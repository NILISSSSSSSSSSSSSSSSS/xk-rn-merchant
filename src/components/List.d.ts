import React, { Component, ReactElement , ReactText } from 'react';
import { ViewStyle, TextStyle, ImageSourcePropType, ImageStyle, ViewProps } from 'react-native'

interface ListProps {
    header: ReactElement,
    footer: ReactElement, 
    children: ReactElement, 
    style: ViewStyle
}

interface ListItemProps {
    title: ReactElement | ReactText, 
    subtitle: ReactElement | ReactText,
    arrow: boolean, 
    extra: ReactElement | ReactText, 
    icon: ImageSourcePropType, 
    horizontal: boolean, 
    onPress?: Function,
    onExtraPress?: Function,
    onIconPress?: Function,
    iconContainerStyle: ViewStyle, 
    iconStyle: ImageStyle, 
    style: ViewStyle, 
    contentStyle: ViewStyle, 
    titleContainerStyle: ViewStyle, 
    titleStyle: TextStyle, 
    subtitleStyle: TextStyle,
    extraContainerStyle: ViewStyle, 
    extraStyle: TextStyle, 
    arrowStyle: ImageStyle,
    hidden?: boolean,
}

export default class List extends Component<ListProps> {}

export class ListItem extends Component<ListItemProps> {}

export class Splitter extends Component<ViewProps>{}