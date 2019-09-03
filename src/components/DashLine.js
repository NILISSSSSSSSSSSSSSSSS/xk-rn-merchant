import React, { Component } from 'react';
import {
  Dimensions,
  StyleSheet,
  View,
} from 'react-native';

const { width, height } = Dimensions.get('window');

/**
 * 水平方向的虚线
 * @param { boolean } row { 水平还是垂直 }
 * @param { number } width { 总长度 }
 * @param { number } itemLen { 单个虚线的长度 }
 * @param { string } backgroundColor { 背景颜色 }
 */
// 使用
// <DashLine
//     row={true}
//     itemLen={10}
//     width={width}
//     backgroundColor='red'
// />
export default class DashLine extends Component {
  render() {
    const itemLen = this.props.itemLen;
    const len = parseInt(this.props.width / itemLen, 10);
    const arr = [];
    for (let i = 0; i < len; i++) {
      arr.push(i);
    }

    if (this.props.row) {
      return (
        <View style={[styles.dashLineRow, { width: this.props.width }]}>
          {
            arr.map((item, index) => (
              <View
                key={`dash${index}`}
                style={[styles.dashItemRow, { width: itemLen, marginRight: itemLen / 2, backgroundColor: this.props.backgroundColor }]}
              />
            ))
          }
        </View>
      );
    }
    return (
      <View style={[styles.dashLineCol, { height: this.props.width }]}>
        {
                        arr.map((item, index) => (
                          <View
                                    key={`dash${index}`}
                                    style={[styles.dashItemCol, { height: itemLen, marginBottom: itemLen / 2, backgroundColor: this.props.backgroundColor }]}
                          />
                        ))
                    }
      </View>
    );
  }
}

DashLine.defaultProps = {
  row: true,
  width,
  itemLen: 10,
  backgroundColor: '#4A90FA',
};

const styles = StyleSheet.create({
  dashLineRow: {
    flexDirection: 'row',
    overflow: 'hidden',
  },
  dashItemRow: {
    height: 1,
  },
  dashLineCol: {
    flexDirection: 'column',
    overflow: 'hidden',
  },
  dashItemCol: {
    width: 1,
  },
});
