import React, { Component } from 'react';
import { View, Text, StyleSheet } from 'react-native';

export default class Card extends Component {
  render() {
    const { style, children } = this.props;
    return (
      <View style={[styles.card, style]}>
        {children}
      </View>
    );
  }
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: '#fff',
    borderRadius: 6,
    paddingHorizontal: 15,
    overflow: 'hidden',
  },
});
