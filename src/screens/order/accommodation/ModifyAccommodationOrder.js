/**
 * 住宿--订单修改
 */
import React, { Component } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    TextInput,
    TouchableOpacity,
} from "react-native";
import ListView from 'deprecated-react-native-listview';
import moment from 'moment'
import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import Picker from '../../../components/Picker'
import ModalDemo from '../../../components/Model'
import SwipeListView from '../../../components/SwipeListView'
import * as orderRequestApi from '../../../config/Apis/order'
import { NavigationComponent } from "../../../common/NavigationComponent";
import { keepTwoDecimal } from "../../../config/utils";
import  math from "../../../config/math.js";
const { width, height } = Dimensions.get("window")
const checked = require('../../../images/mall/checked.png')
const unchecked = require('../../../images/mall/unchecked.png')
const expand = require('../../../images/order/expand.png')
function getwidth(val) {
    return width * val / 375
}

export default class ModifyAccommodationOrder extends NavigationComponent {
    constructor(props) {
        super(props)
        this.ds = new ListView.DataSource({ rowHasChanged: (r1, r2) => r1 !== r2 });
        let { goodsData, startTime, endTime,subPhone, phone, consumer, consumerNum, remark, bcleGoodsType, totalMoney } = this.props.navigation.state.params
        goodsData.forEach((item, index) => {
            item.index = index
        })
        let isStay = false
        if (bcleGoodsType === '1003') {
            isStay = true
        }
        console.log('endtimedate', startTime, endTime)
        this.state = {
            phone: subPhone,  //预约手机号
            reson: '', //修改原因
            starttimedate: startTime, // 入住时间
            endtimedate: endTime,  //  离店时间
            alertVisible: false,
            remark: remark,  //备注
            goodsData: goodsData,
            consumer: consumer,
            consumerNum: consumerNum,
            isStay: isStay,
            totalMoney,
            youhuiPrice: '',
            isOrigionPrice: true,

        }
    }

    blurState = {
        alertVisible: false,
    }

    renderSrvice = (item, some, key) => {
        let borderBt = {}
        let serviceData = this.state.goodsData
        if (key == serviceData.length - 1) {
            borderBt = styles.borderBt1
        }
        return (
            <View style={{ alignItems: 'center' }}>
                <View style={[styles.serviceItem, borderBt]} key={key}>
                    <View style={styles.serviceItemimg}>
                        <Image source={{ uri: item.skuUrl }} style={{ width: getwidth(80), height: getwidth(80) }} />
                    </View>
                    <View style={{ flex: 1, height: 110, justifyContent: 'center' }}>
                        <View style={{ height: getwidth(80), marginLeft: 15, width: '100%' }}>
                            <View style={styles.textItem}>
                                <View style={{ flex: 1 }}>
                                    <Text style={styles.c2f14}>{item.goodsName}</Text>
                                </View>
                            </View>
                            <View style={{ marginTop: 13 }}>
                                <Text style={styles.c7f12}>{item.skuName}</Text>
                            </View>
                            <View style={{ flexDirection: 'row', marginTop: 15, alignItems: 'center' }}>
                                <Text style={styles.credf14}>￥{keepTwoDecimal(math.divide(item.platformPrice , 100))}</Text><Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}> (市场价￥{keepTwoDecimal(math.divide(item.originalPrice , 100) )})</Text>
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
        }, 2000);
    }
    changeState = (name, val) => {
        if (name === 'isOrigionPrice' && val) {
            this.setState({
                youhuiPrice: ''
            })
        }
        this.setState({
            [name]: val
        })
    }
    getTotalMoney = () => {
        const { goodsData, isStay } = this.state
        let totalMoney = 0
        goodsData.forEach((item) => {
            totalMoney = item.platformPrice + totalMoney
        })
        let days = isStay ? this.getDurationData() : 1
        totalMoney =math.divide(math.multiply(totalMoney , days)  , 100)
        this.setState({
            totalMoney
        })
    }
    _createDateData1 = () => {
        let date = [];
        const fullYear = this.fullYear
        const fullMonth = this.fullMonth
        const fullDay = this.fullDay
        for (let i = fullYear; i < fullYear + 10; i++) {
            let month = [];
            for (let j = i == fullYear ? fullMonth : 1; j < 13; j++) {
                let day = [];
                let _day = {}
                let nowDays = i == fullYear && j == fullMonth ? fullDay : 1
                if (j === 2) {
                    for (let k = nowDays; k < 29; k++) {
                        day.push(k + '日');
                    }
                    //Leap day for years that are divisible by 4, such as 2000, 2004
                    if (i % 4 === 0) {
                        day.push(29 + '日');
                    }
                }
                else if (j in { 1: 1, 3: 1, 5: 1, 7: 1, 8: 1, 10: 1, 12: 1 }) {
                    for (let k = nowDays; k < 32; k++) {
                        day.push(k + '日');
                    }
                }
                else {
                    for (let k = nowDays; k < 31; k++) {
                        day.push(k + '日');
                    }
                }
                let _month = {};
                _month[j + '月'] = day;
                month.push(_month);
            }
            let _date = {};
            _date[i + '年'] = month;
            date.push(_date);
        }
        console.log(date)
        return date;
    }
    chooseTime = (name) => {
        const { isStay, endtimedate, starttimedate } = this.state
        if (isStay) {
            let startDay = ''
            if (name == 'endtimedate') {
                startDay = moment(this.state.starttimedate).add('days', 1).format('YYYY年MM月DD日')
            } else {
                startDay = moment().format('YYYY年MM月DD日')
            }
            this.fullYear = parseInt(startDay.split('年')[0])
            this.fullMonth = parseInt(startDay.split('年')[1].split('月')[0])
            this.fullDay = parseInt(startDay.split('月')[1].split('日')[0])
            Picker._showDatePicker((date) => {
                if (name == 'starttimedate' && (date == endtimedate || date > endtimedate)) {
                    Toast.show('入驻时间必须小于离店时间')
                } else {
                    this.setState({
                        [name]: date
                    }, this.getTotalMoney)
                }

            }, this._createDateData1, moment(this.state[name])._d)
        } else {
            Picker._showTimePicker('dateTime', (date) => {
                console.log("Picker._showTimePicker", date);
                this.setState({
                    [name]: date
                }, this.getTotalMoney)
            }, moment(this.state[name])._d)
        }
    }
    getDurationData = () => {
        const { starttimedate, endtimedate } = this.state
        console.log('endtimeda,', endtimedate)
        let result = moment(endtimedate).diff(moment(starttimedate), 'days')
        return result
    }
    addsServiceGoodsData = (data) => {
        console.log('dsdsdsdsdsd', data)
        let newdata = []
        let totalMoney = 0
        data.forEach((item) => {
            // if (item.sum > 1) {
                while (item.sum) {
                    let onedata = JSON.parse(JSON.stringify(item))
                    onedata.sum = 1
                    onedata.platformPrice = onedata.skuprice || onedata.discountPrice
                    onedata.skuUrl = onedata.mainPic || onedata.skuUrl
                    newdata.push(onedata)
                    totalMoney += item.skuprice || item.discountPrice
                    item.sum--
                }
            // } else {
            //     item.platformPrice = item.skuprice || item.discountPrice
            //     item.skuUrl = item.mainPic || item.skuUrl
            //     totalMoney += item.skuprice || item.discountPrice
            //     newdata.push(item)
            // }
        })
        let days = this.getDurationData()
        totalMoney = days ? totalMoney * days : totalMoney
        this.setState({
            goodsData: this.state.goodsData.concat(newdata) ,
            totalMoney: math.divide(totalMoney , 100)
        })
    }
    renderHeader = () => {
        const { isStay, goodsData } = this.state
        return (
            <View style={{ alignItems: 'center' }}>
                <View style={styles.servicView}>
                    <View style={styles.serviceTitle}>
                        <Text style={styles.c2f14}>{isStay ? '住宿' : '服务'}</Text>
                    </View>
                    <TouchableOpacity
                        onPress={() => {
                            const { bcleGoodsType, shopId } = this.props.navigation.state.params
                            this.props.navigation.navigate('EditorMenu', { purchased: -1, serviceCatalogCode: bcleGoodsType, shopId: shopId, serviceData: goodsData, addsServiceGoodsData: this.addsServiceGoodsData })
                        }}
                        style={styles.serviceBtn}>
                        <Text style={styles.cbf14}>修改</Text>
                    </TouchableOpacity>
                </View>
            </View>
        )
    }
    renderFooter = () => {
        const { phone,subPhone, reson, starttimedate, endtimedate, remark, consumerNum, consumer, isStay, isOrigionPrice, goodsData, totalMoney, youhuiPrice } = this.state
        if (isStay) {
            return (
                <View style={{ alignItems: 'center' }}>

                    <View style={styles.infoView}>
                        <View style={styles.infoItem}>
                            <View
                                style={styles.infoItemleft}
                            ><Text style={styles.c2f14}>入住时间:</Text></View>
                            <TouchableOpacity
                                style={styles.infoItemright}
                                onPress={() => this.chooseTime('starttimedate')}
                            >
                                <Text style={styles.c7f14}>{starttimedate}</Text>
                                <Image source={expand} />
                            </TouchableOpacity>
                        </View>

                        <View style={styles.infoItem}>
                            <View
                                style={styles.infoItemleft}
                            ><Text style={styles.c2f14}>离店时间:</Text></View>
                            <TouchableOpacity
                                style={styles.infoItemright}
                                onPress={() => this.chooseTime('endtimedate')}
                            >
                                <Text style={styles.c7f14}>{endtimedate}</Text>
                                <Image source={expand} />
                            </TouchableOpacity>
                        </View>

                        <View style={styles.infoItem}>
                            <View
                                style={styles.infoItemleft}
                            ><Text style={styles.c2f14}>入住时长:</Text></View>
                            <View
                                style={styles.infoItemright}
                            >
                                <Text style={styles.c7f14}>{this.getDurationData()}晚</Text>
                            </View>
                        </View>

                        <View style={styles.infoItem}>
                            <View
                                style={styles.infoItemleft}
                            ><Text style={styles.c2f14}>预约手机:</Text></View>
                            <View style={styles.infoItemright}>
                                <Text>{subPhone}</Text>
                            </View>
                        </View>

                        <View style={styles.infoItem}>
                            <View
                                style={styles.infoItemleft}
                            ><Text style={styles.c2f14}>联系人:</Text></View>
                            <View style={styles.infoItemright}>
                                <Text>{consumer}</Text>
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
                                style={{ flexDirection: 'row', flex: 4, alignItems: 'center' }}
                                onPress={() => {
                                    this.changeState('isOrigionPrice', true)
                                }}
                            >
                                <Image source={isOrigionPrice ? checked : unchecked} />
                                <Text style={[styles.c2f14, { marginLeft: 6 }]}>使用原价:</Text>
                            </TouchableOpacity>

                            <View
                                style={styles.infoItemright}
                            >
                                <Text style={styles.c7f14}>{totalMoney}元</Text>
                            </View>
                        </View>

                        <View style={styles.infoItem}>

                            <TouchableOpacity
                                style={{ flexDirection: 'row', flex: 4, alignItems: 'center' }}
                                onPress={() => {
                                    this.changeState('isOrigionPrice', false)
                                }}
                            >
                                <Image source={isOrigionPrice ? unchecked : checked} />
                                <Text style={[styles.c2f14, { marginLeft: 6 }]}>使用优惠价:</Text>
                            </TouchableOpacity>

                            <View
                                style={[styles.infoItemright, { flexDirection: 'row', alignItems: 'center' }]}
                            >
                                <TextInput
                                    style={[styles.c7f14, { flex: 1, marginRight: 5 }]}
                                    placeholder='请输入金额'
                                    textAlign='right'
                                    value={youhuiPrice}
                                    returnKeyLabel="确定"
                                    returnKeyType="done"
                                    onChangeText={(val) => { this.changeState('youhuiPrice', val) }} />
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
                        <View style={styles.infoItem2}>
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
        } else {
            return (
                <View style={{ alignItems: 'center' }}>

                    <View style={styles.infoView}>
                        <View style={styles.infoItem}>
                            <View
                                style={styles.infoItemleft}
                            ><Text style={styles.c2f14}>预约时间:</Text></View>
                            <TouchableOpacity
                                style={styles.infoItemright}
                                onPress={() => { this.chooseTime('starttimedate') }}
                            >
                                <Text style={styles.c7f14}>{starttimedate}</Text>
                                <Image source={expand} />
                            </TouchableOpacity>
                        </View>

                        <View style={styles.infoItem}>
                            <View
                                style={styles.infoItemleft}
                            ><Text style={styles.c2f14}>预约手机:</Text></View>

                            <View style={styles.infoItemright}>
                                <Text style={styles.c7f14}>{subPhone}</Text>
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
                                style={{ flexDirection: 'row', flex: 4, alignItems: 'center' }}
                                onPress={() => {
                                    this.changeState('isOrigionPrice', true)
                                }}
                            >
                                <Image source={isOrigionPrice ? checked : unchecked} />
                                <Text style={[styles.c2f14, { marginLeft: 6 }]}>使用原价:</Text>
                            </TouchableOpacity>

                            <View
                                style={styles.infoItemright}
                            >
                                <Text style={styles.c7f14}>{totalMoney}元</Text>
                            </View>
                        </View>

                        <View style={styles.infoItem}>

                            <TouchableOpacity
                                style={{ flexDirection: 'row', flex: 4, alignItems: 'center' }}
                                onPress={() => {
                                    this.changeState('isOrigionPrice', false)
                                }}
                            >
                                <Image source={isOrigionPrice ? unchecked : checked} />
                                <Text style={[styles.c2f14, { marginLeft: 6 }]}>使用优惠价:</Text>
                            </TouchableOpacity>

                            <View
                                style={[styles.infoItemright, { flexDirection: 'row', alignItems: 'center' }]}
                            >
                                <TextInput
                                    style={[styles.c7f14, { flex: 1, marginRight: 5 }]}
                                    placeholder='请输入金额'
                                    textAlign='right'
                                    value={youhuiPrice}
                                    returnKeyLabel="确定"
                                    returnKeyType="done"
                                    onChangeText={(val) => { this.changeState('youhuiPrice', val) }} />
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
                        <View style={styles.infoItem2}>
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
    }
    showError = (msg = "提交出错，请检查填写的内容") => {
        Toast.show(msg)
        this.setState({
            alertVisible: false
        })
    }
    saveData = () => {
        const { orderId, shopId } = this.props.navigation.state.params
        const { goodsData, reson, starttimedate, endtimedate, isOrigionPrice, youhuiPrice, totalMoney, isStay } = this.state
        let price = ''
        if (isOrigionPrice) {
            price = totalMoney
        } else {
            price = youhuiPrice
            if (youhuiPrice > totalMoney) { this.showError('优惠价格不得大于实际价格'); return }
        }
        if (!reson) {
            if (youhuiPrice > totalMoney) { this.showError('修改原因必填'); return }
        }
        let param = {
            muserAgreeUpdateOrde: {
                orderId: orderId,
                shopId: shopId,
                goodsParams: [],
                price: math.multiply(price , 100) ,
                appointRange: '',
                modifyInfo: reson,
            }
        }
        goodsData.forEach((item) => {
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
        if (isStay) {
            let startTimeValue = moment(starttimedate, 'YYYY-MM-DD HH:mm').valueOf();
            let endTimeValue = moment(endtimedate, 'YYYY-MM-DD HH:mm').valueOf();
            param.muserAgreeUpdateOrde.appointRange = `${startTimeValue / 1000}-${endTimeValue / 1000}`
            if (startTimeValue >= endTimeValue) { this.showError('离店时间不应小于等于入住时间'); return }
        } else {
            param.muserAgreeUpdateOrde.appointRange = `${moment(starttimedate, 'YYYY-MM-DD HH:mm').valueOf() / 1000}`
        }
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
    deleteServiceData = (data, secId, rowId, rowMap) => {
        let { goodsData } = this.state
        let indexData = -1
        goodsData.find((item, index) => {
            if (item.goodsId === data.goodsId && data.goodsSkuCode === item.goodsSkuCode) {
                indexData = index
                return true
            }
        })
        this.closeRow(rowMap, `${secId}${rowId}`)
        goodsData.splice(indexData, 1)
        this.setState({
            goodsData
        })
    }
    render() {
        const { navigation } = this.props
        const { alertVisible, goodsData, starttimedate } = this.state
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
                    dataSource={this.ds.cloneWithRows(goodsData)}
                    data={goodsData}
                    style={{ marginTop: 10, marginBottom: 60 + CommonStyles.footerPadding, width: width }}
                    renderHeader={this.renderHeader}
                    renderFooter={this.renderFooter}
                    renderRow={this.renderSrvice}
                    renderHiddenRow={(data, secId, rowId, rowMap) => (
                        <TouchableOpacity
                            onPress={() => {
                                this.deleteServiceData(data, secId, rowId, rowMap)
                            }}
                            style={styles.rowBack}>
                            <Text style={styles.cf14}>删除</Text>
                        </TouchableOpacity>

                    )}
                    leftOpenValue={getwidth(68)}
                    rightOpenValue={-getwidth(68)}
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
    scrollList: {
        width: width - 20,
        flex: 1,
        marginTop: 10,
        marginBottom: 16
    },
    servicView: {
        width: width - 20,
        paddingHorizontal: 15,
        backgroundColor: '#fff',
        flexDirection: 'row',
        justifyContent: 'space-between',
        borderTopRightRadius: 8,
        borderTopLeftRadius: 8
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
        backgroundColor: '#fff',
        borderTopColor: '#D7D7D7',
        borderTopWidth: 1
    },
    serviceItemimg: {
        width: getwidth(80),
        height: 110,
        justifyContent: 'center',
        alignItems: 'center'
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
        // height: 450,
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
        borderBottomColor: '#D7D7D7',
        borderBottomWidth: 0.5,
        height: 44,
    },
    infoItem2: {
        width: getwidth(325),
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        height: 44,
    },
    infoItemleft: {
        flex: 3,
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
