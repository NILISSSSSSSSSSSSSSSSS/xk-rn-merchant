import React, { Component } from 'react';
import dva from 'rn-dva';
import dvaLoading from 'dva-loading';
import thunk from 'redux-thunk';
import logger from 'redux-logger';
import { applyMiddleware } from 'redux';
import { Provider } from 'react-redux';
import { StoreEnhancer, PersistStore } from './utils/persist';
import reducers from './reducer';
import {
  App, AppSOM, AppWM, AppProfile,
} from './App';
import { middleware } from './Routes';
import userModel from './models/user';
import shopModel from './models/shop';
import systemModel from './models/system';
import applicationModel from './models/application';
import taskModel from './models/task';
import homeModel from './models/home';
import mallModel from './models/mall'
import welfareModel from './models/welfare';
import orderModel from './models/order';
import myModel from './models/my';
import userActiveModel from './models/userActive';
import upgradeModel from './models/upgrade';

import config from '../android/app/src/main/assets/requestConfig.json';

const app = dva({
  extraEnhancers: [
    StoreEnhancer(),
    applyMiddleware(middleware),
    applyMiddleware(thunk),
    !__DEV__ || config.enableLogger !== '1' ? null : applyMiddleware(logger),
  ].filter(item => !!item),
  extraReducers: {
    ...reducers,
  },
  uses: [
    dvaLoading({ effects: true }),
  ],
  models: [
    userModel,
    systemModel,
    applicationModel,
    shopModel,
    taskModel,
    homeModel,
    welfareModel,
    orderModel,
    myModel,
    userActiveModel,
    upgradeModel,
    mallModel,
  ],
});

const MainApp = app.start(<App />);

global.app = app;

PersistStore(app);

export default MainApp;

export const MainAppSOM = props => (
  <Provider store={app._store}>
    <AppSOM {...props} />
  </Provider>
);

export const MainAppWM = props => (
  <Provider store={app._store}>
    <AppWM {...props} />
  </Provider>
);

export const MainAppProfile = props => (
  <Provider store={app._store}>
    <AppProfile {...props} />
  </Provider>
);
