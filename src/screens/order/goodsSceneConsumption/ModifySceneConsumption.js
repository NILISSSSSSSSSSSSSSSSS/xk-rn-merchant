/**
 * 商品现场消费：修改订单
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    ScrollView,
    TextInput,
    TouchableOpacity,
} from "react-native";
import ListView from 'deprecated-react-native-listview';
import { connect } from "rn-dva"
import moment from 'moment'
import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import Picker from '../../../components/Picker'
import ModalDemo from '../../../components/Model'
import SwipeListView from '../../../components/SwipeListView'
import * as orderRequestApi from '../../../config/Apis/order'
import { NavigationComponent } from "../../../common/NavigationComponent";
import { keepTwoDecimal } from "../../../config/utils";

const { width, height } = Dimensions.get("window")
const add = require('../../../images/shopOrder/add.png')
const editor = require('../../../images/shopOrder/editor.png')
const checked = require('../../../images/mall/checked.png')
const unchecked = require('../../../images/mall/unchecked.png')
function getwidth(val) {
    return width * val / 375
}

export default class ModifySceneConsumption extends NavigationComponent {
    constructor(props) {
        super(props)
        this.ds = new ListView.DataSource({ rowHasChanged: (r1, r2) => r1 !== r2 });
        const { serviceData,subPhone, orderId, createdAt, seatData, phone, consumerNum, remark, totalMoney } = this.props.navigation.state.params
        this.state = {
            phone: subPhone,  //预约手机号
            reson: '', //修改原因
            alertVisible: false,
            createdAt: createdAt,
            seatData: seatData,
            consumerNum: consumerNum,
            remark: remark,
            totalMoney: totalMoney,
            orderId: orderId,
            serviceData: serviceData,
            itemId: '',   //当前修改的服务的数据，这个服务的itemId
            isOrigiPrice: true,
            youhuiPrice: '',
        }
    }
    blurState = {
        alertVisible: false,
    }
    renderSrvice = (item, some, key) => {
        let borderBt = styles.borderBt
        return (
            <View style={{ alignItems: 'center' }}>
                <View style={[styles.serviceItem, borderBt]} key={key}>
                    <View style={styles.serviceItemimg}>
                        <Image source={{ uri: item.goodsSkuUrl }} style={{ width: getwidth(80), height: getwidth(80) }} />
                    </View>
                    <View style={{ flex: 1, height: 110, justifyContent: 'center' }}>
                        <View style={{ height: getwidth(80), marginLeft: 15, width: '100%' }}>
                            <View style={styles.textItem}>
                                <View style={{ flex: 1 }}>
                                    <Text style={styles.c2f14}>{item.name}</Text>
                                </View>
                            </View>
                            <View style={{ marginTop: 13 }}>
                                <Text style={styles.c7f12}>{item.goodsSkuName}</Text>
                            </View>
                            <View style={{ flexDirection: 'row', marginTop: 15, alignItems: 'center' }}>
                                <Text style={styles.credf14}>￥{keepTwoDecimal(item.platformPrice / 100)} </Text><Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}> (市场价￥{keepTwoDecimal(item.originalPrice / 100)})</Text>
                            </View>
                        </View>
                    </View>
                </View>
            </View>
        )
        // })
    }
    closeRow(rowMap, rowKey) {
        if (rowMap && rowMap[rowKey]) {
            rowMap[rowKey].closeRow();
        }
    }
    onRowDidOpen = (rowKey, rowMap) => {
        setTimeout(() => {
            this.closeRow(rowMap, rowKey);
        }, 4000);
    }
    changeState = (name, val) => {
        this.setState({
            [name]: val
        })
    }
    changePriceType = (val) => {
        if (val) {
            this.setState({
                youhuiPrice: ''
            })
        }
        this.setState({
            isOrigiPrice: val
        })
    }
    changeyouhuiPrice = (val) => {
        this.setState({
            youhuiPrice: val
        })
    }
    renderHeader = () => {
        const { phone, reson, orderId, createdAt, seatData, consumerNum, remark, isOrigiPrice, youhuiPrice, totalMoney } = this.state
        return (
            <View style={{ width: getwidth(355), marginLeft: getwidth(10) }}>
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
                        <View
                            style={styles.infoItemleft}
                        ><Text style={styles.c2f14}>席位选择:</Text></View>
                        <View
                            style={styles.infoItemright}
                        >
                            <Text style={styles.c7f14}>已选择{seatData}个</Text>
                        </View>
                    </View>

                    <View style={styles.infoItem}>
                        <View
                            style={styles.infoItemleft}
                        ><Text style={styles.c2f14}>预约手机:</Text></View>
                        <View style={styles.infoItemright}>
                            <TextInput
                                style={styles.c7f14}
                                value={phone}
                                returnKeyLabel="确定"
                                returnKeyType="done"
                                onChangeText={(val) => { this.changeState('phone', val) }} />
                        </View>
                    </View>

                    <View style={styles.infoItem}>
                        <View
                            style={styles.infoItemleft}
                        ><Text style={styles.c2f14}>人数:</Text></View>
                        <View style={styles.infoItemright}>
                            <Text style={styles.c7f14}>{consumerNum}人</Text>
                        </View>
                    </View>
                    <View style={[styles.infoItem, { borderBottomWidth: 0 }]}>
                        <View
                            style={{ flex: 6 }}
                        ><Text style={styles.c2f14}>修改原因（必填）:</Text></View>
                        <View style={styles.infoItemright}>
                            <TextInput
                                placeholder='请输入修改原因'
                                textAlign='right'
                                style={styles.c7f14}
                                value={reson}
                                returnKeyLabel="确定"
                                returnKeyType="done"
                                onChangeText={(val) => { this.setState({ 'reson': val }) }} />
                        </View>
                    </View>

                    {/* <View style={styles.infoItem2}>
                        <View
                            style={styles.infoItemleft}
                        ><Text style={styles.c2f14}>修改原因(必填):</Text></View>

                        <View style={styles.infoItemright}>
                            <TextInput style={styles.c7f14} value={reson} onChangeText={(val) => {
                                this.setState({
                                    reson: val
                                })
                            }} />
                        </View>

                    </View> */}
                </View>
            </View>
        )
    }
    renderFooter = () => {
        const { totalMoney, serviceData } = this.state
        return (
            <View style={{ alignItems: 'center' }}>
                <View style={styles.totlaView}>
                    <View style={styles.btnItem}>
                        <View><Text style={styles.c7f14}>数量：</Text></View>
                        <View><Text style={styles.credf14}>{serviceData[0].goods && serviceData[0].goods.length || 0}</Text></View>
                    </View>
                    <View style={styles.btnItem}>
                        <View><Text style={styles.c7f14}>总金额：</Text></View>
                        <View><Text style={styles.credf14}>￥{keepTwoDecimal(totalMoney / 100)}</Text></View>
                    </View>
                </View>
            </View>
        )
    }
    addsServiceGoodsData = (data) => {
        let serviceData = this.state.serviceData
        let totalMoney = 0
        serviceData.forEach((item) => {
            item.goods = item.goods || []
            console.log('ggggggg', data)
            data.forEach((goodsItem) => {
                while (goodsItem.sum) {
                    let onedata = JSON.parse(JSON.stringify(goodsItem))
                    onedata.sum = 1
                    onedata.platformPrice = onedata.skuprice || onedata.discountPrice
                    totalMoney += onedata.platformPrice
                    onedata.name = onedata.goodsName
                    onedata.goodsSkuName = onedata.goodsSkuName || onedata.skuName
                    onedata.goodsSkuUrl = onedata.mainPic || onedata.goodsSkuUrl
                    item.goods.push(onedata)
                    goodsItem.sum--
                }
            })
        })
        this.setState({
            serviceData,
            totalMoney
        })

    }
    changeSeatData = (seatData) => {
        const { serviceData, itemId } = this.state
        serviceData.forEach((item) => {
            if (item.itemId === itemId) {
                item.seatCode = seatData[0].seatCode
                item.seatId = seatData[0].seatId
                item.seatName = seatData[0].seatName
            }
        })
        this.setState({
            serviceData
        })
    }
    renderSeatGoodsHear = (seatOne, serviceItem) => {
        let seatData = []
        seatData.push({
            seatCode: seatOne.seatCode,
            seatId: seatOne.seatId,
            seatName: seatOne.seatName
        })
        return (
            <View style={{ alignItems: 'center' }}>
                <View style={styles.servicView}>
                    <TouchableOpacity
                        onPress={() => {
                            this.setState({
                                itemId: serviceItem.itemId
                            })
                            const { orderId } = this.props.navigation.state.params
                            this.props.navigation.navigate('ChooseTableNum', { orderId: orderId, seatData: seatData, maxNum: 1, changeSeatData: this.changeSeatData })
                        }}
                        style={[styles.serviceTitle, { flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start' }]}>
                        <Text style={styles.c2f14}>席位:{seatOne.seatName}</Text>
                        <Image source={editor} style={{ marginLeft: 4 }} />
                    </TouchableOpacity>
                    <TouchableOpacity
                        onPress={() => {
                            const { serviceData } = this.state
                            //只需要传递商品
                            let goodsData = []
                            serviceData.forEach((item) => {
                                if (item.goods) {
                                    item.goods.forEach((goodsItem) => {
                                        goodsItem.goodsName = goodsItem.name
                                        goodsData.push(goodsItem)
                                    })
                                }
                            })
                            this.props.navigation.navigate('EditorMenu', { serviceCatalogCode: '1002', shopId: this.props.navigation.state.params.shopId, serviceData: goodsData, addsServiceGoodsData: this.addsServiceGoodsData })
                        }}
                        style={[styles.serviceBtn, { flexDirection: 'row', justifyContent: 'flex-end', alignItems: 'center' }]}>
                        <Text style={styles.cbf14}>添加</Text>
                        <Image source={add} style={{ marginLeft: 4 }} />
                    </TouchableOpacity>
                </View>
            </View >
        )
    }
    deletServiceData = (data, secId, rowId, rowMap, index) => {
        const { serviceData } = this.state
        let goodsData = serviceData[index].goods
        let indeData = -1
        let totalMoney = 0
        goodsData.findIndex((item, index) => item.goodsId === data.goodsId && item.goodsSkuCode === data.goodsSkuCode);
        this.closeRow(rowMap, `${secId}${rowId}`)
        goodsData.splice(indeData, 1)
        totalMoney = goodsData.reduce((preV, curItem, curIndex) => (preV + curItem.platformPrice), 0)
        this.setState({
            serviceData,
            totalMoney
        })
    }
    renderSeatAndGoods = () => {
        const { serviceData } = this.state
        return serviceData.map((item, index) => {
            let goodsData = item.goods || []
            return (
                <SwipeListView
                    key={index}
                    dataSource={this.ds.cloneWithRows(goodsData)}
                    style={{ marginTop: 10, marginBottom: 10 + CommonStyles.footerPadding, width: width }}
                    showsVerticalScrollIndicator={false}
                    renderRow={this.renderSrvice}
                    renderFooter={this.renderFooter}
                    renderHeader={() => {
                        let seatOne = {
                            seatCode: item.seatCode,
                            seatId: item.seatId,
                            seatName: item.seatName
                        }
                        return this.renderSeatGoodsHear(seatOne, item)
                    }}
                    renderHiddenRow={(data, secId, rowId, rowMap) => (

                        <TouchableOpacity
                            onPress={() => {
                                this.deletServiceData(data, secId, rowId, rowMap, index)
                            }}
                            style={styles.rowBack}>
                            <Text style={styles.cf14}>删除</Text>
                        </TouchableOpacity>

                    )}
                    leftOpenValue={68}
                    rightOpenValue={-68}
                    onRowDidOpen={this.onRowDidOpen}
                />
            )
        })
    }
    saveDate = () => {
        const { orderId, shopId } = this.props.navigation.state.params
        const { serviceData, reson, isOrigiPrice, youhuiPrice, totalMoney } = this.state
        let price = ''
        if (isOrigiPrice) {
            price = Number(totalMoney) / 100
        } else {
            price = Number(youhuiPrice)
            if (youhuiPrice > totalMoney / 100) {
                Toast.show('优惠价格不得大于原价')
                this.setState({
                    alertVisible: false
                })
                return
            }
        }
        if (!reson) {
            Toast.show('修改原因必填')
            this.setState({
                alertVisible: false
            })
            return
        }
        let param = {
            muserAgreeUpdateOrde: {
                orderId: orderId,
                shopId: shopId,
                goodsParams: [],
                seats: [],
                modifyInfo: reson,
            }
        }
        if (!isOrigiPrice) {
            param.muserAgreeUpdateOrde.price = price * 100
        }
        serviceData.forEach((onedata) => {
            if (onedata.goods) {
                onedata.goods.forEach((item) => {
                    let flag = false
                    param.muserAgreeUpdateOrde.goodsParams.find((one) => {
                        if (one.goodsId === item.goodsId && one.goodsSkuCode === item.goodsSkuCode) {
                            one.goodsSum += 1
                            flag = true
                            return true
                        }
                    })
                    if (!flag) {
                        param.muserAgreeUpdateOrde.goodsParams.push({
                            goodsId: item.goodsId,
                            goodsSkuCode: item.goodsSkuCode,
                            goodsSum: 1,
                        })
                    }
                })
            }
            param.muserAgreeUpdateOrde.seats.push({
                seatId: onedata.seatId,
                seatName: onedata.seatName,
                seatCode: onedata.seatCode
            })
        })
        orderRequestApi.fetchShopAgreeUpdateOrder(param).then((res) => {
            const { changeorderStatus } = this.props.navigation.state.params
            //传递时间，价格
            if (changeorderStatus) {
                changeorderStatus(orderId)
            }
            this.props.navigation.goBack()

        }).catch(err => {
            console.log(err)
        });
        this.setState({ alertVisible: false })
    }
    render() {
        const { navigation } = this.props
        const { alertVisible } = this.state
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='订单详情'
                />
                <ModalDemo
                    title='确定修改并接单?'
                    visible={alertVisible}
                    onConfirm={this.saveDate}
                    onClose={() => { this.setState({ alertVisible: false }) }} type='confirm' />
                <ScrollView showsVerticalScrollIndicator={false} style={{ paddingBottom: CommonStyles.footerPadding }}>

                    {
                        this.renderHeader()
                    }
                    {
                        this.renderSeatAndGoods()
                    }
                </ScrollView>
                <TouchableOpacity
                    onPress={() => {
                        this.setState({
                            alertVisible: true
                        })
                    }}
                    style={styles.bottombBtn}
                >
                    <Text style={[styles.cf14, { fontSize: 17 }]}>确认修改并接单</Text>
                </TouchableOpacity>
            </View >
        )
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center',
        backgroundColor: CommonStyles.globalBgColor,
    },
    flatListView: {
        backgroundColor: '#fff',
    },
    rowBack: {
        width: getwidth(68),
        height: '100%',
        backgroundColor: '#EE6161',
        justifyContent: 'center',
        alignItems: 'center',
        position: 'absolute',
        right: getwidth(10),
        top: 0
    },
    scrollList: {
        width: getwidth(355),
        flex: 1,
        marginTop: 10,
        marginBottom: 16
    },
    totlaView: {
        width: getwidth(355),
        paddingHorizontal: 15,
        height: 73,
        borderTopColor: '#D7D7D7',
        // borderRadius: 8,
        borderTopWidth: 0.5,
        backgroundColor: '#fff',
        marginBottom: 60,
        borderBottomLeftRadius: 8,
        borderBottomRightRadius: 8,
        overflow: 'hidden'
    },
    btnItem: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center'
    },
    servicView: {
        width: getwidth(355),
        paddingHorizontal: 15,
        backgroundColor: '#fff',
        flexDirection: 'row',
        justifyContent: 'space-between',
        borderBottomColor: '#D7D7D7',
        borderBottomWidth: 0.5,
        borderTopLeftRadius: 8,
        borderTopRightRadius: 8,
    },
    orderCode: {
        width: getwidth(355),
        height: 89,
        backgroundColor: '#fff',
        borderRadius: 8,
        marginTop: 11,
        paddingHorizontal: 15
    },
    orderCodeItem: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center'
    },
    serviceTitle: {
        width: getwidth(160),
        height: 50,
        justifyContent: 'center'
    },
    serviceBtn: {
        flex: 1,
        height: 50,
        alignItems: 'flex-end',
        justifyContent: 'center'
    },
    cbf14: {
        color: '#4A90FA',
        fontSize: 14
    },
    c2f14: {
        color: '#222222',
        fontSize: 14
    },
    ccf10: {
        color: '#CCCCCC',
        fontSize: 10,
    },
    c2f12: {
        color: '#222222',
        fontSize: 12
    },
    credf14: {
        color: '#EE6161',
        fontSize: 14
    },
    c7f12: {
        color: '#777777',
        fontSize: 12
    },
    c7f14: {
        color: '#777777',
        fontSize: 14
    },
    ccf14: {
        color: '#CCCCCC',
        fontSize: 14
    },
    cf14: {
        color: '#FFFFFF',
        fontSize: 14
    },
    serviceItem: {
        width: getwidth(355),
        paddingHorizontal: 15,
        height: 110,
        flexDirection: 'row',
        backgroundColor: '#fff'
    },
    serviceItemimg: {
        width: getwidth(80),
        height: 110,
        justifyContent: 'center',
        alignItems: 'center'
    },
    borderBt: {
        borderBottomColor: '#D7D7D7',
        borderBottomWidth: 0.5,
    },
    textItem: {
        width: '100%',
        flexDirection: 'row',
        justifyContent: 'space-between',
        paddingRight: 15
    },
    infoView: {
        width: getwidth(355),
        height: 270,
        marginTop: 10,
        paddingHorizontal: 15,
        backgroundColor: '#fff',
        borderRadius: 8,
        marginBottom: 10
    },
    infoItem: {
        width: getwidth(325),
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        borderBottomColor: '#D7D7D7',
        borderBottomWidth: 0.5,
    },
    infoItem2: {
        width: getwidth(325),
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    infoItemleft: {
        flex: 6
    },
    infoItemright: {
        flex: 8,
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center'
    },
    bottombBtn: {
        position: 'absolute',
        bottom: 0 + CommonStyles.footerPadding,
        width: width,
        height: 50,
        backgroundColor: '#4A90FA',
        justifyContent: 'center',
        alignItems: 'center'
    }
})
