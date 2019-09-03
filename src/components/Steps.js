import React, { Component } from 'react';
import { Text, View, TouchableOpacity } from 'react-native';
import Icon from './Icon';
import { RowBetween, YellowColor, BackThirdColor, BackSecondColor } from './theme';

function calculatePosition(vertical = false, lineWidth = 7, rootPosition = {}, firstIconLayout = {}, lastIconLayout = {}, size = 32) {
  const position = vertical ? {
    left: size / 2 - lineWidth / 2,
    top: firstIconLayout.width / 2,
    height: rootPosition.height - (firstIconLayout.height + lastIconLayout.height) / 2,
  } : {
    top: size / 2 - lineWidth / 2,
    left: firstIconLayout.height / 2,
    width: rootPosition.width - (firstIconLayout.width + lastIconLayout.width) / 2,
  };
  console.log(position);
  return position;
}

export default class Steps extends Component {
  state = {
    position: null,
    layouted: false,
    index: -1,
  }

  handleLayout(evt, targetType) {
    const { vertical = false, lineWidth = 7, size } = this.props;
    const { layouted } = this.state;
    switch (targetType) {
      case 'root':
        this.rootLayout = evt.nativeEvent.layout;
        break;
      case 'firstIcon':
        this.firstIconLayout = evt.nativeEvent.layout;
        break;
      case 'lastIcon':
        this.lastIconLayout = evt.nativeEvent.layout;
        break;
      default:
        break;
    }

    if (this.rootLayout && this.firstIconLayout && this.lastIconLayout) {
      console.log(this.rootLayout, this.firstIconLayout, this.lastIconLayout);
      const position = calculatePosition(vertical, lineWidth, this.rootLayout, this.firstIconLayout, this.lastIconLayout, size);
      this.setState({ layouted, position });
    }
  }

  handlePress(index, icon) {
    const { index: indexProp, onIndexChange } = this.props;
    const controllMode = indexProp !== undefined;
    onIndexChange && onIndexChange(index, icon);
    if (!controllMode) {
      this.setState({ index });
    }
  }

  render() {
    const {
      vertical = false, size = 32, tintColor = YellowColor, icons = [], lineWidth = 7, index: indexProp = -1, defaultColor = BackThirdColor, lineStyle,
    } = this.props;
    const { position, layouted, index } = this.state;
    const controllMode = indexProp !== undefined;
    const currentIndex = (controllMode ? indexProp : index) || -1;

    return (
      <View style={{ position: 'relative' }}>
        <View style={[vertical ? {} : RowBetween, { position: 'relative', zIndex: 1 }]} onLayout={evt => this.handleLayout(evt, 'root')}>
          {
            icons.map((icon, i) => {
              const _tintColor = icon.tintColor || tintColor;
              const _defaultColor = icon.defaultColor || defaultColor;
              const iconColor = currentIndex >= i ? _defaultColor : _tintColor;
              const isFirst = i === 0;
              const isLast = i === icons.length - 1;
              return (
                <TouchableOpacity key={icon.title} onPress={() => this.handlePress(i, icon)}>
                  <Icon
                    size={icon.size || size}
                    source={icon.source}
                    iconStyle={{ tintColor: iconColor, ...icon.iconStyle }}
                    titleStyle={{ color: iconColor, ...icon.titleStyle }}
                    subtitleStyle={{ color: iconColor, ...icon.subtitleStyle }}
                    title={icon.title}
                    subtitle={icon.subtitle}
                    style={icon.style}
                    onLayout={evt => (isFirst || isLast) && this.handleLayout(evt, isFirst ? 'firstIcon' : 'lastIcon')}
                  />
                </TouchableOpacity>
              );
            })
          }
        </View>
        <View
          style={[{
            position: 'absolute', top: size / 2, left: size / 2, height: lineWidth, width: lineWidth, backgroundColor: BackSecondColor, zIndex: -1,
          }, position, lineStyle]}
        />
      </View>
    );
  }
}
