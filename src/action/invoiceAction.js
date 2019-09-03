/**
 * 发票管理
 * 
 */

import { CHANGE_STATEDATA } from './actionTypes'


export function changeData(data) {
    return {
        type: CHANGE_STATEDATA,
        data: data
    }
}