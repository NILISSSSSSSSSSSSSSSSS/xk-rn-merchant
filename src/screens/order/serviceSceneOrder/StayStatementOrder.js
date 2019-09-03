/**
 * 服务+现场点单-待接单订单
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
    RefreshControl
} from "react-native";
import ListView from 'deprecated-react-native-listview';
import { connect } from "rn-dva"
import moment from 'moment'
import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import SwipeListView from '../../../components/SwipeListView'
import * as orderRequestApi from '../../../config/Apis/order'
import { scan } from '../../../config/scanConfig'
import CountDown from '../../../components/CountDown'
import * as nativeApi from '../../../config/nativeApi';
import ImageView from "../../../components/ImageView";
import { NavigationComponent } from "../../../common/NavigationComponent";
import ActionSheet from "../../../components/Actionsheet";
import { keepTwoDecimal } from "../../../config/utils";
import { ORDER_STATUS_ONLINE, ORDER_STATUS_ONLINE_DESCRIBE } from "../../../const/order";
import  math from "../../../config/math.js";
const tuiKuan = require('../../../images/shopOrder/tuiKuan.png')
const add = require('../../../images/shopOrder/add.png')
const green = require('../../../images/account/xiaokebi.png')
const shiwuquan = require('../../../images/account/shiwuquan.png')

const { width, height } = Dimensions.get("window")

function getwidth(val) {
    return width * val / 375
}

class StayStatementOrder extends NavigationComponent {
    state = {
        showCountDown: true,
    }
    constructor(props) {
        super(props)
        this.ds = new ListView.DataSource({ rowHasChanged: (r1, r2) => r1 !== r2 });
    }
    changeorderStatus = (orderId) => {
        this.initDataDidMount(orderId)
    }
    initDataDidMount = () => {
        const { fetchOBMBcleOrderDetails } = this.props;
        let orderId = this.props.navigation.state.params.orderId
        fetchOBMBcleOrderDetails(orderId, this.isShouhou);
    }
    componentDidMount() {
        let orderId = this.props.navigation.state.params.orderId
        this.isShouhou = this.props.navigation.state.params.isShouhou
        this.initDataDidMount(orderId)
    }
    getpBcleOrderPayStatus = (item, isServuice) => {
        let payState = ''
        if (isServuice) {
            payState = item.bcleOrderPayStatus
        } else {
            payState = item.pBcleOrderPayStatus
        }

        switch (payState) {
            case 'NOT_PAY': case 'DURING_PAY':
                return '未支付'
            case 'SUCCESS_PAY':
              return '支付成功'
            case 'APPLY_REFUND':
                return '已支付需退款'
            case 'AGREE_REFUND':
                return '同意退款'
            case 'REFUSE_REFUND':
                return '拒绝退款'
            case 'SUCCESS_REFUND':
                return '退款成功'
        }
    }
    renderSrvice = () => {
        let { orderDetail } = this.props;
        let { serviceData: data = [] } = orderDetail || {};
        if (data.length) {
            return data.map((item, index) => {
                let borderBt = styles.borderBt
                if (index === data.length - 1) {
                    borderBt = null
                }
                let litterTitle = null
                if (!item.itemRefundId) {
                    litterTitle = styles.cgreenF14
                } else {
                    litterTitle = styles.cyellowF14
                }
                let sourcePic = this.getSourcePic(item, true)
                return (
                    <View key={index}>
                        {
                            this.isShouhou && (
                                <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginTop: 6, alignItems: 'center' }}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Image source={sourcePic ? green : shiwuquan} />
                                        {
                                            item.itemRefundId && <Text style={[styles.c7f14, {marginLeft: 8}]}>售后编号：{item.itemRefundId}</Text>
                                    }
                                    </View>
                                <Text style={litterTitle}>{this.getpBcleOrderPayStatus(item, true)}</Text>
                                </View>
            )
        }
                        <View style={[styles.serviceItem, borderBt]} key={index}>
                            <View style={styles.serviceItemimg}>
                                <ImageView source={{ uri: item.skuUrl}} sourceWidth={getwidth(80)} sourceHeight={getwidth(80)} resizeMode='cover'/>
                            </View>
                            <View style={{ flex: 1, height: 80, marginLeft: 15, alignSelf: 'center' }}>
                                <View style={styles.textItem}>
                                    <View style={{ flex: 1 }}>
                                        <Text style={styles.c2f14}>{item.name || item.goodsName}</Text>
                                    </View>
                                </View>
                                <View style={{ marginTop: 13 }}>
                                    <Text style={styles.c7f12}>{item.skuName}</Text>
                                </View>
                                <View style={{ flexDirection: 'row', marginTop: 15, alignItems: 'center' }}>
                                    <Text style={styles.credf14}>
                                        ￥
                                    {
                                        keepTwoDecimal(math.divide(this.isShouhou && item.bcleOrderPayStatus== "SUCCESS_PAY"?item.paymentPrice:item.platformShopPrice , 100))
                                    }
                                    </Text>
                                    <Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}>
                                        (市场价￥{keepTwoDecimal(math.divide(item.originalPrice || 0,100) )})
                                    </Text>
                                </View>
                            </View>
                            {
                                item.status === 'active' && item.isAgree === 1 &&
                                < View style={{ height: 44, width: getwidth(80), alignItems: 'center', justifyContent: 'center' }}>
                                    <Text style={styles.cbf14}>{this.getpayStatusActive(item.payStatus)}</Text>
                                </View>
                            }
                            {
                                item.status === 'del' &&
                                <View style={{ height: 44, width: getwidth(80), alignItems: 'center', justifyContent: 'center' }}>
                                    <Text style={styles.cbf14}>{this.getpayStatus(item.payStatus, item.isAgree, item.isAgree)}</Text>
                                </View>

                            }
                        </View>
                    </View>
                )
            })
        } else {
            return null
        }
    }
    getpayStatus = (payStatus, confirmStatus, isAgree) => {
        if (confirmStatus === 1 || isAgree === 1) {
            return '已关闭'
        }
        switch (payStatus) {
            case 'FAILED_REFUND': case 'APPLY_REFUND':
                return '申请中'
            case 'NOT_PAY':
                return '申请中'
            case 'DURING_PAY':
                return '申请中'
            case 'SUCCESS_PAY':
                return '申请中'
            case 'AGREE_REFUND':
                return '同意退款'
            case 'REFUSE_REFUND':
                return '拒绝退款'
            case 'SUCCESS_REFUND':
                return '退款成功'
        }

    }
    getSourcePic = (item, isServuice) => {
        let payState = ''
        if (isServuice) {
            payState = item.bcleOrderPayStatus
        } else {
            payState = item.pBcleOrderPayStatus
        }
        if (payState == 'NOT_PAY' || payState == 'DURING_PAY' || payState == 'DURING_PAY') {
            return true
        } else {
            return false
        }
    }
    getpayStatusActive = (payStatus) => {
        switch (payStatus) {
            case 'NOT_PAY':
                return '未支付'
            case 'DURING_PAY':
                return '支付中'
            case 'SUCCESS_PAY':
                return '支付成功'
            case 'REFUSE_REFUND':
              return '拒绝退款'
            case 'SUCCESS_REFUND':
                return '退款成功'
            case 'FAILED_REFUND': case 'APPLY_REFUND':
                return '申请中'
            case 'AGREE_REFUND':
                return '同意退款'
        }
    }
    getAllWeiFuKuanData = () => {
        const { orderDetail } = this.props;
        const { serviceData = [] } = orderDetail || {};
        let resu = []
        serviceData.forEach((serceItem) => {
            if (serceItem.goods) {
                serceItem.goods.forEach((item) => {
                    if (item.confirmStatus === 0 && item.status === 'active') {
                        resu.push(item)
                    }
                })
            }
        })
        return resu
    }
    renderGoods = (item, some, key) => {
        let borderBt = styles.borderBt
        let litterTitle = null
        if (!item.pPurchaseRefundId) {
            litterTitle = styles.cgreenF14
        } else {
            litterTitle = styles.cyellowF14
        }
        let sourcePic = this.getSourcePic(item, false)
        console.log('item',item)
        return (
            <View key={key}>
                {
                    this.isShouhou && (
                        <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginTop: 6, alignItems: 'center' }}>
                            <View style={{ flexDirection: 'row' }}>
                                <Image source={sourcePic ? green : shiwuquan} />
                                {
                                    item.pPurchaseRefundId && <Text style={styles.c7f14}>售后编号：{item.pPurchaseRefundId}</Text>
                                }
                            </View>
                            <Text style={litterTitle}>{this.getpBcleOrderPayStatus(item, false)}</Text>
                        </View>
                    )
                }
                <View style={[styles.serviceItem, borderBt]} key={item.index}>
                    <View style={styles.serviceItemimg}>
                        <Image source={{ uri: item.goodsSkuUrl }} style={{ width: getwidth(80), height: getwidth(80) }} />
                    </View>
                    <View style={{ flex: 1, height: 80, marginLeft: 15, alignSelf: 'center' }}>
                        <View style={styles.textItem}>
                            <View style={{ flex: 1 }}>
                                <Text style={styles.c2f14}>{item.name || item.pName}</Text>
                            </View>
                        </View>
                        <View style={{ marginTop: 13 }}>
                            <Text style={styles.c7f12}>{item.goodsSkuName || item.pSkuName}</Text>
                        </View>
                        <View style={{ flexDirection: 'row', height: 44, alignItems: 'center', justifyContent: 'space-between' }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                <Text style={styles.credf14}>
                                    ￥
                                    {
                                        keepTwoDecimal(math.divide(this.isShouhou?item.pPaymentPrice: (item.platformShopPrice || item.pPlatformShopPrice) , 100) )
                                    }

                                </Text>
                                <Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}>
                                    (市场价￥{keepTwoDecimal(math.divide(item.originalPrice || item.pOriginalPrice , 100) )})
                            </Text>
                            </View>
                            {
                                item.confirmStatus === 0 && item.status === 'active'  && item.mainStatus == 'STAY_ORDER' && (
                                    <TouchableOpacity
                                        onPress={() => {
                                            let weiFukuanData = this.getAllWeiFuKuanData()
                                            const { navigation } = this.props
                                            const { orderId, shopId } = navigation.state.params
                                            navigation.navigate('RefundOrSettlement', { data: weiFukuanData, status: 2, orderId, shopId, initDataDidMount: this.initDataDidMount })
                                        }}
                                        style={{ height: 44, width: getwidth(80), alignItems: 'center', justifyContent: 'center' }}>
                                        <Text style={styles.cbf14}>确认接单</Text>
                                    </TouchableOpacity>
                                )
                            }
                            {
                                item.status === 'active' && item.confirmStatus === 1 &&
                                < View style={{ height: 44, width: getwidth(80), alignItems: 'center', justifyContent: 'center' }}>
                                    <Text style={styles.cbf14}>{this.getpayStatusActive(item.payStatus)}</Text>
                                </View>
                            }
                            {
                                item.status === 'del' &&
                                <View style={{ height: 44, width: getwidth(80), alignItems: 'center', justifyContent: 'center' }}>
                                    <Text style={styles.cbf14}>{this.getpayStatus(item.payStatus, item.confirmStatus, item.isAgree)}</Text>
                                </View>

                            }
                        </View>
                    </View>
                </View >
            </View>
        )
    }

    changeOrderStatus = (orderStatus2, status, isAgree) => {
        this.initDataDidMount()
    }
    cancelTheOrder = () => {
        const { navigation } = this.props
        let orderId = navigation.state.params.orderId
        let shopId = navigation.state.params.shopId
        navigation.navigate('CancelOrder', { orderId, shopId, changeOrderStatus: this.changeOrderStatus, initData: this.initDataDidMount })
    }
    confirmOrder = () => {
        const { navigation } = this.props;
        let orderId = navigation.state.params.orderId
        let shopId = navigation.state.params.shopId
        orderRequestApi.fetcShopAgreeOrder({ orderId, shopId }).then((res) => {
            this.initDataDidMount(orderId)
        }).catch((err)=>{
            console.log(err)
          });
    }

    concatUser = () => {//联系客户
        let { orderDetail, userShop } = this.props;
        Loading.show()
        orderRequestApi.mCustomerServiceContactUser({
            customerId: orderDetail.userId,
            shopId: userShop.id
        }).then((res) => {
            console.log(res)
            if (res && res.tid) {
                nativeApi.createShopCustomerWithCustomerID(res.tid, res.userId, res.username, userShop.id)
            }
        }).catch(err => {
            console.log(err)
        });
    }

    renderBtttomBtn = (isClosed) => {
        let { orderDetail, userShop, navigation } = this.props;
        const { orderStatus, orderId, agree_pay, updataSettlement, serviceData = [], startTime, endTime, status, canCancelOrder } = orderDetail || {}
        const { shopId, initData } = navigation.state.params

        let buttons = []
        if(!isClosed) {
            switch (orderStatus) {
                case ORDER_STATUS_ONLINE.STAY_ORDER:
                    buttons.push({ title: "取消订单", style: [styles.fixedWidth, { backgroundColor: '#EE6161' }], titleStyle: styles.cf14, onPress: ()=>  this.cancelTheOrder()})
                    buttons.push({ title: "确认接单", style: [styles.fixedWidth, { backgroundColor: '#4A90FA' }], titleStyle: styles.cf14, onPress: ()=>  this.confirmOrder()})
                    break;
                case ORDER_STATUS_ONLINE.STAY_PAY:
                    buttons.push({ title: "取消订单", style: [styles.fixedWidth, { backgroundColor: '#EE6161' }], titleStyle: styles.cf14, onPress: ()=>  this.cancelTheOrder()})
                    break;
                case ORDER_STATUS_ONLINE.STAY_CONSUMPTION:
                    buttons.push({ title: "取消订单", style: [styles.fixedWidth, { backgroundColor: '#EE6161' }], titleStyle: styles.cf14, onPress: ()=>  this.cancelTheOrder()})
                    buttons.push({ title: "确认到店", style: [styles.fixedWidth, { backgroundColor: '#4A90FA' }], titleStyle: styles.cf14, onPress: ()=>  this.ActionSheet.show()})
                    break;
                case ORDER_STATUS_ONLINE.CONSUMPTION_CENTRE:
                    if(canCancelOrder) {
                        buttons.push({ title: "取消订单", style: [styles.fixedWidth, { backgroundColor: '#EE6161' }], titleStyle: styles.cf14, onPress: ()=>  this.cancelTheOrder()})
                    }
                    if(agree_pay) {
                        buttons.push({ title: "订单计算", style: [styles.fixedWidth, { backgroundColor: '#4A90FA' }], titleStyle: styles.cf14, onPress: ()=> {
                            const { shopId } = this.props.navigation.state.params
                            navigation.navigate('ChooseCalculateGoods', { shopId: shopId, orderId, initDataDidMount: this.initDataDidMount })
                        } })
                    }
                    if(updataSettlement) {
                        buttons.push({ title: "修改结算", style: [styles.fixedWidth, { backgroundColor: '#4A90FA' }], titleStyle: styles.cf14, onPress: ()=> {
                            const { shopId } = this.props.navigation.state.params
                            navigation.navigate('ChooseCalculateGoods', { shopId: shopId, orderId, initDataDidMount: this.initDataDidMount })
                        } })
                    }
                    break;
                case ORDER_STATUS_ONLINE.SHOU_HOU:
                    buttons.push({ title: "拒绝取消", style: [styles.fixedWidth, { backgroundColor: '#EE6161' }], titleStyle: styles.cf14, onPress: ()=>  {
                        navigation.navigate('RefusedRefund', { status, orderId, shopId, initData: initData,serviceData: serviceData, startTime, endTime, })
                    }})
                    buttons.push({ title: "确认取消", style: [styles.fixedWidth, { backgroundColor: '#4A90FA' }], titleStyle: styles.cf14, onPress: ()=>  {
                        if(status==='del') {
                            this.fetchMUserAgreeOrRejectCancelOrder();
                            return
                        }
                        navigation.navigate('RefundServiceList', { status, serviceData: serviceData, shopId: shopId, orderId: orderId, startTime, endTime, initData: initData })
                    }})
                    break;
                default:
                    break;
            }
        }

        buttons.unshift(
            { title: "联系客户", style: [styles.kefu, { alignItems: buttons.length>0? 'flex-start' : 'center' }], titleStyle: styles.c2f14, onPress: ()=>  this.concatUser()}
        )

        return <View style={styles.bottomBtn}>
            {
                buttons.map(btn=>
                <TouchableOpacity style={btn.style} activeOpacity={0.8} onPress={()=> btn.onPress()}>
                    <Text style={btn.titleStyle}>{btn.title}</Text>
                </TouchableOpacity>)
            }
        </View>
    }
    fetchMUserAgreeOrRejectCancelOrder = ()=> {
        const { navigation, orderDetail } = this.props;
        const { shopId, initData } = navigation.state.params
        let param = {
            orderMUserAgree: {
                orderId: orderDetail.orderId,
                shopId: shopId,
                agree: 1
            }
        }
        Loading.show();
        orderRequestApi.fetchMUserAgreeOrRejectCancelOrder(param).then((res) => {
            Toast.show('同意退款成功')
            if (initData) {
                initData()
            }
            navigation.goBack()
            Loading.hide();
        }).catch(()=> Loading.hide())
    }
    closeRow(rowMap, rowKey) {
        if (rowMap && rowMap[rowKey]) {
            rowMap[rowKey].closeRow();
        }
    }
    onRowDidOpen = (rowKey, rowMap) => {
        setTimeout(() => {
            this.closeRow(rowMap, rowKey);
        }, 2000);
    }
    renderlistEmptyComponent = () => {
        return (
            <View style={styles.nogoods}>
                <Text>暂无商品</Text>
            </View>
        )
    }
    getTotalMoney = () => {
        const { orderDetail } = this.props;
        const { serviceData = [] } = orderDetail || {};
        let totalMoney = 0
        serviceData.forEach((item) => {
            totalMoney =totalMoney + item.platformShopPrice ;// fix: 服务、服务加加购 取platformShopPrice
            (item.goods || []).map((item1)=>{
                item1.payStatus== "SUCCESS_PAY" && item1.status== "active"? totalMoney =totalMoney + item1.platformShopPrice:null
            })
        })
        return totalMoney
    }
    sureDeleteItem = (deleteItemInfo) => {
        const { orderDetail } = this.props;
        this.initDataDidMount(orderDetail.orderId)
    }
    deleteSomeSeatGoodsItem = (data, secId, rowId, rowMap, serviceIndex) => {
        const { orderDetail } = this.props;
        if (data.isCustomerAdd) {
            const { navigation } = this.props
            const { shopId } = navigation.state.params
            let deleteItemInfo = {
                goodsId: data.goodsId,
                goodsSkuCode: data.goodsSkuCode,
                serviceIndex: serviceIndex
            }
            this.closeRow(rowMap, `${secId}${rowId}`)
            navigation.navigate('BatchCancelOrder', { deleteItemInfo: deleteItemInfo, shopId, purchaseId: data.purchaseId, sureDelete: this.sureDeleteItem })
        } else {
            let { serviceData } = orderDetail || {};
            let delIndex = -1
            serviceData[serviceIndex].goods.find((item, index) => {
                if (item.goodsId === data.goodsId && item.goodsSkuCode === data.goodsSkuCode && !item.isCustomerAdd) {
                    delIndex = index
                    return true
                }
            })
            this.closeRow(rowMap, `${secId}${rowId}`)
            serviceData[serviceIndex].goods.splice(delIndex, 1)
            this.setState({
                serviceData
            })
        }

    }
    getAllGoodsMoney = (goods = []) => {
        let totalMoney = 0
        goods.forEach((item) => {
            if (!(item.status === 'del' && item.confirmStatus === 1 || item.isAgree === 1 || item.payStatus == 'SUCCESS_REFUND')) {
                totalMoney += item.platformShopPrice
            }
        })
        return keepTwoDecimal(totalMoney)
    }
    renderSameSeatItem = () => {
        const { orderDetail, navigation } = this.props;
        const { serviceData = [], orderStatus, orderId, canAddGoods } = orderDetail || {}
        return serviceData.map((item, serviceIndex) => {
            let bottomView = item.goods && item.goods.length===0 ? styles.serviceBottomNogoods : styles.serviceBottom
            return (
                <View style={[styles.servicView, { marginTop: 10 }]} key={item.itemId}>
                    <View style={styles.serviceTitle2}>
                        <Text style={styles.c2f14}>席位：{item.seatName}</Text>
                        {
                            (orderStatus === ORDER_STATUS_ONLINE.STAY_PAY || orderStatus === ORDER_STATUS_ONLINE.STAY_CONSUMPTION) && canAddGoods && (
                                <TouchableOpacity
                                    onPress={() => {
                                        navigation.navigate('EditorMenu', { orderId, needFetch: true, itemId: item.itemId, purchased: 1, serviceCatalogCode: '1002', shopId: this.props.navigation.state.params.shopId, serviceData: [], initDataDidMount: this.initDataDidMount })
                                    }}
                                    style={{ flexDirection: 'row', alignItems: 'center' }}
                                >
                                    <Text style={styles.cbf14}>添加 </Text>
                                    <Image source={add} />
                                </TouchableOpacity>
                            )
                        }
                    </View>
                    {
                        item.goods &&
                        <SwipeListView
                            dataSource={this.ds.cloneWithRows(item.goods)}
                            showsVerticalScrollIndicator={false}
                            renderRow={this.renderGoods}
                            ListEmptyComponent={this.renderlistEmptyComponent}
                            renderHiddenRow={(data, secId, rowId, rowMap) => {
                                if (this.isShouhou || data.status==="del") {
                                    return null
                                } else {
                                    return (
                                        <TouchableOpacity
                                            onPress={() => {
                                                this.deleteSomeSeatGoodsItem(data, secId, rowId, rowMap, serviceIndex)
                                            }}
                                            style={styles.rowBack}>
                                            <Text style={styles.cf14}>删除</Text>
                                        </TouchableOpacity>
                                    )
                                }
                            }}
                            leftOpenValue={75}
                            rightOpenValue={-150}
                            onRowDidOpen={this.onRowDidOpen}
                        />

                    }

                    <View style={bottomView}>
                        <View style={styles.serviceBottomItem}>
                            <View><Text style={styles.c7f14}>总数：</Text></View>
                            <View><Text style={styles.c2f14}>x{item.goods && item.goods.length}</Text></View>
                        </View>
                        {
                            this.isShouhou ? (
                                <View style={styles.serviceBottomItem}>
                                    <View><Text style={styles.c7f14}>总金额：</Text></View>
                                    <View><Text style={styles.credf14}>￥{keepTwoDecimal(math.divide(item.iPirce ,100))}</Text></View>
                                </View>
                            ) : (
                                    <View style={styles.serviceBottomItem}>
                                        <View><Text style={styles.c7f14}>总金额：</Text></View>
                                        <View><Text style={styles.credf14}>￥{Number(math.divide(this.getAllGoodsMoney(item.goods) || 0,100))}</Text></View>
                                    </View>
                                )
                        }
                        {
                            this.isShouhou && (

                                <View style={styles.serviceBottomItem}>
                                    <View><Text style={styles.c7f14}>实际支付：</Text></View>
                                    <View><Text style={styles.credf14}>￥{keepTwoDecimal(math.divide(item.iPPayPirce , 100) )}</Text></View>
                                </View>
                            )
                        }
                    </View>

                </View>
            )
        })
    }
    getQrCodeData = (param) => {
        const { orderId } = this.props.navigation.state.params
        orderRequestApi.fetchBcleMUserConfirmConsume({ 
            consumeCode: param.consumeCode ,
            orderId
        }).then((res) => {
            this.initDataDidMount(orderId)
        }).catch(err => {
            console.log(err)
        });
    }
    scanQrCode = () => {
        const { navigation } = this.props
        const { shopId, userId,orderId } = navigation.state.params
        scan(navigation, userId, shopId, this.getQrCodeData,this.initDataDidMount)
    }
    handleTimerOnEnd = () => {
        this.setState({
            showCountDown: false
        })
    }
    render() {
        const { navigation, orderDetail } = this.props
        const { showCountDown } = this.state;
        const { orderStatus, seatData = [],
            createdAt, orderId, startTime, endTime, phone, orderReason = "", totalVoucher, totalShopVoucher, refundXfq, refundXfqs,
            consumerNum, remark, totalMoney,subPhone, goodsNum, seatId, serviceData = [],resmoney,
            price, pPrice, pPayPirce,money, discountName, discountMoney, isAll, updatedAt, taskTime,getSomeData,totalCash,totalReal } = orderDetail || {}

        console.log(orderStatus, orderDetail);

        let topTitleData = ORDER_STATUS_ONLINE_DESCRIBE[orderStatus] || {};
        let topHeight = 94
        if (!topTitleData.tips) {
            topHeight = 66
        }
        let countdown = -1
        let canCountDown = [ORDER_STATUS_ONLINE.STAY_ORDER, ORDER_STATUS_ONLINE.STAY_PAY, ORDER_STATUS_ONLINE.STAY_EVALUATE].includes(orderStatus);
        let canComplete = [ORDER_STATUS_ONLINE.COMPLETELY, ORDER_STATUS_ONLINE.CLOSE].includes(orderStatus);
        if (canCountDown && taskTime && updatedAt) {
            //倒计时
            // countdown = (taskTime * 1000 - (new Date().getTime() - updatedAt * 1000))
            countdown = Number(taskTime) * 1000
        }
        if ( [ORDER_STATUS_ONLINE.COMPLETELY, ORDER_STATUS_ONLINE.CLOSE].includes(orderStatus) && updatedAt) {
            countdown = moment(updatedAt * 1000).format('YYYY-MM-DD HH:mm:ss')
        }
        let rightView = null
        let isClosed=false
        if(topTitleData.tips && canCountDown && countdown !== -1){
                showCountDown && countdown > 0 ?null:orderStatus == ORDER_STATUS_ONLINE.STAY_EVALUATE ?null:isClosed=true
        }
        if (orderStatus === ORDER_STATUS_ONLINE.STAY_ORDER && !isClosed) {
            rightView = (
                <View style={{ width: 50, height: '100%' }}>
                    <TouchableOpacity
                        style={{ position: 'absolute', left: -50, width: 100, height: '100%', justifyContent: 'center', alignItems: 'center' }}
                        onPress={() => {
                            const shopId = this.props.navigation.state.params.shopId

                            navigation.navigate('ChangeOrders', {subPhone, orderStatus, startTime, seatData: JSON.parse(JSON.stringify(seatData)), phone, consumerNum, remark, orderId, shopId, totalMoney, serviceData: JSON.parse(JSON.stringify(serviceData)), changeorderStatus: this.changeorderStatus })
                        }}
                    >
                        <Text style={{ color: '#FFFFFF', fontSize: 17 }}>修改订单</Text>
                    </TouchableOpacity>
                </View>
            )
        }
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    leftView={<TouchableOpacity
                        style={[styles.headerItem, styles.left]}
                        onPress={() => {
                            let initData = this.props.navigation.state.params.initData
                            if (initData) {
                                initData()
                            }
                            navigation.goBack()
                        }}
                    >
                        <Image source={require('../../../images/mall/goback.png')} />
                    </TouchableOpacity>}
                    title='订单详情'
                    rightView={rightView}
                />
                <View style={[styles.topState, { height: topHeight }]}>
                    <View style={[styles.topItem, { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }]}>
                        <Text style={{ color: '#222222', fontSize: 21 }}>{isClosed?'已关闭':topTitleData.name}</Text>
                        <Image source={tuiKuan} style={{ width: getwidth(28), height: getwidth(28) }} />
                    </View>
                    {
                        topTitleData.tips ? (
                            <View style={[styles.topItem, { justifyContent: 'center' }]}>
                                {
                                    !(canComplete || canCountDown) ? (
                                        <Text style={styles.c7f14}>{topTitleData.tips}</Text>
                                    ) : (
                                        canCountDown && countdown !== -1 ? (
                                                showCountDown && countdown > 0 ? (
                                                    <View style={{ flexDirection: 'row' }} >
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
                                                        <Text style={{
                                                            fontSize: 12, color: 'rgba(85, 85, 85, 1)'
                                                        }}>{topTitleData.tips}</Text>
                                                    </View>
                                                ) : (
                                                        <Text> {orderStatus == ORDER_STATUS_ONLINE.STAY_EVALUATE ? '系统默认好评' : '系统已经自动关闭'}</Text>
                                                    )
                                            ) : (
                                                    <Text style={styles.c7f14}>{topTitleData.tips}：{countdown}</Text>
                                                )
                                        )
                                }

                            </View>
                        ) : null
                    }
                </View>
                <ScrollView
                    style={styles.scrollList}
                    showsVerticalScrollIndicator={false}
                    refreshControl={
                        <RefreshControl
                            refreshing={this.props.refreshing}
                            onRefresh={() => this.initDataDidMount()}
                        />
                    }
                >
                    <View style={styles.orderCode}>
                        <View style={[styles.orderCodeItem, { borderBottomColor: '#D7D7D7', borderBottomWidth: 0.5 }]}>
                            <Text style={styles.c7f14}>订单编号</Text>
                            <Text style={styles.c2f14}>{orderId}</Text>
                        </View>
                        <View style={styles.orderCodeItem}>
                            <Text style={styles.c7f14}>下单时间</Text>
                            <Text style={styles.c2f14}>{moment(createdAt * 1000).format('YYYY-MM-DD HH:mm:ss')}</Text>
                        </View>
                    </View>
                    <View style={styles.servicView}>
                        <View style={styles.serviceTitle}>
                            <Text style={styles.c2f14}>服务</Text>
                        </View>
                        {
                            this.renderSrvice()
                        }
                        {
                            !this.isShouhou ? (
                                <View style={[styles.serviceBottom, { borderTopColor: '#D7D7D7', borderTopWidth: 0.5, }]}>
                                    < View style={styles.serviceBottomItem} >
                                        <View><Text style={styles.c7f14}>总数：</Text></View>
                                        <View><Text style={styles.c2f14}>x{serviceData.length || 0}</Text></View>
                                    </View>
                                    <View style={styles.serviceBottomItem}>
                                        <View><Text style={styles.c7f14}>总金额：</Text></View>
                                        <View><Text style={styles.credf14}>￥{keepTwoDecimal(math.divide(this.getTotalMoney() , 100) )}</Text></View>
                                    </View>
                                    <View style={styles.serviceBottomItem}>
                                            <View><Text style={styles.c7f14}>消费券支付：</Text></View>
                                            <View><Text style={styles.c2f14}>{keepTwoDecimal(math.divide(getSomeData.voucher , 100) )}</Text></View>
                                        </View>
                                    <View style={styles.serviceBottomItem}>
                                            <View><Text style={styles.c7f14}>商家券支付：</Text></View>
                                            <View><Text style={styles.c2f14}>{keepTwoDecimal(math.divide(getSomeData.shopVoucher , 100) )}</Text></View>
                                        </View>

                                    <View style={styles.serviceBottomItem}>
                                        <View><Text style={styles.c7f14}>现金支付：</Text></View>
                                        <View><Text style={styles.credf14}>￥{keepTwoDecimal(math.divide(resmoney,100) )}</Text></View>
                                    </View>
                                </View>
                            ) : (
                                    <View style={[styles.serviceBottom2, { borderTopColor: '#D7D7D7', borderTopWidth: 1, }]}>
                                        <View style={styles.serviceBottomItem}>
                                            <View><Text style={styles.c7f14}>订单总额：</Text></View>
                                            <View><Text style={styles.c2f14}>¥{math.divide(Number(price) , 100)}</Text></View>
                                        </View>
                                        <View style={styles.serviceBottomItem}>
                                            <View><Text style={styles.c7f14}>消费券：</Text></View>
                                            <View><Text style={styles.c2f14}>{math.divide(totalVoucher , 100) }</Text></View>
                                        </View>
                                        <View style={styles.serviceBottomItem}>
                                            <View><Text style={styles.c7f14}>实际支付：</Text></View>
                                            <View><Text style={styles.credf14}>¥{math.divide(totalReal,100)}</Text></View>
                                        </View>
                                        <View style={styles.serviceBottomItem}>
                                            <View><Text style={styles.c7f14}>现金支付：</Text></View>
                                            <View><Text style={styles.c2f14}>¥{math.divide(totalCash , 100) }</Text></View>
                                        </View>
                                        <View style={styles.serviceBottomItem}>
                                            <View><Text style={styles.c7f14}>商家券支付：</Text></View>
                                            <View><Text style={styles.c2f14}>{math.divide(totalShopVoucher, 100) }</Text></View>
                                        </View>
                                        <View style={styles.serviceBottomItem}>
                                            <View><Text style={styles.c7f14}>优惠说明：</Text></View>
                                            <View><Text style={styles.c2f14}>{discountName}{discountMoney ?math.divide(discountMoney , 100) :'暂无'}</Text></View>
                                        </View>
                                    </View>
                                )
                        }
                    </View>

                    <View style={styles.infoView}>
                        <View style={styles.infoItem}>
                            <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>预约时间</Text></View>
                            <Text style={styles.c2f14}>{startTime}</Text>
                        </View>
                        <View style={styles.infoItem}>
                            <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>席位选择</Text></View>
                            <View><Text style={styles.c2f14}>已选{seatData.length}个</Text></View>
                        </View>
                        <View style={styles.infoItem}>
                            <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>预约手机</Text></View>
                            <View><Text style={styles.c2f14}>{subPhone}</Text></View>
                        </View>
                        <View style={styles.infoItem}>
                            <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>人数</Text></View>
                            <View><Text style={styles.c2f14}>{consumerNum}人</Text></View>
                        </View>
                        {
                            this.isShouhou && (
                                <View style={styles.infoItem}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>取消原因</Text></View>
                                    <View style={{ flex: 1 }}><Text style={styles.c2f14} numberOfLines={2} ellipsizeMode='tail' >{orderReason}</Text></View>
                                </View>
                            )
                        }
                        <View style={styles.infoItem2}>
                            <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>备注</Text></View>
                            <View style={{flex:1,alignItems:'flex-end'}}><Text style={[styles.c2f14]}>{remark}</Text></View>
                        </View>
                    </View>
                    {
                        [ORDER_STATUS_ONLINE.STAY_ORDER, ORDER_STATUS_ONLINE.STAY_PAY].includes(orderStatus) ? null : this.renderSameSeatItem()
                    }
                    {/* {
                        this.isShouhou && (
                            <View style={styles.infoView}>
                                <View style={[styles.infoItem, { flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4 }]}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>订单总金额</Text></View>
                                    <Text style={styles.credf14}>¥{price / 100}</Text>
                                </View>
                                <View style={[styles.infoItem, { flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4 }]}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>消费券支付</Text></View>
                                    <Text style={styles.c2f14}>{getSomeData.voucher / 100}</Text>
                                </View>
                                <View style={[styles.infoItem, { flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4 }]}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>实际支付</Text></View>
                                    <Text style={styles.credf14}>¥{(Number(money) + Number(pPayPirce) + getSomeData.voucher + getSomeData.shopVoucher) / 100}</Text>
                                </View>
                                <View style={[styles.infoItem, { flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4 }]}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>现金支付</Text></View>
                                    <Text style={styles.c2f14}>¥{(Number(money) + Number(pPayPirce)) / 100}</Text>
                                </View>
                                <View style={[styles.infoItem, { flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4 }]}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>商家券支付</Text></View>
                                    <Text style={styles.c2f14}>{getSomeData.shopVoucher / 100}</Text>
                                </View>
                                <View style={[styles.infoItem2, { flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4 }]}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>优惠说明</Text></View>
                                    <Text style={styles.c2f14}>{discountName}{discountMoney ?discountMoney / 100:'暂无'}</Text>
                                </View>
                            </View>
                        )
                    } */}
                    {
                        this.isShouhou && (
                            <View style={styles.infoView}>
                                <View style={[styles.infoItem]}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>现金退款</Text></View>
                                    <Text style={styles.credf14}>¥{keepTwoDecimal(math.divide(Number(money) + Number(pPayPirce), 100))}</Text>
                                </View>
                                <View style={[styles.infoItem]}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>商家券退款</Text></View>
                                    <Text style={styles.c2f14}>{keepTwoDecimal(math.divide(isAll==="YES"?totalShopVoucher:refundXfqs, 100))}</Text>
                                </View>
                                <View style={[styles.infoItem]}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>消费券退款</Text></View>
                                    <Text style={styles.c2f14}>{keepTwoDecimal(math.divide (isAll==="YES"?totalVoucher:refundXfq, 100))}</Text>
                                </View>
                                {
                                    isAll === 'YES' && (
                                        <View style={[styles.infoItem2]}>
                                            <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>卡券退款</Text></View>
                                            <Text style={styles.credf14}>{keepTwoDecimal(math.divide(discountMoney / 100))}</Text>
                                        </View>
                                    )
                                }
                            </View>
                        )
                    }
                </ScrollView>
                {
                    this.renderBtttomBtn(isClosed)
                }
                <ActionSheet
                        ref={o => (this.ActionSheet = o)}
                        // title={'Which one do you like ?'}
                        options={['输入消费码', '扫描消费二维码', '取消']}
                        cancelButtonIndex={2}
                        // destructiveButtonIndex={2}
                        onPress={index => {
                            if (index == 0) {
                                navigation.navigate('InputConsumerCode', { initDataDidMount: this.initDataDidMount, orderId })
                            }else if(index==1){
                                this.scanQrCode()
                            }
                        }}
                    />
            </View >
        )
    }
}

export default connect(
    state => ({
        userShop: state.user.userShop,
        orderDetail: state.order.orderDetail,
        refreshing: state.loading.effects["order/fetchOBMBcleOrderDetails"],
    }),
    {
        fetchOBMBcleOrderDetails: (orderId, isShouhou)=> ({ type: 'order/fetchOBMBcleOrderDetails', payload: { orderId, isShouhou }})
    }
)(StayStatementOrder);
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
        top: 0
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
    },
    cgreenF14: {
        color: '#46D684',
        fontSize: 14
    },
    cyellowF14: {
        color: '#FA994A',
        fontSize: 14
    },
    left: {
        width: 50
    },
    nogoods: {
        width: getwidth(355),
        height: 67,
        justifyContent: 'center',
        alignItems: 'center'
    },
    sweepBtn: {
        width: width,
        height: 50,
        borderTopColor: '#F1F1F1',
        borderTopWidth: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#fff',
    },
    credf34: {
        color: '#EE6161',
        fontSize: 34
    },
    topState: {
        width: getwidth(355),
        backgroundColor: '#fff',
        borderRadius: 6,
        marginTop: 10,
        paddingHorizontal: 15,
        paddingVertical: 15
    },
    topItem: {
        flex: 1,
    },
    c0f17: {
        color: '#000000',
        fontSize: 17
    },
    c7f14: {
        color: '#777777',
        fontSize: 14
    },
    c2f14: {
        color: '#222222',
        fontSize: 14,
    },
    c2f17: {
        color: '#222222',
        fontSize: 17
    },
    c7f12: {
        color: '#777777',
        fontSize: 12
    },
    c2f12: {
        color: '#222222',
        fontSize: 12
    },
    ccf10: {
        color: '#CCCCCC',
        fontSize: 10,
    },
    credf14: {
        color: '#EE6161',
        fontSize: 14
    },
    cbf14: {
        color: '#4A90FA',
        fontSize: 14
    },
    cf14: {
        color: '#fff',
        fontSize: 14
    },
    orderCode: {
        width: getwidth(355),
        height: 89,
        backgroundColor: '#fff',
        borderRadius: 6,
        paddingHorizontal: 15
    },
    orderCodeItem: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center'
    },
    scrollList: {
        width: getwidth(355),
        flex: 1,
        marginTop: 10,
        borderRadius:6,
        overflow:'hidden',
        marginBottom: 60+CommonStyles.footerPadding
    },
    servicView: {
        width: getwidth(355),
        paddingHorizontal: 15,
        marginTop: 10,
        backgroundColor: '#fff',
        borderRadius:6,
        overflow:'hidden'
    },
    serviceTitle: {
        width: getwidth(325),
        height: 50,
        borderBottomColor: '#D7D7D7',
        borderBottomWidth: 0.5,
        justifyContent: 'center'
    },
    serviceTitle2: {
        width: getwidth(325),
        height: 50,
        borderBottomColor: '#D7D7D7',
        borderBottomWidth: 0.5,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between'
    },
    serviceItem: {
        width: getwidth(325),
        height: 110,
        flexDirection: 'row',
        backgroundColor: '#fff'
    },
    borderBt: {
        borderBottomColor: '#D7D7D7',
        borderBottomWidth: 0.5
    },
    serviceItemimg: {
        width: getwidth(80),
        height: 110,
        justifyContent: 'center',
        alignItems: 'center'
    },
    textItem: {
        width: '100%',
        flexDirection: 'row',
        justifyContent: 'space-between'
    },
    infoView: {
        width: getwidth(355),
        // height: 234,
        marginTop: 10,
        paddingHorizontal: 15,
        backgroundColor: '#fff',
        // borderBottomColor: '#D7D7D7',
        // borderBottomWidth: 1,
        borderRadius: 6
    },
    infoItem: {
        width: getwidth(325),
        height: 44,
        borderBottomColor: '#D7D7D7',
        borderBottomWidth: 0.5,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center'
    },
    infoItem2: {
        width: getwidth(325),
        height: 44,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center'
    },
    serviceBottom: {
        width: getwidth(355),
        // height: 98,
        // borderTopColor: '#D7D7D7',
        // borderTopWidth: 0.5,
        borderRadius: 6,
        overflow:'hidden'
    },
    serviceBottom2: {
        width: getwidth(355),
        // height: 196,
        // borderTopColor: '#D7D7D7',
        // borderTopWidth: 1,
        borderRadius: 6
    },
    serviceBottomNogoods: {
        width: getwidth(355),
        height: 102,
        borderRadius: 6
    },
    serviceBottomItem: {
        width: getwidth(325),
        height: 34,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center'
    },
    bottomBtn: {
        position: 'absolute',
        bottom: 0,
        left: 0,
        paddingBottom:CommonStyles.footerPadding,
        width: getwidth(375),
        height: 50+CommonStyles.footerPadding,
        flexDirection: 'row'
    },
    kefu: {
        flex: 1,
        height: 50,
        backgroundColor: '#fff',
        justifyContent: 'center',
        paddingLeft: 15
    },
    fixedWidth: {
        width: getwidth(105),
        height: 50,
        justifyContent: 'center',
        alignItems: 'center'
    }
})
