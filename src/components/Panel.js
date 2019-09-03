import React, { Component } from 'react';
import { View, StyleSheet } from 'react-native';
import {
  WindowWidth, BaseMargin, BorderRadius, BorderColor, WhiteColor, SmallMargin,
} from './theme';
import { ListItem } from './List';

export default class Panel extends Component {
  render() {
    const {
      children, style, headerStyle, bodyStyle, ...rest
    } = this.props;
    return (
      <View style={[styles.panel, style]}>
        <ListItem style={[styles.header, headerStyle]} {...rest} />
        <View style={[styles.body, bodyStyle]}>
          { children }
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  panel: {
    width: WindowWidth - BaseMargin * 2,
    marginHorizontal: BaseMargin,
    borderRadius: BorderRadius,
    backgroundColor: WhiteColor,
    overflow: 'hidden',
    marginTop: BaseMargin,
    paddingBottom: SmallMargin,
  },
  header: {
    borderBottomColor: BorderColor,
    borderBottomWidth: 1,
  },
  body: {
    paddingHorizontal: BaseMargin,
  },
});
