
/**
 * 任务中心reducer
 */

import * as actionTypes from '../action/actionTypes'

let initialState = {
    taskHomeData: [],
    merchantList: [],
    appointedList: [
        { // 任务预委派(已委派)列表
            page: 1,
            limit: 10,
            data: [],
            total: 0,
            hasMore: true,
            refreshing:false,
        },
        { // 验收预委派(已委派)列表
            page: 1,
            limit: 10,
            data: [],
            total: 0,
            hasMore: true,
            refreshing:false,
        },
        { // 审核预委派(已委派)列表
            page: 1,
            limit: 10,
            data: [],
            total: 0,
            hasMore: true,
            refreshing:false,
        }
    ],
    taskList: {
        pagination: {},
        list: []
    },

    appointList: [
        { // 任务预委派分店列表
        page: 1,
        limit: 10,
        data: [],
        total: 0,
        hasMore: true,
        refreshing:true,
    },
    { // 验收预委派分店列表
        page: 1,
        limit: 10,
        data: [],
        total: 0,
        hasMore: true,
        refreshing:true,
    },
    { // 审核预委派分店列表
        page: 1,
        limit: 10,
        data: [],
        total: 0,
        hasMore: true,
        refreshing:true,
    }],
    // 单个委派员工列表
    singleAppontAccountList: {
        page: 1,
        limit: 10,
        data: [],
        total: 0,
        hasMore: true,
        refreshing:true,
    },
    // 单个委派联盟商列表
    singleMerchantList: {},
}
export default (state = initialState, action) => {
    switch (action.type) {
        case actionTypes.SAVE_TASK_HOME_DATA:
            return {
                ...state,
                taskHomeData: action.payload
            }
        case actionTypes.SAVE_TASK_LIST:
            return {
                ...state,
                taskList: {
                    ...state.taskList,
                    ...action.payload
                }
            }
        case actionTypes.PREJOBDELEGATEDPAGE:
            return {
                ...state,
                appointedList: state.appointedList[0] = action.prevDataList
            }
        case actionTypes.PRECHECKDELEGATEDPAGE:
            return {
                ...state,
                appointedList: state.appointedList[1] = action.prevDataList
            }
        case actionTypes.PREAUDITDELEGATEDPAGE:
            return {
                ...state,
                appointedList: state.appointedList[2] = action.prevDataList
            }
        case actionTypes.PREJOBDELEGATINGPAGE:
            return {
                ...state,
                appointList: state.appointList[0] = action.prevDataList
            }
        case actionTypes.PRECHECKDELEGATINGPAGE:
            return {
                ...state,
                appointList: state.appointList[1] = action.prevDataList
            }
        case actionTypes.PREAUDITDELEGATINGPAGE:
            return {
                ...state,
                appointList: state.appointList[2] = action.prevDataList
            }
        case actionTypes.UPDATESINGLEMERCHANTAPPOINT:
            return {
                ...state,
                ...action
            }
        case actionTypes.UPDATESINGLEAPPOINT:
            return {
                ...state,
                ...action
            }
        case actionTypes.UPDATESTAFFLIS:
            return {
                ...state,
                ...action
            }
        case actionTypes.UPDATEAPPOINTEDLIS:
            return {
                ...state,
                ...action
            }
        case actionTypes.UPDATEAPPOINTLIS:
            return {
                ...state,
                ...action
            }
        default:
            return state
    }
}
