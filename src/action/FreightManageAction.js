/**
 * FreightManageAction
 * @params getState() 读取redux的store
 */

import * as actionTypes from './actionTypes';

export function freightManagegetData(isFirst = false, params = {}, api = () => { }, loadingxl) {
    return (dispatch, getState) => {
        //  loadingxl=true  上拉加载
        if (!loadingxl && !isFirst) {
            dispatch({ type: actionTypes.FREIGHT_MANAG_LOADING })
        }
        if (loadingxl) {
            dispatch({ type: actionTypes.FREIGHT_MANAG_SHANGLALOADING })
        }
        api(params).then((res) => {
            let data = res && res.data
            data.forEach((item) => {
                if (item.valuateType == "BY_WEIGHT" || item.valuateType == "DISTANCE") {
                    if(item.destFee){
                        item.destFee.defaultNum = item.destFee.defaultNum / 1000
                        item.destFee.increNum = item.destFee.increNum / 1000
                        item.destFee.defaultFee = item.destFee.defaultFee / 100
                        item.destFee.increFee = item.destFee.increFee / 100
                    }
                }else{
                    if(item.destFee){
                        item.destFee.defaultFee = item.destFee.defaultFee / 100
                        item.destFee.increFee = item.destFee.increFee / 100
                    }
                }
            })
            if (!data || data.length === 0) {
                dispatch({ type: actionTypes.FREIGHT_MANAG_LISTFOOTERnO })
                return;
            }
            if (isFirst) {
                dispatch({ type: actionTypes.FREIGHT_MANAG_FIRSTLIST, data })  //将loading关闭
            } else {
                dispatch({ type: actionTypes.FREIGHT_MANAG_LIST, data })
            }
        })

    }
}
