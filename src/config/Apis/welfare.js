
/**
 * 请求api
 */
import request from '../request';
import { storageFnc } from './commonApi';
/**
 * 福利商城 获取订单详情 welfareMall/winning
 */
export function qureyWMOrderDetail(params = { orderId: '', userId: '' }, callback = () => { }) {
  return request('POST', 'trade/ma/jfMallOrderDetail/1.0', params);
}
// 福利商城 大奖晒单列表 welfareMall/winning
export function jmallGoodsCommentList(params = { page: 1, limit: 10 }) {
  return request('POST', 'im/ma/jmallGoodsCommentList/1.0', params);
}
/**
 * 夺宝购物车 welfareMall
 */
export function jfmallCartQList(params) {
  return request('POST', 'goods/ma/jfmallCartQList/1.0', params);
}
// 福利商城 用户消费券余额 welfareMall
export function muserAccDetail(params = { refundId: '' }, isShowLoading = false) {
  return request('GET', 'trade/ma/muserAccDetail/1.0', params, isShowLoading);
}
// 修改数量 welfareMall
export function jfmallCartUpdateQuantity(params) {
  return request('POST', 'goods/ma/jfmallCartUpdateQuantity/1.0', params);
}
// 移入收藏夹 welfareMall
export function jfmallCartMoveToFavorites(params) {
  return request('POST', 'goods/ma/jfmallCartMoveToFavorites/1.0', params);
}
// 批量删除 welfareMall
export function jfmallCartDestroy(params) {
  return request('POST', 'goods/ma/jfmallCartDestroy/1.0', params);
}
// 获取默认收货地址 welfareMall/winning/wholesaleMall
export function merchantDefault(params = {}, isShowLoading = true) { // 修改
  return request('POST', 'user/ma/merchantDefault/1.0', params, isShowLoading);
}
// 福利商城下单 兑换 welfareMall
export function jmallOrderCreate(params) {
  return request('POST', 'trade/ma/jmallOrderCreate/1.0', params);
}
// 福利商品详情往期中奖 welfareMall/winning
export function pastLotteryRecordForOperation(params = { jCondition: {}, limit: 10, page: 1 }) {
  return request('GET', 'goods/ma/pastLotteryRecordForOperation/1.0', params);
}
/**
 * 福利商城收藏夹 welfareMall
 */
export function xkFavoriteQPage(params) {
  return request('POST', 'user/ma/xkFavoriteQPage/1.0', params);
}
// 取消收藏 welfareMall
export function xkFavoriteDelete(params) {
  return request('POST', 'user/ma/xkFavoriteDelete/1.0', params);
}
// 收藏列表 welfareMall
export function requestxkFavoriteQPage(params = {}, success = () => { }, fail = () => { }) {
  return request('GET', 'user/ma/xkFavoriteQPage/1.0', params).then((res) => {
    success(res);
  }).catch((e) => {
    fail(e);
  });
}
// 获取商品晒单标签 welfareMall/winning
export function jGoodsCommentLabels(params = { goodsId: '' }) {
  return request('GET', 'im/ma/jGoodsCommentLabels/1.0', params);
}
// 福利商城 晒单提交 又名：添加评论 welfareMall/winning
export function jGoodsCommentCreate(params = { page: 1, limit: 10 }, callback = () => { }) {
  return request('POST', 'im/ma/jGoodsCommentCreate/1.0', params);
}
// 福利商城 消费抽奖 领取奖品 welfareMall/winning
export function platOrderDoDelivery(params = { orderId: '', addressId: '' }) {
  return request('POST', 'trade/ma/platOrderDoDelivery/1.0', params);
}
// 福利商城 货物报损 welfareMall
export function jmallOrderRefundCreate(params = { sequenceId: '' }) {
  return request('POST', 'trade/ma/jmallOrderRefundCreate/1.0', params);
}
// 福利商城 货物报损详情 welfareMall
export function refundReportDetail(params = { refundId: '' }) {
  return request('POST', 'trade/ma/refundReportDetail/1.0', params);
}
// 福利商城 货物报损添加物流信息 welfareMall
export function jRefundOrderAddLogistics(params = { refundId: '' }) {
  return request('POST', 'trade/ma/jRefundOrderAddLogistics/1.0', params);
}
// 福利商城 福利商品详情 welfareMall/winning
export function lotteryDetail(params = {}) {
  return request('POST', 'goods/ma/lotteryDetail/1.0', params);
}
// 商品sku明细 welfareMall/wholesaleMall/winning
export function requestGoodsSku(params = { goodsId: '' }, callback = () => { }) {
  return request('GET', 'trade/ma/mallGoodsSkuQList/1.0', params).then((res) => {
    callback(res);
  });
}

// 福利商城 最新揭晓 当前用户参与的抽奖列表，包括已开奖和未开奖 welfareMall
export function newestJQPage(params = { page: 1, limit: 10 }, callback = () => { }) {
  return request('POST', 'trade/ma/newestJQPage/1.0', params);
}
/**
 * 福利商城 分类列表 welfareMall
 */
export function getWMCategoryList(callback = () => { }) {
  return request('POST', 'goods/ma/queryJfmallCategory/1.0').then((res) => {
    callback(res);
  });
}
/**
 * 福利商城 推荐商品 welfareMall
 */
export function getGoodsRecommendGoods(params = { page: 1, limit: 10, jCondition: { districtCode: '' } }, callback = () => { }) {
  return request('POST', 'goods/ma/recommendJGoodsQPage/1.0', params);
}
// 福利商城 搜索  二级列表的筛选也用此接口 welfareMall
export function jmallEsSearch(params) {
  return request('POST', 'goods/ma/jmallEsSearch/1.0', params);
}
// 福利商城 平台大奖 welfareMall
export function jmallEsSearchPlawt(params = { page: 1, limit: 10 }, callback = () => { }) {
  return request('POST', 'goods/ma/jmallEsSearchPlawt/1.0', params);
}
// welfare.js 福利商城 物流信息 welfareMall/winning/wholesaleMall
export function logisticsQuery(params = { orderId: '', orderType: 'NORMAL' }) {
  return request('POST', 'sys/ma/logisticsQuery/1.0', params);
}
// 福利商城 我的奖券 welfareMall/winning
export function drawTicketPage(params = { ticketType: 0, limit: 10, page: 1 }) {
  return request('POST', 'trade/ma/drawTicketPage/1.0', params);
}
// 福利商城 中奖记录 welfareMall/winning
export function platSpendLotteryRecordUserQpage(params = { ticketType: 0, limit: 10, page: 1 }) {
  return request('POST', 'trade/ma/platSpendLotteryRecordUserQpage/1.0', params);
}
// 福利商城 中奖数量 welfareMall/winning
export function myWinningCount(params = {}) {
  return request('POST', 'trade/ma/myWinningCount/2.0.12', params);
}
// 福利商城 平台抽奖多期列表 welfareMall/winning
export function jPlatQpage(params = { serialNum: 0, limit: 10, page: 1 }) {
  return request('POST', 'trade/ma/jPlatQpage/2.0.12', params);
}
// 福利商城 确认收货 welfareMall/winning
export function jOrderDoReceving(params = { refundId: '' }) {
  return request('POST', 'trade/ma/jOrderDoReceving/1.0', params);
}
// 福利商城 消费抽奖 商品详情  welfareMall/winning
export function allDetailLottery(params = { orderId: '', orderType: 'NORMAL' }) {
  return request('POST', 'trade/ma/allDetailLottery/1.0', params);
}
// 消费订单分享 welfareMall/winning
export function platOrderDoShare(params = { orderId: '' }) {
  return request('POST', 'trade/ma/platOrderDoShare/1.0', params);
}
/**
 * 缓存是否第一次订单分享 welfareMall
 */
export function storageWMOrderShare(status = 'save', data = null, expires = null) {
  return storageFnc('wmOrderShareNum', status, data, expires);
}
// 福利商城 已完成 中奖详情 welfareMall/winning
export function jSequenceJoinQPage(params = { sequenceId: '' }) {
  return request('POST', 'trade/ma/jSequenceJoinQPage/1.0', params);
}
// 福利商城 红包领取记录 welfareMall
export function jprizeUserPrizeUserQPage(params = { page: 1, limit: 10, prizeType: 0 }) {
  return request('POST', 'trade/ma/jprizeUserPrizeUserQPage/1.0', params);
}
/**
 * 福利商城搜索历史
 * @param status 状态 详见storageFnc方法
 * @param lists 原搜索历史列表
 * @param keyword 字段
 */
export function storageSearchWMHistory(status = 'save', lists = [], keyword = null, expires = null) {
  lists.unshift(keyword);

  // 数组去重
  function unique(arr) {
    const res = [];
    const json = {};
    for (let i = 0; i < arr.length; i++) {
      if (!json[arr[i]]) {
        res.push(arr[i]);
        json[arr[i]] = 1;
      }
    }
    return res;
  }
  // 移除相同的搜索历史
  lists = unique(lists);

  // 最多保存10条
  if (lists.length >= 10) {
    lists.splice(10, 1);
  }
  return storageFnc('searchWMHistory', status, lists, expires);
}
/**
 * 福利商城热门搜索 welfareMall
 */
export function requestWMHotWordsList() {
  return request('GET', 'sys/ma/keyWordDetail/1.0');
}
/**
 * 缓存商城搜索历史
 * @param lists 原搜索历史列表
 * @param keyword 搜索字段
 */
export function storageSearchHistory(status = 'save', lists = [], keyword = null, expires = null) {
  lists.unshift(keyword);

  // 数组去重
  function unique(arr) {
    const res = [];
    const json = {};
    for (let i = 0; i < arr.length; i++) {
      if (!json[arr[i]]) {
        res.push(arr[i]);
        json[arr[i]] = 1;
      }
    }
    return res;
  }
  // 移除相同的搜索历史
  lists = unique(lists);

  // 最多保存10条
  if (lists.length >= 10) {
    lists.splice(10, 1);
  }
  return storageFnc('searchHistory', status, lists, expires);
}
// 福利商城 我的大奖 winning
export function jfMallOrderSysQPage(params = { jCondition: {}, limit: 10, page: 1 }) {
  return request('POST', 'trade/ma/jfMallOrderSysQPage/1.0', params);
}
// 确认分享 welfareMall
export function jOrderDoShare(params = { sequenceId: '' }) {
  return request('POST', 'trade/ma/jOrderDoShare/1.0', params);
}
// 福利商城 已完成订单 已晒单 获取中奖晒单信息 welfareMall
export function detailJLottery(params = { orderId: '', userId: '' }) {
  return request('POST', 'trade/ma/detailJLottery/1.0', params);
}
/**
 * 福利商城 获取订单列表 welfareMall
 */
export function qureyWMOrderList(params = { page: 1, limit: 10, status: 1 }, callback = () => { }) {
  return request('POST', 'trade/ma/jfMallOrderQPage/1.0', params);
}
// 福利商城 最新揭晓 所有用户参与的抽奖列表，包括已开奖和未开奖 welfareMall/winning
export function bestNewJGoodsQPage(params = { page: 1, limit: 10 }, callback = () => { }) {
  return request('GET', 'goods/ma/bestNewJGoodsQPage/1.0', params);
}

// 福利商城 我的夺奖数量
export function notfinishedSequenceNum(params = {}, callback = () => { }) {
  return request('GET', 'goods/ma/notfinishedSequenceNum/2.0.12', params, false);
}
// 福利商城 提醒发货
export function jOrderReminderShipment(params = {}, callback = () => { }) {
  return request('GET', 'trade/ma/jOrderReminderShipment/1.0', params, false);
}
