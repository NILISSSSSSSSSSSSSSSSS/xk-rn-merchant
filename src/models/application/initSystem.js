import applicationService from '../../services/application';
import { RequestWriteAndLocationPermission } from '../../config/permission';

export default {
  /** 只需要请求一次的系统数据 */
  * initSystem(_, { put, call }) {
    try {
      // 1. 请求服务器时间
      yield put({ type: 'initRequestTime' });
      // 2. 清空店铺列表页面红点数据
      yield put({ type: 'initMessageModules', payload: {} });
      // 3. 请求设备唯一标识
      const uniqueIdentifier = yield call(applicationService.getUniqueIdentifier);
      yield put({ type: 'save', payload: { uniqueIdentifier } });
      // 4. 获取权限
      yield call(RequestWriteAndLocationPermission);
      // 5. 获取定位信息
      yield put({ type: 'getUserLocations' });
    } catch (error) {
      console.warn(error);
    }
  },
  * initRequestTime(_, { call, put }) {
    const requestTime = yield call(applicationService.initRequestTime);
    yield put({ type: 'save', payload: { requestTime } });
  },
  * getUserLocations(_, { call, put }) {
    // 1. 获取定位信息
    const userLocations = yield call(applicationService.getUserLocations);
    // 2. 获取地区编码
    const regionCode = yield call(applicationService.getReginCode, userLocations);
    // 3. 获取经纬度信息
    const geolocation = yield call(applicationService.getGeolocation, userLocations);
    yield put({ type: 'save', payload: { userLocations, regionCode, geolocation } });
  },
  * initMessageModules(_, { call, put, select }) {
    const shouldDeleteModules = ['orderlist.tabs', 'shops'];
    const messageModules = yield select(state => state.application.messageModules);
    const keys = Object.keys(messageModules).filter(key => shouldDeleteModules.find(item => key.includes(item)));
    const nowMessageModules = {};
    keys.forEach((key) => {
      nowMessageModules[key] = messageModules[key];
    });
    yield put({ type: 'save', payload: { messageModules } });
  },
};
