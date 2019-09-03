/**
 * 已中奖详情
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Button,
  Image,
  ScrollView,
  ImageBackground,
  TouchableOpacity,
  Modal,
} from 'react-native';
import { connect } from 'rn-dva';
import moment from 'moment';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import WMGoodsWrap from '../../components/WMGoodsWrap';
import * as nativeApi from '../../config/nativeApi';
import * as requestApi from '../../config/requestApi';
import WMOrderInfoWrap from '../../components/WMOrderInfoWrap';
import WMOrderLogisticsInfo from '../../components/WMOrderLogisticsInfo';
import WMOrderLotterInfo from '../../components/WMOrderLotterInfo';
import { showSaleNumText } from '../../config/utils'

import { NavigationComponent } from '../../common/NavigationComponent';
import math from '../../config/math';
import config from '../../config/config';

const topShareStatusIcon = require('../../images/wm/orderShare_icon.png');
const topResaveStatusIcon = require('../../images/wm/orderResava_icon.png');
const topSendStatusIcon = require('../../images/wm/orderSend_icon.png');
const topRecevingStatusIcon = require('../../images/wm/orderReceving_icon.png');

const configShareUrl = config.baseUrl_share_h5;

const { width, height } = Dimensions.get('window');

class WMExpenseWinLotteryScreen extends NavigationComponent {
  static navigationOptions = {
    header: null,
  };

  constructor(props) {
    super(props);
    this.state = {
      shareVisible: false, // 分享弹窗
      shareInfoVisible: false,
      isNotice: false, // 是否提醒发货
    };
  }


  blurState = {
    shareModal: false, // 分享弹窗
    shareTemModal: false, // 分享模板
  }

  screenDidFocus = (payload) => {
    super.screenDidFocus(payload);
    this.getData();
  }

  componentDidMount() {
    // requireApi.storageWMOrderShare('load', {isShare: false})
    Loading.show();
  }

  componentWillUnmount() {
    super.componentWillUnmount();
    Loading.hide();
  }

  getData = () => {
    const { navigation, dispatch } = this.props;
    const orderId = navigation.getParam('orderId', '');
    const params = {
      orderId,
    };
    dispatch({ type: 'welfare/qureyWMOrderDetail', payload: { params } });
  };

  getCrashNumItem = (label = '', value = '', index) => (
    <View key={index} style={[styles.flexStart, styles.flex_1, styles.crashLabelWrap]}>
      <Text style={styles.crashLabel}>{label}</Text>
      <Text style={[styles.crashLabel, styles.itemValueStyle]}>{value}</Text>
    </View>
  )
  // 确认收货
  jOrderDoReceving = () => {
    const { orderData } = this.props;
    const params = {
      orderId: orderData.orderId,
    };
    requestApi.jOrderDoReceving(params).then((res) => {
      console.log('jOrderDoReceving', res);
      //dispatch({ type: 'welfare/refreshOrderListItem',  payload: { nextStatus: 'DELIVERY' } })
      this.props.navigation.navigate('WMGoodsDamagSuccessful', { title: '确认收货成功', resultType: 1, orderId: orderData.orderId });

    }).catch((err) => {
      console.log(err);
    });
  }

  getBottomBtnItem = () => {
    const { orderData, navigation, dispatch } = this.props;
    const { isNotice } = this.state
    let disBtn = true;
    if (orderData.refundRecordAudit === 'DELIVERED' || orderData.refundRecordAudit === null || orderData.refundRecordAudit === 'UNAPPROVED') {
      disBtn = false;
    }
    switch (orderData.state) {
      case 'NOT_DELIVERY': return (
        <TouchableOpacity
          style={[styles.btnWrap, styles.redBtnBorder, { width: 82, marginLeft: 10, marginRight: 10 }]}
          onPress={() => {
            if (isNotice) {
              Toast.show('已成功提醒发货！');
              return
            }
            Loading.show()
            requestApi.jOrderReminderShipment({ orderId: orderData.orderId }).then(() => {
              this.setState({
                isNotice: true
              })
              Toast.show('已成功提醒发货！');
              Loading.hide()
            }).catch((err)=>{
              console.log(err)
            });
          }}
          activeOpacity={0.65}
        >
          <Text style={[styles.btnText, styles.redColor]}>提醒发货</Text>
        </TouchableOpacity>
      );
      case 'DELIVERY': return (
        <TouchableOpacity
          style={[styles.btnWrap, styles.redBtnBorder, { width: 82, marginLeft: 10, marginRight: 10 }]}
          onPress={() => {
            if (disBtn) {
              Toast.show('已申请货物报损，暂不能确认收货');
              return;
            }
            this.jOrderDoReceving();
          }}
          activeOpacity={0.65}
        >
          <Text style={[styles.btnText, styles.redColor]}>确认收货</Text>
        </TouchableOpacity>
      );
      case 'NOT_SHARE': return (
        <TouchableOpacity
          style={[styles.btnWrap, styles.redBtnBorder, { width: 82, marginLeft: 10, marginRight: 10 }]}
          onPress={() => { this.handleChangeState('shareInfoVisible', true); }}
          activeOpacity={0.65}
        >
          <Text style={[styles.btnText, styles.redColor]}>分享即领取</Text>
        </TouchableOpacity>
      );
      case 'WAIT_FOR_RECEVING': return (
        <TouchableOpacity
          style={[styles.btnWrap, styles.redBtnBorder, { width: 82, marginLeft: 10, marginRight: 10 }]}
          onPress={() => { this.getLotteryGoods(); }}
          activeOpacity={0.65}
        >
          <Text style={[styles.btnText, styles.redColor]}>立即领取</Text>
        </TouchableOpacity>
      );
      default: return null;
    }
  }

  handleChangeState = (key = '', value = '', callback = () => { }) => {
    this.setState(
      {
        [key]: value,
      },
      () => {
        callback();
      },
    );
  };

  // 匹配物流信息
  getLogisticsInfo = () => {
    const { orderData } = this.props;
    const { logisticsName } = orderData;
    switch (logisticsName) {
      case 'XK': return '晓可自营物流';
      case 'SF': return '顺丰';
      case 'YD': return '韵达';
      case 'ZT': return '中通';
      case 'ST': return '申通';
      case 'YT': return '圆通';
      case 'BSHT': return '百世汇通';
      case 'HIMSELF': return '用户自行配送';
      default: return '';
    }
  }

  // 领取
  getLotteryGoods = () => {
    const { orderData, navigation } = this.props;
    navigation.navigate('WMGetLotterGoods', {
      data: [{
        mainPic: orderData.mainUrl,
        name: orderData.goodsName,
        attr: orderData.showSkuName || '无',
      }],
      jOrderLotteryVO: orderData,
      listItemData: orderData,
      routerIn: navigation.getParam('routerIn', 'WMOrderList'),
    });
  }

  // 货物报损
  hanldeApplyDramg = () => {
    const { orderData, navigation } = this.props;
    // 如果报损次数大于2，不操作
    if (orderData.refundCount >= 2 && orderData.refundRecordAudit === 'UNAPPROVED') {
      Toast.show('超出报损次数限制');
      return;
    }
    // 如果为null，未提交过记录，则去提交
    if (orderData.refundRecordAudit === null || orderData.refundRecordAudit === 'UNAPPROVED') {
      navigation.navigate('WMGoodsDamag', { orderData, callback: this.getData }); // 跳转提交界面
    }
    // 如果提交了审核，并且通过了。并且填写了物流信息就跳转结果页
    if (orderData.refundRecordAudit === 'WAIT' || orderData.refundRecordAudit === 'RECEVIED' || orderData.refundRecordAudit === 'DELIVERED') {
      navigation.navigate('WMGoodsDamagResult', { orderData });
    }
    // 不通过，待审核，通过审核，跳转详情
    if (orderData.refundRecordAudit === 'VERIFIED' || orderData.refundRecordAudit === 'UNAUDITED') {
      navigation.navigate('WMGoodsDamagDetailNo', { orderData, callback: this.getData });
    }
  }

  // 跳转到客服
  gotoCunstom = () => {
    nativeApi.createXKCustomerSerChat();
  }

  // 确认分享 回调函数
  jOrderDoShare = (successCallBack = () => { }) => {
    const { orderData, navigation } = this.props;
    const param = {
      orderId: orderData.orderId,
    };
    requestApi.platOrderDoShare(param).then((res) => {
      console.log(res);
      Toast.show('分享成功!');
      let routeName = navigation.getParam('routerIn', 'WMWMOrderList')
      orderData.goodsType === 'virtual'
        ? navigation.navigate(routeName) // 虚拟分享后，回到原来的列表
        : successCallBack();
    }).catch((err) => {
      console.log(err);
    });
  }
  // 分享
  handleWxShare(type) {
    const { orderData, navigation } = this.props;
    const url = `${configShareUrl}welfareGoodsShow?id=${orderData.termNumber}`;
    const title = orderData.goodsName;
    const info = `规格：${orderData.showSkuName || '无'}  消费券：${math.divide(orderData.price || 0, 100)}`;
    const iconUrl = orderData.mainUrl || orderData.goodsUrl;
    nativeApi.nativeShare(type, url, title, info, iconUrl).then((res) => {
      console.log('分享返回结果', res);
      Loading.hide();
      this.handleChangeState('shareVisible', false);
      this.jOrderDoShare(this.getData);
    }).catch((e) => {
      this.handleChangeState('shareVisible', false);
      Toast.show('分享失败，请重试！');
      Loading.hide();
    });
  }

  render() {
    const { navigation, orderData } = this.props;
    const {
      shareVisible, shareInfoVisible,
    } = this.state;
    const topStatusTitle = orderData.state === 'NOT_DELIVERY'
      ? '等待平台发货'
      : orderData.state === 'DELIVERY'
        ? '等待用户收货'
        : orderData.state === 'WAIT_FOR_RECEVING'
          ? '等待用户领取'
          : '等待用户分享';
    const topStatusImg = orderData.state === 'NOT_DELIVERY'
      ? topSendStatusIcon
      : orderData.state === 'DELIVERY'
        ? topResaveStatusIcon
        : orderData.state === 'WAIT_FOR_RECEVING'
          ? topRecevingStatusIcon
          : topShareStatusIcon;
    const time = moment(orderData.expectDrawTime).format('MM-DD HH:mm');
    const value = math.multiply(math.divide(orderData.joinCount, orderData.maxStake), 100);
    // eslint-disable-next-line radix
    const processValue = (value < 1 && value !== 0) ? '1' : parseInt(value);
    const processPercent = `${processValue}%`;
    let fixedNumber = orderData.maxStake > 100000 ? 0 : 1;
    const showText = `${showSaleNumText(orderData.joinCount, fixedNumber)}/${showSaleNumText(orderData.maxStake, fixedNumber)}`
    const showAddress = orderData.goodsType === 'substance' && (orderData.state === 'NOT_DELIVERY' || orderData.state === 'DELIVERY');
    return (
      <View style={styles.container}>
        <Header
          navigation={navigation}
          goBack
          title="订单详情"
        />
        <ScrollView
          style={{ marginBottom: CommonStyles.footerPadding }}
          // contentContainerStyle={{paddingBottom: CommonStyles.footerPadding}}
          showsHorizontalScrollIndicator={false}
          showsVerticalScrollIndicator={false}
        >
          <ImageBackground source={require('../../images/wm/winLotterBg.png')} style={styles.topStatus} imageStyle={styles.imageStyle}>
            <View style={[CommonStyles.flex_between, { paddingRight: 40, paddingLeft: 45 }]}>
              <Text style={styles.topStatusText}>{topStatusTitle}</Text>
              <Image source={topStatusImg} />
            </View>
          </ImageBackground>
          {
            // 如果是虚拟物品，不显示地址, 如果是实物，显示领取后显示领取地址
            showAddress
              ? (
                <View style={[styles.addressView, styles.borderRadius, styles.border]}>
                  <View style={[CommonStyles.flex_start]}>
                    <Image source={require('../../images/wm/localtion_icon.png')} />
                    <Text style={[styles.userInfoText, { marginLeft: 5, marginRight: 15 }]}>{orderData.userName}</Text>
                    <Text style={styles.userInfoText}>{orderData.userPhone}</Text>
                  </View>
                  <Text style={styles.addressInfoText} numberOfLines={2}>{orderData.userAddress}</Text>
                </View>
              )
              : null
          }
          <View style={[styles.goodsItemWrap, showAddress ? null : { position: 'relative', top: -15, left: 0 }]}>
            <View style={[styles.flexStart, styles.goodsBorder]}>
              <WMGoodsWrap
                imgHeight={80}
                imgWidth={80}
                imgUrl={orderData.mainUrl}
                title={orderData.goodsName}
                goodsTitleStyle={{ fontSize: 12, color: '#222' }}
                xfnumber={orderData.price}
                showProcess={false}
                showPrice={false}
                type={orderData.drawType}
                processValue={processValue}
                label="开奖进度："
                timeLabel="开奖时间："
                timeValue={time}
                showText={showText}
                labelStyle={styles.labelStyle}
              >
                {
                  orderData.showSkuName
                    ? <View style={[CommonStyles.flex_start_noCenter, { marginTop: 10 }]}>
                      <Text style={styles.goodsInfoText}>规格参数：</Text>
                      <Text style={[styles.goodsInfoText, CommonStyles.flex_1]}>{`${orderData.showSkuName || '无'} x ${orderData.myStake || 1}`}</Text>
                    </View>
                    : null
                }
              </WMGoodsWrap>
            </View>
          </View>

          <View style={{ marginTop: showAddress ? 0 : -15 }}>
            <WMOrderInfoWrap orderData={orderData} />
          </View>
          {/* 三方开奖信息 */}
          <WMOrderLotterInfo orderData={orderData} navigation={navigation} wrapStyle={(orderData.state !== 'DELIVERY') ? styles.marginBottom : null} />
          {/* 物流信息 */}
          {
            // 待用户收货显示物流
            (orderData.state === 'DELIVERY')
              ? (
                <WMOrderLogisticsInfo orderData={orderData} />
              )
              : null
          }
        </ScrollView>
        <View style={styles.bottomBar}>
          <TouchableOpacity style={[styles.btnWrap, { borderColor: '#e5e5e5' }]} onPress={() => { this.gotoCunstom(); }} activeOpacity={0.65}>
            <Text style={[styles.btnText, { color: '#555' }]}>联系客服</Text>
          </TouchableOpacity>
          {
            // 根据当前商品状态获取底部操作栏按钮
            this.getBottomBtnItem()
          }
        </View>
        <Modal
          animationType="fade"
          transparent
          visible={shareInfoVisible}
          onRequestClose={() => { this.handleChangeState('shareInfoVisible', false); }}
          onShow={() => { }}
        >

          <View style={[CommonStyles.flex_1, styles.modalView]}>
            <View style={[CommonStyles.flex_end, styles.closeBtnWrap]}>
              <TouchableOpacity
                activeOpacity={0.65}
                onPress={() => { this.handleChangeState('shareInfoVisible', false); }}
                style={styles.imgWrap}
              >
                <Image source={require('../../images/wm/shareCloseBtn.png')} style={styles.shareImg} />
              </TouchableOpacity>
            </View>
            <View style={[styles.shareInfoContent]}>
              <Text style={styles.titleText}>提示</Text>
              <View style={[CommonStyles.flex_center, { paddingVertical: 18 }]}>
                <Image
                  defaultSource={require('../../images/skeleton/skeleton_img.png')}
                  source={{ uri: orderData.mainUrl }}
                  style={styles.goodsImg}
                />
              </View>
              <Text style={styles.modalInfo}>恭喜您中奖了，分享后即可领取奖品！</Text>
              <TouchableOpacity
                style={[CommonStyles.flex_start, CommonStyles.flex_center, styles.modalBtn]}
                onPress={() => {
                  this.setState({
                    shareVisible: true,
                    shareInfoVisible: false,
                  });
                }}
              >
                <Image source={require('../../images/wm/wmshare_icon.png')} />
                <Text style={styles.modalBtnText}>立即分享</Text>
              </TouchableOpacity>
            </View>
          </View>
        </Modal>
        <Modal
          visible={shareVisible}
          onRequestClose={() => { this.handleChangeState('shareVisible', false); }}
          animationType="fade"
          transparent
        >
          <View style={[CommonStyles.flex_1, { backgroundColor: 'rgba(0,0,0,.5)' }]}>
            <View style={[styles.shareContent]}>
              <View style={[CommonStyles.flex_start]}>
                <TouchableOpacity style={[CommonStyles.flex_center, styles.modalItemStyle]} onPress={() => { this.handleWxShare('WX_P'); }}>
                  <Image source={require('../../images/wm/friendsquan.png')} />
                  <Text style={{ fontSize: 10, color: '#777', marginTop: 7 }}>朋友圈</Text>
                </TouchableOpacity>
                <TouchableOpacity style={[CommonStyles.flex_center, styles.modalItemStyle]} onPress={() => { this.handleWxShare('WX'); }}>
                  <Image source={require('../../images/wm/weixin.png')} />
                  <Text style={{ fontSize: 10, color: '#777', marginTop: 7 }}>微信群</Text>
                </TouchableOpacity>
              </View>
              <TouchableOpacity
                style={{ borderTopColor: '#f1f1f1', borderTopWidth: 1 }}
                activeOpacity={0.65}
                onPress={() => { this.handleChangeState('shareVisible', false); }}
              >
                <Text style={[CommonStyles.flex_1, styles.shareModalCloseText]}>
                  关闭
                  </Text>
              </TouchableOpacity>
            </View>
          </View>
        </Modal>

      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  flexStart_noItemCenter: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
  },
  flexStart: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  flexCenter: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  flexWrap: {
    flexWrap: 'wrap',
  },
  borderRadius: {
    borderRadius: 6,
  },
  border: {
    borderWidth: 1,
    borderColor: 'rgba(215,215,215,0.5)',
  },
  borderBottom: {
    borderBottomWidth: 1,
    borderBottomColor: '#F1F1F1',
  },
  flex_1: {
    flex: 1,
  },
  topStatus: {
    height: 110,
    width,
  },
  topStatusText: {
    color: '#fff',
    fontSize: 24,
  },
  topStatusImage: {
    marginTop: 1,
    marginRight: 6,
  },
  addressView: {
    // margin: 10,
    marginHorizontal: 10,
    marginBottom: -5,
    position: 'relative',
    top: -15,
    left: 0,
    padding: 15,
    backgroundColor: '#fff',
  },
  userInfoText: {
    fontSize: 14,
    color: '#555',
  },
  goodsImg: {
    height: 130,
    width: 130,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: 'rgba(231,231,231,1)',
  },
  goodsWrap: {
    backgroundColor: '#fff',
    borderRadius: 10,
    borderWidth: 1,
    marginHorizontal: 10,
    marginTop: 10,
    borderColor: 'rgba(231,231,231,1)',
    overflow: 'hidden',
  },
  goodsItemWrap: {
    backgroundColor: '#fff',
    borderRadius: 10,
    borderWidth: 1,
    marginHorizontal: 10,
    borderColor: 'rgba(231,231,231,1)',
    overflow: 'hidden',
    // position: 'relative',
    // top: -15,
    // left: 0,
  },
  goodsTitle: {
    fontSize: 12,
    color: '#222',
    lineHeight: 17,
    paddingLeft: 15,
  },
  Specifications: {
    color: '#555',
    fontSize: 12,
    paddingLeft: 15,
    marginTop: 10,
  },
  goodsImgWrap: {
    padding: 15,
  },
  redColor: {
    color: '#EE6161',
  },
  goodsInfoText: {
    fontSize: 12,
    color: '#555',
  },
  goodsBorder: {
    borderBottomColor: '#f1f1f1',
    borderBottomWidth: 1,
    width: '100%',
  },
  btmLabelWrap: {
    borderBottomColor: '#f1f1f1',
    borderBottomWidth: 1,
    padding: 14,
    backgroundColor: '#fff',

  },
  btmLabel: {
    fontSize: 14,
    color: '#777',
    width: 70,
  },
  bottomBar: {
    position: 'absolute',
    bottom: 0 + CommonStyles.footerPadding,
    left: 0,
    width: '100%',
    height: 50,
    flexDirection: 'row',
    justifyContent: 'flex-end',
    alignItems: 'center',
    backgroundColor: '#fff',
    paddingHorizontal: 15,
  },
  bottomBtn: {
    backgroundColor: '#EE6161',
    paddingHorizontal: 14,
    height: '100%',
  },
  logisticsWrap: {
    margin: 10,
    marginTop: 0,
    backgroundColor: '#fff',
    borderRadius: 8,
    marginBottom: 66,
    overflow: 'hidden',
    borderBottomColor: '#f1f1f1',
    borderBottomWidth: 1,
  },
  marginBottom: {
    marginBottom: 66,
  },
  logisticsTitle: {
    height: 42,
    lineHeight: 42,
    color: '#777',
    fontSize: 14,
  },
  logisticsLabel: {
    color: '#555',
    lineHeight: 17,
    fontSize: 12,
  },
  bgBlue: {
    backgroundColor: '#4A90FA',
  },
  bgWhite: {
    backgroundColor: '#fff',
  },
  prizeNumLable: {
    color: '#4A90FA',
    fontSize: 17,
  },
  logisticsTitleWrap: {
    width: '100%',
    paddingHorizontal: 14,
    borderBottomColor: '#f1f1f1',
    borderBottomWidth: 1,
  },
  crashLabelWrap: {
    paddingBottom: 7,
  },
  crashLabel: {
    fontSize: 14,
    color: '#555',
  },
  gzWrpa: {
    backgroundColor: '#fff',
    margin: 10,
    marginBottom: 0,
    borderRadius: 8,
  },
  imageStyle: {
    height: '100%',
    width: '100%',
  },
  addressInfoText: {
    fontSize: 14,
    color: '#777',
    paddingLeft: 19,
    marginTop: 10,
    lineHeight: 20,
  },
  itemValueStyle: {
    fontSize: 14,
    color: '#222',
    flex: 1,
    paddingLeft: 10,
  },
  btnText: {
    fontSize: 12,
    textAlign: 'center',
    color: CommonStyles.globalHeaderColor,
    lineHeight: 18,
  },
  btnWrap: {
    width: 70,
    height: 20,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: CommonStyles.globalHeaderColor,
    backgroundColor: '#fff',
  },
  redBtnBorder: {
    borderColor: '#EE6161',
  },
  shareContent: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    paddingBottom: CommonStyles.footerPadding,
    backgroundColor: '#fff',
    width,
    borderTopRightRadius: 8,
    borderTopLeftRadius: 8,
  },
  shareModalCloseText: {
    fontSize: 14,
    color: '#222',
    textAlign: 'center',
    paddingVertical: 17.5,
  },
  modalItemStyle: {
    marginLeft: 35,
    marginRight: 25,
    paddingVertical: 25,
  },
  modalView: {
    backgroundColor: 'rgba(10,10,10,.5)',
  },
  closeBtnWrap: {
    position: 'absolute',
    top: (height - 312) / 2 - 54,
    left: 0,
    right: 0,
    height: 54,
    borderRadius: 8,
  },
  imgWrap: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    height: 24,
    width: 24,
    position: 'absolute',
    right: 28,
    top: 15,
    zIndex: 10,
  },
  shareInfoContent: {
    position: 'absolute',
    top: (height - 312) / 2,
    left: 43,
    right: 42,
    height: 312,
    backgroundColor: '#fff',
    padding: 15,
    borderRadius: 8,
  },
  shareImg: {
    height: 24,
    width: 24,
  },
  titleText: {
    color: '#222',
    fontSize: 17,
    textAlign: 'center',
  },
  modalInfo: {
    fontSize: 14,
    color: '#777',
    lineHeight: 19,
    textAlign: 'center',
    paddingHorizontal: 4,
    paddingBottom: 15,
  },
  modalBtn: {
    backgroundColor: CommonStyles.globalHeaderColor,
    borderRadius: 8,
    height: 40,
  },
  modalBtnText: {
    color: '#fff',
    fontSize: 14,
    paddingLeft: 6,
  },
  logItemWrap: {
    position: 'relative',
  },
  logisticsCircle: {
    height: 7,
    width: 7,
    borderRadius: 10,
    backgroundColor: CommonStyles.globalHeaderColor,
    position: 'absolute',
    top: 0,
    left: -3.5,
  },
});
export default connect(
  state => ({
    orderData: state.welfare.wmOrderDetail,
    wmOrderListItem: state.welfare.wmOrderListItem,
  }),
)(WMExpenseWinLotteryScreen);
