import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { StyleSheet, Text, TouchableOpacity } from 'react-native';

export default class Button extends Component {
  static propTypes = {
    type: PropTypes.oneOf(['primary', 'default', 'link']),
  }

  static defaultProps = {
    type: 'default',
  }

  render() {
    const {
      title = '', disabled, disabledStyle, style = {}, onPress = () => {}, type = 'primary', children, titleStyle = {}, activeOpacity,
    } = this.props;
    return (
      <TouchableOpacity activeOpacity={activeOpacity || 0.7} disabled={disabled} style={[styles.button, styles[type], style, disabled ? disabledStyle || styles.disabled : {}]} onPress={() => onPress()}>
        { children ? children : <Text style={[styles.title, styles[`${type}Text`], titleStyle]}>{title}</Text>}
      </TouchableOpacity>
    );
  }
}

const styles = StyleSheet.create({
  disabled: {
    opacity: 0.5,
  },
  button: {
    backgroundColor: '#4A90FA',
    borderRadius: 14,
    height: 44,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 17,
    color: '#fff',
    letterSpacing: -0.41,
  },
  primary: {

  },
  primaryText: {

  },
  default: {
    backgroundColor: '#EEE',
  },
  defaultText: {
    color: '#555',
  },
  link: {
    backgroundColor: 'transparent',
  },
  linkText: {
    color: '#222222',
  },
});
