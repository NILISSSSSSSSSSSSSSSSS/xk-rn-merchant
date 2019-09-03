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
import * as orderRequestApi from '../../../config/Apis/order'
import math from '../../../config/math';
import { keepTwoDecimal } from "../../../config/utils";
const { width, height } = Dimensions.get("window")

function getwidth(val) {
    return width * val / 375
}

export default class CreateOrderScreen extends Component {
    constructor(props){
        super(props)
        this.state=props.navigation.state.params || {}
    }

    renderXiwei = () => {
        const { canAddGoods, serviceData } = this.state
        if (canAddGoods) {
            return serviceData.map((item, index) => {
                let seat = item.seat
                return (
                    <View style={styles.xiweiView} key={index}>
                        <View style={styles.serviceTitle}>
                            <View style={styles.xiweiItemTitle}  >
                                <Text style={styles.c2f14}>席位：{seat && seat.seatName}</Text>
                            </View>
                        </View>
                        <View style={styles.goodsViewStyle}>
                            {
                                this.renderServiceGoods(index)
                            }
                        </View>
                    </View>
                )
            })
        }
    }
    renderServiceGoods = (index) => {
        const { serviceData } = this.state
        let data = []
        if (serviceData[index].goods) {
            data = serviceData[index].goods
        }
        return data.map((item, index) => {
            let borderBt = styles.borderBt
            if (index === data.length - 1) {
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

    saveData = () => {
        Loading.show()
        orderRequestApi.fetchBcleMUserOrderCreate(this.state.fetchParam).then((res) => {
            const { navigation } = this.props
            Toast.show('新增成功')
            navigation.navigate('CreateOrderSucess',{orderParams:{
                ...res,
                orderId:res.orderIdByString || res.orderId,
                ...this.state.fetchParam
            }})
        }).catch(err => {
            console.log(err)
        });
    }
    render() {
        const { navigation } = this.props
        console.log(this.state)
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='生成订单'
                    rightView={
                        <TouchableOpacity
                            onPress={()=>navigation.goBack()}
                            style={{ width: 50, height: 44 + CommonStyles.headerPadding, justifyContent: 'center', alignItems: 'center' }}
                        ><Text style={styles.cff17}>编辑</Text>
                        </TouchableOpacity>
                    }
                />

                <View style={styles.mainstyle}>
                    <ScrollView showsVerticalScrollIndicator={false}>
                        <View style={styles.serviceview} contentContainerStyle={{paddingBottom:20}}>
                            <View style={styles.serviceTitle}>
                                <View><Text style={styles.c2f14}>服务</Text></View>
                            </View>
                            <View style={{ paddingHorizontal: 15 }}>
                                {
                                    this.renderServiceData()
                                }
                            </View>
                        </View>
                        <View style={styles.serviceview}>
                            <View style={styles.serviceTitle}>
                                <Text style={styles.c2f14}>席位选择</Text>
                                <Text style={styles.c2f14}>已选{this.state.serviceData.length}个</Text>
                            </View>
                        </View>
                        {
                            this.renderXiwei()
                        }
                    </ScrollView>
                </View>
                <View style={{marginTop:10, backgroundColor:'#fff',borderRadius:6,width:getwidth(355),paddingHorizontal:15,paddingVertical:15}}>
                    <View style={styles.row}>
                        <Text style={{color:'#777'}}>总金额：</Text>
                        <Text style={{color:CommonStyles.globalRedColor}}>¥{this.state.realTotalPrice}</Text>
                    </View>
                    <View style={[styles.row,{marginTop:10}]}>
                        <Text style={{color:'#777'}}>实际支付：</Text>
                        <Text style={{color:CommonStyles.globalRedColor}}>¥{this.state.totalPrice}</Text>
                    </View>
                </View>
                <TouchableOpacity style={styles.bottomView} onPress={this.saveData}>
                    <Text style={{color:'#fff',fontSize:17}}>确认生成订单</Text>
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
    row:{
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'space-between'
    },
    serviceItem: {
        // width: getwidth(325),
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
        alignItems: 'center'
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
        width: getwidth(355),
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
        justifyContent:'center',
        alignItems:'center',
        backgroundColor:CommonStyles.globalHeaderColor,
        width:width,
        marginBottom:CommonStyles.footerPadding,
        height:50,
        marginTop:20
    },
})
