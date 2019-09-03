import React, { Component } from 'react';
import { IconProps, ViewStyle } from './Icon';

interface StepsIcon extends IconProps {
  tintColor?: string,
  defaultColor?: string,
}

interface StepsProps {
  icons: StepsIcon[],
  size: number,
  vertical?: boolean,
  lineWidth?: number,
  defaultColor?: number,
  onIndexChange?(index: number, icon: StepsIcon): void,
  lineStyle: ViewStyle,
}

export default class Steps extends Component<StepsProps>{}