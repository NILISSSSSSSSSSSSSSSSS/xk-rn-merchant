import React, { Component } from 'react';
import {
  Text, View, Image, StyleSheet,
} from 'react-native';

export default class Icon extends Component {
  render() {
    const {
      size = 26, title, subtitle, style, iconStyle, titleStyle, subtitleStyle, source, onLayout,
    } = this.props;
    return (
      <View style={[styles.container, style]} onLayout={evt => onLayout && onLayout(evt)}>
        <Image source={source} style={[{ width: size, height: size }, iconStyle]} />
        { title ? typeof title === 'string' ? <Text style={[styles.title, titleStyle]}>{title}</Text> : title : null }
        { subtitle ? typeof title === 'string' ? <Text style={[styles.subtitle, subtitleStyle]}>{subtitle}</Text> : subtitle : null }
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    color: '#222',
    fontSize: 14,
  },
  subtitle: {
    color: '#999',
    fontSize: 12,
  },
});
