/**
 * mall相关reducer
 */

import * as actionTypes from "../action/actionTypes";

const initialState = {
    goodsCategoryLists: [], // 商品分类列表
    goodsCategoryLists_pre: [], // 商品私人分类列表
    refreshing: false, // 是否刷新中
    loading: false, // 是否加载中
    limit: 10,

    bannerList_som: [],
    recommendGoodsList: {
        goodLists: [],
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
    },

    goodsListsPage: 1,
    goodsListsTotal: 0,
    hasMoreGoodsLists: false, // 是否还有更多数据
    goodsLists: [], // 商品列表

    goodsCldListsPage: 1,
    goodsCldListsTotal: 0,
    hasMoreGoodsCldLists: false,
    goodsCldLists: [], // 商品二级列表

    resultListsPage: 1,
    resultListsTotal: 0,
    hasMoreResultLists: false,
    resultLists: [], // 搜索结果列表

    cartLists: [], // 购物车列表
    bannerLists: [],
    payOrderInfo: {},
    refundAmount :0,
    recordPayRouter: '',
    recordRouterKey: [],
    recommendGoodsList: {
        goodLists: [],
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
    },
    SOMOrderList:[{
        data: [],
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
    },{
        data: [],
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
    },{
        data: [],
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
    },{
        data: [],
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
    },{
        data: [],
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
    },{
        data: [],
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
    },{
        data: [],
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
    }]
};

export default (state = initialState, action) => {
    switch (action.type) {
        case actionTypes.FETCH_GOODSCATEGORYLISTS:
            return {
                ...state,
                goodsCategoryLists: action.data
            };
        case actionTypes.CHANGE_GOODSCATEGORYLIST:
            return {
                ...state,
                goodsCategoryLists: action.data
            };
        case actionTypes.CHANGE_PRECATEGORYLIST:
            return {
                ...state,
                goodsCategoryLists_pre: action.data
            };
        case actionTypes.FETCH_GOODSLISTS_RESET:
            return {
                ...state,
                refreshing: false,
                loading: false,
                goodsListsPage: 1,
                goodsListsTotal: 0,
                hasMoreGoodsLists: false,
                goodsLists: []
            };
        case actionTypes.FETCH_GOODSLISTS_BEFORE:
            return {
                ...state,
                refreshing: true,
                goodsListsPage: 1,
                goodsListsTotal: 0,
                goodsLists: []
            };
        case actionTypes.FETCH_GOODSLISTS:
            return {
                ...state,
                refreshing: false,
                goodsListsTotal: action.data ? action.data.total : 0,
                goodsLists: action.data ? action.data.data : [],
                hasMoreGoodsLists: action.data
                    ? action.data.data.length !== action.data.total
                    : false
            };
        case actionTypes.FETCH_GOODSLISTS_FAILED:
            return {
                ...state,
                refreshing: false
            };
        case actionTypes.FETCH_GOODSLISTS_MORE_BEFORE:
            return {
                ...state,
                loading: true,
                goodsListsPage: state.goodsListsPage + 1
            };
        case actionTypes.FETCH_GOODSLISTS_MORE:
            return {
                ...state,
                loading: false,
                goodsLists: action.data
                    ? [...state.goodsLists, ...action.data.data]
                    : state.goodsLists,
                hasMoreGoodsLists: action.data
                    ? action.data.data.length + state.goodsLists.length !==
                    state.goodsListsTotal
                    : false
            };
        case actionTypes.FETCH_GOODSLISTS_MORE_FAILED:
            return {
                ...state,
                loading: false,
                goodsListsPage: state.goodsListsPage - 1
            };
        case actionTypes.FETCH_GOODSCLDLISTS_RESET:
            return {
                ...state,
                refreshing: false,
                loading: false,
                goodsCldListsPage: 1,
                goodsCldListsTotal: 0,
                hasMoreGoodsCldLists: false,
                goodsCldLists: []
            };
        case actionTypes.FETCH_GOODSCLDLISTS_BEFORE:
            return {
                ...state,
                refreshing: true,
                goodsCldListsPage: 1,
                goodsCldListsTotal: 0,
                goodsCldLists: []
            };
        case actionTypes.FETCH_GOODSCLDLISTS:
            return {
                ...state,
                refreshing: false,
                goodsCldListsTotal: action.data ? action.data.total : 0,
                goodsCldLists: action.data ? action.data.data : [],
                hasMoreGoodsCldLists: action.data
                    ? action.data.data.length !== action.data.total
                    : false
            };
        case actionTypes.FETCH_GOODSCLDLISTS_FAILED:
            return {
                ...state,
                refreshing: false
            };
        case actionTypes.FETCH_GOODSCLDLISTS_MORE_BEFORE:
            return {
                ...state,
                loading: true,
                goodsCldListsPage: state.goodsCldListsPage + 1
            };
        case actionTypes.FETCH_GOODSCLDLISTS_MORE:
            return {
                ...state,
                loading: false,
                goodsCldLists: action.data
                    ? [...state.goodsCldLists, ...action.data.data]
                    : state.goodsCldLists,
                hasMoreGoodsCldLists: action.data
                    ? action.data.data.length + state.goodsCldLists.length !==
                    state.goodsCldListsTotal
                    : false
            };
        case actionTypes.FETCH_GOODSCLDLISTS_MORE_FAILED:
            return {
                ...state,
                loading: false,
                goodsCldListsPage: state.goodsCldListsPage - 1
            };
        case actionTypes.FETCH_RESULTLISTS_RESET:
            return {
                ...state,
                refreshing: false,
                loading: false,
                resultListsPage: 1,
                resultListsTotal: 0,
                hasMoreResultLists: false,
                resultLists: []
            };
        case actionTypes.FETCH_RESULTLISTS_BEFORE:
            return {
                ...state,
                refreshing: true,
                resultListsPage: 1,
                resultListsTotal: 0,
                resultLists: []
            };
        case actionTypes.FETCH_RESULTLISTS:
            return {
                ...state,
                refreshing: false,
                resultListsTotal: action.data ? action.data.total : 0,
                resultLists: action.data ? action.data.data : [],
                hasMoreResultLists: action.data
                    ? action.data.data.length !== action.data.total
                    : false
            };
        case actionTypes.FETCH_RESULTLISTS_FAILED:
            return {
                ...state,
                refreshing: false
            };
        case actionTypes.FETCH_RESULTLISTS_MORE_BEFORE:
            return {
                ...state,
                loading: true,
                resultListsPage: state.resultListsPage + 1
            };
        case actionTypes.FETCH_RESULTLISTS_MORE:
            return {
                ...state,
                loading: false,
                resultLists: action.data
                    ? [...state.resultLists, ...action.data.data]
                    : state.resultLists,
                hasMoreResultLists: action.data
                    ? action.data.data.length + state.resultLists.length !==
                    state.resultListsTotal
                    : false
            };
        case actionTypes.FETCH_RESULTLISTS_MORE_FAILED:
            return {
                ...state,
                loading: false,
                resultListsPage: state.resultListsPage - 1
            };
        case actionTypes.FETCH_MALLCARTLIST:
            return {
                ...state,
                cartLists: action.data
            };
        case actionTypes.CHANGE_MALLCARTLIST:
            return {
                ...state,
                cartLists: action.data
            };

        case actionTypes.MALL_CHANGE_STATE:
            return {
                ...state,
                ...action.data
            };
        case actionTypes.SOM_PAY_PARAMS:
            return {
                ...state,
                payOrderInfo: action.data
            };
        case actionTypes.SOM_PAY_RECORDROUTER:
            return {
                ...state,
                recordPayRouter: action.data
            };
        case actionTypes.RECORDROUTER:
            return {
                ...state,
                recordRouterKey: action.data
            };
        case actionTypes.SOMRECOMMENDGOODS_LIST:
            return {
                ...state,
                recordRouterKey: action.data
            };
        case actionTypes.SOMCACHEDATA:// 缓存首页数据
            return {
                ...state,
                bannerList_som: action.cacheData.bannerList,
                recommendGoodsList: action.cacheData.recommendGoodsList
            }
        case actionTypes.SOMORDERLIST:// 缓存订单数据
            return {
                ...state,
                SOMOrderList: JSON.parse(JSON.stringify(action.orderList)),
            }

        case actionTypes.SETREFUNDAMOUNT:// 缓存售后退款金额
            return {
                ...state,
                refundAmount: action.refundAmount,
            }
        default:
            return state;
    }
};
