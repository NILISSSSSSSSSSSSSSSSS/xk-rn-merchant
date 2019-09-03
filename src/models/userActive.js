import modelInitState from '../config/modelInitState';
import * as loginApi from '../config/Apis/login';
import dataMap from '../const/dataMap';
import * as userActiveService from '../services/userActive';

export default {
  namespace: 'userActive',
  state: modelInitState.userActive,
  effects: {
    /** 跳转激活页面/店铺结算页面，并请求基本依赖数据 */
    * navPage({ payload: { routeName, params } }, { select, put, call }) {
      try{
        const activeInfo = yield select(state => state.userActive.activeInfo);
        switch (routeName) {
          case 'AccountActive':
            {
              const { merchantType, familyUp = false } = params || {};
              yield put({ type: 'save', payload: { activeInfo: { ...activeInfo, merchantType, familyUp } } });
            }
            break;
          case 'AccountActiveShop':
            break;
          default:
            break;
        }
      } catch(error) {
        console.log(error);
      }

      yield put({ type: 'system/navPage', payload: { routeName, params } });
    },
    /** 获取店铺结算账户状态 */
    * fetchAccountShopStatus({ payload }, { select, put, call }) {
      try {
        const userInfo = yield select(state => state.user.user);
        const res = yield call(loginApi.detailChannelMerchant, { merchantId: userInfo.merchantId, channel: 'tfb' });
        const firstIndustry = yield call(loginApi.getIndustry, { limit: 0 });
        const firstIndustryMap = (firstIndustry.data || []).map(item => ({ title: item.name, value: item.code }));
        const optionsMap = {
          firstIndustry: firstIndustryMap,
        };

        const detail = res || null;
        const formData = detail ? {} : modelInitState.userActive.shopInfo.formData;
        const allKeys = detail ? (detail.account || []).concat(detail.company || []).concat(detail.legal_person || []) : [];
        allKeys.forEach((item) => {
          formData[item.key] = item.value;
        });

        if (formData.secondIndustry) {
          const secondIndustry = yield call(loginApi.getIndustry, { parentCode: formData.firstIndustry, limit: 0 });
          const secondIndustryMap = (secondIndustry.data || []).map(item => ({ title: item.name, value: item.code }));
          optionsMap.secondIndustry = secondIndustryMap;
        }
        if (formData.openBankCode) {
          formData.openBankCodeMap = yield call(loginApi.tfBankDotQuery, { code: formData.openBankCode });
        }
        if (formData.bankCode) {
          formData.bankCodeMap = yield call(loginApi.tfBankQuery, { code: formData.bankCode });
        }

        yield put({
          type: 'save',
          payload: {
            shopInfo: {
              formData, // 编辑的表单数据
              detailInfo: { ...detail }, // 详情数据
              optionsMap,
            },
          },
        });
      } catch (error) {
        console.log(error);
      }
    },
    /** 请求支付模版 */
    * fetchPayTmpl({ payload: { loading = true } }, { select, put, call }) {
      Loading.show();
      const activeInfo = yield select(state => state.userActive.activeInfo);
      const userInfo = yield select(state => state.user.user);
      const { merchantType } = activeInfo || {};

      // 请求支付模版
      try {
        const res = yield call(loginApi.merchantInitialCostTemplate, { merchantType });
        const requestTime = yield select(state=> state.application.requestTime);
        const dSecond =  Math.ceil((requestTime.localTime - requestTime.systemTime) / 1000) + 2;
        const detail = yield call(loginApi.detailChannelMerchant, { merchantId: userInfo.merchantId, channel: 'tfb' });
        const mDetail = detail || {};
        if (res) {
          const costPayType = (res.cost || []).length > 0 ? (res.cost.find(item=> item.use) || {}).payType : '';
          const depositPayType = (res.deposit || []).length > 0 ? (res.deposit.find(item=> item.use) || {}).payType : '';
          const payTmpl = {
            ...res,
            costPayType,
            depositPayType,
            authStatus: mDetail.auditStatus || res.authStatus,
            partnerId: mDetail.partnerId,
          };
          try {
            const initialCost = yield call(loginApi.merchantInitialCostPayStatus, { merchantType }) || {};
            const cashDeposit = yield call(loginApi.merchantCashDepositPayStatus, { merchantType }) || {};
            payTmpl.costStatus = initialCost.authStatus || payTmpl.costStatus;
            payTmpl.costPayType = initialCost.payType || payTmpl.costPayType;
            payTmpl.costTimeExpire = initialCost.timeExpire ? initialCost.timeExpire + dSecond : 0;
            payTmpl.costPayChannel = initialCost.payChannel;
            payTmpl.depositStatus = cashDeposit.authStatus || payTmpl.depositStatus;
            payTmpl.depositPayType = cashDeposit.payType || payTmpl.depositPayType;
            payTmpl.depositTimeExpire = cashDeposit.timeExpire ? cashDeposit.timeExpire + dSecond : 0;
            payTmpl.depositPayChannel = cashDeposit.payChannel;
          } catch (error) {
            console.log(error);
          }
          yield put({
            type: 'save',
            payload: {
              payTmpl,
            },
          });
        } else {
          Toast.show('未获取到支付模版');
        }
        yield put({ type: 'updateActiveStatus' });
      } catch (error) {
        console.log(error);
      }
      Loading.hide();
    },
    /** 检查用户是否可以激活当前角色 */
    * checkedUserActive({ payload: { callback, merchantType, familyUp } }, { select, put, call }) {
      const activeInfo = yield select(state => state.userActive.activeInfo);
      /** 如果未传递参数，则取activeInfo的值 */
      if (merchantType === undefined) {
        merchantType = activeInfo.merchantType;
        familyUp = activeInfo.familyUp;
      }
      const userInfo = yield select(state => state.user.user);
      const firstMerchant = (yield select(state => state.user.firstMerchant)) || {};

      const notActive = userInfo.auditStatus === 'notActive';
      let activeSuccess = userInfo.auditStatus === 'success';
      const isFirstMerchant = firstMerchant.merchantType === merchantType;
      const identityStatuses = userInfo.identityStatuses || [];
      let canNavUserActive = false;
      let canUpgradeActive = false;
      /** 当前首次入驻的角色 判断 */
      if (isFirstMerchant) {
        // 允许跳转激活
        if (notActive || activeSuccess) {
          canNavUserActive = true;
        }
      }

      /** 首次入驻成功后，非首次入驻的角色 判断 */
      if (activeSuccess && !isFirstMerchant) {
        // 查询当前入驻角色状态
        const currentActiveMerchant = identityStatuses.find(item => item.merchantType === merchantType);
        const currentNotActive = currentActiveMerchant.auditStatus === 'notActive';
        const currentActiveSuccess = currentActiveMerchant.auditStatus === 'success';
        if (currentNotActive || currentActiveSuccess) {
          activeSuccess = currentActiveSuccess;
          canNavUserActive = true;
        }
      }

      /** 如果是家族长升级 入驻角色判断 */
      const canUpgrade = merchantType === 'familyL1' && activeSuccess;
      if (familyUp && canUpgrade) {
        const familyL2 = identityStatuses.find(item => item.merchantType === 'familyL2');
        const familyL2NotActive = familyL2.auditStatus === 'notActive';
        const familyL2ActiveSuccess = familyL2.auditStatus === 'success';
        if (familyL2NotActive || familyL2ActiveSuccess) {
          activeSuccess = familyL2ActiveSuccess;
          canUpgradeActive = true;
        }
      }

      if (!canNavUserActive && !canUpgradeActive) {
        if (familyUp) {
          Toast.show('家族长角色未激活成功，请先激活家族长角色');
        } else if (isFirstMerchant) {
          Toast.show('您首次入驻的角色未审核通过');
        } else {
          Toast.show('您首次入驻的角色未激活成功或者正在激活的角色还未审核通过');
        }
      }

      callback && callback({
        activeSuccess,
        isFirstMerchant,
        canNavUserActive: false,
        canUpgradeActive,
        familyUp,
      });
    },
    /** 获取保证金或者加盟费支付情况 */
    * fetchPaiedInfo({ payload: { type } }, { select, put, call }) {
      try {
        const activeInfo = yield select(state => state.userActive.activeInfo);
        const payTmpl = yield select(state => state.userActive.payTmpl);
        const requestTime = yield select(state=> state.application.requestTime);
        const dSecond =  Math.floor((requestTime.localTime - requestTime.systemTime) / 1000) + 1;
        const { merchantType } = activeInfo || {};
        if (type === 'join') {
          const initialCost = yield call(loginApi.merchantInitialCostPayStatus, { merchantType });
          if (initialCost.payType) {
            payTmpl.costStatus = initialCost.authStatus;
            payTmpl.costPayType = initialCost.payType;
            payTmpl.costTimeExpire = initialCost.timeExpire ? initialCost.timeExpire + dSecond : 0;
            payTmpl.costPayChannel = initialCost.payChannel;
          }
        } else {
          const cashDeposit = yield call(loginApi.merchantCashDepositPayStatus, { merchantType });
          if (cashDeposit.payType) {
            payTmpl.depositStatus = cashDeposit.authStatus;
            payTmpl.depositPayType = cashDeposit.payType;
            payTmpl.depositTimeExpire = cashDeposit.timeExpire ? cashDeposit.timeExpire + dSecond : 0;
            payTmpl.costPayChannel = cashDeposit.payChannel;
          }
        }
        yield put({
          type: 'save',
          payload: {
            payTmpl: { ...payTmpl },
          },
        });
      } catch (error) {
        console.log(error);
      }
    },
    /** 支付保证金或者加盟费 */
    * pay({ payload: { type, payType, context, callback } }, { select, put, call }) {
      Loading.show();
      const activeInfo = yield select(state => state.userActive.activeInfo);
      const { merchantType } = activeInfo || {};
      const rule = context || {};
      const params = {
        payType,
        merchantType,
        costTemplateId: context.id,
      };
      if (payType === 'all') {
        params.payChannel = rule.channel.channelKey;
      }
      console.log(type, payType, context);
      try {
        const res = yield call(type === 'join' ? loginApi.merchantInitialCostPayment : loginApi.merchantCashDepositPayment, params);
        if (payType === 'all') {
          const isOk = yield call(userActiveService.pay, rule, res);
          console.log(isOk);
        }
      } catch (error) {
        console.log(error);
      }
      try {
        yield put({ type: 'fetchPaiedInfo', payload: { type } });
        yield put({ type: 'updateActiveStatus' });
      } catch (error) {
        console.log(error);
      }
      Loading.hide();
    },
    /** 提交店铺结算账户信息 */
    * submitShopActiveInfo({ payload: formData }, { select, put, call }) {
      Loading.show();
      const activeShopInfo = yield select(state => state.userActive.activeShopInfo);
      const { formTmpl } = activeShopInfo;
      const groupFormKeys = dataMap.group.map(g => (formTmpl[g.value] || []));
      const userInfo = yield select(state => state.user.user);
      let keys = [];
      /** 合并所有key */
      groupFormKeys.forEach((item) => {
        keys = keys.concat(item);
      });
      /** 商户店铺结算账户 时间戳传字符串 如：“2587651200” (20190801/马一揆) */
      ['legalPersonCertificateValidity', 'licenseDate', 'systemOpenDate', 'capital'].forEach((key) => {
        if (formData[key]) {
          formData[key] = String(formData[key]);
        }
      });
      /** 组合请求数据 */
      const params = {
        channel: 'tfb',
        merchantId: userInfo.merchantId,
        params: keys.map(item => ({
          key: item.key,
          value: formData[item.key],
          name: item.name,
          group: item.group,
          media: item.media,
        })),
      };
      try {
        yield call(loginApi.createChannelMerchant, params);
        yield put({ type: 'system/back' });
        Toast.show('提交成功');
        yield put({ type: 'updateActiveStatus' });
      } catch (error) {
        console.log(error);
      }
      Loading.hide();
    },
    * changeShopActiveForm({ payload: formData }, { select, put, call }) {
      Loading.show();
      const shopInfo = yield select(state => state.userActive.shopInfo);
      const oldFormData = shopInfo.formData || {};
      const optionsMap = shopInfo.optionsMap || {};

      if (formData.firstIndustry !== oldFormData.firstIndustry) {
        const secondIndustry = yield call(loginApi.getIndustry, { parentCode: formData.firstIndustry, limit: 0 });
        const secondIndustryMap = (secondIndustry.data || []).map(item => ({ title: item.name, value: item.code }));
        optionsMap.secondIndustry = secondIndustryMap;
        formData.secondIndustry = null;
      }

      yield put({
        type: 'save',
        payload: {
          shopInfo: {
            ...shopInfo,
            formData,
            optionsMap,
          },
        },
      });
      Loading.hide();
    },
    /** 获取店铺结算账户信息 */
    * fetchShopActiveInfo({ payload }, { select, put, call }) {
      Loading.show();
      try {
        const userInfo = yield select(state => state.user.user);
        const tmpl = yield call(loginApi.channelMerchantFieldTemplateList, { channel: 'tfb' });
        const groupFormParams = dataMap.group.map((g) => {
          const tmplFields = tmpl[g.value] || {};
          const formParams = {
            ...g,
            fields: tmplFields.map(item => userActiveService.filterField(item)).filter(item => item !== null),
            rules: tmplFields.map(item => userActiveService.filterRules(item)),
          };
          return formParams;
        });

        yield put({
          type: 'save',
          payload: {
            activeShopInfo: {
              formTmpl: tmpl,
              formInfoList: groupFormParams,
              merchantId: userInfo.merchantId,
            },
          },
        });
      } catch (error) {
        console.log(error);
      }
      Loading.hide();
    },
    /**
    * 需要更新用户状态信息
    */
    * updateActiveStatus({ payload }, { select, put, call }) {
      const activeInfo = yield select(state => state.userActive.activeInfo);
      const { merchantType } = activeInfo || {};
      const payTmpl = yield select(state => state.userActive.payTmpl);
      const merchant = yield select(state => state.user.merchant);
      const auditStatus = (merchant.find(item => item.merchantType === merchantType) || {}).auditStatus;
      const actived = auditStatus === 'active';

      if (
        payTmpl.costStatus === 'success'
        && payTmpl.depositStatus === 'success'
        && !actived
      ) {
        yield put({
          type: 'user/getMerchantHome',
          payload: {},
        });
      }
    },
  },
  reducers: {
    save(state, action) {
      return {
        ...state,
        ...action.payload,
      };
    },
  },
};
