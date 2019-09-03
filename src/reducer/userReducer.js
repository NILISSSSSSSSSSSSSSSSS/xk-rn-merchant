/**
 * user相关reducer
 */

import * as actionTypes from '../action/actionTypes';
import * as nativeApi from '../config/nativeApi';
const initialState = {
    user: {},  // 用户登录信息
    userShop: {},  // 选择登录的店铺信息
    userRole:[], // 根据用户选择的店铺的权限
    userFinanceInfo: {},
    merchantData:{},//商户基本信息
    userRoleList: [], // 用户权限key
    merchant:[
        {
            name: '主播',
            merchantType: "anchor",
            agreement:'ZB',
            auditStatus:'unSubmit'
        },
        {
            name: '家族长',
            merchantType: "familyL1",
            agreement:'FAMILY',
            auditStatus:'unSubmit'
        },
        {
            name: '公会',
            merchantType: "familyL2",
            agreement:'TRADE_UNION',
            auditStatus:'unSubmit'
        },
        {
            name: '商户',
            merchantType: "shops",
            agreement:'MERCHANT',
            auditStatus:'unSubmit'
        },
        {
            name: '合伙人',
            merchantType: "company",
            agreement:'PARTNER',
            auditStatus:'unSubmit'
        },
        {
            name: '个人/团队/公司',
            merchantType: "personal",
            agreement:'PERSONAL',
            auditStatus:'unSubmit'
        },
    ],
    messageData:[],//系统消息
};

export default (state = JSON.parse(JSON.stringify(initialState)), action) => {
    switch (action.type) {
        case actionTypes.FETCH_REGISTER:
            return {
                ...JSON.parse(JSON.stringify(initialState)),
                user: action.data,
                userShop:{}
            }
        case actionTypes.FETCH_LOGIN:
            return {
                ...JSON.parse(JSON.stringify(initialState)),
                user: action.data
            }
        case actionTypes.CHOOSE_SHOP:
            return {
                ...state,
                userShop: action.data
            }

        case actionTypes.CHANGE_STATE:
            return {
                ...state,
                ...action.data
            }
         case actionTypes.USERROLELIST:
            return {
                ...state,
                userRoleList: action.data
            }
        default:
            return state
    }
};
