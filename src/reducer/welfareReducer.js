/**
 * 福利商城
 */
/**
 * 商城reducer
 */

import * as actionTypes from '../action/actionTypes';
let initialState = {
    roleManagerShopList: [],
    orderData: {
        price: 0,
        joinCount: 0,
        maxStake: 0,
        userName: '',
        userPhone: '',
        userAddress: '',
        goodsName: '',
        showSkuName: '',
        lotteryNumbers: [],

    },
    xfViweWebReload: false,
    bannerList_wm: [],
    recommendGoodsList: {
        goodLists: [],
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
    },
    latelyPrizeList: {
        goodLists: [],
        page: 1,
        limit: 10,
        refreshing: false,
        hasMore: false,
        total: 0,
    },
    orderList: [{
        data: [],
        refreshing: false,
        page: 1,
        hasMore: true,
        total: 0,
    },{
        data: [],
        refreshing: false,
        page: 1,
        hasMore: true,
        total: 0,
    },{
        data: [],
        refreshing: false,
        page: 1,
        hasMore: true,
        total: 0,
    },{
        data: [],
        refreshing: false,
        page: 1,
        hasMore: true,
        total: 0,
    }],
    WMMyPrizeList: [
        { // 我的大奖列表未中奖
            data: [],
            refreshing: false,
            page: 1,
            hasMore: true,
            total: 0,
        },
        { // 我的大奖列表已中奖
            data: [],
            refreshing: false,
            page: 1,
            hasMore: true,
            total: 0,
        }
    ]
}
export default (state = initialState, action) => {
    switch (action.type) {
        case actionTypes.FETCH_SHOP_CHILDREDLIST:// 获取授权管理直属下级店铺
            return {
                ...state,
                roleManagerShopList: action.data
            }
        case actionTypes.ORDER_DETAILSD_DATA:// 获取福利商城订单详情数据
            return {
                ...state,
                orderData: action.data
            }
        case actionTypes.VM_CHANGE_STATE:// 修改福利商城数据
            return {
                ...state,
                ...action.data
            }
        case actionTypes.RECOMMENDGOODS_LIST:// 修改福利商城推荐商品列表数据
            return {
                ...state,
                recommendGoodsList: action.recommendGoodsList
            }
        case actionTypes.WMALLLATEYPRIZE_LIST:// 所有人的最新揭晓
            return {
                ...state,
                latelyPrizeList: action.latelyPrizeList
            }
        case actionTypes.WMCACHEDATA:// 缓存首页数据
            return {
                ...state,
                bannerList_wm: action.cacheData.bannerList,
                recommendGoodsList: action.cacheData.recommendGoodsList
            }
        case actionTypes.WMORDERLIST:// 缓存订单列表数据
            return {
                ...state,
                orderList: action.listData
            }
        case actionTypes.WMXFWEBVIEWRELOAD:
            return {
                ...state,
                xfViweWebReload: action.params.needReLoad
            }
        case actionTypes.GETWNMYPRIZELIST:
        return {
            ...state,
            WMMyPrizeList: action.listData
        }
        default:
            return state
    }
};
