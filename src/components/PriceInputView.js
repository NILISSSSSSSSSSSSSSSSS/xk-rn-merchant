/**
 * TextInput
 */
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import {
  StyleSheet,
  View,
  TextInput,
} from 'react-native';
import { inputPrice, price } from '../config/regular';
import CommonStyles from '../common/Styles';

export default class PriceInputView extends Component {
    static propTypes = {
      inputView: PropTypes.oneOfType([PropTypes.object, PropTypes.number, PropTypes.array]),
      inputRef: PropTypes.func,
      leftIcon: PropTypes.element,
      rightIcon: PropTypes.element,
      style: PropTypes.oneOfType([PropTypes.object, PropTypes.number]),
      onChangeText: PropTypes.func,
      value: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
    }

    static defaultProps = {
      inputView: {},
      inputRef: () => {},
      leftIcon: null,
      rightIcon: null,
      style: {},
      onChangeText: () => {},
      value: '',
    }
    getStrCount=(scrstr, armstr)=> {
      var count = 0;
      while (scrstr.indexOf(armstr) >= 1) {
          scrstr = scrstr.replace(armstr, "")
          count++;
      }
      return count;
  }

    render() {
      const {
        inputView,
        inputRef,
        leftIcon,
        rightIcon,
        style,
        onChangeText,
        value,
        ...rest
      } = this.props;
      return (
        <View style={[{ height: 20 }, inputView]}>
          {leftIcon ? leftIcon : null}
          <TextInput
            ref={inputRef}
            placeholderTextColor="#ccc"
            keyboardType="decimal-pad" // 三星的数字键盘没有小数点
            returnKeyLabel="确定"
            returnKeyType="done"
            value={value === 0 ? '0' : value ? value.toString() : ''}
            autoCapitalize="none"
            underlineColorAndroid="transparent"
            {...rest}
            style={[styles.input, style, !price(value) ? { color: CommonStyles.globalRedColor } : {}]}
            onChangeText={(data) => {
              const text = data.replace(/(^\s*)/g, ''); // 去掉左边空格
              if(this.getStrCount(text,'.')>1){ //最多存在一个小数点
                return
              }
              if(text.split('.')[1] && text.split('.')[1].length>2){ //最多保留两位小数
                return
              }
              if (inputPrice(text)) onChangeText(text); // 判断是否输入数字或者点
            }}
          />
          {rightIcon ? rightIcon : null}
        </View>
      );
    }
}


const styles = StyleSheet.create({
  input: {
    padding: 0,
    flex: 1,
    fontSize: 14,
    height: 20,
    color: '#222',
  },
});
