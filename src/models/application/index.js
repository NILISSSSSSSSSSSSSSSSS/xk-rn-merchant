/**
 * 1. 负责应用内全局数据：消息红点
 * 2. 七牛token
 * 3. 系统初始化
 */

import { NativeEventEmitter, NativeModules, Platform } from 'react-native';
import config from '../../config/config';
import applicationService from '../../services/application';
import * as nativeApi from '../../config/nativeApi';
import * as requestApi from '../../config/requestApi';
import initSystemEffects from './initSystem';
import initDataEffects from './initData';
import initEffects from './init';
import { TakeOrPickParams } from '../../const/application';

const xkMerchantEmitterModule = NativeModules.xkMerchantEmitterModule;

const initState = {
  messageModules: {},
  messageMapDesc: {},
  qiniuToken: '',
  qiniuTokenExpiryTime: Date.now(),
  launchAppNotification: null,
  requestTime: {},
  uniqueIdentifier: '',
  userLocations: {},
  regionCode: '',
  geolocation: {},
  remoteSensitiveWords: [],
};

export default {
  namespace: 'application',
  state: {
    ...initState,
  },
  reducers: {
    save(state, action) {
      return {
        ...state,
        ...action.payload,
      };
    },
  },
  effects: {
    ...initSystemEffects,
    ...initDataEffects,
    ...initEffects,
    * changeMessageModules({ payload: { modules = [], flag = false } }, { select, put, call }) {
      const messageModules = yield select(state => state.application.messageModules);
      const modulesKeys = Object.keys(messageModules);
      modules.forEach((mod) => {
        modulesKeys.filter(key => key.indexOf(mod) === 0).forEach((key) => {
          messageModules[key] = flag;
        });
        messageModules[mod] = flag;
      });
      yield put({ type: 'save', payload: { messageModules: { ...messageModules } } });
    },
    * changeMessageModulesExt({ payload: { objModules = {} } }, { select, put, call }) {
      const messageModules = yield select(state => state.application.messageModules);
      const modulesKeys = Object.keys(messageModules);
      const modules = Object.entries(objModules).map(([key, value]) => ({ key, value }));
      modules.forEach((mod) => {
        modulesKeys.filter(key => key.indexOf(mod.key) === 0).forEach((key) => {
          messageModules[key] = mod.value;
        });
        messageModules[mod.key] = mod.value;
      });
      yield put({ type: 'save', payload: { messageModules: { ...messageModules } } });
    },
    * changeMessageDesc({ payload: { code = '001', msg = {} } }, { select, put }) {
      const messageMapDesc = yield select(state => state.application.messageMapDesc);
      msg.time = Date.now();
      messageMapDesc[code] = msg;
      yield put({ type: 'save', payload: { messageMapDesc: { ...messageMapDesc } } });
    },
    * openLaunchAppNotification({ payload }, { select }) {
      const launchAppNotification = yield select(state => state.application.launchAppNotification);
      if (launchAppNotification) {
        applicationService.openNotificationListener(launchAppNotification);
        yield put({ type: 'save', payload: { launchAppNotification: null } });
      }
    },
    * syncQiniuToken({ payload: { callback = () => { }, isForce = false } }, { select, put, call }) {
      const application = yield select(state => state.application);
      const { qiniuToken: token, qiniuTokenExpiryTime: expiryTime } = application || {};
      const duration = 600000; // 10 分钟
      if (isForce) {
        Loading.hide();
      }
      // token不存在，或者token即将过期
      const canRequest = !token || (Date.now() + duration) > expiryTime || isForce;
      if (canRequest) {
        try {
          const res = yield call(requestApi.syncQiniuToken);
          yield put({ type: 'save', payload: { qiniuToken: res.upToken, qiniuTokenExpiryTime: res.expiryTime * 1000 } });
          callback && callback(res.upToken);
        } catch (error) {
          console.log('tokenError', error);
          yield put({ type: 'save', payload: { qiniuToken: '', qiniuTokenExpiryTime: Date.now() } });
          callback && callback('');
        }
      } else {
        callback(token);
      }
    },
    * takeOrPickImageAndVideo({ payload: { options, callback } }, {
      select, put, call, take,
    }) {
      const params = new TakeOrPickParams(options);
      yield put({ type: 'syncQiniuToken', payload: {} });
      yield take(['syncQiniuToken/@@end']);
      const qiniuToken = yield select(state => state.application.qiniuToken);
      if (!qiniuToken) {
        Toast.show('七牛token请求中，请稍等片刻；或重新加载');
        return;
      }
      try {
        params.setToken(qiniuToken);
        const _options = params.getOptions();
        const res = params.isTake()
          ? yield call(nativeApi.takeImageAndVideo, _options.token, _options.type, _options.crop, _options.duration)
          : yield call(nativeApi.pickImageAndVideo, _options.token, _options.type, _options.crop, _options.totalNum, _options.limit, _options.duration);
        if (Array.isArray(res) && res.length > 0) {
          callback && callback(res);
        }
      } catch (error) {
        yield put({ type: 'syncQiniuToken', payload: { isForce: true } });
      }
    },
  },
};
