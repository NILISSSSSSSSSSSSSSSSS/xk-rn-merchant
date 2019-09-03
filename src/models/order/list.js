import * as requestApi from '../../config/requestApi';
import Pagination from '../../services/pagination';

export default {
  * fetchOrderList({
    payload: {
      page = 1, limit = 10, shopId = '', orderStatus = '', type = 'ONLINE', isFirstLoad = false,
    },
  }, { call, put, select }) {
    /** 准备请求参数 */
    const params = {
      limit, page, shopId, orderStatus, type,
    };
    const isShouhou = orderStatus === 'SHOUHOU';
    const fetchListFunc = isShouhou ? requestApi.fetchbcleOBMRefundOrderAppQPage : requestApi.fetchbcleOBMOrderAppQPage;

    /** 更新状态 */
    try {
      const orderList = yield select(state => state.order.orderList);
      const sameOrderStatus = orderList.params && orderList.params.orderStatus === orderStatus && orderList.params.type === type;
      const oldList = sameOrderStatus ? orderList.list : [];
      const currentPage = sameOrderStatus ? page : 1;
      const pagination = new Pagination().StartFetch(currentPage, limit, isFirstLoad);
      /** 开始请求数据 */
      try {
        yield put({
          type: 'readOrderTabs',
          payload: { old: orderList.params, now: params },
        });
        yield put({
          type: 'save',
          payload: {
            orderList: {
              pagination: { ...pagination },
              list: oldList,
              params,
            },
          },
        });

        const res = yield call(fetchListFunc, { ...params, page: currentPage });
        const { data = [], total = 0 } = res || {};
        /** 数据请求成功 */
        pagination.EndFetch(total);
        const list = page === 1 ? data : oldList.concat(data);
        yield put({
          type: 'save',
          payload: {
            orderList: {
              pagination: { ...pagination },
              list,
              params,
            },
          },
        });
        return;
      } catch (error) {
        Loading.hide();
      }

      /** 请求异常 */
      pagination.ErrorFetch();
      yield put({
        type: 'save',
        payload: {
          orderList: {
            pagination: { ...pagination },
            list: oldList,
            params,
          },
        },
      });
    } catch (error) {
      console.log(error);
    }
  },
  * readOrderTabs({ payload: { old, now } }, { put }) {
    const modules = [];
    if (old.type === 'ONLINE' && old.orderStatus) {
      modules.push(`orderlist.tabs.${old.orderStatus}`);
    }
    if (now.type === 'ONLINE' ** now.orderStatus) {
      modules.push(`orderlist.tabs.${now.orderStatus}`);
    }
    if (modules.length > 0) {
      yield put({ type: 'application/changeMessageModules', payload: { modules, flag: false } });
    }
  },
};
