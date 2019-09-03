/**
 * 已完成 晒单详情
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
import WMOrderInfoWrap from '../../components/WMOrderInfoWrap';
import WMOrderLotterInfo from '../../components/WMOrderLotterInfo';
import WMOrderLogisticsInfo from '../../components/WMOrderLogisticsInfo';
import WMOrderBottomBtn from '../../components/WMOrderBottomBtn';
import * as nativeApi from '../../config/nativeApi';
import * as requestApi from '../../config/requestApi';
import WMShareModal from '../../components/WMShareModal';
import { NavigationComponent } from '../../common/NavigationComponent';
import math from '../../config/math';
import config from '../../config/config';
import { showSaleNumText } from '../../config/utils';

const winningLotteryICon = require('../../images/wm/showOrder_icon.png');
const winningLotteryFaildICon = require('../../images/wm/showOrder_faildIcon.png');

const configShareUrl = config.baseUrl_share_h5;

const { width, height } = Dimensions.get('window');

class WMExpenseShowOrderDetail extends NavigationComponent {
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
      const showOrderCommentStyle = (orderData.state === 'SHARE_AUDIT_ING' || orderData.state === 'SHARE_AUDIT_FAIL') ? { top: 0, marginBottom: 0 } : null;
      const time = moment(orderData.expectDrawTime).format('MM-DD HH:mm');
      const value =math.multiply(math.divide(orderData.joinCount , orderData.maxStake) , 100) ;
      // eslint-disable-next-line radix
      const processValue = (value < 1 && value !== 0) ? '1' : parseInt(value);
      const processPercent = `${processValue}%`;
      let fixedNumber = orderData.maxStake > 100000 ? 0 : 1;
      const showText = `${showSaleNumText(orderData.joinCount, fixedNumber)}/${showSaleNumText(orderData.maxStake,fixedNumber)}`
      const substance =  orderData.goodsType === 'substance';
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
            {
              // 如果是虚拟物品，不显示地址, 如果是实物，显示领取地址
              substance
                ? (
                  <View style={[styles.addressView, styles.borderRadius, styles.border, showOrderCommentStyle]}>
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

            <View style={[styles.goodsWrap, substance ?  null : { position: 'relative',top: -15, left: 0 }]}>
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
            {/* 注数，基本订单信息 */}
            <View style={{ marginTop: substance ? 0 : -15 }}>
              <WMOrderInfoWrap orderData={orderData}/>
            </View>
            {/* 三方开奖信息 */}
            <View style={{ marginBottom: substance ? 0 : 66 }}>
              <WMOrderLotterInfo orderData={orderData} navigation={navigation} />
            </View>
            {/* 物流信息 */}
            {
              // 如果是虚拟物品，不显示物流
              substance
                ? <WMOrderLogisticsInfo orderData={orderData} />
                : null
            }
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


  marginBottom: {
    marginBottom: 66,
  },

  bgBlue: {
    backgroundColor: '#4A90FA',
  },
  bgWhite: {
    backgroundColor: '#fff',
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


});
export default connect(
  state => ({ orderData: state.welfare.wmOrderDetail }),
)(WMExpenseShowOrderDetail);
