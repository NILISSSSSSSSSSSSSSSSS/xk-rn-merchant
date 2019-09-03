
import React, { PureComponent, Component } from 'react';
import { Text, StyleSheet, Platform } from 'react-native';

export default class XKText extends PureComponent {
  render() {
    const { fontFamily, styleName, style, children, ...others } = this.props;
    let currentFontFamily = 'Akrobat-Bold';
    if (['Oswald-Regular', 'Oswald'].indexOf(fontFamily) !== -1) {
      currentFontFamily = Platform.OS === 'ios' ? 'Oswald' : 'Oswald-Regular';
    }

    const fontFamilyStyle = { fontFamily: currentFontFamily };
    const fontColorStyle = styleName ? styles[styleName] : {};
    return (<Text style={[style, fontFamilyStyle, fontColorStyle]} {...others}>{children}</Text>);
  }
}

export const XKTextStyles = {
  c2f14: {
    color: '#222',
    fontSize: 14,
  },
  c9f12: {
    color: '#999',
    fontSize: 12,
  },
  cff22: {
    color: '#fff',
    fontSize: 22,
  },
  cff14: {
    color: '#fff',
    fontSize: 14,
  },
  cff17: {
    color: '#fff',
    fontSize: 17,
  },
};

const styles = StyleSheet.create(XKTextStyles);
