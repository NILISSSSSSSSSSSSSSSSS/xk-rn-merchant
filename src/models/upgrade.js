import applicationService from '../services/application';

export default {
  namespace: 'upgrade',
  state: {
    upgradeInfo: {},
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
    * fetchUpgradeInfo({ payload: { launchAppNotification } }, { put, call, take }) {
      try {
        // 更新信息
        yield put({ type: 'save', payload: { launchAppNotification } });
        yield take(['application/initRequestTime/@@end']);
        const upgradeInfo = yield call(applicationService.fetchUpgradeInfo);
        yield put({ type: 'save', payload: { upgradeInfo } });
        // 读取启动消息
        if (!upgradeInfo.modalVisible && !upgradeInfo.isMandatory) {
          yield put({ type: 'application/readLaunchAppNotification' });
        }
      } catch (error) {
        console.log(error);
      }
    },
  },
};
