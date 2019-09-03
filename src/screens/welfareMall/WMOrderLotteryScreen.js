/**
 * 晒单流程
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
import WMOrderLotterInfo from '../../components/WMOrderLotterInfo';
import WMOrderLogisticsInfo from '../../components/WMOrderLogisticsInfo';
import WMOrderBottomBtn from '../../components/WMOrderBottomBtn';
import WMShareModal from '../../components/WMShareModal';
import { NavigationComponent } from '../../common/NavigationComponent';
import math from '../../config/math';
import config from '../../config/config';
import { showSaleNumText } from '../../config/utils'

const winningLotteryICon = require('../../images/wm/showOrder_icon.png');
const winningLotteryFaildICon = require('../../images/wm/showOrder_faildIcon.png');

const configShareUrl = config.baseUrl_share_h5;

const { width, height } = Dimensions.get('window');

class WMOrderLotteryScreen extends NavigationComponent {
    static navigationOptions = {
      header: null,
    };

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

    // 订单信息
    getOrderInfoItem = () => {
      const { orderData } = this.props;
      return (
        <React.Fragment>
          <View style={[styles.flexStart, styles.flex_1, styles.btmLabelWrap]}>
            <Text style={styles.btmLabel}>总计:</Text>
            <Text style={[styles.itemValueStyle]}>{`${math.divide(orderData.price || 0, 100)}消费券`}</Text>
          </View>
          <View style={[styles.flexStart, styles.flex_1, styles.btmLabelWrap]}>
            <Text style={styles.btmLabel}>期数:</Text>
            <Text style={[styles.itemValueStyle]}>{(orderData.currentNper < 10) ? `第0${orderData.currentNper}期` : `第${orderData.currentNper || 0}期`}</Text>
          </View>
          <View style={[styles.flexStart, styles.flex_1, styles.btmLabelWrap]}>
            <Text style={styles.btmLabel}>订单编号:</Text>
            <Text style={[styles.itemValueStyle]}>{orderData.orderId}</Text>
          </View>
          <View style={[styles.flexStart, styles.flex_1, styles.btmLabelWrap]}>
            <Text style={styles.btmLabel}>下单时间:</Text>
            <Text style={[styles.itemValueStyle]}>
              {
                orderData.createdAt
                  ? moment(orderData.createdAt * 1000).format('YYYY-MM-DD HH:mm')
                  : moment().format('YYYY-MM-DD HH:mm')
              }
            </Text>
          </View>
          <View style={[styles.flexStart, styles.flex_1, styles.btmLabelWrap]}>
            <Text style={styles.btmLabel}>兑奖方式:</Text>
            <Text style={[styles.itemValueStyle]}>消费券兑奖</Text>
          </View>
        </React.Fragment>
      );
    };

    // 兑奖编号
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
        this.props.navigation.navigate('WMGoodsDamagSuccessful', { title: '确认收货成功', resultType: 1, orderId: orderData.orderId });
      }).catch((err) => {
        console.log(err);
      });
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


    // 跳转到客服
    gotoCunstom = () => {
      nativeApi.createXKCustomerSerChat();
    }

    // 分享
    handleWxShare(type) {
      const { orderData } = this.props;
      const url = `${configShareUrl}welfareGoodsShow?id=${orderData.termNumber}`;
      const title = orderData.goodsName;
      const info = `规格：${orderData.showSkuName || '无'}  消费券：${math.divide(orderData.price || 0 , 100) }`;
      const iconUrl = orderData.mainUrl || orderData.goodsUrl;
      console.log('nativeApi', type, url, title, info, iconUrl);
      nativeApi.nativeShare(type, url, title, info, iconUrl).then((res) => {
        console.log('分享返回结果', res);
        Loading.hide();
        this.getData();
      }).catch((e) => {
        Toast.show('分享失败，请重试！');
        Loading.hide();
      });
    }

    // 获取顶部晒单状态文案
    getShowOrderLabel = (state = '') => {
      switch (state) {
        case 'WINNING_LOTTERY': return '等待用户晒单';
        case 'SHARE_AUDIT_ING': return '晒单审核中';
        case 'SHARE_AUDIT_FAIL': return '晒单失败';
        case 'SHARE_LOTTERY': return '已晒单';
        default: return '等待用户晒单';
      }
    }

    // 获取顶部晒单状态图片
    getShowOrderIcon = (state = '') => {
      switch (state) {
        case 'WINNING_LOTTERY': return winningLotteryICon;
        case 'SHARE_AUDIT_ING': return winningLotteryICon;
        case 'SHARE_AUDIT_FAIL': return winningLotteryFaildICon;
        case 'SHARE_LOTTERY': return winningLotteryICon;
        default: return winningLotteryICon;
      }
    }

    render() {
      const { navigation, orderData } = this.props;
      const topStatusTitle = this.getShowOrderLabel(orderData.state);
      const topStatusImg = this.getShowOrderIcon(orderData.state);
      const showOrderCommentStyle = (orderData.state === 'SHARE_AUDIT_ING' || orderData.state === 'SHARE_AUDIT_FAIL') ? { top: 0, marginBottom: 10 } : null;
      const time = moment(orderData.expectDrawTime).format('MM-DD HH:mm');
      const value =math.multiply(math.divide (orderData.joinCount , orderData.maxStake) , 100) ;
      // eslint-disable-next-line radix
      const processValue = (value < 1 && value !== 0) ? '1' : parseInt(value);
      const processPercent = `${processValue}%`;
      let fixedNumber = orderData.maxStake > 100000 ? 0 : 1;
      const showText = `${showSaleNumText(orderData.joinCount,fixedNumber)}/${showSaleNumText(orderData.maxStake,fixedNumber)}`
      console.log('orderDataComplete', orderData);
      return (
        <View style={styles.container}>
          <Header
            navigation={navigation}
            goBack
            title="订单详情"
          />
          <ScrollView
            style={{ marginBottom: CommonStyles.footerPadding }}
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
              (orderData.state === 'SHARE_AUDIT_ING' || orderData.state === 'SHARE_AUDIT_FAIL')
                ? (
                  <View style={[CommonStyles.flex_start_noCenter, styles.shareAduitIngInfo]}>
                    <Text style={{ fontSize: 14, color: '#222' }}>{ orderData.state === 'SHARE_AUDIT_ING' ? '晒单奖励：' : '失败原因：' }</Text>
                    <View style={CommonStyles.flex_1}>
                      <Text style={{ fontSize: 14, color: '#EE6161', lineHeight: 18 }}>{orderData.state !== 'SHARE_AUDIT_ING' ? `${orderData.commentContent || '无'}` : orderData.commentPrizeContent || '无'}</Text>
                    </View>
                  </View>
                )
                : null
            }
            <View style={[styles.addressView, styles.borderRadius, styles.border, showOrderCommentStyle]}>
              <View style={[CommonStyles.flex_start]}>
                <Image source={require('../../images/wm/localtion_icon.png')} />
                <Text style={[styles.userInfoText, { marginLeft: 5, marginRight: 15 }]}>{orderData.userName}</Text>
                <Text style={styles.userInfoText}>{orderData.userPhone}</Text>
              </View>
              <Text style={styles.addressInfoText} numberOfLines={2}>{orderData.userAddress}</Text>
            </View>
            <View style={[styles.goodsWrap, { marginTop: 0 }]}>
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
                  <View style={[CommonStyles.flex_start_noCenter, { marginTop: 1 }]}>
                    <Text style={styles.goodsInfoText}>消费券：</Text>
                    <Text style={[styles.goodsInfoText, styles.redColor, CommonStyles.flex_1]}>{`${math.divide(orderData.eachPrice || 0 , 100)}每注`}</Text>
                  </View>
                </WMGoodsWrap>
              </View>
            </View>
            {/* 注数，基本订单信息 */}
            <WMOrderInfoWrap orderData={orderData} />
            {/* 三方开奖信息 */}
            <WMOrderLotterInfo orderData={orderData} navigation={navigation} />
            {/* 物流信息 */}
            <WMOrderLogisticsInfo orderData={orderData} />
          </ScrollView>
          {/* 底部按钮 */}
          <WMOrderBottomBtn orderData={orderData} navigation={navigation} />
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
  shareAduitIngInfo: {
    marginHorizontal: 10,
    marginBottom: -5,
    position: 'relative',
    top: -15,
    left: 0,
    padding: 15,
    backgroundColor: '#fff',
    borderRadius: 8,
  },
  userInfoText: {
    fontSize: 14,
    color: '#555',
  },
  goodsImg: {
    height: 80,
    width: 80,
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
    backgroundColor: '#fff',
    height: 22,
    minWidth: 70,
    paddingHorizontal: 10,
    borderRadius: 20,
    borderWidth: 1,
    borderColor: '#EE6161',
    marginRight: 10,
    marginLeft: 10,
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
    color: '#555',
    fontSize: 14,
  },
  logisticsLabel: {
    color: '#777',
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
    lineHeight: 18,
    color: CommonStyles.globalHeaderColor,
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
    borderTopColor: '#f1f1f1',
    borderTopWidth: 1,
  },
  modalItemStyle: {
    marginLeft: 35,
    marginRight: 25,
    paddingVertical: 25,
  },
  modalView: {
    backgroundColor: 'rgba(10,10,10,.5)',
  },
  imgWrap: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    // position: 'relative',
    height: 24,
    width: 24,
    position: 'absolute',
    // right: -15,
    // top: -39,
    right: 15,
    top: 15,
    zIndex: 10,
  },
  shareInfoContent: {
    position: 'absolute',
    top: 200,
    left: 43,
    right: 42,
    backgroundColor: '#fff',
    padding: 15,
    borderRadius: 8,
  },
  shareImg: {
    height: 24,
    width: 24,
  },
  titleText: {
    flex: 1,
    color: '#222',
    fontSize: 17,
    textAlign: 'center',
  },
  goodsImg: {
    height: width - 241,
    width: width - 241,
    borderRadius: 10,
    marginTop: 12,
  },
  modalInfo: {
    paddingVertical: 15,
    fontSize: 14,
    color: '#777',
    textAlign: 'center',
  },
  modalBtn: {
    flex: 1,
    backgroundColor: CommonStyles.globalHeaderColor,
    paddingVertical: 12,
    borderRadius: 8,
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
  bottomBtnText: {
    color: '#EE6161',
    fontSize: 12,
  },
});
export default connect(
  state => ({ orderData: state.welfare.wmOrderDetail }),
)(WMOrderLotteryScreen);
