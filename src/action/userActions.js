/**
 * userActions
 * @params getState() 读取redux的store
 */

import * as actionTypes from "./actionTypes";
import * as requestApi from "../config/requestApi";
import * as nativeApi from "../config/nativeApi";
import NavigatorService from '../common/NavigatorService';
// 注册
export function fetchRegister(params = {}, callback = () => {
}) {
    return (dispatch, getState) => {
        requestApi
            .requestRegister(params)
            .then(data => {
                requestApi.storageLogin("save", data);
                global.loginInfo = {...data, phone: params.phone, userId: data.id}
                dispatch({type: actionTypes.FETCH_REGISTER, data: global.loginInfo});
                callback();
            })
            .catch(error => {
                //
            });
    };
}

// 登录
export function fetchLogin(params = {}, callback = () => {
}, fail = () => {
}) {
    return (dispatch, getState) => {
        requestApi
            .requestLogin(params)
            .then(data => {
                let loginInfo = {
                    // 后端更改接口返回数据，去掉user字段
                    userId: data.id,
                    params,
                    ...data,
                    phone: params.phone
                };
                const nextFun=()=>{
                    requestApi.storagePhone("save", params);
                    requestApi.storageLogin("save", data);
                    global.loginInfo = loginInfo;
                    dispatch({type: actionTypes.FETCH_LOGIN, data: {...data}});
                    callback(data);
                }
                nextFun()
            })
            .catch(error => {
                console.log(error)
                fail();
            });
    };
}
// 更新登录信息
export function updateUser(user = {}) {
    return (dispatch, getState) => {
        dispatch({ type: "user/updateUser", payload: { user }})
    }
}
// 获取商户信息
export function  getMerchantHome(successCallback=()=>{},failCallback=()=>{},user={}){
    return (dispatch, getState) => {
        app._store.dispatch({ type: "user/getMerchantHome", payload: { successCallback, failCallback, user }})
    }
}
// 选择登录店铺
export function chooseShop(data, callback = () => {
}) {
    return (dispatch, getState) => {
        app._store.dispatch({ type: 'user/chooseShop', payload: data })
    };
}

//单纯修改一些状态
export function changeState(params) {
    return (dispatch, getState) => {
        dispatch({type: actionTypes.CHANGE_STATE, data: params});
    };
}

// 非商户身份获取权限
export function mUserPermission() {
    return (dispatch, getState) => {
        app._store.dispatch({ type: 'user/mUserPermission' });
    };
}
