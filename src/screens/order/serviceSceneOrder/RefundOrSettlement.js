/**
 * 服务+现场点单-确认待结单商品，退款商品，
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
    TouchableHighlight
} from "react-native";
import { connect } from "rn-dva"
import moment from 'moment'
import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import * as orderRequestApi from '../../../config/Apis/order'
import { keepTwoDecimal } from "../../../config/utils";

const add = require('../../../images/shopOrder/add.png')
const checked = require('../../../images/mall/checked.png')
const unchecked = require('../../../images/mall/unchecked.png')
const service = require('../../../images/shopOrder/service.png')
const { width, height } = Dimensions.get("window")

function getwidth(val) {
    return width * val / 375
}
const titleData = [
    {
        title: '确认退款',  //退款商品选择
        status: 1,
    },
    {
        title: '取消顶大',   //拒绝退款
        status: 2,
    },
    {
        title: '待确认商品',   //确认订单
        status: 3,
    },
]
export default class RefundOrSettlement extends Component {
    constructor(props) {
        super(props)
        let data = this.props.navigation.state.params.data
        data.forEach((item) => {
            item.isChoose = false
        })
        this.state = {
            data: data,
            isAllChecked: false
        }
    }
    changeChoose = (index) => {
        let { data } = this.state
        data[index].isChoose = !data[index].isChoose
        let flag = false
        data.find((item) => {
            if (!item.isChoose) {
                flag = true
                return true
            }
        })
        if (flag) {
            this.setState({
                data,
                isAllChecked: false
            })
        } else {
            this.setState({
                data,
                isAllChecked: true
            })
        }
    }
    renderItem = () => {
        const { data } = this.state
        return data.map((item, index) => {
            return (
                <View style={styles.listItem} key={index}>
                    <TouchableOpacity
                        onPress={() => {
                            this.changeChoose(index)
                        }}
                        style={styles.checkedView}
                    >
                        <Image source={item.isChoose ? checked : unchecked} />
                    </TouchableOpacity>
                    <View style={styles.listItemImg}>
                        <Image source={{ uri: item.goodsSkuUrl }} style={{ width: getwidth(80), height: getwidth(80) }} />
                    </View>
                    <View style={styles.listItemRight}>
                        <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
                            <View><Text style={styles.c2f14}>{item.name}</Text></View>
                        </View>
                        <View style={{ marginTop: 13 }}><Text style={styles.c7f12}>{item.skuName}</Text></View>
                        <View style={{ flexDirection: 'row', justifyContent: 'flex-end', alignItems: 'center', marginTop: 20 }}><Text style={styles.credf14}>￥{keepTwoDecimal(item.platformShopPrice / 100)} </Text>
                            <Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}> (市场价 ￥{keepTwoDecimal(item.originalPrice)})</Text></View>
                    </View>
                </View>
            )
        })
    }
    getAllMoney = () => {
        const { data } = this.state
        let totalMoney = 0
        data.forEach((item) => {
            if (item.isChoose) {
                totalMoney += item.platformShopPrice
            }
        })
        return keepTwoDecimal(totalMoney)
    }
    toggleAllChecked = () => {
        let { isAllChecked, data } = this.state
        data.forEach((item) => {
            item.isChoose = !isAllChecked
        })
        this.setState({
            isAllChecked: !isAllChecked,
            data
        })
    }
    sureOrder = () => {
        const { data } = this.state
        let param = {
            purchaseOrderIds: [],
            shopId: this.props.navigation.state.params.shopId
        }
        data.forEach((item) => {
            if (item.isChoose) {
                param.purchaseOrderIds.push(item.purchaseId)
            }
        })
        orderRequestApi.fetchShopPurchaseOrderBatchAccept(param).then((res) => {
            const { initDataDidMount, orderId } = this.props.navigation.state.params
            if (initDataDidMount) {
                initDataDidMount(orderId)
            }
            this.props.navigation.goBack()
        }).catch(err => {
            console.log(err)
        });
    }
    renderBtn = (index) => {
        const { navigation } = this.props
        const { isAllChecked } = this.state
        switch (index) {
            case 1:
                return (
                    <View style={styles.bottomBtn}>

                        <TouchableOpacity
                            onPress={this.toggleAllChecked}
                            style={{ flex: 1, flexDirection: 'row', alignItems: 'center', paddingLeft: 20 }}>
                            <Image source={isAllChecked ? checked : unchecked} />
                            <Text>  全选</Text>
                        </TouchableOpacity>

                        <TouchableOpacity
                            style={styles.btnright}
                        >
                            <Text style={styles.cf14}>确认退款</Text>
                        </TouchableOpacity>
                    </View>
                )
            case 2:
                return (
                    <TouchableOpacity
                        onPress={
                            () => {
                                navigation.navigate('CancelOrder')
                            }
                        }
                        style={{ width: width, height: 50, justifyContent: 'center', alignItems: 'center', backgroundColor: '#4A90FA', position: 'absolute', bottom: 0 }}
                    >
                        <Text style={styles.cf14}>确认拒绝退款</Text>
                    </TouchableOpacity>
                )
            case 3: {
                return (
                    <View style={styles.bottomBtn}>

                        <TouchableOpacity
                            onPress={this.toggleAllChecked}
                            style={{ flex: 1, flexDirection: 'row', alignItems: 'center', paddingLeft: 20 }}>

                            <Image source={isAllChecked ? checked : unchecked} />
                            <Text>  全选</Text>
                        </TouchableOpacity>

                        <TouchableOpacity
                            onPress={this.sureOrder}
                            style={styles.btnright}
                        >
                            <Text style={styles.cf14}>确认接单</Text>
                        </TouchableOpacity>
                    </View>
                )
            }
        }
    }
    render() {
        const { navigation } = this.props
        const testData = titleData[this.props.navigation.state.params.status]
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={testData.title}
                />
                <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
                    <View style={styles.topView}>
                        <View style={styles.topLeftView}>
                            <Text style={styles.c2f14}>商品</Text>
                        </View>
                    </View>
                    {
                        this.renderItem()
                    }
                </ScrollView>
                <View style={styles.totlaView}>
                    <View style={styles.btnItem}>
                        <View><Text style={styles.c7f14}>总金额：</Text></View>
                        <View><Text style={styles.credf14}>￥{this.getAllMoney() / 100}</Text></View>
                    </View>

                </View>
                <View style={{ width: width, height: 40,justifyContent: 'center', paddingHorizontal: 15 }}>
                    <Text style={styles.c2f14}>温馨提示：未确认的商品将被取消</Text>
                </View>
                {
                    this.renderBtn(testData.status)
                }
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
    scrollView: {
        width: getwidth(355),
        borderRadius: 8,
        backgroundColor: '#fff',
        marginTop: 10,
        paddingHorizontal: 15,
        flex:1
        // marginBottom: 148,
    },
    topView: {
        width: getwidth(325),
        height: 50,
        flexDirection: 'row',
        justifyContent: 'space-between'
    },
    topLeftView: {
        width: getwidth(100),
        justifyContent: 'center',
        alignItems: 'flex-start'
    },
    topRight: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center'
    },
    cbf14: {
        color: '#4A90FA',
        fontSize: 14
    },
    c2f14: {
        color: '#222222',
        fontSize: 14
    },
    c2f12: {
        color: '#222222',
        fontSize: 12
    },
    c7f12: {
        color: '#777777',
        fontSize: 12
    },
    c7f14: {
        color: '#777777',
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
    cf14: {
        color: '#FFFFFF',
        fontSize: 14
    },
    listItem: {
        width: getwidth(325),
        height: 110,
        flexDirection: 'row',
        borderTopColor: '#D7D7D7',
        borderTopWidth: 1
    },
    checkedView: {
        width: getwidth(29),
        height: 110,
        justifyContent: 'center',
        alignItems: 'flex-start'
    },
    listItemImg: {
        width: getwidth(80),
        height: 110,
        marginLeft: 0,
        justifyContent: 'center',
        alignItems: 'center'
    },
    listItemRight: {
        height: 110,
        flex: 1,
        marginLeft: 15,
        justifyContent: 'center'
    },
    totlaView: {
        width: getwidth(355),
        paddingHorizontal: 15,
        height: 52,
        borderTopColor: '#D7D7D7',
        borderRadius: 8,
        borderTopWidth: 1,
        backgroundColor: '#fff',
        // position: 'absolute',
        // bottom: 100
    },
    btnItem: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center'
    },
    bottomBtn: {
        // position: 'absolute',
        // bottom: 0,
        width: width,
        marginBottom:CommonStyles.footerPadding,
        height: 50,
        flexDirection: 'row',
        justifyContent: 'space-between',
        backgroundColor: '#fff'
    },
    btnright: {
        width: getwidth(105),
        height: 50,
        backgroundColor: '#4A90FA',
        justifyContent: 'center',
        alignItems: 'center'
    }
})
