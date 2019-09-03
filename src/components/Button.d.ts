import { Component, ReactChildren } from "react";
import { ImageSourcePropType, ViewStyle, ImageStyle, TextStyle } from 'react-native'

export type ButtonType = "primary" | "default" | "link"

interface ButtonProps {
    type?: ButtonType,
    title: string,
    disabled: boolean,
    style?: ViewStyle,
    titleStyle?: TextStyle,
    disabledStyle: ViewStyle,
    onPress?: Function,
    children?: ReactChildren,
    activeOpacity?: number,
}

export default class Button extends Component<ButtonProps> {}