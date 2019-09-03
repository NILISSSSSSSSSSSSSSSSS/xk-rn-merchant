/**
 * 导出reducer
 */

// 工具函数，用于组织多个reducer，并返回reducer集合
import { combineReducers } from 'redux';

import totalReducer from './totalReducer';
import userReducer from './userReducer';
import shopReducer from './shopReducer';
import mallReducer from './mallReducer';
import orderReducer from './orderReducer';
import welfareReducer from './welfareReducer';
import freightManageReducer from './freightManageReducer'
import invoiceReducer from './invoiceReducer'
import taskReducer from './taskReducer'
import systemReducer from './systemReducer'
import nav, { navAppReducer } from './navReducer'

export default {
    totalReducer,
    userReducer,
    mallReducer,
    shopReducer,
    orderReducer,
    freightManageReducer,
    welfareReducer,
    invoiceReducer,
    taskReducer,
    systemReducer,
    nav,
    navApp: navAppReducer,
};