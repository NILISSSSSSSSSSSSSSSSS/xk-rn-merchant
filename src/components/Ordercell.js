import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    ActivityIndicator,
    View,
    Text,
    Dimensions,
    Image,
    TouchableOpacity,
} from 'react-native';
import { withNavigation } from 'react-navigation';
import { connect } from 'rn-dva';
const { width, height } = Dimensions.get('window');
import CommonStyles from '../common/Styles';
import * as requestApi from '../config/requestApi';
import ImageView from '../components/ImageView';
import PayModal from '../components/PayModal';
import moment from 'moment'
import { getPreviewImage, getRefundOrderTagText, keepTwoDecimalFull, debounce } from '../config/utils';
import CountDown from '../components/CountDown'
import Model from "../components/Model";
import math from '../config/math';
class OrderCell extends Component {
    constructor(props) {
        super(props)
        this.state = {
            modalVisible: false,
            orderDetails: {
                amountInfo: {}
            },
            modelType: "confirm",
            modelVisible: false,

        }
        this.debounceCreateAndPay = debounce(this.handleCreateAndPay)
        this.debounceCancelRefund = debounce(this.handleCancelRefund, 100)
    }
    componentWillUnmount () {
        this.setState({
            modelVisible: false
        });
    }
    // 支付，后台已处理，自动匹配并找到支付订单
    handleCreateAndPay = () => {
        let { item, navigation, actions,dispatch } = this.props
        requestApi.mallOrderMUserPay({
            orderIds: [item.orderId]
        }).then(res => {
            console.log('获取去付款收银台信息',res)
            navigation.push('SOMCashier', { cashier: res });
            dispatch({ type: 'welfare/save', payload: { cashireGoBackRoute: 'SOMOrder' } })
        }).catch(err => {
            Toast.show('获取订单信息失败,请重试！')
            console.log('%获取订单信息失败', 'color:red', err)
        })
    }
    handleChangeState = (key = '', value = '', callback = () => { }) => {
        this.setState({
            [key]: value
        }, () => {
            callback()
        })
    }
    getOrderCompleteStatus = (item) => {
        if (item.status === 'del') {
            return '已关闭'
        }
        return '交易完成'
    }
    renderItemLess = (itemOrder) => {//商品少于三条时
        const { nextData } = this.props;
        return (
            itemOrder.goods.map((item, index) => {
                return (
                    <View style={[styles.itemContent, { borderBottomWidth: index == itemOrder.goods.length - 1 ? 0 : 1 }]} key={index}>
                        <View style={styles.itemContentLeft}>
                            {/* <ImageView
                                source={{ uri: getPreviewImage(item.goodsPic) }}
                                sourceWidth={58}
                                sourceHeight={58}
                                style={{borderRadius: 6}}
                            /> */}
                            <Image
                                style={{borderRadius: 6,height: '100%',width: '100%'}}
                                source={{uri: getPreviewImage(item.goodsPic, '50p')}}
                            />
                            {
                                nextData.key === 6
                                ? item.refundType && item.refundStatus !== 'REFUSED'
                                    ? <View style={styles.showRefundText}><Text style={{fontSize:10,color:'#fff'}}>{getRefundOrderTagText(item.refundStatus)}</Text></View>
                                    : null
                                : item.refundType && itemOrder.orderStatus !== 'COMPLETELY' && item.refundStatus !== 'REFUSED'
                                    ? <View style={styles.showRefundText}><Text style={{fontSize:10,color:'#fff'}}>{getRefundOrderTagText(item.refundStatus)}</Text></View>
                                    : null
                            }
                        </View>
                        <View style={styles.itemContentRight}>
                            <Text style={{ color: '#222222', fontSize: 12, lineHeight: 17, marginBottom: 4 }}>{item.goodsName}</Text>
                            <View key={index}>
                                <Text style={[{ color: '#777', fontSize: 12, }]}>
                                    规格：
                                    <Text>{item.goodsShowAttr}</Text>
                                    <Text>×{item.num}</Text>
                                </Text>
                            </View>
                            {
                                item.goodsDivide === 2
                                ? <React.Fragment>
                                    <Text style={[{ fontSize: 12, color: '#777',marginTop: 3 }]}>预约金：<Text style={{ color: '#EE6161' }}>￥{keepTwoDecimalFull(math.divide(item.price, 100))}</Text> </Text>
                                    {
                                        item.tradePrice
                                        ? <Text style={[{ fontSize: 12, color: '#777',marginTop: 3 }]}>最终交易价格：<Text style={{ color: '#222' }}>￥{keepTwoDecimalFull(math.divide(item.tradePrice, 100))}</Text> </Text>
                                        : null
                                    }
                                </React.Fragment>
                                : <Text style={[{ fontSize: 12, color: '#777',marginTop: 3 }]}>价格：<Text style={{ color: '#101010' }}>￥{keepTwoDecimalFull(math.divide(item.price, 100))}</Text> </Text>
                            }
                        </View>
                    </View>
                )
            })
        )
    }
    renderItemMany = (itemOrder) => {//商品多于两条时
        const { nextData } = this.props;
        let _itemOrder = JSON.parse(JSON.stringify(itemOrder))
        let _unRefundArr =[];
        let _refundarr = [];
        _itemOrder.goods.map(item => {
            if (item.refundStatus !== 'NONE') {
                _refundarr.push(item)
            } else {
                _unRefundArr.push(item)
            }
        })
        _itemOrder.goods = _refundarr.concat(_unRefundArr)
        return (
            <View style={[styles.itemContent, { borderBottomWidth: 0, padding: 0 }]}>
                {
                    _itemOrder.goods.map((item, index) => {
                        return index > 3 ? null : (//超出4个时不再渲染
                            <View style={[styles.itemContentLeft, { marginRight: index === 3 ? 0 : 10 }]} key={index}>
                                {/* <ImageView
                                    source={{ uri: getPreviewImage(item.goodsPic) }}
                                    sourceWidth={58}
                                    sourceHeight={58}
                                    style={{borderRadius: 6}}
                                /> */}
                                <Image
                                    style={{borderRadius: 6,height: '100%',width: '100%'}}
                                    source={{uri: getPreviewImage(item.goodsPic, '50p')}}
                                />
                                {
                                    nextData.key === 6
                                    ? item.refundType && item.refundStatus !== 'REFUSED'
                                        ? <View style={styles.showRefundText}><Text style={{fontSize:10,color:'#fff'}}>{getRefundOrderTagText(item.refundStatus)}</Text></View>
                                        : null
                                    : item.refundType && itemOrder.orderStatus !== 'COMPLETELY' && item.refundStatus !== 'REFUSED'
                                        ? <View style={styles.showRefundText}><Text style={{fontSize:10,color:'#fff'}}>{getRefundOrderTagText(item.refundStatus)}</Text></View>
                                        : null
                                }
                            </View>
                        )
                    })
                }

            </View>


        )
    }
    showPopover() {
        this.refs.popover.measure((ox, oy, width, height, px, py) => {
            this.props.showPopover(
                {
                    buttonRect: { x: px, y: py, width: width, height: height },
                    currentItem: this.props.item
                }
            )
        });
    }
    renderTransportation = () => {//运输状态
        const item = this.props.item
        return (
            <View style={styles.transView}>
                {
                    item.isSign === 1 ?
                        <View style={[styles.row,CommonStyles.flex_start]}>
                            <ImageView
                                source={require('../images/order/cofirm_timer.png')}
                                sourceWidth={14}
                                sourceHeight={14}
                            />
                            <Text style={[styles.topStatusText, { marginLeft: 6 }]}>还有</Text>
                            <CountDown
                                label= ''
                                type='orderApply'
                                date={moment().add(item.receivedExpiredTime, 's')}
                                days={{ plural: '', singular: '' }}
                                hours='小时'
                                mins='分钟'
                                segs=' '
                                daysStyle={styles.topStatusText}
                                hoursStyle={styles.topStatusText}
                                minsStyle={styles.topStatusText}
                                secsStyle={styles.topStatusText}
                                firstColonStyle={styles.topStatusText}
                                secondColonStyle={styles.topStatusText}
                            />
                            <Text style={[styles.topStatusText]}>后将自动"确认收货"</Text>
                        </View> :
                        <View>
                            <View style={styles.row}>
                                <ImageView
                                    source={require('../images/order/logistics.png')}
                                    sourceWidth={14}
                                    sourceHeight={14}
                                />
                                <Text style={[styles.smallText, { marginLeft: 6, color: '#222222' }]}>{item.orderStatus === 'PRE_SHIP' ? '运送中' : '待收货'}</Text>
                            </View>
                            {
                                item.logisticsInfos && item.logisticsInfos.map((item, index) => {
                                    if (index >= 2) return
                                    return (
                                        <View style={[CommonStyles.flex_start_noCenter]} key={index}>
                                            <Text style={[styles.smallText]}>{moment(item.time * 1000).format('YYYY-MM-DD HH:mm:ss')}</Text>
                                            <Text style={[styles.smallText,CommonStyles.flex_1]}>{item.location}</Text>
                                        </View>
                                    )
                                })

                            }
                        </View>
                }
            </View>
        )
    }
    // 获取售后列表显示状态
    getAfterSaleStatus = (item) => {
        const { nextData } = this.props;
        switch (item.refundStatus) {
            case 'APPLY' : return '退款申请中';
            case 'REFUSED' : return '平台已拒绝';
            case 'PRE_USER_SHIP' : return '待用户发货';
            case 'PRE_PLAT_RECEIVE' : return '待平台收货';
            case 'PRE_REFUND' : return '待平台退款';
            case 'REFUNDING' : return '退款中';
            case 'COMPLETE' : return '已退款';
            default: return nextData.status
        }
    }
    // 获取售后列表操作按钮
    getRefundOpearteBtn = (item) => {
        // APPLY PRE_USER_SHIP 待审核和待用户发货都可以取消， 其余时候根据状态跳转不同页面，如果是或者同意拒绝则跳转退款详情，如果进入退款流程进入进度页面
        switch (item.refundStatus) {
            // case 'APPLY': return <Text style={[styles.bottomText, { color: '#EE6161', marginLeft: 0 }]}>去发货</Text>
            // case 'PRE_USER_SHIP': return <Text style={[styles.bottomText, { color: '#EE6161', marginLeft: 0 }]}>去发货</Text>
            case 'APPLY': return <Text style={[styles.bottomText, { color: '#EE6161', marginLeft: 0 }]}>取消退款</Text>
            case 'PRE_USER_SHIP': return <Text style={[styles.bottomText, { color: '#EE6161', marginLeft: 0 }]}>取消退款</Text>
            case 'REFUSED': return <Text style={[styles.bottomText, { color: '#EE6161', marginLeft: 0 }]}>查看详情</Text>
            case 'PRE_PLAT_RECEIVE': return <Text style={[styles.bottomText, { color: '#EE6161', marginLeft: 0 }]}>查看详情</Text>
            case 'PRE_REFUND': return <Text style={[styles.bottomText, { color: '#EE6161', marginLeft: 0 }]}>查看详情</Text>
            case 'REFUNDING': return <Text style={[styles.bottomText, { color: '#EE6161', marginLeft: 0 }]}>查看详情</Text>
            case 'COMPLETE': return <Text style={[styles.bottomText, { color: '#EE6161', marginLeft: 0 }]}>查看详情</Text>
            default: return <Text style={[styles.bottomText, { color: '#EE6161', marginLeft: 0 }]}>查看详情</Text>
        }
    }
    // 取消退款
    handleCancelRefund = () => {
        const currentItem = this.props.item;
        let params = {
            refundId: currentItem.refundId
        };
        // 仅退款时， 当用户发起仅退款时，平台客服同意后，用户无法取消退款申请，若用户需要取消申请，只能联系客服
        if (currentItem.refundType === "REFUND") {
            if (currentItem.refundStatus === 'PRE_REFUND' || currentItem.refundStatus === "REFUNDING" || currentItem.refundStatus === "COMPLETE") {
                this.setState({
                    modelVisible: false
                }, () => {
                    Loading.hide();
                    Toast.show("暂不能进行退款操作,请联系客服!", 3000);
                })
            return
            }
        }
        // 退货退款时， 当用户发起退货退款时，平台客服同意后，用户无法取消退款申请，若用户需要取消申请，只能联系客服
        if (currentItem.refundType === "REFUND_GOODS") {
            if (currentItem.refundStatus === "PRE_PLAT_RECEIVE" || currentItem.refundStatus === "PRE_REFUND"|| currentItem.refundStatus === "REFUNDING"|| currentItem.refundStatus === "COMPLETE") {
                this.setState({
                    modelVisible: false
                }, () => {
                    Loading.hide();
                    Toast.show("暂不能进行退款操作,请联系客服!", 3000);
                })
                return
            }
        }
        requestApi.mallOrderMUserRefundCancel(params).then(res => {
            Toast.show("取消退款成功！", 2000);
            this.setState(
                {
                    modelVisible: false
                },
                () => {
                    this.props.refresh(); // 刷新列表
                }
            );
        }).catch(err => {
            Toast.show("取消失败，请重试！", 2000);
            this.setState({
                modelVisible: false
            });
        });
    };
    showModel = type => {
        this.setState({ modelVisible: true, modelType: type });
    };
    handleRefundEvent = (item) => {
        // 状态为 已申请，待用户发货，可以取消退款，点击显示弹窗,其余的根据状态判断跳转详情页还是进度页面
        switch (item.refundStatus) {
            case 'APPLY': this.setState({ modelVisible: true }) ;break;
            case 'PRE_USER_SHIP': this.setState({ modelVisible: true }) ;break;
            default: this.props.goDetails(item);
        }
    }
    render() {
        const { orderDetails, modelVisible } = this.state
        const { item, index, toggleSelecte, showPopover, nextData, goDetails, navigation } = this.props
        let payMoney = ((orderDetails.amountInfo.payMoney || 0) / 100)
        return (
            <TouchableOpacity key={index} style={styles.itemView} onPress={() => goDetails()} activeOpacity={0.7}>
                {/* 上部 */}
                <View style={styles.itemTop}>
                    <View style={styles.itemTopLeft}>
                        <TouchableOpacity style={{ flexDirection: 'row', justifyContent: 'flex-start', alignItems: 'center', }} onPress={() => { navigation.navigate('SOM') }}>
                            <Text style={{ color: '#222222', fontSize: 14, }}>晓可商城</Text>
                            <ImageView
                                source={require('../images/order/expand.png')}
                                sourceWidth={12}
                                sourceHeight={24}
                            />
                        </TouchableOpacity>
                    </View>
                    <Text style={styles.itemTopRight}>
                        {
                            (nextData.key === 5)
                                ? this.getOrderCompleteStatus(item)
                                : nextData.key === 6
                                    ? this.getAfterSaleStatus(item)
                                    : nextData.status
                        }
                    </Text>
                </View>
                {/* 中部*/}
                <View style={{ borderBottomWidth: 1, borderColor: '#F1F1F1' }}>
                    {
                        item.goods.length > 2 ?
                            <View style={{ padding: 14 }}>
                                {
                                    this.renderItemMany(item)
                                }
                                <Text style={{ marginTop: 6, marginBottom: -6, textAlign: 'right', fontSize: 12, color: '#222222' }}>共{item.goods.length}件商品</Text>
                            </View>
                            : this.renderItemLess(item)
                    }
                    {/* 待收货时显示运输物流状态*/}
                    <TouchableOpacity
                        style={{ paddingHorizontal: 14, marginBottom: 14, marginTop: -14 }}
                        onPress={() => { this.props.navigation.navigate('SOMLogistics', { orderDdata: item }) }}>
                        {
                            nextData.key == 3 ?
                                this.renderTransportation()
                                : null
                        }
                    </TouchableOpacity>
                </View>
                {/* 底部*/}
                <View style={styles.itemBottom}>
                    {
                        nextData.more ?
                            <Text style={[styles.bottomText, { color: '#222222',paddingHorizontal:8,paddingVertical:10 }]} ref={'popover'} onPress={() => { this.showPopover() }}>更多</Text> : null
                    }
                    {
                        nextData.nextOperTitle && item.refundStatus !== 'COMPLETE'
                        ?<TouchableOpacity style={styles.payBottom} onPress={() => {
                                if (nextData.key === 1) {
                                    // 待付款时，点击去支付
                                    Loading.show();
                                    this.debounceCreateAndPay()
                                } 
                                else if (nextData.key === 6) {
                                    // 如果是售后，点击查看详情根据售后的状态跳转不同页面
                                    this.handleRefundEvent(item)
                                } 
                                else {
                                    Loading.show()
                                    nextData.nextOperFunc(item, index)
                                }
                            }}>
                                {
                                    item.refundType // 如果是售后，获取售后操作按钮文案
                                    ? this.getRefundOpearteBtn(item)
                                    : <Text style={[styles.bottomText, { color: '#EE6161', marginLeft: 0 }]}>{nextData.nextOperTitle}</Text>
                                }

                            </TouchableOpacity>
                        : null
                    }


                </View>
                <Model
                    type={this.state.modelType}
                    title={"确定要取消退款吗?"}
                    visible={modelVisible}
                    onShow={() => this.setState({ modelVisible: true })}
                    onConfirm={() => { this.setState({ modelVisible: false }, () => { Loading.show();this.debounceCancelRefund() });}}
                    onClose={() => this.setState({ modelVisible: false })}
                />
            </TouchableOpacity>
        )
    }
}

export const styles = StyleSheet.create({
    itemView: {
        width: width - 20,
        borderRadius: 8,
        backgroundColor: 'white',
        borderWidth: 1,
        borderColor: '#F1F1F1',
        marginTop: 10,
        marginLeft: 10

    },
    topStatusText: {
        color: "#999",
        fontSize: 12
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
        flexDirection: 'row',
        alignItems: 'center',
        padding: 14,
        borderBottomWidth: 1,
        borderColor: '#F1F1F1',
    },
    itemContentLeft: {
        // width: 70,
        // height: 70,
        width: (width - 20 - 28 - 10 * 3 - 2) / 4,
        height: (width - 20 - 28 - 10 * 3 - 2) / 4,
        borderWidth: 1,
        borderColor: '#F1F1F1',
        borderRadius: 6,
        marginRight: 10,
        alignItems: 'center',
        justifyContent: 'center',
        position: 'relative',
    },
    itemContentRight: {
        flex: 1
    },
    smallText: {
        color: '#999999',
        fontSize: 10,
        lineHeight: 14,
        marginTop: 3
    },
    itemBottom: {
        flexDirection: 'row',
        alignItems: 'center',
        height: 40,
        justifyContent: 'flex-end',
        paddingHorizontal: 14
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
    transView: {
        backgroundColor: '#F6F6F6',
        // opacity:0.65,
        padding: 9,
        marginTop: 12
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    showRefundText: {
        position: 'absolute',
        right: 0,
        top: 0,
        backgroundColor: CommonStyles.globalHeaderColor,
        borderTopRightRadius: 8,
        borderBottomLeftRadius: 8,
        padding: 2,
    },
});
export default connect(
    null,
    (dispatch) => ({ dispatch })
)(withNavigation(OrderCell));