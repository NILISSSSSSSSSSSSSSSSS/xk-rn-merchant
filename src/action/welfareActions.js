/**
 * 福利商城专用action
 */

import * as actionTypes from './actionTypes';
import * as requestApi from '../config/requestApi';

/**
 * 福利商城 获取订单详情
 */
export function qureyWMOrderDetail(params = { orderId: '', userId: '' }, callback = () => { }, errorCallBack = () => { }) {
  return (dispatch, getState) => {
    requestApi.qureyWMOrderDetail(params).then((data) => {
      dispatch({ type: actionTypes.ORDER_DETAILSD_DATA, data });
      callback(data);
    }).catch((error) => {
      errorCallBack(error);
    });
  };
}
// 福利首页banner
export function getWMBannerList(params = {}, callback = () => {}, errorCallBack = () => { }) { // ???????
  return (dispatch, getState) => {
    console.log(getState());
    // 获取已存的数据
    requestApi.requestSOMBannerList({
      regionCode: global.regionCode,
      bannerModule: 'MERCHANT_WELFARE',
    }).then((data) => {
      bannerLists = data || [];
      dispatch({ type: actionTypes.WMBANNERLIST, data: bannerLists });
    }).catch((err) => {
      errorCallBack(err);
    });
  };
}
// 推荐商品 列表
export function cacheWMData(params = { page: 1, limit: 10, jCondition: { districtCode: '' } }, errorCallBack = () => { }) {
  return (dispatch, getState) => {
    console.log('getState()', getState());
    // 获取已存的数据
    const prevGoodsList = getState().welfareReducer.recommendGoodsList.goodLists || [];
    const prevBannerList = getState().welfareReducer.bannerList_wm || [];
    if (prevBannerList.length === 0 || prevGoodsList.length === 0) {
      Loading.show();
    }
    // 获取bannerList
    requestApi.requestSOMBannerList({
      regionCode: global.regionCode,
      bannerModule: 'MERCHANT_WELFARE',
    }).then((data) => {
      console.log('bannerlist', data);
      return bannerList = data || [];
    }).then((bannerList) => {
      getGoodsRecommendGoods(params, getState, dispatch, bannerList, errorCallBack);
    }).catch((err) => {
      getGoodsRecommendGoods(params, getState, dispatch, [], errorCallBack);
      Toast.show(err.message);
    });
  };
}
const getGoodsRecommendGoods = (params = { page: 1, limit: 10, jCondition: { districtCode: '' } }, getState = () => {}, dispatch = () => {}, bannerList = [], errorCallBack = () => {}) => {
  const cacheData = {
    bannerList: [],
    recommendGoodsList: {
      goodLists: [],
      page: 1,
      limit: 10,
      refreshing: false,
      hasMore: false,
      total: 0,
    },
  };
  const prevGoodsList = getState().welfareReducer.recommendGoodsList.goodLists;
  const total = getState().welfareReducer.recommendGoodsList.total;

  // 获取推荐数据
  requestApi.getGoodsRecommendGoods(params).then((data) => {
    console.log('redxxx', data);
    let _data;
    if (params.page === 1) {
      _data = data ? data.data : [];
    } else {
      _data = data ? [...prevGoodsList, ...data.data] : prevGoodsList;
    }
    const _total = params.page === 1
      ? (data)
        ? data.total
        : 0
      : total;
    const hasMore = data ? _total !== _data.length : false;
    cacheData.recommendGoodsList = {
      goodLists: _data,
      page: params.page,
      limit: params.limit,
      refreshing: false,
      hasMore,
      total: _total,
    };
    cacheData.bannerList = bannerList;
    console.log('cacheData', cacheData);
    dispatch({ type: actionTypes.WMCACHEDATA, cacheData });
  }).catch((err) => {
    Toast.show(err.message);
    // cacheData.bannerList = bannerList;
    // dispatch({ type: actionTypes.WMCACHEDATA, cacheData });
    // errorCallBack(err)
  });
};
// 获取所有人最新揭晓数据
export function getWMAllLateyPrizeList(params = { page: 1, limit: 10, jCondition: {} }, callback = () => {}, errorCallBack = () => { }) {
  return (dispatch, getState) => {
    console.log(getState());
    // 获取已存的数据
    const prevGoodsList = getState().welfareReducer.latelyPrizeList.goodLists;
    const total = getState().welfareReducer.latelyPrizeList.total;
    requestApi.bestNewJGoodsQPage(params).then((data) => {
      console.log('redxxx', data);
      let _data;
      if (params.page === 1) {
        _data = data ? data.data : [];
      } else {
        _data = data ? [...prevGoodsList, ...data.data] : prevGoodsList;
      }
      // let _total = page === 1 ? data.total : total;
      const _total = params.page === 1
        ? (data)
          ? data.total
          : 0
        : total;
      const hasMore = data ? _total !== _data.length : false;
      const latelyPrizeList = {
        goodLists: _data,
        page: params.page,
        limit: params.limit,
        refreshing: false,
        hasMore,
        total: _total,
      };
      dispatch({ type: actionTypes.WMALLLATEYPRIZE_LIST, latelyPrizeList });
      callback(data);
    }).catch((err) => {
      errorCallBack(err);
    });
  };
}
// 我的大奖列表
export function getWMMyPrizeList(params = {
 page: 1, limit: 10, awardUsage: 'expense', status: 1 
}) {
  return (dispatch, getState) => {
    const prevData = (params.status === 1) ? getState().welfareReducer.WMMyPrizeList[0].data : getState().welfareReducer.WMMyPrizeList[1].data;
    const prevListData = getState().welfareReducer.WMMyPrizeList;
    if (prevData.length === 0) {
      Loading.show();
    }
    requestApi.jfMallOrderSysQPage({
      page: params.page,
      limit: params.limit,
      awardUsage: params.awardUsage, // 平台大奖
      status: params.status,
    }).then((data) => {
      console.log('我的大奖列表', data);
      let _data;
      if (params.page === 1) {
        _data = data ? data.data : [];
      } else {
        _data = data ? [...prevData, ...data.data] : prevData;
      }
      const _total = params.page === 1
        ? (data)
          ? data.total
          : 0
        : prevData.total;
      const hasMore = data ? _total !== _data.length : false;
      prevListData[params.status === 1 ? 0 : 1] = {
        data: _data,
        page: params.page,
        limit: params.limit,
        refreshing: false,
        hasMore,
      };
      Loading.hide();
      dispatch({ type: actionTypes.GETWNMYPRIZELIST, listData: prevListData });
    }).catch((err) => {
      console.log(err);
      Loading.hide();
    });
  };
}

// 设置消费商品详情webView的重载状态
export function setWMXFWebViewReload(params = { needReLoad: false }) {
  return (dispatch, getState) => {
    dispatch({ type: actionTypes.WMXFWEBVIEWRELOAD, params });
  };
}
