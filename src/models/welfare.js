/**
 * 福利商城
 */
import * as nativeApi from '../config/nativeApi';
import * as requestApi from '../config/requestApi';
import modelInitState from '../config/modelInitState';
import { handleListLoadMore, handleStatusListLoadMore } from '../services/welfare';

const modalName = 'welfare';
export default {
  namespace: 'welfare',
  state: modelInitState.welfare,
  reducers: {
    save(state, action) {
      return {
        ...state,
        ...action.payload,
      };
    },
  },
  effects: {
    // 福利商城 获取订单详情
    * qureyWMOrderDetail({ payload: { params = { orderId: '', userId: '' }, callback = () => { }, errorCallBack = () => { } } }, { put, call, select }) {
      try {
        const data = yield call(requestApi.qureyWMOrderDetail, params);
        callback(data);
        data.state = 'WAIT_FOR_RECEVING'
        yield put({ type: 'save', payload: { orderData: data } });
      } catch (error) {
        console.log(`${modalName} qureyWMOrderDetail`, error);
      }
    },
    * initPageData({ payload }, { put, call, select }) {
      try {
        Loading.show();
        const { params } = payload;
        yield put({ type: 'getWMBannerList' });
        yield put({ type: 'getGoodsRecommendGoodsList', payload: { params } });
      } catch (error) {
        console.log(`${modalName} initPageData`, error);
      }
    },
    // 获取推荐商品
    * getGoodsRecommendGoodsList({ payload }, { call, put, select }) {
      try {
        const { params } = payload;
        const goodsList = yield call(requestApi.getGoodsRecommendGoods, params);
        const prevData = yield select(state => state.welfare.wmRecommendList);
        console.log('getGoodsRecommendGoodsList', goodsList);
        const _filterData = handleListLoadMore(params, goodsList, prevData);
        yield put({ type: 'save', payload: { wmRecommendList: _filterData } });
      } catch (error) {
        console.log(`${modalName} getGoodsRecommendGoodsList`, error);
      }
    },
    // 福利首页banner
    * getWMBannerList({ payload }, { put, call, select }) {
      try {
        const data = yield call(requestApi.requestSOMBannerList, { regionCode: global.regionCode, bannerModule: 'MERCHANT_WELFARE' });
        yield put({ type: 'save', payload: { bannerList_wm: data || [] } });
      } catch (error) {
        console.log(`${modalName} getWMBannerList`, error);
      }
    },
    // 获取所有人最新揭晓数据
    * getWMAllLateyPrizeList({ payload: { params = { page: 1, limit: 10, jCondition: {} }, callback = () => {}, errorCallBack = () => { } } }, { put, call, select }) {
      // 获取已存的数据
      const prevGoodsList = (yield select(state => state.welfare)).latelyPrizeList.goodLists;
      const total = (yield select(state => state.welfare)).latelyPrizeList.total;
      // 获取推荐数据
      try {
        const data = yield call(requestApi.bestNewJGoodsQPage, params);
        console.log('redxxx', data);
        let _data;
        if (params.page === 1) {
          _data = data ? data.data : [];
        } else {
          _data = data ? [...prevGoodsList, ...data.data] : prevGoodsList;
        }
        // let _total = page === 1 ? data.total : total;
        const _total = params.page === 1
          ? (data)
            ? data.total
            : 0
          : total;
        const hasMore = data ? _total !== _data.length : false;
        const latelyPrizeList = {
          goodLists: _data,
          page: params.page,
          limit: params.limit,
          refreshing: false,
          hasMore,
          total: _total,
        };
        yield put({
          type: 'save',
          payload: {
            latelyPrizeList,
          },
        });
        callback(data);
      } catch (err) {
        errorCallBack(err);
      }
    },
    //  我的夺奖列表
    * getPrizeOrderList({ payload }, { put, call, select }) {
      try {
        const { params, nowStatusIndex } = payload;
        const prevData = yield select(state => state.welfare.prizeOrderList);
        const fetchList = yield call(requestApi.jfMallOrderSysQPage, params);
        const _filterData = handleStatusListLoadMore(params, nowStatusIndex, fetchList, prevData);
        console.log('fetchList', fetchList);
        console.log('_filterData', _filterData);
        const response = yield call(requestApi.notfinishedSequenceNum);
        yield put({ type: 'save', payload: { prizeOrderList: JSON.parse(JSON.stringify(_filterData)), prizeOrderListNum: response } });
      } catch (error) {
        console.log(`${modalName} getPrizeOrderList`, error);
      }
    },
    // 设置消费商品详情webView的重载状态
    * setWMXFWebViewReload({ payload }, { put, call, select }) {
      yield put({ type: 'save', payload: { xfViweWebReload: payload.needReLoad || false } });
    },
    // 往期揭晓列表
    * getPastWinnerList({ payload }, { call, put, select }) {
      try {
        const goodsList = yield call(requestApi.pastLotteryRecordForOperation, payload.params);
        console.log('goodsList', goodsList);
        const prevData = yield select(state => state.welfare.pastWinnerList);
        const _filterData = handleListLoadMore(payload.params, goodsList, prevData);
        yield put({ type: 'save', payload: { pastWinnerList: _filterData } });
      } catch (error) {
        console.log(`${modalName} getPastWinnerList`, error);
      }
    },
    // 获取夺奖商品
    * getWmPrizeGoodsList({ payload }, { call, put, select }) {
      try {
        const { params } = payload;
        const goodsList = yield call(requestApi.jmallEsSearch, params);
        const prevData = yield select(state => state.welfare.wmPrizeGoodsList);
        console.log('jmallEsSearch', goodsList);
        const _filterData = handleListLoadMore(params, goodsList, prevData);
        yield put({ type: 'save', payload: { wmPrizeGoodsList: _filterData } });
      } catch (error) {
        console.log(`${modalName} getWmPrizeGoodsList`, error);
      }
    },
    // 获取平台大奖
    * getPaltDrawDataList({ payload }, { call, put, select }) {
      try {
        const { params } = payload;
        const goodsList = yield call(requestApi.jmallEsSearchPlawt, params);
        const prevData = yield select(state => state.welfare.paltDrawDataList);
        console.log('jmallEsSearchPlawt', goodsList);
        const _filterData = handleListLoadMore(params, goodsList, prevData);
        yield put({ type: 'save', payload: { paltDrawDataList: _filterData } });
      } catch (error) {
        console.log(`${modalName} getPaltDrawDataList`, error);
      }
    },
    // 根据状态获取多列表
    * getStatusList({ payload }, { put, call, select }) {
      try {
        const {
          params, nowStatusIndex, field, requestApiName,
        } = payload;
        const prevData = yield select(state => state.welfare[field]);
        const fetchList = yield call(requestApi[requestApiName], params);
        const _filterData = handleStatusListLoadMore(params, nowStatusIndex, fetchList, prevData);
        console.log('fetchList', fetchList);
        console.log('_filterData', _filterData);
        yield put({ type: 'save', payload: { [field]: JSON.parse(JSON.stringify(_filterData)) } });
      } catch (error) {
        console.log(`${modalName} getStatusList`, error);
      }
    },
    // 订单详情
    // eslint-disable-next-line no-dupe-keys
    * qureyWMOrderDetail({ payload }, { put, call, select }) {
      try {
        const { params } = payload;
        const wmOrderDetail = yield call(requestApi.qureyWMOrderDetail, params);
        console.log('wmOrderDetail', wmOrderDetail);
        yield put({ type: 'save', payload: { wmOrderDetail } });
      } catch (error) {
        console.log(`${modalName} qureyWMOrderDetail`, error);
      }
    },
    *listNavigation ( { payload }, { put, call, select }){
      try {
        const { params } = payload
        let routeName = ''
        let navParams = {
          orderId:params.orderId,
          sequenceId: params.termNumber || params.sequenceId,
          routerIn:params.routerIn,
          goodsId: params.goodsId
        }
        let winnerLotterStatusArr = ['NOT_SHARE', 'NOT_DELIVERY' , 'DELIVERY' , 'WAIT_FOR_RECEVING']
        let completeStatusArr = ['WINNING_LOTTERY' ,'RECEVING' , 'LOSING_LOTTERY' , 'SHARE_LOTTERY' ,'SHARE_AUDIT_ING' , 'SHARE_AUDIT_FAIL']
        let isExpenseGoods = params.awardUsage === 'expense'
        console.log('opeartGoBackRouteName', params.routerIn)
        yield put({ type: 'save', payload: { opeartGoBackRouteName: params.routerIn || '' } })
        // 未开奖状态
        if (params.state === 'NO_LOTTERY') {
          routeName = isExpenseGoods ? 'WMExpenseWaitOpenOrderDetail' :  'WMOpenPrizeDetail';
          yield put({ type: 'system/navPage', payload: { routeName, params:navParams } })
        }
        // 已中奖状态
        if (winnerLotterStatusArr.includes(params.state)) {
          routeName = isExpenseGoods ? 'WMExpenseWinLottery' :  'WMWinPrizeDetail';
          yield put({ type: 'system/navPage', payload: { routeName, params:navParams } })
        }
        // 已完成状态
        if (completeStatusArr.includes(params.state)) {
         if (params.state === 'SHARE_LOTTERY' || params.state === 'LOSING_LOTTERY') { // 如果已中奖或未中奖，判断平台大奖还是福利夺奖，福利去未中奖订单详情，平台去h5
            // 平台大奖跳转详情
            routeName = isExpenseGoods ? 'WMXFGoodsDetail' :  'WMLotteryDetail';
            params.sequenceId = params.termNumber || params.sequenceId;
            let payload = isExpenseGoods ? { routeName, params: { goodsData: params, goodsId: params.goodsId } } : { routeName, params: navParams };
            yield put({ type: 'system/navPage', payload})
          } else {
            console.log('去晒单')
            // 否则进入晒单流程页面
            routeName = isExpenseGoods ? 'WMExpenseShowOrderDetail' :  'WMOrderLottery';
            yield put({ type: 'system/navPage', payload: { routeName, params: navParams } })
          }
        }
      } catch (error) {
        // routeName = 'WMOrderList';
        // yield put({ type: 'system/navPage', payload: { routeName } })
        console.log(`${modalName} listNavigation`, error);
      }
    },
    *handleOpeartGoBack ({ payload }, { put, call, select }) {
      try {
        const { resultType } = payload
        const goBackRouteName = yield select(state => state.welfare.opeartGoBackRouteName) 
        // goBackRouteName 如果福利订单列表进入 为 WMOrderList， 如果我的奖品列表进入 为 WMMyPrizeRecord， 如果我的夺奖进入 为 WMMyprize
        const routeName = (goBackRouteName === 'WMOrderList' || goBackRouteName === '') ? resultType === 2 ? 'WMWinPrizeDetail' : 'WMOrderList' : goBackRouteName;
        yield put({ type: 'system/navPage', payload: { routeName, params: {} } })
      } catch (error) {
        console.log(`${modalName} handleOpeartGoBack`, error);        
      }
    },
    *handleCashierGoBack({ payload }, { put, call, select }){
      try {
        const routeName = yield select(state => state.welfare.cashireGoBackRoute)
        const cashireGoBackParams = yield select(state => state.welfare.cashireGoBackParams)
        yield put({ type: 'system/navPage', payload: { routeName, params: cashireGoBackParams } })
      } catch (error) {
        console.log(`${modalName} handleCashierGoBack`, error);        
      }
    },
    *refreshOrderListItem({ payload }, { put, call, select }){
      try {
        const { nextStatus, type } = payload
        console.log('nextStatus',nextStatus)
        const wmOrderList = yield select(state => state.welfare.wmOrderList)
        const recordItem = yield select(state => state.welfare.wmOrderListItem)
        let findItem;
        let findIndex;
        wmOrderList[recordItem.status].data.find((item, index) =>{
          if (item.orderId === recordItem.orderId) {
            findIndex = index;
            findItem = item;
          }
        })
        if (findItem) {
          let nextItem = findItem 
          nextItem.state = nextStatus
          wmOrderList[recordItem.status].data[findIndex] = nextItem;
          yield put({ type: 'save', payload: { wmOrderList: JSON.parse(JSON.stringify(wmOrderList)) } })
        }
      } catch (error) {
        console.log(`${modalName} refreshOrderListItem`, error);        
      }
    },
  },
};
