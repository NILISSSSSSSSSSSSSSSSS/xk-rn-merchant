/**
 * 服务＋现场点单--订单修改
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
    TextInput,
    KeyboardAvoidingView,
    TouchableOpacity
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
const service = require('../../../images/shopOrder/service.png')
const expand = require('../../../images/order/expand.png')
const checked = require('../../../images/mall/checked.png')
const unchecked = require('../../../images/mall/unchecked.png')
function getwidth(val) {
    return width * val / 375
}

export default class ChangeOrdersScreen extends NavigationComponent {
    constructor(props) {
        super(props)
        this.ds = new ListView.DataSource({ rowHasChanged: (r1, r2) => r1 !== r2 })
        const { startTime,subPhone, seatData, phone, consumerNum, remark, serviceData } = this.props.navigation.state.params
        this.state = {
            phone: subPhone,  //预约手机号
            reson: '', //修改原因
            timedate: startTime, // 时间
            alertVisible: false,
            remark: remark,
            consumerNum: consumerNum,
            serviceData: serviceData,
            seatData: seatData,
            isOrigiPrice: true,
            youhuiPrice: '',
        }
    }

    blurState = {
        alertVisible: false,
    }

    renderSrvice = (item, some, key) => {
        let borderBt = styles.borderBt
        let serviceData = this.state.serviceData
        if (key == serviceData.length - 1) {
            borderBt = styles.borderBt1
        }
        return (
            <View style={{ alignItems: 'center' }}>
                <View style={[styles.serviceItem, borderBt, serviceData.length == 1 ? styles.borderBt : null]} key={key}>
                    <View style={styles.serviceItemimg}>
                        <Image source={{ uri: item.skuUrl }} style={{ width: getwidth(80), height: getwidth(80) }} />
                    </View>
                    <View style={{ flex: 1, height: 110, justifyContent: 'center', paddingVertical: 15 }}>
                        <View style={{ height: getwidth(80), marginLeft: 15, width: '100%' }}>
                            <View style={styles.textItem}>
                                <View style={{ flex: 1 }}>
                                    <Text style={styles.c2f14}>{item.goodsName}</Text>
                                </View>
                            </View>
                            <View style={{ marginTop: 8 }}>
                                <Text style={styles.c7f12}>{item.skuName}</Text>
                            </View>
                            <View style={{ flexDirection: 'row', marginTop: 8, alignItems: 'center' }}>
                                <Text style={styles.credf14}>
                                    ￥{keepTwoDecimal(item.platformPrice / 100)}
                                </Text><Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}>
                                    (市场价￥{keepTwoDecimal(item.originalPrice / 100)})
                                </Text>
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
    chooseTime = () => {
        Picker._showTimePicker('dateTime', (date) => {
            this.setState({
                timedate: date
            })
        })
    }
    renderHeader = () => {
        const { serviceData } = this.state
        console.log('llllllll2')
        return (
            <View style={{ alignItems: 'center' }}>
                <View style={styles.servicView}>
                    <View style={styles.serviceTitle}>
                        <Text style={styles.c2f14}>服务</Text>
                    </View>
                    <TouchableOpacity
                        onPress={() => {
                            this.props.navigation.navigate('EditorMenu', { purchased: 1, serviceCatalogCode: '1001', shopId: this.props.navigation.state.params.shopId, serviceData: serviceData, addsServiceGoodsData: this.addsServiceGoodsData })
                        }}
                        style={styles.serviceBtn}>
                        <Text style={styles.cbf14}>修改</Text>
                    </TouchableOpacity>
                </View>
            </View>

        )
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
    changeSeatData = (seatData) => {
        const { serviceData } = this.state
        serviceData.forEach((item, index) => {
            item.seatCode = seatData[index].seatCode
            item.seatId = seatData[index].seatId
            item.seatName = seatData[index].seatName
        })
        this.setState({
            serviceData,
            seatData
        })
    }
    getToltalMoney = () => {
        const { serviceData } = this.state
        let totalMoney = 0
        serviceData.forEach((item) => {
            if (item.platformPrice) {
                totalMoney += item.platformPrice
            }
        })
        return totalMoney
    }
    renderFooter = () => {
        const { phone, reson, timedate, remark, consumerNum, seatData, isOrigiPrice, youhuiPrice, serviceData } = this.state

        return (
            <View style={{ alignItems: 'center' }}>
                <View style={styles.infoView}>
                    <View style={styles.infoItem2}>
                        <View
                            style={styles.infoItemleft}
                        ><Text style={styles.c2f14}>预约时间:</Text></View>
                        <TouchableOpacity
                            style={styles.infoItemright}
                            onPress={this.chooseTime}
                        >
                            <Text style={styles.c7f14}>{timedate}</Text>
                            <Image source={expand} />
                        </TouchableOpacity>
                    </View>

                    <View style={styles.infoItem}>
                        <View
                            style={styles.infoItemleft}
                        ><Text style={styles.c2f14}>席位选择:</Text></View>
                        <TouchableOpacity
                            onPress={() => {
                                const { orderId } = this.props.navigation.state.params
                                this.props.navigation.navigate('ChooseTableNum', { orderId: orderId, seatData: seatData, maxNum: serviceData.length, changeSeatData: this.changeSeatData })
                            }}
                            style={styles.infoItemright}
                        >
                            <Text style={styles.c7f14}>已选择{seatData.length}个</Text>
                            <Image source={expand} />
                        </TouchableOpacity>
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

                    <View style={styles.infoItem}>
                        <TouchableOpacity
                            onPress={() => {
                                this.changePriceType(true)
                            }}
                            style={{ flexDirection: 'row', flex: 4, alignItems: 'center' }}
                        >
                            <Image source={isOrigiPrice ? checked : unchecked} />
                            <Text style={[styles.c2f14, { marginLeft: 6 }]}>使用原价:</Text>
                        </TouchableOpacity>
                        <View
                            style={styles.infoItemright}
                        >
                            <Text style={styles.c7f14}>{this.getToltalMoney() / 100}元</Text>
                        </View>
                    </View>


                    <View style={styles.infoItem}>
                        <TouchableOpacity
                            onPress={() => {
                                this.changePriceType(false)
                            }}
                            style={{ flexDirection: 'row', flex: 4, alignItems: 'center' }}
                        >
                            <Image source={isOrigiPrice ? unchecked : checked} />
                            <Text style={[styles.c2f14, { marginLeft: 6 }]}>使用优惠价:</Text>
                        </TouchableOpacity>
                        <View
                            style={[styles.infoItemright, { flexDirection: 'row', alignItems: 'center' }]}
                        >
                            <TextInput
                                value={youhuiPrice}
                                textAlign='right'
                                returnKeyLabel="确定"
                                returnKeyType="done"
                                onChangeText={this.changeyouhuiPrice} style={{ flex: 1 }} />
                            <Text style={styles.c7f14}>元</Text>
                        </View>
                    </View>

                    <View style={styles.infoItem}>
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
                                onChangeText={(val) => { this.changeState('reson', val) }} />
                        </View>
                    </View>

                    <View style={styles.infoItem}>
                        <View
                            style={styles.infoItemleft}
                        ><Text style={styles.c2f14}>备注:</Text></View>

                        <View style={styles.infoItemright}>
                            <Text style={styles.c7f14}>{remark}</Text>
                        </View>

                    </View>

                </View>
            </View>


        )
    }
    saveData = () => {
        const { orderId, shopId } = this.props.navigation.state.params
        const { serviceData, seatData, reson, timedate, isOrigiPrice, youhuiPrice } = this.state
        let price = ''
        if (isOrigiPrice) {
            price = this.getToltalMoney() / 100
        } else {
            price = youhuiPrice
            let total = this.getToltalMoney() / 100
            if (youhuiPrice > total) {
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
                price: price * 100,
                appointRange: `${moment(timedate, 'YYYY-MM-DD HH:mm').valueOf() / 1000}`,
                modifyInfo: reson,
            }
        }
        serviceData.forEach((item) => {
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
        seatData.forEach((item) => {
            param.muserAgreeUpdateOrde.seats.push({
                seatId: item.seatId,
                seatName: item.seatName,
                seatCode: item.seatCode
            })
        })
        orderRequestApi.fetchShopAgreeUpdateOrder(param).then((res) => {
            const { changeorderStatus } = this.props.navigation.state.params
            //传递时间，价格
            changeorderStatus(orderId)

            this.props.navigation.goBack()

        }).catch(err => {
            console.log(err)
        });
        this.setState({ alertVisible: false })
    }
    renderlistEmptyComponent = () => {
        return (
            <View style={styles.nogoods}>
                <Text>请添加商品</Text>
            </View>
        )
    }
    addsServiceGoodsData = (data) => {
        let newdata = []
        data.forEach((item) => {
            // if (item.sum > 1) {
                while (item.sum) {
                    let onedata = JSON.parse(JSON.stringify(item))
                    onedata.sum = 1
                    onedata.platformPrice = onedata.skuprice || onedata.discountPrice
                    onedata.skuUrl = onedata.mainPic || onedata.skuUrl
                    newdata.push(onedata)
                    item.sum--
                }
            // } else {
            //     item.platformPrice = item.skuprice || item.discountPrice
            //     item.skuUrl = item.mainPic || item.skuUrl
            //     newdata.push(item)
            // }
        })
        this.setState({
            serviceData: this.state.serviceData.concat(newdata) 
        })
    }
    deleteOneServiceData = (data, secId, rowId, rowMap) => {
        let { serviceData } = this.state
        let indexdata = -1
        serviceData.find((item, index) => {
            if (item.goodsId === data.goodsId && item.goodsSkuCode === data.goodsSkuCode) {
                indexdata = index
                return true
            }
        })
        this.closeRow(rowMap, `${secId}${rowId}`)
        serviceData.splice(indexdata, 1)
        this.setState({
            serviceData
        })
    }
    render() {
        const { navigation } = this.props
        const { alertVisible, serviceData } = this.state
        let serviceDatas = serviceData
        if (!serviceData || (serviceData && !serviceData.length)) {
            serviceDatas = []
        }
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
                    onConfirm={this.saveData}
                    onClose={() => { this.setState({ alertVisible: false }) }} type='confirm' />
                <SwipeListView
                    dataSource={this.ds.cloneWithRows(serviceDatas)}
                    style={{ marginTop: 10, marginBottom: 60 + CommonStyles.footerPadding, width: width }}
                    showsVerticalScrollIndicator={false}
                    renderHeader={this.renderHeader}
                    ListEmptyComponent={this.renderlistEmptyComponent}
                    renderFooter={this.renderFooter}
                    renderRow={this.renderSrvice}
                    renderHiddenRow={(data, secId, rowId, rowMap) =>

                        <TouchableOpacity
                            onPress={() => {
                                this.deleteOneServiceData(data, secId, rowId, rowMap)
                            }}
                            style={styles.rowBack}>
                            <Text style={styles.cf14}>删除</Text>
                        </TouchableOpacity>

                    }
                    leftOpenValue={68}
                    rightOpenValue={-68}
                    onRowDidOpen={this.onRowDidOpen}
                />

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
    flatListView: {
        backgroundColor: '#fff',
    },
    rowBack: {
        width: 68,
        height: '100%',
        backgroundColor: '#EE6161',
        justifyContent: 'center',
        alignItems: 'center',
        position: 'absolute',
        right: 10,
        top: 0,
        borderBottomRightRadius: 8,
        overflow: 'hidden'
    },
    servicView: {
        width: width - 20,
        paddingHorizontal: 15,
        backgroundColor: '#fff',
        flexDirection: 'row',
        justifyContent: 'space-between',
        borderTopRightRadius: 8,
        borderTopLeftRadius: 8
        // borderBottomColor: '#D7D7D7',
        // borderBottomWidth: 0.5,
    },
    nogoods: {
        width: width - 20,
        height: 67,
        justifyContent: 'center',
        alignItems: 'center'
    },
    serviceTitle: {
        width: getwidth(100),
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
    c9f12: {
        color: '#999999',
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
        width: width - 20,
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
        borderTopColor: '#D7D7D7',
        borderTopWidth: 0.5
    },
    borderBt1: {
        borderBottomLeftRadius: 8,
        borderBottomRightRadius: 8,
        overflow: 'hidden',
    },
    textItem: {
        width: '100%',
        flexDirection: 'row',
        justifyContent: 'space-between',
        paddingRight: 15
    },
    infoView: {
        width: width - 20,
        height: 360,
        marginTop: 10,
        paddingHorizontal: 15,
        backgroundColor: '#fff',
        borderRadius: 8,
    },
    infoItem: {
        width: getwidth(325),
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        borderTopColor: '#D7D7D7',
        borderTopWidth: 0.5
    },
    infoItem2: {
        width: getwidth(325),
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    infoItemleft: {
        flex: 4
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
