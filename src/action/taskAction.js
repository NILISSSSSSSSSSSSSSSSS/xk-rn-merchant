import * as requestApi from '../config/requestApi';
import * as actionTypes from './actionTypes';
import { TASK_CATEGORIES, MERCHANT_TYPE_MAP_NAME } from '../const/task';
import * as taskRequest from "../config/taskCenterRequest"


// 联盟商列表
export function fetchMerchantDelegate(params = {page:1,limit: 10,jobId: ''}) {
    return (dispatch, getState) => {
        requestApi.merchantDelegate(params).then(data => {
            console.log('单个委派 联盟商列表',data)
            let _data = data ? data : getState().taskReducer.singleMerchantList;
            _data['isSelected'] = false
            dispatch({ type: actionTypes.UPDATESINGLEMERCHANTAPPOINT, singleMerchantList: _data })
        }).catch(err => {
            Toast.show('请求失败，请重试！')
            console.log(err)
        })
    }
}
// 单个委派 员工列表
export function fetchEmployeeDelegate (params) {
    return (dispatch, getState) => {
        requestApi.employeeDelegate(params).then(data => {
            console.log('单个委派 员工列表',data)
            let prevDataList = getState().taskReducer.singleAppontAccountList
            let _data;
            if (params.page === 1) {
                _data = data ? data.data : [];
            } else {
                _data = data ? [...prevDataList.data, ...data.data] : prevDataList.data
            }
            let _total = params.page === 1
                ? (data)
                    ? data.total
                    : 0
                : prevDataList.total;
            let hasMore = data ? _total !== _data.length : false;
            let initData = handleSetSelectStatue(_data)
            prevDataList.data = initData;
            prevDataList.hasMore = hasMore;
            prevDataList.page = params.page;
            prevDataList.total = _total;
            prevDataList.refreshing = false;
            // let listData = prevDataList
            dispatch({ type: actionTypes.UPDATESINGLEAPPOINT, singleAppontAccountList:prevDataList })
        }).catch(err => {
            Toast.show('请求失败，请重试！')
            console.log(err)
        })
    }
}
// 获取任务，验收，审核的分店(员工)列表
export function fetchStaffList(type,params = {page:1,limit: 10}) {
    return(dispatch, getState) => {
        let request = requestApi.preJobDelegatingPage;
        let preListIndex = 0; // 获取redux中已存在的委派数据列表 0 任务，1验收，2审核
        switch (type) {
            case 'task': request = requestApi.preJobDelegatingPage; preListIndex = 0; break;
            case 'check': request = requestApi.preCheckDelegatingPage; preListIndex = 1; break;
            case 'audit': request = requestApi.preAuditDelegatingPage; preListIndex = 2;break;
            default : request = requestApi.preJobDelegatingPage; preListIndex = 0;break;
        }
        request(params).then(res => {
            console.log('员工列表',res)
            let prevDataList = getState().taskReducer.appointList[preListIndex]
            let data = res ? res.pageable || [] : prevDataList;
            let _data;
            if (params.page === 1) {
                _data = data ? data.data: [];
            } else {
                _data = data ? [...prevDataList.data, ...data.data] : prevDataList.data
            }
            let _total = params.page === 1
                ? (data)
                    ? data.total
                    : 0
                : prevDataList.total;
            let hasMore = data ? _total !== _data.length : false;
            // 设置选择的初始状态
            let initData = handleSetSelectStatue(_data)
            prevDataList.data = initData;
            prevDataList.hasMore = hasMore;
            prevDataList.page = params.page;
            prevDataList.total = _total;
            prevDataList.refreshing = false;
            // let listData = prevDataList
            let pre_list = getState().taskReducer.appointList;
            pre_list[preListIndex] = prevDataList
            dispatch({ type: actionTypes.UPDATEAPPOINTLIS, pre_list })
        }).catch((err) => {
            console.log(err)
            Toast.show('请求失败，请重试！')
            // let prevDataList = getState().welfareReducer.orderList
            // dispatch({ type: actionTypes.WMORDERLIST, listData })
        });
    }
}
// 获取任务、验收、审核预委派(已委派)列表
export function getPreAppointList(type,params = {page:1,limit: 10}) {
    return(dispatch, getState) => {
        let request = requestApi.preJobDelegatedPage;
        let preListIndex = 0; // 获取redux中已存在的委派数据列表 0 任务，1验收，2审核
        switch (type) {
            case 'task': request = requestApi.preJobDelegatedPage; preListIndex = 0;break;
            case 'check': request = requestApi.preCheckDelegatedPage; preListIndex = 1;break;
            case 'audit': request = requestApi.preAuditDelegatedPage; preListIndex = 2;break;
            default : request = requestApi.preJobDelegatedPage; preListIndex = 0;break;
        }
        request(params).then(data => {
            console.log('已委派列表',data)
            let prevDataList = getState().taskReducer.appointedList[preListIndex]
            let _data;
            data ? null : data = {data: []}
            data.data ? null : data.data = [];
            if (params.page === 1) {
                _data = data ? data.data: [];
            } else {
                _data = data ? [...prevDataList.data, ...data.data] : prevDataList.data
            }
            let _total = params.page === 1
                ? (data)
                    ? data.total
                    : 0
                : prevDataList.total;
            let hasMore = data ? _total !== _data.length : false;
            prevDataList.data = _data;
            prevDataList.hasMore = hasMore;
            prevDataList.page = params.page;
            prevDataList.total = _total;
            prevDataList.refreshing = false;
            // let listData = prevDataList
            let pre_list = getState().taskReducer.appointedList;
            pre_list[preListIndex] = prevDataList
            dispatch({ type: actionTypes.UPDATEAPPOINTEDLIS, appointedList:pre_list })
        }).catch((err) => {
            Toast.show('请求失败，请重试！')
            console.log(err)
            // Toast.show(err.message)
            // let prevDataList = getState().welfareReducer.orderList
            // dispatch({ type: actionTypes.WMORDERLIST, listData })
        });
    }
}
// 选择员工修改状态
// data 传入对象修改联盟商或者分店数据 { appointList: newData }
export function updateStaffList(data) {
    return (dispatch, getState) => {
        dispatch({ type: actionTypes.UPDATESTAFFLIS, appointList: data.appointList })
    }
}
// 更新联盟商员工选择状态
export function updateSingleAppointList (data) {
    return (dispatch, getState) => {
        dispatch({ type: actionTypes.UPDATESINGLEAPPOINT, data})
    }
}
// 初始列表选择的状态
handleSetSelectStatue = (data = []) => { //??????
    if (data.length === 0) return []
    return data.map(item => {
        item['isSelected'] = false
        return item
    })
}

/** 获取验收、 */
export function fetchTaskList(params) {
    return (dispatch, getState) => {
        const { type, formData, page, limit, isFirstLoad } = params;
        let func = null;
        if(type === TASK_CATEGORIES.TrainTask) {
            func = taskRequest.fetchTrainingJobQPage
        } else {
            func = taskRequest.fetchAuditJobQPage
        }
        let pagination = {
            page,
            limit,
            loading: true,
            refreshing: page === 1,
            hasMore: false,
            isFirstLoad
        }
        let oldList = getState().taskReducer.taskList.list;
        dispatch({ type: actionTypes.SAVE_TASK_LIST, payload: { pagination }})
        if(func) {
            func({ ...formData, page, limit }).then(res=> {
                if(res) {
                    pagination.loading = false;
                    pagination.refreshing = false;
                    pagination.hasMore = res.total > page*limit;
                    pagination.isFirstLoad = false;
                    let data = (res.jobData || {}).data || [];
                    let list = [] ;
                    if(page===1) {
                        list = data;
                    } else {
                        list = oldList.concat(data);
                    }
                    let statistics = res.jobNumbers;
                    let merchantStatistics = res.auditJobNumbers || res.trainingJobNumbers || {};
                    dispatch({ type: actionTypes.SAVE_TASK_LIST, payload: { pagination, list, statistics, merchantStatistics }})
                } else {
                    pagination.loading = false;
                    pagination.refreshing = false;
                    pagination.hasMore = false;
                    pagination.isFirstLoad = false;
                    let list = page === 1 ? [] : oldList;
                    dispatch({ type: actionTypes.SAVE_TASK_LIST, payload: { pagination, list }})
                }
            }).catch(error=> {
                pagination.loading = false;
                pagination.refreshing = false;
                pagination.isFirstLoad = false;
                let list = page === 1 ? [] : oldList;
                dispatch({ type: actionTypes.SAVE_TASK_LIST, payload: { pagination, list }})
                Toast.show("获取任务列表失败")
            })
        } else {
            pagination.loading = false;
            pagination.refreshing = false;
            pagination.isFirstLoad = false;
            let list = page === 1 ? [] : oldList;
            dispatch({ type: actionTypes.SAVE_TASK_LIST, payload: { pagination, list }})
        }
    }
}

/** 获取任何首页统计数据 */
export function fetchMerchantNewJobPage(params) {
    return (dispatch, getState) => {
        taskRequest.fetchMerchantNewJobPage({}).then(res=> {
            let taskHomeData = res.data.map(task=> ({ ...task, merchantTypeName: MERCHANT_TYPE_MAP_NAME[task.merchantType ]}));
            dispatch({ type: actionTypes.SAVE_TASK_HOME_DATA, payload: taskHomeData })
        }).catch(error=> {
            Toast.show("获取任务首页数据失败")
        })
    }
}

export function setJobDelegate({ callback, ...formData }) {
    return (dispatch, getState) => {
        taskRequest.fetchsetJobDelegate(formData).then(res=> {
            callback & callback();
        }).catch(error=> {
            Toast.show("委派任务失败")
        })
    }
}
