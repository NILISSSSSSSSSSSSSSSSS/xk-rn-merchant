/**
 * TextInput
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  View,
  TextInput,
} from 'react-native';

export default class TextInputView extends Component {
  render() {
    const {
      inputView, inputRef, leftIcon, rightIcon, style, ...rest
    } = this.props;
    return (
      <View style={inputView}>
        {leftIcon ? leftIcon : null}
        <TextInput
            ref={inputRef}
            autoCapitalize="none"
            underlineColorAndroid="transparent"
            style={[styles.textInput, style]}
            returnKeyType="done"
            returnKeyLabel="确定"
            {...rest}
            value={rest.value === 0 ? '0' : (rest.value && rest.value.toString()) || undefined}
            onChangeText={data => rest.onChangeText(data.replace(/(^\s*)/g, ''))}
        />
        {rightIcon ? rightIcon : null}
      </View>
    );
  }
}

const styles = StyleSheet.create({
  textInput: {
    padding: 0,
    flex: 1,
    fontFamily: 'PingFangSC-Regular',
    fontSize: 14,
    height: 20,
  },
});
