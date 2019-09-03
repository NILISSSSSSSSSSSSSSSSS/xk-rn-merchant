/**
 * 服务+现场点单-待接单订单
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
  TouchableOpacity,
  TextInput,
  TouchableHighlight,
  KeyboardAvoidingView,
  Modal,
} from 'react-native';
import { connect } from 'rn-dva';
import moment from 'moment';
import CommonStyles from '../../../common/Styles';
import Header from '../../../components/Header';
import * as orderRequestApi from '../../../config/Apis/order';
import math from '../../../config/math';
import * as regular from '../../../config/regular';
import { NavigationComponent } from '../../../common/NavigationComponent';
import { keepTwoDecimal } from '../../../config/utils';
import PriceInputView from '../../../components/PriceInputView';
const add = require('../../../images/shopOrder/add.png');
import Toast from '../../../components/Toast';
const checked = require('../../../images/mall/checked.png');
const unchecked = require('../../../images/mall/unchecked.png');
const service = require('../../../images/shopOrder/service.png');
const close = require('../../../images/shopOrder/close.png');

const { width, height } = Dimensions.get('window');

function getwidth(val) {
  return width * val / 375;
}

export default class ChooseCalculateGoods extends NavigationComponent {
  constructor(props) {
    super(props);
    this.state = {
      data: [],
      isAllChecked: false,
      confirmSettlement: false,
      useYouHui: false, // 是否使用优惠
      youHuiPrice: 0,
      updataSettlement: (props.navigation.state.params || {}).updataSettlement || false,
      res: {}
    };
  }

  blurState = {
    confirmSettlement: false,
  }

  componentDidMount() {
    const { orderId } = this.props.navigation.state.params;
    orderRequestApi.fetchBcleOBMOrderStayClearingAppDetail({ orderId }).then((res) => {
      let data = [];
      let useYouHui = false;
      let youHuiPrice = 0;
      if (res.goods) {
        res.goods.forEach((item) => {
          if (item.goods) {
            data = data.concat(item.goods);
          }
        });
      }
      // let totalMoney = 0;
      // let platMoney = 0;
      // data.forEach((item) => {
      //   totalMoney += item.platformPrice;
      //   platMoney += item.platformShopPrice;
      // });
      // if (totalMoney !== platMoney) {
      //   useYouHui = true;
      //   youHuiPrice = Number(totalMoney - platMoney) / 100;
      // }
      this.setState({
        data,
        useYouHui,
        youHuiPrice,
        res
      });
    }).catch(err => {
      console.log(err)
    });
  }

  changeChoose = (index) => {
    const { data } = this.state;
    data[index].isChoose = !data[index].isChoose;
    let flag = false;
    data.find((item) => {
      if (!item.isChoose) {
        flag = true;
        return true;
      }
    });
    if (flag) {
      this.setState({
        data,
        isAllChecked: false,
      });
    } else {
      this.setState({
        data,
        isAllChecked: true,
      });
    }
  }

  toggleAllChecked = () => {
    const { isAllChecked, data } = this.state;
    data.forEach((item) => {
      item.isChoose = !isAllChecked;
    });
    this.setState({
      isAllChecked: !isAllChecked,
      data,
    });
  }
  getServiceMoney = (orderStatus) => {
    let total = 0
    const { res, page } = this.state
    console.log('res', res, res.goods)
    if (res.goods) {
      res.goods.map((item, index) => {
        let price = item.payStatus != 'SUCCESS_PAY' ? item.platformPrice : 0
        total = total + price
      })
    }
    console.log('total', total)
    return total
  }

  getTotalMoney = (witch) => {
    const { data } = this.state;
    let totalMoney = 0;
    const { page, orderStatus } = this.props.navigation.state.params
    witch == 'total' ? totalMoney = this.getServiceMoney(orderStatus) : null
    console.log(witch)
    data.forEach((item) => {
      if (witch == 'total') {
        item.isChoose ? totalMoney += item.platformPrice : null;
      } else if (witch == 'paid') {
        item.payStatus === 'SUCCESS_PAY' ? totalMoney += item.platformPrice : null;
      }
      else {
        item.payStatus != 'SUCCESS_PAY' && item.isChoose ? totalMoney += item.platformPrice : null;
      }
    });
    return keepTwoDecimal(totalMoney);
  }

  renderItem = () => {
    const { data } = this.state;
    return data.map((item, index) => (
      <View style={styles.listItem} key={index}>
        <TouchableOpacity
          onPress={() => {
            this.changeChoose(index);
          }}
          style={styles.checkedView}
        >
          <Image source={item.isChoose ? checked : unchecked} />
        </TouchableOpacity>
        <View style={styles.listItemImg}>
          <Image source={{ uri: item.goodsSkuUrl || '' }} style={{ width: getwidth(80), height: getwidth(80) }} />
        </View>
        <View style={styles.listItemRight}>
          <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
            <View><Text style={styles.c2f14}>{item.name}</Text></View>
            <View><Text style={styles.c2f12}>{item.payStatus === 'SUCCESS_PAY' ? '已付款' : ''}</Text></View>
          </View>
          <View style={{ marginTop: 13 }}><Text style={styles.c7f12}>{item.goodsSkuName}</Text></View>
          <View style={{ flexDirection: 'row', justifyContent: 'flex-end', alignItems: 'center', marginTop: 20 }}>
            <Text style={styles.credf14}>
              ￥{keepTwoDecimal(item.platformPrice / 100)}
            </Text>
            <Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}>
              {' '}市场价 ￥{keepTwoDecimal(item.originalPrice / 100)}
            </Text>
          </View>
        </View>
      </View>
    ))
  }

  saveData = () => {
    const { navigation } = this.props;
    const { initDataDidMount, orderId, shopId, page } = navigation.state.params;
    const { data, youHuiPrice, useYouHui } = this.state;
    const param = {
      mUserClearing: {
        orderId,
        shopId,
        purchaseOrderIds: [],
      },
    };
    data.forEach((item) => {
      item.isChoose ? param.mUserClearing.purchaseOrderIds.push(item.purchaseId) : null;
    });
    if (useYouHui && youHuiPrice) {
      param.mUserClearing.payAmount = parseFloat(youHuiPrice) * 100;
    } else {
      param.mUserClearing.payAmount = 0;
    }
    orderRequestApi.fetchBcleMUserConfirmClearing(param).then((res) => {
      this.setState({ confirmSettlement: false });
      if (initDataDidMount) {
        initDataDidMount(orderId);
      }
      page == 'offline' ?
        this.props.navigation.navigate('OrderQrcode', { orderId, initDataDidMount }) :
        navigation.goBack();
    }).catch((err)=>{
      console.log('err1',err)
      if(err && err.message){
        this.Toast.show(err.message)
      }
    });
  }

  changeUseYouhui = (val) => {
    let useYouHui = false;
    if (val === 1) {
      useYouHui = true;
    } else {
      useYouHui = false;
    }
    this.setState({
      useYouHui,
    });
  }

  changeYouHuiPrice = (val) => {
    this.setState({
      youHuiPrice: val,
    });
  }
  getPrices = () => {
    const { initDataDidMount, orderId, shopId, page } = this.props.navigation.state.params;
    const { youHuiPrice, useYouHui } = this.state;
    let finalMoney = useYouHui ?
      math.divide((this.getTotalMoney('pay') - math.multiply(parseFloat(youHuiPrice), 100)), 100) :
      math.divide(this.getTotalMoney('pay'), 100); // 最终金额
    // const waitPay=page=='offline'?math.divide(this.getTotalMoney('total')-this.getTotalMoney('paid'),100) :this.getTotalMoney('pay') / 100
    const waitPay = math.divide(this.getTotalMoney('total') - this.getTotalMoney('paid'), 100)
    // if(page=='offline'){
    finalMoney = useYouHui ? waitPay - (youHuiPrice || 0) : waitPay
    // }
    return {
      waitPay,//待结算金额
      finalMoney,//最终金额,
      totalMoney: math.divide(this.getTotalMoney('total'), 100),//总金额
      // paidMoney:math.divide(this.getTotalMoney(page=='offline'?'paid':'pay') , 100) //实际支付
      paidMoney: math.divide(this.getTotalMoney('paid'), 100) //实际支付
    }
  }

  checked = (callback = () => { }) => {
    const { youHuiPrice, useYouHui, res, data, page } = this.state;
    // if (useYouHui) {
    //   const { waitPay, finalMoney } = this.getPrices()
    //   let message = '';
    //   if (!regular.price(youHuiPrice) || parseFloat(youHuiPrice) == 0) {
    //     message = '请输入正确格式的优惠金额,且优惠金额不能为0';
    //   }
    //   if (youHuiPrice < 0) {
    //     message = '优惠金额不能为负数';
    //   }
    //   if (waitPay < youHuiPrice) {
    //     message = '优惠金额不能超过待结算金额';
    //   }
    //   if (waitPay == youHuiPrice) {
    //     message = '优惠金额不能等于待结算金额';
    //   }
    //   const serviceLength = (res.goods || []).filter(item => item = item.payStatus != 'SUCCESS_PAY').length
    //   const allLength = serviceLength + ((data.filter(item => item.isChoose)).length)
    //   if (youHuiPrice - parseInt(youHuiPrice) != 0 && youHuiPrice - parseInt(youHuiPrice) < math.divide(allLength, 100)) {
    //     message = '优惠金额小数部分不能小于0.0' + allLength;
    //   }
    //   if (message) {
    //     this.Toast && this.Toast.show(message)
    //     return;
    //   }
    // }
    typeof (callback) === 'function' ? callback() : null;
  }

  render() {
    const { navigation } = this.props;
    const { isAllChecked, confirmSettlement, useYouHui, youHuiPrice } = this.state;
    const { initDataDidMount, orderId, shopId, page } = this.props.navigation.state.params;
    const { waitPay, finalMoney, totalMoney, paidMoney } = this.getPrices()
    return (
      <View style={styles.container}>
        <Header
          navigation={navigation}
          goBack
          title="选择结算商品"
        />
        <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
          <View style={styles.topView}>
            <View style={styles.topLeftView}>
              <Text style={styles.c2f14}>商品</Text>
            </View>
          </View>
          {
            this.renderItem()
          }
        </ScrollView>
        <View style={styles.totlaView}>
          <View style={styles.btnItem}>
            <View><Text style={styles.c7f14}>总金额：</Text></View>
            <View>
              <Text style={styles.credf14}>￥{totalMoney}</Text>
            </View>
          </View>
          <View style={styles.btnItem}>
            <View><Text style={styles.c7f14}>实际支付：</Text></View>
            <View>
              <Text style={styles.credf14}>￥{paidMoney}</Text>
            </View>
          </View>
        </View>
        <View style={styles.bottomBtn}>
          <TouchableOpacity
            onPress={this.toggleAllChecked}
            style={{ flex: 1, flexDirection: 'row', alignItems: 'center', paddingLeft: 20 }}
          >

            <Image source={isAllChecked ? checked : unchecked} />
            <Text>  全选</Text>
          </TouchableOpacity>

          <TouchableOpacity
            onPress={() => {
              // this.getTotalMoney('total')?
              this.setState({ confirmSettlement: true });
              // :Toast.show('请选择结算商品')
            }}
            style={styles.btnright}
          >
            <Text style={styles.cf14}>确认结算</Text>
          </TouchableOpacity>
        </View>

        <Modal
          animationType="fade"
          transparent
          visible={confirmSettlement}
          onRequestClose={() => { this.setState({ confirmSettlement: false }); }}
        >
          <KeyboardAvoidingView behavior="padding" enabled={false} >
            <ScrollView style={{ backgroundColor: 'rgba(0,0,0,0.5)' }}>
              <View style={{ width, height, justifyContent: 'flex-end' }}>
                <View style={{ backgroundColor: '#fff', paddingBottom: CommonStyles.footerPadding + 10 }}>
                  <View style={{ width, height: 51, flexDirection: 'row', borderBottomColor: '#F1F1F1', borderBottomWidth: 1 }}>
                    <View style={{ width: width - getwidth(120), marginLeft: getwidth(60), height: 51, justifyContent: 'center', alignItems: 'center', }}>
                      <Text style={styles.c0f17}>最终金额</Text>
                    </View>
                    <TouchableOpacity
                      onPress={() => { this.setState({ confirmSettlement: false }); }}
                      style={{ width: getwidth(60), height: 51, justifyContent: 'center', alignItems: 'center' }}
                    >
                      <Image source={close} />
                    </TouchableOpacity>
                  </View>
                  <Text style={[styles.c7f14, { marginTop: 26, textAlign: 'center' }]}>待结算金额：￥{waitPay}</Text>
                  <View style={{ width, height: 36, flexDirection: 'row', alignItems: 'center', marginTop: 20 }}>
                    <TouchableOpacity
                      onPress={() => { this.changeUseYouhui(1); }}
                      style={{ width: getwidth(44), height: 36, justifyContent: 'center', alignItems: 'flex-end', marginLeft: getwidth(70) }}
                    >
                      <Image source={useYouHui ? checked : unchecked} />
                    </TouchableOpacity>
                    <Text style={[styles.c2f14, { marginLeft: 6 }]}>优惠金额</Text>
                    <View style={{ flex: 1, flexDirection: 'row', alignItems: 'center', marginLeft: 6 }}>
                      <View style={{ width: getwidth(90), height: 44, borderColor: '#CCCCCC', borderWidth: 1, borderRadius: 6, justifyContent: 'center', paddingRight: 5, }}>
                        <PriceInputView
                          // keyboardType="decimal-pad"
                          returnKeyLabel="确认"
                          returnKeyType="done"
                          rejectResponderTermination
                          value={(youHuiPrice || '').toString()}
                          onChangeText={this.changeYouHuiPrice}
                          onBlur={this.checked}
                          textAlign="right"
                        />
                      </View>
                      <Text style={[styles.c7f14, { marginLeft: 5 }]}>元</Text>
                    </View>
                  </View>

                  <View style={{ width, height: 36, flexDirection: 'row', alignItems: 'center', marginTop: 10, }} >
                    <TouchableOpacity
                      onPress={() => { this.changeUseYouhui(-1); }}
                      style={{ width: getwidth(44), height: 36, justifyContent: 'center', alignItems: 'flex-end', marginLeft: getwidth(70) }}
                    >
                      <Image source={useYouHui ? unchecked : checked} />
                    </TouchableOpacity>
                    <Text style={[styles.c2f14, { marginLeft: 6 }]}>不使用优惠</Text>
                  </View>

                  <View style={{ width, height: 44, flexDirection: 'row', justifyContent: 'center', marginTop: 10, }} >
                    <View style={{ justifyContent: 'center' }}>
                      <Text style={styles.credf34}>￥{keepTwoDecimal(finalMoney)} </Text>
                    </View>
                    <View style={{ justifyContent: 'flex-end', marginLeft: 6 }}>
                      <Text style={styles.c7f12}>最终金额</Text>
                    </View>
                  </View>
                  <TouchableOpacity
                    onPress={() => this.checked(() => this.saveData())}
                    style={{ width, height: 50, backgroundColor: '#4A90FA', justifyContent: 'center', alignItems: 'center', marginTop: 20 }}
                  >
                    <Text style={[styles.cf17, { color: '#fff' }]}>确定</Text>
                  </TouchableOpacity>
                </View>
              </View>
            </ScrollView>
          </KeyboardAvoidingView>
          <Toast
            ref={(e) => {
              e && (this.Toast = e);
            }}
            position="center"
          />
        </Modal>
      </View >
    );
  }
}
const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    alignItems: 'center',
    backgroundColor: CommonStyles.globalBgColor,
  },
  scrollView: {
    width: getwidth(355),
    borderRadius: 8,
    backgroundColor: '#fff',
    marginTop: 10,
    paddingHorizontal: 15,
    flex: 1,
  },
  topView: {
    width: getwidth(325),
    height: 50,
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  topLeftView: {
    width: getwidth(100),
    justifyContent: 'center',
    alignItems: 'flex-start',
  },
  topRight: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'flex-end',
    alignItems: 'center',
  },
  credf34: {
    color: '#EE6161',
    fontSize: 34,
  },
  cbf14: {
    color: '#4A90FA',
    fontSize: 14,
  },
  c2f14: {
    color: '#222222',
    fontSize: 14,
  },
  c0f17: {
    color: '#000000',
    fontSize: 17,
  },
  c2f12: {
    color: '#222222',
    fontSize: 12,
  },
  c7f12: {
    color: '#777777',
    fontSize: 12,
  },
  c7f14: {
    color: '#777777',
    fontSize: 14,
  },
  credf14: {
    color: '#EE6161',
    fontSize: 14,
  },
  ccf10: {
    color: '#CCCCCC',
    fontSize: 10,
  },
  cf14: {
    color: '#FFFFFF',
    fontSize: 14,
  },
  listItem: {
    width: getwidth(325),
    height: 110,
    flexDirection: 'row',
    borderTopColor: '#D7D7D7',
    borderTopWidth: 1,
  },
  checkedView: {
    width: getwidth(29),
    height: 110,
    justifyContent: 'center',
    alignItems: 'flex-start',
  },
  listItemImg: {
    width: getwidth(80),
    height: 110,
    marginLeft: 0,
    justifyContent: 'center',
    alignItems: 'center',
  },
  listItemRight: {
    height: 110,
    flex: 1,
    marginLeft: 15,
    justifyContent: 'center',
  },
  totlaView: {
    width: getwidth(355),
    paddingHorizontal: 15,
    height: 73,
    borderTopColor: '#D7D7D7',
    borderRadius: 8,
    borderTopWidth: 1,
    backgroundColor: '#fff',
    marginBottom: 20,
  },
  btnItem: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  bottomBtn: {
    width,
    height: 50,
    flexDirection: 'row',
    justifyContent: 'space-between',
    backgroundColor: '#fff',
    marginBottom: CommonStyles.footerPadding,
  },
  btnright: {
    width: getwidth(105),
    height: 50,
    backgroundColor: '#4A90FA',
    justifyContent: 'center',
    alignItems: 'center',
  },
});
