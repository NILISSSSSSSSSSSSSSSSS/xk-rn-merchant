/**
 * 请求api
 */
import request from '../request';
import { storageFnc } from './commonApi';
/**
 * 找回密码 defaultAPP
 */
export function requestRetrievePwd(params = {}) {
  return request('POST', 'user/ma/mUserRetrievePassword/1.0', params);
}
/**
 * 缓存登录账号、密码
 */
export function storagePhone(status = 'save', data = null, expires = null) {
  return storageFnc('phone', status, data, expires);
}
/**
 * 缓存login信息
 */
export function storageLogin(status = 'save', data = null, expires = null) {
  return storageFnc('login', status, data, expires);
}
// 退出登录 defaultAPP
export function xkUserLogout(params = {}) {
  return request('POST', 'user/ma/xkUserLogout/1.0', params);
}

/**
 * 重置密码 defaultAPP
 */
export function mUserUpdatePassword(params = { phone: '' }) {
  return request('POST', 'user/ma/mUserUpdatePassword/1.0', params);
}
/**
 * 注册 defaultAPP
 */
export function requestRegister({
  phone = '', password = '', referralCode = '', code = '',
}) {
  const lng = global.lng;
  const lat = global.lat;

  const params = {
    lng,
    lat,
    phone,
    password,
    code,
    referralCode,
  };
  return request('POST', 'user/ma/mUserRegister/2.0', params);
}

/**
 * 登录 defaultAPP
 * @param lng 经度
 * @param lat 纬度
 */
export function requestLogin(params = { phone: '', password: '' }) {
  const lng = global.lng;
  const lat = global.lat;
  params = {
    lng,
    lat,
    ...params,
  };
  return request('POST', 'user/ma/mUserLogin/2.0', params);
  // return request('POST', 'user/ma/mUserLogin1/1.0', params);
}
// 查询城市code defaultAPP
export function regionPage(params = { page: 1, limit: 10, key: '' }) {
  return request('GET', 'sys/ma/regionPage/1.0', params, false);
}

// 联盟商入驻

// 用户加盟费支付状态查询 defaultAPP
export function merchantKeepEnterInitialCostPayStatus(params = {}) {
  return request('POST', 'user/ma/merchantKeepEnterInitialCostPayStatus/2.0', params, true, true, 5000, params && params.toastWrong);
}
// 用户保证金支付状态查询 defaultAPP
export function merchantKeepEnterCashDepositPayStatus(params = {}) {
  return request('POST', 'user/ma/merchantKeepEnterCashDepositPayStatus/2.0', params);
}
// 保证金模板查询 defaultAPP
export function upgradeCashDepositTemplate(params = {}) {
  return request('POST', 'user/ma/upgradeCashDepositTemplate/2.0', params);
}
// 保证金模板查询 defaultAPP
export function upFamilyCashDepositTemplate(params = {}) {
  return request('POST', 'user/ma/upFamilyCashDepositTemplate/2.0', params);
}
// 扩展身份保证金模板查询 defaultAPP
export function merchantExtendCashDepositTemplate(params = {}) {
  return request('GET', 'user/ma/merchantExtendCashDepositTemplate/2.0', params);
}
// 联盟商保证金模板查询 defaultAPP
export function merchantCashDepositTemplate(params = {}) {
  return request('GET', 'user/ma/merchantCashDepositTemplate/2.0', params);
}
// 保证金点击下一步(升级店铺) defaultAPP
export function upgradeCashDepositNextStepShop(params = {}) {
  return request('POST', 'user/ma/upgradeCashDepositNextStepShop/2.0', params);
}
// 保证金点击下一步 defaultAPP
export function upgradeCashDepositNextStep(params = {}) {
  return request('POST', 'user/ma/upgradeCashDepositNextStep/2.0', params);
}
// 保证金点击下一步 defaultAPP
export function upFamilyCashDepositNextStep(params = {}) {
  return request('POST', 'user/ma/upFamilyCashDepositNextStep/2.0', params);
}
// 保证金点击下一步 defaultAPP
export function merchantExtendCashDepositNextStep(params) {
  return request('POST', 'user/ma/merchantExtendCashDepositNextStep/2.0', params, true, true, 5000, params && params.toastWrong);
}
// 保证金下一步 defaultAPP
export function merchantCashDepositNextStep(params = {}) {
  return request('POST', 'user/ma/merchantCashDepositNextStep/2.0', params);
}
// 用户保证金支付状态查询 defaultAPP
export function upgradeCashDepositPayStatus(params = {}) {
  return request('POST', 'user/ma/upgradeCashDepositPayStatus/2.0', params);
}
// 用户保证金支付状态查询 defaultAPP
export function upFamilyCashDepositPayStatus(params = {}) {
  return request('POST', 'user/ma/upFamilyCashDepositPayStatus/2.0', params);
}
// 保证金支付状态查询 defaultAPP
export function merchantKeepEnterUpFamilyCashDepositPayStatus(params = {}) {
  return request('POST', 'user/ma/merchantKeepEnterUpFamilyCashDepositPayStatus/2.0', params);
}
// 用户保证金支付状态查询 defaultAPP
export function merchantExtendCashDepositPayStatus(params) {
  return request('GET', 'user/ma/merchantExtendCashDepositPayStatus/2.0', params, true, true, 5000, params && params.toastWrong);
}
// 保证金支付状态查询 defaultAPP
export function merchantCashDepositPayStatus(params = {}) {
  return request('POST', 'user/ma/merchantCashDepositPayStatus/2.1.0', params, true, true, 5000, false);
}
// 用户全额支付保证金 defaultAPP
export function upFamilyCashDepositPayment(params = {}) {
  return request('POST', 'user/ma/upFamilyCashDepositPayment/2.0', params);
}
// 用户全额支付保证金 defaultAPP
export function merchantExtendCashDepositPayment(params = {}) {
  return request('POST', 'user/ma/merchantExtendCashDepositPayment/2.0', params);
}
// 用户全额支付保证金 defaultAPP
export function upgradeCashDepositPayment(params = {}) {
  return request('POST', 'user/ma/upgradeCashDepositPayment/2.0', params);
}
// 保证金 选择全额支付方式 defaultAPP
export function merchantCashDepositPayment(params = {}) {
  return request('POST', 'user/ma/merchantCashDepositPayment/2.1.0', params);
}
// 加盟费模板查询 defaultAPP
export function upgradeInitialCostTemplate(params = {}) {
  return request('POST', 'user/ma/upgradeInitialCostTemplate/2.0', params);
}
// 加盟费模板查询 defaultAPP
export function upFamilyInitialCostTemplate(params = {}) {
  return request('POST', 'user/ma/upFamilyInitialCostTemplate/2.0', params);
}
// 扩展身份加盟费模板查询 defaultAPP
export function merchantExtendInitialCostTemplate(params = {}) {
  return request('GET', 'user/ma/merchantExtendInitialCostTemplate/2.0', params);
}
// 联盟商加盟费模板查询 defaultAPP
export function merchantInitialCostTemplate(params = {}) {
  return request('GET', 'user/ma/merchantInitialCostTemplate/2.1.0', params);
}
// 用户加盟费支付状态查询 defaultAPP
export function upgradeInitialCostPayStatus(params = {}) {
  return request('POST', 'user/ma/upgradeInitialCostPayStatus/2.0', params);
}
// 用户加盟费支付状态查询 defaultAPP
export function upFamilyInitialCostPayStatus(params = {}) {
  return request('POST', 'user/ma/upFamilyInitialCostPayStatus/2.0', params);
}
// 加盟费支付状态查询 defaultAPP
export function merchantKeepEnterUpFamilyInitialCostPayStatus(params = {}) {
  return request('POST', 'user/ma/merchantKeepEnterUpFamilyInitialCostPayStatus/2.0', params);
}
// 扩展身份用户加盟费支付状态查询 defaultAPP
export function merchantExtendInitialCostPayStatus(params) {
  return request('GET', 'user/ma/merchantExtendInitialCostPayStatus/2.0', params, true, true, 5000, params && params.toastWrong);
}
// 加盟费支付状态查询 defaultAPP
export function merchantInitialCostPayStatus(params = {}) {
  return request('POST', 'user/ma/merchantInitialCostPayStatus/2.1.0', params, true, true, 5000, false);
}
// 加盟费点击下一步 defaultAPP
export function upgradeInitialCostNextStep(params = {}) {
  return request('POST', 'user/ma/upgradeInitialCostNextStep/2.0', params);
}
// 加盟费点击下一步 defaultAPP
export function upFamilyInitialCostNextStep(params = {}) {
  return request('POST', 'user/ma/upFamilyInitialCostNextStep/2.0', params);
}
// 扩展身份加盟费点击下一步 defaultAPP
export function merchantExtendInitialCostNextStep(params = {}) {
  return request('POST', 'user/ma/merchantExtendInitialCostNextStep/2.0', params);
}
// 加盟费 下一步 defaultAPP
export function merchantInitialCostNextStep(params = {}) {
  return request('POST', 'user/ma/merchantInitialCostNextStep/2.0', params);
}
// 用户全额支付加盟费 defaultAPP
export function upFamilyInitialCostPayment(params = {}) {
  return request('POST', 'user/ma/upFamilyInitialCostPayment/2.0', params);
}
// 扩展身份用户全额支付加盟费 defaultAPP
export function merchantExtendInitialCostPayment(params = {}) {
  return request('GET', 'user/ma/merchantExtendInitialCostPayment/2.0', params);
}
// 用户全额支付加盟费 defaultAPP
export function upgradeInitialCostPayment(params = {}) {
  return request('POST', 'user/ma/upgradeInitialCostPayment/2.0', params);
}
// 加盟费选择全额支付方式 defaultAPP
export function merchantInitialCostPayment(params = {}) {
  return request('POST', 'user/ma/merchantInitialCostPayment/2.1.0', params);
}
// 查询商户账号 defaultAPP
export function upgradeMerchantFindUser(params = {}) {
  return request('POST', 'user/ma/upgradeMerchantFindUser/2.0', params, true, true, 5000, false);
}
// 创建商户账号 defaultAPP
export function upgradeMerchantCreateUser(params = {}) {
  return request('POST', 'user/ma/upgradeMerchantCreateUser/2.0', params);
}
// 家族长升级 defaultAPP
export function upFamilyFieldTemplateList(params = {}) { // 申请需要材料查询
  return request('POST', 'user/ma/upFamilyFieldTemplateList/2.1.0', params);
}
// 入驻数据查询 defaultAPP
export function dataPage(params = {}) {
  return request('GET', 'user/ma/dataPage/2.1.0', params);
}
// 申请需要材料查询 defaultAPP
export function fieldTemplateList(params = {}) {
  return request('GET', 'user/ma/fieldTemplateList/2.0', params);
}
// 查询已提交资料（崔鹏） defaultAPP
export function merchantKeepEnterUpgradeMerchantDetail(params = {}) {
  return request('POST', 'user/ma/merchantKeepEnterUpgradeMerchantDetail/2.1.0', params);
}
// 查询已提交资料 defaultAPP
export function keepEnterMerchantDetail(params = {}) {
  return request('POST', 'user/ma/keepEnterMerchantDetail/2.1.0', params);
}
// 扩展身份继续入驻 defaultAPP
export function reExtendMerchantDetail(params = {}) { // 查询已提交资料
  return request('GET', 'user/ma/reExtendMerchantDetail/2.1.0', params);
}
// 继续家族升级 defaultAPP
export function merchantKeepEnterUpFamilyMerchantDetail(params = {}) { // 查询已提交资料
  return request('POST', 'user/ma/merchantKeepEnterUpFamilyMerchantDetail/2.1.0', params);
}
// 查询已提交的资料 defaultAPP
export function merchantIdentityDetailForUpdate(params = {}) {
  return request('GET', 'user/ma/merchantIdentityDetailForUpdate/2.1.0', params);
}
// 查询扩展字段 defaultAPP
export function merchantExtendDetail(params = {}) {
  return request('POST', 'user/ma/merchantExtendDetail/2.0', params);
}
// 查询审核不通过原因 defaultAPP
export function auditFailReason(params = {}) {
  return request('POST', 'user/ma/auditFailReason/2.0', params);
}
// 数据保存 defaultAPP
export function upFamilySave(params = {}) {
  return request('POST', 'user/ma/upFamilySave/2.1.0', params);
}
// 修改已提交的资料 defaultAPP
export function merchantKeepEnterUpFamilyUpdateMerchant(params = {}) {
  return request('POST', 'user/ma/merchantKeepEnterUpFamilyUpdateMerchant/2.1.0', params);
}
// 保存商户资料 defaultAPP
export function merchantIdentityUpdate(params = {}) {
  return request('POST', 'user/ma/merchantIdentityUpdate/2.1.0', params);
}
// 创建独立店铺提交商户资料 defaultAPP
export function createIsolateMerchant(params = {}) {
  return request('POST', 'user/ma/createIsolateMerchant/2.1.0', params);
}
// 修改已提交资料（崔鹏） defaultAPP
export function merchantKeepEnterUpgradeUpdateMerchant(params = {}) {
  return request('POST', 'user/ma/merchantKeepEnterUpgradeUpdateMerchant/2.1.0', params);
}
// 修改身份资料 defaultAPP
export function merchantUpdateReExtend(params = {}) {
  return request('POST', 'user/ma/merchantUpdateReExtend/2.1.0', params);
}
// 查询商户账号 defaultAPP
export function upgradeMerchant(params = {}) {
  return request('POST', 'user/ma/upgradeMerchant/2.1.0', params);
}
// 修改入驻资料 defaultAPP
export function merchantUpdateEnter(params = {}) {
  return request('POST', 'user/ma/merchantUpdateEnter/2.1.0', params);
}
// 扩展身份 defaultAPP
export function merchantExtend(params = {}) {
  return request('POST', 'user/ma/merchantExtend/2.1.0', params);
}
// 验证安全码 defaultAPP
export function verifySecurityCode(params = {}) {
  return request('GET', 'user/ma/verifySecurityCode/2.0', params);
}
// 用户退保证金 defaultAPP
export function merchantCashDepositRefund(params = {}) {
  return request('POST', 'user/ma/merchantCashDepositRefund/2.0', params);
}
// 行网点查询 defaultAPP
export function tfBankDotQuery(params = {}) {
  return request('POST', 'sys/ma/tfBankDotQuery/1.0', params);
}
// 银行网点查询 defaultAPP
export function dataPageTfBankDotPage(params = {}) {
  return request('POST', 'user/ma/dataPageTfBankDotPage/2.0', params);
}
// 银行查询分页 defaultAPP
export function dataPageTfBankQPage(params = {}) {
  return request('POST', 'user/ma/dataPageTfBankQPage/2.0', params);
}
// 银行信息查询 defaultAPP
export function tfBankQuery(params = {}) {
  return request('POST', 'sys/ma/tfBankQuery/1.0', params);
}

// 扩展身份
// 重新扩展加盟费支付状态查询 defaultAPP
export function merchantReExtendInitialCostPayStatus(params = {}) {
  return request('GET', 'user/ma/merchantReExtendInitialCostPayStatus/2.0', params);
}
// 重新扩展保证金支付状态查询 defaultAPP
export function merchantReExtendCashDepositPayStatus(params = {}) {
  return request('GET', 'user/ma/merchantReExtendCashDepositPayStatus/2.0', params);
}

// 第三方首次提交（马一揆） defaultAPP
export function createChannelMerchant(params = {}) {
  return request('POST', 'user/ma/createChannelMerchant/2.1.0', params);
}

// 第三方入驻模板（马一揆） defaultAPP
export function channelMerchantFieldTemplateList(params = {}) {
  return request('POST', 'user/ma/channelMerchantFieldTemplateList/2.1.0', params);
}

// 第三方入驻详情（马一揆） defaultAPP
export function detailChannelMerchant(params = {}) {
  return request('POST', 'user/ma/detailChannelMerchant/2.1.0', params);
}

// 第三方再次提交（马一揆） defaultAPP
export function updateChannelMerchant(params = {}) {
  return request('POST', 'user/ma/updateChannelMerchant/2.1.0', params);
}
// 获取行业 defaultAPP
export function getIndustry(params = {}) {
  return request('POST', 'user/ma/getIndustry/2.1.0', params);
}
// 获取作品类型 defaultAPP
export function getWorkType(params = {}) {
  return request('POST', 'user/ma/getWorkType/2.1.0', params);
}
// 验证主播手机号 defaultAPP
export function smsCodeValidateUserAccount(params = {}) {
  return request('POST', 'sys/ma/smsCodeValidateUserAccount/2.1.0', params);
}
