
/**
 * 运费管理reducer
 */

import * as actionTypes from '../action/actionTypes'

let initialState = {
    dataList: [],
    refreshing: false,   //loding
    loadingxl: false,    //上拉加载
    hasmore: true
}
export default (state = initialState, action) => {
    switch (action.type) {
        case actionTypes.FREIGHT_MANAG_LOADING:
            return {
                refreshing: true,
                dataList: state.dataList,
                loadingxl: false,
                hasmore: true,
            }
        case actionTypes.FREIGHT_MANAG_REPLACEALL:
            return {
                refreshing: false,
                dataList: action.data,
                hasmore: true,
            }
        case actionTypes.FREIGHT_MANAG_SHANGLALOADING:
            return {
                refreshing: false,
                dataList: state.dataList,
                hasmore: true,
                loadingxl: true,
            }
        case actionTypes.FREIGHT_MANAG_LISTFOOTERnO:
            return {
                refreshing: false,
                dataList: state.dataList,
                hasmore: false,
                loadingxl: false,
            }
        case actionTypes.FREIGHT_MANAG_FIRSTLIST:
            let hasmore = true
            if (!action.data || (action.data && action.data.length < 10)) {
                hasmore = false
            }
            return {
                refreshing: false,
                dataList: action.data,
                loadingxl: false,
                hasmore: hasmore,
            }
        case actionTypes.FREIGHT_MANAG_LIST:
            return {
                refreshing: false,
                dataList: state.dataList.concat(action.data),
                loadingxl: false,
                hasmore: true
            }
        default:
            return state
    }
}
