/**
 * 店铺订单请求api
 */
import request from '../request'



export function fetchbcleOBMOrderAppQPage(params) {
    return request('POST', 'trade/ma/bcleOBMOrderAppQPage/1.0', params);
}

export function fetchbcleOBMRefundOrderAppQPage(params) {
    return request('POST', 'trade/ma/bcleOBMRefundOrderAppQPage/1.0', params);
}


export function fetchOBMBcleOrderMuserAppDetail(params) {
    return request('POST', 'trade/ma/OBMBcleOrderMuserAppDetail/1.0', params);
}

//修改并接单订单
export function fetchShopAgreeUpdateOrder(params) {
    return request('POST', 'trade/ma/shopAgreeUpdateOrder/1.0', params);
}
//取消订单
export function fetchMUserCancelOrder(params) {
    return request('POST', 'trade/ma/mUserCancelOrder/1.0', params);
}

//席位分类
export function fetchMSeatStatistics(params) {
    return request('POST', 'goods/ma/mSeatStatistics/1.0', params);
}
//席位列表
export function fetchMSeatList(params) {
    return request('POST', 'goods/ma/mSeatList/1.0', params);
}

//商品列表
export function fetchshopGoodsClassificationQList(params) {
    return request('POST', 'goods/ma/shopGoodsClassificationQList/1.0', params);
}
//商品分类列表
export function fetchQListByServiceCatalogCode(params) {
    return request('POST', 'sys/ma/qListByServiceCatalogCode/1.0', params);
}

//商品规格
export function fetchShopGoodsSkuQList(params) {
    return request('POST', 'trade/ma/shopGoodsSkuQList/1.0', params);
}

//未修改接单
export function fetcShopAgreeOrder(params) {
    return request('POST', 'trade/ma/shopAgreeOrder/1.0', params);
}

//批量删除订单接单
export function fetchShopPurchaseOrderMUserBatchDelete(params) {
    return request('POST', 'trade/ma/shopPurchaseOrderMUserBatchDelete/1.0', params);
}

//批量接单
export function fetchShopPurchaseOrderBatchAccept(params) {
    return request('POST', 'trade/ma/shopPurchaseOrderBatchAccept/1.0', params);
}

//消费码消费
export function fetchBcleMUserConfirmConsume(params) {
    return request('POST', 'trade/ma/bcleMUserConfirmConsume/1.0', params);
}

//结算
export function fetchBcleMUserConfirmClearing(params) {
    return request('POST', 'trade/ma/bcleMUserConfirmClearing/1.0');
}

//加购保存数据
export function fetchShopPurchaseOrderMUserCreate(params) {
    return request('POST', 'trade/ma/shopPurchaseOrderMUserCreate/1.0', params);
}


//获取结算列表
export function fetchBcleOBMOrderStayClearingAppDetail(params) {
    return request('POST', 'trade/ma/bcleOBMOrderStayClearingAppDetail/1.0', params);
}

//备货完成
export function fetchBcleMUserReadyComplete(params) {
    return request('POST', 'trade/ma/bcleMUserReadyComplete/1.0', params);
}

//外卖送达
export function fetchMUserConfirmDelivery(params) {
    return request('POST', 'trade/ma/mUserConfirmDelivery/1.0', params);
}

//商户同意退款
export function fetchShopOrderRefundOrCancelAgree(params) {
    return request('POST', 'trade/ma/shopOrderRefundOrCancelAgree/1.0', params);
}

// 拒绝部分退款
export function fetchShopOrderRefundOrCancelRefuse(params) {
    return request('POST', 'trade/ma/shopOrderRefundOrCancelRefuse/1.0', params);
}

//下单
export function fetchBcleMUserOrderCreate(params) {
    return request('POST', 'trade/ma/bcleMUserOrderCreate/1.0', params);
}

//售后详情
export function fetchOBMBcleRefundOrderDetail(params) {
    return request('POST', 'trade/ma/OBMBcleRefundOrderDetail/1.0', params);
}

//全部同意或全部拒绝退款
export function fetchMUserAgreeOrRejectCancelOrder(params) {
    return request('POST', 'trade/ma/mUserAgreeOrRejectCancelOrder/1.0', params);
}

//订单搜索
export function fetchBcleDetailByOrderIdAndMerchantId(params) {
    return request('POST', 'trade/ma/bcleDetailByOrderIdAndMerchantId/1.0', params);
}

//选择晓可配送
export function fetchMerchantNearbyRiderCache(params) {
    return request('POST', 'user/ma/merchantNearbyRiderCache/1.0', params);
}

//商户绑定骑手列表
export function fetchMerchantRiderQList(params) {
    return request('POST', 'user/ma/merchantRiderQList/1.0', params);
}

//附近骑手
export function fetchMerchantNearbyRiderQList(params) {
    return request('POST', 'user/ma/merchantNearbyRiderQList/1.0', params);
}

//派单
export function fetchMerchantDispatchOrder(params) {
    return request('POST', 'user/ma/merchantDispatchOrder/1.0', params);
}

//派单后订单详情
export function fetchMerchantOrderDetail(params) {
    return request('POST', 'user/ma/merchantOrderDetail/1.0', params);
}

//席位是否被占用
export function fetchBcleUserVerifierOrderSeat(params) {
    return request('POST', 'trade/ma/bcleUserVerifierOrderSeat/1.0', params);
}

// 体积物流
export function fetchMerchantCalcPrice(params) {
    return request('POST', 'user/ma/merchantCalcPrice/1.0', params);
}

//保存第三方物流
export function fetchmUserUploadLogistics(params) {
    return request('POST', 'trade/ma/mUserUploadLogistics/1.0', params);
}

//查看第三方物流
export function fetchlogisticsQuery(params) {
    return request('GET', 'sys/ma/logisticsQuery/1.0', params)
}
//取消物流
export function mUserCancelLogistics(params) {
    return request('GET', 'trade/ma/mUserCancelLogistics/1.0', params)
}

//取消物流订单
export function fetchmerchantCancelOrder(params) {
    return request('POST', 'user/ma/merchantCancelOrder/1.0', params)
}

//派单上限次数
export function fetgiftCreate(params) {
    return request('GET', 'user/ma/merchantExceptionOrderNum/1.0', params)
}

//晓可物流订单列表
export function fetchmerchantOrderQPage(params) {
    return request('GET', 'user/ma/merchantOrderQPage/1.0', params)
}

//达到上限以后
export function fetchmerchantCreateExceptionOrder(params) {
    return request('GET', 'user/ma/merchantCreateExceptionOrder/1.0', params)
}

//查询派单清单详情byid
export function fetchmerchantDetailByRiderOrderNo(params) {
    return request('GET', 'user/ma/merchantDetailByRiderOrderNo/1.0', params)
}

// 客户联系客服
export function mCustomerServiceContactUser(params = {  }) {
    return request('POST', 'im/ma/mCustomerServiceContactUser/1.0', params)
}
