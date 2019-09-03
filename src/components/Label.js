/**
 * 标签
 */

import React, { Component } from 'react'
import { Text, View, TouchableOpacity, StyleSheet } from 'react-native'
import CommonStyles from '../common/Styles';

export default class Label extends Component {
  render() {
    const { disabled, checked, style = {}, title = "", onPress=()=>{}, titleStyle = {} } = this.props;
    return (
      <TouchableOpacity 
        disabled={disabled} 
        style={[ styles.item, disabled ? styles.disabled : checked ? styles.checked : styles.unchecked, style ]} 
        activeOpacity={disabled ? 1 : 0.9}
        onPress={()=> onPress()}
      >
        <Text style={[styles.title, disabled ? styles.disabledText : checked ? styles.checkedText : styles.uncheckedText, titleStyle]}>{title}</Text>
      </TouchableOpacity>
    )
  }
}

const styles = StyleSheet.create({
    item: {
        alignItems:'center',
        justifyContent: 'center',
        width:80,
        borderRadius: 4,
        height: 20,
    },
    title: {
        fontSize: 12,
    },
    checked: {
        backgroundColor:CommonStyles.globalHeaderColor,
    },
    unchecked: {
        backgroundColor:'#f5f5f5',
        borderWidth:1,
        borderColor:'#f1f1f1'
    },
    disabled: {
        backgroundColor:'#979797',
        borderWidth:1,
        borderColor:'#f1f1f1'
    },
    disabledText: {
        color: '#ddd'
    },
    checkedText: {
        color: '#fff'
    },
    uncheckedText: {
        color: '#ddd'
    }
})