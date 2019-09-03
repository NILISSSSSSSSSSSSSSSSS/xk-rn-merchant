/**
 * mallActions
 * @params getState() 读取redux的store
 */

import * as actionTypes from "./actionTypes";
import * as requestApi from "../config/requestApi";

// 请求商品分类列表
export function fetchGoodsCategoryLists(data) {
    return (dispatch, getState) => {
        dispatch({ type: actionTypes.FETCH_GOODSCATEGORYLISTS, data });
    };
}

// 更改商品分类列表的选中状态
export function changeGoodsCategoryList(params) {
    return (dispatch, getState) => {
        let data = getState().mallReducer.goodsCategoryLists;
        for (let i = 0; i < data.length; i++) {
            data[i].selected_status = false;
            if (params.code === data[i].code) {
                data[i].selected_status = true;
            }
        }
        dispatch({ type: actionTypes.CHANGE_GOODSCATEGORYLIST, data });
    };
}

// 私人分类列表修改
export function changePreCategoryList(data) {
    return (dispatch, getState) => {
        dispatch({ type: actionTypes.CHANGE_PRECATEGORYLIST, data });
    };
}

/**
 * 根据商品类目查询
 * @param {*} params 参数
 * @param {*} isFirst 是否第一次加载
 * @param {*} isLoadingMore 是否加载更多
 * @param {*} type 搜索结果还是商品一级列表或者二级列表
 */
export function fetchGoodsLists(
    params,
    isFirst = false,
    isLoadingMore = false,
    type = null
) {
    return (dispatch, getState) => {
        if (isFirst) {
            type === "search"
                ? dispatch({ type: actionTypes.FETCH_RESULTLISTS_RESET })
                : type === "children"
                    ? dispatch({ type: actionTypes.FETCH_GOODSCLDLISTS_RESET })
                    : dispatch({ type: actionTypes.FETCH_GOODSLISTS_RESET });
        } else {
            if (isLoadingMore) {
                type === "search"
                    ? dispatch({
                        type: actionTypes.FETCH_RESULTLISTS_MORE_BEFORE
                    })
                    : type === "children"
                        ? dispatch({
                            type: actionTypes.FETCH_GOODSCLDLISTS_MORE_BEFORE
                        })
                        : dispatch({
                            type: actionTypes.FETCH_GOODSLISTS_MORE_BEFORE
                        });
            } else {
                type === "search"
                    ? dispatch({ type: actionTypes.FETCH_RESULTLISTS_BEFORE })
                    : type === "children"
                        ? dispatch({ type: actionTypes.FETCH_GOODSCLDLISTS_BEFORE })
                        : dispatch({ type: actionTypes.FETCH_GOODSLISTS_BEFORE });
            }
        }

        params = {
            ...params,
            page:
                type === "search"
                    ? getState().mallReducer.resultListsPage
                    : type === "children"
                        ? getState().mallReducer.goodsCldListsPage
                        : getState().mallReducer.goodsListsPage
        };
        requestApi.requestSearchGoodsList(params).then(data => {
            console.log('datadata', data)
            if (isLoadingMore) {
                type === "search"
                    ? dispatch({
                        type: actionTypes.FETCH_RESULTLISTS_MORE,
                        data
                    })
                    : type === "children"
                        ? dispatch({
                            type: actionTypes.FETCH_GOODSCLDLISTS_MORE,
                            data
                        })
                        : dispatch({
                            type: actionTypes.FETCH_GOODSLISTS_MORE,
                            data
                        });
            } else {
                type === "search"
                    ? dispatch({
                        type: actionTypes.FETCH_RESULTLISTS,
                        data
                    })
                    : type === "children"
                        ? dispatch({
                            type: actionTypes.FETCH_GOODSCLDLISTS,
                            data
                        })
                        : dispatch({
                            type: actionTypes.FETCH_GOODSLISTS,
                            data
                        });
            }
        }).catch(error => {
            if (isLoadingMore) {
                type === "search"
                    ? dispatch({
                        type: actionTypes.FETCH_RESULTLISTS_MORE_FAILED
                    })
                    : type === "children"
                        ? dispatch({
                            type: actionTypes.FETCH_GOODSCLDLISTS_MORE_FAILED,
                            data
                        })
                        : dispatch({
                            type: actionTypes.FETCH_GOODSLISTS_MORE_FAILED
                        });
            } else {
                type === "search"
                    ? dispatch({
                        type: actionTypes.FETCH_RESULTLISTS_FAILED
                    })
                    : type === "children"
                        ? dispatch({
                            type: actionTypes.FETCH_GOODSCLDLISTS_FAILED
                        })
                        : dispatch({
                            type: actionTypes.FETCH_GOODSLISTS_FAILED
                        });
            }
        });
    };
}

// 购物车列表
export function fetchMallCartList(params, callback = () => { }) {
    return (dispatch, getState) => {
        requestApi
            .requestMallCartList(params)
            .then(data => {
                console.log(data)
                if (data) {
                    data.data.forEach(item => {
                        // 添加是否选中状态
                        item.selected_status = false;
                    });
                    dispatch({
                        type: actionTypes.FETCH_MALLCARTLIST,
                        data: data.data
                    });
                    callback(data.data);
                } else {
                    dispatch({
                        type: actionTypes.FETCH_MALLCARTLIST,
                        data: []
                    });
                }
            })
            .catch(error => {
                //
            });
    };
}
// 更改购物车列表商品
export function changeMallCartList(item) {
    return (dispatch, getState) => {
        let data = getState().mallReducer.cartLists;
        for (let i = 0; i < data.length; i++) {
            if (item.id === data[i].id) {
                data[i] = item;
            }
        }
        dispatch({ type: actionTypes.CHANGE_MALLCARTLIST, data });
    };
}
//单纯修改一些状态
export function mallChangeState(params) {
    return (dispatch, getState) => {
        dispatch({ type: actionTypes.MALL_CHANGE_STATE, data: params });
    };
}

// 支付订单信息储存
export function payOrderInfo(params) {
    return (dispatch, getState) => {
        dispatch({ type: actionTypes.SOM_PAY_PARAMS, data: params });
    };
}
// 记录进入收银台的路由
export function recordPayRouter(params) {
    return (dispatch, getState) => {
        dispatch({ type: actionTypes.SOM_PAY_RECORDROUTER, data: params });
    };
}
// 记录SOM和WM路由key
export function recordRouterKey(params) {
    return (dispatch, getState) => {
        dispatch({ type: actionTypes.RECORDROUTER, data: params });
    };
}
// 获取批发商城 banner
export function getSOMBannerList(params={},callback=() => {},errorCallBack = () => { }) {
    return (dispatch, getState) => {
        console.log(getState())
        requestApi.requestSOMBannerList({
            regionCode: global.regionCode,
            bannerModule: "MERCHANT_SELF_SHOP"
        }).then(data => {
            console.log('initBannerData',data)
            dispatch({ type: actionTypes.WMBANNERLIST, data: bannerLists});
        }).catch(err => {
            errorCallBack(err)
            Loading.hide();
        });
    };
}
// 推荐商品 列表
export function cacheSOMData(params={page: 1,limit: 10,jCondition: {districtCode: ''}},isLoadingMore,errorCallBack = () => { }) {
    return (dispatch, getState) => {
        console.log('getState()',getState())
        // 获取已存的数据
        let prevGoodsList = getState().mallReducer.recommendGoodsList.goodLists;
        let prevBannerList = getState().mallReducer.bannerList_som;
        if (prevBannerList.length === 0 || prevGoodsList.length === 0 && !isLoadingMore) {
            Loading.show()
        }
        if (isLoadingMore) {
            getGoodsRecommendGoods(params,getState,dispatch,prevBannerList,errorCallBack)
            return
        }
        // 获取bannerList
        requestApi.requestSOMBannerList({
            regionCode: global.regionCode,
            bannerModule: "MERCHANT_SELF_SHOP"
        }).then(data => {
            console.log('bannerlist',data)
            return bannerList = data || [];
        }).then((bannerList) => {
            getGoodsRecommendGoods(params,getState,dispatch,bannerList,errorCallBack)
        }).catch((err) => {
            getGoodsRecommendGoods(params,getState,dispatch, [], errorCallBack)
        });
    };
}
const getGoodsRecommendGoods = (params = {page: 1,limit: 10,condition: {districtCode: ''}},getState = () => {},dispatch = () => {},bannerList = [],errorCallBack = () => {}) => {
    let cacheData = {
        bannerList: [],
        recommendGoodsList: {
            goodLists: [],
            page: 1,
            limit: 10,
            refreshing: false,
            hasMore: false,
            total: 0,
        }
    }
    let prevGoodsList = getState().mallReducer.recommendGoodsList.goodLists;
    let total = getState().mallReducer.recommendGoodsList.total;

    // 获取推荐数据
    requestApi.requestMallGoodsRecommendSGoodsQPage(params).then(data => {
        console.log('redxxx',data)
        let _data;
        if (params.page === 1) {
            _data = data ? data.data : [];
        } else {
            _data = data ? [...prevGoodsList, ...data.data] : prevGoodsList;
        }
        let _total = params.page === 1
            ? (data)
                ? data.total
                : 0
            : total;
        let hasMore = data ? _total !== _data.length : false;
        cacheData.recommendGoodsList = {
            goodLists: _data,
            page:params.page,
            limit: params.limit,
            refreshing: false,
            hasMore,
            total:_total,
        }
        cacheData.bannerList = bannerList;
        console.log("cacheData",cacheData)
        dispatch({ type: actionTypes.SOMCACHEDATA, cacheData });
    }).catch((err) => {
        Toast.show(err.message)
        // let prevGoodsList = getState().mallReducer.recommendGoodsList
        // let prevBannerList = getState().mallReducer.bannerList_som;
        // cacheData.bannerList = prevBannerList;
        // cacheData.recommendGoodsList = prevGoodsList;
        // dispatch({ type: actionTypes.SOMCACHEDATA, cacheData });
    });
}
// 订单列表数据
export function fetchMallOrderList (params={ orderStatus: 'PRE_PAY',limit: 10,page:1,currentTab:0 }) {
    return (dispatch, getState) => {
        let currentTab = params.currentTab
        let prevOrderList = getState().mallReducer.SOMOrderList
        requestApi.fetchMallOrderList(params).then(data => {
            console.log("%cDatadatadatadata", "color:red", data);
            let _data;
            if (params.page === 1) {
                _data = data ? data.data : [];
            } else {
                _data = data ? [...prevOrderList[currentTab].data, ...data.data] : prevOrderList[currentTab].data;
            }
            let _total = params.page === 1 ? (data ? data.total : 0) : prevOrderList[currentTab].total;
            let hasMore = data ? _total !== _data.length : false;
            let obj = {
                data: _data,
                page: params.page,
                limit: 10,
                refreshing: false,
                hasMore,
                total: _total,
            }
            prevOrderList[currentTab] = obj
            console.log('prevOrderList',prevOrderList)
            dispatch({ type: actionTypes.SOMORDERLIST, orderList: JSON.parse(JSON.stringify(prevOrderList)) })
        }).catch((err) => {
            Toast.show(err.message)
            // console.log('err',err)
            // let prevOrderList = getState().mallReducer.SOMOrderList
            // dispatch({ type: actionTypes.SOMORDERLIST, orderList: prevOrderList })
        });
    };

}
// 售后订单
export function fetchMallRefundOrderList (params={ limit: 10,page:1,currentTab: 5}) {
    return (dispatch, getState) => {
        let prevOrderList = getState().mallReducer.SOMOrderList
        let currentTab = params.currentTab
        requestApi.fetchMallRefundOrderList(params).then(data => {
            let _data;
            if (params.page === 1) {
                _data = data ? data.data : [];
            } else {
                _data = data ? [...prevOrderList[currentTab].data, ...data.data] : prevOrderList[currentTab].data;
            }
            let _total = params.page === 1 ? (data ? data.total : 0) : prevOrderList[currentTab].total;
            let hasMore = data ? _total !== _data.length : false;
            let obj = {
                data: _data,
                page: params.page,
                limit: 10,
                refreshing: false,
                hasMore,
                total: _total,
            }
            prevOrderList[currentTab] = obj
            dispatch({ type: actionTypes.SOMORDERLIST, orderList: prevOrderList })
        }).catch((err) => {
            Toast.show(err.message)
            // console.log(err)
            // let prevOrderList = getState().mallReducer.SOMOrderList
            // dispatch({ type: actionTypes.SOMORDERLIST, orderList: prevOrderList })
        });
    }
}

// 售后退款金额

export function setRefundAmount (afterSaleGoods, orderInfo) {
    return (dispatch, getState) => {
        let temp = afterSaleGoods.map(item => {
            return {
                goodsId: item.goodsId,
                goodsSkuCode: item.goodsSkuCode
            }
        })
        let params = {
            itemIds: temp,
            orderId: orderInfo.orderId
        }
        requestApi.sOrderRefundApplyAmount(params).then(res => {
            console.log('获取的售后金额',res)
            if (res) {
                dispatch({ type: actionTypes.SETREFUNDAMOUNT, refundAmount: res.amount  })
            }
        }).catch(err => {
            console.log(err)
        })
    }
}
