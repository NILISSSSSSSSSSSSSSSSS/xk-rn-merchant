/**
 * 新建订单
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    ScrollView,
    TouchableOpacity,
} from "react-native";
import { connect } from "rn-dva"
import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import Picker from '../../../components/Picker'
import ModalDemo from "../../../components/Model"
import * as orderRequestApi from '../../../config/Apis/order'
import ImageView from "../../../components/ImageView";
import { isset } from "../../../components/Actionsheet/utils";
import SwipeRow from "../../../components/SwipeRow";
const deleteIcon = require('../../../images/shopOrder/deleteIcon.png')
const editor = require('../../../images/shopOrder/editor.png')
import math from '../../../config/math';
import { NavigationComponent } from "../../../common/NavigationComponent";
import { keepTwoDecimal } from "../../../config/utils";

const { width, height } = Dimensions.get("window")

function getwidth(val) {
    return width * val / 375
}

class CreateOrderScreen extends NavigationComponent {
    state = {
        serviceData: [],
        timedate: '',
        alertVisible: false,
    }
    blurState = {
        alertVisible: false,
    }
    changeSeatData = (saetData) => {
        let serviceData = this.state.serviceData
        serviceData[this.serviceIndex].seat = saetData[0]
        this.setState({
            serviceData
        })
    }
    addSeatData = (index) => {
        const { navigation } = this.props
        const { serviceData } = this.state
        this.serviceIndex = index
        let seatData = []
        if (serviceData[index].seat) {
            seatData.push(serviceData[index].seat)
        }
        navigation.navigate('ChooseTableNum', {serviceData,serviceIndex:index, maxNum: 1, changeSeatData: this.changeSeatData, seatData: seatData })
    }
    addsServiceGoodsDataShop = (orderData) => {
        let { serviceData } = this.state
        let newdata = []
        if (orderData.length) {
            orderData.forEach((item) => {
                if (item.sum > 1) {
                    while (item.sum) {
                        let onedata = JSON.parse(JSON.stringify(item))
                        onedata.sum = 1
                        onedata.platformShopPrice = onedata.discountPrice
                        newdata.push(onedata)
                        item.sum--
                    }
                } else {
                    item.platformShopPrice = item.discountPrice
                    newdata.push(item)
                }
            })
        }
        serviceData[this.serviceIndex].goods = newdata
        this.setState({
            serviceData
        })
    }
    addGoods = (index) => {
        const { serviceData } = this.state
        const { navigation } = this.props
        let data = []
        if (serviceData[index].goods) {
            data = serviceData[index].goods
        }
        this.serviceIndex = index
        navigation.navigate('EditorMenu', {
            purchased: 1,
            serviceCatalogCode: '1002', shopId: this.props.userShop.id,
            serviceData: data, addsServiceGoodsDataShop: this.addsServiceGoodsDataShop
        })
    }
    renderXiwei = () => {
        const { serviceData } = this.state
            return serviceData.map((item, index) => {
                let seat = item.seat
                return (
                    <View style={styles.xiweiView} key={index}>
                        <View style={styles.serviceTitle}>
                            <TouchableOpacity
                                onPress={() => {
                                    this.addSeatData(index)
                                }}
                                style={styles.xiweiItemTitle}>
                                <Text style={styles.c2f14}>席位：{seat && seat.seatName}</Text>
                                <Image style={{ marginLeft: 8 }} source={editor} />
                            </TouchableOpacity>
                            <TouchableOpacity
                                onPress={() => {
                                    this.addGoods(index)
                                }}
                                style={styles.xiweiItemRight}>
                                <Text style={styles.cbluef14}>添加</Text>
                            </TouchableOpacity>
                        </View>
                        {this.renderServiceGoods(index,'seat')}
                    </View>
                )
            })
    }
    renderItem=(item,index,borderBt)=>{
        return(
                <View style={[styles.serviceItem, borderBt,{paddingLeft:15}]} key={index}>
                        <View style={styles.serviceItemimg}>
                            <ImageView
                                source={{ uri: item.mainPic }}
                                resizeMode='cover'
                                sourceWidth={getwidth(80)}
                                sourceHeight={getwidth(80)}
                             />
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
                                <Text style={styles.credf14}>￥{keepTwoDecimal(math.divide(item.platformShopPrice , 100))} </Text><Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}> (市场价￥{keepTwoDecimal(math.divide(item.originalPrice,100)) })</Text>
                            </View>
                        </View>
                    </View>
        )
    }
    deleteSeat=(index,index0)=>{
        const { serviceData } = this.state
        let data =serviceData[index0].goods || []
        data.splice(index,1)
        this.setState({serviceData:serviceData})
    }
    renderServiceGoods = (index0) => {
        const { serviceData } = this.state
        let data = []
        if (serviceData[index0].goods) {
            data = serviceData[index0].goods
        }
        if (data.length) {
            return data.map((item, index) => {
                let borderBt = styles.borderBt
                if (index === data.length - 1) {
                    borderBt = null
                }
                if(isset){
                    return(
                        <SwipeRow
                            style={{ backgroundColor: "white" }}
                            key={index}
                        >
                            <TouchableOpacity
                                style={styles.delTextContainer}
                                onPress={() => this.deleteSeat(index,index0) }
                            >
                                <Text style={styles.deleteTextStyle}>删除</Text>
                            </TouchableOpacity>
                            {
                                this.renderItem(item,index,borderBt)
                            }
                        </SwipeRow>

                    )
                }else{
                    this.renderItem(item,index,borderBt)
                }
            })
        } else {
            return (
                <View style={styles.noGoods}>
                    <Text style={styles.c9f12}>点击右上角的按钮添加菜品</Text>
                </View>
            )
        }
    }
    deleteIndexItem = () => {
        let index = this.state.chooseIndex
        let serviceData = this.state.serviceData
        serviceData.splice(index, 1)
        this.setState({
            serviceData,
            alertVisible: false
        })
    }
    renderServiceData = () => {
        const { serviceData } = this.state
        return serviceData.map((item, index) => {
            let borderBt = styles.borderBt
            if (index === serviceData.length - 1) {
                borderBt = null
            }
            return (
                <View style={[styles.serviceItem, borderBt]} key={index}>
                    <View style={styles.serviceItemimg}>
                        <Image source={{ uri: item.mainPic }} style={{ width: getwidth(80), height: 80 }} />
                    </View>
                    <View style={{ flex: 1, height: 80, marginLeft: 15, alignSelf: 'center' }}>
                        <View style={styles.textItem}>
                            <View style={{ flex: 1 }}>
                                <Text style={styles.c2f14}>{item.goodsName}</Text>
                            </View>
                            <TouchableOpacity
                                onPress={() => {
                                    this.setState({
                                        alertVisible: true,
                                        chooseIndex: index,
                                    })
                                }}
                                style={{ width: getwidth(60), alignItems: 'flex-end' }}>
                                <Image source={deleteIcon} />
                            </TouchableOpacity>
                        </View>
                        <View style={{ marginTop: 13 }}>
                            <Text style={styles.c7f12}>{item.skuName}</Text>
                        </View>
                        <View style={{ flexDirection: 'row', marginTop: 15, alignItems: 'center' }}>
                            <Text style={styles.credf14}>￥{keepTwoDecimal(item.platformShopPrice / 100)} </Text><Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}> (市场价￥{keepTwoDecimal(math.divide(item.originalPrice,100)) })</Text>
                        </View>
                    </View>
                </View>
            )
        })
    }
    addsServiceGoodsData = (orderData) => {
        //增加的服务的数据
        let newData = []
        console.log('orderData2',orderData)
        orderData.forEach((item) => {
            while (item.sum) {
                let onedata = JSON.parse(JSON.stringify(item))
                onedata.sum = 1
                onedata.platformShopPrice = onedata.skuprice || onedata.platformShopPrice || onedata.discountPrice
                onedata.name = onedata.goodsName
                onedata.confirmStatus = 1
                newData.push(onedata)
                item.sum--
            }
        })
        this.setState({
            serviceData:this.state.serviceData.concat(newData) 
        })
    }
    chooseTime = () => {
        Picker._showTimePicker('dateTime', (date) => {
            this.setState({
                timedate: date
            })
        })
    }
    saveData = () => {
        const { serviceData, timedate } = this.state
        if (!serviceData.length) {
            Toast.show('请添加服务')
            return
        }
        let param = {
            orderCreate: {
                goodsParams: [],
                shopId: this.props.userShop.id
            }
        }
        let flag = false
        if (serviceData) {
            serviceData.forEach((item) => {
                let one = {
                    goodsId: item.goodsId,
                    goodsSkuCode: item.goodsSkuCode,
                }
                one.seat = item.seat
                if (one.seat) {
                    one.seat.purchases = []
                    if (item.goods && item.goods.length) {
                        item.goods.forEach((goodItem) => {
                            one.seat.purchases.push({
                                goodsId: goodItem.goodsId,
                                goodsSkuCode: goodItem.goodsSkuCode
                            })
                        })
                    }
                } else {
                    Toast.show('请选择席位');
                    flag = true
                    return
                }
                param.orderCreate.goodsParams.push(one)
            })
        }
        if (flag) {
            return;
        }
        const params={
            fetchParam:param,
            ...this.state,
            totalPrice: this.getTotalPrice(),
            realTotalPrice:this.getTotalPrice('originalPrice')
        }
        console.log(param)
        this.props.navigation.navigate('ConfirmCreateOrder',params)
        // orderRequestApi.fetchBcleMUserOrderCreate(param).then((res) => {
        //     const { navigation } = this.props
        //     navigation.goBack()
        // }).catch(err => {
        //     console.log(err)
        // });
    }
    getTotalPrice=(price='platformShopPrice')=>{
        const {serviceData}=this.state
        let total=0
        for(let item of serviceData){
            total=total+item[price]
            for(let item2 of (item.goods || [])){
                total=total+item2[price]
            }
        }
        return math.divide(total,100)
    }
    render() {
        const { navigation,userShop } = this.props
        const { serviceData, timedate, alertVisible } = this.state
        let shopId = userShop.id
        console.log(serviceData)
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='新建订单'
                    rightView={
                        <TouchableOpacity
                            onPress={this.saveData}
                            style={{ width: 50, height: 44 + CommonStyles.headerPadding, justifyContent: 'center', alignItems: 'center' }}
                        ><Text style={styles.cff17}>确定</Text>
                        </TouchableOpacity>
                    }
                />
                <ModalDemo
                    title='确定删除吗?'
                    visible={alertVisible}
                    onConfirm={this.deleteIndexItem}
                    onClose={() => { this.setState({ alertVisible: false }) }} type='confirm' />
                <View style={styles.mainstyle}>
                    <ScrollView showsVerticalScrollIndicator={false}>
                        <View style={styles.serviceview}>
                            <View style={styles.serviceTitle}>
                                <View><Text style={styles.c2f14}>服务</Text></View>
                                <TouchableOpacity
                                    onPress={() => {
                                        this.props.navigation.navigate('EditorMenu', { purchased: 1, serviceCatalogCode: '1001', shopId, serviceData: serviceData, addsServiceGoodsData: this.addsServiceGoodsData })
                                    }}
                                    style={styles.serviceTitleBtn}
                                ><Text style={styles.cbluef14}>添加</Text></TouchableOpacity>
                            </View>
                            {
                                serviceData && serviceData.length ? (
                                    <View style={{ paddingHorizontal: 15 }}>
                                        {
                                            this.renderServiceData()
                                        }
                                    </View>
                                ) : (
                                        <View style={styles.addService}>
                                            <Text style={styles.c9f12}>点击右上角按钮添加服务</Text>
                                        </View>
                                    )
                            }
                        </View>

                        {
                            this.renderXiwei()
                        }

                    </ScrollView>
                </View>
                <View style={styles.bottomView}>
                    <Text style={{color:'#222'}}>共计：</Text>
                    <Text style={{color:CommonStyles.globalRedColor}}>¥{this.getTotalPrice()}</Text>
                </View>
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
    serviceItem: {
        // width: getwidth(325),
        // paddingHorizontal:15,
        height: 110,
        flexDirection: 'row',
        backgroundColor: '#fff'
    },
    borderBt: {
        borderBottomColor: '#D7D7D7',
        borderBottomWidth: 0.5
    },
    serviceItemimg: {
        width: getwidth(80),
        height: 110,
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius:6
    },
    textItem: {
        width: '100%',
        flexDirection: 'row',
        justifyContent: 'space-between'
    },
    cff17: {
        color: '#FFFFFF',
        fontSize: 17
    },
    c7f12: {
        color: '#777777',
        fontSize: 12
    },
    c2f14: {
        color: '#222222',
        fontSize: 14
    },
    cbluef14: {
        color: '#4A90FA',
        fontSize: 14
    },
    c9f12: {
        color: '#999999',
        fontSize: 12
    },
    credf14: {
        color: '#EE6161',
        fontSize: 14
    },
    ccf14: {
        color: '#CCCCCC',
        fontSize: 14
    },
    ccf10: {
        color: '#CCCCCC',
        fontSize: 10,
    },
    c7f14: {
        color: '#777777',
        fontSize: 14
    },
    mainstyle: {
        width: width,
        flex: 1,
        paddingHorizontal: 10,
    },
    serviceview: {
        width: getwidth(355),
        backgroundColor: '#fff',
        marginTop: 10,
        borderRadius: 8,
        borderColor: '#F1F1F1',
        borderWidth: 1
    },
    serviceTitle: {
        width: getwidth(355),
        height: 40,
        borderBottomColor: '#F1F1F1',
        borderBottomWidth: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingHorizontal: 15
    },
    serviceTitleBtn: {
        width: 100,
        height: 40,
        justifyContent: 'center',
        alignItems: 'flex-end',
    },
    addService: {
        width: getwidth(355),
        height: 67,
        justifyContent: 'center',
        alignItems: 'center'
    },
    infoItem: {
        width: getwidth(325),
        height: 40,
        flexDirection: 'row'
    },
    infoItemtitle: {
        flex: 4,
        height: 40,
        justifyContent: 'center'
    },
    infoItemexpand: {
        flex: 6,
        height: 40,
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center'
    },
    xiweiView: {
        width: getwidth(355),
        backgroundColor: '#fff',
        marginTop: 10,
        borderRadius: 6,
        borderColor: '#F1F1F1',
        borderWidth: 1,
        overflow:'hidden'
    },
    goodsViewStyle: {
        width: getwidth(355),
        paddingHorizontal: 15
    },
    xiweiTitle: {
        // width: getwidth(355),
        height: 40,
        borderColor: '#F1F1F1',
        borderWidth: 1,
        paddingHorizontal: 15,
        flexDirection: 'row',
        alignItems: 'center'
    },
    xiweiItemTitle: {
        flex: 4,
        height: 40,
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center'
    },
    xiweiItemRight: {
        flex: 6,
        height: 40,
        alignItems: 'flex-end',
        justifyContent: 'center'
    },
    noGoods: {
        width: getwidth(355),
        height: 67,
        justifyContent: 'center',
        alignItems: 'center'
    },
    bottomView:{
        flexDirection:'row',
        justifyContent:'space-between',
        alignItems:'center',
        backgroundColor:'#fff',
        width:width,
        paddingBottom:CommonStyles.footerPadding,
        height:50+CommonStyles.footerPadding,
        paddingHorizontal:25,
        marginTop:20
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
export default connect(
    (state) => ({ userShop: state.user.userShop || {} }),
)(CreateOrderScreen)
