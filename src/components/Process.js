/**
 * 进度条
 * 用例： <Process label="开奖进度：" height={4} nowValue={60} />
 */

import React, { Component } from 'react';
import {
  StyleSheet,
  View,
  Text,
} from 'react-native';
import CommonStyles from '../common/Styles';
export default class Process extends Component {
    static defaultProps = {
      nowValue: 20, // 当前值，单位是，百分比
      height: 3, // 高度
      label: '', // label文字
      labelStyle: {}, // label样式
      showText: '', // 自定义显示的文本
    }
    constructor (props) {
      super(props)
      this.state = {
        textWidth: 44,
        bgViewWidth: 0,
        showText: props.showText,
        textHeight: 18,
      }
    }
    // shouldComponentUpdate (a,b) {
    //   console.log('a',a,'b',b)
    //   if (a.showText === b.showText) {
    //     return false
    //   }
    //   return true
    // }
    getTextWidth = (e) => {
      if (e.nativeEvent.layout) {
        this.setState({ 
          textWidth: e.nativeEvent.layout.width,
          textHeight: e.nativeEvent.layout.height
         })
      }
    }
    getBgViewWidth = (e) => {
      if (e.nativeEvent.layout) {
        this.setState({ bgViewWidth: e.nativeEvent.layout.width })
      }
    }
    getOffset = (nowValue) => {
      const { bgViewWidth, textWidth } = this.state
      if (nowValue >= (100 - (textWidth / bgViewWidth) * 100)) {
        return (100 - (textWidth / bgViewWidth) * 100)
      }
      return nowValue
    }
    render() {
      const {
        height, label, labelStyle, showText, bgViewWidth
      } = this.props;
      const { textWidth, textHeight } = this.state
      // eslint-disable-next-line no-restricted-globals
      let nowValue = (isNaN(this.props.nowValue) ? 0 : this.props.nowValue); // 排除NaN
      if (nowValue > 100) {
        nowValue = 100;
      }
      const offsetX = this.getOffset(nowValue)
      const top = -((textHeight - height) / 2);
      return (
        <View style={styles.containerView}>
          <Text style={[styles.labelStyle, labelStyle]}>{label}</Text>
          <View style={[styles.container_bgView,CommonStyles.flex_center, { borderRadius: height, height }]} onLayout={(e) => { this.getBgViewWidth(e) }}>
            <View style={[styles.container_nowValue, { width: `${nowValue}%`, borderRadius: height, height }, styles.noBorderRadius]}/>
            <Text numberOfLines={1} style={[styles.container_showValue, { left: `${offsetX}%`, top, }, { ...CommonStyles.shadowStyle }]} onLayout={(e) => { this.getTextWidth(e) }} >
              {(showText === 'NaN%') ? '0%' : showText || `${nowValue}%`}
            </Text>
          </View>
        </View>
      );
    }
}

const styles = StyleSheet.create({
  labelStyle: {
    fontSize: 12,
    color: '#222',
    paddingRight: 5,
  },
  container_bgView: {
    backgroundColor: '#DFE2E6',
    height: '100%',
    flex: 1,
  },
  container_nowValue: {
    backgroundColor: CommonStyles.globalHeaderColor,
    position: 'absolute',
    left: 0,
  },
  container_showValue: {
    borderRadius: 2,
    paddingLeft: 1,
    paddingRight: 1,
    maxWidth: 81,
    backgroundColor: '#fff',
    position: 'absolute',
    fontSize: 12,
    color: '#222',
    textAlign: 'center',
  },
  noBorderRadius: {
    borderTopRightRadius: 0,
    borderBottomRightRadius: 0,
  },
  containerView: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
});
