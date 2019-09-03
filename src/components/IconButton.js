import React, { Component } from 'react'
import { Text, View } from 'react-native'
import Button from './Button';
import Icon from './Icon';

export default class IconButton extends Component {
  render() {
    const { style, source, title, subtitle, titleStyle, subtitleStyle, size, iconStyle, onPress, buttonContainerStyle, type = "link" } = this.props;
    return <Button type={type} style={buttonContainerStyle} onPress={onPress}>
        <Icon style={style} iconStyle={iconStyle} source={source} title={title} subtitle={subtitle} titleStyle={titleStyle} subtitleStyle={subtitleStyle} size={size}></Icon>
    </Button>
  }
}