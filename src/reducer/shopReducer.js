/**
 * 店铺reducer
 */

import * as actionTypes from "../action/actionTypes";
let initialState = {
    storeManagePage: "manager", //'lower','manager'店铺信息页是下级店铺的信息还是管理员店铺的信息
    serviceCatalogList: [], //四大服务分类列表
    longLists: {},
    goodsList: [],
    initList: {
        refreshing: false,
        loading: false,
        listsPage: 1,
        listsTotal: 0,
        hasMore: false,
        lists: [],
        isFirstLoad: true,
    },
    goodsDetail: {},
    juniorShops: [], //下级店铺列表
    roleList: [],
    roleManagerShopList: [],
    bannerLists: []
};
export default (state = initialState, action) => {
    const witchList = action.data && action.data.witchList || 'none'
    switch (action.type) {
        case actionTypes.SHOP_CHANGE_STATE:
            return {
                ...state,
                ...action.data
            };
        case actionTypes.List_FIRSTLOAD: //第一次加载
            return {
                ...state,
                ...action.data,
                longLists: {
                    ...state.longLists,
                    [witchList]: {
                        ...state.initList,
                        lists: state.longLists[witchList] && state.longLists[witchList].lists || []
                    }
                }
            };
        case actionTypes.LIST_LOADMORE: //加载更多
            return {
                ...state,
                longLists: {
                    ...state.longLists,
                    [witchList]: {
                        ...state.longLists[witchList],
                        listsPage: state.longLists[witchList].listsPage + 1,
                        loading: true
                    }
                }
            };
        case actionTypes.LIST_NO_LOADMORE: //刷新清空
            return {
                ...state,
                longLists: {
                    ...state.longLists,
                    [witchList]: {
                        ...state.longLists[witchList],
                        refreshing: action.data.refreshing,
                        isFirstLoad:true,
                        listsPage: 1,
                        listsTotal: 0
                    }
                }
            };
        case actionTypes.LIST_FETCH_LOADINGMORE_SUCCESS: //加载更多请求成功
            return {
                ...state,
                longLists: {
                    ...state.longLists,
                    [witchList]: {
                        ...state.longLists[witchList],
                        isFirstLoad: false,
                        ...action.data
                    }
                }

            };
        case actionTypes.LIST_FETCH_NO_LOADINGMORE_SUCCESS: //不加载更多请求成功
            return {
                ...state,
                longLists: {
                    ...state.longLists,
                    [witchList]: {
                        ...state.longLists[witchList],
                        isFirstLoad: false,
                        ...action.data
                    }
                }
            };
        case actionTypes.LIST_FETCH_LOADINGMORE_FAILD: //加载更多请求失败
            return {
                ...state,
                longLists: {
                    ...state.longLists,
                    [witchList]: {
                        ...state.longLists[witchList],
                        isFirstLoad: false,
                        loading: false,
                        listsPage: state.longLists[witchList].listsPage - 1
                    }
                }
            };
        case actionTypes.LIST_FETCH_No_LOADINGMORE_FAILD: //加载更多请求失败
            return {
                ...state,
                longLists: {
                    ...state.longLists,
                    [witchList]: {
                        ...state.longLists[witchList],
                        isFirstLoad: false,
                        refreshing: false
                    }
                }
            };

        case actionTypes.FETCH_SETPAYPWDSTATUS: //是否设置支付密码
            return {
                ...state,
                setPayPwdStatus: action.data
            };
        case actionTypes.FETCH_SHOP_ROLELIST: // 获取权限列表
            return {
                ...state,
                roleList: action.data
            };
        case actionTypes.FETCH_SHOP_CHILDREDLIST: // 获取授权管理直属下级店铺
            return {
                ...state,
                roleManagerShopList: action.data
            };

        default:
            return state;
    }
};
