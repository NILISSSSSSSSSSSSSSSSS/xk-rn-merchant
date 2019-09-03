/**
 * 售后订单商品列表
 */
import React, { Component } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    ScrollView,
} from "react-native";
import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import { keepTwoDecimal } from "../../../config/utils";

import  math from "../../../config/math.js";
const { width, height } = Dimensions.get("window")

function getwidth(val) {
    return width * val / 375
}
export default class RefundGoodsList extends Component {
    renderItem = () => {
        const { goods } = this.props.navigation.state.params
        return goods.map((item, index) => {
            return (
                <View style={styles.listItem} key={index}>
                    <View style={styles.listItemImg}>
                        <Image source={{ uri: item.goodsSkuUrl }} style={{ width: getwidth(80), height: getwidth(80) }} />
                    </View>
                    <View style={styles.listItemRight}>
                        <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
                            <View><Text style={styles.c2f14}>{item.pName}</Text></View>
                        </View>
                        <View style={{ marginTop: 13 }}><Text style={styles.c7f12}>{item.pSkuName}</Text></View>
                        <View style={{ flexDirection: 'row', justifyContent: 'flex-end', alignItems: 'center', marginTop: 20 }}><Text style={styles.credf14}>￥{keepTwoDecimal(math.divide(item.pPlatformShopPrice , 100) )}</Text>
                            <Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}>  (市场价 ￥{keepTwoDecimal(math.divide(item.pOriginalPrice , 100) )})</Text></View>
                    </View>
                </View>
            )
        })
    }
    render() {
        const { navigation } = this.props
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='席位'
                />
                <ScrollView style={styles.scrllovew} contentContainerStyle={styles.contentContainerStyle} showsVerticalScrollIndicator={false}>
                    {
                        this.renderItem()
                    }
                </ScrollView>
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
    contentContainerStyle: {
        alignItems: 'center',
        marginTop: 8
    },
    scrllovew: {
        backgroundColor: '#fff',
        width: width,
    },
    listItem: {
        width: getwidth(325),
        height: 110,
        flexDirection: 'row',
        borderBottomColor: '#D7D7D7',
        borderBottomWidth: 0.5
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
    c2f14: {
        color: '#222222',
        fontSize: 14
    },
    c7f12: {
        color: '#777777',
        fontSize: 12
    },
    credf14: {
        color: '#EE6161',
        fontSize: 14
    },
    ccf10: {
        color: '#CCCCCC',
        fontSize: 10,
    },
})
