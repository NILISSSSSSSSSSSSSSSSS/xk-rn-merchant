import React, { Component, ReactText, ReactElement } from 'react';
import { ImageSourcePropType, TextStyle, ImageStyle, ViewStyle, LayoutChangeEvent } from 'react-native'

export interface IconProps {
    size: number,
    title: ReactText | ReactElement,
    subtitle: ReactText | ReactElement,
    source: ImageSourcePropType,
    style: ViewStyle,
    titleStyle: TextStyle,
    subtitleStyle: TextStyle,
    iconStyle: ImageStyle,
    onLayout?: (event: LayoutChangeEvent) => void;
}

export default class Icon extends Component<IconProps> {}