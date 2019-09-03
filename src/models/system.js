/**
 * 1. 负责系统跳转
 */
import { StackActions, NavigationActions } from 'react-navigation';
import DeviceInfo from 'react-native-device-info';

export default {
  namespace: 'system',
  state: {
    doLogin: false,
    isFirst: true,
    token: '',
    version: '',
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
    * bootstrap(action, { put, call, select }) {
      const system = yield select(state => state.system);
      const { isFirst, version: currentVersion, doLogin } = system || {};
      const version = DeviceInfo.getVersion();
      if (isFirst || version != currentVersion) { // 1、版本不同或第一次进入app打开引导页
        yield put({ type: 'firstToLogin' });
      } else if (doLogin) { // 2. 是否已经登录过，登录过则自动登录
        yield put({ type: 'user/autoLogin' });
      } else { // 3. 未登录过，直接跳转登录页面
        yield put({ type: 'resetPage', payload: { routeName: 'Login' } });
      }
    },
    * resetToHome(action, { call, put }) {
      const navigateAction = StackActions.reset({
        index: 0,
        actions: [
          NavigationActions.navigate({
            routeName: 'Index',
            params: {},
            action: NavigationActions.navigate({ routeName: 'Home' }),
          }),
        ],
      });
      yield put(navigateAction);
    },
    * resetPage(action, { call, put }) {
      const navigateAction = StackActions.reset({
        index: 0,
        actions: [
          NavigationActions.navigate({ ...action.payload }),
        ],
      });
      yield put(navigateAction);
    },
    * back(action, { call, put }) {
      const navigateAction = NavigationActions.back({ ...action.payload });
      yield put(navigateAction);
    },
    * navPage(action, { call, put }) {
      const navigateAction = NavigationActions.navigate({ ...action.payload });
      yield put(navigateAction);
    },
    * replacePage(action, { call, put }) {
      const navigateAction = StackActions.replace({ ...action.payload });
      yield put(navigateAction);
    },
    * popPage(action, { call, put }) {
      const navigateAction = StackActions.pop({ ...action.payload });
      yield put(navigateAction);
    },
    * firstToLogin(action, { call, put }) {
      const version = DeviceInfo.getVersion();
      yield put({
        type: 'save',
        payload: { isFirst: false, doLogin: false, version },
      });
      yield put({
        type: 'resetPage',
        payload: { routeName: 'AppIntro' },
      });
    },
  },
  subscriptions: {
    setup({ dispatch }) {

    },
  },
};
