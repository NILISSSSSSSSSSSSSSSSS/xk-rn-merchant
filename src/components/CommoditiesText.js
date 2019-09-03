// 大宗商品列表文案

import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    TouchableOpacity,
} from 'react-native';
import CommonStyles from '../common/Styles';
const { width, height } = Dimensions.get('window');
import  math from "../config/math.js";
import BlurredPrice from './BlurredPrice'
import { getSalePriceText } from '../config/utils'
export default class CommoditiesText extends PureComponent {
    static defaultProps = {
        subscription: 0, // 预约金
        price: 0, // 原价
        buyPrice: 0, // 购买价格
        subscriptionStyle: {},
        buyPriceStyle: {},
        priceStyle: {},
    }

    render() {
        const { subscription, price, buyPrice, priceStyle, buyPriceStyle, subscriptionStyle } = this.props
        return (
            <View style={[styles.commoditiesWrap]}>
                <View style={[CommonStyles.flex_start]}>
                    <Text style={styles.fz12color222}>特惠价：</Text>
                    <Text style={[styles.fz14color222, buyPriceStyle]}>¥</Text>
                    <BlurredPrice color='black'>
                        <Text style={[styles.fz14color222, buyPriceStyle]}>{ getSalePriceText(math.divide(buyPrice || 0, 100)) }</Text>
                    </BlurredPrice>
                </View>
                <View style={[CommonStyles.flex_start]}>
                    { price !== 0 && <Text style={styles.fz12color222}>原价：<Text style={[styles.fz12color999, priceStyle]}>¥{ getSalePriceText(math.divide(price || 0, 100)) }</Text></Text> }
                </View>

                {
                    subscription !== 0
                    ? <View style={[CommonStyles.flex_start]}>
                        <Text style={styles.fz12color222}>预约金：</Text>
                        <Text style={[styles.red_color, { fontSize:12 }]}>¥</Text>
                        <BlurredPrice>
                            <Text style={[styles.red_color, { fontSize: 15 }, subscriptionStyle]}>{ getSalePriceText(math.divide(subscription || 0, 100)) }</Text>
                        </BlurredPrice>
                    </View>
                    : null
                }
            </View>
        );
    }
};

const styles = StyleSheet.create({
    commoditiesWrap: { marginTop: 5 },
    fz12color222: { fontSize: 12, color: '#222' },
    fz14color222: { fontSize: 14, color: '#222' },
    fz12color999: { fontSize: 12, color: '#999', textDecorationLine:'line-through', marginLeft: 5},
    red_color: { color: '#EE6161'}
})