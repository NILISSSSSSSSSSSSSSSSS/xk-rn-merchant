import React, { Component } from 'react';
import { ViewStyle } from 'react-native';
import { IconProps } from './Icon';
import { ButtonType } from './Button';

interface IconButtonProps extends IconProps {
    type: ButtonType,
    onPress: Function,
    buttonContainerStyle: ViewStyle
}

export default class IconButton extends Component<IconButtonProps> {}
