import * as requestApi from '../../config/requestApi'
import { initSelectedStatus, initCategoryTitleStatus, filterCategoryLists, handleListToItem, handleListLoadMore, handldleFilterMove, handleCategotyListLoadMore } from '../../services/mall'
const errorJsName = 'mallModel'

export default {
    *getBrandData({ payload }, { call, put }) {
        try {
            let brandInfo = yield call(requestApi.brandShopDetail, payload);// 获取店铺信息
            let brandBannerList = yield call(requestApi.brandShopBanner, payload)// 获取店铺banner
            yield put({ type: 'save', payload: { brandInfo, brandBannerList: brandBannerList.banner } })
        } catch (error) { }
    },
    *fetchSomPageData({ payload }, { call, put }) {
        try {

            // 获取bannerList
            let bannerList = yield call(requestApi.requestSOMBannerList, { regionCode: global.regionCode || '510107', bannerModule: "MERCHANT_SELF_SHOP" })

            // 获取分类页面弹窗子类数据
            let modalCategoryLists = yield call(requestApi.requestGoodsCategoryLists)

            // 异步获取分类列表（不包含子项）
            let requestSOMScategoryQList = yield call(requestApi.requestSOMScategoryQList)
            let categoryLists = initCategoryTitleStatus({ data: requestSOMScategoryQList || [] })

            // 获取缓存的自定义分类列表,并进行过滤
            let goodsCategoryLists_pre;
            try {
                let coustomCategoryList = yield call(requestApi.storageSOMCateLists, 'load')
                goodsCategoryLists_pre = filterCategoryLists({ data: categoryLists, coustomCategoryList: coustomCategoryList || [] })
            } catch (error) {
                goodsCategoryLists_pre = filterCategoryLists({ data: categoryLists, coustomCategoryList: [] })
                console.log(`${errorJsName},fetchSomPageData`, error)
            }

            // 分类页面弹窗数据 加入选择标识
            let _modalCategoryLists = initSelectedStatus(modalCategoryLists)
            yield put({
                type: 'save', payload: {
                    somBannerList: bannerList,
                    goodsCategoryLists: _modalCategoryLists,
                    goodsCategoryLists_pre: goodsCategoryLists_pre || [],
                    categoryGoodsList: Array.apply(null, Array((goodsCategoryLists_pre || []).length)).map(item => {
                        return {
                            params: {},
                            data: []
                        }
                    })
                }
            })
        } catch (error) { }
    },
    // 获取推荐商品列表数据
    *fetchRecommendSGoods({ payload }, { call, put, select }) {
        try {
            let prevData = yield select(state => state.mall.recommendGoodsList)
            let somRecommendList = yield call(requestApi.requestMallGoodsRecommendSGoodsQPage, payload.params)
            console.log('handleListLoadMore',handleListLoadMore)
            let _filterData = handleListLoadMore(payload.params, somRecommendList, prevData);
            yield put({ type: 'save', payload: { recommendGoodsList: _filterData } })
        } catch (error) {
            console.log(`${errorJsName},fetchRecommendSGoods`, error)
        }
    },
    // 保存自定义的分类数据
    *saveCoustomCategoryList({ payload }, { put, call }) {
        try { yield put({ type: 'save', payload: { goodsCategoryLists_pre: payload.categoryLists } }) } catch (error) { console.log(`${errorJsName}`) }
    },
    // 获取分类列表推荐商品数据
    *fetchRecommendGoodsOfCategory({ payload }, { put, call, select }) {
        try {
            let prevData = yield select(state => state.mall.recommendGoodsListOfCategory)
            let somRecommendList = yield call(requestApi.requestMallGoodsRecommendSGoodsQPage, payload.params)
            console.log('data', somRecommendList)
            let _filterData = handleListLoadMore(payload.params, somRecommendList, prevData);
            yield put({ type: 'save', payload: { recommendGoodsListOfCategory: _filterData } })
        } catch (error) {
            console.log(`${errorJsName},fetchRecommendGoodsOfCategory`, error)
        }
    },
    *fetchCategoryList({ payload }, { put, call, select }) {
        try {
            console.log('payload', payload)
            let prevData = yield select(state => state.mall.categoryGoodsList)
            // console.log('prevData', prevData)
            let fetchList = yield call(requestApi.requestSearchGoodsList, payload.params)
            let _filterData = handleCategotyListLoadMore(payload.params, payload.nowCategoryIndex, fetchList, prevData);
            // console.log('_filterData', _filterData)
            yield put({ type: 'save', payload: { categoryGoodsList: JSON.parse(JSON.stringify(_filterData)) } })
            // console.log('requestSearchGoodsList', fetchList)
        } catch (error) {
            console.log(`${errorJsName},fetchRecommendSGoods`, error)
        }
    },
    // 获取收藏夹商品列表数据
    *fetchCollenctionList({ payload }, { put, call, select }) {
        console.log("fetchCollenctionList", payload.params)
        try {
            let prevData = yield select(state => state.mall.somCollectionGoodsList)
            let response = yield call(requestApi.requestxkFavoriteQPage, payload.params)
            console.log("response", response)
            let _filterData = handleListLoadMore(payload.params, response, prevData);
            console.log("_filterData", _filterData)
            yield put({ type: 'save', payload: { somCollectionGoodsList: _filterData } })
        } catch (error) {
            console.log(`${errorJsName},fetchCollenctionList`, error)
        }
    },
    // 删除收藏夹数据
    *fetchCollenctionDeleSingle({ payload }, { put, select, call }) {
        try {
            let prevData = yield select(state => state.mall.somCollectionGoodsList) //原有数据
            let idsObj = {
                ids: payload.ids
            };
            yield call(requestApi.requestxkFavoriteDelete, idsObj) //删除项，条件id
            yield put({ type: 'fetchCollenctionList', payload: { params: { page: 1, limit: 10, xkModule: 'mall' } } })
        } catch (error) {
            console.log(`${errorJsName},fetchCollenctionDeleSingle`, error)
        }
    },
    // 更新选择状态
    *handleUpDataSelectStatus({ payload }, { call, put, select }) {
        let modalCategoryLists = yield select(state => state.mall.goodsCategoryLists)
        let _newData = initSelectedStatus(modalCategoryLists, payload.index)
        console.log('_newData', _newData)
        yield put({ type: 'save', payload: { goodsCategoryLists: JSON.parse(JSON.stringify(_newData)) } })

    },
    // 自营分类列表三级列表商品数据
    *fetchThirdCategoryList({ payload }, { call, put, select }) {
        try {
            let goodsList = yield call(requestApi.requestSearchGoodsList, payload.params)
            console.log('goodsList', goodsList)
            let prevData = yield select(state => state.mall.somListsThirdList)
            let _filterData = handleListLoadMore(payload.params, goodsList, prevData);
            yield put({ type: 'save', payload: { somListsThirdList: _filterData } })
        } catch (error) {
            console.log(`${errorJsName},fetchThirdCategoryList`, error)
        }
    },
    // 自营商城搜索历史记录
    *getStorageSearchHistory({ payload }, { call, put, select }) {
        try {
            let _searchHistory = yield call(requestApi.storageSearchHistory, 'load')
            yield put({ type: 'save', payload: { somHistoryLists: { title: '历史搜索', lists: _searchHistory } } })
        } catch (error) {
            console.log(`${errorJsName},getStorageSearchHistory`, error)
            yield put({ type: 'save', payload: { somHistoryLists: { title: '历史搜索', lists: [] } } })
        }
    },
    // 自营商城获取热词
    *getHotList({ payload }, { call, put, select }) {
        try {
            let _hotList = yield call(requestApi.requestHotWordsList)
            console.log('_hotList', _hotList)
            yield put({
                type: 'save', payload: {
                    somHotList: {
                        title: '热门搜索',
                        lists: _hotList.length === 0 ? ['小可', '书', '包', '商品', '书包', '鼠标', '键盘'] : _hotList
                    }
                }
            })
        } catch (error) {
            console.log(`${errorJsName},getHotList`, error)
        }
    },
    // 自营商城清除历史记录
    *clearHistory({ payload }, { call, put, select }) {
        try {
            yield call(requestApi.storageSearchHistory, 'remove')
            yield put({ type: 'save', payload: { somHistoryLists: { title: '历史搜索', lists: [] } } })
        } catch (error) {
            console.log(`${errorJsName},clearHistory`, error)
        }
    },
    // 自营商城保存历史记录
    *saveSomSearchHistory({ payload }, { call, put, select }) {
        try {
            let prevData = yield select(state => state.mall.somHistoryLists)
            requestApi.storageSearchHistory('save', prevData.lists, payload.keyword);
        } catch (error) {
            console.log(`${errorJsName},saveSomSearchHistory`, error)
        }
    },
    // 自营商城搜索
    *searchGoodsList({ payload }, { call, put, select }) {
        try {
            let prevData = yield select(state => state.mall.somSearchGoodsList.data)
            let goodsList = yield call(requestApi.requestSearchGoodsList, payload.params)
            let _filterData = handleListLoadMore(payload.params, goodsList, prevData);
            yield put({ type: 'save', payload: { somSearchGoodsList: _filterData } })
        } catch (error) {
            console.log(`${errorJsName},searchGoodsList`, error)
        }
    },
    // 获取属性模板
    *getPropertyData({ payload }, { call, put, select }){
        try {
            const { keyword } = payload
            let response = yield call(requestApi.filterAttrList, { keywords: keyword })
            console.log('属性模板', response)
            yield put({ type: 'resetPropertyFilter', payload: { data: response } })

        } catch (error) {
            console.log(`${errorJsName},getPropertyData`, error)
        }
    },
    *resetPropertyFilter({ payload }, { call, put, select }){
        try {
            const { data } = payload
            let listData = data.templates && data.templates.length !== 0 ? data.templates : [];
            // 初始化选择状态
            listData.map(attrItem => {
                attrItem.attributes.map(filedItem => {
                    if (filedItem.fields.length !== 2) {
                        filedItem.fields.map(porpertyItem => {
                            porpertyItem.items.map(item => {
                                item.selectStatus = false; // 设置初始单选的状态
                            })
                        })
                    } else {
                        filedItem.fields.map(item => {
                            item.value = ''; // 设置价格区间初始值
                        })
                    }
                })
            })
        yield put({ type: 'save', payload: { somFilterAttrList: { templates: listData } } })
        } catch (error) {
            console.log(`${errorJsName},resetPropertyFilter`, error)
        }
    },
    // 获取购物车商品列表数据
    *fetchMallCartList({ payload }, { put, call, select }) {
        try {
            let params = payload.merchantId;
            let fetchList = yield call(requestApi.requestMallCartList, params)
            if (!fetchList) {
                yield put({ type: 'save', payload: { somCartLists: { data: [] } } })
            }
            // let _filterData = handleListLoadMore(params, fetchList, prevData);
            yield put({ type: 'save', payload: { somCartLists: fetchList } })
        } catch (error) {
            console.log(`${errorJsName},requestMallCartList`, error)
        }
    },
    // 修改购物车列表数据
    *changeMallCartList({ payload, callback }, { put, call, select }) {
        try {
            let paylItem = payload.item;
            let paylData = payload.data;
            let prevData = yield select(state => state.mall.somCartLists.data)
            let _filterData = handleListToItem(paylItem, paylData, prevData);
            yield call(requestApi.requestMallCartBatchUpdate, _filterData)
            let idsObj = {
                data: _filterData
            }
            yield put({ type: 'save', payload: { somCartLists: idsObj } })
            callback(true)
        } catch (error) {
            console.log(`${errorJsName},requestMallCartList`, error)
        }
    },
    // 购物车批量移入收藏夹数据
    *mallCartMoveToCollect({ payload, callback }, { put, call, select }) {
        try {
            let prevData = yield select(state => state.mall.somCartLists.data)
            let params = payload.data;
            let _filterData = handldleFilterMove(prevData, params);
            let data = yield call(requestApi.requestMallCartMoveToCollect, params)
            yield put({ type: 'save', payload: { somCartLists: { data: _filterData } } })
            _filterData ? Toast.show("移除成功") : Toast.show("移除失败");
            callback(true);
        } catch (error) {
            console.log(`${errorJsName},mallCartMoveToCollect`, error)
        }
    },
    // 删除商品
    *mallCartBatchDestory({ payload, callback }, { put, call, select }) {
        try {
            let prevData = yield select(state => state.mall.somCartLists.data)
            let params = payload.data;
            let _filterData = handldleFilterMove(prevData, params);
            yield call(requestApi.requestMallCartBatchDestory, params)
            yield put({ type: 'save', payload: { somCartLists: { data: _filterData } } })
            _filterData ? Toast.show("删除成功") : Toast.show("删除失败");
            callback(true);
        } catch (error) {
            console.log(`${errorJsName},mallCartMoveToCollect`, error)
        }
    },
    // 清空失效商品
    *deteleCartToColect({ payload, callback }, { put, call, select }) {
        try {
            let params = payload.data;
            let filterData = params.map(item => item.status === 0 ? item : {})
            yield call(requestApi.requestMallCartBatchDestory, params)
            filterData === params ?
                (Toast.show("失效商品已全部清空"),
                    callback(true))
                : (Toast.show("失效商品清空失败"),
                    callback(false))
        } catch (error) {
            console.log(`${errorJsName},deteleCartToColect`, error)
        }
    }
}
