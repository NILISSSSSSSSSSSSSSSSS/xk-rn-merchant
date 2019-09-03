import { Component, ReactChildren } from "react";
import { ViewStyle, TextStyle } from 'react-native'


interface Props {
    subscription: number // 预约金
    price: number // 原价
    buyPrice: number // 购买价格
    priceStyle: TextStyle // 数字样式
    buyPriceStyle: TextStyle // 数字样式
    subscriptionStyle: TextStyle // 数字样式
}

export default class CommoditiesText extends PureComponent<Props> {}