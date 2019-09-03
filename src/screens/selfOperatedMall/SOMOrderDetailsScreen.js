/**
 * 自营商城订单详情
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    SafeAreaView,
    View,
    Text,
    Button,
    Image,
    ScrollView,
    TouchableOpacity,
    Platform,
} from 'react-native';
import { connect } from 'rn-dva'

import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import * as nativeApi from "../../config/nativeApi";
const { width, height } = Dimensions.get('window');
import ScrollableTab from '../../components/ScrollableTab';
import FlatListView from '../../components/FlatListView';
import ImageView from '../../components/ImageView';
import Popover from '../../components/Popover';
import ModelConfirm from '../../components/Model';
import moment from 'moment'
import PayModal from '../../components/PayModal';
import  math from "../../config/math.js";
import { keepTwoDecimalFull, getPreviewImage, getRefundOrderTagText } from '../../config/utils';
class SOMOrderDetailsScreen extends Component {
    static navigationOptions = {
        header: null,
    }
    constructor(props) {
        super(props)
        this.state = {
            visiblePopover: false, // 显示popover弹窗
            buttonRect: {},
            currentItem: {},
            modelVisible: false, // 取消订单 confirm 弹窗
            showMoreGoods: false, // 查看更多
            modalVisible: false, // 支付modal 弹窗
            modelVisible1:  false, //取消退款
            orderDetails: {
                addressInfo: {},
                amountInfo: {},
                invoiceInfo: {
                    invoiceType: '',
                    invoiceContent: '',
                    head: ''
                },
                payInfos:[{
                    payChannel: ''
                }]
            },
        }
    }

    componentDidMount() {
        this.getOrderDetail()
        console.log(this.props.navigation)
    }
    getOrderDetail = () => {
        const { navigation, store } = this.props;
        const { data } = navigation.state.params
        // 获取订单信息并合并商城信息
        Loading.show()
        requestApi.queryMallOrderDetail({ orderId: data.orderId }).then(data => {
            this.handleChangeState('orderDetails', data)
        }).catch((err)=>{
            console.log(err)
          });
    }
    // 去支付
    goToPay = () => {
        Loading.show()
        const { orderDetails } = this.state
        const { navigation, dispatch } = this.props
        requestApi.mallOrderMUserPay({
            orderIds: [orderDetails.orderId]
        }).then(res => {
            console.log('%cREES', 'color:red', res)
            navigation.push('SOMCashier', { cashier: res });
            dispatch({ type: 'welfare/save', payload: { cashireGoBackRoute: 'SOMOrderDetails', cashireGoBackParams: this.props} })
        }).catch(err => {
            Toast.show('获取订单信息失败,请重试！')
            console.log('%获取订单信息失败', 'color:red', err)
        })
    }
    //保存发票
    DownloadImage = (uri = null) => {
        if (!uri) return
        Loading.show();
        console.log(uri)
        nativeApi.DownloadImage(uri)
    }
    componentWillUnmount() {

    }
    showPopover() {
        this.refs.popoverDetail.measure((ox, oy, width, height, px, py) => {
            console.log(ox, oy, width, height, px, py)
            this.setState(
                {
                    buttonRect: { x: px, y: py, width: width, height: height },
                    currentItem: this.props.item,
                    visiblePopover: !this.state.visiblePopover
                }
            )
        });
    }
    handleChangeState = (key = '', value = '', callback = () => { }) => {
        this.setState({
            [key]: value
        }, () => {
            console.log('%cChagneState', 'color:red,background-color:blue', this.state)
            callback()
        })
    }
    closePopover = () => {
        this.setState({
            visiblePopover: false
        });
    }

    renderItem(item, index) {
        const { navigation } = this.props
        const { orderDetails } = this.state
        console.log('itemitem', item)
        return (
            <TouchableOpacity key={index} style={styles.itemView} activeOpacity={item.refundType && item.refundStatus !== 'REFUSED' ? 0.3 : 1} onPress={() => {
                if(item.refundStatus === 'REFUSED') return
                // 售后没有详情,判断是进入等待审核页面还是进度页面
                if (item.refundStatus === 'COMPLETE' || item.refundStatus === 'PRE_PLAT_RECEIVE' || item.refundStatus === 'PRE_REFUND' || item.refundStatus === 'REFUNDING') {
                    navigation.navigate('SOMRefundProcess', {
                        refundId: item.refundId,
                    })
                    return
                }
                if (item.refundType === 'REFUND') {
                    navigation.navigate('SOMRefundMoney', {
                        refundId: item.refundId,
                        routerIn: 'details'
                    })
                    return
                }
                if (item.refundType === 'REFUND_GOODS') {
                    navigation.navigate('SOMReturnedAllWait', {
                        refundId: item.refundId,
                        routerIn: 'details'
                    })
                }
            }}>
                <View style={styles.itemContent}>
                    <View style={styles.itemContentLeft}>
                        <Image
                            style={{borderRadius: 8,height: '100%',width: '100%'}}
                            source={{uri: getPreviewImage(item.goodsPic, '50p')}}
                        />
                    </View>
                    <View style={[styles.itemContentRight]}>
                        <Text style={{ color: '#222222', fontSize: 14, lineHeight: 17, marginBottom: 4 }} numberOfLines={2}>{item.goodsName}</Text>
                        <Text style={[{marginTop: 8, fontSize: 12, color: '#777'}]}>规格: {item.goodsAttr} × {item.buyCount}</Text>
                        <View style={[styles.flex_between, {marginTop: 5}]}>
                            {
                                orderDetails.goodsDivide === 2
                                ? <Text style={[{fontSize: 12, color: '#777'}]}>预约金: <Text style={{ color: '#EE6161' }}>￥{(math.divide(item.goodsPrice , 100))}</Text> </Text>
                                : <Text style={[{fontSize: 12, color: '#777'}]}>价格: <Text style={{ color: '#EE6161' }}>￥{(math.divide(item.goodsPrice , 100))}</Text> </Text>
                            }
                            {
                                item.refundType && item.refundStatus !== 'REFUSED' && <Text style={styles.showReundText}>{getRefundOrderTagText(item.refundStatus)}</Text>
                            }
                        </View>
                    </View>
                </View>
            </TouchableOpacity>
        )
    }
    // 取消退款
    handleCancelRefund = () => {
        Loading.show()
        const { navigation } = this.props
        let callback = navigation.getParam('callback', () => { })
        let item = navigation.getParam('data', {})
        let params = {
            refundId: item.refundId
        }
        console.log('itme',item)
         // 仅退款时， 当用户发起仅退款时，平台客服同意后，用户无法取消退款申请，若用户需要取消申请，只能联系客服
         if (item.refundType === "REFUND") {
            if (item.refundStatus === 'PRE_REFUND' || item.refundStatus === "REFUNDING" || item.refundStatus === "COMPLETE") {
                this.setState({
                    modelVisible1: false
                }, () => {
                    Loading.hide();
                    Toast.show("暂不能进行退款操作,请联系客服!", 3000);
                })
            return
            }
        }
        // 退货退款时， 当用户发起退货退款时，平台客服同意后，用户无法取消退款申请，若用户需要取消申请，只能联系客服
        if (item.refundType === "REFUND_GOODS") {
            if (item.refundStatus === "PRE_USER_SHIP"
            || item.refundStatus === "PRE_PLAT_RECEIVE"
            || item.refundStatus === "PRE_REFUND"
            || item.refundStatus === "REFUNDING"
            || item.refundStatus === "COMPLETE") {
                this.setState({
                    modelVisible1: false
                }, () => {
                    Loading.hide();
                    Toast.show("暂不能进行退款操作,请联系客服!", 3000);
                })
            return
            }
        }
        requestApi.mallOrderMUserRefundCancel(params).then(res => {
            Toast.show('取消退款成功！', 2000)
            callback()
            navigation.goBack()
        }).catch(err => {
            Toast.show('取消失败，请重试！', 2000)
        })
    }
    // 确认收货
    mallOrderMUserConfirmReceive = () => {
        const { orderDetails } = this.state
        const { navigation } = this.props
        // let callback = navigation.getParam('callback', () => { })
        let item = navigation.getParam('data', {})

        // let refundGoods = [];
        // // 判断当前订单中是否存在售后商品，且售后商品未完成流程
        // item.goods && item.goods.map(goodsItem => {
        //     if (goodsItem.refundStatus !== null &&
        //     (goodsItem.refundStatus === 'APPLY'
        //     || goodsItem.refundStatus === 'PRE_USER_SHIP'
        //     || goodsItem.refundStatus === 'PRE_PLAT_RECEIVE'
        //     || goodsItem.refundStatus === 'PRE_REFUND'
        //     || goodsItem.refundStatus === 'REFUNDING')) {
        //         refundGoods.push(goodsItem)
        //     }
        // })
        // if (refundGoods.length > 0) {
        //     Toast.show('当前订单中存在售后商品，暂不能确认收货！')
        //     return
        // }
        Loading.show()
        let params = {
            orderId: orderDetails.orderId
        }
        requestApi.mallOrderMUserConfirmReceive(params).then(res => {
            navigation.navigate("SOMReceivSuccess", {
                callback: () => {},
                orderData: item,
                routerIn: 'SOMOrderDetail'
            });
        }).catch(err => {
            Toast.show("收货失败！", 2000);
        });
    }
    getPayType = () => {
        if(this.state.orderDetails.payInfos){
            let finalValue=[]
            for(let item of this.state.orderDetails.payInfos){
                let type=item.payChannel
                let value=keepTwoDecimalFull(math.divide(item.amount,100))
                let valueItem=''
                switch (type) {
                    case 'xkq':
                        valueItem= '账户余额支付 ' + value;break;
                    case 'xkb':
                        valueItem='晓可币支付 ' + value;break;
                    case 'swq':
                        valueItem='实物券支付 ' + value;break;
                    case 'xfq':
                        valueItem= '消费券支付 ' + value;break;
                    case 'xfqs':
                        valueItem= '店铺消费券支付 ' + value;break;
                    case 'alipay':
                        valueItem= '支付宝支付 ￥' + value;break;
                    case 'wxpay':
                        valueItem= '微信 ￥' + value;break;
                    case 'tfAlipay':
                        valueItem= '天府银行-支付宝支付 ￥' + value;break;
                    case 'tfWxpay':
                        valueItem= '天府银行-微信支付 ￥' + value;break;
                    case 'applePay':
                        valueItem= 'Apple Pay ￥' + value;break;
                    case 'offline':
                        valueItem= '线下支付 ￥' + value;break;
                    default: return '无'
                }
                finalValue.push(valueItem)
            }
            return finalValue
        }
        return null


    }
    // 跳转到评价
    goToEvaluation = (item) => {
        const { navigation } = this.props
        console.log('item', item)
        navigation.navigate('SOMOrderEvaluation', { orderData: item })
    }
    // 匹配物流信息
    getLogisticsInfo = () => {
        const { orderDetails } = this.state
        let { logisticsNo, logisticsName } = orderDetails
        if (logisticsNo === null && logisticsName === null) {
            return null
        }
        switch (logisticsName) {
            case 'XK': return '晓可自营物流  ' + logisticsNo
            case 'SF': return '顺丰  ' + logisticsNo
            case 'YD': return '韵达  ' + logisticsNo
            case 'ZT': return '中通  ' + logisticsNo
            case 'ST': return '申通  ' + logisticsNo
            case 'YT': return '圆通  ' + logisticsNo
            case 'BSHT': return '百世汇通  ' + logisticsNo
            case 'HIMSELF': return '用户自行配送  ' + logisticsNo
            default: return '无'
        }
    }
    // 匹配发票类型

    getInvoiceType = (type = null) => {
        switch (type) {
            case 'PERSONAL': return '个人发票'
            case 'ENTERPRISE': return '企业发票'
            default: return '电子普通发票'
        }
    }
    // 通过支付方式获取商品金额
    getOrderGoodsPrice = (value) => {
        const { orderDetails } = this.state
        if (!orderDetails.payInfos) return '￥ ' + value;
        let payType = orderDetails.payInfos[0].payChannel;
        switch (payType) {
            case 'xkq':
                return '账户余额支付 ' + value
            case 'xkb':
                return '晓可币支付 ' + value
            case 'swq':
                return value + '实物券 '
            case 'xfq':
                return value + '消费券'
            case 'xfqs':
                return '店铺消费券支付 ' + value
            case 'alipay':
                return '￥ ' + value
            case 'wxpay':
                return '￥ ' + value
            case 'tfAlipay':
                return '天府银行-支付宝支付 ￥' + value
            case 'tfWxpay':
                return '天府银行-微信支付 ￥' + value
            case 'applePay':
                return 'Apple Pay ￥' + value
        }
    }
    handleCanRefund = (currentItem) => {
        const { orderDetails } = this.state
        let temp = orderDetails.goodsInfo.map(item => item.refundCount === 2 ? true : false)
        return temp.includes(true)
    }
    getNormalOrderMessage = ({ goodsMessage, orderMessage, ticketMessage, payMessage, logisticsMessage }) => {
        const { navigation, store } = this.props;
        const { orderDetails } = this.state
        const { nextData = {}, data } = navigation.state.params
        let ticketFilter = ticketMessage.filter(item => item.value === '无' || !item.value)
        let ticketObj = ticketFilter.length > 0 ? null : ticketMessage
        let orderReciveTime = [{ title: '收货时间', value: moment(orderDetails.receivedTime * 1000 || new Date()).format('YYYY-MM-DD HH:mm:ss') }];
        if(orderDetails.status === 'active') {
            switch (nextData.key) {
                case 1: return ticketObj ? [goodsMessage,orderMessage, ticketMessage] : [goodsMessage,orderMessage];
                case 2: return ticketObj ? [goodsMessage,orderMessage, payMessage, ticketMessage] : [goodsMessage,orderMessage, payMessage];
                case 3: return ticketObj ? [goodsMessage, orderMessage, payMessage, logisticsMessage, ticketMessage] : [goodsMessage, orderMessage, payMessage, logisticsMessage];
                case 4: return ticketObj ? [goodsMessage, orderMessage, payMessage, logisticsMessage, orderReciveTime, ticketMessage] : [goodsMessage, orderMessage, payMessage, logisticsMessage, orderReciveTime];
                default: return ticketObj ? [goodsMessage, orderMessage, payMessage, logisticsMessage, orderReciveTime, ticketMessage]
                    : [goodsMessage,orderMessage, payMessage, logisticsMessage, orderReciveTime];
            }
        } else {
            return [goodsMessage,orderMessage]
        }
        
    }
    getCommoditOrderMessage = ({ orderMessage, payMessage }) => {
        const { orderDetails } = this.state
        const { navigation, store } = this.props;
        const { nextData = {}, data } = navigation.state.params
        const goodsMessage = [
            { title: '预约金', value:'¥ '+keepTwoDecimalFull(math.divide((orderDetails.amountInfo.payMoney || 0) , 100)) },
            { title: '特惠价', value:'¥ '+keepTwoDecimalFull(math.divide((orderDetails.amountInfo.specialMoney || 0) , 100)) },
        ]
        let comlateGoodsMessage = [
            { title: '预约金', value:'¥ '+keepTwoDecimalFull(math.divide((orderDetails.amountInfo.payMoney || 0) , 100)) },
            { title: '特惠价', value:'¥ '+keepTwoDecimalFull(math.divide((orderDetails.amountInfo.specialMoney || 0) , 100)) },
            { title: '最终交易价格', value:'¥ '+keepTwoDecimalFull(math.divide((orderDetails.tradePrice || 0) , 100)) },
        ]
        let complateTimeMessage = [
            { title: '完成发货交易时间', value: moment(orderDetails.receivedTime * 1000 || new Date()).format('YYYY-MM-DD HH:mm:ss') },
        ]
        if(orderDetails.status === 'active') {
            switch (nextData.key) {
                case 1: return [goodsMessage,orderMessage];
                case 2: return [goodsMessage,orderMessage, payMessage];
                case 3: return [goodsMessage,orderMessage, payMessage];
                case 4: return [comlateGoodsMessage,orderMessage, payMessage, complateTimeMessage];
                default: return [comlateGoodsMessage,orderMessage, payMessage, complateTimeMessage];
            }
        } else {
            return [goodsMessage,orderMessage]
        }
        
    }
    getPersonMessage = (orderDetails) => {
        const goodsMessage = [
            { title: '商品总额', value:'¥ '+keepTwoDecimalFull(math.divide((orderDetails.amountInfo.goodsMoney || 0) , 100)) },
            { title: '运费', value:'¥ '+keepTwoDecimalFull(math.divide((orderDetails.amountInfo.postFee || 0) , 100)) },
            { title: '优惠促销', value: '-¥ '+keepTwoDecimalFull(math.divide((orderDetails.amountInfo.discountMoney || 0) , 100))},
        ]
        const orderMessage = [
            { title: '订单编号', value: orderDetails.orderId || '' },
            { title: '下单时间', value: moment(orderDetails.createTime * 1000 || new Date()).format('YYYY-MM-DD HH:mm:ss') },
        ]
        const payMessage = [
            { title: '支付方式', value: this.getPayType()},
            { title: '支付时间', value: moment(orderDetails.payTime * 1000 || new Date()).format('YYYY-MM-DD HH:mm:ss') },
        ]
        const logisticsMessage = [
            { title: '物流公司', value: this.getLogisticsInfo() },
            { title: '发货时间', value: orderDetails.shippingTime ? moment(orderDetails.shippingTime * 1000 ).format('YYYY-MM-DD HH:mm:ss'): null },
        ]
        
        const ticketMessage = [
            { title: '发票类型', value: orderDetails.invoiceInfo ? this.getInvoiceType(orderDetails.invoiceInfo.invoiceType) : '无' },
            { title: '发票抬头', value: orderDetails.invoiceInfo ? orderDetails.invoiceInfo.head : '无' },
            { title: '发票内容', value: orderDetails.invoiceInfo ? orderDetails.invoiceInfo.invoiceContent : '无' },
        ]
        let messageObj = { orderMessage, ticketMessage, payMessage, logisticsMessage, goodsMessage }
        if (orderDetails.goodsDivide === 2) { // 如果是大宗商品
            return this.getCommoditOrderMessage(messageObj)
        } else {
            return this.getNormalOrderMessage(messageObj)
        }

        
    }
    render() {
        const { navigation, store } = this.props;
        const { nextData = {}, data } = navigation.state.params
        const { orderDetails, showMoreGoods, modalVisible,modelVisible1 } = this.state
        let payMoney =math.divide ((orderDetails.amountInfo.payMoney || 0) , 100)
        let personMessage = this.getPersonMessage(orderDetails)
        let electInvoice = orderDetails.invoiceInfo ? orderDetails.invoiceInfo.electInvoice : null
        console.log('orderDetails', orderDetails)
        console.log('nextData', nextData)
        // console.log('personMessage', personMessage)

        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='订单详情'
                />
                <ScrollView
                showsHorizontalScrollIndicator={false}
                showsVerticalScrollIndicator={false}
                alwaysBounceVertical={false}
                style={{ width: width, padding: 10 }}>
                    <View style={[styles.listView, { padding: 10 }]}>
                        <View style={[styles.row, { justifyContent: 'flex-start', marginBottom: 15 }]}>
                            <ImageView
                                source={require('../../images/order/timer.png')}
                                sourceWidth={17}
                                sourceHeight={17}
                            />
                            <Text style={{ marginLeft: 10, color: '#EE6161', fontSize: 17 }}>
                            {
                                (orderDetails.status === 'del')
                            ? '交易已关闭'
                            : nextData.status
                            }</Text>
                        </View>
                        <View style={[CommonStyles.flex_between]}>
                            <Text style={[styles.topViewText, { flex: 1 }]} numberOfLines={1}>收货人：{orderDetails.addressInfo.userName || ''}</Text>
                            <Text style={[styles.topViewText, { flex: 1, textAlign: 'right' }]}>电话：{orderDetails.addressInfo.userPhone || ''}</Text>
                        </View>
                        <Text style={[styles.topViewText]} numberOfLines={2}>地址：{(orderDetails.addressInfo.userAddress || '').replace(/\s+/g,'')}</Text>
                    </View>
                    <View style={styles.listView}>
                        <View style={styles.itemTop}>
                            <View style={styles.itemTopLeft}>
                                <Text style={{ color: '#222222', fontSize: 14, marginLeft: 9 }}>晓可商城</Text>
                            </View>
                        </View>
                        {
                            orderDetails.goodsInfo && orderDetails.goodsInfo.map((item, index) => {
                                if (!showMoreGoods) {
                                    if (index <= 1) {
                                        return this.renderItem(item, index)
                                    }
                                } else {
                                    return this.renderItem(item, index)
                                }
                            })
                        }
                        {
                            orderDetails.goodsInfo && orderDetails.goodsInfo.length > 2
                                ?
                                <TouchableOpacity style={styles.showMoreGoods} onPress={() => { this.handleChangeState('showMoreGoods', !this.state.showMoreGoods) }}>
                                    {
                                        showMoreGoods
                                            ? <Image style={styles.showMoreGoodsImg} source={require('../../images/mall/zhankai_top.png')} />
                                            : <Image style={styles.showMoreGoodsImg} source={require('../../images/mall/zhankai_bom.png')} />
                                    }
                                    <Text style={styles.showMoreGoodsText}>展开更多</Text>
                                </TouchableOpacity>
                                : null
                        }

                    </View>
                    <View style={[styles.listView, { marginBottom: 20 }]}>
                        {
                            personMessage.map((item, index) => {
                                return (
                                    <View style={[styles.messageView]} key={index}>
                                        <View key={index} style={{flex: 1}}>
                                            {
                                                item.map((item2, index2) => {
                                                    let marginTop = index2 === 0 ? null : {marginTop:5};
                                                    return (
                                                        <View style={[{...marginTop, ...CommonStyles.flex_between}]} key={index2}>
                                                            <Text style={[styles.smallText, { fontSize: 14,lineHeight: 17, lineHeight: 20, width: 70, color: '#555',flex: 1 }]}>{item2.title}:</Text>
                                                            <View style={{flex:1,alignItems:'flex-end'}}>
                                                            {
                                                                item2.value instanceof Array
                                                                ? item2.value.map((item3,index)=>{
                                                                    return(
                                                                        <Text
                                                                            key={index}
                                                                            numberOfLines={1}
                                                                            style={[styles.smallText, { fontSize: 12, lineHeight: 20, color: '#555',flex: 1,textAlign:'right' }]}
                                                                        >
                                                                        { item3 }
                                                                        </Text>
                                                                    )
                                                                })
                                                                : <Text
                                                                    numberOfLines={1}
                                                                    style={[styles.smallText, { fontSize: 12, lineHeight: 20, color: '#555',flex: 1,textAlign:'right' },
                                                                    ]}>
                                                                        { item2.value }
                                                                </Text>
                                                            }
                                                            </View>
                                                        </View>
                                                    )
                                                })
                                            }
                                        </View>
                                        {/* 展示屏蔽发票下载 */}
                                        {/* {
                                            nextData.key >= 3 && index == personMessage.length - 1 && electInvoice
                                                ?
                                                <TouchableOpacity onPress={() => { this.DownloadImage(electInvoice) }} style={{position: 'absolute',right: 8}}>
                                                    <Text style={styles.down}>下载发票</Text>
                                                </TouchableOpacity>
                                                : null
                                        } */}
                                </View>
                                )
                            })
                        }
                    </View>

                </ScrollView>
                {
                    nextData.more &&
                    <View style={[styles.itemBottom, { backgroundColor: 'white', width: width }]}>
                    {nextData.key === 1
                        ? <Text style={[styles.bottomText, { color: '#222222', fontSize: 14 }]}>合计：¥{payMoney.toFixed(2)}</Text>
                        : nextData.more
                            ? <Text style={[styles.bottomText, { color: '#222222',paddingHorizontal: 8,paddingVertical: 10 }]} ref={'popoverDetail'} onPress={() => { this.showPopover() }}>更多</Text>
                            : null
                    }
                    {
                        nextData.nextOperTitle ?
                            <TouchableOpacity style={styles.payBottom} onPress={() => {
                                if (nextData.key === 1) {
                                    this.goToPay() // key === 0 时候，去付款按钮
                                } else if (nextData.key === 3) {
                                    this.mallOrderMUserConfirmReceive()
                                } else if (nextData.key === 6) {
                                    // this.handleCancelRefund()
                                    this.setState({
                                        modelVisible1: true
                                    })
                                } else {
                                    nextData.nextOperFunc(this.props.navigation.getParam('data', {}))
                                }
                            }}>
                                <Text style={[styles.bottomText, { color: '#EE6161', marginLeft: 0 }]}>{nextData.nextOperTitle}</Text>
                            </TouchableOpacity> : null
                    }


                </View>
                }

                <Popover
                    isVisible={this.state.visiblePopover}
                    fromRect={this.state.buttonRect}
                    onClose={() => this.closePopover()}
                    placement={'top'}
                >
                    {
                        nextData.more ? nextData.more.map((item, index) => {
                            if ((orderDetails.dividedAble === 1 && item.title === '申请售后')) { // 判断是否允许退货
                                return null
                            }
                            if ((orderDetails.dividedAble === 0 && item.title === '申请售后') && this.handleCanRefund(orderDetails)) {
                                return null
                            }
                            return (
                                <Text key={index} style={[styles.popContent,styles.androidStyle, index > 0 && Platform.OS === 'ios' ? { paddingTop: 0 } : { paddingTop: 8 }]} onPress={() => {
                                    this.setState({
                                        visiblePopover:false,
                                    }, () => {
                                        item.func()
                                    })
                                 }} key={index}>{item.title}</Text>
                            )
                        }) : null
                    }
                </Popover>
                <ModelConfirm
                    title='确定要取消订单吗？'
                    visible={this.state.modelVisible}
                    onShow={() => this.setState({ modelVisible: true })}
                    onConfirm={() => { this.handleCancelOrder() }}
                    onClose={() => this.setState({ modelVisible: false })}
                />
                <ModelConfirm
                    title='确定要取消退款吗？'
                    visible={this.state.modelVisible1}
                    onShow={() => this.setState({ modelVisible1: true })}
                    onConfirm={() => { this.handleCancelRefund() }}
                    onClose={() => this.setState({ modelVisible1: false })}
                />
            </View >
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center'
    },
    flex_between: {
        justifyContent: 'space-between',
        flexDirection: 'row',
    },
    listView: {
        width: width - 20,
        backgroundColor: 'white',
        borderWidth: 1,
        borderColor: '#F1F1F1',
        borderRadius: 6,
        marginBottom: 10,
        overflow: 'hidden'
    },
    itemView: {


    },
    popContent: {
        fontSize: 12,
        color: '#222',
        textAlign: 'center',
        paddingVertical: 6,
        backgroundColor: '#fff',
        padding: 6,
        borderBottomColor: '#f1f1f1',
        borderBottomWidth: 1,
    },
    itemTitleText: {
        fontSize: 16,
        color: '#333',
    },
    unSelected: {
        borderColor: '#979797',
        borderWidth: 1,
        borderRadius: 15,
        width: 15,
        height: 15
    },
    itemTopLeft: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    itemTop: {
        flexDirection: 'row',
        alignItems: 'center',
        height: 32,
        justifyContent: 'space-between',
        paddingHorizontal: 14,
        borderBottomWidth: 1,
        borderColor: '#F1F1F1',

    },
    itemTopRight: {
        color: '#EE6161',
        fontSize: 14,
    },
    itemContent: {
        ...CommonStyles.flex_start_noCenter,
        padding: 14,
        borderBottomWidth: 1,
        borderColor: '#F1F1F1',
    },
    itemContentLeft: {
        width: 80,
        height:80,
        borderWidth: 1,
        borderColor: '#F1F1F1',
        borderRadius: 6,
        marginRight: 10,
        alignItems: 'center',
        justifyContent: 'center'
    },
    itemContentRight: {
        flex: 1
    },
    smallText: {
        color: '#999999',
        fontSize: 10,
        lineHeight: 14
    },
    itemBottom: {
        flexDirection: 'row',
        alignItems: 'center',
        height: 40 + CommonStyles.footerPadding,
        justifyContent: 'flex-end',
        paddingHorizontal: 14,
        paddingBottom: CommonStyles.footerPadding,
    },
    bottomText: {
        marginLeft: 14,
        fontSize: 12
    },
    payBottom: {
        borderColor: '#EE6161',
        borderWidth: 1,
        paddingHorizontal: 18,
        paddingVertical: 3,
        marginLeft: 20,
        borderRadius: 12
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between'
    },
    topViewText: {
        color: '#555555',
        fontSize: 12,
        marginBottom: 4
    },
    downWrap: {
        borderRadius: 12,
        backgroundColor: '#4A90FA',
        width: 70,
        overflow: 'hidden'
    },
    down: {
        color: '#fff',
        fontSize: 12,
        backgroundColor: '#4A90FA',
        borderRadius: 12,
        width: 70,
        textAlign: 'center',
        lineHeight: 20
    },
    messageView: {
        borderBottomWidth: 1,
        borderColor: '#F1F1F1',
        padding: 10,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        flex:1,
        position: 'relative'
    },
    showMoreGoods: {
        paddingVertical: 15,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#fff'
    },
    showMoreGoodsText: {
        fontSize: 12,
        color: '#999',
        paddingLeft: 5
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
    showReundText: {
        fontSize: 12,
        color: CommonStyles.globalHeaderColor,
    },
    androidStyle: {
        borderBottomWidth:1,
        borderColor: '#f1f1f1',
        paddingTop: 8,
        paddingBottom: 8,
    },
});

export default connect(
    (state) => ({ store: state }),
    (dispatch) => ({ dispatch })
)(SOMOrderDetailsScreen);
