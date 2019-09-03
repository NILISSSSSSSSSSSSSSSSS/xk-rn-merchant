import React, { Component } from 'react';
import {
  Text, View, StyleSheet, TouchableOpacity,
} from 'react-native';
import moment from 'moment';
import ImageView from './ImageView';

export const ExtraImage = ({
  field, value, width = 50, height = 50, onPress = () => {},
}) => (
  <TouchableOpacity onPress={() => onPress && onPress({ field, value })}>
    <ImageView
        resizeMode="cover"
        source={{ uri: value }}
        sourceWidth={width}
        sourceHeight={height}
    />
  </TouchableOpacity>
);

export const ExtraAvatar = ({
  field, value, width = 50, hasCamera = true, onPress = () => {}, disabled,
}) => (
  <TouchableOpacity disabled={disabled} style={{ position: 'relative' }} onPress={() => onPress && onPress({ field, value })}>
    <ImageView
        resizeMode="cover"
        source={{ uri: value }}
        sourceWidth={width}
        sourceHeight={width}
        style={{ borderRadius: width / 2 }}
    />
    {
        hasCamera && !disabled ? (
          <ImageView
            resizeMode="cover"
            source={require('../images/profile/camera.png')}
            sourceWidth={18}
            sourceHeight={18}
            style={{
              backgroundColor: '#fff', borderRadius: 9, position: 'absolute', bottom: 0, right: 0,
            }}
          />
        ) : null
    }
  </TouchableOpacity>
);

export const ExtraTextInput = ({
  field, value, placeholder = '未填写', onPress = () => { }, disabled,
}) => (
  <TouchableOpacity disabled={disabled} onPress={() => onPress && onPress({ field, value })}>
    <Text style={disabled ? styles.disabledText : value ? styles.hasText : styles.noText}>{value ? value : placeholder}</Text>
  </TouchableOpacity>
);

export const ExtraDatePicker = ({
  field, value = '2019-05-29', onPress = () => {}, disabled, style,
}) => {
  const strDate = value == null ? '请选择' : moment(value, 'YYYY-MM-DD').format('YYYY年MM月DD日');
  console.log('ExtraDatePicker', strDate);
  return (
    <TouchableOpacity style={style} disabled={disabled} onPress={() => onPress && onPress({ field, value })}>
      <Text style={disabled ? styles.disabledText : value ? styles.hasText : styles.noText}>{strDate}</Text>
    </TouchableOpacity>
  );
};

export const ExtraDistrictPicker = ({
  field, value = '2019-05-29', onPress = () => {}, disabled, style,
}) => {
  const strDistrict = !value ? '请选择' : value;
  return (
    <TouchableOpacity style={style} disabled={disabled} onPress={() => onPress && onPress({ field, value })}>
      <Text style={disabled ? styles.disabledText : value ? styles.hasText : styles.noText}>{strDistrict}</Text>
    </TouchableOpacity>
  );
};

export const ExtraGenderPicker = ({
  field, value = 'unknown', onPress = () => {}, disabled = true,
}) => {
  const valueArr = ['male', 'female', 'unknown'];
  const strArr = ['男', '女', '保密'];
  const index = valueArr.indexOf(value);
  const strGender = strArr[index < 0 || index > 2 ? 2 : index];
  return (
    <TouchableOpacity disabled={disabled} onPress={() => onPress && onPress({ field, value })}>
      <Text style={disabled ? styles.disabledText : value ? styles.hasText : styles.noText}>{strGender}</Text>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  disabledText: {
    fontSize: 15,
    color: '#9E9E9E',
    letterSpacing: 0,
    textAlign: 'right',
  },
  hasText: {
    fontSize: 15,
    color: '#222222',
    letterSpacing: 0,
    textAlign: 'right',
  },
  noText: {
    fontSize: 15,
    color: '#CCCCCC',
    letterSpacing: 0,
    textAlign: 'right',
  },
});
