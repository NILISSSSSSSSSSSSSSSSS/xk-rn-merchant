/**
 * 订单相关reducer
 */

import * as actionTypes from '../action/actionTypes';

const initialState = {
    selectedAll: false,//是否选择全部订单
    selectedOrder: [],//选中的所有订单
    orderList: [[], [], [], [], [], []],
    shopOrderSearchResult: {},
    orderDetail: {
        orderStatus: 4,   // 订单状态
        confirmSettlement: false,
        sweepVisible: false,
        pickupWayVisible: false,
        timedate: '',
        endtime: '',
        isSelfLifting: '',
        freight: '',
        ischangefreight: false,
        hasWuliu: false,    //是否已经录入物流
        orderId: '',
        address: '',
        phone: '',
        createdAt: '',
        totalMoney: '',
        data: [],
        remark: '',
        isOrigiPrice: true,
        youhuiPrice: '',
        reson: '',
        discountMoney: 0,
        discountName: 0,
        isAll: 0,
        money: 0,
        resmoney: 0,
        price: 0,
        pPrice: 0,
        pPayPirce: 0,
        chooseKightData: null,
        getSomeData: {
            voucher: 0,
            shopVoucher: 0,
        },
        isUpLimit: false,
        editorble: false,
    },
    /** 物流选择页面数据 */
    logisticsInfo: {

    },
    /** 最近一次派单数据 */
    lastLogistics: {

    }
};

export default (state = initialState, action) => {
    switch (action.type) {
        case actionTypes.TOGGLE_ORDER_SELECTE:
            return {
                ...state,
                ...action.data
            }
        case actionTypes.SAVE_ORDER_REDUCER:
            return {
                ...state,
                ...action.payload
            }
        default:
            return state
    }
};
