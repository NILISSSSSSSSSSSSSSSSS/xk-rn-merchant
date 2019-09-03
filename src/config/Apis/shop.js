
/**
 * 请求api
 */
import request from '../request';

/**
 * 授权管理
 */
// 获取当前登录店铺绑定状态 gave
export function shopIsBind(params = { id: '' }) {
  return request('POST', 'goods/ma/shopIsBind/1.0', params, false);
}
// 获取下级直属店铺 gave
export function getRoleManagerShopList(params = '', callback = () => { }) {
  return request('POST', 'goods/ma/mShopQMerchantSlefShop/1.0', params).then((res) => {
    callback(res);
  });
}
// 数据提交 gave
export function submitRoleList(params = '', callback = () => { }) {
  return request('POST', 'user/ma/shopBindCodeCreate/1.0', params).then((res) => {
    callback(res);
  });
}

/**
 * 品类管理
 */
// 列表 category
export function goodsCatalogList(params = { shopId: '' }) { // 自定义分类
  return request('POST', 'sys/ma/goodsCatalogList/1.0', params);
}
// 创建 category
export function goodsCatalogCreate(params = { shopId: '' }) { // 自定义分类
  return request('GET', 'sys/ma/goodsCatalogCreate/1.0', params);
}
// 删除 category
export function goodsCatalogDelete(params = { shopId: '' }) { // 自定义分类
  return request('GET', 'sys/ma/goodsCatalogDelete/1.0', params);
}
// 修改 category
export function goodsCatalogUpdate(params = { shopId: '' }) { // 自定义分类
  return request('POST', 'sys/ma/goodsCatalogUpdate/1.0', params);
}
//店铺一级分类别名列表
export function shopCatalogAliasQueryAll(params = {  }) { // 自定义分类
  return request('GET', 'goods/ma/shopCatalogAliasQueryAll/2.1.0', params);
}
//店铺分类别名修改别名排序
export function shopCatalogAliasUpdateAll(params = { }) { // 自定义分类
  return request('POST', 'goods/ma/shopCatalogAliasUpdateAll/2.1.0', params);
}


/**
 *  评价管理
 */
// evaluate / commodity
export function bcleGoodsCommentList4Merchant(params) {
  return request('POST', 'im/ma/bcleGoodsCommentList4Merchant/1.0', params);
}
// evaluate
export function bcleGoodsCommentReplyList(params) {
  return request('POST', 'im/ma/bcleGoodsCommentReplyList/1.0', params);
}
// evaluate
export function bcleGoodsCommentMerchantReply(params) {
  return request('POST', 'im/ma/bcleGoodsCommentMerchantReply/1.0', params);
}
/**
 * 数据中心 statistics
 */
export function fetchshopOrderData(params) {
  return request('POST', 'trade/ma/shopOrderDataApp/1.0', params);
}
/**
 * 财务中心 shopFinance
 */
export function fetchshopOrderDataQPage(params) {
  return request('POST', 'trade/ma/shopOrderDividedStatistics/1.0', params);
}
// 财务中心 详情
export function shopOrderSettleDetail(params) {
  return request('POST', 'trade/ma/shopOrderSettleDetail/1.0', params);
}
/**
 * 运费管理
 */
// 查询列表 freight
export function mUserPostFeeQList(params) {
  return request('GET', 'goods/ma/mUserPostFeeQList/1.0', params);
}
// 修改运费模板 freight
export function mUserPostFeeUpdate(params) {
  return request('POST', 'goods/ma/mUserOBMPostFeeUpdate/1.0', params);
}
/**
 * 商品管理 commodity
 */
// 详情 commodity
export function shopOBMDetail(params = {}) {
  return request('POST', 'goods/ma/shopOBMDetail/1.0', params);
}
// 商品新增店铺分类 commodity
export function shopAndCatalogQList(params = {}) {
  return request('POST', 'goods/ma/shopAndCatalogQList/1.0', params);
}
// 商品下架 commodity
export function shopOBMUnshelve(params = {}) {
  return request('POST', 'goods/ma/shopOBMUnshelve/1.0', params);
}
// 商品上架 commodity
export function shopOBMAdded(params = {}) {
  return request('POST', 'goods/ma/shopOBMAdded/1.0', params);
}
// 删除商品 commodity
export function xkShopGoodsDelete(params = {}) {
  return request('POST', 'goods/ma/xkShopGoodsDelete/1.0', params);
}
/**
 * 根据品类查询商品列表 commodity
 */
export function goodsQList(params = {}) {
  return request('POST', 'goods/ma/goodsQList/1.0', params);
}

// 店铺折扣查询 commodity
export function mShopDiscount(params = {}) {
  return request('POST', 'goods/ma/mShopDiscount/1.0', params);
}
/**
 * 新增商圈商品 commodity
 */
export function shopGoodsCreate(params = {}) {
  return request('POST', 'goods/ma/shopGoodsCreate/1.0', params);
}
/**
 * 编辑商圈商品 commodity
 */
export function shopGoodsUpdate(params = {}) {
  return request('POST', 'goods/ma/shopGoodsUpdate/1.0', params);
}

/**
 * 会员卡新增 promotion
 */
export function addShopCard(params = {}) {
  return request('GET', 'goods/ma/shopMemberCardCreate/1.0', params);
}
/**
 * 优惠券新增 promotion
 */
export function shopCardCreate(params = {}) {
  return request('GET', 'goods/ma/shopCardCreate/1.0', params);
}
/**
 * 会员卡详情 promotion
 */
export function mUserCardMemberDetail(params = { shopId: '' }) {
  return request('GET', 'goods/ma/mUserCardMemberDetail/1.0', params);
}
/**
 * 优惠券详情 promotion
 */
export function mUserCardCouponDetail(params = { shopId: '' }) {
  return request('GET', 'goods/ma/mUserCardCouponDetail/1.0', params);
}
/**
 * 会员卡作废 promotion
 */
export function mUserCardMemberDelete(params = { shopId: '' }) {
  return request('GET', 'goods/ma/mUserCardMemberDelete/1.0', params);
}
/**
 * 优惠券作废 promotion
 */
export function mUserCardCouponDelete(params = { shopId: '' }) {
  return request('GET', 'goods/ma/mUserCardCouponDelete/1.0', params);
}
/**
 * 店铺所有会员卡列表 promotion
 */
export function getShopCards(params = { storeId: '' }) {
  return request('GET', 'goods/ma/mUserCardMemberQPage/1.0', params);
}
/**
 * 店铺所有优惠券列表 promotion
 */
export function mUserCardCouponQPage(params = { shopId: '' }) {
  return request('GET', 'goods/ma/mUserCardCouponQPage/1.0', params);
}
/**
 * 会员卡领卡用户明细 promotion
 */
export function shopListMember(params = {}) {
  return request('GET', 'goods/ma/shopListMember/1.0', params);
}
/**
 * 优惠券领卡用户明细 promotion
 */
export function shopListCoupon(params = {}) {
  return request('GET', 'goods/ma/shopListCoupon/1.0', params);
}
/**
 * 单品优惠券 accountFinance
 */
export function shopAppUserCouponQPage(params = {}) {
  return request('GET', 'trade/ma/shopAppUserCouponQPage/1.0', params);
}
// 手机号查询主播详情 promotion
export function anchorDetail(params = {}) {
  return request('POST', 'user/ma/anchorDetail/1.0', params);
}
/**
 * 促销品类选择列表 promotion
 */
export function shopOBMQListBcleGoodsCode(params = {}) {
  return request('GET', 'goods/ma/shopOBMQListBcleGoodsCode/1.0', params);
}
/**
 * 促销商品选择列表 promotion
 */
export function shopOBMQListBcleGoods(params = {}) {
  return request('GET', 'goods/ma/shopOBMQListBcleGoods/1.0', params);
}

// 店铺席位
/**
 * 新增席位 seat
 */
export function mSeatCreate(params = {
 shopId: '', name: '', usedTemplate: 0, count: 1
}) {
  return request('POST', 'goods/ma/mSeatCreate/1.0', params);
}
/**
 * 删除席位 seat
 */
export function mSeatDelete(params = { shopId: '' }) {
  return request('POST', 'goods/ma/mSeatDelete/1.0', params);
}

/**
 * 修改席位 seat
 */
export function mSeatUpdate(params) {
  return request('POST', 'goods/ma/mSeatUpdate/1.0', params);
}
/**
 * 席位列表 seat
 */
export function mSeatList(params) {
  return request('POST', 'goods/ma/mSeatList/1.0', params);
}
/**
 * 席位分类统计 seat
 */
export function mSeatStatistics(params) {
  return request('POST', 'goods/ma/mSeatStatistics/1.0', params);
}
/**
 * 席位批量创建 seat
 */
export function mSeatBatchCreate(params) {
  return request('POST', 'goods/ma/mSeatBatchCreate/1.0', params);
}
// 席位分类创建  seat
export function mSeatTypeCreate(params = { shopId: '', name: '' }) {
  return request('POST', 'goods/ma/mSeatTypeCreate/1.0', params);
}
// 席位分类删除 seat
export function mSeatTypeDelete(params = { shopId: '' }) {
  return request('POST', 'goods/ma/mSeatTypeDelete/1.0', params);
}

// 席位分类修改 seat
export function mSeatTypeUpdate(params = { shopId: '', name: '', id: '' }) {
  return request('POST', 'goods/ma/mSeatTypeUpdate/1.0', params);
}
// 席位分类列表 seat
export function mSeatTypeList(params) {
  return request('POST', 'goods/ma/mSeatTypeList/1.0', params);
}

/**
 * 店铺详情 editShop/shopManager/logistics/defaultAPP
 */
export function shopDetails(params = {}) {
  return request('POST', 'goods/ma/mShopDetail/1.0', params);
}
/**
 * 店铺升级权限 shopManager
 */
export function mShopUpgrade(params = {}) {
  return request('POST', 'goods/ma/mShopUpgrade/1.0', params);
}
/**
 * 绑定店铺 shopManager
 */
export function shopBind(params = {}) {
  return request('POST', 'goods/ma/shopBind/1.0', params);
}
/**
 * 解绑店铺 shopManager
 */
export function shopUnBind(params = {}) {
  return request('POST', 'goods/ma/shopUnBind/1.0', params);
}
/**
 * 查询商户下的主店 defaultAPP
 */
export function mercahntMasterShopIsExist(params = { merchantId: '' }) {
  return request('POST', 'user/ma/mercahntMasterShopIsExist/2.0.12', params);
}

/**
 * 授权码详情查询 shopManager
 */
export function bindCodeDetail(params = {}) {
  return request('POST', 'user/ma/bindCodeDetail/1.0', params);
}
/**
 * 店铺行业一级分类 editShop/shopManager
 */
export function industryLevelOneList(params = {}) {
  return request('POST', 'sys/ma/industryLevelOneList/1.0', params);
}
/**
 * 店铺行业全部分类 shopManager/defaultAPP
 */
export function industryAllQList(params = {}) {
  return request('POST', 'sys/ma/industryAllQList/2.0', params);
}
// 继续入驻查询店铺 shopManager/defaultAPP
export function merchantKeepenterShopDetail(params = {}) {
  return request('GET', 'user/ma/merchantKeepenterShopDetail/2.0', params, closeLoading = true, isEncrypt = true, timeout = 5000, toastWrong = false);
}
// c重新拓展店铺查询 shopManager/defaultAPP
export function merchantReextendShopDetail(params = {}) {
  return request('GET', 'user/ma/merchantReextendShopDetail/2.0', params, closeLoading = true, isEncrypt = true, timeout = 5000, toastWrong = false);
}
// 重新扩展身份创建店铺 shopManager/defaultAPP
export function merchantReextendCreateShop(params = {}) {
  return request('POST', 'user/ma/merchantReextendCreateShop/2.0', params);
}
// 扩展身份店铺创建 shopManager/defaultAPP
export function merchantEnterCreateShop(params = {}) {
  return request('POST', 'user/ma/merchantEnterCreateShop/2.0', params);
}
// 继续入驻创建店铺 shopManager/defaultAPP
export function merchantKeepenterCreateShop(params = {}) {
  return request('POST', 'user/ma/merchantKeepenterCreateShop/2.0', params);
}

// 新增店铺以后创建运费 shopManager/defaultAPP
export function fetchmUserOBMPostFeeCreate(params) {
  return request('GET', 'goods/ma/mUserOBMPostFeeCreate/1.0', params);
}
// 创建独立店铺 shopManager/defaultAPP
export function merchantIsolateCreateShop(params = {}) {
  return request('POST', 'user/ma/merchantIsolateCreateShop/2.0', params);
}
/**
 * 店铺创建 shopManager
 */
export function requestAddShop(params = {}) {
  return request('POST', 'goods/ma/mShopCreate/2.1.0', params);
}
/**
 * 修改管理员手机号—商户app
 */
// export function mShopUpdateAdminPone(params = {}) {
//     return request('POST', 'goods/ma/mShopUpdateAdminPone/1.0', params);
// }
/**
 * 下级店铺列表查询 shopManager/commodity
 */
export function mShopNextShopList(params = {}) {
  return request('POST', 'goods/ma/mShopNextShopList/1.0', params);
}
// 入驻协议查询 defaultAPP
export function merchantContractAgreement(params = {}) {
  return request('GET', 'sys/ma/platformPtotocolConfigUrl/1.0', params, closeLoading = true, isEncrypt = false);
}

// 店铺银行卡管理 merchantInfo/merchantProfit/merchantProfitData/accountFinance
/**
 * 列表 merchantInfo
 */
export function mBankCardPage(params = { limit: 10, page: 1 }) {
  return request('POST', 'user/ma/mBankCardPage/1.0', params);
}
/**
 * 新增 merchantInfo
 */
export function mBankCardCreate(params = {}) {
  return request('POST', 'user/ma/mBankCardCreate/1.0', params);
}
/**
 * 删除 merchantInfo
 */
export function mBankCardDelete(params = { id: '' }) {
  return request('POST', 'user/ma/mBankCardDelete/1.0', params);
}

/**
 * 修改 merchantInfo
 */
export function mBankCardUpdate(params = { id: '' }) {
  return request('POST', 'user/ma/mBankCardUpdate/1.0', params);
}
/**
 * 银行卡修改默认 merchantInfo
 */
export function mBankCardUpdateDefault(params = { id: '' }) {
  return request('POST', 'user/ma/mBankCardUpdateDefault/1.0', params);
}
/**
 * 根据银行卡号查询银行信息 merchantInfo
 */
export function bankCardBinDetail(params = { binNum: '' }) {
  return request('POST', 'sys/ma/bankCardBinDetail/1.0', params);
}
/**
 * 店铺开始接单 switch/commodity
 */
export function mShopBusiness(params = { id: '' }) {
  return request('POST', 'goods/ma/mShopBusiness/1.0', params);
}
/**
 * 店铺停止接单 switch/commodity
 */
export function mShopUnBusiness(params = { id: '' }) {
  return request('POST', 'goods/ma/mShopUnBusiness/1.0', params);
}
/**
 * 修改店铺 editShop
 */
export function updateShop(params = {}) {
  return request('POST', 'goods/ma/mShopUpdate/1.0', params);
}
// 店铺商品
/**
 * 四大服务分类列表 commodity/category/defaultAPP
 */
export function serviceCatalogList(params = {}) {
  return request('POST', 'sys/ma/serviceCatalogList/1.0', params);
}
// 入驻 defaultAPP
export function merchantEnter(params = {}) {
  return request('POST', 'user/ma/merchantEnter/2.1.0', params);
}
// 查询店铺资质配置 editShop
export function shopQueryQualification(params = {}) {
  return request('POST', 'manager/ma/shopQueryQualification/2.1.0', params);
}