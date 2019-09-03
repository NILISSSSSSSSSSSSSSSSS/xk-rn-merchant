/**
 * actionsType
 */

 export * from './order'
 export * from './cart'
 export * from './som'
 export * from './shop'
 export * from './welfare'
 export * from './task'
 export * from './system'


// 注册
export const FETCH_REGISTER = "FETCH_REGISTER";
// 登录
export const FETCH_LOGIN = "FETCH_LOGIN";
// 选择登录店铺
export const CHOOSE_SHOP = "CHOOSE_SHOP";
export const CHANGE_STATE = "CHANGE_STATE";
// 用户权限
export const USERROLELIST = "USERROLELIST";
// Mall
// 商品分类列表
export const FETCH_GOODSCATEGORYLISTS = "FETCH_GOODSCATEGORYLISTS";
// 更改商品分类列表的选中状态
export const CHANGE_GOODSCATEGORYLIST = "CHANGE_GOODSCATEGORYLIST";
// 私人分类列表修改
export const CHANGE_PRECATEGORYLIST = "CHANGE_PRECATEGORYLIST";
//更改状态
export const MALL_CHANGE_STATE = "MALL_CHANGE_STATE";
// 根据商品类目查询商品 或 搜索商品
export const FETCH_GOODSLISTS_RESET = "FETCH_GOODSLISTS_RESET"; // 重置
export const FETCH_GOODSLISTS_BEFORE = "FETCH_GOODSLISTS_BEFORE"; // 请求之前
export const FETCH_GOODSLISTS = "FETCH_GOODSLISTS"; // 成功
export const FETCH_GOODSLISTS_FAILED = "FETCH_GOODSLISTS_FAILED"; // 失败
export const FETCH_GOODSLISTS_MORE_BEFORE = "FETCH_GOODSLISTS_MORE_BEFORE";
export const FETCH_GOODSLISTS_MORE = "FETCH_GOODSLISTS_MORE";
export const FETCH_GOODSLISTS_MORE_FAILED = "FETCH_GOODSLISTS_MORE_FAILED";

export const FETCH_GOODSCLDLISTS_RESET = "FETCH_GOODSCLDLISTS_RESET";
export const FETCH_GOODSCLDLISTS_BEFORE = "FETCH_GOODSCLDLISTS_BEFORE";
export const FETCH_GOODSCLDLISTS = "FETCH_GOODSCLDLISTS";
export const FETCH_GOODSCLDLISTS_FAILED = "FETCH_GOODSCLDLISTS_FAILED";
export const FETCH_GOODSCLDLISTS_MORE_BEFORE =
    "FETCH_GOODSCLDLISTS_MORE_BEFORE";
export const FETCH_GOODSCLDLISTS_MORE = "FETCH_GOODSCLDLISTS_MORE";
export const FETCH_GOODSCLDLISTS_MORE_FAILED =
    "FETCH_GOODSCLDLISTS_MORE_FAILED";

export const FETCH_RESULTLISTS_RESET = "FETCH_RESULTLISTS_RESET";
export const FETCH_RESULTLISTS_BEFORE = "FETCH_RESULTLISTS_BEFORE";
export const FETCH_RESULTLISTS = "FETCH_RESULTLISTS";
export const FETCH_RESULTLISTS_FAILED = "FETCH_RESULTLISTS_FAILED";
export const FETCH_RESULTLISTS_MORE_BEFORE = "FETCH_RESULTLISTS_MORE_BEFORE";
export const FETCH_RESULTLISTS_MORE = "FETCH_RESULTLISTS_MORE";
export const FETCH_RESULTLISTS_MORE_FAILED = "FETCH_RESULTLISTS_MORE_FAILED";
export const FETCH_SETPAYPWDSTATUS = "FETCH_SETPAYPWDSTATUS";


export const RECORDROUTER = "RECORDROUTER";
