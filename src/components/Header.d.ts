import React, { PureComponent, ReactElement, ReactText } from 'react'
import { TextComponent, ViewStyle, TextStyle, ImageStyle } from 'react-native'
import { NavigationProp } from 'react-navigation'

interface HeaderProps {
    /** 标题 */
    title: string,
    /** 可选，是否带返回按钮 */
    goBack: boolean,
    /** 可选，返回的回调 */
    onBack: Function,
    /** 可选，Header容器样式 */
    headerStyle: ViewStyle,
    /** 可选，标题样式 */
    titleTextStyle: TextStyle,
    /** 可选，返回按钮样式 */
    backStyle: ImageStyle,
    /** 可选，左部可定制区域 */
    leftView: ReactText | ReactElement,
    /** 可选，中间可定制区域 */
    centerView: ReactText | ReactElement,
    /** 可选，右部可定制区域 */
    rightView: ReactText | ReactElement,
    /** 可选，导航组件 */
    navigation: NavigationProp,
}

export default class Header extends PureComponent {}