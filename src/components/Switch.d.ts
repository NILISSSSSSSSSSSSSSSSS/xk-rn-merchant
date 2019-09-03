

import React, { Component } from 'react';
interface StepsIcon extends IconProps {
  tintColor?: string,
  defaultColor?: string,
}

interface SwitchProps {
    value: boolean
    padding: number
    inactiveButtonColor: string
    inactiveButtonPressedColor: string
    activeButtonColor: string
    activeButtonPressedColor: string
    buttonShadow: object
    activeBackgroundColor: string
    inactiveBackgroundColor: string
    buttonRadius: number
    width: number
    height: number
    buttonContent: JSXElement
    disabled: boolean
    switchAnimationTime: number
    borderWidth: number
    borderColor: string
    onActivate: () => { }
    onDeactivate: () => { }
    onChangeState: () => { }
}

export default class Switch extends React.Component<SwitchProps>{}