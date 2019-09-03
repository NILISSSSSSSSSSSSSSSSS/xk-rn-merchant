/**
 * 住宿和服务
 */
import React, { Component } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    RefreshControl,
    ScrollView,
    TouchableOpacity,
} from 'react-native';
import moment from 'moment';
import CommonStyles from '../../../common/Styles';
import Header from '../../../components/Header';
import { connect } from 'rn-dva';
import * as orderRequestApi from '../../../config/Apis/order';
import { scan } from '../../../config/scanConfig';
import CountDown from '../../../components/CountDown';
import * as nativeApi from '../../../config/nativeApi';
import ImageView from '../../../components/ImageView';
import { NavigationComponent } from '../../../common/NavigationComponent';

import { keepTwoDecimal } from '../../../config/utils';
import { ORDER_STATUS_ONLINE, ORDER_STATUS_ONLINE_DESCRIBE } from '../../../const/order';
import ActionSheet from '../../../components/Actionsheet';
const tuiKuan = require('../../../images/shopOrder/tuiKuan.png');
const green = require('../../../images/account/xiaokebi.png');
const shiwuquan = require('../../../images/account/shiwuquan.png');

const { width, height } = Dimensions.get('window');

function getwidth(val) {
    return width * val / 375;
}

class AccommodationOrder extends NavigationComponent {
    state = {
        showCountDown: true,
    }
    componentDidMount() {
        this.isShouhou = this.props.navigation.state.params.isShouhou;
        this.initDataDidMount();
    }

    initDataDidMount = () => {
        const { fetchOBMBcleOrderDetails, navigation } = this.props;
        const { orderId = '', isShouhou = false } = navigation.state.params || {};
        fetchOBMBcleOrderDetails(orderId, isShouhou);
    }
    getpBcleOrderPayStatus = (item, isServuice) => {
        let payState = '';
        if (isServuice) {
            payState = item.bcleOrderPayStatus;
        } else {
            payState = item.pBcleOrderPayStatus;
        }

        switch (payState) {
            case 'NOT_PAY': case 'DURING_PAY':
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
        }
    }
    getSourcePic = (item, isServuice) => {
        let payState = '';
        if (isServuice) {
            payState = item.bcleOrderPayStatus;
        } else {
            payState = item.pBcleOrderPayStatus;
        }
        if (payState == 'NOT_PAY' || payState == 'DURING_PAY' || payState == 'DURING_PAY') {
            return true;
        } else {
            return false;
        }
    }
    renderGoods = () => {
        let { orderDetail } = this.props;
        const { goodsData } = orderDetail || {};
        let borderBt = styles.borderBt;
        if (goodsData) {
            return goodsData.map((item, index) => {
                if (index === goodsData.length - 1) {
                    borderBt = null;
                }
                let litterTitle = null;
                if (!item.itemRefundId) {
                    litterTitle = styles.cgreenF14;
                } else {
                    litterTitle = styles.cyellowF14;
                }
                let sourcePic = this.getSourcePic(item, true);
                console.log(item,'///////////////');
                return (
                    <View key={index}>
                        {
                            this.isShouhou && (
                                <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginTop: 6, alignItems: 'center' }}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Image source={sourcePic ? green : shiwuquan} />
                                        {
                                            item.itemRefundId && <Text style={[styles.c7f14, { marginLeft: 8 }]}>售后编号：{item.itemRefundId}</Text>
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
                                        <Text style={styles.c2f14}>{item.goodsName}</Text>
                                    </View>
                                    {/* <View style={{ width: getwidth(60), alignItems: 'flex-end' }}>
                                    <Text style={styles.c2f12}>x1</Text>
                                </View> */}
                                </View>
                                <View style={{ marginTop: 13 }}>
                                    <Text style={styles.c7f12}>{item.skuName}</Text>
                                </View>
                                <View style={{ flexDirection: 'row', height: 44, alignItems: 'center', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Text style={styles.credf14}>
                                            ￥{keepTwoDecimal(item.platformShopPrice / 100)}
                                        </Text><Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}> (市场价￥{keepTwoDecimal(item.originalPrice / 100)})</Text>
                                    </View>
                                </View>
                            </View>
                            {
                                item.status === 'active' && (item.confirmStatus === 1 || item.isAgree == 1) &&
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
                );
            });
        }
    }
    getpayStatusActive = (payStatus) => {
        switch (payStatus) {
            case 'NOT_PAY':
                return '未支付';
            case 'DURING_PAY':
                return '支付中';
            case 'SUCCESS_PAY':
                return '支付成功';
                case 'FAILED_REFUND': case 'APPLY_REFUND':
                return '申请中';
            case 'AGREE_REFUND':
                return '同意退款';
            case 'REFUSE_REFUND':
                return '拒绝退款';
            case 'SUCCESS_REFUND':
                return '退款成功';
        }
    }
    getpayStatus = (payStatus, confirmStatus, isAgree) => {
        if (confirmStatus === 1 || isAgree === 1) {
            switch (payStatus) {
                case 'AGREE_REFUND':
                    return '同意退款';
                case 'REFUSE_REFUND':
                    return '拒绝退款';
                case 'SUCCESS_REFUND':
                    return '退款成功';
                default:
                    return '已关闭';
            }
        }
        switch (payStatus) {
            case 'FAILED_REFUND': case 'APPLY_REFUND':
                return '申请中';
            case 'NOT_PAY':
                return '申请中';
            case 'DURING_PAY':
                return '申请中';
            case 'SUCCESS_PAY':
                return '申请中';
            case 'AGREE_REFUND':
                return '同意退款';
            case 'REFUSE_REFUND':
                return '拒绝退款';
            case 'SUCCESS_REFUND':
                return '退款成功';
        }

    }

    changeOrderStatus = () => {
        this.initDataDidMount();
    }

    cancelTheOrder = () => {
        const { navigation } = this.props;
        const { orderId, shopId } = this.props.navigation.state.params;
        navigation.navigate('CancelOrder', { orderId, shopId, changeOrderStatus: this.changeOrderStatus, initData: this.initDataDidMount });
    }

    confirmOrder = () => {
        const { orderId, shopId } = this.props.navigation.state.params || {};
        let param = { orderId, shopId };
        orderRequestApi.fetcShopAgreeOrder(param).then((res) => {
            this.initDataDidMount();
        }).catch(err => {
            console.log(err)
        });
    }
    concatUser = () => {//联系客户
        Loading.show();
        const { userShop, orderDetail } = this.props;

        orderRequestApi.mCustomerServiceContactUser({
            customerId: orderDetail.userId,
            shopId: userShop.id,
        }).then((res) => {
            console.log(res);
            if (res && res.tid) {
                nativeApi.createShopCustomerWithCustomerID(res.tid, res.userId, res.username, userShop.id);
            }
        }).catch((err)=>{
            console.log(err)
          });
    }

    renderBtttomBtn = (isClosed) => {
        const { orderDetail, navigation } = this.props;
        const { orderStatus, orderId, startTime, endTime, goodsData, status } = orderDetail || {};
        const { shopId, initData } = navigation.state.params;

        let buttons = [];
        if (!isClosed) {
            switch (orderStatus) {
                case ORDER_STATUS_ONLINE.STAY_ORDER:
                    buttons.push({ title: '取消订单', style: [styles.fixedWidth, { backgroundColor: '#EE6161' }], titleStyle: styles.cf14, onPress: ()=>  this.cancelTheOrder()});
                    buttons.push({ title: '确认接单', style: [styles.fixedWidth, { backgroundColor: '#4A90FA' }], titleStyle: styles.cf14, onPress: ()=>  this.confirmOrder()});
                    break;
                case ORDER_STATUS_ONLINE.STAY_PAY:
                    buttons.push({ title: '取消订单', style: [styles.fixedWidth, { backgroundColor: '#EE6161' }], titleStyle: styles.cf14, onPress: ()=>  this.cancelTheOrder()});
                    break;
                case ORDER_STATUS_ONLINE.STAY_CONSUMPTION:
                    buttons.push({ title: '到店确认', style: [styles.fixedWidth, { backgroundColor: '#4A90FA' }], titleStyle: styles.cf14, onPress: ()=>  this.ActionSheet.show() });
                    break;
                case ORDER_STATUS_ONLINE.CONSUMPTION_CENTRE:
                    buttons.push({ title: '取消订单', style: [styles.fixedWidth, { backgroundColor: '#EE6161' }], titleStyle: styles.cf14, onPress: ()=>  this.cancelTheOrder()});
                    buttons.push({ title: '订单计算', style: [styles.fixedWidth, { backgroundColor: '#4A90FA' }], titleStyle: styles.cf14, onPress: ()=>  navigation.navigate('ChooseCalculateGoods') });
                    break;
                case ORDER_STATUS_ONLINE.SHOU_HOU:
                    buttons.push({ title: '拒绝取消', style: [styles.fixedWidth, { backgroundColor: '#EE6161' }], titleStyle: styles.cf14, onPress: ()=>  {
                        navigation.navigate('RefusedRefund', { status, orderId, shopId, initData: initData,serviceData: goodsData, startTime, endTime });
                    }});
                    buttons.push({ title: '确认取消', style: [styles.fixedWidth, { backgroundColor: '#4A90FA' }], titleStyle: styles.cf14, onPress: ()=>  {
                        if (status === 'del') {
                            this.fetchMUserAgreeOrRejectCancelOrder();
                            return;
                        }
                        navigation.navigate('RefundServiceList', { status, serviceData: goodsData, shopId: shopId, orderId: orderId, startTime, endTime, initData: initData });
                    }});
                    break;
                default:
                    break;
            }
        }
        buttons.unshift(
            { title: '联系客户', style: [styles.kefu, { alignItems: buttons.length > 0 ? 'flex-start' : 'center' }], titleStyle: styles.c2f14, onPress: ()=>  this.concatUser()}
        );

        return <View style={styles.bottomBtn}>
            {
                buttons.map(btn=>
                <TouchableOpacity style={btn.style} activeOpacity={0.8} onPress={()=> btn.onPress()}>
                    <Text style={btn.titleStyle}>{btn.title}</Text>
                </TouchableOpacity>)
            }
        </View>;
    }

    fetchMUserAgreeOrRejectCancelOrder = ()=> {
        const { navigation, orderDetail } = this.props;
        const { orderId } = orderDetail || {};
        const { shopId, initData } = navigation.state.params;
        let param = {
            orderMUserAgree: {
                orderId: orderId,
                shopId: shopId,
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
        }).catch(()=> Loading.hide());
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

    renderBtnView = () => {
        const { orderDetail } = this.props;
        const { isStay, startTime,subPhone, endTime, phone, consumer, consumerNum, remark, stayDays } = orderDetail || {};
        let containsty = null;
        if (this.isShouhou){
            containsty = {
                width: getwidth(355),
                marginTop: 10,
                paddingHorizontal: 15,
                backgroundColor: '#fff',
                borderRadius:6,
            };
        } else{
            containsty = {
                width: getwidth(355),
                marginTop: 10,
                backgroundColor: '#fff',
                borderRadius:6,
            };
        }
        let lists = [
            {name:'预约手机',value:subPhone},
            {name:'联系人',value:consumer},
            {name:'人数',value:consumerNum + '人'},
            {name:'备注',value:remark},
        ];
        if (isStay){
            let lists2 = [
                {name:'入住时间',value:startTime},
                {name:'离店时间',value:endTime},
                {name:'入住时长',value:stayDays + '晚'},
            ];
            lists = lists.concat(lists2);
        } else{
            lists.unshift({name:'预约时间',value:startTime});
        }
        return (
            <View style={containsty}>
                {
                    lists.map((item,index)=>{
                        return (
                            <View style={styles.infoItem} key={index}>
                                <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>{item.name}</Text></View>
                                <View style={{flex:1,alignItems:'flex-end'}}><Text style={[styles.c2f14]}>{item.value}</Text></View>
                            </View>
                        );
                    })
                }
            </View>
        );
    }

    getQrCodeData = (params) => {
        const { orderId } = this.props.navigation.state.params;
        orderRequestApi.fetchBcleMUserConfirmConsume({ consumeCode: params.consumeCode,orderId }).then((res) => {
            this.initDataDidMount(orderId);
        }).catch(err => {
            console.log(err)
        });
    }
    scanQrCode = () => {
        const { navigation } = this.props;
        const { shopId, userId } = navigation.state.params;
        scan(navigation, userId, shopId, this.getQrCodeData,this.initDataDidMount);
    }
    handleTimerOnEnd = () => {
        this.setState({
            showCountDown: false,
        });
    }
    getPriceList=()=>{
        const { orderDetail } = this.props;
        const { resmoney, goodsCount, price,money, discountMoney,getSomeData} = orderDetail || {};
        return !this.isShouhou ?
        [
            {name:'总数',value:'x' + goodsCount},
            {name:'总金额',value: keepTwoDecimal((Number(price)) / 100),price:true},
            {name:'消费券支付',value: keepTwoDecimal(getSomeData.voucher / 100)},
            {name:'商家券支付',value: keepTwoDecimal(getSomeData.shopVoucher / 100)},
            {name:'现金支付',value: keepTwoDecimal(resmoney / 100),price:true},
        ]:
        [
            {name:'订单总额',value:keepTwoDecimal((Number(price)) / 100),price:true},
            {name:'消费券支付',value: keepTwoDecimal(getSomeData.voucher / 100)},
            {name:'实际支付',value: keepTwoDecimal((getSomeData.voucher + Number(money) + getSomeData.shopVoucher) / 100),price:true},
            {name:'现金支付',value: keepTwoDecimal(resmoney / 100),price:true},
            {name:'商家券支付',value: keepTwoDecimal(getSomeData.shopVoucher / 100)},
            {name:'优惠说明',value:discountMoney ? discountMoney / 100:'暂无'},
        ];
    }
    render() {
        const { navigation, orderDetail } = this.props;
        const { showCountDown } = this.state;
        const { orderStatus, isStay, createdAt, startTime,resmoney, totalVoucher, totalShopVoucher, refundXfq, refundXfqs,
            endTime, phone, consumer, consumerNum, remark, goodsData, bcleGoodsType, totalMoney,
            price, pPrice, pPayPirce,money, discountName, discountMoney, isAll, updatedAt, taskTime ,getSomeData} = orderDetail || {};
        const { orderId, shopId } = this.props.navigation.state.params;
        let topTitleData = ORDER_STATUS_ONLINE_DESCRIBE[orderStatus] || {};
        let topHeight = 94;
        if (!topTitleData.tips) {
            topHeight = 66;
        }

        let showCountDownStatusList = [ORDER_STATUS_ONLINE.STAY_ORDER, ORDER_STATUS_ONLINE.STAY_PAY, ORDER_STATUS_ONLINE.STAY_EVALUATE];
        let notOtherStatusList = [ORDER_STATUS_ONLINE.STAY_ORDER, ORDER_STATUS_ONLINE.STAY_PAY, ORDER_STATUS_ONLINE.STAY_EVALUATE, ORDER_STATUS_ONLINE.COMPLETELY, ORDER_STATUS_ONLINE.CLOSE];
        let closeStatusList = [ORDER_STATUS_ONLINE.COMPLETELY, ORDER_STATUS_ONLINE.CLOSE];

        let countdown = -1;
        if (showCountDownStatusList.includes(orderStatus) && taskTime && updatedAt) {
            //倒计时
            // countdown = (taskTime * 1000 - (new Date().getTime() - updatedAt * 1000))
            countdown = taskTime * 1000;
        }
        if (closeStatusList.includes(orderStatus) && updatedAt) {
            countdown = moment(updatedAt * 1000).format('YYYY-MM-DD HH:mm:ss');
        }
        let rightView = null;
        let isClosed = false;

        if (topTitleData.tips && showCountDownStatusList.indexOf(orderStatus) !== -1 && countdown !== -1){
            showCountDown && countdown > 0 ? null:orderStatus == ORDER_STATUS_ONLINE.STAY_EVALUATE ? null : isClosed = true;
        }
        if (orderStatus === ORDER_STATUS_ONLINE.STAY_ORDER && !isClosed) {
            rightView = (
                <View style={{ width: 50, height: '100%' }}>
                    <TouchableOpacity
                        style={{ position: 'absolute', left: -50, width: 100, height: '100%', justifyContent: 'center', alignItems: 'center' }}
                        onPress={() => {
                            navigation.navigate('ModifyAccommodationOrder', { totalMoney:keepTwoDecimal((Number(price)) / 100), goodsData: JSON.parse(JSON.stringify(goodsData)), shopId, orderId, startTime, endTime, phone, consumer, consumerNum, remark, bcleGoodsType, changeorderStatus: this.changeOrderStatus });
                        }}
                    >
                        <Text style={{ color: '#FFFFFF', fontSize: 17 }}>修改订单</Text>
                    </TouchableOpacity>
                </View>
            );
        }
        console.log(isClosed);

        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    leftView={<TouchableOpacity
                        style={[styles.headerItem, styles.left]}
                        onPress={() => {
                            let initData = this.props.navigation.state.params.initData;
                            if (initData) {
                                initData();
                            }
                            navigation.goBack();
                        }}
                    >
                        <Image source={require('../../../images/mall/goback.png')} />
                    </TouchableOpacity>}
                    title="订单详情"
                    rightView={rightView}
                />
                <View style={[styles.topState, { height: topHeight }]}>
                    <View style={[styles.topItem, { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }]}>
                        <Text style={{ color: '#222222', fontSize: 21 }}>{isClosed ? '已关闭': topTitleData.name}</Text>
                        <Image source={tuiKuan} style={{ width: getwidth(28), height: getwidth(28) }} />
                    </View>
                    {
                        topTitleData.tips ? (
                            <View style={[styles.topItem, { justifyContent: 'center' }]}>
                                {
                                    !notOtherStatusList.includes(orderStatus) ? (
                                        <Text style={styles.c7f14}>{topTitleData.tips}</Text>
                                    ) : (
                                        showCountDownStatusList.indexOf(orderStatus) !== -1 && countdown !== -1 ? (
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
                                                            fontSize: 12, color: 'rgba(85, 85, 85, 1)',
                                                        }}>{topTitleData.tips}</Text>
                                                    </View>
                                                ) : (
                                                        <Text>{orderStatus == ORDER_STATUS_ONLINE.STAY_EVALUATE ? '系统默认好评' : '系统已经自动关闭'}</Text>
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
                        <View style={styles.goodsTitle}>
                            <Text style={styles.c2f14}>{isStay ? '住宿' : '服务'}</Text>
                        </View>
                        {

                            this.renderGoods()
                        }
                        {
                            !this.isShouhou && this.renderBtnView()
                        }
                    </View>
                    <View style={{ width: getwidth(355),paddingHorizontal:15, backgroundColor: '#fff', marginTop: 10,borderRadius:6,overflow:'hidden' }}>
                        {
                            this.getPriceList().map((item,index)=>{
                            return (
                                    <View style={[styles.serviceBottomItem, { height: 34 }]} key={index}>
                                        <Text style={styles.c7f14}>{item.name}：</Text>
                                        <Text style={item.price ? styles.credf14:styles.c2f14}>{item.price ? '¥':''}{item.value}</Text>
                                    </View>
                            );
                            })
                        }
                    </View>
                    {
                        this.isShouhou && this.renderBtnView()
                    }
                    {
                        this.isShouhou && (
                            <View style={{width: getwidth(355),
                                marginTop: 10,
                                paddingHorizontal: 15,
                                backgroundColor: '#fff',
                                borderRadius:6}}>
                                <View style={[styles.infoItem2, { flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4 }]}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>现金退款</Text></View>
                                    <Text style={styles.credf14}>¥{keepTwoDecimal((Number(money) + Number(pPayPirce)) / 100)}</Text>
                                </View>
                                <View style={[styles.infoItem, { flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4 }]}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>商家券退款</Text></View>
                                    <Text style={styles.c2f14}>{keepTwoDecimal((isAll === 'YES' ? totalShopVoucher:refundXfqs) / 100)}</Text>
                                </View>
                                <View style={[styles.infoItem, { flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4 }]}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>消费券退款</Text></View>
                                    <Text style={styles.c2f14}>{keepTwoDecimal((isAll === 'YES' ? totalVoucher:refundXfq) / 100)}</Text>
                                </View>
                                {
                                    isAll === 'YES' && (
                                        <View style={[styles.infoItem2, {
                                            flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4, borderTopColor: '#D7D7D7',
                                            borderTopWidth: 0.5,
                                        }]}>
                                            <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>卡券退款</Text></View>
                                            <Text style={styles.credf14}>{keepTwoDecimal(discountMoney / 100)}</Text>
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
                                navigation.navigate('InputConsumerCode', { initDataDidMount: this.initDataDidMount, orderId });
                            } else if (index == 1){
                                this.scanQrCode();
                            }
                        }}
                    />
            </View >
        );
    }
}

export default connect(
    state => ({
        userShop: state.user.userShop,
        orderDetail: state.order.orderDetail,
        refreshing: state.loading.effects['order/fetchOBMBcleOrderDetails'],
    }),
    {
        fetchOBMBcleOrderDetails: (orderId, isShouhou)=> ({ type: 'order/fetchOBMBcleOrderDetails', payload: { orderId, isShouhou }}),
    }
)(AccommodationOrder);

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
    cgreenF14: {
        color: '#46D684',
        fontSize: 14,
    },
    cyellowF14: {
        color: '#FA994A',
        fontSize: 14,
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
    },
    serviceBottom2: {
        width: getwidth(355),
        // height: 196,
        // borderTopColor: '#D7D7D7',
        // borderTopWidth: 0.5,
        borderRadius: 20,
        paddingHorizontal: 15,
        borderRadius:6,
        overflow:'hidden',
    },
    left: {
        width: 50,
    },
    goodsTitle: {
        width: getwidth(325),
        height: 50,
        borderBottomColor: '#F1F1F1',
        borderBottomWidth: 1,
        justifyContent: 'center',
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
        fontSize: 34,
    },
    topState: {
        width: getwidth(355),
        backgroundColor: '#fff',
        borderRadius:6,
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
    orderCode: {
        width: getwidth(355),
        height: 89,
        backgroundColor: '#fff',
        borderRadius:6,
        // marginTop: 11,
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
        marginTop: 10,
        borderRadius:6,
        overflow:'hidden',
        marginBottom: 60 + CommonStyles.footerPadding,
    },
    servicView: {
        width: getwidth(355),
        marginTop: 10,
        paddingHorizontal: 15,
        backgroundColor: '#fff',
        borderRadius:6,
        overflow:'hidden',
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
        borderBottomWidth: 1,
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
        // height: 311,
        marginTop: 10,
        // paddingHorizontal: 15,
        backgroundColor: '#fff',
        // borderBottomColor: '#D7D7D7',
        // borderBottomWidth: 1,
        borderRadius:6,
        overflow:'hidden',
    },
    infoItem: {
        width: getwidth(325),
        height: 44,
        borderTopColor: '#D7D7D7',
        borderTopWidth: 0.5,
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
        height: 102,
        borderTopColor: '#D7D7D7',
        borderTopWidth: 0.5,
        borderRadius:6,
        overflow:'hidden',
        backgroundColor: '#fff',
        paddingHorizontal: 15,
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
        paddingBottom:CommonStyles.footerPadding,
        left: 0,
        width: getwidth(375),
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
