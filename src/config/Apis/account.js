/**
 * 请求api
 */
import request from '../request';
// 账户财务，晓可币充值方式列表 accountFinance
export function xkbPayChannel(params = {}) {
    return request('POST', 'trade/ma/xkbPayChannel/1.0', params);
}
// 财务账户/xkb面额充值列表 accountFinance
export function xkbDenominationQList(params = {}) {
    return request('GET', 'goods/ma/xkbDenominationQList/1.0', params);
}
// 账户财务 晓可币充值/物流充值 去支付 accountFinance
export function uniPaymentXkbCharge(params = {}) {
    return request('POST', 'trade/ma/uniPaymentXkbCharge/1.0', params);
}
// 账户财务 晓可币转账 accountFinance
export function xkbTransfer(params = {}) {
    return request('POST', 'trade/ma/xkbTransfer/1.0', params);
}
// 账户财务 晓可币 支出详情 accountFinance
export function userAccXkbBillDetail(params = {id:''}) {
    return request('POST', 'trade/ma/userAccXkbBillDetail/1.0', params);
}
// 账户财务 消费券 支出详情 accountFinance
export function userAccXfqBillDetail(params = {id:''}) {
    return request('POST', 'trade/ma/userAccXfqBillDetail/1.0', params);
}
// 账户财务 实物券 支出详情 accountFinance
export function userAccSwqBillDetail(params = {id:''}) {
    return request('POST', 'trade/ma/userAccSwqBillDetail/1.0', params);
}
// 账户财务 晓可券 支出详情 accountFinance
export function userAccXkqBillDetail(params = {id:''}) {
    return request('POST', 'trade/ma/userAccXkqBillDetail/1.0', params);
}
// 账户财务 商户物流余额账户流水列表、详情 accountFinance
export function merchantWlsBillQPage(params = {id:''}) {
    return request('POST', 'trade/ma/merchantWlsBillQPage/1.0', params);
}
// 账户财务交易记录 accountFinance
export function shopAppUserAccQpage(params = {}) {
    if(["xkrd", "xkr"].indexOf(params.currency)!==-1)
        return request('POST', 'trade/ma/merchantWlsBillQPage/1.0', params);
    return request('POST', 'trade/ma/shopAppUserAccQpage/1.0', params);
}
// 账户财务，物流余额充值方式列表 accountFinance
export function wlPayChannel(params = {}) {
    return request('POST', 'trade/ma/wlsPayOrder/1.0', params);
}
// 账户财务信息 accountFinance
export function shopAppUserAccDetail(params = {}) {
    return request('POST', 'trade/ma/shopAppUserAccDetail/1.0', params);
}
// 财务账户/提现记录 accountFinance
export function shopMerchantAdvanceQPage(params = {}) {
    return request('GET', 'trade/ma/shopMerchantAdvanceQPage/1.0', params);
}
// 财务账户/商户申请提现信息app端 accountFinance
export function merchantWithdrawInfoApp(params = {}) {
    return request('GET', 'trade/ma/merchantWithdrawInfoApp/1.0', params);
}
// 财务账户/商户提现手续费比例 accountFinance
export function merchantWithdrawPoundageApp(params = {}) {
    return request('GET', 'trade/ma/merchantWithdrawPoundageApp/1.0', params);
}
// 财务账户/商户提现申请 accountFinance
export function merchantWithdrawApply(params = {}) {
    return request('POST', 'trade/ma/merchantWithdrawApply/1.0', params);
}
// 财务账户/商户保证金列表 accountFinance
export function merchantCashDepositList(params = {}) {
    return request('POST', 'user/ma/merchantCashDepositList/2.0', params);
}
// 账户财务，物流余额充值 去支付
// export function uniPayment(params = {}) {
//     return request('POST', 'trade/ma/uniPayment/1.0', {
//         payAmount: params.amount
//     });
// }
