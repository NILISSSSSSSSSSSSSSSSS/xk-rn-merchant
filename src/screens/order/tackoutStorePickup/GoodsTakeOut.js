/**
 * 外卖或到店取货：订单详情
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Linking,
  Image,
  ScrollView,
  TouchableOpacity,
  TextInput,
  RefreshControl,
} from 'react-native';
import moment from 'moment';
import  math from "../../../config/math.js";
import { connect } from 'rn-dva';
import CommonStyles from '../../../common/Styles';
import Header from '../../../components/Header';
import Picker from '../../../components/Picker';
import * as orderRequestApi from '../../../config/Apis/order';
import CountDown from '../../../components/CountDown';
import ModalDemo from '../../../components/Model';
import * as nativeApi from '../../../config/nativeApi';
import TimeSelectModal from '../../../components/TimeSelectModal';
import {
  ORDER_STATUS_ONLINE_DESCRIBE,
  ORDER_STATUS_ONLINE,
  RIDER_ORDER_STATUS,
  RIDER_ORDER_STATUS_DESCRIBE,
} from '../../../const/order';
import ImageView from '../../../components/ImageView';
import { NavigationComponent } from '../../../common/NavigationComponent';
import { keepTwoDecimal } from '../../../config/utils';
import OrderGoodsCard from './components/OrderGoodsCard';

const tuiKuan = require('../../../images/shopOrder/tuiKuan.png');
const service = require('../../../images/shopOrder/service.png');
const add = require('../../../images/shopOrder/add.png');
const close = require('../../../images/shopOrder/close.png');
const checked = require('../../../images/mall/checked.png');
const unchecked = require('../../../images/mall/unchecked.png');
const editoricon = require('../../../images/shopOrder/editoricon.png');
const green = require('../../../images/account/xiaokebi.png');
const shiwuquan = require('../../../images/account/shiwuquan.png');
const realname = require('../../../images/shopOrder/realname.png');
const health = require('../../../images/shopOrder/health.png');
const callkihght = require('../../../images/shopOrder/callkihght.png');

const { width, height } = Dimensions.get('window');

function getwidth(val) {
  return width * val / 375;
}


class GoodsTakeOut extends NavigationComponent {
  constructor(props) {
    super(props);
    const params = props.navigation.state.params || {};
    const { orderStatus, updatedAt, taskTime } = props.orderDetail;
    this.state = {// 订单状态\
      confirmModifyPostVisible: false,
      modalVisible: false,
      title: params.title,
      showCountDown: true,
      isOrigiPrice: true,
      youhuiPrice: '',
      reson: '',
      isUpdate: false, // 是否修改了订单
      refreshing: false,
      timeVisible: false,
      timeVisibleForm: {
        date: '',
        time: '',
      },
    };
  }

  blurState = {
    confirmModifyPostVisible: false,
    modalVisible: false,
    timeVisible: false,
  }

  componentDidMount() {
    const params = this.props.navigation.state.params || {};
    this.isShouhou = params.isShouhou; // 是否是售后订单
    this.nosure = params.page === 'LogisticsOrder'; // 是否是物流订单
    this.orderId = params.orderId; // 订单Id
    this.orderNo = params.orderNo;
    this.isUpdate = false;
    console.log('GoodsTakeOut.componentDidMount', params);

    this.initDataDidMount();
  }

  screenDidFocus = (payload) => {
    super.screenDidFocus(payload);
    this.initDataDidMount();
  }

  initDataDidMount = () => {
    this.props.fetchOBMBcleOrderDetails(this.orderId, this.orderNo, this.isShouhou, this.nosure);
  }

  getpBcleOrderPayStatus = (item) => {
    const payState = item.bcleOrderPayStatus;

    switch (payState) {
      case 'NOT_PAY':
      case 'DURING_PAY':
        return '未支付';
      case 'SUCCESS_PAY':
        return '支付成功';
      case 'APPLY_REFUND':
        return '已支付需退款';
      case 'AGREE_REFUND':
        return '同意退款';
      case 'REFUSE_REFUND':
        return '拒绝退款';
      case 'SUCCESS_REFUND':
        return '退款成功';
      default:
        return '';
    }
  }

  getSourcePic = (item, isServuice) => {
    const payState = isServuice ? item.bcleOrderPayStatus : item.pBcleOrderPayStatus;
    return payState == 'NOT_PAY' || payState == 'DURING_PAY' || payState == 'DURING_PAY';
  }

  cancelTheOrder = () => {
    const { navigation } = this.props;
    navigation.navigate('CancelOrder');
  }

  bcleMUserReadyComplete = () => {
    const { orderId } = this.props.orderDetail;
    orderRequestApi.fetchBcleMUserReadyComplete({ orderId }).then((res) => {
      this.initDataDidMount(orderId);
    }).catch(err => {
      console.log(err)
    });
  }

  mUserConfirmDelivery = () => {
    const { orderDetail } = this.props;
    const { orderId, shopId } = orderDetail;
    const param = { orderId, shopId };
    orderRequestApi.fetchMUserConfirmDelivery(param).then((res) => {
      this.initDataDidMount(orderId);
    }).catch(err => {
      console.log(err)
    });
  }

  cancelWuliuOrder = () => {
    const { chooseKightData } = this.props.orderDetail;
    const { orderId } = this.props.navigation.state.params;
    const param = {
      orderNo: chooseKightData.orderNo,
      riderId: chooseKightData.riderId,
      goodsOrderNo: orderId,
    };
    orderRequestApi.fetchmerchantCancelOrder(param).then((res) => {
      this.props.changeOBMBcleOrderDetail({
        hasWuliu: false,
        chooseKightData: null,
      });
      this.initDataDidMount(orderId);
      this.setState({
        modalVisible: false,
      });
    }).catch(() => {
      this.setState({
        modalVisible: false,
      });
    });
  }

  concatUser = () => { // 联系客户
    Loading.show();
    orderRequestApi.mCustomerServiceContactUser({
      customerId: this.props.orderDetail.userId,
      shopId: this.props.shopId,
    }).then((res) => {
      console.log(res);
      if (res && res.tid) {
        nativeApi.createShopCustomerWithCustomerID(res.tid, res.userId, res.username, this.props.shopId);
      }
    }).catch(()=>{
          
    });
  }

  renderBottomData = (isClosed) => {
    let bottomData;
    const {
      orderStatus, data, orderId, shopId, status, chooseKightData, isUpLimit, editorble, isGoodsTakeOut, isSelfLifting,
    } = this.props.orderDetail;
    const { navigation } = this.props;
    const { initData } = navigation.state.params;
    if (isUpLimit) {
      bottomData = [{ name: '联系客户', onPress: this.concatUser }];
    } else if (chooseKightData) {
      switch (chooseKightData.orderStatus) {
        case 'wait_rider': bottomData = [{ name: '取消派单', onPress: () => this.this.setState({ modalVisible: true }) }];
        case 'rider_refuse': bottomData = [
          { name: '联系客户', onPress: this.concatUser },
          { name: '取消订单', onPress: this.cancelTheOrder },
          { name: '重新派单', onPress: () => this.inputWuliu(1) },
        ];
        case 'rider_drivering':
        case 'order_cancel':
        case 'wait_pickup':
        case 'rider_trans':
        case 'rider_transing':
        case 'rider_arraive':
        case 'order_canceling':
        case 'user_confirm':
          bottomData = [{ name: '联系客户', onPress: this.concatUser }];
        default:
          break;
      }
    } else {
      if (isClosed) {
        bottomData = [{ name: '联系客户', onPress: this.concatUser }];
      } else {
        switch (orderStatus) {
          case ORDER_STATUS_ONLINE.STAY_ORDER: bottomData = [
            { name: '联系客户', onPress: this.concatUser },
            { name: '取消订单', onPress: this.cancelTheOrder },
            { name: '确认接单', onPress: this.confirmOrder },
          ];
          case ORDER_STATUS_ONLINE.STAY_PAY: bottomData = [
            { name: '联系客户', onPress: this.concatUser },
            { name: '取消订单', onPress: this.cancelTheOrder },
          ];
          case ORDER_STATUS_ONLINE.STOCK_CENTRE: bottomData = [
            { name: '联系客户', onPress: this.concatUser },
            { name: '取消订单', onPress: this.cancelTheOrder },
            { name: '备货完成', onPress: this.bcleMUserReadyComplete },
          ];

          case ORDER_STATUS_ONLINE.CONSUMPTION_CENTRE:
          case ORDER_STATUS_ONLINE.PROCESS_CENTRE: bottomData = [
            { name: '联系客户', onPress: this.concatUser },
            { name: '取消订单', onPress: this.cancelTheOrder },
          ];
            isSelfLifting == 1 ? bottomData.push({ name: '订单结束', onPress: this.mUserConfirmDelivery }) : null; // fix：到店自提需要手动结束订单
          case ORDER_STATUS_ONLINE.SHOU_HOU: bottomData = [
            { name: '联系客户', onPress: this.concatUser },
            {
              name: '拒绝取消',
              onPress: () => {
                navigation.navigate('RefusedRefund', {
                  status, orderId, shopId, initData, serviceData: data, isGoodsTakeOut: true,
                });
              },
            },
            {
              name: '确认取消',
              onPress: () => {
                navigation.navigate('RefundServiceList', {
                  status, serviceData: data, shopId, orderId, initData, isGoodsTakeOut: true,
                });
              },
            },
          ];
          default: bottomData = [{ name: '联系客户', onPress: this.concatUser }];
        }
      }
    }
    return bottomData;
  }

  renderBtttomBtn = (isClosed) => {
    const {
      orderStatus, data, orderId, shopId, status, chooseKightData, isUpLimit, editorble, logistics = {}, isSelfLifting,
    } = this.props.orderDetail;
    const { navigation } = this.props;
    const { initData } = navigation.state.params;
    if (isUpLimit) {
      return (
        <View style={styles.bottomBtn}>
          <TouchableOpacity
            style={{
              backgroundColor: '#fff', width: '100%', justifyContent: 'center', alignItems: 'center',
            }}
            activeOpacity={0.8}
            onPress={() => this.concatUser()}
          >
            <Text style={styles.c2f14}>联系客户</Text>
          </TouchableOpacity>
        </View>
      );
    } if (chooseKightData) {
      switch (chooseKightData.orderStatus) {
        case 'wait_rider':
          return (
            <View style={styles.bottomBtn}>
              <TouchableOpacity
                disabled={editorble}
                onPress={() => this.setState({ modalVisible: true })}
                style={{
                  backgroundColor: '#4A90FA', width: '100%', justifyContent: 'center', alignItems: 'center',
                }}
              >
                <Text style={[styles.cf14, { fontSize: 17 }]}>取消派单</Text>
              </TouchableOpacity>
            </View>
          );
        case 'rider_refuse':
          return (
            <View style={styles.bottomBtn}>
              <TouchableOpacity style={styles.kefu} activeOpacity={0.8} onPress={() => this.concatUser()}>
                <Text style={styles.c2f14}>联系客户</Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={this.cancelTheOrder}
                style={[styles.fixedWidth, { backgroundColor: '#EE6161' }]}
              >
                <Text style={styles.cf14}>取消订单</Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => this.inputWuliu(1)}
                style={[styles.fixedWidth, { backgroundColor: '#4A90FA' }]}
              >
                <Text style={styles.cf14}>重新派单</Text>
              </TouchableOpacity>
            </View>
          );
        case 'rider_drivering':
        case 'order_cancel':
        case 'wait_pickup':
        case 'rider_trans':
        case 'rider_transing':
        case 'rider_arraive':
        case 'order_canceling':
        case 'user_confirm':
          return (
            <View style={styles.bottomBtn}>
              <TouchableOpacity
                disabled={editorble}
                style={{
                  backgroundColor: '#fff', width: '100%', justifyContent: 'center', alignItems: 'center', height: 50,
                }}
                activeOpacity={0.8}
                onPress={() => this.concatUser()}
              >
                <Text style={[styles.c2f14]}>联系客户</Text>
              </TouchableOpacity>
            </View>
          );
        default: return null;
      }
    } else {
      if (isClosed) {
        return (
          <View style={[styles.bottomBtn, { justifyContent: 'center', alignItems: 'center' }]}>
            <TouchableOpacity style={[styles.kefu, { justifyContent: 'center', alignItems: 'center' }]} activeOpacity={0.8} onPress={() => this.concatUser()}>
              <Text style={styles.c2f14}>联系客户</Text>
            </TouchableOpacity>
          </View>
        );
      }
      switch (orderStatus) {
        case ORDER_STATUS_ONLINE.STAY_ORDER:
          return (
            <View style={styles.bottomBtn}>
              <TouchableOpacity style={styles.kefu} activeOpacity={0.8} onPress={() => this.concatUser()}>
                <Text style={styles.c2f14}>联系客户</Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={this.cancelTheOrder}
                style={[styles.fixedWidth, { backgroundColor: '#EE6161' }]}
              >
                <Text style={styles.cf14}>取消订单</Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={this.confirmOrder}
                style={[styles.fixedWidth, { backgroundColor: '#4A90FA' }]}
              >
                <Text style={styles.cf14}>确认接单</Text>
              </TouchableOpacity>
            </View>
          );
        case ORDER_STATUS_ONLINE.STAY_PAY:
          return (
            <View style={styles.bottomBtn}>
              <TouchableOpacity style={styles.kefu} activeOpacity={0.8} onPress={() => this.concatUser()}>
                <Text style={styles.c2f14}>联系客户</Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={this.cancelTheOrder}
                style={[styles.fixedWidth, { backgroundColor: '#EE6161' }]}
              >
                <Text style={styles.cf14}>取消订单</Text>
              </TouchableOpacity>
            </View>
          );
        case ORDER_STATUS_ONLINE.STOCK_CENTRE:
          return (
            <View style={styles.bottomBtn}>
              <TouchableOpacity style={styles.kefu} activeOpacity={0.8} onPress={() => this.concatUser()}>
                <Text style={styles.c2f14}>联系客户</Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={this.cancelTheOrder}
                style={[styles.fixedWidth, { backgroundColor: '#EE6161' }]}
              >
                <Text style={styles.cf14}>取消订单</Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={this.bcleMUserReadyComplete}
                style={[styles.fixedWidth, { backgroundColor: '#4A90FA' }]}
              >
                <Text style={styles.cf14}>备货完成</Text>
              </TouchableOpacity>
            </View>
          );
        case ORDER_STATUS_ONLINE.CONSUMPTION_CENTRE:
        case ORDER_STATUS_ONLINE.PROCESS_CENTRE:
          return (
            <View style={styles.bottomBtn}>
              <TouchableOpacity style={styles.kefu} activeOpacity={0.8} onPress={() => this.concatUser()}>
                <Text style={styles.c2f14}>联系客户</Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={this.cancelTheOrder}
                style={[styles.fixedWidth, { backgroundColor: '#EE6161' }]}
              >
                <Text style={styles.cf14}>取消订单</Text>
              </TouchableOpacity>
              {
                isSelfLifting == 1 || (logistics && (logistics.postType === 'THIRD' || logistics.postType === 'M_HIMSELF'))
                  ? (
                    <TouchableOpacity
                      onPress={this.mUserConfirmDelivery}
                      style={[styles.fixedWidth, { backgroundColor: '#4A90FA' }]}
                    >
                      <Text style={styles.cf14}>订单结束</Text>
                    </TouchableOpacity>
                  ) : null
              }

            </View>
          );
        case ORDER_STATUS_ONLINE.SHOU_HOU:
          return (
            <View style={styles.bottomBtn}>
              <TouchableOpacity style={styles.kefu} activeOpacity={0.8} onPress={() => this.concatUser()}>
                <Text style={styles.c2f14}>联系客户</Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => {
                  navigation.navigate('RefusedRefund', {
                    status, orderId, shopId, initData, serviceData: data, isGoodsTakeOut: true,
                  });
                }}
                style={[styles.fixedWidth, { backgroundColor: '#EE6161' }]}
              >
                <Text style={styles.cf14}>拒绝取消</Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => {
                  if (status === 'del') {
                    this.fetchMUserAgreeOrRejectCancelOrder();
                    return;
                  }
                  navigation.navigate('RefundServiceList', {
                    status, serviceData: data, shopId, orderId, initData, isGoodsTakeOut: true,
                  });
                }}
                style={[styles.fixedWidth, { backgroundColor: '#4A90FA' }]}
              >
                <Text style={styles.cf14}>确认取消</Text>
              </TouchableOpacity>
            </View>
          );
        default:
          return (
            <View style={[styles.bottomBtn, { justifyContent: 'center', alignItems: 'center' }]}>
              <TouchableOpacity style={[styles.kefu, { justifyContent: 'center', alignItems: 'center' }]} activeOpacity={0.8} onPress={() => this.concatUser()}>
                <Text style={styles.c2f14}>联系客户</Text>
              </TouchableOpacity>
            </View>
          );
      }
    }
  }

  fetchMUserAgreeOrRejectCancelOrder = () => {
    const { navigation } = this.props;
    const { shopId, initData } = navigation.state.params;
    const param = {
      orderMUserAgree: {
        orderId: this.orderId,
        shopId,
        agree: 1,
      },
    };
    Loading.show();
    orderRequestApi.fetchMUserAgreeOrRejectCancelOrder(param).then((res) => {
      Toast.show('同意退款成功');
      if (initData) {
        initData();
      }
      navigation.goBack();
      Loading.hide();
    }).catch(() => Loading.hide());
  }

  chooseTime = (date, time) => {
    this.props.changeOBMBcleOrderDetail({
      timedate: `${date} ${time.split('-')[0]}`,
      endtime: `${date} ${time.split('-')[1]}`,
    });
    this.setState({ isUpdate: true });
  }

  changefreight = (val) => {
    this.props.changeOBMBcleOrderDetail({
      freight: val,
    });
  }

  setisUpLimit = () => {
    this.props.changeOBMBcleOrderDetail({
      isUpLimit: true,
    });
  }

  setThreeWuliu = (hasWuliu = true) => {
    this.props.changeOBMBcleOrderDetail({
      hasWuliu,
      postType: hasWuliu ? 'THIRD' : '',
    });
  }

  inputWuliu = (flag) => {
    const {
      hasWuliu, isGoodsTakeOut, postType: orderPostType, shopId, orderId, logistics,
    } = this.props.orderDetail;
    const { postType: wuliuPostType } = logistics || {};
    const postType = wuliuPostType || orderPostType;
    const { navigation } = this.props;
    if (flag === 1) { // 重新派单
      // navigation.navigate('ChooseStream', {
      navigation.navigate('LogisticsScreen', {
        shopId,
        isGoodsTakeOut,
        orderId,
        setKight: this.props.setKightToUpdateChooseKightData,
        setisUpLimit: this.setisUpLimit,
        callback: this.initDataDidMount.bind(this),
      });
      this.props.changeOBMBcleOrderDetail({ hasWuliu: false, chooseKightData: null });
    } else {
      // 录入物流
      if (!hasWuliu) {
        navigation.navigate('LogisticsScreen', {
          // navigation.navigate('ChooseStream', {
          shopId,
          isGoodsTakeOut,
          orderId,
          setKight: this.props.setKightToUpdateChooseKightData,
          setThreeWuliu: this.setThreeWuliu,
          setisUpLimit: this.setisUpLimit,
          callback: this.initDataDidMount.bind(this),
        });
      } else {
        console.log('postType', postType);
        // 查看物流
        if (postType == 'THIRD') { // 第三方物流
          this.props.navigation.navigate('LogisticsInform', { orderId, page: 'detail', setThreeWuliu: this.setThreeWuliu });
        } else if (postType === 'M_HIMSELF') {
          this.setState({
            confirmModifyPostVisible: true,
          });
        } else { // 小可物流
          // this.props.setKightToUpdateChooseKightData(1)
        }
      }
    }
  }

  addsServiceGoodsData = (data) => {
    const newdata = [];
    let totalMoney = 0;
    data.forEach((item) => {
      if (item.sum > 1) {
        while (item.sum) {
          const onedata = JSON.parse(JSON.stringify(item));
          onedata.sum = 1;
          onedata.platformShopPrice = onedata.skuprice || onedata.discountPrice || onedata.platformShopPrice;
          onedata.platformPrice = onedata.skuprice || onedata.discountPrice || onedata.platformPrice;
          onedata.skuUrl = onedata.mainPic || onedata.skuUrl;
          totalMoney += onedata.skuprice || onedata.discountPrice;
          newdata.push(onedata);
          item.sum--;
        }
      } else {
        item.platformShopPrice = item.skuprice || item.discountPrice || item.platformShopPrice;
        item.platformPrice = item.skuprice || item.discountPrice || item.platformPrice;
        item.skuUrl = item.mainPic || item.skuUrl;
        totalMoney += item.skuprice || item.discountPrice;
        newdata.push(item);
      }
    });
    this.props.changeOBMBcleOrderDetail({ data: newdata, totalMoney });
  }

  confirmOrder = () => {
    const {
      data, timedate, endtime, totalMoney, freight, orderId, shopId,
    } = this.props.orderDetail;
    const {
      isOrigiPrice, youhuiPrice, reson, isUpdate,
    } = this.state;
    let price = '';
    if (isOrigiPrice) {
      price = math.divide(totalMoney , 100) ;
    } else {
      price = youhuiPrice;
      if (youhuiPrice > math.divide(totalMoney , 100)) {
        Toast.show('优惠价格不得大于原价');
        return;
      }
    }
    const oldData = this.oldData;
    if (this.oldData) {
      const oldtimedata = moment(oldData.timedate).valueOf() / 1000;
      const oldendtime = moment(oldData.endtime).valueOf() / 1000;
      const { freight: oldfreight, totalMoney: oldtotalMoney, data: oldgoodsdata } = oldData;
      const newtimedate = moment(timedate).valueOf() / 1000;
      const newendtime = moment(endtime).valueOf() / 1000;
      const newfreight = freight;
      const newtotalMoney = totalMoney;
      const newdata = data;
      if (newtimedate == oldtimedata && oldendtime == newendtime && newfreight == oldfreight && newtotalMoney == oldtotalMoney && newdata && oldgoodsdata) {
        if (newdata.length !== oldgoodsdata.length) {
          this.isUpdate = true;
        } else {
          newdata.forEach((item) => {
            let flag = false;
            oldgoodsdata.find((oldItem) => {
              if (item.goodsId === oldItem.goodsId && item.goodsSkuCode === oldItem.goodsSkuCode) {
                flag = true;
                return true;
              }
            });
            if (!flag) {
              this.isUpdate = true;
            }
          });

          oldgoodsdata.forEach((item) => {
            let flag = false;
            newdata.find((oldItem) => {
              if (item.goodsId === oldItem.goodsId && item.goodsSkuCode === oldItem.goodsSkuCode) {
                flag = true;
                return true;
              }
            });
            if (!flag) {
              this.isUpdate = true;
            }
          });
        }
      } else {
        this.isUpdate = true;
      }
    }
    if (!isOrigiPrice) {
      this.isUpdate = true;
    }
    if (this.isUpdate || isUpdate) {
      // 修改并接单
      if (!reson || (reson && reson.trim() == '')) {
        Toast.show('修改原因必填');
        return;
      }
      const param = {
        muserAgreeUpdateOrde: {
          orderId,
          shopId,
          goodsParams: [],
          seats: [],
          price: this.getAllPrice,
          appointRange: `${moment(timedate, 'YYYY-MM-DD HH:mm').valueOf() / 1000}-${moment(endtime, 'YYYY-MM-DD HH:mm').valueOf() / 1000}`,
          modifyInfo: reson,
          postFee:math.multiply(freight ,100) ,
        },
      };
      data.forEach((item) => {
        let flag = false;
        param.muserAgreeUpdateOrde.goodsParams.find((one) => {
          if (one.goodsId === item.goodsId && one.goodsSkuCode === item.goodsSkuCode) {
            one.goodsSum += 1;
            flag = true;
            return true;
          }
        });
        if (!flag) {
          param.muserAgreeUpdateOrde.goodsParams.push({
            goodsId: item.goodsId,
            goodsSkuCode: item.goodsSkuCode,
            goodsSum: 1,
          });
        }
      });
      orderRequestApi.fetchShopAgreeUpdateOrder(param).then((res) => {
        this.initDataDidMount(orderId);
      }).catch(()=>{
          
      });
    } else {
      // 直接接单
      const param = { orderId, shopId };
      orderRequestApi.fetcShopAgreeOrder(param).then((res) => {
        this.initDataDidMount(orderId);
      }).catch(()=>{
          
      });
    }
  }

  changePriceType = (val) => {
    if (val) {
      this.setState({
        youhuiPrice: '',
      });
    }
    this.setState({
      isOrigiPrice: val,
    });
  }

  changeyouhuiPrice = (val) => {
    this.setState({
      youhuiPrice: val,
    });
  }

  handleTimerOnEnd = () => {
    this.setState({
      showCountDown: false,
    });
  }

  getAllPrice = () => { // 获取总价格
    const data = this.props.orderDetail.data || [];
    const orderStatus = this.props.orderDetail.orderStatus;
    const isPlatformPrice = [ORDER_STATUS_ONLINE.STAY_EVALUATE, ORDER_STATUS_ONLINE.COMPLETELY].includes(orderStatus);
    return data.reduce((preV, curV, curIndex, array) => preV + (isPlatformPrice ? curV.platformShopPrice : curV.platformPrice), 0);
  }

  renderRiderDetail = () => {
    const { chooseKightData } = this.props.orderDetail;
    return (
      <View>
        <View style={{
          width: getwidth(325),
          height: 0.5,
          borderTopColor: '#CCC',
          borderTopWidth: 0.5,
        }}
        />
        <View style={{ flexDirection: 'row', alignItems: 'center', height: 52 }}>
          <Text style={{ color: '#17181A', fontSize: 14, width: 60 }} numberOfLines={1} ellipsizeMode="tail">{chooseKightData.realName}</Text>
          <Image source={chooseKightData.idCardAuthStatus === 'SUCCESS' ? realname : ''} style={{ marginLeft: 10 }} />
          <Image source={chooseKightData.healthCardAuthStatus === 'SUCCESS' ? health : ''} style={{ marginLeft: 10, marginRight: 20 }} />
          <Text style={{ color: '#17181A', fontSize: 14 }}>{chooseKightData.phone}</Text>
          <TouchableOpacity
            onPress={() => Linking.openURL(`tel:${chooseKightData.phone}`)}
            style={{
              flex: 1, flexDirection: 'row', justifyContent: 'flex-end', marginRight: 0, alignItems: 'center',
            }}
          >
            <Image source={callkihght} style={{ marginRight: 6 }} />
            <Text style={{ color: '#17181A', fontSize: 14 }}>联系骑手</Text>
          </TouchableOpacity>
        </View>
      </View>
    );
  }

  renderKightStatus = () => {
    const { chooseKightData, isUpLimit, isGoodsTakeOut } = this.props.orderDetail;
    let view = null;
    if (isUpLimit) {
      return (
        <View style={[styles.topState, { height: 127, marginBottom: 10 }]}>
          <View style={{
            flexDirection: 'row', justifyContent: 'space-between', width: '100%', height: 64, alignItems: 'center',
          }}
          >
            <Text style={{ color: '#222222', fontSize: 21 }}>等待平台派单</Text>
            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
              <Image source={tuiKuan} style={{ width: getwidth(28), height: getwidth(28), marginRight: 8 }} />
            </View>
          </View>
        </View>
      );
    }
    switch (chooseKightData.orderStatus) {
      case RIDER_ORDER_STATUS.WAIT_RIDER:
        console.log('倒计时间：', moment(chooseKightData.endAt * 1000).format('HH:mm:ss'));
        console.log('当前时间', moment(Date.now()).format('HH:mm:ss'));
        view = (
          <View style={[styles.topState, { height: 127, marginBottom: 10 }]}>
            <View style={{
              flexDirection: 'row', justifyContent: 'space-between', width: '100%', height: 64, alignItems: 'center',
            }}
            >
              <Text style={{ color: '#222222', fontSize: 21 }}>等待骑手接单</Text>
              <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                <Image source={tuiKuan} style={{ width: getwidth(28), height: getwidth(28), marginRight: 8 }} />
                <View style={{ flexDirection: 'row' }}>
                  <CountDown
                    date={moment(chooseKightData.endAt * 1000)}
                    daysStyle={{ color: '#FF7E00', fontSize: 21 }}
                    hoursStyle={{ color: '#FF7E00', fontSize: 21 }}
                    minsStyle={{ color: '#FF7E00', fontSize: 21 }}
                    secsStyle={{ color: '#FF7E00', fontSize: 21 }}
                    firstColonStyle={{ color: '#FF7E00', fontSize: 21 }}
                    secondColonStyle={{ color: '#FF7E00', fontSize: 21 }}
                    hours=":"
                    mins=":"
                    segs=" "
                    onEnd={() => {
                      chooseKightData.orderStatus = RIDER_ORDER_STATUS.RIDER_REFUSE;
                      this.props.changeOBMBcleOrderDetail({ chooseKightData });
                    }}
                  />
                </View>
              </View>
            </View>
            {this.renderRiderDetail()}
          </View>
        );
        return view;
      case RIDER_ORDER_STATUS.RIDER_REFUSE:
        view = (
          <View style={[styles.topState, { height: 147, marginBottom: 10 }]}>
            <View style={{ width: '100%', height: 74, justifyContent: 'center' }}>
              <Text style={{ color: '#222222', fontSize: 21 }}>{RIDER_ORDER_STATUS_DESCRIBE[chooseKightData.orderStatus || 'default'].name}</Text>
              <Text style={{ color: '#222222', fontSize: 14 }}>倒计时已结束，骑手没有接单，请重新派单</Text>
            </View>
            {this.renderRiderDetail()}
          </View>
        );
        return view;
      case RIDER_ORDER_STATUS.RIDER_DRIVERING:
      case RIDER_ORDER_STATUS.WAIT_PICKUP:
      case RIDER_ORDER_STATUS.RIDER_TRANS:
      case RIDER_ORDER_STATUS.RIDER_TRANSING:
        view = (
          <View style={[styles.topState, { height: 153, marginBottom: 10 }]}>
            <View style={{ height: 90, justifyContent: 'center' }}>
              <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
                <Text style={{ color: '#222222', fontSize: 21 }}>{RIDER_ORDER_STATUS_DESCRIBE[chooseKightData.orderStatus || 'default'].name}</Text>
                <Text style={{ color: '#4A90FA', fontSize: 17 }}>
                  {!isGoodsTakeOut ? '取货码' : '取餐码'}
                  :
                    {chooseKightData.pickupCode}
                </Text>
              </View>
              <View style={{ marginTop: 10 }}>
                <Text style={{ color: '#222222', fontSize: 14 }}>
                  预计到达时间：
                    <Text style={{ color: '#FF7E00', fontSize: 14 }}>{moment(chooseKightData.planShopDuration * 1000).format('YYYY-MM-DD HH:mm')}</Text>
                </Text>
              </View>
            </View>
            {this.renderRiderDetail()}
          </View>
        );
        return view;
      case RIDER_ORDER_STATUS.ORDER_CANCEL:
      case RIDER_ORDER_STATUS.RIDER_ARRAIVE:
        view = (
          <View style={[styles.topState, { height: 153, marginBottom: 10 }]}>
            <View style={{ height: 90, justifyContent: 'center' }}>
              <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
                <Text style={{ color: '#222222', fontSize: 21 }}>{RIDER_ORDER_STATUS_DESCRIBE[chooseKightData.orderStatus || 'default'].name}</Text>
              </View>
              <View style={{ marginTop: 10 }}>
                <Text style={{ color: '#222222', fontSize: 14 }}>
                  {chooseKightData.orderStatus == RIDER_ORDER_STATUS.ORDER_CANCEL ? '取消' : '完成'}
                  时间：
                    <Text style={{ color: '#FF7E00', fontSize: 14 }}>{moment((chooseKightData.endAt) * 1000).format('YYYY-MM-DD HH:mm')}</Text>
                </Text>
              </View>
            </View>
            {this.renderRiderDetail()}
          </View>
        );
        return view;
    }
  }


  renderTitleTips = (topTitleData, orderStatus, showCountDown, countdown, updatedAt, isGoodsTakeOut, isSelfLifting) => {
    let stockUped = false;
    if (orderStatus == ORDER_STATUS_ONLINE.PROCESS_CENTRE && isGoodsTakeOut && isSelfLifting == 1) { // 备货完成
      stockUped = true;
    }
    let content = <Text style={styles.c7f14}>{stockUped ? '等待用户上门取货' : topTitleData.tips}</Text>;
    console.log(showCountDown, countdown);
    switch (orderStatus) {
      case ORDER_STATUS_ONLINE.STAY_ORDER:
      case ORDER_STATUS_ONLINE.STAY_PAY:
      case ORDER_STATUS_ONLINE.STAY_EVALUATE:
        if (countdown !== -1) {
          if (showCountDown && countdown > 0) {
            content = (
              <View style={{ flexDirection: 'row' }}>
                <CountDown
                  date={moment(updatedAt * 1000).add(countdown, 'ms')}
                  days={{ plural: '天 ', singular: '天 ' }}
                  hours="时"
                  mins="分"
                  segs="秒"
                  onEnd={() => {
                    this.handleTimerOnEnd();
                  }}
                />
                <Text style={{ fontSize: 12, color: 'rgba(85, 85, 85, 1)' }}>{topTitleData.tips}</Text>
              </View>
            );
          } else {
            content = <Text>{orderStatus == ORDER_STATUS_ONLINE.STAY_EVALUATE ? '系统默认好评' : '系统已经自动关闭'}</Text>;
          }
          break;
        } else {
          content = (
            <Text style={styles.c7f14}>
              {topTitleData.tips}
              ：
                {countdown}
            </Text>
          );
          break;
        }
      case ORDER_STATUS_ONLINE.COMPLETELY:
      case ORDER_STATUS_ONLINE.CLOSE:
        content = (
          <Text style={styles.c7f14}>
            {topTitleData.tips}
            ：
              {countdown}
          </Text>
        );
        break;
      default:
        break;
    }
    return (<View style={[styles.topItem, { justifyContent: 'center' }]}>{content}</View>);
  }

  getCountDown(orderStatus, taskTime, updatedAt) {
    let countdown = -1;
    console.log('getCountDown', orderStatus, taskTime, updatedAt);
    switch (orderStatus) {
      case ORDER_STATUS_ONLINE.STAY_ORDER:
      case ORDER_STATUS_ONLINE.STAY_PAY:
      case ORDER_STATUS_ONLINE.STAY_EVALUATE:
        if (taskTime && updatedAt) {
          // countdown = (taskTime * 1000 - (moment().valueOf() - updatedAt * 1000))
          countdown = taskTime * 1000;
          console.log('getCountDown', countdown);
        }
        break;
      case ORDER_STATUS_ONLINE.COMPLETELY:
      case ORDER_STATUS_ONLINE.CLOSE:
        if (updatedAt) countdown = moment(updatedAt * 1000).format('YYYY-MM-DD HH:mm:ss');
        break;
    }
    return countdown;
  }

  /** 待接单需填写的表单内容 */
  renderStayOrderForm(orderStatus, isOrigiPrice, youhuiPrice, reson, price) {
    if (orderStatus !== ORDER_STATUS_ONLINE.STAY_ORDER) return null;
    return (
      <View>
        {/* <View style={styles.infoItem}> */}
        {/* <TouchableOpacity
                    onPress={() => {
                        this.changePriceType(true)
                    }}
                    style={{ flexDirection: 'row', flex: 4, alignItems: 'center' }}
                >
                    <Image source={isOrigiPrice ? checked : unchecked} />
                    <Text style={[styles.c2f14, { marginLeft: 6 }]}>使用原价:</Text>
                </TouchableOpacity>
                <View
                    style={styles.infoItemright}
                >
                    <Text style={styles.c7f14}>{math.divide(price, 100)}元</Text>
                </View>
            </View>
            <View style={styles.infoItem}>
                <TouchableOpacity
                    onPress={() => {
                        this.changePriceType(false)
                    }}
                    style={{ flexDirection: 'row', flex: 4, alignItems: 'center' }}
                >
                    <Image source={isOrigiPrice ? unchecked : checked} />
                    <Text style={[styles.c2f14, { marginLeft: 6 }]}>使用优惠价:</Text>
                </TouchableOpacity>
                <View
                    style={[styles.infoItemright, { flexDirection: 'row', alignItems: 'center' }]}
                >
                    <TextInput value={youhuiPrice} textAlign='right' style={{ flex: 1 }} onChangeText={this.changeyouhuiPrice} />
                    <Text style={styles.c7f14}>元</Text>
                </View>
            </View> */}
        <View style={styles.infoItem}>
          <View style={{ flex: 4 }}><Text style={styles.c2f14}>修改原因:</Text></View>
          <View style={[styles.infoItemright, { alignItems: 'flex-end' }]}>
            <TextInput
              placeholder="请输入修改原因"
              textAlign="right"
              style={styles.c7f14}
              value={reson}
              returnKeyLabel="确定"
              returnKeyType="done"
              onChangeText={(val) => { this.setState({ reson: val }); }} />
          </View>
        </View>
      </View>
    );
  }

  render() {
    const { navigation, orderDetail } = this.props;
    const {
      title, modalVisible, showCountDown, isOrigiPrice, youhuiPrice, reson, ischangefreight, isUpdate, timeVisibleForm, confirmModifyPostVisible,
    } = this.state;
    const {
      orderStatus, timedate, endtime, isSelfLifting, freight, hasWuliu, orderId, address, phone, resmoney,
      createdAt, totalMoney, data, remark,subPhone,
      price, pPrice, pPayPirce, money, discountName, discountMoney, isAll, updatedAt,
      taskTime, chooseKightData, getSomeData, editorble, bcleGoodsType, isStockCenter,
      shopId, isGoodsTakeOut, totalVoucher, totalShopVoucher, refundXfq, refundXfqs,
    } = orderDetail || {};
    console.log('orderStatus', data, orderStatus, ischangefreight);
    const topTitleData = ORDER_STATUS_ONLINE_DESCRIBE[orderStatus];
    let topHeight = 94;
    if (!topTitleData || !topTitleData.tips) { topHeight = 66; }
    const countdown = this.getCountDown(orderStatus, taskTime, updatedAt);
    let ispostFee = '运费';
    let postFeeStyle = styles.infoItem;
    let freightPost = freight;
    let pickupWay = '';
    if (isSelfLifting === 1) {
      pickupWay = '到店取货';
      ispostFee = '';
      postFeeStyle = { height: 0 };
      freightPost = 0;
    } else {
      pickupWay = '外卖上门';
    }
    let endtimestr = endtime || '';
    const tieIndex = endtimestr.indexOf(' ');
    endtimestr = endtimestr.substring(tieIndex + 1);
    let rightView = null;
    let isClosed = false; // 订单是否已关闭
    if (countdown !== -1 && (orderStatus === ORDER_STATUS_ONLINE.STAY_ORDER || orderStatus === ORDER_STATUS_ONLINE.STAY_PAY || orderStatus === ORDER_STATUS_ONLINE.STAY_EVALUATE)) {
      showCountDown && countdown > 0 ? null : orderStatus == ORDER_STATUS_ONLINE.STAY_EVALUATE ? null : isClosed = true;
    }
    if (orderStatus === ORDER_STATUS_ONLINE.STAY_ORDER && !isClosed) {
      rightView = (
        <View style={{ width: 50, height: '100%' }}>
          <TouchableOpacity
            style={{
              position: 'absolute', left: -50, width: 100, height: '100%', justifyContent: 'center', alignItems: 'center',
            }}
            onPress={() => {
              navigation.navigate('EditorMenu', {
                serviceCatalogCode: isGoodsTakeOut ? '1004' : '1005',
                shopId,
                serviceData: JSON.parse(JSON.stringify(data)),
                addsServiceGoodsData: this.addsServiceGoodsData,
                callback: () => this.setState({ isUpdate: true }),
              });
            }}
          >
            <Text style={{ color: '#FFFFFF', fontSize: 17 }}>修改订单</Text>
          </TouchableOpacity>
        </View>
      );
    }

    return (
      <View style={styles.container}>
        <Header
          navigation={navigation}
          leftView={(
            <TouchableOpacity
              style={[styles.headerItem, styles.left]}
              onPress={() => {
                const { navigation } = this.props;
                const params = navigation.state.params || {};
                if (params.initData) params.initData();
                navigation.goBack();
              }}
            >
              <Image source={require('../../../images/mall/goback.png')} />
            </TouchableOpacity>
          )}
          title={title || '订单详情'}
          rightView={rightView}
        />

        {
          chooseKightData ? (
            this.renderKightStatus()
          ) : (
              <View style={[styles.topState, { height: topHeight, marginBottom: 10 }]}>
                <View style={[styles.topItem, { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }]}>
                  <Text style={{ color: '#222222', fontSize: 21 }}>{isClosed ? '已关闭' : topTitleData ? topTitleData.name : ''}</Text>
                  <Image source={tuiKuan} style={{ width: getwidth(28), height: getwidth(28) }} />
                </View>
                {
                  topTitleData && topTitleData.tips ? this.renderTitleTips(topTitleData, orderStatus, showCountDown, countdown, orderStatus === ORDER_STATUS_ONLINE.STAY_ORDER ? createdAt : updatedAt, isGoodsTakeOut, isSelfLifting) : null
                }
              </View>
            )
        }


        <ScrollView
          style={styles.scrollList}
          showsVerticalScrollIndicator={false}
          refreshControl={(
            <RefreshControl
              refreshing={this.state.refreshing}
              onRefresh={() => this.initDataDidMount()}
            />
          )}
        >
          <View style={styles.infoView}>
            <View style={styles.infoItem}>
              <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>订单编号</Text></View>
              <View><Text style={styles.c2f14}>{orderId}</Text></View>
            </View>
            <View style={[styles.infoItem]}>
              {
                (<View style={{ flexDirection: 'row', justifyContent: 'space-between', width: '100%' }}>
                  <View style={{ width: getwidth(160) }}><Text style={styles.c7f14}>{!isGoodsTakeOut ? '在线购物' : '外卖上门/到店取货'}</Text></View>
                  <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                    <Text style={styles.c2f14}>{isGoodsTakeOut ? pickupWay : '在线购物'}</Text>
                    {
                      orderStatus === ORDER_STATUS_ONLINE.PROCESS_CENTRE && pickupWay == '外卖上门' && (
                        chooseKightData ? (
                          null
                        ) : (
                            <TouchableOpacity
                              disabled={editorble}
                              onPress={this.inputWuliu}
                              style={{
                                width: 72, borderColor: '#0A5FDA', borderWidth: 1, borderRadius: 6, alignItems: 'center',
                              }}
                            >
                              <Text style={{ color: '#0A5FDA' }}>{hasWuliu ? '查看物流' : '选择物流'}</Text>
                            </TouchableOpacity>
                          )
                      )
                    }
                  </View>
                </View>)
              }
            </View>
            <View style={styles.infoItem}>
              <View style={{ width: getwidth(120) }}><Text style={styles.c7f14}>预约送货/取货时间</Text></View>
              {
                orderStatus === ORDER_STATUS_ONLINE.STAY_ORDER && !isClosed ? (
                  // <View style={{ flexDirection: 'row', justifyContent: 'flex-end', width: getwidth(325 - 120) }}>
                  //     <TouchableOpacity
                  //         onPress={() => this.chooseTime('timedate')}
                  //         style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}
                  //     >
                  //         <Text style={styles.c2f14}>{timedate}</Text>
                  //         <Image source={editoricon} style={{ marginLeft: 4 }} />
                  //     </TouchableOpacity>
                  //     <TouchableOpacity
                  //         onPress={() => this.chooseTime('endtime')}
                  //         style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}
                  //     >
                  //         <Text style={styles.c2f14}> --- {endtimestr}</Text>
                  //         <Image source={editoricon} style={{ marginLeft: 4 }} />
                  //     </TouchableOpacity>
                  // </View>
                  <TouchableOpacity
                    onPress={() => this.setState({
                      timeVisible: true,
                      timeVisibleForm: {
                        date: timedate && timedate.split(' ')[0],
                        time: timedate && endtimestr && (`${timedate.split(' ')[1]}-${endtimestr.split(' '[1])}`),
                      },
                    })}
                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}
                  >
                    <Text style={styles.c2f14}>
                      {' '}
                      {timedate}
                      {' '}
                      ---
                                      {' '}
                      {endtimestr}
                    </Text>
                    <Image source={editoricon} style={{ marginLeft: 4 }} />
                  </TouchableOpacity>
                ) : (
                    <Text style={styles.c2f14}>
                      {timedate}
                      {' '}
                      ---
                                    {' '}
                      {endtimestr}
                    </Text>
                  )
              }
            </View>
            {
              isSelfLifting !== 1
              && (
                <View style={[styles.infoItem, { height: 88 }]}>
                  <View style={{ width: getwidth(120) }}><Text style={styles.c7f14}>送货地址</Text></View>
                  <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'flex-end' }}>
                    <Text style={styles.c2f14}>{address}</Text>
                  </View>
                </View>
              )
            }
            <View style={styles.infoItem}>
              <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>预约手机</Text></View>
              <View><Text style={styles.c2f14}>{subPhone}</Text></View>
            </View>
            {
              isSelfLifting === 1 ? null
                : (
                  <View style={postFeeStyle}>
                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>{ispostFee}</Text></View>
                    <Text style={styles.c2f14}>
                      ￥
                                    {keepTwoDecimal(freight)}
                    </Text>
                  </View>
                )
            }
            {
              // 只有服务 服务加购 才能修改价格
              isUpdate && !isClosed && topTitleData && topTitleData.name == '待接单'
              && this.renderStayOrderForm(orderStatus, isOrigiPrice, youhuiPrice, reson, price)
            }
            <View style={styles.infoItem}>
              <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>备注</Text></View>
              <View style={{ flex: 1, alignItems: 'flex-end' }}><Text style={[styles.c2f14]}>{remark}</Text></View>
            </View>
            <View style={styles.infoItem2}>
              <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>下单时间</Text></View>
              <View><Text style={styles.c2f14}>{moment(createdAt * 1000).format('YYYY-MM-DD HH:mm')}</Text></View>
            </View>
          </View>
          <OrderGoodsCard style={{ marginTop: 10 }} isShouhou={this.isShouhou} orderDetail={orderDetail} />
          {
            this.isShouhou && (
              <View>
                <View style={[styles.infoView, { marginTop: 10 }]}>
                  <View style={[styles.infoItem, {
                    flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4,
                  }]}
                  >
                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>现金退款</Text></View>
                    <Text style={styles.credf14}>
                      ¥
                        {keepTwoDecimal(math.divide(math.add(Number(money) + Number(pPayPirce)),100) )}
                    </Text>
                  </View>
                  <View style={[styles.infoItem, {
                    flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4,
                  }]}
                  >
                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>商家券退款</Text></View>
                    <Text style={styles.c2f14}>{keepTwoDecimal(math.divide(isAll === 'YES' && isStockCenter ? totalShopVoucher : refundXfqs, 100))}</Text>
                  </View>
                  <View style={[styles.infoItem, {
                    flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4,
                  }]}
                  >
                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>消费券退款</Text></View>
                    <Text style={styles.c2f14}>{keepTwoDecimal(math.divide(isAll === 'YES' && isStockCenter ? totalVoucher : refundXfq, 100))}</Text>
                  </View>
                  {
                    isAll === 'YES' && (
                      <View style={[styles.infoItem2, {
                        flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4,
                      }]}
                      >
                        <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>卡券退款</Text></View>
                        <Text style={styles.credf14}>{keepTwoDecimal(math.divide(discountMoney , 100) )}</Text>
                      </View>
                    )
                  }
                </View>
              </View>
            )
          }
        </ScrollView>
        {
          this.renderBtttomBtn(isClosed)
        }
        <ModalDemo
          title="取消派单后，骑手订单将无法恢复"
          confirmText="取消派单"
          visible={modalVisible}
          titleStyle={{ width: (width - 105) * 0.8 }}
          onConfirm={this.cancelWuliuOrder}
          onClose={() => { this.setState({ modalVisible: false }); }}
          type="confirm"
        />
        <ModalDemo
          noTitle
          type="confirm"
          title="当前使用自行配送，要修改配送方式吗？"
          leftBtnText="取消"
          rightBtnText="去修改"
          visible={confirmModifyPostVisible}
          titleStyle={{ width: (width - 105) * 0.8 }}
          onConfirm={() => this.inputWuliu(1)}
          onClose={() => { this.setState({ confirmModifyPostVisible: false }); }}
        />
        <TimeSelectModal
          visible={this.state.timeVisible}
          onClose={() => this.setState({ timeVisible: false })}
          {...timeVisibleForm}
          onChange={value => this.setState({ timeVisibleForm: value })}
          onConfirm={(date, time) => this.chooseTime(date, time)}
        />
      </View>
    );
  }
}
export default connect(
  state => ({
    orderDetail: state.order.orderDetail,
    shopId: state.user.userShop.id,
  }), {
    fetchOBMBcleOrderDetails: (orderId, orderNo, isShouhou, nosure) => ({
      type: 'order/fetchOBMBcleOrderDetails',
      payload: {
        orderId, orderNo, isShouhou, nosure,
      },
    }),
    changeOBMBcleOrderDetail: formData => ({ type: 'order/changeOBMBcleOrderDetail', payload: formData }),
  },
)(GoodsTakeOut);

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    alignItems: 'center',
    backgroundColor: CommonStyles.globalBgColor,
  },
  rowBack: {
    width: getwidth(68),
    height: '100%',
    backgroundColor: '#EE6161',
    justifyContent: 'center',
    alignItems: 'center',
    position: 'absolute',
    right: 6,
    top: 0,
  },
  infoItemright: {
    flex: 8,
    flexDirection: 'row',
    justifyContent: 'flex-end',
    alignItems: 'center',
  },
  sweepBtn: {
    width,
    height: 50,
    borderTopColor: '#F1F1F1',
    borderTopWidth: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#fff',
  },
  headerItem: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
  },
  left: {
    width: 50,
  },
  credf34: {
    color: '#EE6161',
    fontSize: 34,
  },
  lurWuliu: {
    width: getwidth(60),
    height: 24,
    borderColor: '#4A90FA',
    borderWidth: 1,
    borderRadius: 6,
    justifyContent: 'center',
    alignItems: 'center',
    marginLeft: 6,
  },
  topState: {
    width: getwidth(355),
    backgroundColor: '#fff',
    borderRadius: 6,
    marginTop: 10,
    paddingHorizontal: 15,
    paddingVertical: 15,
  },
  topItem: {
    flex: 1,
  },
  c0f17: {
    color: '#000000',
    fontSize: 17,
  },
  c7f14: {
    color: '#777777',
    fontSize: 14,
  },
  c2f14: {
    color: '#222222',
    fontSize: 14,
  },
  c2f17: {
    color: '#222222',
    fontSize: 17,
  },
  c7f12: {
    color: '#777777',
    fontSize: 12,
  },
  c2f12: {
    color: '#222222',
    fontSize: 12,
  },
  ccf10: {
    color: '#CCCCCC',
    fontSize: 10,
  },
  credf14: {
    color: '#EE6161',
    fontSize: 14,
  },
  cbf14: {
    color: '#4A90FA',
    fontSize: 14,
  },
  cf14: {
    color: '#fff',
    fontSize: 14,
  },
  cgreenF14: {
    color: '#46D684',
    fontSize: 14,
  },
  cyellowF14: {
    color: '#FA994A',
    fontSize: 14,
  },
  orderCode: {
    width: getwidth(355),
    height: 89,
    backgroundColor: '#fff',
    borderRadius: 6,
    marginTop: 11,
    paddingHorizontal: 15,
  },
  orderCodeItem: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  scrollList: {
    width: getwidth(355),
    flex: 1,
    borderRadius: 6,
    overflow: 'hidden',
    marginBottom: 60 + CommonStyles.footerPadding,
  },
  servicView: {
    width: getwidth(355),
    paddingHorizontal: 15,
    backgroundColor: '#fff',
    borderRadius: 6,
    overflow: 'hidden',
  },
  serviceTitle: {
    width: getwidth(325),
    height: 50,
    borderBottomColor: '#D7D7D7',
    borderBottomWidth: 1,
    justifyContent: 'center',
  },
  serviceTitle2: {
    width: getwidth(325),
    height: 50,
    borderBottomColor: '#D7D7D7',
    borderBottomWidth: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  serviceItem: {
    width: getwidth(325),
    height: 110,
    flexDirection: 'row',
    backgroundColor: '#fff',
  },
  borderBt: {
    borderBottomColor: '#D7D7D7',
    borderBottomWidth: 0.5,
  },
  serviceItemimg: {
    width: getwidth(80),
    height: 110,
    justifyContent: 'center',
    alignItems: 'center',
  },
  textItem: {
    width: '100%',
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  infoView: {
    width: getwidth(355),
    // marginTop: 10,
    paddingHorizontal: 15,
    backgroundColor: '#fff',
    borderRadius: 6,
  },
  infoItem: {
    width: getwidth(325),
    height: 44,
    borderBottomColor: '#D7D7D7',
    borderBottomWidth: 0.5,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  infoItem2: {
    width: getwidth(325),
    height: 44,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  serviceBottom: {
    width: getwidth(355),
    height: 170,
    borderTopColor: '#D7D7D7',
    borderTopWidth: 0.5,
    borderRadius: 6,
    overflow: 'hidden',
  },
  serviceBottomItem: {
    width: getwidth(325),
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  bottomBtn: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    width: getwidth(375),
    paddingBottom: CommonStyles.footerPadding,
    height: 50 + CommonStyles.footerPadding,
    flexDirection: 'row',
  },
  kefu: {
    flex: 1,
    height: 50,
    backgroundColor: '#fff',
    justifyContent: 'center',
    paddingLeft: 15,
  },
  fixedWidth: {
    width: getwidth(105),
    height: 50,
    justifyContent: 'center',
    alignItems: 'center',
  },
});
