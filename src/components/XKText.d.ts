import React, { PureComponent } from 'react';
import { TextProps } from 'react-native'

type XKTextFontFamilyType = "Akrobat-Bold" | "Oswald-Bold" | "Oswald-Light" | "Oswald-Regular" | "Oswald"
type XKTextStyleNameType = "c2f14" | "c9f12" | "cff22" | "cff14" | "cff17";

interface XKTextProps extends TextProps {
    /** 可选，字体族名称 */
    fontFamily: XKTextFontFamilyType,
    /** 可选，字体大小和颜色样式名称 */
    styleName: XKTextStyleNameType
}

export default class XKText extends PureComponent<XKTextProps> {}