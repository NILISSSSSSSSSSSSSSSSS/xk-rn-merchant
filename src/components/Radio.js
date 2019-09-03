/**
 * Riado
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
} from 'react-native';

import ImageView from './ImageView';

const unchecked = require('../images/index/unselect.png');
const checked = require('../images/index/select.png');

export default class Radio extends PureComponent {
    handleSelect = (v) => {
      this.props.change(v);
    };

    render() {
      const {
        options = [], value, disabled, textStyle,
      } = this.props;
      return (
        <View style={[styles.grounp, this.props.contentstyle]}>
          {
            options.map((item, index) => (
              <TouchableOpacity
                disabled={disabled}
                key={item.value}
                style={[this.props.itemStyle, this.props[`item${index}Style`], styles.label, index > 0 ? styles.ml20 : null]}
                onPress={() => this.handleSelect(item.value)}
              >
                <ImageView
                    source={
                        item.value === value
                          ? checked
                          : unchecked
                    }
                    sourceWidth={18}
                    sourceHeight={18}
                />
                <Text style={[styles.txt, textStyle]}>{item.title}</Text>
              </TouchableOpacity>
            ))
        }
        </View>
      );
    }
}

const styles = StyleSheet.create({
  grounp: {
    flexDirection: 'row',
    flexWrap: 'nowrap',
  },
  label: {
    flexDirection: 'row',
    flexWrap: 'nowrap',
    alignItems: 'center',
  },
  ml20: {
    marginLeft: 20,
  },
  txt: {
    color: '#555',
    fontSize: 14,
    marginLeft: 10,
  },
});
