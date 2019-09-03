import React, { Component } from 'react';
import { AppRegistry } from 'react-native';
// import { name as appName } from "./app.json";
import { name, nativeName } from './app.json';
import storage from './src/config/storage';
import './src/utils/exception'; // 全局异常处理
import './src/utils/fontscale'; // 字体倍数设置
import MainApp, { MainAppSOM, MainAppWM, MainAppProfile } from './src';
// 禁止yellowBox显示
console.disableYellowBox = true;
console.log('开始启动', Date.now());

console.assert = (condition, ...args)=> {
  if (!condition) {
    console.log(...args);
  }
};

// 在全局范围内创建一个（且只有一个）storage实例
global.storage = storage;
AppRegistry.registerComponent(name, () => MainApp);

/** 延后执行 */
global.initAppRegistryed = false;
global.initAppRegistry = () => {
  if (!global.initAppRegistryed) {
    global.initAppRegistryed = true;
    AppRegistry.registerComponent('SOMGoodsDetail', () => MainAppSOM);
    AppRegistry.registerComponent('WMGoodsDetail', () => MainAppWM);
    AppRegistry.registerComponent('Profile', () => MainAppProfile);
  }
};
