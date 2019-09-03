import * as actionTypes from './actionTypes';
import * as requestApi from '../config/requestApi';


//店铺
//店铺修改
export function updateShop(params, callback = () => { }) {
    return (dispatch, getState) => {
        requestApi.updateShop(params).then(data => {
            requestApi.shopDetails({ id: params.id }).then(res => {
                callback(res)
                if (getState().userReducer.userShop.id == params.id) {
                    const user = getState().userReducer.user
                    for(let item of user.shops){
                        item.id==params.id?item={...item,...res.detail}:null
                    }
                    console.warn('12321',user)
                    // dispatch({ type: actionTypes.FETCH_LOGIN, data: user });
                    dispatch({ type: actionTypes.CHANGE_STATE, user })
                    dispatch({ type: actionTypes.CHOOSE_SHOP, data: {...getState().userReducer.userShop,...res.detail} });
                }
                const juniorShops = getState().shopReducer.juniorShops
                for (let i = 0; i < juniorShops.length; i++) {
                    if (juniorShops[i].id == params.id) {
                        juniorShops[i] = { ...juniorShops[i], ...res.detail }
                        break;
                    }
                }
                dispatch({ type: actionTypes.SHOP_CHANGE_STATE, data: juniorShops });
            })
        }).catch(error => {

        })
    };
};
//店铺修改接单状态
export function updateShopJiedan(params, callback = () => { }) {
    return (dispatch, getState) => {
        const { user, userShop } = getState().userReducer
        userShop.isBusiness = params.isBusiness
        let newShops = []
        for (let i = 0; i < user.shops.length; i++) {
            let newShop = {...user.shops[i]};
            if (newShop.id === userShop.id) {
                newShop.isBusiness = params.isBusiness
            }
            newShops.push(newShop);
        }
        user.shops = newShops;
        dispatch({ type: actionTypes.CHANGE_STATE, user });
        dispatch({ type: actionTypes.CHOOSE_SHOP, data: { ...userShop, isBusiness: params.isBusiness } });
    };
};


//四大服务分类列表
export function serviceCatalogList(params, callback = () => { }) {
    return (dispatch, getState) => {
        requestApi.serviceCatalogList(params).then(data => {
            callback(data)
            dispatch({ type: actionTypes.SHOP_CHANGE_STATE, data: { serviceCatalogList: data } });
        }).catch(error => {

        })
    };
};
//获取长列表
export function getList(witchList, isFirst = false, isLoadingMore = false, paramsPrivate = {}, api = () => { }, callback = () => { },loading=true,refreshing=true,limit=10) {
    return (dispatch, getState) => {
        if (isFirst) {
            loading?Loading.show():null;
            dispatch({ type: actionTypes.List_FIRSTLOAD, data: { api, witchList } });
        }
        else {
            if (isLoadingMore) {
                dispatch({ type: actionTypes.LIST_LOADMORE, data: { witchList } });
            }
            else {
                dispatch({ type: actionTypes.LIST_NO_LOADMORE, data: { witchList,refreshing } });
            }
        }

        let params = {
            page: getState().shopReducer.longLists[witchList] && getState().shopReducer.longLists[witchList].listsPage || 1,
            limit,
            ...paramsPrivate
        };
        api(params).then(data => {
            dataArr = data && data.data
            if (isLoadingMore) {
                let lists = getState().shopReducer.longLists[witchList].lists
                lists = dataArr ? [...lists, ...dataArr] : lists
                for (let i = 0; i < lists.length; i++) {
                    lists[i].key = i
                }
                callback(lists)
                const params1 = {
                    lists: lists,
                    loading: false,
                    hasMore: dataArr ? dataArr.length + getState().shopReducer.longLists[witchList].lists.length !== getState().shopReducer.longLists[witchList].listsTotal : false
                }
                dispatch({
                    type: actionTypes.LIST_FETCH_LOADINGMORE_SUCCESS,
                    data: {
                        witchList,
                        ...params1
                    }
                });
            } else {
                // console.log(dataArr ? dataArr : [])
                let lists = dataArr ? dataArr : []
                for (let i = 0; i < lists.length; i++) {
                    lists[i].key = i
                }
                callback(lists)
                const params1 = {
                    listsTotal: data ? data.total : 0,
                    lists: lists,
                    refreshing: false,
                    hasMore: data ? lists.length !== data.total : false
                }
                dispatch({
                    type: actionTypes.LIST_FETCH_NO_LOADINGMORE_SUCCESS,
                    data: {
                        witchList,
                        ...params1
                    }
                });
                if (!isFirst && !data) {
                    dispatch({
                        type: actionTypes.SHOP_CHANGE_STATE, data: { lists: [], witchList }
                    });
                }
            }

        }).catch(error => {
            if (isLoadingMore) {
                dispatch({
                    type: actionTypes.LIST_FETCH_LOADINGMORE_FAILD, data: { witchList }
                });
            }
            else {
                dispatch({
                    type: actionTypes.LIST_FETCH_No_LOADINGMORE_FAILD, data: { witchList }
                });
            }

        })
    };
};


//单纯修改一些状态
export function shopChangeState(params) {
    return (dispatch, getState) => {
        dispatch({ type: actionTypes.SHOP_CHANGE_STATE, data: params });
    };
};

// 获取是否设置支付密码
export function getSetPayPwdStatus(params) {
    return (dispatch, getState) => {
        dispatch({ type: actionTypes.FETCH_SETPAYPWDSTATUS, data: params });
    };
};

// 获取权限列表
export function getRoleList(params) {
    return (dispatch, getState) => {
        dispatch({ type: actionTypes.FETCH_SHOP_ROLELIST, data: params });
    };
};
// 获取授权管理直属下级店铺
export function getRoleManagerShopList(params) {
    return (dispatch, getState) => {
        dispatch({ type: actionTypes.FETCH_SHOP_CHILDREDLIST, data: params });
    };
};
// 获取店铺员工
export function employeeQPage(params={page: 1,limit: 10},callback=() => {},errorCallBack = () => { }) {
    return (dispatch, getState) => {
        console.log(getState())
        // 获取已存的数据
        let prevGoodsList = getState().welfareReducer.recommendGoodsList.goodLists;
        let total = getState().welfareReducer.recommendGoodsList.total;
        requestApi.getGoodsRecommendGoods(params).then(data => {
            console.log('redxxx',data)
            let _data;
            if (params.page === 1) {
                _data = data ? data.data : [];
            } else {
                _data = data ? [...prevGoodsList, ...data.data] : prevGoodsList;
            }
            // let _total = page === 1 ? data.total : total;
            let _total = params.page === 1
                ? (data)
                    ? total
                    : 0
                : total;
            let hasMore = data ? _total !== _data.length : false;
            let recommendGoodsList = {
                goodLists: _data,
                page:params.page,
                limit: params.limit,
                refreshing: false,
                hasMore,
                total:_total,
            }
            dispatch({ type: actionTypes.RECOMMENDGOODS_LIST, recommendGoodsList });
            callback(data);
        }).catch((err) => {
            errorCallBack(err)
        });
    };
}
