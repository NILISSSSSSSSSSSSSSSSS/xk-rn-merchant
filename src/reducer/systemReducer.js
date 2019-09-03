/**
 * 公用数据
 * 1. 七牛Token
 */

import * as actionTypes from "../action/actionTypes";

const initialState = {
    qiniuToken: "",
    qiniuTokenExpiryTime: Date.now()
}


export default (state = initialState, action) => {
    switch (action.type) {
        case actionTypes.SAVE_QINIU_TOKEN:
            // { payload: { token, expiryTime }}
            return {
                ...state,
                qiniuToken: action.payload.token,
                qiniuTokenExpiryTime: action.payload.expiryTime
            }
            break;
        default:
            return { ...state }
            break;
    }
}