/**
 * 商圈订单管理
 */
import { ORDER_STATUS_ONLINE, RIDER_ORDER_STATUS } from '../../const/order';
import * as orderService from '../../services/order';
import * as requestApi from '../../config/requestApi';
import modelInitState from '../../config/modelInitState';
import Pagination from '../../services/pagination';
import listEffects from './list';

export default {
  namespace: 'order',
  state: {
    ...modelInitState.order,
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
    ...listEffects,
    /** 获取物流订单详情 */
    * fetchOBMBcleOrderDetails({ payload }, { call, put, select }) {
      const {
        isShouhou = false, isNosure = false, orderId = '', orderNo = '',
      } = payload || {};
      let res = null;
      try {
        Loading.show();
        if (isShouhou) {
          res = yield call(requestApi.fetchOBMBcleRefundOrderDetail, { orderId });
        } else {
          res = yield call(requestApi.fetchOBMBcleOrderMuserAppDetail, { orderId });
        }
        if (res) {
          const orderDetail = orderService.filterOrderDetails(res, isShouhou, isNosure, orderNo);
          console.log('orderDetail',orderDetail)

          /** <<< Start 外卖/在线购物类相关逻辑 >>>> */
          // 获取物流相关信息
          if (isShouhou === false && isNosure === true) {
            try {
              orderDetail.chooseKightData = yield call(requestApi.fetchmerchantDetailByRiderOrderNo, { orderNo }); // 分配物流详情
              orderDetail.merchantOrderDetail = yield call(requestApi.fetchMerchantOrderDetail, { goodsOrderNo: orderId }); // 商品订单详情
              // 没有物流详情信息，且两者（分配物流详情/商品订单详情）物流订单号不一致，则允许编辑物流信息
              orderDetail.editorble = !orderDetail.chooseKightData || orderDetail.chooseKightData.orderNo !== orderDetail.merchantOrderDetail.orderNo;
            } catch (error) {
              console.log(error);
            }
          }
          // 进行中的订单，需要过滤物流状态
          const centreStatusList = [ORDER_STATUS_ONLINE.CONSUMPTION_CENTRE, ORDER_STATUS_ONLINE.PROCESS_CENTRE];
          if (isNosure === false && centreStatusList.indexOf(orderDetail.orderStatus) !== -1 && res.logistics) {
            try {
              orderDetail.chooseKightData = yield call(requestApi.fetchMerchantOrderDetail, { goodsOrderNo: orderId });
            } catch (error) {}
          }
          if (orderDetail.chooseKightData && orderDetail.chooseKightData.orderStatus === RIDER_ORDER_STATUS.WAIT_RIDER) {
            orderDetail.chooseKightData.endAt = Date.now() / 1000 + orderDetail.chooseKightData.endAt;
          }
          /** <<< End 外卖/在线购物类相关逻辑 >>>> */
          yield put({
            type: 'save',
            payload: {
              orderDetail,
              orderDetailParams: {
                isShouhou, isNosure, orderId, orderNo,
              },
            },
          });
        } else {
          Toast.show('订单数据获取失败');
          Loading.hide();
        }
      } catch (err) {
        console.log(err);
        Loading.hide();
      }
    },
    //  //选择/取消选择订单
    //  *setAllData({ payload }, { call, put, select }) {
    //     yield put({type:'save',payload:{
    //         orderList: data,
    //         selectedAll: false,
    //         selectedOrder: []
    //     }})
    // },
    // //选择/取消选择订单
    // *toggleOrderSelecte({ payload }, { call, put, select }) {
    //     let { orderList, selectedAll, selectedOrder } = yield select(state=>state.order);
    //     data.selected ? selectedOrder = selectedOrder.filter((item) => item.id != data.id) : selectedOrder.push(data)//是删除还是新增
    //     orderList[data.index].selected ? orderList[data.index].selected = false : orderList[data.index].selected = true
    //     yield put({type:'save',payload:{
    //         orderList,
    //         selectedAll: orderList.length == selectedOrder.length ? true : false,
    //         selectedOrder
    //     }})
    // },
    // //选择全部订单
    // *selectAllOrder({ payload }, { call, put, select }) {
    //     let { orderList, selectedAll} = yield select(state=>state.order);
    //     for (let i = 0; i < orderList.length; i++) {
    //         orderList[i].selected = !selectedAll
    //     }
    //     yield put({type:'save',payload:{
    //         orderList,
    //         selectedAll: !selectedAll,
    //         selectedOrder: orderList
    //     }})
    // },
    // 店铺订单搜索
    * fetchBcleDetailByOrderIdAndMerchantId({ payload }, { call, put, select }) {
      try {
        const res = yield call(requestApi.fetchBcleDetailByOrderIdAndMerchantId, { orderId: payload.searchword });
        yield put({ type: 'save', payload: { shopOrderSearchResult: res } });
        if (!res) {
          Toast.show('订单数据不存在');
        }
      } catch (error) {
        console.log(error);
        Toast.show('订单数据搜索失败');
      }
    },
    // 清空店铺订单搜索结果
    * clearShopOrderSearchResult({ payload }, { call, put, select }) {
      yield put({ type: 'save', payload: { shopOrderSearchResult: {} } });
    },
    /** 获取订单的物流数据 */
    * setKightToUpdateChooseKightData({ payload }, { call, put, select }) {
      try {
        const oldOrderDetail = (yield select(state => state.order)).orderDetail;
        const chooseKightData = yield call(requestApi.fetchMerchantOrderDetail, { goodsOrderNo: oldOrderDetail.orderId });

        if (chooseKightData && chooseKightData.orderStatus === RIDER_ORDER_STATUS.WAIT_RIDER) {
          chooseKightData.endAt = Date.now() / 1000 + chooseKightData.endAt;
          console.log(chooseKightData.endAt, Date.now() / 1000, chooseKightData.endAt - Date.now() / 1000);
        }
        const orderDetail = (yield select(state => state.order)).orderDetail;
        orderDetail.chooseKightData = chooseKightData;
        orderDetail.hasWuliu = !!chooseKightData;
        console.log('chooseKightData', chooseKightData);
        yield put({ type: 'save', payload: { orderDetail: { ...orderDetail } } });
      } catch (error) {}
    },
    /** 更改订单详情数据，页面管控 */
    * changeOBMBcleOrderDetail({ payload = {} }, { call, put, select }) {
      const oldOrderDetail = (yield select(state => state.order)).orderDetail;
      yield put({ type: 'save', payload: { orderDetail: { ...oldOrderDetail, ...payload } } });
    },
    // /物流订单列表
    * fetchmerchantOrderQPage({ payload = {} }, { call, put, select }) {
      const store = {
        refreshing: false,
        loading: false,
        hasMore: true,
        isFirstLoad: true,
      };
      store.refreshing = true;
      const wuliuOrderParams = (yield select(state => state.order)).wuliuOrderParams || {};
      const queryParam = { ...wuliuOrderParams, ...payload.params };
      yield put({ type: 'save', payload: { wuliuOrderParams: queryParam, wuliuOrderStore: { ...store } } });
      try {
        const res = yield call(requestApi.fetchmerchantOrderQPage, queryParam);
        console.log(res);
        if (res && res.data) {
          const wuliuOrderList = (yield select(state => state.order)).wuliuOrderList || [];
          if (res.data.length < 10) {
            store.hasMore = false;
          } else {
            store.hasMore = true;
          }
          store.refreshing = false;
          store.loading = false;
          if (queryParam.page === 1) {
            yield put({ type: 'save', payload: { wuliuOrderList: res.data, wuliuOrderStore: store } });
          } else {
            yield put({ type: 'save', payload: { wuliuOrderList: wuliuOrderList.concat(res.data), wuliuOrderStore: store } });
          }
        } else {
          store.hasMore = false;
          store.refreshing = false;
          store.loading = false;
          if (queryParam.page === 1) {
            yield put({ type: 'save', payload: { wuliuOrderList: [], wuliuOrderStore: store } });
          } else {
            yield put({ type: 'save', payload: { wuliuOrderStore: store } });
          }
        }
      } catch (err) {
        console.log(err);
      }
    },
    /** 订单物流查询 */
    * logisticsQuery({ payload: orderId }, { put, call, select }) {
      let logistics = { ...modelInitState.order.logistics, orderId };
      try {
        const res = yield call(requestApi.fetchlogisticsQuery, {
          orderId,
          orderType: 'NORMAL',
          xkModule: 'shop',
          logisticsType: 'MUSER',
        });
        if (res) logistics = res;
      } catch (error) {}
      yield put({ type: 'save', payload: { logistics } });
    },
    /** 更新物流选择页面数据 */
    * changeLogistics({ payload: params }, { put, call, select }) {
      const logistics = yield select(state => state.order.logistics);
      yield put({ type: 'save', payload: { logistics: { ...logistics, ...params } } });
    },
    /** 获取骑士列表 */
    * fetchRiderPickList({
      payload: {
        page, limit, type = 'my', isFirstLoad = false, sortParams = '', sortValue = true,
      },
    }, { select, put, call }) {
      const pagination = new Pagination().StartFetch(page, limit, isFirstLoad);
      const riderPickList = yield select(state => state.order.riderPickList);
      const oldList = riderPickList[type].list || [];
      const { id: shopId } = yield select(state => state.user.userShop) || {};
      /** 开始请求数据 */
      riderPickList[type] = { pagination: { ...pagination, sortParams, sortValue }, list: oldList };
      yield put({ type: 'save', payload: { riderPickList: { ...riderPickList } } });
      /** 正在请求数据 */
      try {
        Loading.show();
        const apiRequestFunc = type === 'my' ? requestApi.fetchMerchantRiderQList : requestApi.fetchMerchantNearbyRiderQList;
        const params = {};
        if (sortParams) params[sortParams] = sortValue ? 1 : 0;
        const res = yield call(apiRequestFunc, {
          page, limit, shopId, ...params,
        });
        if (res) {
          /** 结束请求数据 */
          pagination.EndFetch(res.total);
          const data = res.data || [];
          const list = page === 1 ? data : oldList.concat(data);
          riderPickList[type] = { pagination: { ...pagination, sortParams, sortValue }, list };
          yield put({ type: 'save', payload: { riderPickList: { ...riderPickList } } });
          return;
        }
      } catch (error) {
        Loading.hide();
      }
      /** 请求数据失败 */
      pagination.ErrorFetch();
      const list = page === 1 ? [] : oldList;
      riderPickList[type] = { pagination: { ...pagination, sortParams, sortValue }, list };
      yield put({ type: 'save', payload: { riderPickList: { ...riderPickList } } });
      Loading.hide();
    },
    /** 搜索骑士 */
    * searchRiderList({ payload: { page, limit, riderName = '' } }, { select, put, call }) {
      const pagination = new Pagination().StartFetch(page, limit);
      let searchRiderList = yield select(state => state.order.searchRiderList);
      const oldList = searchRiderList.list || [];
      const { id: shopId } = yield select(state => state.user.userShop) || {};
      /** 开始请求数据 */
      searchRiderList = { pagination: { ...pagination, riderName }, list: oldList };
      yield put({ type: 'save', payload: { searchRiderList: { ...searchRiderList } } });
      /** 正在请求数据 */
      try {
        Loading.show();
        const res = yield call(requestApi.fetchMerchantRiderQList, {
          page, limit, shopId, riderName,
        });
        if (res) {
          /** 结束请求数据 */
          pagination.EndFetch(res.total);
          const data = res.data || [];
          const list = page === 1 ? data : oldList.concat(data);
          searchRiderList = { pagination: { ...pagination, riderName }, list };
          yield put({ type: 'save', payload: { searchRiderList: { ...searchRiderList } } });
          return;
        }
      } catch (error) {}
      /** 请求数据失败 */
      pagination.ErrorFetch();
      const list = page === 1 ? [] : oldList;
      searchRiderList = { pagination: { ...pagination, riderName }, list };
      yield put({ type: 'save', payload: { searchRiderList: { ...searchRiderList } } });
      Loading.hide();
    },
    /** 取消订单 */
    * cancelOrder({ payload: { cause } }, { put, call, select }) {
      const orderDetail = yield select(state => state.order.orderDetail);
      const { orderId, shopId } = orderDetail || {};
      try {
        const res = yield call(requestApi.fetchMUserCancelOrder, { orderId, shopId, cause });
        if (res) {
          // 取消订单成功后，回退到上一个页面
          yield put({type:'fetchOBMBcleOrderDetails',payload:{orderId}})
          yield put({ type: 'system/back' });
        }
      } catch (error) {
        console.log(error);
      }
    },
  },
};
