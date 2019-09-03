import React, { Component } from 'react';
import { Text, View, StyleSheet } from 'react-native';

import requestConfig from '../../android/app/src/main/assets/requestConfig.json';
import config from '../config/config';

export default class Environment extends Component {
  render() {
    const isRelease = requestConfig.envir === '0';
    const envirName = ['正式服', '本地服', '测试服', '预发布'][requestConfig.envir];
    const baseUrl = config.baseUrl;
    return (
      <View style={[styles.container, { opacity: isRelease ? 0 : 1, height: isRelease ? 0 : 36, overflow: 'hidden' }]}>
        <Text style={styles.content}>{envirName}</Text>
        <Text style={styles.url}>{baseUrl}</Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    paddingHorizontal: 12,
    backgroundColor: '#ccc',
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 20,
    position: 'absolute',
    bottom: 12,
    right: 12,
  },
  content: {
    color: '#fff',
    fontSize: 12,
  },
  url: {
    color: '#fff',
    fontSize: 10,
  },
});
