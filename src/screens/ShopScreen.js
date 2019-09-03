/**
 * 店铺首页
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  StatusBar,
  ScrollView,
  TouchableOpacity,
  RefreshControl,
  ImageBackground,
  Platform,
} from 'react-native';
import { connect } from 'rn-dva';
import SplashScreen from 'react-native-splash-screen';

import Switch from '../components/Switch';
import * as requestApi from '../config/requestApi';
import * as nativeApi from '../config/nativeApi';
import CommonStyles from '../common/Styles';
import ImageView from '../components/ImageView';
import * as utils from '../config/utils';
import ActionSheet from '../components/Actionsheet';
import * as scanConfig from '../config/scanConfig';
import Content from '../components/ContentItem';
import IconWithRedPoint from '../components/IconWithRedPoint';
import {
  TakeOrPickParams, TakeOrPickCropEnum, TakeTypeEnum, PickTypeEnum,
} from '../const/application';

const { width, height } = Dimensions.get('window');

class ShopScreen extends PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      firstLoad: true, // 是否第一次加载
      joinStatusName: '', // 入驻成功,审核中，审核失败,未入驻商户
    };
  }

  componentWillMount() {
    StatusBar.setBarStyle('light-content');
  }

  componentDidMount() {
    this._onRefresh(false);
    SplashScreen.hide();
  }

  judgeShopStatus = (res) => {
    this.setState({ refreshing: false, firstLoad: false });
    if (!res) return;
    const { shops, userShop } = this.props;
    // 判断商户是否入驻成功
    let joinStatusName = '未入驻商户';
    const shopItem = res.merchant.identityStatuses.find(item => item.merchantType == 'shops');
    if (shopItem && !userShop.id) {
      switch (shopItem.auditStatus) {
        case 'active': joinStatusName = '入驻成功'; userShop.id ? null : joinStatusName = '待开店'; break;
        case 'un_active': joinStatusName = '待开店'; break;
        case 'audit_fail': joinStatusName = '审核失败'; break;
        default: joinStatusName = '审核中'; break;
      }
    }
    this.setState({ joinStatusName, auditStatus: shopItem && shopItem.auditStatus || 'un_audit' });
  }

  _onRefresh = (refreshing) => {
    this.setState({ refreshing });
    const { fetchServiceCatalogList, getMerchantHome } = this.props;
    fetchServiceCatalogList(); // 获取四大分类
    getMerchantHome({
      successCallback: res => this.judgeShopStatus(res),
      failCallback: () => this.setState({ refreshing: false }),
    });
  };


  doggleJiedan = (data) => {
    this.props.updateShopJiedan(data ? 1 : 0);
  };

  // 修改头像
  _uploadPicture = (index) => {
    const { userShop, takeOrPickImageAndVideo, updateShop } = this.props;
    const params = new TakeOrPickParams(index === 0 ? { func: 'take', type: TakeTypeEnum.takeImage } : { func: 'pick', type: PickTypeEnum.pickImage });
    params.setTotalNum(1);
    params.setCrop(TakeOrPickCropEnum.Crop);
    console.log(params);
    takeOrPickImageAndVideo(params.getOptions(), (res) => {
      const formData = {
        ...userShop,
        logo: res[0].url,
        callback: () => Toast.show('修改成功'),
      };
      updateShop(formData);
    });
  };

  // 扫码
  handleScan = () => {
    const { navigation, userShop, userId } = this.props;
    scanConfig.scan(navigation, userId, userShop.id);
  };

  goHaveStore = (roleKey = '', func = () => { }) => { // 去创建店铺
    const { firstLoad } = this.state;
    const { checkAuditStatus } = this.props;
    if (firstLoad) {
      Toast.show('获取商户状态失败');
      this._onRefresh(false);
      return;
    }

    checkAuditStatus(roleKey, func);
  }

  // 先判断是否是主账号，主账号有所有权限，
  checkoutRole = (roleKey, allRoleList) => {
    const isAdmin = global.loginInfo && global.loginInfo.isAdmin || 0;
    const { merchantShopRelations, userShop } = this.props;
    // 获取当前店铺的类型 MASTER, //总店 BRANCH, //分店 SHOP_IN_SHOP; //店中店
    let shopRelationType;
    let isSelfShop = 0;
    merchantShopRelations.map((item) => {
      if (item.shopId === userShop.id && item.name === userShop.name) {
        shopRelationType = item.shopType;
        isSelfShop = item.isSelf;
      }
    });
    // 如果是主店铺，并且是主账号，有所有权限
    if (isAdmin && shopRelationType === 'MASTER' && isSelfShop) {
      return true;
    }
    // 如果不是主店铺，是主账号，则改店铺是绑定的店铺，需要检查权限是否允许操作
    // 如果不是主账号，需要检查权限是否允许操作
    if ((isAdmin && shopRelationType !== 'MASTER') || !isAdmin || !isSelfShop) {
      const isPass = allRoleList.includes(roleKey);
      if (!isPass) {
        Toast.show('没有权限访问！');
      }
      return isPass;
    }
  }

  changeState(key, value) {
    this.setState({
      [key]: value,
    });
  }

  render() {
    const {
      userShop, allRoleList, navPage, changeMessageModules,
    } = this.props;
    const { firstLoad, joinStatusName, auditStatus } = this.state;
    const canShow = !firstLoad && userShop.id;
    return (
      <View style={styles.container}>
        <StatusBar barStyle="light-content" translucent backgroundColor="transparent" />
        {/* //头 */}
        <ScrollView
          showsHorizontalScrollIndicator={false}
          showsVerticalScrollIndicator={false}
          refreshControl={(
            <RefreshControl
              refreshing={this.state.refreshing}
              onRefresh={() => this._onRefresh(true)}
            />
          )}
        >
          <ImageBackground
            style={styles.header}
            source={require('../images/default/background.png')}
            resizeMode="cover"
          >
            <View style={{ flexDirection: 'row' }}>
              <TouchableOpacity
                style={{
                  width: 47, height: 47, borderRadius: 6, overflow: 'hidden',
                }}
                onPress={() => { this.goHaveStore('editShop', () => this.ActionSheet.show()); }}
              >
                <ImageView
                  source={
                    userShop.logo
                      ? { uri: utils.getPreviewImage(userShop.logo, '50p') }
                      : require('../images/default/shop.png')
                  }
                  sourceWidth={47}
                  sourceHeight={47}
                  resizeMode="cover"
                />
              </TouchableOpacity>

              <View style={{
                flex: 1, flexDirection: 'row', justifyContent: 'space-between', alignItems: auditStatus == 'active' ? 'flex-start' : 'center',
              }}
              >
                <View style={{ flex: 1, marginHorizontal: 10 }}>
                  <View>
                    <Text
                      numberOfLines={1}
                      style={[styles.headerText, { fontSize: 17, marginBottom: 0 }]}
                    >
                      {firstLoad ? '' : userShop.name || joinStatusName}
                    </Text>
                  </View>
                  {
                    !canShow ? null
                      : (
                        <View style={[styles.row, { marginTop: 10, width: '100%' }]}>
                          <ImageView
                            source={require('../images/index/address.png')}
                            sourceWidth={8}
                            sourceHeight={10}
                          />
                          <Text
                            style={[styles.headerText, { marginLeft: 4, marginBottom: 0, flex: 1 }]}
                            numberOfLines={1}
                          >
                            {userShop.address || '地址'}
                          </Text>
                        </View>
                      )
                  }
                </View>
                {
                  !canShow ? null
                    : (
                      <TouchableOpacity
                        onPress={() => {
                          navPage(
                            'UserShopLists',
                            {
                              canGoBack: true,
                              chooseShop: true,
                              callback: () => this._onRefresh(false),
                            },
                          );
                        }}
                      >
                        <Text style={{ color: '#fff', fontSize: 14, fontWeight: '600' }}>
                          切换店铺
                        </Text>
                      </TouchableOpacity>
                    )
                }

              </View>
            </View>
          </ImageBackground>
          {/* 正文    / */}
          <View style={styles.content}>
            <View style={[styles.contentItem, { marginTop: -42 }]}>
              <TouchableOpacity
                style={styles.line}
                onPress={() => {
                  this.goHaveStore('editShop', () => navPage('StoreDetail'));
                }}
              >
                <Text style={styles.contentTopText}>
                  店铺信息
                  {' '}
                  <Text style={{ color: '#777' }}>
                    {' '}
                    {userShop.secondAuthStatus == 'SUBMIT' ? '(审核中)' : userShop.firstAuthStatus == 'FAILED'
                      || userShop.secondAuthStatus == 'FAILED' ? '(审核不通过)' : ''}
                  </Text>
                </Text>
                <View style={styles.row}>
                  <Text style={[styles.contentTopText, { color: '#777' }]}>详细信息</Text>
                  <ImageView
                    source={require('../images/index/expand.png')}
                    sourceWidth={14}
                    sourceHeight={14}
                  />
                </View>
              </TouchableOpacity>
              <View style={[styles.line, { borderTopWidth: 1, borderColor: '#F1F1F1' }]}>
                <Text style={styles.contentTopText}>
                  {userShop.isBusiness === 1 ? '接单中' : '暂停接单'}
                </Text>
                {
                  !allRoleList.includes('switch')
                    ? (
                      <TouchableOpacity
                        style={{
                          backgroundColor: 'transparent', paddingHorizontal: 22, position: 'absolute', right: 15, zIndex: 10, height: 30,
                        }}
                        activeOpacity={1}
                        onPress={() => {
                          this.goHaveStore('switch', () => {
                            this.doggleJiedan(userShop.isBusiness ? 0 : 1);
                          });
                        }}
                      >
                        <Text>&nbsp;</Text>
                      </TouchableOpacity>
                    )
                    : null
                }
                <Switch
                  width={36}
                  height={23}
                  value={userShop.isBusiness === 1 ? true : false}
                  disabled={global.loginInfo.isAdmin === 1 ? false : !allRoleList.includes('switch')}
                  // onChangeState={(data) => {
                  //   // 判断权限
                  //   if (!utils.checkoutRole('switch', allRoleList)) {
                  //     Toast.show('您没有当前权限');
                  //     return;
                  //   }
                  //   userShop.id ? this.doggleJiedan(data) : this.goHaveStore();
                  // }
                  // }
                />


              </View>
            </View>
            <View style={[styles.contentItem2, styles.row, { flexWrap: 'wrap' }]}>
              {items.map((data, firstIndex) => (
                <View key={data.title}>
                  <Text style={{
                    fontSize: 12, color: '#999', marginVertical: 15, marginLeft: 15,
                  }}
                  >
                    {data.title}

                  </Text>
                  <Content style={{ flexDirection: 'row', flexWrap: 'wrap', marginTop: 0 }}>
                    {
                      data.items.map((item, index) => (
                        <TouchableOpacity
                          key={item.route}
                          onPress={() => {
                            this.goHaveStore(item.roleKey, () => {
                              if (item.route) {
                                if (item.route === 'scan') {
                                  this.handleScan();
                                } else if (item.route === 'shopServcie') {
                                  nativeApi.changeShopSuccess(userShop.id);
                                  nativeApi.jumpShopService();
                                } else {
                                  navPage(item.route);
                                }
                              } else {
                                Toast.show('开发中');
                              }
                              if (item.modules) {
                                changeMessageModules({ modules: item.modules, flag: false });
                              }
                            });
                          }}
                          style={[styles.contentBottomItem,
                            {
                              borderBottomWidth: index <= 4 ? 1 : 0,
                              // borderBottomWidth: data.items.length - (index + 1) < 4 ? 0 : 1,
                            },
                          ]}
                        >
                          <IconWithRedPoint test={item.modTest} showNumber={item.showNumber}>
                            <ImageView
                              source={item.icon}
                              sourceWidth={20}
                              sourceHeight={20}
                            />
                          </IconWithRedPoint>
                          <Text style={{ color: '#222222', fontSize: 12, marginTop: 15 }}>
                            {' '}
                            {item.title}
                            {' '}
                          </Text>
                        </TouchableOpacity>
                      ))
                    }
                    {/* </View> */}
                  </Content>
                </View>
              ))
              }
            </View>
          </View>
        </ScrollView>
        <ActionSheet
          ref={o => (this.ActionSheet = o)}
          // title={'Which one do you like ?'}
          options={['拍照', '相册', '取消']}
          cancelButtonIndex={2}
          // destructiveButtonIndex={2}
          onPress={(index) => {
            if (index != 2) {
              this._uploadPicture(index);
            }
          }}
        />
      </View>
    );
  }
}
const items = [
  {
    title: '快捷操作',
    items: [
      {
        title: '收款',
        icon: require('../images/shopicon/qrcode.png'),
        route: 'ReceiptQrCodeScreen',
        roleKey: 'receivablesQR',
      },
      {
        title: '扫码',
        icon: require('../images/shopicon/scan.png'),
        route: 'scan',
        roleKey: 'sweepCode',
      }, // 扫码不用跳转页面
      {
        title: '新增订单',
        icon: require('../images/shopicon/add_order.png'),
        route: 'CreateOrder',
        roleKey: 'offlineOrder',
      },
      {
        title: '店铺客服',
        icon: require('../images/shopicon/customerService_inactive.png'),
        route: 'shopServcie',
        roleKey: 'shopService',
        modTest: /^shop.service/gm,
        modules: [],
      },
    ],
  },
  {
    title: '店铺运营',
    items: [
      {
        title: '促销管理',
        icon: require('../images/shopicon/cuxiaoguanli.png'),
        route: 'Sale',
        roleKey: 'promotion',
      },
      {
        title: '品类管理',
        icon: require('../images/shopicon/pinlei_manage.png'),
        route: 'Category',
        roleKey: 'category',
      },
      {
        title: '订单管理',
        icon: require('../images/shopicon/order_manage.png'),
        route: 'OrderListScreen',
        roleKey: 'order',
        modTest: /^shops.ordermanage.orderId/gm,
        modules: ['shops.ordermanage.orderId'],
        showNumber: true,
        // route:"LogisticsOrder"
      },
      {
        title: '店铺管理',
        icon: require('../images/shopicon/shop_manage.png'),
        route: 'StoreManage',
        roleKey: 'shopManager',
      },
      // {
      //   title: '运费设置',
      //   icon: require('../images/shopicon/yunfei.png'),
      //   route: 'FreightManag',
      //   roleKey: 'freight',
      // },
      {
        title: '商品管理',
        icon: require('../images/shopicon/goods_manage.png'),
        route: 'Goods',
        roleKey: 'commodity',
      },
      {
        title: '评价管理',
        icon: require('../images/shopicon/comment_manage.png'),
        route: 'Comment',
        roleKey: 'evaluate',
        modTest: /^shops.commentmanage/gm,
        modules: ['shops.commentmanage'],
      },
      {
        title: '席位管理',
        icon: require('../images/shopicon/seat_manage.png'),
        route: 'Seat',
        roleKey: 'seat',
      },
    ],
  },
  {
    title: '其他',
    items: [
      {
        title: '授权管理',
        icon: require('../images/shopicon/shouquan_manage.png'),
        route: 'Authorization',
        roleKey: 'gave',
      },
      {
        title: '财务中心',
        icon: require('../images/shopicon/chaiwuzhongxin.png'),
        route: 'FinancialCenter',
        roleKey: 'shopFinance',
      },
      {
        title: '数据中心',
        icon: require('../images/shopicon/datas.png'),
        route: 'DataCenter',
        roleKey: 'statistics',
      },
    ],
  },
  // { title: '发票申请', icon: require('../images/index/fapiao.png'), route: '' },

];

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    flexDirection: 'column',
  },
  header: {
    justifyContent: 'flex-end',
    height: 158 + CommonStyles.headerPadding,
    paddingHorizontal: 25,
    overflow: 'hidden',
    paddingBottom: 62,

  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  headerText: {
    color: '#fff',
    fontSize: 12,
    marginBottom: 6,
  },
  content: {
    alignItems: 'center',
    paddingBottom: 10,
  },
  contentItem: {
    // ...CommonStyles.shadowStyle,
    backgroundColor: '#fff',
    borderRadius: 10,
    width: width - 20,
    marginTop: 10,
    height: 84,
  },
  contentItem2: {
    // ...CommonStyles.shadowStyle,
    borderRadius: 10,
    width: width - 20,
  },
  line: {
    flexDirection: 'row',
    alignItems: 'center',
    height: 42,
    paddingHorizontal: 15,
    justifyContent: 'space-between',
  },
  contentTopText: {
    fontSize: 14,
    color: '#222222',
  },
  contentBottomItem: {
    width: (width - 20) / 4,
    height: (width - 22) / 4,
    alignItems: 'center',
    justifyContent: 'center',
    borderColor: '#F1F1F1',
  },

  modalOutView: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  modalInnerTopView: {
    flex: 1,
    width,
    backgroundColor: 'rgba(0, 0, 0, .5)',
  },
  modalInnerBottomView: {
    width,
    height: 156 + CommonStyles.footerPadding,
    backgroundColor: '#fff',
  },
  userImgLists_item: {
    justifyContent: 'center',
    alignItems: 'center',
    width,
    height: 50,
  },
  userImgLists_item1: {
    borderTopWidth: 1,
    borderTopColor: '#E5E5E5',
  },
  userImgLists_item2: {
    borderTopWidth: 5,
    borderTopColor: '#E5E5E5',
  },
  userImgLists_item_text: {
    fontSize: 16,
    color: '#000',
  },
});

export default connect(
  state => ({
    userShop: state.user.userShop || {},
    shops: (state.user.merchantData || {}).shops || [],
    userRoleList: state.user.userRoleList || [],
    userId: (state.user.user || {}).id,
    merchantShopRelations: (state.user.merchantData || {}).merchantShopRelations || [],
    allRoleList: state.user.allRoleList || [],
    user: state.user.user || {},

  }), {
    resetPage: routeName => ({ type: 'system/resetPage', payload: { routeName } }),
    navPage: (routeName, params = {}) => ({ type: 'system/navPage', payload: { routeName, params } }),
    fetchServiceCatalogList: () => ({ type: 'shop/serviceCatalogList' }),
    getMerchantHome: (payload = {}) => ({ type: 'user/getMerchantHome', payload }),
    shopSave: (payload = {}) => ({ type: 'shop/save', payload }),
    userSave: (payload = {}) => ({ type: 'user/save', payload }),
    updateShop: (payload = {}) => ({ type: 'shop/updateShop', payload }),
    updateUser: (payload = {}) => ({ type: 'user/updateUser', payload }),
    updateShopJiedan: isBusiness => ({ type: 'shop/updateShopJiedan', payload: { isBusiness } }),
    changeMessageModules: (payload = {}) => ({ type: 'application/changeMessageModules', payload }),
    takeOrPickImageAndVideo: (options, callback) => ({ type: 'application/takeOrPickImageAndVideo', payload: { options, callback } }),
    checkAuditStatus: (roleKey, callback) => ({ type: 'shop/check', payload: { roleKey, callback } }),
  },
)(ShopScreen);
