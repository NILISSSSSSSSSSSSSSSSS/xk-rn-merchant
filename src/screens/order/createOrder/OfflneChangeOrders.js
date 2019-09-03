
/**
 * 线下订单--订单修改
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
import ListView from 'deprecated-react-native-listview';
import moment from 'moment'
import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import Picker from '../../../components/Picker'
import SwipeListView from '../../../components/SwipeListView'
import * as orderRequestApi from '../../../config/Apis/order'
import { keepTwoDecimal } from "../../../config/utils";
import  math from "../../../config/math.js";
const { width, height } = Dimensions.get("window")
const expand = require('../../../images/order/expand.png')
const add = require('../../../images/shopOrder/add.png')
const editor = require('../../../images/shopOrder/editor.png')
import SwipeRow from "../../../components/SwipeRow";
import Content from '../../../components/ContentItem';
function getwidth(val) {
    return width * val / 375
}

export default class OfflneChangeOrders extends Component {
    constructor(props) {
        super(props)
        this.ds = new ListView.DataSource({ rowHasChanged: (r1, r2) => r1 !== r2 })
        const { startTime, serviceData } = this.props.navigation.state.params
        this.state = {
            timedate: startTime, // 时间
            alertVisible: false,
            serviceData: serviceData,
            isOrigiPrice: true,
            youhuiPrice: '',
        }
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
        return (
            <View style={[styles.servicView]}>
                <View style={styles.serviceTitle}>
                    <Text style={styles.c2f14}>服务</Text>
                </View>
                <TouchableOpacity
                    onPress={() => {
                        //服务类型
                        this.props.navigation.navigate('EditorMenu', { purchased: 1, serviceCatalogCode: '1001', shopId: this.props.navigation.state.params.shopId, serviceData, addsServiceGoodsData: this.addsServiceGoodsData })
                    }}
                    style={styles.serviceBtn}>
                    <Text style={styles.cbf14}>修改</Text>
                </TouchableOpacity>
            </View>
        )
    }
    changePriceType = (val) => {
        this.setState({
            isOrigiPrice: val
        })
    }
    changeyouhuiPrice = (val) => {
        this.setState({
            youhuiPrice: val
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
    saveData = () => {
        const { serviceData, timedate } = this.state
        const { navigation } = this.props
        const { orderId, shopId, initDataDidMount } = navigation.state.params
        let param = {
            orderCreate: {
                appointRange: moment(timedate, 'YYYY-MM-DD HH:mm').valueOf() / 1000,
                shopId: shopId,
                goodsParams: [],
                orderId: orderId,
            }
        }
        serviceData.forEach((item) => {
            let onedata = {
                goodsId: item.goodsId,
                goodsSkuCode: item.goodsSkuCode,
                seat: {
                    seatCode: item.seatCode,
                    seatId: item.seatId,
                    seatName: item.seatName,
                    purchases: []
                },
            }
            if (item.goods) {
                item.goods.forEach((goodsItem) => {
                    onedata.seat.purchases.push({
                        goodsId: goodsItem.goodsId,
                        goodsSkuCode: goodsItem.goodsSkuCode
                    })
                })
            }
            param.orderCreate.goodsParams.push(onedata)
        })
        Loading.show()
        orderRequestApi.fetchBcleMUserOrderCreate(param).then((res) => {
            if (initDataDidMount) {
                initDataDidMount(orderId)
                navigation.goBack()
            }
        }).catch(err=>console.log(err))
    }
    deleteOneServiceData = (index) => {
        let { serviceData } = this.state
        serviceData.splice(index, 1)
        this.setState({
            serviceData
        })
    }
    addsServiceGoodsData = (data=[]) => {
        console.log('data1',data)
        let newdata = []
        data.forEach((item, index) => {
                while (item.sum) {
                    let onedata = JSON.parse(JSON.stringify(item))
                    onedata.sum = 1
                    onedata.platformPrice = onedata.skuprice || onedata.discountPrice
                    onedata.skuUrl = onedata.mainPic || onedata.skuUrl
                    onedata.goods=[]
                    newdata.push(onedata)
                    item.sum--
                }
        })
        console.log('data2',newdata)
        this.setState({
            serviceData: this.state.serviceData.concat(newdata) 
        })
    }
    deleteSomeSeatGoodsItem = ( serviceIndex,index) => {
        let { serviceData } = this.state
        serviceData[serviceIndex].goods.splice(index, 1)
        this.setState({
            serviceData
        })
    }
    renderGoods=(item,serviceIndex,index,key)=>{
        return(
            <SwipeRow style={{ backgroundColor: "white" }} key={index} >
                <TouchableOpacity
                    style={styles.delTextContainer}
                    onPress={() => key=='service'?this.deleteOneServiceData(index):this.deleteSomeSeatGoodsItem(serviceIndex,index) }
                >
                    <Text style={styles.deleteTextStyle}>删除</Text>
                </TouchableOpacity>
                {
                    this.renderItem(item,serviceIndex,index,key)
                }
            </SwipeRow>
        )
    }
    renderItem = (item,serviceIndex,index,key) => {
        console.log(item)
        let name=item.name;
        let price=keepTwoDecimal(math.divide(item.platformPrice , 100))
        let originalPrice=keepTwoDecimal(math.divide(item.originalPrice , 100));
        let uri=item.goodsSkuUrl
        let skuName=item.goodsSkuName
        if(key=='service'){
            name=item.goodsName
            uri=item.skuUrl
            skuName=item.skuName
        }
        return (
                <View style={[styles.serviceItem,{paddingHorizontal:15}]} key={item.index}>
                    <View style={styles.serviceItemimg}>
                        <Image source={{ uri }} style={{ width: getwidth(80), height: getwidth(80) }} />
                    </View>
                    <View style={{ flex: 1, height: 80, marginLeft: 15, alignSelf: 'center' }}>
                        <View style={styles.textItem}>
                            <View style={{ flex: 1 }}>
                                <Text style={styles.c2f14}>{name}</Text>
                            </View>
                        </View>
                        <View style={{ marginTop: 13 }}>
                            <Text style={styles.c7f12}>{skuName}</Text>
                        </View>
                        <View style={{ flexDirection: 'row', height: 44, alignItems: 'center', justifyContent: 'space-between' }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                <Text style={styles.credf14}>￥{price} </Text><Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}> (市场价￥{originalPrice})</Text>
                            </View>
                        </View>
                    </View>
                </View>
        )
    }
    getAllGoodsMoney = (goods) => {
        let totalMoney = 0
        goods.forEach((item) => {
            totalMoney += item.platformPrice
        })
        return keepTwoDecimal(totalMoney)
    }
    changeSeatData = (saetData) => {
        let serviceData = this.state.serviceData
        serviceData[this.serviceIndex].seatCode = saetData[0].seatCode
        serviceData[this.serviceIndex].seatId = saetData[0].seatId
        serviceData[this.serviceIndex].seatName = saetData[0].seatName
        this.setState({
            serviceData
        })
    }
    addSeatData = (index) => {
        const { navigation } = this.props
        const { serviceData } = this.state
        this.serviceIndex = index
        let seatData = []
        if (serviceData[index]) {
            seatData.push({
                seatCode: serviceData[index].seatCode,
                seatId: serviceData[index].seatId,
                seatName: serviceData[index].seatName
            })
        }
        navigation.navigate('ChooseTableNum', { maxNum: 1,seatData,serviceData, serviceIndex:index,changeSeatData: this.changeSeatData })
    }
    addgoodsData = (orderData) => {
        const { serviceData } = this.state
        let newdata = []
        orderData.forEach((item) => {
                while (item.sum) {
                    let onedata = JSON.parse(JSON.stringify(item))
                    onedata.sum = 1
                    onedata.platformPrice = onedata.discountPrice || onedata.platformPrice
                    onedata.goodsSkuUrl = onedata.mainPic || onedata.goodsSkuUrl
                    newdata.push(onedata)
                    item.sum--
                }
        })
        serviceData.forEach((item,index) => {
            if(this.serviceIndex==index){
                item.goods =item.goods.concat(newdata) 
            }
        })
        this.setState({
            serviceData
        })
    }
    seatHeader=(item,serviceIndex)=>{
        const { serviceData } = this.state
        const { navigation } = this.props
        const { orderId } = navigation.state.params
        return(
                <View style={styles.item}>
                    <View style={[styles.serviceTitle2]}>
                        <TouchableOpacity
                            onPress={() => { this.addSeatData(serviceIndex) }}
                            style={{ flexDirection: 'row', alignItems: 'center' }}
                        >
                            <Text style={styles.c2f14}>席位：{item.seatName}</Text>
                            <Image source={editor} style={{ marginLeft: 4 }} />
                        </TouchableOpacity>
                        <TouchableOpacity
                            onPress={() => {
                                let goods = JSON.parse(JSON.stringify(item.goods))
                                goods.forEach((goodsItem) => {
                                    goodsItem.goodsName = goodsItem.name
                                })
                                let addGoodsSeat = {
                                    seatId: item.seatId,
                                    seatName: item.seatName
                                }
                                this.serviceIndex=serviceIndex
                                navigation.navigate('EditorMenu', {
                                    addGoodsSeat, addGoodsSeat, orderId, purchased: 1,
                                    serviceCatalogCode: '1002', shopId: this.props.navigation.state.params.shopId, serviceData: goods, addsServiceGoodsData: this.addgoodsData
                                })
                            }}
                            style={{ flexDirection: 'row', alignItems: 'center' }}
                        >
                            <Text style={styles.cbf14}>添加 </Text>
                            <Image source={add} />
                        </TouchableOpacity>
                    </View>
                </View>
        )
    }
    renderSeatFooter=(item,serviceIndex)=>{
        return(
            <View style={styles.item}>
                <View style={[styles.serviceBottom,styles.borderRadiusFooter]}>
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
            
        )
    }
    render() {
        const { navigation } = this.props
        const { serviceData } = this.state
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
                    rightView={
                        <TouchableOpacity
                            onPress={this.saveData}
                            style={{ width: 50 }}
                        >
                            <Text style={{ color: '#FFFFFF', fontSize: 17 }}>确定</Text>
                        </TouchableOpacity>
                    }
                />
                    <ScrollView 
                        style={{flex:1}} 
                        showsVerticalScrollIndicator={false} 
                        contentContainerStyle={{paddingBottom:CommonStyles.footerPadding+10}}
                    >
                        <Content style={styles.contentItem}>
                            {this.renderHeader()}
                            {
                                serviceData.map((item, serviceIndex) => {
                                    return this.renderGoods(item,serviceIndex,serviceIndex,'service')
                                })
                            }
                        </Content>
                        {
                            serviceData.map((item, serviceIndex) => {
                                return(
                                    <Content key={serviceIndex}  style={styles.contentItem}>
                                        {this.seatHeader(item, serviceIndex)}
                                        {
                                            (item.goods || []).map((item2,index)=>{
                                                return this.renderGoods(item2,serviceIndex,index,'goods')
                                            })
                                        }
                                        {this.renderSeatFooter(item, serviceIndex)}
                                    </Content>
                                )
                            })
                        }
                    </ScrollView>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: "center",
        backgroundColor: CommonStyles.globalBgColor
    },
    contentItem:{
        width:width-20,
        overflow:'hidden'
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
        right: getwidth(10),
        top: 0
    },
    serviceBottom: {
        // borderRadius: 8,
        backgroundColor:'#fff',
        paddingHorizontal:15,
    },
    serviceBottomItem: {
        height: 34,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center'
    },
    serviceTitle2: {
        paddingHorizontal:15,
        height: 50,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
    },
    servicView: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        paddingHorizontal:15
    },
    borderRadiusHeader:{
        borderTopRightRadius:6,
        borderTopLeftRadius:6,
    },
    borderRadiusFooter:{
        borderBottomRightRadius:6,
        borderBottomLeftRadius:6,
    },
    nogoods: {
        height: 67,
        justifyContent: 'center',
        alignItems: 'center'
    },
    serviceTitle: {
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
        height: 110,
        flexDirection: 'row',
        backgroundColor: '#fff',
        flex:1,
        borderTopColor:'#f1f1f1',
        borderTopWidth:1
    },
    serviceItemimg: {
        width: 80,
        height: 110,
        justifyContent: 'center',
        alignItems: 'center'
    },
    textItem: {
        width: '100%',
        flexDirection: 'row',
        justifyContent: 'space-between',
        paddingRight: 15
    },
    infoView: {
        width: getwidth(355),
        height: 52,
        marginTop: 10,
        paddingHorizontal: 15,
        borderRadius: 8,
    },
    infoItem: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center'
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
        bottom: 0,
        width: width,
        height: 50,
        backgroundColor: '#4A90FA',
        justifyContent: 'center',
        alignItems: 'center'
    },
    item:{
        borderTopColor:'#D7D7D7',
        borderTopWidth:0.5
    },
    delTextContainer: {
        width: 84,
        backgroundColor: "#EE6161",
        alignItems: "center",
        justifyContent: "center"
    },
    deleteTextStyle: {
        color: "#fff",
        fontSize: 14
    },
})
