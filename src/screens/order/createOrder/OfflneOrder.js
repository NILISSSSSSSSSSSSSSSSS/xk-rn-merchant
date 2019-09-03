
/**
 * 线下订单
 */
import React, { Component } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    ScrollView,
    TouchableOpacity,
    BackHandler,
    Modal,
} from 'react-native';
import moment from 'moment';
import CommonStyles from '../../../common/Styles';
import Header from '../../../components/Header';
import PriceInputView from '../../../components/PriceInputView';
import { NavigationComponent } from '../../../common/NavigationComponent';
import { keepTwoDecimal } from '../../../config/utils';
import  math from '../../../config/math.js';
import { connect } from 'rn-dva';
import { ORDER_STATUS_ONLINE, ORDER_STATUS_OFFLINE_DESCRIBE } from '../../../const/order';
import CountDown from '../../../components/CountDown';
const tuiKuan = require('../../../images/shopOrder/tuiKuan.png');
const add = require('../../../images/shopOrder/add.png');

const { width, height } = Dimensions.get('window');

function getwidth(val) {
    return width * val / 375;
}

class OfflneOrder extends NavigationComponent {
    static navigationOptions = {
        header: null,
        gesturesEnabled: false, // 禁用ios左滑返回
    };
    state = {
        consumerNum: 1,
        confirmSettlement: false,
        needPay: 0,
        youHuiPrice: 0,
        useYouHui: false,
        showCountDown: true,
    }

    blurState = {
        confirmSettlement: false,
    }

    componentDidMount() {
        const { navigation, fetchOBMBcleOrderDetails  } = this.props;
        let orderId = navigation.state.params.orderId;
        fetchOBMBcleOrderDetails(orderId);
    }

    renderService = () => {
        const { orderDetail } = this.props;
        const { serviceData: data = [], orderStatus } = orderDetail || {};
        if (data.length) {
            return data.map((item, index) => {
                let borderBt = styles.borderBt;
                if (index === data.length - 1) {
                    borderBt = null;
                }
                return (
                    <View style={[styles.serviceItem, borderBt]} key={index}>
                        <View style={styles.serviceItemimg}>
                            <Image source={{ uri: item.skuUrl }} style={{ width: getwidth(80), height: 80 }} />
                        </View>
                        <View style={{ flex: 1, height: 80, marginLeft: 15, alignSelf: 'center' }}>
                            <View style={styles.textItem}>
                                <View style={{ flex: 1 }}>
                                    <Text style={styles.c2f14}>{item.goodsName}</Text>
                                </View>
                            </View>
                            <View style={{ marginTop: 13 }}>
                                <Text style={styles.c7f12}>{item.skuName}</Text>
                            </View>
                            <View style={{ flexDirection: 'row', marginTop: 15, alignItems: 'center' }}>
                                <Text style={styles.credf14}>
                                    ￥
                                    {
                                        keepTwoDecimal(
                                        orderStatus === 1 || orderStatus === 3 ? (
                                            math.divide(item.platformShopPrice , 100)
                                        ) : (
                                               math.divide(item.platformPrice , 100)
                                            )
                                        )
                                    }
                                </Text><Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}> (市场价￥{keepTwoDecimal(math.divide(item.originalPrice,100))})</Text>
                            </View>
                        </View>
                    </View>
                );
            });
        } else {
            return null;
        }
    }
    getpayStatus = (payStatus) => {
        switch (payStatus) {
            case 'NOT_PAY':
                return '未支付';
            case 'DURING_PAY':
                return '支付中';
            case 'SUCCESS_PAY':
                return '支付成功';
            case 'FAILED_REFUND':
                return '退款中';
            case 'AGREE_REFUND':
                return '同意退款';
            case 'REFUSE_REFUND':
                return '拒绝退款';
            case 'SUCCESS_REFUND':
                return '退款成功';
            case 'FAILED_PAY':
                return '支付失败';
        }
    }
    getAllWeiFuKuanData = () => {
        const { orderDetail } = this.props;
        const { serviceData = [] } = orderDetail || {};
        let resu = [];
        serviceData.forEach((serceItem) => {
            if (serceItem.goods) {
                serceItem.goods.forEach((item) => {
                    if (item.confirmStatus === 0) {
                        resu.push(item);
                    }
                });
            }
        });
        return resu;
    }
    renderGoods = (data = []) => {
        const { orderDetail } = this.props;
        return data.map((item, index) => {
            const { orderStatus } = orderDetail || {};
            let borderBt = styles.borderBt;
            let goodsData = [1, 2];
            if (item.index === goodsData.length - 1) {
                borderBt = null;
            }
            return (
                <View style={[styles.serviceItem, borderBt]} key={index}>
                    <View style={styles.serviceItemimg}>
                        <Image source={{ uri: item.goodsSkuUrl }} style={{ width: getwidth(80), height: getwidth(80) }} />
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
                                        orderStatus === 1 || orderStatus === 3 ? (
                                           math.divide(item.platformShopPrice , 100)
                                        ) : (
                                              math.divide(item.platformPrice , 100)
                                            )
                                        )
                                    }
                                </Text><Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}> (市场价￥{keepTwoDecimal(math.divide(item.originalPrice , 100))})</Text>
                            </View>

                            <View style={{ height: 44, width: getwidth(80), alignItems: 'center', justifyContent: 'center' }}>
                                <Text style={styles.cbf14}>{this.getpayStatus(item.payStatus)}</Text>
                            </View>
                        </View>
                    </View>
                </View>
            );
        });
    }

    cancelTheOrder = () => {
        const { navigation, fetchOBMBcleOrderDetails } = this.props;
        let orderId = navigation.state.params.orderId;
        let shopId = navigation.state.params.shopId;
        navigation.navigate('CancelOrder', { orderId, shopId, changeOrderStatus: ()=> fetchOBMBcleOrderDetails(orderId), initData: ()=> fetchOBMBcleOrderDetails(orderId) });
    }
    renderBtttomBtn = () => {
        const { orderDetail,navigation } = this.props;
        const { orderStatus } = orderDetail || {};
        let orderId = navigation.state.params.orderId;
        let shopId = navigation.state.params.shopId;
        switch (orderStatus) {
            case 0:
                return (
                    <View style={[styles.bottomBtn]}>
                        {/* <TouchableOpacity style={styles.kefu} activeOpacity={0.8}>
                            <Text style={styles.c2f14}>联系客服</Text>
                        </TouchableOpacity> */}
                        <TouchableOpacity
                            onPress={this.cancelTheOrder}
                            style={[styles.fixedWidth, { backgroundColor: '#EE6161' }]}>
                            <Text style={styles.cf14}>取消订单</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            onPress={() => {
                                this.props.navigation.navigate('ChooseCalculateGoods', { page:'offline',orderStatus, shopId: shopId, orderId, initDataDidMount: this.props.fetchOBMBcleOrderDetails })
                            }}
                            style={[styles.fixedWidth, { backgroundColor: '#4A90FA' }]}>
                            <Text style={styles.cf14}>订单结束</Text>
                        </TouchableOpacity>
                    </View>
                );

            case 2:
                return (
                    <View style={styles.bottomBtn}>
                        {/* <TouchableOpacity style={styles.kefu} activeOpacity={0.8}>
                            <Text style={styles.c2f14}>联系客服</Text>
                        </TouchableOpacity> */}
                        <TouchableOpacity
                            onPress={this.cancelTheOrder}
                            style={[styles.fixedWidth, { backgroundColor: '#EE6161' }]}>
                            <Text style={styles.cf14}>取消订单</Text>
                        </TouchableOpacity>
                    </View>
                );
            default:return null;
        }
    }
    getServiceTotalMoney = () => {
        const { orderDetail } = this.props;
        const { serviceData = [], orderStatus } = orderDetail || {};
        let totalMoney = 0;
        serviceData.forEach((item) => {
            if (orderStatus === 1 || orderStatus === 3) {
                totalMoney += item.platformShopPrice;
            } else {
                totalMoney += item.platformPrice;
            }
        });
        return keepTwoDecimal(totalMoney);
    }

    getAllGoodsMoney = (goods) => {
        const { orderDetail } = this.props;
        const { orderStatus } = orderDetail || {};
        let totalMoney = 0;
        goods.forEach((item) => {
            if (orderStatus === 1 || orderStatus === 3) {
                totalMoney += item.platformShopPrice;
            } else {
                totalMoney += item.platformPrice;
            }
        });
        return keepTwoDecimal(totalMoney);
    }
    renderSameSeatItem = () => {
        const { navigation, orderDetail } = this.props;
        const { serviceData = [], orderStatus, orderId, canAddGoods } = orderDetail || {};

        return serviceData.map((item, serviceIndex) => {
            let bottomView = item.goods && item.goods.length ? styles.serviceBottom : styles.serviceBottomNogoods;
            return (
                <View style={[styles.servicView, { marginTop: 10 }]} key={serviceIndex}>
                    <View style={styles.serviceTitle2}>
                        <Text style={styles.c2f14}>席位：{item.seatName}</Text>
                        {
                            (orderStatus === 2 || orderStatus === 3) && canAddGoods && (
                                <TouchableOpacity
                                    onPress={() => {
                                        navigation.navigate('EditorMenu', { orderId, needFetch: true, itemId: item.itemId, purchased: 1, serviceCatalogCode: '1002', shopId: this.props.navigation.state.params.shopId, serviceData: [], initDataDidMount: this.props.fetchOBMBcleOrderDetails });
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
                        this.renderGoods(item.goods || [])
                    }
                    <View style={bottomView}>
                        <View style={styles.serviceBottomItem}>
                            <View><Text style={styles.c7f14}>总数：</Text></View>
                            <View><Text style={styles.c2f14}>x{item.goods && item.goods.length}</Text></View>
                        </View>
                        <View style={styles.serviceBottomItem}>
                            <View><Text style={styles.c7f14}>总金额：</Text></View>
                            <View><Text style={styles.credf14}>￥{math.divide(this.getAllGoodsMoney(item.goods) , 100)}</Text></View>
                        </View>
                    </View>

                </View>
            );
        });
    }
    handleTimerOnEnd = () => {
        this.setState({
            showCountDown: false,
        });
    }
    render() {
        const { navigation, orderDetail } = this.props;
        const { orderStatus, status,createdAt, orderId, startTime, serviceData = [],taskTime,updatedAt } = orderDetail || {};
        const { showCountDown } = this.state;
        let topTitleData =ORDER_STATUS_OFFLINE_DESCRIBE[orderStatus] || {};
        let topHeight = 94;
        if (!topTitleData.tips) {
            topHeight = 66;
        }
        let rightView = null;
        if (orderStatus === 0) {
            rightView = (
                <View style={{ width: 50, height: '100%' }}>
                    <TouchableOpacity
                        style={{ position: 'absolute', left: -50, width: 100, height: '100%', justifyContent: 'center', alignItems: 'center' }}
                        onPress={() => {
                            const shopId = this.props.navigation.state.params.shopId;

                            navigation.navigate('OfflneChangeOrders', { startTime, orderId, shopId, serviceData: JSON.parse(JSON.stringify(serviceData)), initDataDidMount: this.props.fetchOBMBcleOrderDetails });
                        }}
                    >
                        <Text style={{ color: '#FFFFFF', fontSize: 17 }}>修改订单</Text>
                    </TouchableOpacity>
                </View>
            );
        }
        let countdown = -1;
        if (orderStatus===1 && taskTime) { //待评价
            countdown = taskTime * 1000;
        }
        else if (orderStatus===3 || orderStatus===2 && updatedAt) { //已关闭,已完成
            countdown = moment(updatedAt * 1000).format('YYYY-MM-DD HH:mm:ss');
        }
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack
                    title="订单详情"
                    rightView={rightView}
                />
                <View style={[styles.topState, { height: topHeight }]}>
                    <View style={[styles.topItem, { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }]}>
                        <Text style={{ color: '#222222', fontSize: 21 }}>{topTitleData.name}</Text>
                        <Image source={tuiKuan} style={{ width: getwidth(28), height: getwidth(28) }} />
                    </View>
                    {
                        topTitleData.tips ? (
                            <View style={[styles.topItem, { justifyContent: 'center' }]}>
                                {
                                    orderStatus===0 ? (//进行中
                                        <Text style={styles.c7f14}>{topTitleData.tips}</Text>
                                    ) : (
                                        orderStatus== 1 && countdown !== -1 ? (
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
                                                        <Text style={{fontSize: 12, color: 'rgba(85, 85, 85, 1)'}}>{topTitleData.tips}</Text>
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

                <ScrollView style={styles.scrollList} showsVerticalScrollIndicator={false} contentContainerStyle={{paddingBottom:this.renderBtttomBtn() ? 0:CommonStyles.footerPadding + 10}}>
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
                            this.renderService()
                        }

                        <View style={[styles.serviceBottom, { borderTopColor: '#D7D7D7', borderTopWidth: 0.5 }]}>
                            <View style={styles.serviceBottomItem}>
                                <View><Text style={styles.c7f14}>总数：</Text></View>
                                <View><Text style={styles.c2f14}>x{serviceData.length || 0}</Text></View>
                            </View>
                            <View style={styles.serviceBottomItem}>
                                <View><Text style={styles.c7f14}>总金额：</Text></View>
                                <View><Text style={styles.credf14}>￥{this.getServiceTotalMoney() / 100}</Text></View>
                            </View>
                        </View>
                    </View>

                    <View style={styles.infoView}>
                        <View style={styles.infoItem2}>
                            <View style={{ width: getwidth(80) }}><Text style={styles.c7f14}>席位选择</Text></View>
                            <View><Text style={styles.c2f14}>已选{serviceData.length}个</Text></View>
                        </View>
                    </View>
                    {
                        this.renderSameSeatItem()
                    }
                </ScrollView>
                {
                    this.renderBtttomBtn()
                }
            </View >
        );
    }
}

export default connect(state=> ({
    orderDetail: state.order.orderDetail,
}), {
    fetchOBMBcleOrderDetails: (orderId, isShouhou = false) => ({ type: 'order/fetchOBMBcleOrderDetails', payload: { orderId, isShouhou } }),
})(OfflneOrder);

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
    left: {
        width: 50,
    },
    nogoods: {
        width: getwidth(355),
        height: 67,
        justifyContent: 'center',
        alignItems: 'center',
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
        // marginBottom: 60
    },
    servicView: {
        width: getwidth(355),
        paddingHorizontal: 15,
        marginTop: 10,
        backgroundColor: '#fff',
        borderRadius:6,
    },
    serviceTitle: {
        width: getwidth(325),
        height: 50,
        borderBottomColor: '#D7D7D7',
        borderBottomWidth: 0.5,
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
        // height: 234,
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
        height: 68,
        borderRadius: 6,
    },
    serviceBottomNogoods: {
        width: getwidth(355),
        height: 68,
        borderRadius: 6,
    },
    serviceBottomItem: {
        width: getwidth(325),
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    bottomBtn: {
        // position: 'absolute',
        // bottom: 0,
        // left: 0,
        width: getwidth(375),
        height: 50,
        flexDirection: 'row',
        marginBottom:CommonStyles.footerPadding,
        marginTop:10,
        backgroundColor:'#fff',
        justifyContent:'flex-end',
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
