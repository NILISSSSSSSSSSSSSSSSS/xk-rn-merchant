/**
 * 商品现场消费：订单详情
 */
import React, { Component } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    ScrollView,
    RefreshControl,
    TouchableOpacity,
    TextInput,
    Modal,
} from 'react-native';
import ListView from 'deprecated-react-native-listview';
import moment from 'moment';
import CommonStyles from '../../../common/Styles';
import Header from '../../../components/Header';
import SwipeListView from '../../../components/SwipeListView';
import * as orderRequestApi from '../../../config/Apis/order';
import CountDown from '../../../components/CountDown';
import { connect } from 'rn-dva';
import * as nativeApi from '../../../config/nativeApi';
import ImageView from '../../../components/ImageView';
import { NavigationComponent } from '../../../common/NavigationComponent';
import { keepTwoDecimal } from '../../../config/utils';
import { ORDER_STATUS_ONLINE, ORDER_STATUS_ONLINE_DESCRIBE } from '../../../const/order';
import math from '../../../config/math';
const tuiKuan = require('../../../images/shopOrder/tuiKuan.png');
const add = require('../../../images/shopOrder/add.png');
const close = require('../../../images/shopOrder/close.png');
const checked = require('../../../images/mall/checked.png');
const unchecked = require('../../../images/mall/unchecked.png');
const green = require('../../../images/account/xiaokebi.png');
const shiwuquan = require('../../../images/account/shiwuquan.png');

const { width, height } = Dimensions.get('window');

function getwidth(val) {
    return width * val / 375;
}

class GoodsSceneConsumption extends NavigationComponent {
    state = {
        confirmSettlement: false,
        showCountDown: true,
    }

    blurState = {
        confirmSettlement: false,
    }
    constructor(props) {
        super(props);
        this.ds = new ListView.DataSource({ rowHasChanged: (r1, r2) => r1 !== r2 });
    }
    changeorderStatus = (orderId) => {
        this.initDataDidMount(orderId);
    }
    getTotalMoney = () => {
        const { orderDetail } = this.props;
        const { serviceData = [], orderStatus, updataSettlement } = orderDetail || {};
        let totalMoney = 0;
        if (serviceData[0] && serviceData[0].goods) {
            serviceData[0].goods.forEach((item) => {
                if (item.platformShopPrice) {
                    if (orderStatus==ORDER_STATUS_ONLINE.COMPLETELY || orderStatus === ORDER_STATUS_ONLINE.STAY_EVALUATE || orderStatus === ORDER_STATUS_ONLINE.CLOSE || updataSettlement) {
                        totalMoney += item.platformShopPrice;
                    } else {
                        totalMoney += item.platformPrice;
                    }
                }
            });
        }
        return keepTwoDecimal(totalMoney);
    }
    initDataDidMount = () => {
        const { navigation, fetchOBMBcleOrderDetails } = this.props;
        let orderId = navigation.state.params.orderId;
        fetchOBMBcleOrderDetails(orderId, this.isShouhou);
    }
    componentDidMount() {
        let orderId = this.props.navigation.state.params.orderId;
        this.isShouhou = this.props.navigation.state.params.isShouhou;
        this.initDataDidMount(orderId);
    }
    getAllWeiFuKuanData = () => {
        const { orderDetail } = this.props;
        const { serviceData = [] } = orderDetail || {};
        let resu = [];
        serviceData.forEach((serceItem) => {
            if (serceItem.goods) {
                serceItem.goods.forEach((item) => {
                    if (item.confirmStatus === 0 && item.status != 'del') {
                        resu.push(item);
                    }
                });
            }
        });
        return resu;
    }
    renderGoods = (item, goodsData, key) => {
        let borderBt = styles.borderBt;
        const { orderDetail } = this.props;
        const { orderStatus, updataSettlement } = orderDetail || {};
        let sourcePic = this.getSourcePic(item, false);
        let litterTitle = null;
        if (!item.pPurchaseRefundId) {
            litterTitle = styles.cgreenF14;
        } else {
            litterTitle = styles.cyellowF14;
        }
        let statusName = '';
        if (item.status === 'active' && (item.confirmStatus === 1 || item.isAgree == 1)) {
            statusName = this.getpayStatusActive(item.payStatus);
        } else if (item.status === 'del') {
            statusName = this.getpayStatus(item.payStatus, item.confirmStatus, item.isAgree);
        }
        return (
            <View key={key}>
                {
                    this.isShouhou && (
                        <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginTop: 6, alignItems: 'center' }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                <Image source={sourcePic ? green : shiwuquan} />
                                {
                                    item.itemRefundId && <Text style={[styles.c7f14, { marginLeft: 8 }]}>售后编号：{item.itemRefundId}</Text>
                                }
                            </View>
                            <Text style={litterTitle}>{this.getpBcleOrderPayStatus(item, false)}</Text>
                        </View>
                    )
                }
                <View style={[styles.serviceItem, borderBt]} >
                    <View style={styles.serviceItemimg}>
                        <ImageView source={{ uri: item.goodsSkuUrl }} sourceWidth={getwidth(80)} sourceHeight={getwidth(80)} resizeMode='cover'/>
                    </View>
                    <View style={{ flex: 1, height: 80, marginLeft: 15, alignSelf: 'center' }}>
                        <View style={styles.textItem}>
                            <View style={{ flex: 1 }}>
                                <Text style={styles.c2f14}>{item.name}</Text>
                            </View>
                        </View>
                        <View style={{ marginTop: 13 }}>
                            <Text style={styles.c7f12}>{item.goodsSkuName}</Text>
                        </View>
                        <View style={{ flexDirection: 'row', height: 44, alignItems: 'center', justifyContent: 'space-between' }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                <Text style={styles.credf14}>
                                    ￥
                                {
                                        keepTwoDecimal(
                                            orderStatus==ORDER_STATUS_ONLINE.COMPLETELY || orderStatus === ORDER_STATUS_ONLINE.STAY_EVALUATE || orderStatus === ORDER_STATUS_ONLINE.CLOSE || updataSettlement ? (
                                                item.platformShopPrice / 100
                                            ) : (
                                                    item.platformPrice / 100
                                                )
                                        )
                                    }

                                </Text>
                                <Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}> (市场价￥{keepTwoDecimal(item.originalPrice / 100)})</Text>
                            </View>
                            {
                                orderStatus == ORDER_STATUS_ONLINE.STAY_ORDER ? (
                                    null
                                ) : (
                                        item.confirmStatus === 0 && item.status === 'active' && item.mainStatus == 'STAY_ORDER' ? (
                                            <TouchableOpacity
                                                onPress={() => {
                                                    const { orderDetail } = this.props;
                                                    const { orderId } = orderDetail || {};
                                                    const { shopId } = this.props.navigation.state.params;
                                                    let weiFukuanData = this.getAllWeiFuKuanData();
                                                    this.props.navigation.navigate('RefundOrSettlement', { data: weiFukuanData, status: 2, orderId, shopId, initDataDidMount: this.initDataDidMount });
                                                }}
                                                style={{ height: 44, width: getwidth(80), alignItems: 'center', justifyContent: 'center' }}>
                                                <Text style={styles.cbf14}>确认接单</Text>
                                            </TouchableOpacity>
                                        ) : (
                                                // item.status === 'active' && (item.confirmStatus === 1 || item.isAgree == 1)  ? (
                                                <View style={{ height: 44, width: getwidth(80), alignItems: 'center', justifyContent: 'center' }}>
                                                    <Text style={styles.cbf14}>{statusName}</Text>
                                                </View>
                                                // ) : (
                                                //     item.status === 'del' && (
                                                //         <View style={{ height: 44, width: getwidth(80), alignItems: 'center', justifyContent: 'center' }}>
                                                //         <Text style={styles.cbf14}>{this.getpayStatus(item.payStatus,item.confirmStatus,item.isAgree)}</Text>
                                                //     </View>
                                                //     )
                                                // )

                                            )
                                    )
                            }
                        </View>
                    </View>
                </View>
            </View>
        );
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
            return '已关闭';
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
    changeOrderStatus = (orderStatus2, status, isAgree) => {
        this.initDataDidMount();
    }
    cancelTheOrder = () => {
        const { navigation } = this.props;
        const { shopId, orderId } = this.props.navigation.state.params;
        navigation.navigate('CancelOrder', { orderId, shopId, changeOrderStatus: this.changeOrderStatus, initData: this.initDataDidMount });
    }
    concatUser = () => {//联系客户
        Loading.show();
        const { orderDetail, userShop } = this.props;
        orderRequestApi.mCustomerServiceContactUser({
            customerId: orderDetail.userId,
            shopId: userShop.id,
        }).then((res) => {
            console.log(res);
            if (res && res.tid) {
                nativeApi.createShopCustomerWithCustomerID(res.tid, res.userId, res.username, userShop.id);
            }
        }).catch(err => {
            console.log(err)
        });
    }
    confirmOrder = () => {
        const { navigation } = this.props;
        let orderId = navigation.state.params.orderId;
        let shopId = navigation.state.params.shopId;
        orderRequestApi.fetcShopAgreeOrder({ orderId, shopId }).then((res) => {
            this.initDataDidMount(orderId);
        }).catch(err => {
            console.log(err)
        });
    }
    renderBtttomBtn = (isClosed) => {
        const { orderDetail, navigation } = this.props;
        const { orderStatus, orderId, agree_pay, updataSettlement, startTime, endTime, serviceData = [], status, canCancelOrder } = orderDetail || {};
        const { shopId, initData } = navigation.state.params;

        let buttons = [];
        if (!isClosed) {
            switch (orderStatus) {
                case ORDER_STATUS_ONLINE.STAY_ORDER:
                    buttons.push({ title: '取消订单', style: [styles.fixedWidth, { backgroundColor: '#EE6161' }], titleStyle: styles.cf14, onPress: () => this.cancelTheOrder() });
                    buttons.push({ title: '确认接单', style: [styles.fixedWidth, { backgroundColor: '#4A90FA' }], titleStyle: styles.cf14, onPress: () => this.confirmOrder() });
                    break;
                case ORDER_STATUS_ONLINE.CONSUMPTION_CENTRE:
                    if (canCancelOrder) {
                        buttons.push({ title: '取消订单', style: [styles.fixedWidth, { backgroundColor: '#EE6161' }], titleStyle: styles.cf14, onPress: () => this.cancelTheOrder() });
                    }
                    if (agree_pay) {
                        buttons.push({
                            title: '订单计算', style: [styles.fixedWidth, { backgroundColor: '#4A90FA' }], titleStyle: styles.cf14, onPress: () => {
                                const { shopId } = this.props.navigation.state.params;
                                navigation.navigate('ChooseCalculateGoods', { shopId: shopId, orderId, initDataDidMount: this.initDataDidMount });
                            },
                        });
                    }
                    if (updataSettlement) {
                        buttons.push({
                            title: '修改结算', style: [styles.fixedWidth, { backgroundColor: '#4A90FA' }], titleStyle: styles.cf14, onPress: () => {
                                const { shopId } = this.props.navigation.state.params;
                                navigation.navigate('ChooseCalculateGoods', { shopId: shopId, orderId, initDataDidMount: this.initDataDidMount, updataSettlement });
                            },
                        });
                    }
                    break;
                case ORDER_STATUS_ONLINE.SHOU_HOU:
                    buttons.push({
                        title: '拒绝取消', style: [styles.fixedWidth, { backgroundColor: '#EE6161' }], titleStyle: styles.cf14, onPress: () => {
                            navigation.navigate('RefusedRefund', { status, orderId, shopId, initData: initData, serviceData: serviceData, startTime, endTime });
                        },
                    });
                    buttons.push({
                        title: '确认取消', style: [styles.fixedWidth, { backgroundColor: '#4A90FA' }], titleStyle: styles.cf14, onPress: () => {
                            if (status === 'del') {
                                this.fetchMUserAgreeOrRejectCancelOrder();
                                return;
                            }
                            navigation.navigate('RefundServiceList', { status, serviceData: serviceData, shopId: shopId, orderId: orderId, startTime, endTime, initData: initData });
                        },
                    });
                    break;
                default:
                    break;
            }
        }
        buttons.unshift(
            { title: '联系客户', style: [styles.kefu, { alignItems: buttons.length > 0 ? 'flex-start' : 'center' }], titleStyle: styles.c2f14, onPress: () => this.concatUser() }
        );

        return <View style={styles.bottomBtn}>
            {
                buttons.map(btn =>
                    <TouchableOpacity style={btn.style} activeOpacity={0.8} onPress={() => btn.onPress()}>
                        <Text style={btn.titleStyle}>{btn.title}</Text>
                    </TouchableOpacity>)
            }
        </View>;
    }
    fetchMUserAgreeOrRejectCancelOrder = () => {
        const { navigation, orderDetail } = this.props;
        const { shopId, initData } = navigation.state.params;
        const { orderId } = orderDetail || {};
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
        }).catch(() => Loading.hide());
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
    sureDeleteItem = (deleteItemInfo) => {
        this.initDataDidMount();
    }
    deleteServiceGoodsItem = (data, secId, rowId, rowMap, serviceIndex) => {
        const { navigation } = this.props;
        const { shopId } = navigation.state.params;
        let deleteItemInfo = {
            goodsId: data.goodsId,
            goodsSkuCode: data.goodsSkuCode,
            serviceIndex: serviceIndex,
        };
        navigation.navigate('BatchCancelOrder', { deleteItemInfo: deleteItemInfo, shopId, purchaseId: data.purchaseId, sureDelete: this.sureDeleteItem });
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
    //席位和goods
    renderSeatGoods = () => {
        const { orderDetail } = this.props;
        const { serviceData = [], orderStatus, orderId, canAddGoods } = orderDetail || {};
        return serviceData.map((item, index) => {
            let goodsData = item.goods || [];
            let litterTitle = null;
            if (!item.pPurchaseRefundId) {
                litterTitle = styles.cgreenF14;
            } else {
                litterTitle = styles.cyellowF14;
            }
            return (
                <View key={index}>
                    <View style={{ width: getwidth(355), backgroundColor: '#fff', marginTop: 10, borderTopLeftRadius: 6, borderTopRightRadius: 6, paddingHorizontal: 15 }}>

                        <View style={styles.serviceTitle2} key={index}>
                            <Text style={styles.c2f14}>席位：{item.seatName}</Text>
                            {
                                orderStatus === ORDER_STATUS_ONLINE.CONSUMPTION_CENTRE && canAddGoods && (
                                    <TouchableOpacity
                                        onPress={() => {
                                            const { navigation } = this.props;
                                            navigation.navigate('EditorMenu', { orderId, needFetch: true, itemId: item.itemId, serviceCatalogCode: '1002', shopId: navigation.state.params.shopId, serviceData: [], initDataDidMount: this.initDataDidMount });
                                        }}
                                        style={{ flexDirection: 'row', alignItems: 'center' }}
                                    >
                                        <Text style={styles.cbf14}>添加 </Text>
                                        <Image source={add} />
                                    </TouchableOpacity>
                                )
                            }
                        </View>
                        <SwipeListView
                            dataSource={this.ds.cloneWithRows(goodsData)}
                            showsVerticalScrollIndicator={false}
                            renderRow={(item, some, key) => { return this.renderGoods(item, goodsData, key); }}
                            renderHiddenRow={(data, secId, rowId, rowMap) => {
                                if ([ORDER_STATUS_ONLINE.STAY_PAY, ORDER_STATUS_ONLINE.STAY_CONSUMPTION, ORDER_STATUS_ONLINE.CONSUMPTION_CENTRE].includes(orderStatus) && !this.isShouhou && data.status !== 'del') {
                                    return (
                                        <TouchableOpacity
                                            onPress={() => this.deleteServiceGoodsItem(data, secId, rowId, rowMap, index)}
                                            style={styles.rowBack}>
                                            <Text style={styles.cf14}>删除</Text>
                                        </TouchableOpacity>
                                    );
                                } else {
                                    return null;
                                }
                            }}
                            leftOpenValue={0}
                            rightOpenValue={-getwidth(68)}
                            onRowDidOpen={this.onRowDidOpen}
                        />
                    </View>
                </View>
            );
        });
    }
    getVoucher = (serviceData) => {
        let voucher = 0;
        let shopVoucher = 0;
        if (serviceData) {
            serviceData.forEach((item) => {
                voucher += Number(item.voucher);
                shopVoucher += Number(item.shopVoucher);
            });
        }
        return {
            voucher,
            shopVoucher,
        };
    }
    getQrCodeData = (param) => {
        const { orderId } = this.props.navigation.state.params;
        orderRequestApi.fetchBcleMUserConfirmConsume({ consumeCode: param.consumeCode,orderId }).then((res) => {
            this.initDataDidMount(orderId);
        }).catch(err => {
            console.log(err)
        });
    }
    handleTimerOnEnd = () => {
        this.setState({
            showCountDown: false,
        });
    }
    render() {
        const { navigation, orderDetail } = this.props;
        const { confirmSettlement, showCountDown } = this.state;
        const { orderStatus, orderId, subPhone,createdAt, startTime, endTime, totalVoucher, totalShopVoucher, refundXfq, refundXfqs,
            phone, consumerNum, remark, serviceData = [], totalMoney, useYouHui, youHuiPrice, respayPirce,payMoney,
            price, pPrice, pPayPirce, money, discountName, discountMoney, isAll, updatedAt, taskTime, getSomeData } = orderDetail || {};
        let topTitleData = ORDER_STATUS_ONLINE_DESCRIBE[orderStatus] || {};
        let topHeight = 94;
        if (!topTitleData.tips) {
            topHeight = 66;
        }
        let countdown = -1;
        let canCountDown = [ORDER_STATUS_ONLINE.STAY_ORDER, ORDER_STATUS_ONLINE.STAY_PAY, ORDER_STATUS_ONLINE.STAY_EVALUATE].includes(orderStatus);
        if (canCountDown && taskTime && updatedAt) {
            //倒计时
            // countdown = (taskTime * 1000 - (new Date().getTime() - updatedAt * 1000))
            countdown = taskTime * 1000;
        }
        if ([ORDER_STATUS_ONLINE.COMPLETELY, ORDER_STATUS_ONLINE.CLOSE].includes(orderStatus) && updatedAt) {
            countdown = moment(updatedAt * 1000).format('YYYY-MM-DD HH:mm:ss');
        }
        let rightView = null;
        let isClosed = false;
        if (topTitleData.tips && canCountDown && countdown !== -1) {
            showCountDown && countdown > 0 ? null : orderStatus == 4 ? null : isClosed = true;
        }
        console.log('isClosed', isClosed, orderStatus,countdown);
        if (orderStatus === ORDER_STATUS_ONLINE.STAY_ORDER && !isClosed) {
            rightView = (
                <View style={{ width: 50, height: '100%' }}>
                    <TouchableOpacity
                        style={{ position: 'absolute', left: -50, width: 100, height: '100%', justifyContent: 'center', alignItems: 'center' }}
                        onPress={() => {
                            let shopId = this.props.navigation.state.params.shopId;
                            navigation.navigate('ModifySceneConsumption', {subPhone, orderStatus, serviceData: JSON.parse(JSON.stringify(serviceData)), orderId, createdAt, seatData: serviceData.length, phone, consumerNum, remark, totalMoney: totalMoney * 100, shopId: shopId, changeorderStatus: this.changeorderStatus });
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
                        <Text style={{ color: '#222222', fontSize: 21 }}>{isClosed ? '已关闭' : topTitleData.name}</Text>
                        <Image source={tuiKuan} style={{ width: getwidth(28), height: getwidth(28) }} />
                    </View>
                    {

                        topTitleData.tips ? (
                            <View style={[styles.topItem, { justifyContent: 'center' }]}>
                                {
                                    ![ORDER_STATUS_ONLINE.STAY_ORDER,ORDER_STATUS_ONLINE.STAY_EVALUATE, ORDER_STATUS_ONLINE.STAY_PAY, ORDER_STATUS_ONLINE.STAY_CONSUMPTION, ORDER_STATUS_ONLINE.COMPLETELY, ORDER_STATUS_ONLINE.CLOSE].includes(orderStatus) ? (
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

                    <View style={styles.infoView}>
                        <View style={styles.infoItem}>
                            <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>席位选择</Text></View>
                            <View><Text style={styles.c2f14}>已选{serviceData.length}个</Text></View>
                        </View>
                        <View style={styles.infoItem}>
                            <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>预约手机</Text></View>
                            <View><Text style={styles.c2f14}>{subPhone}</Text></View>
                        </View>
                        <View style={styles.infoItem}>
                            <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>人数</Text></View>
                            <View><Text style={styles.c2f14}>{consumerNum}人</Text></View>
                        </View>
                        <View style={styles.infoItem2}>
                            <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>备注</Text></View>
                            <View style={{ flex: 1, alignItems: 'flex-end' }}><Text style={[styles.c2f14]}>{remark}</Text></View>
                        </View>
                    </View>
                    {
                        this.renderSeatGoods()
                    }
                    <View style={[styles.servicView]}>
                        <View style={styles.serviceBottom}>
                            <View style={styles.serviceBottomItem}>
                                <View><Text style={styles.c7f14}>总数：</Text></View>
                                <View><Text style={styles.c2f14}>x{serviceData[0] && serviceData[0].goods && serviceData[0].goods.length}</Text></View>
                            </View>
                            <View style={styles.serviceBottomItem}>
                                <View><Text style={styles.c7f14}>总金额：</Text></View>
                                <View><Text style={styles.credf14}>￥{math.divide(this.getTotalMoney() , 100)}</Text></View>
                            </View>
                            <View style={styles.serviceBottomItem}>
                                <View><Text style={styles.c7f14}>消费券支付：</Text></View>
                                <Text style={styles.c2f14}>{keepTwoDecimal(math.divide(getSomeData.voucher , 100))}</Text>
                            </View>
                            <View style={styles.serviceBottomItem}>
                                <View ><Text style={styles.c7f14}>商家券支付：</Text></View>
                                <Text style={styles.c2f14}>{keepTwoDecimal(math.divide(getSomeData.shopVoucher,100))}</Text>
                            </View>
                            {
                                !this.isShouhou && (
                                    <View style={styles.serviceBottomItem}>
                                        <View><Text style={styles.c7f14}>现金支付：</Text></View>
                                        <View><Text style={styles.credf14}>￥{keepTwoDecimal(math.divide(payMoney,100))}</Text></View>
                                    </View>
                                )
                            }
                        </View>
                        {/* )
                        } */}

                    </View>
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
                                <View style={[styles.infoItem, { flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4 }]}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>现金退款</Text></View>
                                    <Text style={styles.credf14}>¥{keepTwoDecimal((Number(money) + Number(pPayPirce)) / 100)}</Text>
                                </View>
                                <View style={[styles.infoItem, { flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4 }]}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>商家券退款</Text></View>
                                    <Text style={styles.c2f14}>{keepTwoDecimal((isAll === 'YES' ? totalShopVoucher : refundXfqs) / 100)}</Text>
                                </View>
                                <View style={[isAll === 'YES' ? styles.infoItem : styles.infoItem2, { flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4 }]}>
                                    <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>消费券退款</Text></View>
                                    <Text style={styles.c2f14}>{keepTwoDecimal((isAll === 'YES' ? totalVoucher : refundXfq) / 100)}</Text>
                                </View>
                                {
                                    isAll === 'YES' && (
                                        <View style={[styles.infoItem2, { flexWrap: 'wrap', height: 54, alignItems: 'center', paddingVertical: 4 }]}>
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
                <Modal
                    animationType={'fade'}
                    transparent={true}
                    visible={confirmSettlement}
                    onRequestClose={() => { this.setState({ confirmSettlement: false }); }}
                >
                    <ScrollView style={{ flex: 1, width }} contentContainerStyle={{ flex: 1, justifyContent: 'flex-end' }}>
                        <View style={{
                            width, backgroundColor: '#fff', paddingBottom: CommonStyles.footerPadding + 10,
                        }}
                        >
                            <View style={{ width: width, height: 51, flexDirection: 'row', borderBottomColor: '#F1F1F1', borderBottomWidth: 1 }}>
                                <View style={{ width: width - getwidth(120), marginLeft: getwidth(60), height: 51, justifyContent: 'center', alignItems: 'center' }}>
                                    <Text style={styles.c0f17}>最终金额</Text>
                                </View>
                                <TouchableOpacity
                                    onPress={() => { this.setState({ confirmSettlement: false }); }}
                                    style={{ width: getwidth(60), height: 51, justifyContent: 'center', alignItems: 'center' }}>
                                    <Image source={close} />
                                </TouchableOpacity>
                            </View>
                            <View style={{ width: width, marginTop: 26, justifyContent: 'center', alignItems: 'center' }}>
                                <Text style={styles.c7f14}>待结算金额：￥{keepTwoDecimal(totalMoney)}</Text>
                            </View>
                            <View style={{ width: width, height: 36, flexDirection: 'row', alignItems: 'center', marginTop: 20 }}>
                                <TouchableOpacity style={{ width: getwidth(44), height: 36, justifyContent: 'center', alignItems: 'flex-end', marginLeft: getwidth(70) }}>
                                    <Image source={useYouHui ? checked : unchecked} />
                                </TouchableOpacity>
                                <View style={{ marginLeft: 6 }}>
                                    <Text style={styles.c2f14}>
                                        优惠金额
                                </Text>
                                </View>
                                <View style={{ flex: 1, flexDirection: 'row', alignItems: 'center', marginLeft: 6 }}>
                                    <View style={{ width: getwidth(90), height: 44, borderColor: '#CCCCCC', borderWidth: 1, borderRadius: 6, backgroundColor: 'red' }}>
                                        <TextInput
                                            // keyboardType="numeric"
                                            returnKeyLabel="确认"
                                            returnKeyType="done"
                                            value={youHuiPrice}
                                            rejectResponderTermination
                                            onChangeText={(val) => {
                                                this.setState({
                                                    youHuiPrice: val,
                                                });
                                            }} />
                                    </View>
                                    <View style={{ marginLeft: 5 }}>
                                        <Text style={styles.c7f14}>元</Text>
                                    </View>
                                </View>
                            </View>

                            <View style={{ width: width, height: 36, flexDirection: 'row', alignItems: 'center', marginTop: 10 }}>
                                <TouchableOpacity style={{ width: getwidth(44), height: 36, justifyContent: 'center', alignItems: 'flex-end', marginLeft: getwidth(70) }}>
                                    <Image source={useYouHui ? unchecked : checked} />
                                </TouchableOpacity>
                                <View style={{ marginLeft: 6 }}>
                                    <Text style={styles.c2f14}>
                                        不使用优惠
                                </Text>
                                </View>
                            </View>

                            <View style={{ width: width, height: 44, flexDirection: 'row', justifyContent: 'center', marginTop: 10 }}>
                                <View style={{ justifyContent: 'center' }}>
                                    <Text style={styles.credf34}>￥{keepTwoDecimal(Number(totalMoney) - Number(youHuiPrice))}</Text>
                                </View>
                                <View style={{ justifyContent: 'flex-end', marginLeft: 6 }}>
                                    <Text style={styles.c7f12}>最终金额</Text>
                                </View>
                            </View>
                            <TouchableOpacity
                                style={{ width: width, height: 50, backgroundColor: '#4A90FA', justifyContent: 'center', alignItems: 'center', marginTop: 20 }}
                            >
                                <Text style={styles.cf14}>确定</Text>
                            </TouchableOpacity>
                        </View>
                    </ScrollView>
                </Modal>
            </View>
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
        fetchOBMBcleOrderDetails: (orderId, isShouhou) => ({ type: 'order/fetchOBMBcleOrderDetails', payload: { orderId, isShouhou } }),
    }
)(GoodsSceneConsumption);
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
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
    },
    cgreenF14: {
        color: '#46D684',
        fontSize: 14,
    },
    cyellowF14: {
        color: '#FA994A',
        fontSize: 14,
    },
    left: {
        width: 50,
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
    orderCode: {
        width: getwidth(355),
        height: 89,
        backgroundColor: '#fff',
        borderRadius: 6,
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
        borderRadius: 6,
        overflow: 'hidden',
        marginBottom: 60 + CommonStyles.footerPadding,
    },
    servicView: {
        width: getwidth(355),
        paddingHorizontal: 15,
        backgroundColor: '#fff',
        borderBottomLeftRadius: 6,
        borderBottomRightRadius: 6,
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
        borderBottomWidth: 0.5,
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
        // height: 176,
        marginTop: 10,
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
        // borderTopColor: '#D7D7D7',
        // borderTopWidth: 1,
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
        paddingBottom: CommonStyles.footerPadding,
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
