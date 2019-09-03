
import request from '../request';
import { storageFnc } from './commonApi'
// 常见问题分类 defaultAPP
export function fetchCategoryManagerPage(params) {
    return request('GET', 'user/ma/knowledgePointCategoryPage/1.0', params)
}
/**
 * 获取常见问题列表 defaultAPP
 */
export function getCommonQuestion(params = { }) {
    return request('GET', 'user/ma/knowledgePointList/1.0', params);
}
// 骑手数据统计 logistics
export function merchantCount(params = {  }) {
    return request('POST', 'user/ma/merchantCount/1.0', params)
}
// 晓可物流 骑手列表 logistics
export function merchantBindRiderQPage(params = {  }) {
    return request('POST', 'user/ma/merchantBindRiderQPage/1.0', params)
}
// 晓可物流 根据骑手手机匹配姓名 logistics
export function merchantFindRiderByPhone(params = {  }) {
    return request('POST', 'user/ma/merchantFindRiderByPhone/1.0', params)
}
// 晓可物流 绑定骑手 logistics
export function merchantBindRider(params = {  }) {
    return request('POST', 'user/ma/merchantBindRider/1.0', params)
}
// 晓可物流 解绑骑手 logistics
export function merchantUnBindRider(params = {  }) {
    return request('POST', 'user/ma/merchantUnBindRider/1.0', params)
}
// 缓存是否打开过引导页
export function storageAppIntroStatus(status = 'save', data = null, expires = null) {
    return storageFnc('appIntroStatus', status, data, expires);
}
// 联盟商-月结算类型总额查询 latestRevenue
export function unionIndexPieEarningsStatistics(params = {}) {
    return request('GET', 'trade/ma/unionIndexPieEarningsStatistics/1.0', params);
}
// 获取用户权限资源 defaultAPP
export function mUserQueryPermission(params) {
    return request('POST', 'user/ma/mUserQueryPermission/2.0', params);
}
// 首页中奖信息 defaultAPP
export function jprizeUserPrize(params = { textPassword: '' }) {
    return request('POST', 'trade/ma/jprizeUserPrize/1.0', params);
}
// 获取banner defaultAPP
export function requestSOMBannerList(params = { regionCode: '', bannerModule: 'SELF_SHOP' }) {
    return request('GET', 'sys/ma/bannerList/1.0', params,false);
}
// 修改用户头像 defaultAPP
export function xkUserUpdate(params = { avatar: '' }) {
    return request('GET', 'user/ma/xkUserUpdate/1.0', params);
}
// 注册极光账号 defaultAPP
export function jpushReg(params = {}) {
    return request('POST', 'im/ma/jpushReg/1.0', params);
}
// 获取版本更新信息 defaultAPP
export function clientVersionQuery(params = { avatar: '' }) {
    return request('GET', 'sys/ma/clientVersionQuery/1.0', params, false);
}
