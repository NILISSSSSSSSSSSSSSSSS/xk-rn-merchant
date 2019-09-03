/**
 * 请求api
 */
import request from '../request';
import { storageFnc } from './commonApi'
// 搜索结果页，属性筛选
export function filterAttrList (params = { keywords: '' }) {
    return request('POST', 'goods/ma/filterAttrList/1.0', params)
}
/**
 mall 收货地址  merchantInfo/wholesaleMall
 */
// 列表 merchantInfo/wholesaleMall/winning
export function merchantShopAddrQPage(params) {
    return request('POST', 'user/ma/merchantShopAddrQPage/1.0', params)
}
// 详情 merchantInfo/wholesaleMall
export function merchantShopAddrDetail(params) {
    return request('POST', 'user/ma/merchantShopAddrDetail/1.0', params)
}
// 新增 merchantInfo/wholesaleMall
export function merchantShopAddrCreate(params) {
    return request('POST', 'user/ma/merchantShopAddrCreate/2.0', params)
}
// 删除 merchantInfo/wholesaleMall
export function merchantShopAddrDelete(params) {
    return request('POST', 'user/ma/merchantShopAddrDelete/1.0', params)
}
// 设为默认 merchantInfo/wholesaleMall
export function merchantShopAddrUpdateDefault(params) {
    return request('POST', 'user/ma/merchantShopAddrUpdateDefault/1.0', params)
}
// 取消默认 merchantInfo/wholesaleMall
export function merchantShopAddrUpdateNotDefault(params) {
    return request('POST', 'user/ma/merchantShopAddrUpdateNotDefault/1.0', params)
}
// 修改 merchantInfo/wholesaleMall
export function merchantShopAddrUpdate(params) {
    return request('POST', 'user/ma/merchantShopAddrUpdate/2.0', params)
}

/**
 * wholesaleMall
 */
// 商城订单详情 wholesaleMall/accountFinance
export function queryMallOrderDetail(params = { orderId: '' }) {
    return request('GET', 'trade/ma/mallOrderDetail/1.0', params);
}
//商圈订单详情
export function shopOrderDetail(params) {
    return request('GET', 'goods/ma/shopOrderDetail/1.0', params)
}
// 统一的收银台发起支付 wholesaleMall/accountFinance
export function uniPayment(params = {}) {
    return request('POST', 'trade/ma/uniPayment/1.0', params);
}
// 自营支付取消
export function mallOrderMUserCancelPay(params = { payId: '' }) {
    return request('POST', 'trade/ma/mallOrderMUserCancelPay/1.0', params);
}
// 取消收藏
export function requestxkFavoriteDelete(params = {}, success = () => { }, fail = () => { }) {
    return request('GET', 'user/ma/xkFavoriteDelete/1.0', params).then(res => {
        success(res);
    }).catch(e => {
        fail(e);
    });
}
// 获取评论标签
export function requestMallGoodsCommentLabels(params = { goodsId: '' }, callback = () => { }) {
    return request('GET', 'im/ma/mallGoodsCommentLabels/1.0', params).then(res => {
        callback(res);
    });
}
// 获取评论列表
export function requestMallGoodsCommentList(params = { page: 1, limit: 10, goodsId: '', type: '' }, success = () => { }, fail = () => { }) {
    return request('GET', 'im/ma/mallGoodsCommentList/1.0', params).then(res => {
        success(res);
    }).catch(e => {
        fail(e);
    });
}
// 自营商城 商品详情
export function goodsDetail(params = { shopId: '' }) {//自定义分类
    return request('POST', 'goods/ma/goodsDetail/2.0', params);
}
/**
 * 商品加入购物车
 * @param {*} params
 * @param merchantId  商户id
 * @param goodsId  商品id
 * @param goodsSkuCode  商品skuCode
 * @param {*} callback
 */
export function requestMallCartCreate(params = { merchantId: '', goodsId: '', goodsSkuCode: '', quantity: '' }, callback = () => { }) {
    return request('GET', 'goods/ma/mallCartCreate/1.0', params).then(res => {
        callback(res);
    });
}
// 自营分享模板
export function promotionTemplateQList(params = { goodsId: '' }) {
    return request('GET', 'goods/ma/promotionTemplateQList/1.0', params);
}
// 自营商城推荐商品  wholesaleMall
export function requestMallGoodsRecommendSGoodsQPage(params = { page: 1, limit: 10, condition: { address: '' } }) {
    return request('GET', 'goods/ma/mallGoodsRecommendSGoodsQPage/2.0', params);
}
/**
 * 根据商品类目查询商品 或 搜索商品
 * @param {*} page 页数
 * @param {*} limit 条数
 * @param {*} category 商品类别ID
 * @param {*} keyword 关键字，多个以空格分开
 * @param {*} type 排序字段，如：popularity 人气 saleQ 销量 price 价格 default 推荐
 * @param {*} isDesc 1 降序 0 升序
 */
export function requestSearchGoodsList(param) {
    return request('GET', 'goods/ma/goodsQPage/2.0', param);
}
/**
 * 缓存自营商城个人分类
 */
export function storageSOMCateLists(status = 'save', data = null, expires = null) {
    return storageFnc('SOMCateLists', status, data, expires);
}
//获取支付金额
export function mallOrderMUserValidateAmount(params) {//修改
    return request('POST', 'trade/ma/mallOrderMUserValidateAmount/1.0', params)
}
// 获取默认发票
export function merchantDefaultInvoice(params) {
    return request('POST', 'user/ma/merchantDefaultInvoice/1.0', params, false)
}
// 获取订单可以使用的优惠券
export function findMUserCoupons(params) {//修改
    return request('POST', 'trade/ma/findMUserCoupons/1.0', params, false)
}
// 商城下单
export function createOrder(params = {}) {
    return request('POST', 'trade/ma/mallOrderMUserCreate/1.0', params);
}
// 自营商城 订单列表支付
export function mallOrderMUserPay(params = { orderId: '' }) {
    return request('POST', 'trade/ma/mallOrderMUserPay/1.0', params);
}
// 商城取消退款
export function mallOrderMUserRefundCancel(params = { refundId: '' }) {
    return request('POST', 'trade/ma/mallOrderMUserRefundCancel/1.0', params);
}
// 确认收货
export function mallOrderMUserConfirmReceive(params = { orderId: '' }) {
    return request('GET', 'trade/ma/mallOrderMUserConfirmReceive/1.0', params);
}
// 商城评价发布
export function mallGoodsCommentCreate(params = { refundId: '' }) {
    return request('POST', 'im/ma/mallGoodsCommentCreate/1.0', params);
}
// 商城订单列表取消订单
export function queryCancelOrder(params = { orderId: '' }) {
    return request('GET', 'trade/ma/mallOrderMUserCancel/1.0', params);
}
// 商城售后进度详情
export function mallOrderRefundDetail(params = { refundId: '' }) {
    return request('GET', 'trade/ma/mallOrderRefundDetail/1.0', params);
}
// 获取售后原因列表
export function fetchMallRefundReasonList(params = { xkModule: 'mall', type: 1 }) {
    return request('GET', 'trade/ma/refundReasonQList/1.0', params);
}
// 退款申请
export function mallOrderMUserRefund(params = { mallRefundOrderParams: {} }) {
    return request('GET', 'trade/ma/mallOrderMUserRefund/1.0', params, false);
}
// 退货提交物流信息
export function mallOrderMUserRefundUploadLogistice(params = { refundId: '' }) {
    return request('GET', 'trade/ma/mallOrderMUserRefundUploadLogistice/1.0', params);
}
/**
 * 获取所有商品分类 wholesaleMall
 */
export function requestGoodsCategoryLists(params = {}) {
    return request('GET', 'goods/ma/queryMallCategory/1.0', params);
}
// 自营商场首页Icon列表  wholesaleMall
export function requestSOMScategoryQList(params = {}) {
    return request('GET', 'sys/ma/scategoryQList/1.0', params);
}
/**
 * 热词
 */
export function requestHotWordsList() {
    return request('GET', 'sys/ma/keyWordDetail/1.0');
}
// 品牌详情
export function brandShopDetail(params = {}) {
    return request('GET', 'goods/ma/brandShopDetail/1.0', params);
}
// 品牌banner
export function brandShopBanner(params = {}) {
    return request('GET', 'goods/ma/brandShopBanner/1.0', params);
}
/**
 * 批量修改购物车商品数量
 * @param {*} data 购物车列表数据
 */
export function requestMallCartBatchUpdate(data) {
    let params = {
        cart: []
    };
    for (let i = 0; i < data.length; i++) {
        params.cart.push({
            id: data[i].id,
            quantity: data[i].quantity,
        });
    }
    return request('GET', 'goods/ma/mallCartBatchUpdate/1.0', params);
}
/**
 * 商品关联优惠券列表
 * @param {*} params
 * @param goodsId  商品id
 * @param lastUpdatedAt  最后更新时间戳
 */
export function requestMallCardGoodsList(params = { goodsId: '', lastUpdatedAt: '' }, callback = () => { }) {
    // 不需要翻页
    params = {
        page: 1,
        limit: 999999999,
        ...params
    }
    return request('GET', 'goods/ma/mallCardGoodsQList/1.0', params).then(res => {
        callback(res);
    });
}
/**
 * 批量删除购物车商品
 * @param {*} data 购物车列表数据
 */
export function requestMallCartBatchDestory(data, callback = () => { }) {
    let params = {
        ids: []
    };
    for (let i = 0; i < data.length; i++) {
        params.ids.push(data[i].id);
    }
    return request('GET', 'goods/ma/mallCartBatchDestory/1.0', params).then(res => {
        callback(res);
    });
}
/**
 * 购物车商品批量移入收藏
 * @param {*} data 购物车列表数据
 */
export function requestMallCartMoveToCollect(data, callback = () => { }) {
    let params = {
        ids: []
    };
    for (let i = 0; i < data.length; i++) {
        params.ids.push(data[i].id);
    }
    return request('GET', 'goods/ma/mallCartMoveToCollect/1.0', params).then(res => {
        callback(res);
    });
}
//领取优惠券
export function mallCouponUserDraw(params) {//修改
    return request('POST', 'trade/ma/mallCouponUserDraw/1.0', params)
}
/**
 * 请求购物车列表
 * @param {*} params
 * @param merchantId  商户id
 * @param {*} callback
 */
export function requestMallCartList(params = { merchantId: '' }) {
    // 购物车列表不需要翻页
    params = {
        page: 1,
        limit: 999999999,
        ...params
    }
    return request('GET', 'goods/ma/mallCartList/1.0', params);
}
// 商城订单列表
export function fetchMallOrderList(params = { orderStatus: '', limit: 10, page: 1 }) {
    return request('GET', 'trade/ma/mallOrderQPage/1.0', params);
}
// 商城售后列表
export function fetchMallRefundOrderList(params = { orderStatus: '', limit: 10, page: 1 }) {
    return request('GET', 'trade/ma/mallOrderQPageRefund/1.0', params);
}
// 退款金额获取
export function sOrderRefundApplyAmount(params = { orderId: '', itemIds: [] }) {
    return request('GET', 'trade/ma/sOrderRefundApplyAmount/1.0', params);
}
// 自营商城 分享后台确认
export function generalizedRecordCreate(params = { generalizeShareRecord: {} }) {//自定义分类
    return request('POST', 'trade/ma/generalizedRecordCreate/1.0', params);
}


// 商品意见反馈 wholesaleMall/defaultAPP
export function requestGoodsFeedbackCreate(params, callback = () => { }) {
    return request('POST', 'sys/ma/goodsFeedbackCreate/1.0', params).then(res => {
        callback();
    });
}
// 个人意见反馈 wholesaleMall/defaultAPP
export function requestPersonalFeedbackCreate(params, callback = () => { }) {
    return request('POST', 'sys/ma/personalFeedbackCreate/1.0', params).then(res => {
        callback();
    });
}
// 提醒发货

export function mallOrderRemindShipping(params, callback = () => { }) {
    return request('POST', 'trade/ma/mallOrderRemindShipping/1.0', params).then(res => {
        callback();
    });
}
