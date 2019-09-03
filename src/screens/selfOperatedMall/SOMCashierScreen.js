/**
 * 收银台
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Image,
    ScrollView,
    TouchableOpacity,
    BackHandler
} from "react-native";
import moment from 'moment'
import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import actions from "../../action/actions";
import * as nativeApi from '../../config/nativeApi';
import Switch from '../../components/Switch'

import Header from "../../components/Header";
import TextInputView from '../../components/TextInputView'
import PriceInputView from "../../components/PriceInputView";
import CommonStyles from "../../common/Styles";
import * as requestApi from '../../config/requestApi';
import * as customPay from '../../config/customPay';
import ModalDemo from "../../components/Model";
import math from "../../config/math.js";
import { keepTwoDecimalFull, debounce, getDiffTime } from "../../config/utils";

const { width, height } = Dimensions.get("window");
class SOMCashierScreen extends Component {
    static navigationOptions = {
        header: null,
        gesturesEnabled: false, // 禁用ios左滑返回
      };
    inputRef = null;
    _willBlurSubscription;
    _didFocusSubscription;
    constructor(props) {
        super(props);
        this._didFocusSubscription = props.navigation.addListener('didFocus', payload =>{
            BackHandler.addEventListener('hardwareBackPress', this.handleBackPress)
        // this.getNavigationParam()
            if(this.state.isGoSetPassword){
                this.setState({isGoSetPassword:false})
            }else{
                this.getCashierData()
            }
        });
        this.handlePay = debounce(this.payOrder)
        this.state = {
            cashier: props.navigation.getParam('cashier', {}),
            seletTypeIndex: '', // 选择的支付索引
            confimVis: false, // 设置密码提示弹窗
            consumerCouponInfo:null, // 消费券信息
            goodsTicketsInfo: null, // 实物券信息
            payChannel: '', //支付方式
            confimVis1: false, // 退出弹窗
            payTypeList: [], // 支付方式列表
            swqProportion: 1, // 实物券兑换比例 当前为1块钱等于1券， 如果1块钱 = 8券，则swqProportion = 8
            xfqProportion: 1, // 消费券兑换比例
            usePrePay: false,//是否使用一级支付
            prePayItem:{
                amount: '0'
            },
            isGoSetPassword:false,//是否是去设置支付密码
            confimVis2: false, // 订单过期弹窗
        }
    }
    componentDidMount() {
        Loading.show();
        // this.getCashierData()
        this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload =>
            BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress)
        );
    }
    getPreItem=(item,use)=>{
        let cashier =this.props.navigation.getParam('cashier', {})
        let useful = math.multiply(cashier.amount, item.payChannel == 'xfq' ? this.state.xfqProportion : this.state.swqProportion)
        // item.amount > math.divide(useful, 100) ? math.divide(useful, 100) : item.amount
        // 上面判断余额是否大于支付余额，如果大于则使用商品价格等额实物券，否则使用全部实物券(商户端由于显示4位小数，且不允许使用的支付金额有小数，故做处理)
        let swqAmount = (item.amount).toString()
        item.use = use!=undefined ? use :item.amount > math.divide(useful, 100) ? math.divide(useful, 100) : swqAmount.substring(0,swqAmount.length - 2)
        item.dikou = math.divide(item.use, item.payChannel == 'xfq' ? this.state.xfqProportion : this.state.swqProportion)
        item.leftPay = math.subtract(math.divide(cashier.amount,100) , item.dikou)
        return item
    }
    getDefalutPayType=()=>{ //获取默认支付方式
      const {consumerCouponInfo,xfqProportion,payTypeList,prePayItem,usePrePay,cashier}=this.state
      if(consumerCouponInfo){
        if(parseFloat(cashier.amount)==0){//支付总金额如果为0 ，支付方式默认为消费券
            this.setState({
                usePrePay: false,
                seletTypeIndex: consumerCouponInfo.index,
                payChannel: consumerCouponInfo.payChannel,
            })
            return
        }
        const leftPay = usePrePay ? prePayItem.leftPay : math.divide(cashier.amount, 100)
        let needXfq = math.multiply(leftPay, xfqProportion)
        console.log('leftPay',leftPay,prePayItem)
        if(leftPay==0){
          this.setState({payChannel:'',seletTypeIndex:''})
        }
        else if(needXfq<=consumerCouponInfo.amount){
            this.setState({
              payChannel:'xfq',
              seletTypeIndex:consumerCouponInfo.index
          })
        }
        else{
            this.setState({
              payChannel:payTypeList[0].payChannel,
              seletTypeIndex:0
            })
        }
      }else{
        this.setState({
          payChannel:payTypeList[0].payChannel,
          seletTypeIndex:0
        })
      }
      console.log('this.state',this.state)
    }
    // 拿到返回给收银台的信息，同事过滤数据，是否显示实物券按钮 （第一排）
    getCashierData = () => {
        const { navigation } = this.props
        const {cashier}=this.state
        let consumerCouponInfo = {
            amount: 0,
        } // 消费券信息
        let goodsTicketsInfo = {
            amount: 0,
        } // 实物券信息
        let temp = []
        console.log('cashier',cashier)
        cashier.channelConfigs.map((item, index) => { // 过滤出四个支付方式
            if (item.payChannel == 'alipay') {
                temp[0] = ({
                    name: '支付宝',
                    info: '支付宝安全支付',
                    img: require('../../images/mall/alipay.png'),
                    disable: false,
                    payChannel: item.payChannel,
                    prePayChannel: item.isPreChannel,
                })
            }
            if (item.payChannel == 'wxpay') {
                temp[1] = ({
                  name: '微信',
                  info: '微信安全支付',
                  img: require('../../images/mall/wechat_pay.png'),
                  disable: false,
                  payChannel: item.payChannel,
                  prePayChannel: item.isPreChannel,
              })
            }
            if (item.payChannel == 'xfq' || item.payChannel == 'swq') {
                //
                // item.payChannel == 'swq'?item.amount=20000000000000:null
                item.payChannel == 'xfq' ? consumerCouponInfo = {...item,index:temp.length} : goodsTicketsInfo = {...item,index:temp.length}
                if (item.isPreChannel) {
                    item.payChannel == 'xfq' ? consumerCouponInfo = {...item,index:temp.length} : goodsTicketsInfo = {...item,index:temp.length}
                    if(item.amount>0 && parseFloat(item.amount.substring(0,item.amount.length - 2)) > 0){
                        const prePayItem=this.getPreItem(item)
                        this.setState({
                            prePayItem,
                            usePrePay: true,
                        })
                    }
                } else {
                    temp.push({
                        name: item.payChannel == 'xfq' ? '消费券' : '实物券',
                        info: item.payChannel == 'xfq' ? `${this.state.xfqProportion}消费券=¥1.00` : `${this.state.swqProportion}实物券=¥1.00`,
                        img: item.payChannel == 'xfq' ? require('../../images/mall/ticket_pay.png') : require('../../images/mall/swq_icon.png'),
                        disable: this.handleInnerPayPer(item, cashier),
                        payChannel: item.payChannel,
                        prePayChannel: item.isPreChannel,
                    })
                }

            }
        })
        this.setState({
            cashier,
            goodsTicketsInfo,
            consumerCouponInfo,
            payTypeList: temp
        }, () => {
            cashier.channelConfigs.length>0?this.getDefalutPayType():null
            Loading.hide();
        })

    }
    componentWillUnmount() {
        BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress)
        this._didFocusSubscription && this._didFocusSubscription.remove();
        this._willBlurSubscription && this._willBlurSubscription.remove();
        Loading.hide();
    }
    // 判断是否禁止内部支付
    handleInnerPayPer = (item, cashier, isUsePrePay = true) => {
        const { xfqProportion, swqProportion } = this.state
        // 获取兑换比例
        let proprotion = (item.payChannel === 'xfq') ? xfqProportion : (item.payChannel === 'swq') ? swqProportion : null;
        let swqItem = cashier.channelConfigs.filter(item => item.payChannel === 'swq')[0]
        if (proprotion === null) return true
        if (item.amount == 0) {
            return true
        } else {
            if (item.isInner === 1) {
                // 当前商品值多少券
                let allTickets = (cashier.amount) * proprotion
                // 用户剩余券足够支付时
                if (isUsePrePay && math.multiply(item.amount, 100) + math.multiply(swqItem.amount, 100) >= allTickets) {
                    console.log('allTickets',allTickets)
                    console.log('haveTickets',math.multiply(item.amount, 100) + math.multiply(swqItem.amount, 100))
                    return false
                }
                if (!isUsePrePay && math.multiply(item.amount, 100) >= allTickets) {
                    console.log('allTickets',allTickets)
                    console.log('haveTickets',math.multiply(item.amount, 100))
                    return false
                }
                return true
            }
            return true
        }
    }
    // 监听返回 ，取消支付
    handleBackPress = () => {
        // 支付时显示弹窗
        console.log('SOMCASHIER')
        const { cashier } = this.state
        let diffTime = (Date.parse(new Date(moment(cashier.expireTime * 1000))) - Date.parse(new Date())) / 1000;
        console.log('diffTime',diffTime)
        if (diffTime > 0) {
            this.setState({
                confimVis1: true,
            })
        } else {
            this.setState({
                confimVis2: true,
            })
        }
        return true
    }
    changeState = (key = '', value = '', callback = () => { }) => {
        this.setState({
            [key]: value
        }, () => {
            callback()
        })
    }
    // 选择支付 索引
    handleSelectPay = (item, index) => {
        this.setState({
            payChannel: item.payChannel,
            seletTypeIndex: index
        })
    }
    // 点击支付
    payOrder = async () => {
        const { navigation } = this.props;
        const { payChannel, cashier, goodsTicketsInfo, consumerCouponInfo, seletTypeIndex, payTypeList, usePrePay,prePayItem } = this.state;
        const prePayUse=prePayItem.use
        console.log('prePayItem', prePayItem)
        let xfqItem = cashier.channelConfigs.filter(item => item.payChannel === 'xfq')[0]
        if (!payChannel && !usePrePay) {
            Toast.show('请选择付款方式')
            Loading.hide();
            return
        }
        if(usePrePay && prePayItem.leftPay < 0){
            Toast.show(prePayItem.payChannel == 'xfq' ? '消费券' : '实物券'+'抵扣金额不能大于付款总额')
            this.inputRef && this.inputRef.focus()
            Loading.hide();
            return
        }
        // 判断用户输入
        let reg = /^\d+(\.\d{1,2})?$/
        let _dotIndex = `${prePayItem.use}`.indexOf('.');
        if (_dotIndex !== -1 && !reg.test(parseFloat(prePayUse))) {
            Toast.show('实物券只能保留两位小数哦')
            Loading.hide();
            this.inputRef && this.inputRef.focus()
            return
        }
        // 如果使用前置支付，必须输入金额
        if ((usePrePay && !prePayUse) || (usePrePay && !parseFloat(prePayUse))) {
            Toast.show('请输入使用实物券金额！')
            Loading.hide();
            this.inputRef && this.inputRef.focus()
            return
        }
        // 使用前置支付，判断输入金额是否大于实物券余额
        let swqAmount = (prePayItem.amount).toString()
        if (usePrePay && parseFloat(prePayUse) > parseFloat(swqAmount.substring(0,swqAmount.length - 2))) {
            Toast.show('实物券余额不足，请修改金额')
            Loading.hide();
            this.inputRef && this.inputRef.focus()
            return
        }
        console.log('leftPay',prePayItem.leftPay)
        // 使用前置支付，且选择的是消费券，判断剩余支付金额是否大于消费券余额
        let xfqAmount = xfqItem.amount
        if(usePrePay && payChannel === 'xfq' && prePayItem.leftPay > parseFloat(xfqAmount.substring(0,xfqAmount.length - 2))) {
            Toast.show('消费券余额不足，请修改金额')
            Loading.hide();
            this.inputRef && this.inputRef.focus()
            return
        }
        // 判断支付是否超时
        let diffTime = (Date.parse(new Date(moment(cashier.expireTime * 1000))) - Date.parse(new Date())) / 1000;
        console.log('diffTime',diffTime)
        if (diffTime < 0) { // 超过 待支付 时间
            Toast.show('已超过待支付时间，请重新下单！')
            navigation.push('SOMPayResult', { payFailed: true, routerIn: 'OrderConfirm' });
            Loading.hide();
            return
        }
        // 如果支付情况为非组合支付，如果只有前置支付（实物券），则payChannel。payAmount为null，如果只有消费券支付，prePayChannel为null，prePayAmount为null
        let param = {
            "body": cashier.body,//【提交订单接口返回body字符串】
            "prePayChannel": usePrePay ? parseFloat(prePayUse) ? prePayItem.payChannel: null : null,
            "payChannel": payTypeList[seletTypeIndex] ? payTypeList[seletTypeIndex].payChannel : null,
            "payAmount": (usePrePay) ? math.multiply(prePayItem.leftPay, 1) == 0 ? null : math.multiply(prePayItem.leftPay, 100) :cashier.amount,
            "prePayAmount": (usePrePay) ? parseFloat(prePayUse) ? math.multiply(prePayItem.use, 100) : null : null,
            "authType": [],
            "authValue": "",
            "platform": 'ma'
        }
        console.log('支付参数', param);
        if (payChannel === 'alipay' || payChannel === 'wxpay') { // 支付宝支付 // 微信支付
            if (prePayItem.isPreChannel && usePrePay) {
                this.getPayPwdStatus((password, navigation) => {
                    param = {
                        ...param,
                        "authType": 'password', // 这里密码验证，面部识别和指纹未做
                        "authValue": password,
                    }
                    payChannel === 'alipay' ? this.handleAliPay(param, navigation) : this.handleWeChatPay(param, navigation)
                })
                return
            }
            payChannel === 'alipay' ? this.handleAliPay(param, this.props.navigation) : this.handleWeChatPay(param, this.props.navigation)
        }
        if (payChannel === 'xfq' || payChannel === 'swq' || param.prePayChannel ) {
            this.getPayPwdStatus((password, navigation) => {
                param = {
                    ...param,
                    "authType": 'password', // 这里密码验证，面部识别和指纹未做
                    "authValue": password,
                }
                this.handleBalancePay(navigation, param)
            })
        }
    }
    // 微信支付
    handleWeChatPay = (param, navigation) => {
        Loading.show()
        requestApi.uniPayment(param).then(res => {
            console.log('wechat', res)
            let wx_param = {
                partnerId: res.next.channelPrams.partnerId,
                prepayId: res.next.channelPrams.prepayId,
                nonceStr: res.next.channelPrams.nonceStr,
                timeStamp: res.next.channelPrams.timestamp,
                package: res.next.channelPrams.pack,
                sign: res.next.channelPrams.sign,
            }
            customPay.wechatPay({
                param: wx_param,
                successCallBack: () => {
                    navigation.push('SOMPayResult', { payFailed: false });
                },
                faildCallBack: () => {
                    navigation.push('SOMPayResult', { payFailed: true });
                }
            })
        }).catch(err => {
            navigation.push('SOMPayResult', { payFailed: true });
            console.log(err)
        })
    }
    // 支付宝支付
    handleAliPay = (param, navigation) => {
        Loading.show()
        requestApi.uniPayment(param).then(res => {
            console.log(res)
            customPay.alipay({
                param: res.next.channelPrams.aliPayStr,
                successCallBack: () => {
                    navigation.push('SOMPayResult', { payFailed: false });
                },
                faildCallBack: () => {
                    navigation.push('SOMPayResult', { payFailed: true });
                }
            })
        }).catch(err => {
            navigation.push('SOMPayResult', { payFailed: true });
            console.log(err)
        })

    }
    // 余额支付
    handleBalancePay = (navigation, param) => {
        Loading.show()
        console.log('参数',param)
        requestApi.uniPayment(param).then(res => {
            console.log('支付结果',res)
            if (res.tradePaymentStatus === 'success') {
                navigation.push('SOMPayResult', { payFailed: false, routerIn: 'OrderConfirm' });
            }
            if (res.tradePaymentStatus === 'fail') {
                navigation.push('SOMPayResult', { payFailed: true, routerIn: 'OrderConfirm' });
            }
        }).catch(err => {
            console.log(err)
            navigation.push('SOMPayResult', { payFailed: true, routerIn: 'OrderConfirm', });

        })
    }
    // 是否设置过支付密码
    getPayPwdStatus = (callback) => {
        Loading.show()
        let cashier = this.props.navigation.getParam('cashier')
        let { navigation } = this.props
        requestApi.merchantPayPasswordIsSet().then(res => {
            console.log('获取设置支付密码状态', res)
            this.props.actions.getSetPayPwdStatus(res);
            if (res.result === 0) {
                // 没有设置支付密码显示弹窗
                this.setState({
                    confimVis: true,
                })
            } else {
                navigation.push('SOMBalancePay', { callback, cashier });
            }
        }).catch(() => {
            console.log('ddd')
        });
    };
    // 取消支付
    // handleCancePay = () => {
    //     Loading.show()
    //     let payId = this.state.cashier.outTradeNo
    //     const { navigation,merchantId } = this.props
    //     requestApi.mallOrderMUserCancelPay({
    //         payId,
    //     }).then(res => {
    //         this.props.actions.fetchMallCartList({ merchantId });
    //         navigation.navigate('SOMOrder', { tabsIndex: 1})
    //         // navigation.goBack()
    //     }).catch(err => {
    //     })
    // }
    viewSwitch = () => {
        const { usePrePay, prePayItem, cashier, payTypeList } = this.state
        return (
            <Switch
                width={36}
                height={23}
                value={usePrePay}
                onChangeState={(data) => {
                    console.log('data',data)
                    let selectXfqItem = payTypeList.filter(item => item.payChannel === 'xfq')[0]
                    let xfqItem = cashier.channelConfigs.filter(item => item.payChannel === 'xfq')[0]
                    selectXfqItem.disable = this.handleInnerPayPer(xfqItem, cashier, data);
                    payTypeList.map(item => {
                        if (item.payChannel === 'xfq') {
                            item = selectXfqItem
                        }
                    })
                    this.setState({usePrePay:!usePrePay, payTypeList},()=>{
                        if (!data) {
                            prePayItem.dikou = 0;
                            prePayItem.use = '';
                            prePayItem.leftPay = math.divide(cashier.amount, 100);
                        }
                        this.getDefalutPayType()
                    })
                }}
            />
        )
    }
    useRightView=(prePayItem,usePrePay)=>{
        return(
            <PriceInputView
                inputRef={(ref) => { this.inputRef = ref }}
                placeholder="请输入使用数量"
                inputView={{ flex:1,height: 30 }}
                maxLength={prePayItem.amount.toString().length}
                value={prePayItem.use.toString()}
                style={{ textAlign: "right" ,...styles.swqPrice}}
                editable={usePrePay}
                onChangeText={data => {
                    let dotIndex = data.indexOf('.');
                    if (dotIndex !== -1 && data.length > dotIndex + 5) return // 输入小数点后只能输入四位
                    if (data.split('.').length > 2) return // 只能输入一个小数点
                    if (math.multiply(parseFloat(data || 0),this.state.xfqProportion)>math.divide (this.state.cashier.amount,100)){
                        Toast.show(prePayItem.payChannel == 'xfq' ? '消费券' : '实物券'+'抵扣金额不能大于付款总额')
                        return
                    }
                    const newPrepay=this.getPreItem(prePayItem,data)
                    this.setState({
                        prePayItem:newPrepay
                    },()=>this.getDefalutPayType());
                }}
            />
        )
    }

    render() {
        const { navigation } = this.props;
        const { confimVis1,confimVis2, usePrePay, confimVis, payTypeList, seletTypeIndex, cashier, consumerCouponInfo, goodsTicketsInfo, swqProportion, xfqProportion,prePayItem } = this.state
        const contentItems = [
            payTypeList
        ]
        // 实物券余额为0 或者 收银台返回金额为0，不显示实物券支付
        prePayItem.amount != '0' && prePayItem.amount >= 0.01 && cashier.amount !== 0 && contentItems.unshift(
            [
                {
                    name: prePayItem.payChannel == 'xfq' ? '消费券' : '实物券',
                    info: prePayItem.payChannel == 'xfq' ? `${xfqProportion}消费券=¥1.00` : `${swqProportion}实物券=¥1.00`,
                    payChannel: prePayItem.payChannel,
                    prePayChannel: prePayItem.isPreChannel,
                    rightView: this.viewSwitch(prePayItem)
                },
                // { name: '使用', rightView: <Text style={styles.swqPrice}>{math.divide(prePayItem.use, 100)}</Text> },
                { name: '使用', rightView: this.useRightView(prePayItem,usePrePay)},
                { name: '抵扣金额', rightView: <Text style={styles.swqPrice}>-¥{prePayItem.dikou}</Text> },
                { name: '剩余支付', rightView: <Text style={[styles.swqPrice, { fontSize: 17 }]}>¥{prePayItem.leftPay}</Text> },

            ]
        );
        
        let diffTime = getDiffTime(moment(cashier.expireTime * 1000));
        let diffText = `${diffTime.days > 0 ? `${diffTime.days}天`: ''}${diffTime.hours > 0 ? `${diffTime.hours}小时`: ''}${diffTime.min > 0 ? `${diffTime.min}分钟`: ''}${diffTime.sec > 0 ? `${diffTime.sec}秒`: ''}`
        let payTitle = `确认离开收银台吗？若在${diffText}内未完成支付，该订单会被关闭`;
        console.log(this.state.payChannel,seletTypeIndex,consumerCouponInfo,payTypeList)
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"晓可收银台"}
                    leftView={
                        <View>
                            <TouchableOpacity
                                style={[styles.headerItem, styles.left]}
                                onPress={() => {
                                    this.handleBackPress()
                                }}
                            >
                                <Image source={require('../../images/mall/goback.png')} />
                            </TouchableOpacity>
                        </View>
                    }
                />
                <ScrollView showsHorizontalScrollIndicator={false} showsVerticalScrollIndicator={false}>
                    <View style={[styles.payAmountView, CommonStyles.flex_center]}>
                        <Text style={styles.payAmountText}>￥{keepTwoDecimalFull(math.divide(cashier.amount, 100))}</Text>
                        <Text style={styles.payNoticeText}>支付金额</Text>
                    </View>
                    {
                        contentItems.map((item, index0) => {
                            return (
                                <View style={[styles.payTypeWrap]} key={index0}>
                                    {
                                        item.map((item, index) => {
                                          let disabled=((prePayItem.leftPay == 0 && usePrePay)? true : item.disable) || parseFloat(cashier.amount)==0
                                          disabled = contentItems.length > 1  && index0 == 0 ? true:disabled //实物券项不能点击
                                          return (
                                                <TouchableOpacity
                                                    style={[CommonStyles.flex_between, styles.payTypeItem]}
                                                    key={index}
                                                    activeOpacity={disabled ? 1: 0.7}
                                                    onPress={() => {
                                                        disabled?null:this.handleSelectPay(item, index)
                                                    }}>
                                                    <View style={[styles.payTypeLable, CommonStyles.flex_start]}>
                                                        {
                                                            item.img && <Image style={{ height: 20, width: 20, marginRight: 10 }} source={item.img} />
                                                        }
                                                        <View>
                                                            <View style={CommonStyles.flex_start_noCenter}>
                                                                <Text style={{ fontSize: 14, color: '#222' }}>{item.name}</Text>
                                                                <Text style={{ fontSize: 14, color: '#777', marginLeft: 5 }}>
                                                                    {
                                                                        (item.name === '消费券')
                                                                            ? `(余额:${consumerCouponInfo.amount})`
                                                                            : (item.name === '实物券')
                                                                                ? `(余额:${goodsTicketsInfo.amount})`
                                                                                : null
                                                                    }
                                                                </Text>
                                                            </View>
                                                            {
                                                                item.info && <Text style={{ fontSize: 12, color: '#999', marginTop: 5 }}>{item.info}</Text>
                                                            }
                                                        </View>
                                                    </View>
                                                    {
                                                        item.rightView
                                                        ? item.rightView
                                                        :(index === seletTypeIndex)
                                                            ? <Image style={{ height: 18, width: 18 }} source={require('../../images/mall/checked.png')} />
                                                            : disabled
                                                              ?<View style={{ height: 18, width: 18, borderRadius: 18, backgroundColor: '#f3f3f3' }} />
                                                              :<View style={{ height: 18, width: 18, borderColor: '#ccc', borderWidth: 2, borderRadius: 18 }} />

                                                    }
                                                </TouchableOpacity>
                                            )
                                        })
                                    }


                                </View>
                            )
                        })
                    }
                    {
                        contentItems.length !== 0 &&
                        <TouchableOpacity activeOpacity={0.75} style={[styles.payBtn, CommonStyles.flex_center]} onPress={() => {
                            Loading.show();
                            this.handlePay();
                        }}>
                            <Text style={{ fontSize: 17, color: '#fff' }}>立即支付</Text>
                        </TouchableOpacity>
                    }

                </ScrollView>
                {/* 未设置支付密码弹窗 */}
                <ModalDemo
                    noTitle={true}
                    leftBtnText="取消"
                    rightBtnText="去设置"
                    visible={confimVis}
                    title="您未设置过支付密码，是否立即设置？"
                    type="confirm"
                    onClose={() => {
                        this.changeState("confimVis", false);
                    }}
                    onConfirm={() => {
                        navigation.navigate('MerchantSetPswValidate', { goBackRouter: 'SOMCashier' })
                        this.changeState("isGoSetPassword", true);
                        this.changeState("confimVis", false);
                    }}
                />
                {/* 退出时候弹窗 */}
                <ModalDemo
                    noTitle={true}
                    leftBtnText="继续支付"
                    rightBtnText="确定离开"
                    visible={confimVis1}
                    titleStyle={{ lineHeight: 18 }}
                    title={payTitle}
                    type="confirm"
                    onClose={() => {
                        this.changeState("confimVis1", false);
                    }}
                    onConfirm={() => {
                        this.changeState("confimVis1", false);
                        let merchantId = this.props.merchantId;
                        this.props.actions.fetchMallCartList({ merchantId });
                        app._store.dispatch({ type: 'welfare/handleCashierGoBack' })
                        // navigation.push('SOMPayResult', { payFailed: true });
                        // this.handleCancePay()
                    }}
                />
                {/* 待支付过期弹窗 */}
                <ModalDemo
                    noTitle={true}
                    visible={confimVis2}
                    titleStyle={{ lineHeight: 18 }}
                    title='该订单已过期，请重新下单'
                    btnText='确认'
                    onConfirm={() => {
                        this.changeState("confimVis2", false);
                        app._store.dispatch({ type: 'welfare/handleCashierGoBack' })
                        // navigation.push('SOMPayResult', { payFailed: true });
                    }}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    payAmountView: {
        margin: 10,
        marginBottom: 0,
        padding: 15,
        backgroundColor: '#fff',
        borderRadius: 8,
        borderWidth: 0.5,
        borderColor: 'rgba(215,215,215,0.5)',
    },
    payAmountText: {
        fontSize: 24,
        color: '#222'
    },
    swqPrice: {
        color: CommonStyles.globalRedColor,
        fontSize: 14
    },
    payApayNoticeTextountText: {
        fontSize: 14,
        color: '#555'
    },
    ticketListWrap: {
        margin: 10,
        marginBottom: 0,
        // padding: 15,
        backgroundColor: '#fff',
        borderRadius: 8,
        borderWidth: 0.5,
        borderColor: 'rgba(215,215,215,0.5)',
        overflow: 'hidden',
    },
    ticketListItem: {
        borderBottomColor: '#f1f1f1',
        borderBottomWidth: 1,
        padding: 15
    },
    disableStyle: {
        color: '#ccc'
    },
    payTypeWrap: {
        margin: 10,
        // padding: 15,
        backgroundColor: '#fff',
        borderRadius: 8,
        borderWidth: 0.5,
        borderColor: 'rgba(215,215,215,0.5)',
        overflow: 'hidden',
    },
    payTypeItem: {
        borderBottomWidth: 1,
        borderBottomColor: '#f1f1f1',
        padding: 15,
    },
    payBtn: {
        margin: 10,
        marginBottom: 20,
        backgroundColor: CommonStyles.globalHeaderColor,
        borderRadius: 8,
        padding: 14
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
        // position: 'absolute'
    },
    left: {
        width: 50
    },
    inputView:{
        flex:1,
        backgroundColor:'red',
        color: CommonStyles.globalRedColor,
        fontSize: 14
    }
});

export default connect(
    state => ({
        merchantId: state.user.userShop.id
     }),
    dispatch => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMCashierScreen);
