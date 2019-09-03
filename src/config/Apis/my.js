
/**
 * 请求api
 */
import request from '../request';
// 联盟商详情
export function merchantDetail(params) {
    return request('GET', 'user/ma/merchantDetail/2.1.0', params)
}
// 联盟商首页 merchantInfo/defaultAPP
export function merchantHome(params = {}) {
    return request('POST', 'user/ma/merchantHome/2.0', params);
}
// 验证验证码  defaultAPP
export function smsCodeValidate(params = { phone: '', code: '' }) {
    return request('POST', 'sys/ma/smsCodeValidate/1.0', params);
}
// 非店铺资源列表 merchantInfo
export function notShopResourcePage(params) {
    return request('POST', 'user/ma/notShopResourcePage/2.0', params);
}
// 店铺资源列表 merchantInfo/gave
export function shopResourcePage(params) {
    return request('POST', 'user/ma/shopResourcePage/2.0', params);
}
/**
 * 店铺资源列表
 */
// export function mShopResourceQPage(params) {
//     return request('POST', 'user/ma/mShopResourceQPage/1.0', params);
// }
/**
 * 账号详情 merchantInfo
 */
export function employeeDetail(params) {
    return request('POST', 'user/ma/employeeDetail/1.0', params);
}
// 账号归属 merchantInfo
export function merchantTypePage(params) {
    return request('POST', 'user/ma/merchantTypePage/2.0', params);
}
/**
 * 账号列表 merchantInfo
 */
export function employeeQPage(params) {
    return request('POST', 'user/ma/employeeQPage/1.0', params);
}
// 修改员工手机号   merchantInfo
export function employeePhoneUpdate(params) {
    return request('POST', 'user/ma/employeePhoneUpdate/1.0', params);
}
/**
 * 重置员工密码 merchantInfo
 */
export function employeeResetPassword(params) {
    return request('POST', 'user/ma/mUserResetPassword/1.0', params);
}
/**
 * 修改账号 merchantInfo
 */
export function employeeUpdate(params) {
    return request('POST', 'user/ma/employeeUpdate/1.0', params);
}
/**
 * 新增账号 merchantInfo
 */
export function employeeCreate(params = { shopId: '', name: '', }) {
    return request('POST', 'user/ma/employeeCreate/1.0', params);
}
/**
 * 删除账号 merchantInfo
 */
export function employeeDelete(params = { id: '' }) {
    return request('POST', 'user/ma/employeeDelete/1.0', params);
}

/**
 * 设置支付密码（商户） merchantInfo/wholesaleMall
 */
export function merchantPayPasswordSetting(params = {}, callback = () => { }) {
    return request('GET', 'user/ma/merchantPayPasswordSetting/2.0', params)
}
/**
 * 查询是否设置支付密码（商户） merchantInfo/wholesaleMall
 */
export function merchantPayPasswordIsSet(params = {}, callback = () => { }) {
    return request('GET', 'user/ma/merchantPayPasswordIsSet/1.0', params)
}
/**
 * 验证支付密码（商户） wholesaleMall
 */
export function merchantPayPasswordValidate(params = {}, callback = () => { }) {
    return request('GET', 'user/ma/merchantPayPasswordValidate/1.0', params)
}
/**
 * 发票管理  merchantInfo / wholesaleMall
 */
//发票列表 merchantInfo/wholesaleMall
export function merchantInvoiceQPage(params) {
    return request('POST', 'user/ma/merchantInvoiceQPage/1.0', params)
}
//新建发票 merchantInfo/wholesaleMall
export function merchantInvoiceCreate(params) {
    return request('POST', 'user/ma/merchantInvoiceCreate/1.0', params)
}
//修改 merchantInfo
export function merchantInvoiceUpdate(params) {
    return request('POST', 'user/ma/merchantInvoiceUpdate/1.0', params)
}
//删除 merchantInfo/
export function merchantInvoiceDelete(params) {
    return request('POST', 'user/ma/merchantInvoiceDelete/1.0', params)
}


// 获取分类消息列表 defaultAPP
export function systemMsgList(params = {}) {
    return request('GET', 'im/ma/systemMsgList/1.0', params);
}
// 删除消息记录 defaultAPP
export function systemMsgDelete(params = {}) {
    return request('GET', 'im/ma/systemMsgDelete/1.0', params)
}
// 获取系统消息 defaultAPP
export function sysFictitiousUserList(params = {}) {
    return request('GET', 'im/ma/sysFictitiousUserList/1.0', params)
}

// 查询个人资料 defaultAPP
export function merchantPersonalDataDetail(params) {
    return request('GET', 'user/ma/merchantPersonalDataDetail/2.0', params)
}

// 保存个人资料 defaultAPP
export function merchantPersonalDataUpdate(params) {
    return request('POST', 'user/ma/merchantPersonalDataUpdate/2.0', params)
}

