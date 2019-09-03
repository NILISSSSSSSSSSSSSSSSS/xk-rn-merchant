import { Component, ReactChildren } from "react";
import { ViewStyle, TextStyle } from 'react-native'


interface Props {
    title: string
    style: ViewStyle
    onPress: () => void
    textStyle: TextStyle
    activeOpacity: number
}

export default class CommonButton extends PureComponent<Props> {}