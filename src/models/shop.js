/**
 * 店铺
 */
import * as nativeApi from '../config/nativeApi';
import * as requestApi from '../config/requestApi';
import { handleListLoadMore } from '../services/mall';
import modelInitState from '../config/modelInitState';
import * as utils from '../config/utils';
import { JOIN_AUDIT_STATUS } from '../const/user';
import { showForzenToast } from '../config/request';

export default {
    namespace: 'shop',
    state: modelInitState.shop,
    reducers: {
        save(state, action) {
            return {
                ...state,
                ...action.payload,
            };
        },
    },
    effects: {
        *serviceCatalogList(action, { put, call, select }) {
            try {
                const data = yield call(requestApi.serviceCatalogList,{});
                action.payload && action.payload.callback && action.payload.callback(data);
                yield put({ type: 'save', payload: {serviceCatalogList: data}});
            } catch (error){}
        },
        *updateShopJiedan(action, { put, call, select }) {
            const { userShop ,merchantData} = yield select(state=>state.user);
            const params = action.payload;
            try {
                const data = yield call(params.isBusiness ? requestApi.mShopBusiness : requestApi.mShopUnBusiness,{ id: userShop.id });
                console.log('data',data);
                userShop.isBusiness = params.isBusiness;
                let newShops = [];
                for (let i = 0; i < merchantData.shops.length; i++) {
                    let newShop = {...merchantData.shops[i]};
                    if (newShop.id === userShop.id) {
                        newShop.isBusiness = params.isBusiness;
                    }
                    newShops.push(newShop);
                }
                merchantData.shops = newShops;
                yield put({type:'user/save',payload:{merchantData,userShop}});
            } catch (err){
                // Toast.show('设置失败')
            }
        },
        *updateShop(action, { put, call, select }) {
            const params = action.payload;
            try {
                const data = yield call(requestApi.updateShop,params);
                yield put({type:'getShopDetail',payload:params});
            } catch (err){
                console.log(err);
            }
        },
        *getShopDetail(action = {}, { put, call, select }) {
          try {
            const state = yield select(state=>state);
            const params = action.payload && action.payload.id ? action.payload : state.user.userShop;
            let juniorShops = [];
            if (params.id){
              const res = yield call(requestApi.shopDetails,{id: params.id});
              params.callback && params.callback();
              if (state.user.userShop.id === params.id || !state.user.userShop.id || params.isLogin) {
                  const merchantData = state.user.merchantData;
                  for (let item of (merchantData.shops || [])){
                      item.id === params.id ? item = {...item,...res.detail} : null;
                  }
                  yield put({ type: 'user/save', payload:{merchantData} });
                  const newUserShop = {...res.detail,mrCode:res.mrCode,shopType:res.shopType};
                  yield put({ type: 'user/chooseShop', payload:{userShop:newUserShop} });
                  const nextShopList = yield call(requestApi.mShopNextShopList,{ masterId: params.id });
                  juniorShops = nextShopList ? [newUserShop, ...nextShopList.nextShopList] : [newUserShop];
              }
            }
            yield put({type:'save',payload:{ juniorShops }});
          } catch (err){
            console.log(err);
          }
      },
      // 财务中心List
      *getFinancialCenterList({ payload }, { call,put,select }){
        try {
            let { params } = payload;
            let prevData = yield select(state => state.shop.financialList);

            console.log('prevData', prevData);
            console.log('params', params);
            let response = yield call(requestApi.fetchshopOrderDataQPage, params);
            if (params.page === 1) {
                yield put({ type: 'save', payload: { settleMoneySum: response ? response.settleMoneySum : 0 } });
            }
            let data = handleListLoadMore(params, response, prevData);
            console.log('response', response);
            console.log('data', data);
            yield put({ type: 'save', payload: { financialList: data } });
        } catch (error) {
            console.log(error);
        }
      },
      *getInitShop(action, { put, call, select }) { //查找预设店铺是否存在
        const merchantId = yield select(state=>state.user.user.merchantId);
        if (!merchantId) return;
        try {
          const data = yield call(requestApi.mercahntMasterShopIsExist,{merchantId});
          console.log(data);
          yield put({type:'save',payload:{isInitShopExist:data.isExist}});
        } catch (error){
          console.log(error);
        }
      },

        *getList({payload:{witchList, isFirst = false, isLoadingMore = false, paramsPrivate = {}, api = () => { }, callback = () => { },loading = true,refreshing = true,limit = 10}}, { put, call, select }) {
                console.log('witchList',witchList,loading,refreshing,isFirst , isLoadingMore);
            if (isFirst) {
                    loading ? Loading.show() : null;
                    const state = yield select(state=>state.shop);
                    yield put({type:'save',payload:{
                        longLists: {
                            ...state.longLists,
                            [witchList]: {
                                ...state.initList,
                                lists: state.longLists[witchList] && state.longLists[witchList].lists || [],
                            },
                        },
                    }});
                }
                else {
                    if (isLoadingMore) {
                        const state = yield select(state=>state.shop);
                        yield put({type:'save',payload:{
                            longLists: {
                                ...state.longLists,
                                [witchList]: {
                                    ...state.longLists[witchList],
                                    listsPage: state.longLists[witchList].listsPage + 1,
                                    loading: true,
                                },
                            },
                        }});
                    }
                    else {
                        const state = yield select(state=>state.shop);
                        yield put({type:'save',payload:{
                            longLists: {
                                ...state.longLists,
                                [witchList]: {
                                    ...state.longLists[witchList],
                                    refreshing,
                                    isFirstLoad:true,
                                    listsPage: 1,
                                    listsTotal: 0,
                                },
                            },
                        }});
                    }
                }
                const state = yield select(state=>state.shop);
                let params = {
                    page: state.longLists[witchList] && state.longLists[witchList].listsPage || 1,
                    limit,
                    ...paramsPrivate,
                };
                try {
                    const data = yield call(api,params);
                    dataArr = data && data.data;
                    if (isLoadingMore) {
                        const state = yield select(state=>state.shop);
                        let lists = state.longLists[witchList].lists;
                        lists = dataArr ? [...lists, ...dataArr] : lists;
                        for (let i = 0; i < lists.length; i++) {
                            lists[i].key = i;
                        }
                        callback(lists);
                        const params1 = {
                            lists: lists,
                            loading: false,
                            hasMore: dataArr ? dataArr.length + state.longLists[witchList].lists.length !== state.longLists[witchList].listsTotal : false,
                        };
                        yield put({type:'save',payload:{
                            longLists: {
                                    ...state.longLists,
                                    [witchList]: {
                                        ...state.longLists[witchList],
                                        isFirstLoad: false,
                                        witchList,
                                        ...params1,
                                    },
                            },
                        }});
                    } else {
                        // console.log(dataArr ? dataArr : [])
                        let lists = dataArr ? dataArr : [];
                        for (let i = 0; i < lists.length; i++) {
                            lists[i].key = i;
                        }
                        callback(lists);
                        const params1 = {
                            listsTotal: data ? data.total : 0,
                            lists: lists,
                            refreshing: false,
                            hasMore: data ? lists.length !== data.total : false,
                        };
                        const state = yield select(state=>state.shop);
                        yield put({type:'save',payload:{
                            longLists: {
                                ...state.longLists,
                                [witchList]: {
                                    ...state.longLists[witchList],
                                    isFirstLoad: false,
                                    witchList,
                                    ...params1,
                                },
                            },
                        }});
                        if (!isFirst && !data) {
                            yield put({type:'save',payload:{
                                lists: [], witchList,
                            }});
                        }
                    }
                } catch (error){
                    console.log(error);
                    const state = yield select(state=>state.shop);
                    if (isLoadingMore) {
                        yield put({type:'save',payload:{
                            longLists: {
                            ...state.longLists,
                            [witchList]: {
                                ...state.longLists[witchList],
                                isFirstLoad: false,
                                loading: false,
                                listsPage: state.longLists[witchList].listsPage - 1,
                            },
                        },
                        }});
                    }
                    else {
                        yield put({type:'save',payload:{
                            longLists: {
                                ...state.longLists,
                                [witchList]: {
                                    ...state.longLists[witchList],
                                    isFirstLoad: false,
                                    refreshing: false,
                                },
                            },
                        }});
                    }
                }
        },
        * check({ payload: { roleKey, callback } }, { select, put }) {
            const merchantData = yield select(state => state.user.merchantData || {});
            const userRoleList = yield select(state => state.user.userRoleList || []);
            const userShop = yield select(state => state.user.userShop || {});
            const { merchant } = merchantData;
            const { identityStatuses } = merchant || {};
            const shopItem = identityStatuses.find(item => item.merchantType == 'shops');
            const { auditStatus } = shopItem || {};

            // 如果创建了店铺，且用户状态未待激活或者激活成功两个状态，可以直接使用功能。
            if (utils.checkoutRole(roleKey, userRoleList) && userShop.id && (auditStatus === JOIN_AUDIT_STATUS.success || auditStatus === JOIN_AUDIT_STATUS.un_active)) {
                callback && callback();
                return;
            }
            // 判断如果未开店，且用户状态未待激活或者激活成功两个状态，可以直接使用店铺管理功能。
            if (utils.checkoutRole(roleKey, userRoleList) && (roleKey === 'shopManager' && !userShop.id && (auditStatus === JOIN_AUDIT_STATUS.success || auditStatus === JOIN_AUDIT_STATUS.un_active))) {
                callback && callback();
                return;
            }
            // 未入驻商户，提示先入驻商户
            if (!auditStatus) {
                CustomAlert.onShow('confirm', '您尚未完成商户入驻，请先入驻商户身份', '', () => { }, () => {
                    app._store.dispatch({ type: 'system/navPage', payload: { routeName: 'RegisterList', params: { route: 'Shop' } }});
                }, '立即入驻', '取消');
                return;
            }

            // 如果未开店，做以下逻辑处理
            switch (auditStatus) {
                case JOIN_AUDIT_STATUS.active:
                    CustomAlert.onShow('confirm', '您已完成入驻，请先在店铺管理创建店铺', '', () => { }, () => {
                        app._store.dispatch({
                            type: 'system/navPage',
                            payload: {
                              routeName: 'StoreManage',
                            },
                          });
                     }, '立即开店','知道了');
                    break;
                case JOIN_AUDIT_STATUS.un_active:
                        CustomAlert.onShow('confirm', '您已完成审核，请先在店铺管理创建店铺', '', () => { }, () => {
                            app._store.dispatch({
                                type: 'system/navPage',
                                payload: {
                                  routeName: 'StoreManage',
                                },
                              });
                         }, '立即开店','知道了');
                //    CustomAlert.onShow('confirm', '您已完成入驻，请先在店铺管理创建店铺', '', () => { }, () => {
                //         app._store.dispatch({
                //             type: 'system/navPage',
                //             payload: {
                //               routeName: 'StoreManage'
                //             },
                //           });
                //      }, '立即开店','知道了');
                    break;
                case JOIN_AUDIT_STATUS.audit_fail:
                    CustomAlert.onShow('alert', '您尚未完成商户入驻，账号未通过审核', '', () => { }, () => { }, '知道了');
                    break;
                default:
                    CustomAlert.onShow('alert', '您尚未完成商户入驻，请耐心等待审核', '', () => { }, () => { }, '知道了');
                    break;
            }
        },
    },
};
