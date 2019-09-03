import React, { Component } from 'react';
import { Text, View, StyleSheet } from 'react-native';
import Button from './Button';
import CommonStyles from '../common/Styles';

export const FixedHeight = 50;

export default class FixedFooter extends Component {
  render() {
    const { style, fixedHeight = FixedHeight } = this.props;
    return (
      <View style={[styles.fixedFooter, { height: fixedHeight }, style]}>
        {
            this.props.children
        }
      </View>
    );
  }
}
/** 弹框组件 */
export class FixedSpacer extends Component {
  render() {
    return <View style={{ flex: 1, height: FixedHeight }}>{this.props.children}</View>;
  }
}

/** 提示内容 */
export class FixedTips extends Component {
  render() {
    const { style, titleStyle, title } = this.props;
    return <View style={[styles.fixedtips, style]}><Text style={[styles.fixedTipsTitle, titleStyle]}>{title}</Text></View>;
  }
}

/** 按钮 */
export class FixedButton extends Component {
  render() {
    const {
      style, ...others
    } = this.props;
    return <Button style={[styles.fixedButton, style]} {...others} />;
  }
}

const styles = StyleSheet.create({
  fixedFooter: {
    height: FixedHeight,
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: '#fff',
    marginBottom: CommonStyles.footerPadding,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  fixedButton: {
    height: '100%',
    width: 105,
    borderRadius: 0,
  },
  fixedTips: {

  },
});
