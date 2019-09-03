
/**
 * 拒绝退款
 */
import React, { Component } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    TextInput,
    Image,
    ScrollView,
    TouchableOpacity,
} from "react-native";
import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import Content from "../../../components/ContentItem";
import * as orderRequestApi from '../../../config/Apis/order'
import { keepTwoDecimal } from "../../../config/utils";
import  math from "../../../config/math.js";
const { width, height } = Dimensions.get("window")
const checked = require('../../../images/mall/checked.png')
const unchecked = require('../../../images/mall/unchecked.png')

function getwidth(val) {
    return width * val / 375
}

export default class RefusedRefund extends Component {
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
            isConfirst: false
        }
    }
    saveData = () => {
        let val = this.cancelReson._lastNativeText
        let isGoodsTakeOut = this.props.navigation.state.params.isGoodsTakeOut
        const { data, goodsData, } = this.state
        if (!val) {
            Toast.show('请输入原因')
            return
        }
        const { navigation } = this.props
        const { orderId, shopId, initData, status } = navigation.state.params
        if (status == 'del') {
            let param = {
                orderMUserAgree: {
                    orderId: orderId,
                    shopId: shopId,
                    cause: val,
                    agree: 2
                }
            }
            orderRequestApi.fetchMUserAgreeOrRejectCancelOrder(param).then((res) => {
                Toast.show('拒绝成功')
                if (initData) {
                    initData()
                }
                navigation.navigate('OrderListScreen')
            }).catch(err => {
                console.log(err)
            });
        } else {
            let param = {
                shopId: shopId,
                orderId: orderId,
                itemIds: [],
                purchaseIds: [],
                refuseReason: val
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
            orderRequestApi.fetchShopOrderRefundOrCancelRefuse(param).then((res) => {
                Toast.show('拒绝退款成功')
                if (initData) {
                    initData()
                }
                this.props.navigation.navigate('OrderListScreen')
            }).catch(err => {
                console.log(err)
            });
        }

    }
    renderItem = () => {
        const { navigation } = this.props
        let data = this.state.data
        const { startTime, endTime } = navigation.state.params
        return data.map((item, index) => {
            if (item.status === 'del') {
                return (
                    <View style={styles.serviceItem} key={index}>
                        <View
                            style={styles.itemTitle}>
                            <Text style={styles.c2f14}>{item.name}</Text>
                        </View>
                        <View style={[styles.itemBtn, { marginTop: 10 }]}>
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
                                <Text style={styles.c5f14}>订单总金额：<Text style={styles.credF14}>￥{keepTwoDecimal(math.divide(item.platformShopPrice, 100))}</Text></Text>
                            </View>
                            <View style={styles.flex1}>
                                <Text style={styles.c5f14}>消费券支付：<Text style={styles.credF14}>{keepTwoDecimal(math.divide(item.voucher , 100))}</Text></Text>
                            </View>
                            <View style={styles.flex1}>
                                <Text style={styles.c5f14}>实际支付：<Text style={styles.credF14}>¥{keepTwoDecimal(math.divide(item.paymentPrice + item.voucher + item.shopVoucher, 100))}</Text></Text>
                            </View>
                            <View style={styles.flex1}>
                                <Text style={styles.c5f14}>现金支付：<Text style={styles.credF14}>￥{keepTwoDecimal(math.divide(item.paymentPrice, 100))}</Text></Text>
                            </View>
                            <View style={styles.flex1}>
                                <Text style={styles.c5f14}>商家券支付：<Text style={styles.credF14}>{keepTwoDecimal(math.divide(item.shopVoucher , 100) )}</Text></Text>
                            </View>
                            <View style={[styles.flex1, { flexDirection: 'row', justifyContent: 'flex-start' }]}>
                                {
                                    item.goods && <Text style={styles.c5f14}>加购商品数量：{item.goods && item.goods.length}件</Text>
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
                            </View>
                            <View style={{ marginTop: 13 }}><Text style={styles.c7f12}>{item.pSkuName}</Text></View>
                            <View style={{ flexDirection: 'row', justifyContent: 'flex-end', alignItems: 'center', marginTop: 8 }}><Text style={styles.credf14}>￥{keepTwoDecimal(math.divide(item.pPlatformShopPrice , 100))}</Text>
                                <Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}>  (市场价 ￥{keepTwoDecimal(math.divide(item.pOriginalPrice , 100) )})</Text></View>
                        </View>
                    </View>
                </View>
            )
        })
    }
    render() {
        const { navigation } = this.props
        const { isConfirst } = this.state
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='拒绝退款'
                />{
                    !isConfirst ? (
                        <View style={{ width: width, height: height - 44 - CommonStyles.headerPadding - CommonStyles.footerPadding, paddingHorizontal: 15 }}>
                            <ScrollView style={{ flex: 1, marginBottom: 10 }} showsVerticalScrollIndicator={false}>
                                {
                                    this.renderItem()
                                }
                                {
                                    this.renderSingelGoods()
                                }
                            </ScrollView>
                            <TouchableOpacity
                                onPress={() => {
                                    this.setState({
                                        isConfirst: true
                                    })
                                }}
                                style={styles.btnButton}>
                                <Text style={styles.cff17}>确认拒绝</Text>
                            </TouchableOpacity>
                        </View>
                    ) : (
                            <View style={{ width: width, height: height - 44 - CommonStyles.headerPadding - CommonStyles.footerPadding, paddingHorizontal: 15 }}>
                                <Content style={styles.content}>
                                    <TextInput
                                        multiline={true}
                                        autoFocus={true}
                                        placeholder='拒绝原因'
                                        returnKeyLabel="确定"
                                        returnKeyType="done"
                                        ref={(ref) => { this.cancelReson = ref }} />
                                </Content>
                                <TouchableOpacity
                                    onPress={this.saveData}
                                    style={styles.savebtn}>
                                    <Text style={styles.cff17}>确认提交</Text>
                                </TouchableOpacity>
                            </View>
                        )
                }
                {/* <Content style={styles.content}>
                    <TextInput multiline={true} placeholder='拒绝原因' ref={(ref) => { this.cancelReson = ref }} />
                </Content>
                <TouchableOpacity
                    onPress={this.saveData}
                    style={styles.savebtn}>
                    <Text style={styles.cff17}>确认提交</Text>
                </TouchableOpacity> */}
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
    content: {
        width: getwidth(355),
        height: 196,
        paddingHorizontal: 15
    },
    savebtn: {
        width: getwidth(355),
        height: 44,
        backgroundColor: '#4A90FA',
        borderRadius: 8,
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 20
    },
    btnButton: {
        position: 'absolute',
        bottom: 0,
        width: width,
        height: 44,
        backgroundColor: '#4A90FA',
        justifyContent: 'center',
        alignItems: 'center'
    },
    cff17: {
        color: '#FFFFFF',
        fontSize: 17
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
    flex1: {
        flex: 1,
        justifyContent: 'center'
    },
    serviceItem: {
        width: getwidth(355),
        height: 300,
        borderWidth: 1,
        borderColor: '#F1F1F1',
        backgroundColor: '#fff',
        marginTop: 10
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
    goodsItem: {
        width: getwidth(355),
        height: 110,
        flexDirection: 'row',
        paddingHorizontal: 15,
        backgroundColor: '#fff',
        marginTop: 6
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
