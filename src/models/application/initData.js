import JPushModule from 'jpush-react-native';
import Axios from 'axios';
import applicationService from '../../services/application';
import * as nativeApi from '../../config/nativeApi';
import * as requestApi from '../../config/requestApi';
import { getRemoteSensitiveWords } from '../../config/utils';

export default {
  * initData({ payload: { loginSuccessData = {}, autoLogin = false } }, { put, call }) {
    // 1. 更新极光
    yield put({ type: 'setAlias', payload: loginSuccessData });
    // 2. 给原生传登陆信息
    yield put({ type: 'initNativeLoginInfo', payload: { loginSuccessData, autoLogin } });
    // 3. 敏感词获取
    yield put({ type: 'fetchSensitiveWordLibrary' });
  },
  * readLaunchAppNotification(_, { put, select }) {
    const launchAppNotification = yield select(state => state.application.launchAppNotification);
    if (launchAppNotification) {
      applicationService.openNotificationLaunchAppListener(launchAppNotification);
    }
  },
  * initNativeLoginInfo({ payload: { loginSuccessData, autoLogin } }, { select, put }) {
    const oldMerchant = yield select(state => state.user.merchant);
    const identityStatuses = loginSuccessData.identityStatuses || [];
    const auditSuccess = loginSuccessData.createdMerchant == 1 && loginSuccessData.auditStatus == 'success' && loginSuccessData.identityStatuses && loginSuccessData.identityStatuses.length > 0;
    const merchant = oldMerchant.map((item) => {
      const auditStatus = auditSuccess && !identityStatuses.find(item2 => item2.merchantType == item.merchantType && item2.auditStatus == 'success');
      return {
        ...item,
        auditStatus: auditStatus ? 1 : 0,
      };
    });
    // 传递登录成功的信息
    nativeApi.loginSuccess({ ...loginSuccessData, merchant }, autoLogin);
  },
  * fetchSensitiveWordLibrary(_, { select, put, call }) {
    try {
      const libsInfo = yield call(requestApi.sensitiveWordLibraryDetail);
      const libInfo = libsInfo.find(s => s.wordLibraryType === 'BCIRCLE');
      const oldVersion = yield select(state => state.application.remoteSensitiveWordsVersion);
      if (libInfo.docUrl && oldVersion !== libInfo.version) {
        const remoteSensitiveWords = yield call(() => fetch(libInfo.docUrl)
        .then(res => res.text()).catch(err => {
          console.log(err);
        })
       );
        const filterSensitiveWords = remoteSensitiveWords.split('\n').map(word => word.trim()).filter(word => !!word);
        yield put({ type: 'save', payload: { remoteSensitiveWords: filterSensitiveWords, remoteSensitiveWordsVersion: libInfo.version } });
        // console.log('敏感词获取成功', getRemoteSensitiveWords());
      }
    } catch (error) {
      console.log(error);
    }
  },
  * setAlias({ payload: user }, { select, put, call }) {
    try {
      applicationService.setAlias(user);
      yield put({ type: 'save', payload: { setAliasSuccess: true } });
    } catch (error) {
      console.log(error);
    }
  },
};
