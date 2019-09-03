/**
 * 自营商城确认订单
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  Platform,
  StatusBar,
  View,
  Text,
  TextInput,
  Keyboard,
  TouchableOpacity,
  Image,
  Button,
  Modal,
  ImageBackground,
  ScrollView,
} from 'react-native';
import { connect } from 'rn-dva';
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import * as requestApi from '../../config/requestApi';
import ImageView from '../../components/ImageView';
const unchecked = require('../../images/mall/unchecked.png')
const checked = require('../../images/mall/checked.png')
const { width, height } = Dimensions.get('window');
import { getPreviewImage, debounce, getSalePriceText } from '../../config/utils';
import  math from "../../config/math.js";
import * as Address from '../../const/address';

class SOMOrderConfirmScreen extends Component {
  static navigationOptions = {
      header: null,
  }
  _didFocusSubscription;
  isClickOrderPay = false
  constructor(props) {
      super(props)
      this._didFocusSubscription = props.navigation.addListener('didFocus', async (payload) => {
          console.log('SOMOrderConfirmScreen.didFocus', payload);
          this.state.isRefresh && this.getData(); // 去地址页面不刷新，因为会清空优惠券数据
          this.state.isRefresh && this.merchantDefaultInvoice() // 获取发票

      });
      this.handleDebouncePayFlow = debounce(this.handlePayFlow)
      this.invoiceId = ''
      this.state = {
          goodsList: props.navigation.state.params && props.navigation.state.params.goodsList || [],
          modalVisible: false,
          remarkText: '',
          // totalPrice: 0,
          postAmount: 0,  // 运费
          adress: null,
          youHuiQuan: null,   //订单可以使用的优惠券
          youhuiQuanVisible: false,
          useYouHuiQuan: {
              cardType: '',
              id: ''
          },   //当前正在使用的优惠券
          goodsAmount: '', //需要支付的金额
          fapiao: '',
          orderId: '', // 订单id传入支付密码页面
          confimVis: false, // 没有设置密码弹窗
          cashier: {}, // 收银台
          height: 0, // 备注文本框自动高度
          yhqIndex: null,
          isRefresh: true, // 是否需要刷新
      }
  }
  mallOrderMUserValidateAmount = (youHuiQuan, adress, callBack = () => { }) => {
      let goodsList = this.props.navigation.getParam('goodsList', [])
      if (adress) {
          let param = {
              mallOrderValidateAmountParams: {
                  goodsParams: [],
                  addressId: adress.id,
                  userDiscountId: youHuiQuan && youHuiQuan.id
              }
          }
          goodsList.forEach((item) => {
              param.mallOrderValidateAmountParams.goodsParams.push({
                  goodsId: item.goodsId,
                  goodsSum: item.quantity,
                  goodsSkuCode: item.goodsSkuCode
              })
          })
          param.mallOrderValidateAmountParams.discountType = youHuiQuan && youHuiQuan.cardType;
          requestApi.mallOrderMUserValidateAmount(param).then((res) => {
              Loading.hide();
              console.log('计算金额', res)
              if (res) {
                  this.setState({
                      goodsAmount: res.goodsAmount,
                      postAmount: res.postAmount
                  })
              }
              this.isClickOrderPay = false
              if (callBack) {
                  callBack()
              }
          }).catch((res) => {
              Toast.show(res.message, 2000)
              Loading.hide();
          })
        return
      }
      this.setState({
        youhuiQuanVisible: false,
      }, () => {
        Toast.show('请选择收货地址！')
      })
  }
  getDefaultAdressData = (adress) => {
      let [provinceName, cityName, districtName] = Address.getNamesByDistrictCode(adress.districtCode)
      this.setState({
          adress: { ...adress, provinceName, cityName, districtName }
      })
      this.isClickOrderPay = false
  }
  // 选择优惠券
  changeItemcheckedData = (item, index) => {
      this.setState({
          yhq: item,
          yhqIndex: index
      })
  }
  componentDidMount() {
      this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload =>
          this.isClickOrderPay = false
      );
  }
  merchantDefaultInvoice = () => {
      requestApi.merchantDefaultInvoice().then((res) => {
          if (!res) return
          let fapiao = res.head
          this.invoiceId = res.id
          this.setState({
              fapiao
          })
          this.isClickOrderPay = false
      }).catch((res) => {
          Toast.show(res.message)
      })
  }
  getData = () => {
      Loading.show();
      let data = this.props.navigation.getParam('goodsList', [])
      //获取默认地址：   adress
      requestApi.merchantDefault({}, false).then((res) => {
          if (res) {
              this.getDefaultAdressData(res)
              this.setState({
                  yhqIndex: null,
                  useYouHuiQuan: {
                      cardType: '',
                      id: ''
                  }
              }, () => {
                  this.mallOrderMUserValidateAmount(null, res)
              })
              return
          }
          Loading.hide()
          this.isClickOrderPay = false
      }).catch((err)=>{
        console.log(err)
      });
      //获取订单可以使用的优惠券  findUserCoupons
      let params = {
          orderGoods: [],
          merchantId: this.props.userInfo.merchantId
      }
      data.forEach((item) => {
          params.orderGoods.push({
              goodsId: item.goodsId,
              goodsSum: item.quantity,
              goodsSkuCode: item.goodsSkuCode
          })
      })
      // 获取优惠券
      requestApi.findMUserCoupons(params).then((res) => {
          console.log('findMUserCoupons', res)
          if (res) {
              res.forEach((item) => {
                  item.checkedData = 0
              })
              this.setState({
                  youHuiQuan: res
              })
          }
      }).catch((res) => {
          Toast.show(res.message, 2000)
      })
  }
  changeState(key, value) {
      this.setState({
          [key]: value
      });
  }
  componentWillUnmount() {
      this._willBlurSubscription && this._willBlurSubscription.remove();
      this._didFocusSubscription && this._didFocusSubscription.remove();
      Loading.hide();
  }
  // 支付流程
  handlePayFlow = () => {
      console.log('this.state.adress', this.state.adress)
      if (!this.state.adress) {
          Toast.show('请选择地址!')
          Loading.hide();
          return
      }
      this.mallOrderMUserValidateAmount(this.state.useYouHuiQuan, this.state.adress, this.handleCreateAndPay)
  }
  getAdressData = (adress) => {
      console.log('sssss', this.state.useYouHuiQuan)
      this.mallOrderMUserValidateAmount(this.state.useYouHuiQuan, adress)
      this.setState({
          adress
      })
  }
  // DeliveryAddress
  toDeliveryAddress = () => {
      const { navigation } = this.props
      this.setState({
          isRefresh: false,
      }, () => {
          navigation.navigate('DeliveryAddress', { callBack: this.getAdressData, nowAddress: this.state.adress })
      })
  }
  renderAdress = () => {
      const { adress } = this.state
      if (!adress) {
          return (
              <TouchableOpacity
                  style={[styles.contentItem, styles.contentItem1]}
                  onPress={
                      this.toDeliveryAddress
                  }
              >
                  <View style={[styles.content_adr, styles.content_adr1]}>
                      <Image source={require('../../images/mall/address.png')} />
                  </View>
                  <View style={[styles.content_adr, styles.content_adr2]}>
                      <Text style={styles.container_text} numberOfLines={2}>您还没有添加收货地址，请点击右侧按钮，添加一个收货地址</Text>
                  </View>
                  <View style={[styles.content_adr, styles.content_adr1]}>
                      <Image source={require('../../images/mall/goto_gray.png')} />
                  </View>
              </TouchableOpacity>
          )
      } else {
          return (
              <TouchableOpacity
                  style={[styles.contentItem, styles.contentItem1, { alignItems: 'center', paddingVertical: 10, paddingHorizontal: 10 }]}
                  onPress={
                      this.toDeliveryAddress
                  }
              >
                  <View style={styles.adresspng}>
                      <Image source={require('../../images/mall/address.png')} />
                  </View>
                  <View style={{ flex: 1, paddingHorizontal: 10, flexDirection: 'column', justifyContent: 'center' }}>
                      <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', flex: 1, }}>
                          <Text ellipsizeMode='tail' numberOfLines={1} style={{ fontSize: 12, marginRight: 6, flex: 1 }}>收件人：{adress.receiver}</Text>
                          <Text style={{ flex: 1 }}>{adress.phone}</Text>
                      </View>
                      <View style={{ flex: 1 }}>
                          <Text style={{ fontSize: 12, lineHeight: 16 }} numberOfLines={2}>收货地址：{adress.provinceName} {adress.cityName} {adress.districtName} {adress.poiName} {(adress.street || '').replace(/\s+/g,'')}</Text>
                      </View>
                  </View>
                  <View style={styles.adresspng}>
                      <Image source={require('../../images/mall/goto_gray.png')} />
                  </View>
              </TouchableOpacity>
          )
      }
  }
  changeDetailVisible = (one) => {
      const { youHuiQuan } = this.state
      youHuiQuan.find((item) => {
          if (item.cardId === one.cardId) {
              item.detailVisible = !one.detailVisible
              return
          }
      })
      this.setState({
          youHuiQuan
      })
  }
  
  getTotalPrice = () => {
      const { navigation, } = this.props
      let goodsList = navigation.getParam('goodsList', [])
      let totalPrice = 0;
      if (goodsList && goodsList.length > 0 ) {
          goodsList.map(item => {
              totalPrice += item.quantity * item.buyPrice
          })
          console.log('123',goodsList)
          console.log('123',totalPrice)
          return math.divide(totalPrice, 100)
      }
      return totalPrice;
  }
  // 下单，收银台信息
  handleCreateAndPay = () => {
      if (this.isClickOrderPay) return
      this.isClickOrderPay = true;
      const securityCode = this.props.userInfo.securityCode
      let { adress, remarkText, goodsAmount, postAmount, useYouHuiQuan } = this.state
      const { navigation, dispatch} = this.props
      let goodsList = navigation.getParam('goodsList', [])
      let goodsData = goodsList.map(({ goodsId, goodsSkuCode, quantity }, index) => {
          return {
              goodsId,
              goodsSkuCode,
              goodsSum: quantity
          }
      })
      console.log('adress', adress)
      if (!adress) {
          Toast.show('请选择地址')
          Loading.hide();
          return
      }

      Loading.show()
      let param = {
          mallCreateOrderParams: {
              payAmount: goodsAmount + postAmount,
              goodsParams: goodsData,
              // referralCode: securityCode, // 推荐吗不传
              remark: remarkText,
              addressId: adress.id,
              invoiceId: this.invoiceId,
              discountType: useYouHuiQuan.cardType,
              userDiscountId: useYouHuiQuan.id
          }
      }
      // console.log('param',param)
      // return
      requestApi.createOrder(param).then((res) => {
          // 支付订单成功后，跳转收银台
          if (res) {
              this.setState({
                  isRefresh: true,
              })
              this.props.dispatch({ type: 'welfare/save', payload: { cashireGoBackRoute: 'SOMPayResult', cashireGoBackParams: { payFailed: true } } })
              navigation.navigate('SOMCashier', { cashier: res });
          }
          this.isClickOrderPay = false
      }).catch(err => {
          this.isClickOrderPay = false
          console.log(err)
          Toast.show('下单失败，请重试！')
      })

  }
  getFapiaoData = (data) => {
      this.invoiceId = data.id === this.invoiceId ? '' : data.id;
      this.setState({
          fapiao: (data.head === this.state.fapiao) ? '' : data.head
      })
  }
  render() {
    const { navigation } = this.props;
    const { cashier, modalVisible, remarkText, postAmount, youhuiQuanVisible, youHuiQuan, useYouHuiQuan, goodsAmount, fapiao, yhqIndex, adress } = this.state;
    let youhui = '请选择优惠券'
    if (useYouHuiQuan && useYouHuiQuan.id !== '') {
      youhui = useYouHuiQuan.cardName
    }
    let goodsList = navigation.getParam('goodsList', [])
    const allPrice = goodsList[0].goodsDivide === 2 
      ? math.divide(goodsList[0].subscription || 0 , 100) 
      : (adress && adress.id) 
        ?  math.divide (math.add(goodsAmount , postAmount) , 100) 
        : this.getTotalPrice();
    let textHeight = Math.max(38, this.state.height);
    if (textHeight >= 80) {
      textHeight = 80;
    }
    console.log(this.state)
    return (
      <View style={styles.container}>
        <Header
          navigation={navigation}
          goBack={true}
          title={'确认订单'}
        />
        <ScrollView
          showsHorizontalScrollIndicator={false}
          showsVerticalScrollIndicator={false}
          alwaysBounceVertical={false}
          style={styles.contentView}>
          {
            this.renderAdress()
          }

            <View style={[styles.contentItem, styles.contentItem2]}>
              {
                goodsList.length !== 0 && goodsList.map((item, index) => {
                  return (
                    <View key={index} style={styles.content_ord}>
                      <ImageView
                        style={styles.item_shop_img}
                        resizeMode='cover'
                        source={{ uri: getPreviewImage(item.url, '50p') }}
                        sourceWidth={80}
                        sourceHeight={80}
                      />
                      <View style={styles.item_shop_other}>
                        <View style={styles.item_shop_titleView}>
                          <Text style={styles.item_shop_title} numberOfLines={2}>{item.goodsName}</Text>
                        </View>
                        <Text style={styles.item_shop_guige} numberOfLines={1}>规格：{item.goodsAttr} x{item.quantity}</Text>
                        {
                          item.goodsDivide === 2 // 如果是大宗商品
                          ? <Text style={styles.item_shop_price1}>预约金：<Text style={styles.item_shop_price2}>¥{math.divide(item.subscription || 0 , 100)}</Text></Text>
                          : <Text style={styles.item_shop_price1}>价格：<Text style={styles.item_shop_price2}>¥{math.divide(item.buyPrice || 0 , 100)}</Text></Text>
                        }
                      </View>
                    </View>
                  );
                })
              }
              <View style={[CommonStyles.flex_start_noCenter, { paddingHorizontal: 15, borderBottomColor: '#f1f1f1', borderBottomWidth: 1 }]}>
                <Text style={{ paddingVertical: 10, color: '#222' }}>备注留言：</Text>
                <TextInput
                  multiline
                  maxLength={50}
                  returnKeyLabel="确定"
                  returnKeyType="done"
                  style={[{ height: textHeight }, { flex: 1, textAlignVertical: 'top' }]}
                  value={remarkText}
                  onContentSizeChange={(e) => { this.setState({ height: this.state.height + 28 }) }}
                  onChangeText={(text) => {
                    if (text.length >= 50) {
                      Toast.show('最多输入50个字哦')
                      return
                    }
                    this.setState({remarkText: text})
                  }}
                />
              </View>
              {
                goodsList[0].goodsDivide === 2 // 如果是大宗商品
                // true
                ? null
                : <React.Fragment>
                  <TouchableOpacity
                    style={[styles.titleView1, styles.titleView2]}
                    onPress={() => {
                      this.setState({ isRefresh: false }, () => { navigation.navigate('InvoiceInfonManage', { getFapiaoData: this.getFapiaoData }) })
                    }}
                  >
                    <Text style={styles.title_text1}>发票信息</Text>
                    <View style={[styles.titleView2_item, { marginLeft: 6 }]}>
                      <Text style={[styles.title_text2, { maxWidth: '60%' }]} ellipsizeMode='tail' numberOfLines={1}>{fapiao}</Text>
                      <Image style={styles.titleView2_img} source={require('../../images/mall/goto_gray.png')} />
                    </View>
                  </TouchableOpacity>
                  <View style={[styles.titleView1, styles.titleView2]}>
                    <Text style={styles.title_text1}>运费</Text>
                    <Text style={styles.title_text2}>¥{math.divide(postAmount , 100) }</Text>
                  </View>
                  <TouchableOpacity
                    style={[styles.titleView1, styles.titleView2]}
                    onPress={() => {
                      this.setState({ youhuiQuanVisible: true })
                    }}
                  >
                    <Text style={[styles.title_text1]}>优惠券</Text>
                    <View style={[styles.titleView2_item]}>
                      <Text style={[styles.title_text2, { paddingLeft: 8, maxWidth: '80%' }]} numberOfLines={3}>{youhui}</Text>
                      <Image style={styles.titleView2_img} source={require('../../images/mall/goto_gray.png')} />
                    </View>
                  </TouchableOpacity>
                </React.Fragment>
              }
              <View style={[styles.titleView1, styles.titleView3]}>
                <Text style={styles.title_text2}>共计{goodsList.length}件商品</Text>
              </View>
            </View>
        </ScrollView>

        <View style={styles.footerView}>
          <View style={[styles.footerItem, styles.footerItem1]}>
            <Text style={styles.footerItem_text1}>合计金额：</Text>
            <Text style={styles.footerItem_text2}>¥{allPrice}</Text>
          </View>
          <TouchableOpacity
            activeOpacity={0.7}
            style={[styles.footerItem, styles.footerItem2]}
            onPress={() => {
              Loading.show();
              this.handleDebouncePayFlow();
            }}
          >
            <Text style={styles.footerItem_text3}>提交订单</Text>
          </TouchableOpacity>
        </View>

        <Modal
          animationType={'fade'}
          transparent={true}
          visible={youhuiQuanVisible}
          onRequestClose={() => { this.changeState('youhuiQuanVisible', false) }}
          onShow={() => { }}
        >
          <View style={styles.modalOutView}>
            <TouchableOpacity
              style={styles.modalInnerTopView}
              activeOpacity={1}
              onPress={() => {
                  this.changeState('youhuiQuanVisible', false);
              }}
            >
            </TouchableOpacity>
                <View style={styles.modalInnerBottomView}>
                  <View style={styles.modal_titleView}>
                    <View style={styles.modal_titleItem}></View>
                    <Text style={styles.modal_title_text}>可用卡券</Text>
                    <TouchableOpacity
                      style={styles.modal_titleItem}
                      onPress={() => {
                        this.changeState('youhuiQuanVisible', false);
                      }}
                    >
                      <Image source={require('../../images/mall/close1.png')} />
                    </TouchableOpacity>
                  </View>
                  {
                    youHuiQuan && youHuiQuan.length
                      ? (
                        <ScrollView style={{ maxHeight: 300 }}>
                          {
                            youHuiQuan && youHuiQuan.map((item, index) => {
                              let fontColor = '#222222'
                              let chooseDisable = false
                              let zhuijia = ''
                              if (item.state === 0) {
                                  fontColor = '#CCCCCC'
                                  chooseDisable = true
                                  zhuijia = '优惠暂不可用'
                              }
                              return (
                                <TouchableOpacity 
                                  style={{ width: width, paddingVertical: 15, borderBottomColor: '#f1f1f1', borderBottomWidth: 0.5 }} 
                                  activeOpacity={0.7} 
                                  key={item.id}
                                  onPress={() => {
                                    if (item.state === 0) {
                                      Toast.show('优惠暂不可用')
                                      this.setState({ youhuiQuanVisible: false })
                                      return
                                    }
                                    if (index === this.state.yhqIndex) {
                                      this.mallOrderMUserValidateAmount({}, this.state.adress, () => {
                                        this.setState({
                                          useYouHuiQuan: { cardType: '', id: ''},
                                          youhuiQuanVisible: false,
                                          yhqIndex: null
                                        })
                                      })
                                    } else {
                                    console.log('item',item)
                                      
                                      this.mallOrderMUserValidateAmount(item, this.state.adress, () => {
                                        this.setState({
                                          useYouHuiQuan: item,
                                          youhuiQuanVisible: false,
                                          yhqIndex: index
                                        })
                                      })
                                    }
                                  }}
                                  >
                                  <View style={{ flexDirection: 'row', justifyContent: 'space-around', alignItems: 'center', paddingHorizontal: 10, width: width }}>
                                    <View disabled={chooseDisable}
                                      style={{ flex: 1, justifyContent: 'center' }}>
                                      <Text style={{ color: fontColor, lineHeight: 18 }}>
                                        {item.cardName}{zhuijia === '' ? '' : <Text style={{ color: '#666' }}>({zhuijia})</Text>}
                                      </Text>
                                    </View>

                                    <View disabled={chooseDisable} style={{ width: 35, justifyContent: 'center' }}>
                                      <ImageView
                                        source={
                                          index === yhqIndex
                                            ? checked
                                            : unchecked
                                        }
                                        sourceWidth={15}
                                        sourceHeight={15}
                                      />
                                    </View>
                                  </View>
                                </TouchableOpacity>
                              )
                            })
                          }
                        </ScrollView>
                      ) 
                      : (
                        <View
                          style={{ height: 50, width: width, justifyContent: 'center', alignItems: 'center' }}
                        >
                          <Text>暂无可用的优惠券</Text>
                        </View>
                      )
                  }
                  </View>
              </View>
          </Modal>
      </View>
    );
  }
};

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  contentView: {
    flex: 1,
    backgroundColor: '#EEEEEE',
  },
  contentItem: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    width: width - 20,
    marginHorizontal: 10,
    borderRadius: 8,
    backgroundColor: '#fff',
      // ...CommonStyles.shadowStyle,
  },
  contentItem1: {
    justifyContent: 'space-between',
    minHeight: 77,
    marginVertical: 10,
  },
  content_adr: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
  },
  adresspng: {
      // width: 50,
      // height: 50,
    alignItems: 'center',
    justifyContent: 'center',
  },
  content_adr1: {
    width: 30,
  },
  content_adr2: {
    flex: 1,
  },
  container_text: {
    fontSize: 14,
    color: '#555',
  },
  contentItem2: {
      flexDirection: 'column',
      justifyContent: 'flex-start',
      marginBottom: 50,
  },
  content_ord: {
      flexDirection: 'row',
      width: '100%',
      height: 110,
      padding: 15,
      borderBottomWidth: 1,
      borderBottomColor: '#F1F1F1',
  },
  item_shop_img: {
      height: 79,
      width: 79,
      borderRadius: 10,
      borderWidth: 1,
      borderColor: '#f1f1f1'
  },
  item_shop_other: {
      flex: 1,
      marginLeft: 10,
  },
  item_shop_title: {
      fontSize: 12,
      color: '#222',
      lineHeight: 19,
  },
  item_shop_guige: {
      fontSize: 12,
      color: '#555',
      marginTop: 10,
  },
  item_shop_price1: {
      fontSize: 12,
      color: '#555',
      marginTop: 3
  },
  item_shop_price2: {
      fontSize: 12,
      color: '#EE6161',
  },
  titleView1: {
      flexDirection: 'row',
      justifyContent: 'flex-start',
      alignItems: 'center',
      width: '100%',
      // height: 40,
      paddingVertical: 10,
      paddingHorizontal: 15,
      borderBottomWidth: 1,
      borderBottomColor: '#F1F1F1',
  },
  title_text1: {
      fontSize: 14,
      color: '#222',
  },
  title_text2: {
      fontSize: 14,
      color: '#777',
      paddingLeft: 5,
      lineHeight: 18,
      // paddingRight: 5
      // textAlign: 'right'
  },
  titleView1_input: {
      width: width - 150,
      height: 30,
  },
  titleView2: {
      justifyContent: 'space-between',
  },
  titleView2_item: {
      flexDirection: 'row',
      justifyContent: 'flex-end',
      alignItems: 'center',
      flex: 1,
  },
  titleView2_img: {
      // marginLeft: 5,
  },
  titleView3: {
      justifyContent: 'center',
  },
  footerView: {
      flexDirection: 'row',
      justifyContent: 'center',
      alignItems: 'center',
      width: width,
      height: 50 + CommonStyles.footerPadding,
      paddingBottom: CommonStyles.footerPadding,
      backgroundColor: '#fff',
  },
  footerItem: {
      flexDirection: 'row',
      justifyContent: 'center',
      alignItems: 'center',
      height: '100%',
      backgroundColor: '#fff',
  },
  footerItem1: {
      justifyContent: 'flex-end',
      flex: 1,
      paddingRight: 15,
  },
  footerItem2: {
      width: 105,
      backgroundColor: '#4A90FA',
  },
  footerItem_text1: {
      fontSize: 14,
      color: '#222',
  },
  footerItem_text2: {
      fontSize: 14,
      color: '#EE6161',
  },
  footerItem_text3: {
      fontSize: 17,
      color: '#fff',
  },

  modalOutView: {
      flex: 1,
      justifyContent: 'center',
      alignItems: 'center',
  },
  modalInnerTopView: {
      width: width,
      flex: 1,
      backgroundColor: 'rgba(0, 0, 0, .5)',
  },
  modalInnerBottomView: {
      width: width,
      paddingBottom: CommonStyles.footerPadding,
      backgroundColor: '#fff',
  },
  modal_titleView: {
      flexDirection: 'row',
      justifyContent: 'center',
      alignItems: 'center',
      height: 50,
      borderBottomWidth: 1,
      borderBottomColor: '#F1F1F1',
  },
  modal_titleItem: {
      flexDirection: 'row',
      justifyContent: 'center',
      alignItems: 'center',
      width: 75,
      height: '100%',
  },
  modal_title_text: {
      flex: 1,
      fontSize: 17,
      color: '#000',
      textAlign: 'center',
  },
  modalItem1: {
      height: 70,
  },
  modal_text1: {
      fontSize: 17,
      color: '#EE6161',
  },
  modalItem2: {
      justifyContent: 'space-between',
      paddingHorizontal: 25,
  },
  modalItem2_item: {
      flexDirection: 'row',
      justifyContent: 'center',
      alignItems: 'center',
  },
  modal_text2: {
      fontSize: 14,
      color: '#222',
      marginLeft: 8,
  },
  modalItem3: {
      justifyContent: 'flex-start',
      paddingHorizontal: 25,
  },
  modal_text3: {
      color: '#ccc',
  },
  modalInnerBottomView1: {
      width: width,
      flex: 1,
      backgroundColor: '#F0F0F0',
  },
  quanViews: {
      width: width - 20,
      marginBottom: 15,
      borderWidth: 1,
      borderColor: '#FFEEF5FF',
      borderRadius: 4,
      backgroundColor: '#EEF5FF',
      paddingRight: 10,
      shadowColor: '#005DC0',
      shadowOpacity: 0.26,
      shadowRadius: 6,
      shadowOffset: { width: 6, height: 6 }
  },
  quanView: {
      flexDirection: 'row',
      width: '100%',
      height: 86,
  },
  quanView2: {
      width: '100%',
  },
  quanItem_line1: {
      width: 0,
      height: '100%',
      marginHorizontal: 10,
      borderWidth: 0.5,
      borderColor: '#ccc',
      borderStyle: 'dashed',
  },
  quanItem_line2: {
      width: '100%',
      height: 6,
      marginVertical: 10,
      borderTopWidth: 0.5,
      borderBottomWidth: 0,
      borderTopColor: '#ccc',
      borderStyle: 'dashed',
      borderRadius: 20
  },
  quanItem1: {
      justifyContent: 'center',
      alignItems: 'flex-start',
      flex: 3,
      height: '100%',
      marginLeft: 10,
  },
  quanItem2: {
      justifyContent: 'center',
      alignItems: 'flex-start',
      flex: 7,
      height: '100%',
      marginLeft: 8
  },
  quan_text1: {
      fontSize: 24,
      color: '#FFFFFF',
  },
  quan_text2: {
      fontSize: 10,
      color: '#FFFFFF',
  },
  quan_text2_mar: {
      marginTop: 5,
  },
  quan_text3: {
      fontSize: 12,
      color: '#222',
  },
  quanItem2_bom: {
      flexDirection: 'row',
      justifyContent: 'space-between',
      alignItems: 'center',
      width: '100%',
      height: 22,
  },
  quan_detail: {
      flexDirection: 'row',
      justifyContent: 'center',
      alignItems: 'center',
  },
  quan_detail2: {
      height: '100%',
      paddingHorizontal: 6,
      borderRadius: 76,
      backgroundColor: '#4A90FA',
  },
  quan_detailNo: {
      height: '100%',
      paddingHorizontal: 6,
      borderRadius: 76,
      backgroundColor: '#DCEAFF'
  },
  quan_text4: {
      fontSize: 12,
      color: '#fff',
  },
  quan2_text1: {
      fontSize: 12,
      color: '#777',
  },
});

export default connect(
  (state) => ({
      userInfo: state.user.user || {},
  }),
  (dispatch) => ({ dispatch })
)(SOMOrderConfirmScreen);
