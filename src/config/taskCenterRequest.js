/**
 * 任务中心，审核中心，验收中心api
 */
import request from '../config/request'


// 任务列表
export function fetchMerchantJoinTaskList(params) {
    return request('GET', 'user/ma/merchantJobPage/2.0', params);
}

// 审核列表
export function fetchMerchantAuditPage(params) {
    return request('GET', 'user/ma/merchantAuditPage/2.0', params);
}

//验收列表
export function fetchMerchantCheckPagee(params) {
    return request('GET', 'user/ma/merchantCheckPage/2.0', params);
}

// 任务详情
export function fetchMerchantJoinTaskTemplate(params) {
    return request('GET', 'user/ma/jobDetail/2.0', params);
}

//审核详情  
export function fetchAuditDetail(params) {
    return request('GET', 'user/ma/auditDetail/2.0', params);
}
// 验收详情
export function fetchcheckDetail(params) {
    return request('GET', 'user/ma/checkDetail/2.0', params);
}



//任务数据  
export function fetchMerchantJoinTaskData(params) {
    return request('POST', 'user/ma/merchantJoinTaskData/1.0', params);
}

//提交任务
export function fetchMerchantJoinTaskFinish(params) {
    return request('POST', 'user/ma/processJob/2.0', params);
}

//查询上级联盟商列表
export function fetchSuperMerchant(params) {
    return request('GET', 'user/ma/merchantDelegate/2.0', params);
}

//查询员工
export function fetchEmployeePage(params) {
    return request('POST', 'user/ma/merchantJoinTaskEmployeePage/1.0', params);
}

//委派， 已经委派了的人
export function fetchMerchantJoinTaskAppointedFind(params) {
    return request('POST', 'user/ma/merchantJoinTaskAppointedFind/1.0', params);
}

//委派设置  任务 已委派的数据
export function fetchMerchantJoinTaskBatchAppointedFind(params) {
    return request('GET', 'user/ma/preJobDelegatedPage/2.0', params);
}
//委派设置 任务  请求所有数据
export function fetchPreJobDelegatingPage(params) {
    return request('GET', 'user/ma/preJobDelegatingPage/2.0', params);
}

//批量委派设置保存  任务 保存
export function fetchMerchantJoinBatchAppointedSave(params) {
    return request('POST', 'user/ma/preJobDelegateSetting/2.0', params);
}

//委派设置 审核 已委派
export function fetchPreAuditDelegatedPage(params) {
    return request('GET', 'user/ma/preAuditDelegatedPage/2.0', params);
}
//委派设置 审核 请求所有数据
export function fetchPreAuditDelegatingPage(params) {
    return request('GET', 'user/ma/preAuditDelegatingPage/2.0', params);
}
//委派设置 审核 保存
export function fetchPreAuditDelegateSetting(params) {
    return request('POST', 'user/ma/preAuditDelegateSetting/2.0', params);
}

//委派设置 验收 已经委派的数据
export function fetchPreCheckDelegatedPage(params) {
    return request('GET', 'user/ma/preCheckDelegatedPage/2.0', params);
}

//委派设置 验收 请求所有数据
export function fetchPreCheckDelegatingPage(params) {
    return request('GET', 'user/ma/preCheckDelegatingPage/2.0', params);
}

//委派设置 验收 保存
export function fetchPreCheckDelegateSetting(params) {
    return request('POST', 'user/ma/preCheckDelegateSetting/2.0', params);
}

//单个委派 请求下级用户 
export function fetchEmployeeDelegate(params) {
    return request('GET', 'user/ma/employeeDelegate/2.0', params);
}

//任务审核 通过
export function fetchMerchantJoinTaskAudit(params) {
    return request('GET', 'user/ma/auditSuccess/2.0', params);
}
//审核失败
export function fetchMerchantauditFail(params) {
    return request('GET', 'user/ma/auditFail/2.0', params);
}

//任务验收 通过
export function fetchMerchantJoinTaskAcceptance(params) {
    return request('GET', 'user/ma/checkJobSuccess/2.0', params);
}
//任务验收 不通过
export function fetchMerchantJoincheckJobFail(params) {
    return request('GET', 'user/ma/checkJobFail/2.0', params);
}

//单个任务委派
export function fetchMerchantJoinTaskAppointed(params) {
    return request('POST', 'user/ma/merchantJoinTaskAppointed/1.0', params);
}

// 审核任务详情
export function fetchEnterTaskList(params) {
    return request('GET', 'user/ma/auditDetail/2.0', params);
}

//入驻信息
export function fetchjobMerchantDetail(params) {
    return request('GET', 'user/ma/jobMerchantDetail/2.0', params);
}

//审核单个委派保存
export function fetchSetAuditDelegate(params) {
    return request('POST', 'user/ma/setAuditDelegate/2.0', params);
}

//任务单个委派保存
export function fetchsetJobDelegate(params) {
    return request('POST', 'user/ma/setJobDelegate/2.0', params);
}

//验收单个委派保存
export function fetchsetCheckDelegate(params) {
    return request('POST', 'user/ma/setCheckDelegate/2.0', params);
}

//审核任务详情
export function fetchauditJobDetail(params) {
    return request('GET', 'user/ma/auditJobDetail/2.0', params);
}

//店铺详情
export function fetchmShopAuthDetail(params) {
    return request('GET', 'goods/ma/mShopAuthDetail/1.0', params);
}

// 商户任务列表（崔鹏）
export function fetchMerchantNewJobPage(params) {
    return request('GET', 'user/ma/merchantNewJobPage/2.0', params);
}

// 任务中心列表（崔鹏）
export function fetchTrainingJobQPage(params) {
    return request('GET', 'user/ma/trainingJobQPage/2.0', params);
}

// 审核中心列表（崔鹏）
export function fetchAuditJobQPage(params) {
    return request('GET', 'user/ma/auditJobQPage/2.0', params);
}

