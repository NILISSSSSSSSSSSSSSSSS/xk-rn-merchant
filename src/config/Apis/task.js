/**
 * 请求api
 */
import request from '../request';
// 保存选择的任务预委派员工 defaultAPP
export function preJobDelegateSetting(params) {
    return request('GET', 'user/ma/preJobDelegateSetting/2.0', params);
}
// 保存选择的验收预委派员工 defaultAPP
export function preCheckDelegateSetting(params) {
    return request('GET', 'user/ma/preCheckDelegateSetting/2.0', params);
}
// 保存选择的审核预委派员工 defaultAPP
export function preAuditDelegateSetting(params) {
    return request('GET', 'user/ma/preAuditDelegateSetting/2.0', params);
}
// 任务、验收、审核预委派人数统计 defaultAPP
export function merchantDelegateList(params={jobId: '',page: 1,limit: 20,}) {
    return request('GET', 'user/ma/merchantDelegateList/2.0', params);
}
// 查询单个委派联盟商列表 defaultAPP
export function merchantDelegate(params={jobId: '',page: 1,limit: 20,}) {
    return request('GET', 'user/ma/merchantDelegate/2.0', params);
}
// 查询单个委派员工列表 defaultAPP
export function employeeDelegate (params = {limit: 10, page: 1}) {
    return request('GET', 'user/ma/employeeDelegate/2.0', params);
}
// 查询任务预委派员工 defaultAPP
export function preJobDelegatingPage(params) {
    return request('GET', 'user/ma/preJobDelegatingPage/2.0', params);
}
// 查询验收预委派员工 defaultAPP
export function preCheckDelegatingPage(params) {
    return request('GET', 'user/ma/preCheckDelegatingPage/2.0', params);
}
// 查询审核预委派员工 defaultAPP
export function preAuditDelegatingPage(params) {
    return request('GET', 'user/ma/preAuditDelegatingPage/2.0', params);
}
// 预委派 任务预委派列表 defaultAPP
export function preJobDelegatedPage(params) {
    return request('GET', 'user/ma/preJobDelegatedPage/2.0', params);
}
// 预委派 验收预委派列表 defaultAPP
export function preCheckDelegatedPage(params) {
    return request('GET', 'user/ma/preCheckDelegatedPage/2.0', params);
}
//预委派 审核预委派列表 defaultAPP
export function preAuditDelegatedPage(params={page: 1,limit:10}) {
    return request('GET', 'user/ma/preAuditDelegatedPage/2.0', params);
}
