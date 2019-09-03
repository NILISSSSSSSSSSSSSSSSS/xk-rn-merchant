/**
 * 我的页面
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  ScrollView,
  Text,
  StatusBar,
  Platform,
  ImageBackground,
  TouchableOpacity,
  Image,
  RefreshControl,
} from 'react-native';

import { connect } from 'rn-dva';
import SplashScreen from 'react-native-splash-screen';
import List, { ListItem, Splitter } from '../components/List';
import config from '../config/config';
import ActionSheet from '../components/Actionsheet';
import CommonStyles from '../common/Styles';
import * as requestApi from '../config/requestApi';
import * as nativeApi from '../config/nativeApi';
import IconWithRedPoint from '../components/IconWithRedPoint';
import { getPreviewImage } from '../config/utils';
import { NavigationComponent } from '../common/NavigationComponent';
import SecurityCode from './my/components/SecurityCode';
import Environment from '../components/Environment';
import {
  TakeOrPickParams, TakeOrPickFunction, TakeOrPickCropEnum, TakeTypeEnum, PickTypeEnum,
} from '../const/application';
import MerchantListCard from './my/components/MerchantListCard';
import { JOIN_AUDIT_STATUS } from '../const/user';
import NotAccessModal from './login/components/NotAccessModal';

const { width, height } = Dimensions.get('window');

function getwidth(val) {
  return (width * val) / 375;
}

const items = [
  {
    type: 'item', icon: require('../images/my/icon-merchantsmessage.png'), title: '联盟商信息', path: 'MerchantsMessage',
  },
  {
    type: 'card',
  },
  {
    type: 'item', icon: require('../images/my/icon-profile.png'), title: '个人资料', path: 'Profile', params: {}, auditStatus: 'active',
  },
  {
    type: 'item', icon: require('../images/my/icon-taskhome.png'), title: '任务中心', path: 'TaskHome', params: { page: 'My', title: '任务中心' }, modTest: /^user\.taskcore/gm, modules: ['user.taskcore'],
  },
  {
    type: 'item', icon: require('../images/my/icon-systemmessage.png'), title: '系统通知', path: 'SystemMessage', modTest: /^user\.system/gm,
  },
  {
    type: 'item', icon: require('../images/my/icon-feedback.png'), title: '意见反馈', path: 'PersonalFeedback', params: {},
  },
  {
    type: 'item', icon: require('../images/my/icon-invitecode.png'), title: '推广二维码', path: 'CampaignCode', auditStatus: 'active',
  },
  Platform.OS === 'ios' ? null : {
    type: 'item', icon: require('../images/my/icon-systemmessage.png'), title: '通知管理', path: 'noticeManage',
  }, // 安卓加入通知管理
  {
    type: 'item', icon: require('../images/my/icon-settings.png'), title: '设置', path: 'Setting', params: {},
  },
];

class MyScreen extends NavigationComponent {
    state = {
      avatarUrl: null,
      confimVis: false,
      visible: false,
    };

    blurState = {
      confimVis: false,
      visible: false,
    }

    componentWillMount() {
      StatusBar.setBarStyle('light-content');
    }

    componentDidMount() {
      this._onRefresh(false);
      SplashScreen.hide();
    }


    changeState(key, value) {
      this.setState({
        [key]: value,
      });
    }

    _uploadPicture = (index) => {
      const { takeOrPickImageAndVideo, updateProfile } = this.props;
      const params = new TakeOrPickParams({
        func: index === 0 ? 'take' : 'pick',
        type: index === 0 ? TakeTypeEnum.takeImage : PickTypeEnum.pickImage,
        crop: TakeOrPickCropEnum.Crop,
        totalNum: 1,
      });

      takeOrPickImageAndVideo(params.getOptions(), (res) => {
        const avatar = res[0].url;
        updateProfile('avatar', avatar, (isSuccess) => {
          if (isSuccess) {
            Toast.show('修改成功');
          } else {
            Toast.show('修改失败');
          }
        });
      });
    };


    componentWillUnmount() {
      super.componentWillUnmount();
      this.timer && clearTimeout(this.timer);
    }

    _onRefresh = () => {
      const { getMerchantHome } = this.props;
      getMerchantHome();
    };

    // 审核中
    renderUnJudgeAndFaild = witch => (
      <ImageBackground
            source={require('../images/my/bg.png')}
            style={styles.imageBackground2}
            resizeMode="cover"
      >
        <View style={{ height: getwidth(68), overflow: 'visible' }}>
          <ImageBackground
            source={require('../images/shop/mobi-homepage.png')}
            style={{ width: getwidth(355), height: getwidth(137), marginHorizontal: getwidth(10) }}
            resizeMode="contain"
          >
            {
              witch === 2
                ? (
                  <TouchableOpacity style={{ position: 'absolute', top: 66, right: 34 }} onPress={() => this.props.navigation.navigate('StoreEditor')}>
                    <Text style={{ color: CommonStyles.globalHeaderColor, fontSize: 22 }}>去开店</Text>
                  </TouchableOpacity>
                )
                : (
                  <View style={{ position: 'absolute', top: 66, right: 34 }}>
                    <Text style={{ fontSize: 22, color: '#FF7E00' }}>{witch == 1 ? '审核中' : '审核不通过'}</Text>
                  </View>
                )
            }
            <View style={{ position: 'absolute', bottom: 16, right: 26 }}>
              <Text style={{ fontSize: 14, color: '#999999' }}>请耐心等待系统审核通过</Text>
            </View>
          </ImageBackground>
        </View>
      </ImageBackground>
    )

    renderPassed = () => {
      const {
        navigation, userInfo, merchantData,
      } = this.props;
      const { merchant = {} } = merchantData || {};
      const userImg = !userInfo.avatar ? require('../images/default/user.png') : { uri: getPreviewImage(userInfo.avatar) };
      const userName = userInfo.isAdmin === 1 ? merchant.name : userInfo.realName || userInfo.nickName;

      return (
        <ImageBackground
          source={require('../images/my/bg.png')}
          resizeMode="cover"
          style={styles.imageBackground2}
        >
          <View style={styles.headerCard}>
            <ImageBackground
              source={require('../images/my/card-bg.png')}
              resizeMode="cover"
              style={styles.avatarCard}
            >
              <List style={styles.cardContent}>
                <ListItem
                  icon={userImg}
                  iconStyle={{ width: getwidth(50), height: getwidth(50), borderRadius: getwidth(25) }}
                  onIconPress={() => this.ActionSheet.show()}
                  style={styles.cardItem}
                  titleContainerStyle={{ height: 41, justifyContent: 'space-between' }}
                  titleStyle={{
                    color: '#27344C', fontSize: 17, fontWeight: 'bold',
                  }}
                  subtitleStyle={{
                    color: '#27344C', fontSize: 13, opacity: 0.5, overflow: 'visible', marginTop: 9,
                  }}
                  title={userName}
                  subtitle={userInfo.phone}
                  extra={(
                    <View style={{
                      height: getwidth(87), flexDirection: 'column', justifyContent: 'center', alignItems: 'flex-end', overflow: 'visible',
                    }}
                    >
                      <View style={{ flex: 1 }} />
                      <View style={{ flex: 1, justifyContent: 'center' }}>
                        <SecurityCode
                          style={{ position: 'relative', right: -5 }}
                          securityCode={userInfo.securityCode}
                          onPress={() => {
                            navigation.navigate('InviteCode', {
                              _name: userName,
                              _code: userInfo.securityCode,
                            });
                          }}
                        />
                      </View>
                    </View>
                  )}
                />
              </List>
            </ImageBackground>
          </View>
        </ImageBackground>
      );
    }

    handleListItemPress = (item) => {
      const {
        changeMessageModules, navigation, userInfo: user, navPage, firstMerchant,
      } = this.props;
      if (item.path === 'MerchantsMessage' && user.isAdmin === 0) {
        Toast.show('没有权限访问');
        return;
      }
      if (item.path === 'Exit') {
        this.changeState('confimVis', true);
        return;
      }
      if (
        ['AccountActive', 'MyApplyForm'].includes(item.path)
        && NotAccessModal.canShow(user, firstMerchant, item.params.merchantType)
      ) {
        this.changeState('visible', true);
        return;
      }

      switch (item.path) {
        case 'noticeManage':
          nativeApi.jumpToAppNotificationSetting();
          break;
        case 'AccountActive':
          navPage(item.path, item.params);
          break;
        default:
          navigation.navigate(
            item.path,
            item.params,
          );
          item.modules && changeMessageModules(item.modules, false);
          break;
      }
    }
    renderTop=() => {
      const { auditStatus } = this.props.userInfo || {};
      const judge = JOIN_AUDIT_STATUS.fail === auditStatus ? 0 : 1;
      const isAduitSuccess = [JOIN_AUDIT_STATUS.active, JOIN_AUDIT_STATUS.un_active].includes(auditStatus);
      const renderTop = isAduitSuccess ? this.renderPassed : this.renderUnJudgeAndFaild;
      return renderTop(judge);
    }

    render() {
      const {
        refreshing, userInfo: user, merchantData, merchant, firstMerchant,
      } = this.props;
      const { visible } = this.state;
      const identityStatuses = (merchantData.merchant && merchantData.merchant.identityStatuses) || [];
      const isAuditSuccess = [JOIN_AUDIT_STATUS.active, JOIN_AUDIT_STATUS.un_active].includes(user.auditStatus);
      const itemsNew = items.filter(item => !!item).filter(item => (user.auditStatus !== 'active' && item.auditStatus !== 'active') || user.auditStatus === 'active');
      return (
        <View style={styles.container}>
          <StatusBar barStyle="light-content" />
          <ScrollView
            showsHorizontalScrollIndicator={false}
            showsVerticalScrollIndicator={false}
            refreshControl={(
              <RefreshControl
                refreshing={refreshing}
                onRefresh={this._onRefresh}
              />
            )}
          >
            {/* 头部 */}
            {this.renderTop()}
            {/** 列表 */}
            <List style={{ marginHorizontal: getwidth(15), marginTop: isAuditSuccess ? 0 : getwidth(30) }}>
              {
                itemsNew.map((item, index) => {
                  switch (item.type) {
                    case 'splitter':
                      return <Splitter style={styles.splitter} key="splitter" />;
                    case 'card': {
                      const merchantTypes = (merchant || []).map((merch) => {
                        const identityStatus = identityStatuses.find(idS => merch.merchantType === idS.merchantType);
                        return {
                          type: merch.merchantType,
                          title: merch.name,
                          status: identityStatus ? (identityStatus.auditStatus) : null,
                          familyUp: identityStatus ? (identityStatus.familyUp) : 0,
                          updateAuditStatus: identityStatus ? (identityStatus.updateAuditStatus) : null,
                        };
                      });
                      return <MerchantListCard merchantTypes={merchantTypes} onPress={_item => this.handleListItemPress(_item)} />;
                    }
                    default:
                      return (
                        <ListItem
                        key={item.title}
                        arrow
                        arrowStyle={{ tintColor: '#ccc' }}
                        icon={item.icon}
                        iconStyle={{ width: getwidth(18), height: getwidth(18) }}
                        title={(
                          <IconWithRedPoint test={item.modTest}>
                            <Text style={styles.itemView_text}>
                              {item.title}
                            </Text>
                          </IconWithRedPoint>
                        )}
                        titleContainerStyle={{ height: getwidth(18) }}
                        style={styles.listitem}
                        onPress={() => this.handleListItemPress(item)}
                        />
                      );
                  }
                })
              }
            </List>
            <View style={styles.bomView} />
            <ActionSheet
              ref={o => this.ActionSheet = o}
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
          </ScrollView>
          <Environment />
          <NotAccessModal visible={visible} firstMerchant={firstMerchant} onClose={() => this.setState({ visible: false })} />
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    backgroundColor: '#fff',
  },
  headerCard: {
    height: getwidth(128) / 2,
    width,
    overflow: 'visible',
  },
  avatarCard: {
    height: getwidth(128),
    width,
    paddingHorizontal: getwidth(15),
  },
  cardContent: {
    paddingLeft: getwidth(15),
    paddingTop: getwidth(17),
  },
  cardItem: {
    paddingRight: 0,
    height: getwidth(87),
  },
  imageBackground2: {
    height: getwidth(126),
    justifyContent: 'flex-end',
    marginBottom: getwidth(64),
  },
  switchAcount: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    alignItems: 'center',
    height: getwidth(44),
    width,
    paddingRight: getwidth(15),
  },
  switchAcountText: {
    fontSize: getwidth(17),
    color: '#fff',
  },
  infoView: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginTop: getwidth(10),
  },
  infoView_left: {
    flexDirection: 'row',
    flex: 1,
  },
  infoView_left_img: {
    width: getwidth(50),
    height: getwidth(50),
    borderRadius: 8,
    marginRight: getwidth(6),
    // overflow: 'hidden'
  },
  infoView_left_text1: {
    fontSize: getwidth(17),
    color: '#fff',
  },
  infoView_left_text2: {
    fontSize: getwidth(12),
    color: '#F2F2F2',
    marginTop: getwidth(8),
  },
  infoView_right: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: getwidth(5),
  },
  infoView_right_text1: {
    fontSize: getwidth(12),
    color: '#F2F2F2',
  },
  infoView_right_img: {
    width: getwidth(16),
    height: getwidth(16),
    marginLeft: getwidth(10),
    marginRight: -getwidth(2),
  },
  itemView: {
    // ...CommonStyles.shadowStyle,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    width: width - 20,
    marginHorizontal: 10,
    borderRadius: 6,
    backgroundColor: '#fff',
    // overflow: "hidden"
  },
  itemView_text: {
    fontSize: 15,
    color: '#27344C',
  },
  itemView2: {
    flexDirection: 'column',
  },
  itemItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    width: '100%',
    height: 50,
    paddingHorizontal: 15,
    borderBottomWidth: 1,
    borderBottomColor: '#F1F1F1',
  },
  itemItem1: {
    borderBottomWidth: 0,
  },
  bomView: {
    marginBottom: 20 + CommonStyles.footerPadding,
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
  listitem: {
    height: getwidth(46),
    marginHorizontal: getwidth(10),
    paddingHorizontal: 0,
  },
  splitter: {
    marginVertical: getwidth(15),
  },
});

export default connect(
  state => ({
    userInfo: state.user.user || {},
    shop: state.shop || {},
    profile: state.my.profile || {},
    merchant: state.user.merchant || [],
    merchantData: state.user.merchantData || {},
    firstMerchant: state.user.firstMerchant || {},
    refreshing: state.loading.effects['user/getMerchantHome'] || false,
  }), {
    changeMessageModules: (modules, flag) => ({ type: 'application/changeMessageModules', payload: { modules, flag } }),
    getMerchantHome: (successCallback, failCallback) => ({ type: 'user/getMerchantHome', payload: { successCallback, failCallback } }),
    takeOrPickImageAndVideo: (options, callback) => ({ type: 'application/takeOrPickImageAndVideo', payload: { options, callback } }),
    updateProfile: (field, value, callback) => ({ type: 'my/updateProfile', payload: { field, value, callback } }),
    // fetchProfile: mUserId => ({ type: 'my/fetchProfile', payload: { mUserId } }),
    navPage: (routeName, params) => ({ type: 'userActive/navPage', payload: { routeName, params } }),
  },
)(MyScreen);
