/**
* 售后订单退款服务列表
*/
import React, { Component } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    ScrollView,
    TouchableOpacity,
} from "react-native";
import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import * as orderRequestApi from '../../../config/Apis/order'
import { keepTwoDecimal } from "../../../config/utils";
import  math from "../../../config/math.js";
const checked = require('../../../images/mall/checked.png')
const unchecked = require('../../../images/mall/unchecked.png')

const { width, height } = Dimensions.get("window")
function getwidth(val) {
    return width * val / 375
}
export default class RefundServiceList extends Component {
    constructor(props) {
        super(props)
        let data = this.props.navigation.state.params.serviceData
        let isGoodsTakeOut = this.props.navigation.state.params.isGoodsTakeOut
        let goodsData = []
        if (isGoodsTakeOut) {
            goodsData = data
            data = []
            goodsData.forEach((item) => {
                item.goodsSkuUrl = item.skuUrl
                item.pName = item.name
                item.checked = true
                item.pPlatformShopPrice = item.platformShopPrice
                item.pOriginalPrice = item.originalPrice
            })
        } else {
            data.forEach((item) => {
                item.checked = true
                if (item.goods && item.status != 'del') {
                    item.goods.forEach((goodsItem) => {
                        goodsItem.checked = true
                        goodsData.push(goodsItem)
                    })
                }
            })
        }
        this.state = {
            data,
            goodsData,
        }
    }
    changeItemChecked = (index) => {
        let data = this.state.data
        data[index].checked = !data[index].checked
        this.setState({
            data: data
        })
    }
    changeGoodsChekd = (index) => {
        let goodsData = this.state.goodsData
        goodsData[index].checked = !goodsData[index].checked
        this.setState({
            goodsData
        })
    }
    renderSingelGoods = () => {
        const { goodsData } = this.state
        return goodsData.map((item, index) => {
            return (
                <View style={styles.goodsItem} key={index}>
                    <View style={styles.listItem}>
                        <View style={styles.listItemImg}>
                            <Image source={{ uri: item.goodsSkuUrl }} style={{ width: getwidth(80), height: getwidth(80) }} />
                        </View>
                        <View style={styles.listItemRight}>
                            <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
                                <View><Text style={styles.c2f14}>{item.pName}</Text></View>
                                <TouchableOpacity
                                    onPress={() => {
                                        this.changeGoodsChekd(index)
                                    }}
                                // style={styles.itemTitle}
                                >
                                    <Image source={item.checked ? checked : unchecked} />
                                </TouchableOpacity>
                            </View>
                            <View style={{ marginTop: 13 }}><Text style={styles.c7f12}>{item.pSkuName}</Text></View>
                            <View style={{ flexDirection: 'row', justifyContent: 'flex-end', alignItems: 'center', marginTop: 8 }}>
                                <Text style={styles.credf14}>￥{keepTwoDecimal(math.divide(item.pPaymentPrice , 100) )}</Text>
                                <Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}>  (市场价 ￥{keepTwoDecimal(math.divide(item.pOriginalPrice , 100))})</Text></View>
                        </View>
                    </View>
                </View>
            )
        })
    }
    renderItem = () => {
        const { navigation } = this.props
        let data = this.state.data
        const { startTime, endTime } = navigation.state.params
        return data.map((item, index) => {
            if (item.status === 'del') {
                return (
                    <View style={styles.serviceItem} key={index}>
                        <TouchableOpacity
                            onPress={() => {
                                this.changeItemChecked(index)
                            }}
                            style={styles.itemTitle}>
                            <Text style={styles.c2f14}>{item.name}</Text>
                            <Image source={item.checked ? checked : unchecked} />
                        </TouchableOpacity>
                        <View style={[styles.itemBtn,{marginTop:10}]}>
                        {
                            item.seatName && (
                            <View style={styles.flex1}>
                                <Text style={styles.c5f14}>席位：{item.seatName}</Text>
                            </View>
                            )
                        }
                            {
                                !endTime ? (
                                    <View style={styles.flex1}>
                                        <Text style={styles.c5f14}>预约时间：{startTime}</Text>
                                    </View>
                                ) : (
                                        <View style={styles.flex1}>
                                            <Text style={styles.c5f14}>预约时间：{`${startTime} -- ${endTime}`}</Text>
                                        </View>
                                    )
                            }
                            <View style={styles.flex1}>
                                <Text style={styles.c5f14}>套餐数量：1</Text>
                            </View>
                            <View style={styles.flex1}>
                                <Text style={styles.c5f14}>订单总金额：<Text style={styles.credF14}>￥{keepTwoDecimal(math.divide(math.add(item.iPirce , item.platformShopPrice) , 100) )}</Text></Text>
                            </View>
                            <View style={styles.flex1}>
                                <Text style={styles.c5f14}>消费券支付：<Text style={styles.credF14}>{math.divide(item.voucher,100)}</Text></Text>
                            </View>
                            <View style={styles.flex1}>
                                <Text style={styles.c5f14}>实际支付：<Text style={styles.credF14}>¥{keepTwoDecimal(math.divide(item.paymentPrice+item.voucher+item.shopVoucher,100))}</Text></Text>
                            </View>
                            <View style={styles.flex1}>
                                <Text style={styles.c5f14}>现金支付：<Text style={styles.credF14}>￥{keepTwoDecimal(math.divide(math.add(item.iPPayPirce ,item.paymentPrice) , 100))}</Text></Text>
                            </View>
                            <View style={styles.flex1}>
                                <Text style={styles.c5f14}>商家券支付：<Text style={styles.credF14}>{keepTwoDecimal(math.divide(item.shopVoucher,100))}</Text></Text>
                            </View>
                            <View style={[styles.flex1, { flexDirection: 'row', justifyContent: 'flex-start' }]}>
                            {
                                item.goods &&  <Text style={styles.c5f14}>加购商品数量：{item.goods && item.goods.length}件</Text>
                            }
                                {
                                    item.goods && (
                                        <TouchableOpacity
                                            onPress={() => {
                                                navigation.navigate('RefundGoodsList', { goods: item.goods })
                                            }}
                                            style={{ marginLeft: 20 }}
                                        ><Text style={styles.cbluef14}>查看详情</Text></TouchableOpacity>
                                    )
                                }
                            </View>
                        </View>
                    </View>
                )
            }
        })
    }
    saveData = () => {
        //如果是整个订单需要取消
        const { shopId, orderId, initData, isGoodsTakeOut, status } = this.props.navigation.state.params
        const { data, goodsData } = this.state
        let alldataChoose = true
        let allgoodChoose = true
        if (data && data.length > 0) {
            data.find((item) => {
                if (!item.checked) {
                    alldataChoose = false
                }
            })
        }
        if (goodsData && goodsData.length > 0) {
            goodsData.find((item) => {
                if (!item.checked) {
                    allgoodChoose = false
                }
            })
        }

        if (status == 'del' && alldataChoose && allgoodChoose) {
            let param = {
                orderMUserAgree: {
                    orderId: orderId,
                    shopId: shopId,
                    agree: 1
                }
            }
            orderRequestApi.fetchMUserAgreeOrRejectCancelOrder(param).then((res) => {
                Toast.show('同意退款成功')
                if (initData) {
                    initData()
                }
                this.props.navigation.navigate('OrderListScreen')
            }).catch(err => {
                console.log(err)
            });
            return
        }
        let param = {
            shopId: shopId,
            orderId: orderId,
            itemIds: [],
            purchaseIds: []
        }
        data.forEach((item) => {
            if (item.checked && item.status === 'del') {
                param.itemIds.push(item.itemId)
            }
        })
        if (isGoodsTakeOut) {
            goodsData.forEach((item) => {
                if (item.checked) {
                    param.itemIds.push(item.itemId)
                }
            })
        } else {
            goodsData.forEach((item) => {
                if (item.checked) {
                    param.purchaseIds.push(item.pPurchaseId)
                }
            })
        }

        orderRequestApi.fetchShopOrderRefundOrCancelAgree(param).then((res) => {
            Toast.show('同意退款成功')
            if (initData) {
                initData()
            }
            this.props.navigation.navigate('OrderListScreen')
        }).catch(err => {
            console.log(err)
        });

    }
    render() {
        const { navigation } = this.props
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='退款选择'
                />
                <ScrollView style={{ flex: 1, marginBottom: 10 }} showsVerticalScrollIndicator={false}>
                    {
                        this.renderItem()
                    }
                    {
                        this.renderSingelGoods()
                    }
                </ScrollView>
                <View style={styles.tishiinnfo}>
                    <Text style={styles.credF14}>温馨提示：</Text>
                    <Text style={[styles.ccf17, { marginTop: 6 }]}>服务退款，相关席位已加购的商品会做退款处理</Text>
                </View>
                <TouchableOpacity
                    onPress={
                        this.saveData
                    }
                    style={styles.btnButton}
                >
                    <Text style={styles.cff17}>
                        确定
                    </Text>
                </TouchableOpacity>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center',
        backgroundColor: CommonStyles.globalBgColor,
    },
    tishiinnfo: {
        width: width,
        marginBottom: 54+CommonStyles.footerPadding,
        paddingHorizontal: 15
    },
    goodsItem: {
        width: getwidth(355),
        height: 110,
        flexDirection: 'row',
        paddingHorizontal: 15,
        backgroundColor: '#fff',
        marginTop: 6
    },
    serviceItem: {
        width: getwidth(355),
        height: 300,
        borderWidth: 1,
        borderColor: '#F1F1F1',
        backgroundColor: '#fff',
        marginTop: 10
    },
    c2f14: {
        color: '#222222',
        fontSize: 14
    },
    c2f12: {
        color: '#222222',
        fontSize: 12
    },
    c5f14: {
        color: '#555555',
        fontSize: 14
    },
    credF14: {
        color: '#EE6161',
        fontSize: 14
    },
    cbluef14: {
        color: '#4A90FA',
        fontSize: 14
    },
    cff17: {
        color: '#FFFFFF',
        fontSize: 17
    },
    credf14: {
        color: '#EE6161',
        fontSize: 14
    },
    ccf10: {
        color: '#CCCCCC',
        fontSize: 10,
    },
    ccf17: {
        color: '#CCC',
        fontSize: 14
    },
    itemTitle: {
        width: getwidth(355),
        height: 44,
        paddingHorizontal: 15,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        borderBottomColor: '#F1F1F1',
        borderBottomWidth: 1,
    },
    itemBtn: {
        width: getwidth(355),
        flex: 1,
        paddingHorizontal: 15
    },
    flex1: {
        flex: 1,
        justifyContent: 'center'
    },
    btnButton: {
        position: 'absolute',
        bottom: 0,
        width: width,
        height: 44,
        backgroundColor: '#4A90FA',
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom:CommonStyles.footerPadding
    },
    listItem: {
        width: getwidth(325),
        height: 110,
        flexDirection: 'row',
        paddingVertical: 15,
        // borderTopColor: '#D7D7D7',
        // borderTopWidth: 1
    },
    listItemImg: {
        width: getwidth(80),
        height: 80,
        marginLeft: 0,
        justifyContent: 'center',
        alignItems: 'center'
    },
    listItemRight: {
        height: 80,
        flex: 1,
        marginLeft: 15,
        justifyContent: 'center',
    },
})
