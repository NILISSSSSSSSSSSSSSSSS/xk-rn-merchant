import moment from 'moment'
import * as actionTypes from './actionTypes';
import * as orderRequestApi from '../config/Apis/order';
import { ORDER_STATUS_ONLINE, RIDER_ORDER_STATUS } from '../const/order';

//订单
//选择/取消选择订单
export function setAllData(data) {
    return (dispatch, getState) => {
        dispatch({
            type: actionTypes.TOGGLE_ORDER_SELECTE,
            data: {
                orderList: data,
                selectedAll: false,
                selectedOrder: []
            }
        });
    };
};
//选择/取消选择订单
export function toggleOrderSelecte(data) {
    return (dispatch, getState) => {
        let { orderList, selectedAll, selectedOrder } = getState().orderReducer;
        data.selected ? selectedOrder = selectedOrder.filter((item) => item.id != data.id) : selectedOrder.push(data)//是删除还是新增
        orderList[data.index].selected ? orderList[data.index].selected = false : orderList[data.index].selected = true
        dispatch({
            type: actionTypes.TOGGLE_ORDER_SELECTE,
            data: {
                orderList,
                selectedAll: orderList.length == selectedOrder.length ? true : false,
                selectedOrder
            }
        });
    };
};
//选择全部订单
export function selectAllOrder(data) {
    return (dispatch, getState) => {
        let { orderList, selectedAll } = getState().orderReducer;
        for (let i = 0; i < orderList.length; i++) {
            orderList[i].selected = !selectedAll
        }
        dispatch({
            type: actionTypes.TOGGLE_ORDER_SELECTE,
            data: {
                orderList,
                selectedAll: !selectedAll,
                selectedOrder: orderList
            }
        });
    };
};

// 店铺订单搜索
export function fetchBcleDetailByOrderIdAndMerchantId(orderId) {
    return async (dispatch, getState) => {
        try{
            let res = await orderRequestApi.fetchBcleDetailByOrderIdAndMerchantId({ orderId });
            dispatch({ type: actionTypes.SAVE_ORDER_REDUCER, payload: { shopOrderSearchResult: res }})
            if(!res) {
                Toast.show('订单数据不存在')
            }
        } catch(error) {
            Toast.show('订单数据搜索失败')
        }
    }
}

// 清空店铺订单搜索结果
export function clearShopOrderSearchResult() {
    return (dispatch, getState) => {
        dispatch({ type: actionTypes.SAVE_ORDER_REDUCER, payload: { shopOrderSearchResult: {} }})
    }
}


/**
 * 外卖订单详情
 * @param {string} orderId 订单Id
 * @param {string} orderNo 商品订单编号
 * @param {boolean} isShouhou 是否售后订单
 * @param {boolean} isNosure 是否物流订单
 */
export function fetchOBMBcleOrderDetails(orderId, orderNo = "", isShouhou = false, isNosure = false,callback=()=>{}) {
    return (dispatch, getState) => {
        app._store.fetchOBMBcleOrderDetails({ orderId, orderNo, isShouhou, isNosure });
    }
}

export function setKightToUpdateChooseKightData() {
    return async (dispatch, getState) => {
        try{
            let oldOrderDetail = getState().orderReducer.orderDetail;
            let chooseKightData = await orderRequestApi.fetchMerchantOrderDetail({ goodsOrderNo: oldOrderDetail.orderId });

            if(chooseKightData && chooseKightData.orderStatus === RIDER_ORDER_STATUS.WAIT_RIDER) {
                chooseKightData.endAt = Date.now()/1000 + chooseKightData.endAt;
                console.log(chooseKightData.endAt, Date.now()/1000, chooseKightData.endAt - Date.now()/1000);
            }
            let orderDetail = getState().orderReducer.orderDetail;
            orderDetail.chooseKightData = chooseKightData;
            orderDetail.hasWuliu = !!chooseKightData;
            console.log("chooseKightData", chooseKightData)
            dispatch({ type: actionTypes.SAVE_ORDER_REDUCER, payload: { orderDetail: {...orderDetail} }})
        } catch(error) {

        }
    }
}

export function changeOBMBcleOrderDetail(newOrderDetail) {
    return async (dispatch, getState) => {
        let oldOrderDetail = getState().orderReducer.orderDetail;
        dispatch({ type: actionTypes.SAVE_ORDER_REDUCER, payload: { orderDetail: { ...oldOrderDetail, ...newOrderDetail } }})
    }
}

/**
 * 物流订单列表
 * @param {object} params
 */
export function fetchmerchantOrderQPage(params) {
    return async (dispatch, getState) => {
        let store = {
            refreshing: false,
            loading: false,
            hasMore: true,
            isFirstLoad: true
        };
        store.refreshing = true
        let wuliuOrderParams = getState().orderReducer.wuliuOrderParams || {};
        let queryParam = {...wuliuOrderParams, ...params };
        dispatch({ type: actionTypes.SAVE_ORDER_REDUCER, payload: { wuliuOrderParams: queryParam, wuliuOrderStore: {...store} }})
        let res = await orderRequestApi.fetchmerchantOrderQPage(queryParam);
        console.log(res);
        if(res && res.data){
            let wuliuOrderList = getState().orderReducer.wuliuOrderList || [];
            if(res.data.length < 10){
                store.hasMore = false
            }else{
                store.hasMore = true
            }
            store.refreshing = false
            store.loading = false
            if(queryParam.page === 1){
                dispatch({ type: actionTypes.SAVE_ORDER_REDUCER, payload: { wuliuOrderList: res.data ,wuliuOrderStore: store}})
            }else{
                dispatch({ type: actionTypes.SAVE_ORDER_REDUCER, payload: { wuliuOrderList: wuliuOrderList.concat(res.data) ,wuliuOrderStore: store}})
            }
        } else {
            store.hasMore = false
            store.refreshing = false
            store.loading = false
            if(queryParam.page === 1){
                dispatch({ type: actionTypes.SAVE_ORDER_REDUCER, payload: { wuliuOrderList: [],wuliuOrderStore: store}})
            }else{
                dispatch({ type: actionTypes.SAVE_ORDER_REDUCER, payload: { wuliuOrderStore: store}})
            }
        }
    }
}
