import React, { Component, ReactElement } from 'react'
import { TextInputProps, ViewStyle, TextStyle, StyleProp, LegacyRef, TextInput } from 'react-native'

interface TextInputViewProps extends TextInputProps {
  inputView?: StyleProp<ViewStyle>,
  style?: TextStyle,
  ref?: LegacyRef<TextInput>,
  leftIcon?: ReactElement,
  rightIcon?: ReactElement,
}

export default class TextInputView extends  Component<TextInputViewProps> {}