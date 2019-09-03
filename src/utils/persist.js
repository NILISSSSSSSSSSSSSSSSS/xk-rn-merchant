import { persistStore, persistReducer } from 'redux-persist';
import { AsyncStorage, Platform } from 'react-native';
import JPushModule from 'jpush-react-native';

const persistConfig = {
  key: 'root',
  keyPrefix: 'xk-rn-merchant',
  storage: AsyncStorage,
  blacklist: ['nav'],
  whitelist: ['user', 'system', 'application', 'my', 'home'],
};

const createPersistStore = (rootReducer, createStore) => {
  const persistedReducer = persistReducer(persistConfig, rootReducer);
  return createStore(persistedReducer);
};

export const StoreEnhancer = () => createStore => (rootReducer, initialState, enhancer) => createPersistStore(rootReducer, createStore);

const getLaunchAppNotification = () => {
  let resolved = false;
  return new Promise((resolve, reject) => {
    if (Platform.OS === 'android') {
      resolved = true;
      resolve(null);
      return;
    }
    JPushModule.getLaunchAppNotification((map) => {
      if (resolved) return;
      resolved = true;
      resolve(map);
    });
    setTimeout(() => {
      if (resolved) return;
      resolved = true;
      resolve(null);
    }, 100);
  });
};

const InitGlobalData = () => {
  const state = app._store.getState();
  const application = state.application || {};
  const {
    requestTime, uniqueIdentifier, userLocations, regionCode, geolocation,
  } = application;
  if (requestTime && requestTime.systemTime) global.requestTime = requestTime;
  global.uniqueIdentifier = uniqueIdentifier;
  if (userLocations && userLocations.region) global.userLocations = userLocations;
  global.regionCode = regionCode;
  if (geolocation && geolocation.lng) {
    global.geolocation = geolocation;
    global.lng = geolocation.lng;
    global.lat = geolocation.lng;
  }
};

global.inited = false;

export const PersistStore = (app) => {
  persistStore(app.getStore(), null, async (err, res) => {
    if (global.inited) return;
    global.inited = true;
    /** 初始化全局数据 */
    InitGlobalData();
    /** 系统数据初始化 */
    const launchAppNotification = await getLaunchAppNotification();
    app._store.dispatch({
      type: 'application/init',
      payload: {
        launchAppNotification,
      },
    });
    /** 页面跳转 */
    app._store.dispatch({
      type: 'system/bootstrap',
    });
  });
};
