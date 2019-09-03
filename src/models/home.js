
import moment from 'moment';
import * as requestApi from '../config/requestApi';
import applicationService from '../services/application';

export default {
  namespace: 'home',
  state: {
    monthIn: {
      RECOMMEND: '',
      'SOURCE_AWARD': '',
      'SALES': '',
      'LIVE_EARNINGS': '',
    },
    userPrizeInfo: { // 中奖信息
      bigPrizeInfo: [''],
      cashPrizeInfo: [''],
      reaPackageWiners: [''],
      prizeCount: 0,
    },
    problemList: [],
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
    * fetchHomeData({ payload }, { select, put, call }) {
      yield put({ type: 'fetchBannerList' });
      yield put({ type: 'unionIndexPieEarningsStatistics' });
      yield put({ type: 'jprizeUserPrize' });
      yield put({ type: 'getNotMerchantRole' });
    },
    * fetchBannerList(_, { select, put, call }) {
      try {
        let { regionCode, userLocations } = yield select(state => state.application);
        if (!regionCode) {
          regionCode = yield call(applicationService.getReginCode, userLocations);
        }
        const bannerLists = yield call(requestApi.requestSOMBannerList, {
          regionCode,
          bannerModule: 'ALLIANCE',
        });
        yield put({ type: 'shop/save', payload: { bannerLists: bannerLists || [] } });
      } catch (error) {
        console.log(error);
      }
    },
    * unionIndexPieEarningsStatistics({ payload }, { select, put, call }) {
      const merchantId = yield select(state => state.user.user.merchantId);
      if (!merchantId) return;
      try {
        const monthIn = yield call(requestApi.unionIndexPieEarningsStatistics, {
          startTime: moment().startOf('month').format('X'),
          endTime: moment().endOf('month').format('X'),
          merchantId,
        });
        yield put({ type: 'save', payload: { monthIn } });
      } catch (error) {
        console.log(error);
      }
    },
    * jprizeUserPrize({ payload }, { select, put, call }) {
      try {
        // 获取中奖信息
        const userPrizeInfo = yield call(requestApi.jprizeUserPrize);
        yield put({ type: 'save', payload: { userPrizeInfo } });
      } catch (error) {
        console.log(error);
      }
    },
    * getNotMerchantRole({ payload }, { select, put, call }) {
      try {
        // 如果不是商户，获取非商户的默认权限,如果分号不是归属于主账号的商户身份，获取非商户的权限
        const userInfo = yield select(state => state.user.user);
        const identityStatuses = userInfo.identityStatuses;
        let isMerchant = false;
        if (identityStatuses && identityStatuses.length > 0) {
          isMerchant = identityStatuses.find(item => (item.auditStatus === 'active' && item.merchantType === 'shops'));
        }
        if (!isMerchant) {
          console.log(`非商户身份${userInfo.isAdmin ? '(主账号)' : '(分号)'}登陆获取权限`);
          yield put({ type: 'user/mUserPermission' });
        } else {
          // 如果是商户，判断是否有店铺，如果有店铺，chooseShop会选择默认店铺登陆，并获取全县
          // 这里处理，身份是商户，但是没有店铺的情况
          if (!(yield select(state => state.user.merchantData)).shops) {
            console.log(`${userInfo.isAdmin ? '(主账号)' : '(分号)'}无店铺登陆获取权限`);
            yield put({ type: 'user/mUserPermission' });
          }
        }
      } catch (error) {
        console.log(error);
      }
    },
    * fetchProblemList({ payload }, { select, put, call }) {
      try {
        const { params } = payload;
        const response = yield call(requestApi.getCommonQuestion, params);
        yield put({ type: 'save', payload: { problemList: response || [] } });
        console.log('problemLis', response);
      } catch (error) {
        console.log('fetchProblemList Error', error);
      }
    },
  },
};
