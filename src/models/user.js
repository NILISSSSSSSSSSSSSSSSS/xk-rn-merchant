/**
 * 1. 登录、登出、登录成功、自动登录等逻辑
 * 2. 用户信息修改
 */
import { Platform } from 'react-native';
import applicationService from '../services/application';
import * as nativeApi from '../config/nativeApi';
import * as requestApi from '../config/requestApi';
import modelInitState from '../config/modelInitState';
import { callPhone } from '../config/utils';
import { ReLogin } from '../config/request';
import { JOIN_AUDIT_STATUS } from '../const/user';

export default {
  namespace: 'user',
  state: modelInitState.user,
  reducers: {
    save(state, action) {
      return {
        ...state,
        ...action.payload,
      };
    },
  },
  effects: {
    * autoLogin(action, { call, put, select }) {
      const user = yield select(state => state.user.user);
      yield put({ type: 'system/resetPage', payload: { routeName: 'Login' } });
      if (user.phone && user.password) {
        yield put({ type: 'login', payload: { phone: user.phone, password: user.password, autoLogin: true } });
      }
    },
    * login({ payload: { phone, password, autoLogin = false } }, { call, put }) {
      Loading.show(0);
      const account = { phone, password };
      try {
        const data = yield call(requestApi.requestLogin, account);
        const loginInfo = {
          // 后端更改接口返回数据，去掉user字段
          userId: data.id,
          params: account,
          ...data,
          phone: account.phone,
        };
        global.loginInfo = loginInfo;
        const loginSuccessData = { ...data, ...account };
        yield put({ type: 'loginSuccess', payload: { ...loginSuccessData } });
        yield put({ type: 'application/initData', payload: { loginSuccessData, autoLogin } });
      } catch (error) {
        console.warn(error);
        yield put({ type: 'loginFail' });
      }
      Loading.hide();
    },
    * fetchRegister(action, { call, put }) {
      const params = action.payload;
      try {
        const data = yield call(requestApi.requestRegister, params);
        requestApi.storageLogin('save', data);
        requestApi.storagePhone('save', { phone: params.phone, password: params.password });
        global.loginInfo = { ...data, phone: params.phone, userId: data.id };
        yield put({
          type: 'save',
          payload: {
            ...modelInitState.user,
            user: { ...global.loginInfo },
            userShop: {},
          },
        });
        yield put({ type: 'updateUser', payload: data });
      } catch (error) {
        console.log(error);
      }
    },
    * loginSuccess(action, { call, put, select }) {
      const res = action.payload;
      const user = yield select(state => state.user.user);
      if (user.id != res.id) { // r如果不是相同用户登录，则清空user和shop里存储的数据
        yield put({ type: 'save', payload: { ...modelInitState.user } });
        yield put({ type: 'shop/save', payload: { ...modelInitState.shop } });
      }
      yield put({ type: 'updateUser', payload: res });
      res.merchantId ? yield put({ type: 'getMerchantHome', payload: { isLogin: true } }) : null;
      // 没有提交过申请资料, 或者审核失败
      if (res.createdMerchant == 0 || res.auditStatus == 'audit_fail') {
        yield put({ type: 'system/resetPage', payload: { routeName: 'RegisterList' } });
      } else {
        yield put({ type: 'system/resetToHome' });
        // yield put({ type: 'system/navPage', payload: { routeName: 'Index' } });
      }
      yield put({ type: 'system/save', payload: { doLogin: true } });
    },
    * loginFail(action, { call, put }) {
      // yield put({ type: 'system/resetPage', payload: {routeName:'Login'}})
    },
    * chooseShop(action, { call, put, select }) { // 选择店铺
      const userShop = action.payload.userShop;
      nativeApi.changeShopSuccess(userShop.id);
      console.log('选择店铺', userShop);
      global.loginInfo.userShop = userShop;
      yield put({ type: 'save', payload: { userShop } });
      action.payload.successCallback && action.payload.successCallback();
      try {
        const userInfo = yield select(state => state.user.user);
        console.log(`${userInfo.isAdmin ? '(主账号)' : '(分号)'}有店铺登陆获取权限`);
        const permission = yield call(requestApi.mUserQueryPermission, { shopId: userShop.id });
        global.userRoleList = permission.keyList || [];
        yield put({ type: 'save', payload: { userRoleList: permission.keyList || [] } });
      } catch (error) {
        console.log(error);
        console.log('权限获取失败');
      }
    },
    * xkUserUpdate({ payload: formData }, { call, put, select }) {
      yield call(requestApi.xkUserUpdate, formData);
      yield put({ type: 'updateUser', payload: formData });
    },
    * updateUser(action, { call, put, select }) { // 更新用户信息
      const userState = yield select(state => state.user);
      const user = { ...userState.user, ...action.payload };
      const identityStatuses = user.createdMerchant ? userState.merchantData.merchant && userState.merchantData.merchant.identityStatuses || [] : [];
      const oldMerchant = [...userState.merchant];
      const familyL2 = identityStatuses.find(item => item.merchantType == 'familyL2'); // 若工会已存在家族长不能升级
      let canUpgrade = false;
      let firstMerchant = {};
      const successMerchantTypes = identityStatuses.filter(item => item.auditStatus == 'active') || [];
      const merchant = oldMerchant.map((item, i) => {
        let auditStatus = 0;
        oldMerchant[i] = {
          ...oldMerchant[i], auditStatus: 'unSubmit', updateAuditStatus: null, familyUp: 0,
        };
        for (const item2 of identityStatuses) {
          if (item2.merchantType == oldMerchant[i].merchantType) {
            oldMerchant[i] = { ...oldMerchant[i], ...item2 };
            if (identityStatuses.length == 1 || (successMerchantTypes.length > 0 && successMerchantTypes[0].merchantType == item2.merchantType)) {
              firstMerchant = oldMerchant[i];
            }
            item2.auditStatus == 'active' ? auditStatus = 1 : null;
          }
          if (item2.merchantType == 'familyL1' && item2.auditStatus == 'active' && !familyL2) {
            canUpgrade = true;
          }
        }
        return { ...item, auditStatus };
      });
      nativeApi.updateUser({ ...user, merchant });
      yield put({
        type: 'save',
        payload: {
          user, merchant: oldMerchant, canUpgrade, firstMerchant,
        },
      });
      user.createdMerchant ? null : yield put({ type: 'system/resetPage', payload: { routeName: 'RegisterList' } });
    },
    // /重组联盟商身份状态
    * getMerchantHome({
      payload: {
        successCallback = () => {}, failCallback = () => {}, user = {}, isLogin = false,
      },
    }, { call, put, select }) { // 获取联盟商基本资料
      try {
        const userState = yield select(state => state.user);
        const res = yield call(requestApi.merchantDetail, { merchantId: userState.user.merchantId });
        // 登录时自动登录主店
        const isShopRelations = res.merchantShopRelations && res.merchantShopRelations.length > 0;
        if (isShopRelations && (!userState.userShop.id || isLogin)) { // 商户审核未通过的时候，或者当前为没用店铺的用户，eg:推销员，设置权限为空
          const masterShop = res.merchantShopRelations.find(item => item.shopType == 'MASTER') || res.merchantShopRelations[0];
          yield put({ type: 'shop/getShopDetail', payload: { ...masterShop, id: masterShop.shopId, isLogin } });
        } else {
          yield put({ type: 'shop/getShopDetail' });
        }
        successCallback && successCallback(res);
        const identityStatuses = res.merchant.identityStatuses || [];
        const securityCode = res.merchant.securityCode || '';
        const userParams = {
          ...userState.user,
          ...user,
          securityCode: userState.user.isAdmin===0?userState.user.securityCode:(securityCode || userState.user.securityCode),
          createdMerchant: identityStatuses.length > 0 ? 1 : 0,
          identityStatuses,
          auditStatus: identityStatuses.length == 1 ? identityStatuses[0].auditStatus : userState.user.auditStatus,
        };
        yield put({ type: 'save', payload: { merchantData: res } });
        if ((identityStatuses.filter(item => item && item.auditStatus == 'active')).length > 0) {
          if (userState.user.auditStatus != 'active') {
            Toast.show('您的联盟商信息已审核通过，请重新登录！');
            global.loginInfo = { userId: '', token: '' };
            yield put({ type: 'system/resetPage', payload: { routeName: 'Login' } });
            return;
          }
        }
        yield put({ type: 'updateUser', payload: userParams })
      } catch (error) {
        console.log(error);
        failCallback && failCallback();
      }
    },
    * mUserPermission(action, { call, put, select }) { //
      try {
        const res = yield call(requestApi.mUserQueryPermission);
        const userRoleList = res ? res.keyList : [];
        global.userRoleList = userRoleList;
        yield put({ type: 'save', payload: { userRoleList } });
      } catch (error) {
        console.log(error);
      }
    },
    * logout({ payload: params }, { call, put }) {
      Loading.show();
      try {
        yield call(requestApi.xkUserLogout, {});
      } catch (error) {
        console.log(error);
      }
      global.loginInfo = { userId: '', token: '' };
      yield put({ type: 'system/resetPage', payload: { routeName: 'Login', params } });
      // 清空部分数据
      yield put({ type: 'application/save', payload: { messageModules: {}, messageMapDesc: {} } });
      /** 登出主动清除极光推送 */
      applicationService.removeJPushListeners();
    },
    * showToastUserIsForzen({ payload }, { call, put, select }) {
      try {
        const { reason } = payload;
        const userInfo = yield select(state => state.user.user);
        CustomAlert.onShow( // 用户被冻结 code(1356)
          'confirm',
          reason.message,
          '登录已失效',
          () => { console.log('确定'); ReLogin(false, null); },
          () => { console.log('联系平台'); callPhone(userInfo.platformPhone); ReLogin(false, null); },
          '联系平台',
          '确定',
        );
      } catch (error) {
        console.log('error in user model showToastUserIsForzen', error);
      }
    },
    /** PermissionByAuditStatus */
    * check({ payload: { callback } }, { select, put }) {
      const userInfo = yield select(state => state.user.user);
      const firstMerchant = yield select(state => state.user.firstMerchant || {});
      const { auditStatus, createdMerchant } = userInfo || {};
      const isNotAuditSuccess = auditStatus !== JOIN_AUDIT_STATUS.success || createdMerchant !== 1;
      if (isNotAuditSuccess) {
        switch (auditStatus) {
          case JOIN_AUDIT_STATUS.un_active:
            CustomAlert.onShow('confirm', '您尚未完成入驻，账号未激活', '', () => {}, () => { 
              app._store.dispatch({
                type: 'userActive/navPage',
                payload: {
                  routeName: 'AccountActive',
                  params: {
                    route: 'UserModel', merchantType: firstMerchant.merchantType,
                  },
                },
              });
            }, '立即激活', '取消');
            break;
          case JOIN_AUDIT_STATUS.audit_fail:
            CustomAlert.onShow('alert', '您尚未完成入驻，账号未通过审核', '', () => { }, () => { }, '知道了');
            break;
          default:
            CustomAlert.onShow('alert', '您尚未完成入驻，请耐心等待审核', '', () => { }, () => { }, '知道了');
            break;
        }
      } else {
        callback && callback();
      }
    },
  },
};
