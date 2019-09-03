import applicationService from '../../services/application';

export default {
  * init({ payload: { launchAppNotification } }, { put, call, take }) {
    // 1. 初始化微信
    applicationService.initWechat();
    // 2. 初始化极光
    applicationService.initJPush();
    // 3. 更新系统
    yield put({ type: 'upgrade/fetchUpgradeInfo', payload: { launchAppNotification } });
    // 4. 初始化系统数据
    yield put({ type: 'initSystem' });
    // 5. 监听本地消息
    applicationService.initNativeMessage();
  },
};
