/**
 * 请求api
 */
import request from '../request';
/** 订单列表 order */
export function fetchbcleOBMOrderAppQPage(params) {
  return request('POST', 'trade/ma/bcleOBMOrderAppQPage/1.0', params);
}
/** 售后订单列表 order */
export function fetchbcleOBMRefundOrderAppQPage(params) {
  return request('POST', 'trade/ma/bcleOBMRefundOrderAppQPage/1.0', params);
}

/** 获取订单列表统计数据 */ // 如果这个接口要使用，请添加到后台资源权限
export function countOrderStatusNumbers(params) {
  return request('POST', 'trade/ma/countOrderStatusNumbers/2.0.12', params);
}

/** 售后订单 order/offlineOrder */
export function fetchOBMBcleOrderMuserAppDetail(params) {
  return request('POST', 'trade/ma/OBMBcleOrderMuserAppDetail/1.0', params);
}
/** 修改并接单订单 order */
export function fetchShopAgreeUpdateOrder(params) {
  return request('POST', 'trade/ma/shopAgreeUpdateOrder/1.0', params);
}
/** 取消订单 order */
export function fetchMUserCancelOrder(params) {
  return request('POST', 'trade/ma/mUserCancelOrder/1.0', params);
}
/** 席位分类 order/seat */
export function fetchMSeatStatistics(params) {
  return request('POST', 'goods/ma/mSeatStatistics/1.0', params);
}
/** 席位列表 order/seat */
export function fetchMSeatList(params) {
  return request('POST', 'goods/ma/mSeatList/1.0', params);
}
/** 商品列表 offlineOrder order */
export function fetchshopGoodsClassificationQList(params) {
  return request('POST', 'goods/ma/shopGoodsClassificationQList/1.0', params);
}
/** 商品分类列表 offlineOrder/category/commodity/order */
export function fetchQListByServiceCatalogCode(params) {
  return request('POST', 'sys/ma/qListByServiceCatalogCode/1.0', params);
}

/** 商品规格 offlineOrder/category/commodity/order */
export function fetchShopGoodsSkuQList(params) {
  return request('POST', 'trade/ma/shopGoodsSkuQList/1.0', params);
}

/** 未修改接单 order */
export function fetcShopAgreeOrder(params) {
  return request('POST', 'trade/ma/shopAgreeOrder/1.0', params);
}

/** 批量删除订单接单 order */
export function fetchShopPurchaseOrderMUserBatchDelete(params) {
  return request('POST', 'trade/ma/shopPurchaseOrderMUserBatchDelete/1.0', params);
}

/** 批量接单 order */
export function fetchShopPurchaseOrderBatchAccept(params) {
  return request('POST', 'trade/ma/shopPurchaseOrderBatchAccept/1.0', params);
}

/** 消费码消费 order */
export function fetchBcleMUserConfirmConsume(params) {
  return request('POST', 'trade/ma/bcleMUserConfirmConsume/1.0', params);
}

/** 结算 order */
export function fetchBcleMUserConfirmClearing(params) {
  return request('POST', 'trade/ma/bcleMUserConfirmClearing/1.0', params);
}

/** 加购保存数据 order */
export function fetchShopPurchaseOrderMUserCreate(params) {
  return request('POST', 'trade/ma/shopPurchaseOrderMUserCreate/1.0', params);
}


/** 获取结算列表 order */
export function fetchBcleOBMOrderStayClearingAppDetail(params) {
  return request('POST', 'trade/ma/bcleOBMOrderStayClearingAppDetail/1.0', params);
}

/** 备货完成 order */
export function fetchBcleMUserReadyComplete(params) {
  return request('POST', 'trade/ma/bcleMUserReadyComplete/1.0', params);
}

/** 外卖送达 order */
export function fetchMUserConfirmDelivery(params) {
  return request('POST', 'trade/ma/mUserConfirmDelivery/1.0', params);
}

/** 商户同意退款 order */
export function fetchShopOrderRefundOrCancelAgree(params) {
  return request('POST', 'trade/ma/shopOrderRefundOrCancelAgree/1.0', params);
}

/** 拒绝部分退款 order */
export function fetchShopOrderRefundOrCancelRefuse(params) {
  return request('POST', 'trade/ma/shopOrderRefundOrCancelRefuse/1.0', params);
}

/** 下单 offlineOrder/order */
export function fetchBcleMUserOrderCreate(params) {
  return request('POST', 'trade/ma/bcleMUserOrderCreate/1.0', params);
}

/** 售后详情 order */
export function fetchOBMBcleRefundOrderDetail(params) {
  return request('POST', 'trade/ma/OBMBcleRefundOrderDetail/1.0', params);
}

/** 全部同意或全部拒绝退款 order */
export function fetchMUserAgreeOrRejectCancelOrder(params) {
  return request('POST', 'trade/ma/mUserAgreeOrRejectCancelOrder/1.0', params);
}

/** 订单搜索 order */
export function fetchBcleDetailByOrderIdAndMerchantId(params) {
  return request('POST', 'trade/ma/bcleDetailByOrderIdAndMerchantId/1.0', params);
}

/** 选择晓可配送 order */
export function fetchMerchantNearbyRiderCache(params) {
  return request('POST', 'user/ma/merchantNearbyRiderCache/1.0', params);
}

/** 商户绑定骑手列表 order */
export function fetchMerchantRiderQList(params) {
  return request('POST', 'user/ma/merchantRiderQList/1.0', params);
}

/** 附近骑手 order */
export function fetchMerchantNearbyRiderQList(params) {
  return request('POST', 'user/ma/merchantNearbyRiderQList/1.0', params);
}

/** 派单 order */
export function fetchMerchantDispatchOrder(params) {
  return request('POST', 'user/ma/merchantDispatchOrder/1.0', params);
}

/** 派单后订单详情 order */
export function fetchMerchantOrderDetail(params) {
  return request('POST', 'user/ma/merchantOrderDetail/1.0', params);
}

/** 席位是否被占用 order */
export function fetchBcleUserVerifierOrderSeat(params) {
  return request('POST', 'trade/ma/bcleUserVerifierOrderSeat/1.0', params);
}

/** 体积物流 order */
export function fetchMerchantCalcPrice(params) {
  return request('POST', 'user/ma/merchantCalcPrice/1.0', params);
}

/** 保存第三方物流 order */
export function fetchmUserUploadLogistics(params) {
  return request('POST', 'trade/ma/mUserUploadLogistics/1.0', params);
}

/** 查看第三方物流 order */
export function fetchlogisticsQuery(params) {
  return request('GET', 'sys/ma/logisticsQuery/1.0', params);
}
/** 取消物流 order */
export function mUserCancelLogistics(params) {
  return request('GET', 'trade/ma/mUserCancelLogistics/1.0', params);
}

/** 取消物流订单 order */
export function fetchmerchantCancelOrder(params) {
  return request('POST', 'user/ma/merchantCancelOrder/1.0', params);
}

/** 派单上限次数 order */
export function fetgiftCreate(params) {
  return request('GET', 'user/ma/merchantExceptionOrderNum/1.0', params);
}

/** 晓可物流订单列表 order */
export function fetchmerchantOrderQPage(params) {
  return request('GET', 'user/ma/merchantOrderQPage/1.0', params);
}

/** 达到上限以后 order */
export function fetchmerchantCreateExceptionOrder(params) {
  return request('GET', 'user/ma/merchantCreateExceptionOrder/1.0', params);
}

/** 查询派单清单详情byid order */
export function fetchmerchantDetailByRiderOrderNo(params) {
  return request('GET', 'user/ma/merchantDetailByRiderOrderNo/1.0', params);
}

/** 客户联系客服 order */
export function mCustomerServiceContactUser(params = { }) {
  return request('POST', 'im/ma/mCustomerServiceContactUser/1.0', params);
}
