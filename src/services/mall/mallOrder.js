import math from '../../config/math'
import * as requestApi from '../../config/requestApi';
import * as customPay from '../../config/customPay';

/**
 * 检查创建订单参数
 * @param {Object} params
 * @returns {Boolean} true 通过， false 不通过
 */
export function handleCheckOrderParams(somOrderConfiirm) {
    if (somOrderConfiirm.address.id === '') {
        Toast.show('请选择收货地址！')
        Loading.hide();
        return false
    }
    if (somOrderConfiirm.goodsList.length === 0) {
        console.log('商品信息未获取不予通过')
        Loading.hide();
        return false
    }
    return true
}

/**
 * 对收银台数据进行过滤
 * @param {Object} cashierResponse 创建订单时，后台返回的收银台数据 see： http://showdoc.xksquare.com/web/#/3?page_id=1020
 * @param {Object} proportion {swqProportion：1，xfqProportion：1  }兑换比例 当前为1块钱等于1券， 如果1块钱 = 8券，则swqProportion = 8
 */
export function filterCashierData(cashierResponse, proportion = { swqProportion: 1, xfqProportion: 1 }) {
    let temp = []
    cashierResponse.channelConfigs.map(item => { // 过滤出四个支付方式
        const { xfqProportion, swqProportion } = proportion
        console.log('item',item)
        if (item.payChannel === 'swq') {
            // 实物券为前置支付，需要额外配置参数
            temp[0] = {
                name: '实物券',
                info: `${swqProportion}实物券=¥1.00`,
                disable: parseFloat(item.amount) > 0 ? false: true,
                type: item.payChannel,
                prePayChannel: item.isPreChannel,
                useSwqPrePay: parseFloat(item.amount) > 0 ? true: false, // 是否使用实物券前置支付， 如果实物券余额为0，则不使用，否则使用实物券前置支付
                useAmount: '', // 输入的实物券使用金额
                deductionAmount: '', // 当前抵扣金额， 随着输入变化
                amount: item.amount, // 实物券余额
            }
        }
        if (item.payChannel == 'alipay') {
            temp[1] = {
                name: '支付宝',
                info: '支付宝安全支付',
                disable: false,
                type: 'alipay',
                prePayChannel: item.isPreChannel, // 是否是前置支付
                amount: item.amount, // 支付宝余额，默认null
                selectStatus: handleDefaultSelectStatus(cashierResponse, proportion), // 如果消费券被禁用，默认支付宝选中
            }
        }
        if (item.payChannel == 'wxpay') {
            temp[2] = {
                name: '微信',
                info: '微信安全支付',
                disable: false,
                type: 'wxpay',
                prePayChannel: item.isPreChannel,
                amount: item.amount, // 微信余额，默认null
                selectStatus: false, // 当前选择状态
            }
        }
        if (item.payChannel === 'xfq') {
            temp[3] = {
                name: '消费券',
                info: `${xfqProportion}消费券=¥1.00`,
                disable: handleInnerPayPer(item, cashierResponse.amount, proportion),
                type: item.payChannel,
                prePayChannel: item.isPreChannel,
                // onlyPayWay: cashierResponse.amount === 0 ? true : false ,
                amount: item.amount, // 消费券余额
                selectStatus: !handleInnerPayPer(item, cashierResponse.amount, proportion), // 当前选择状态,默认使用优惠券
            }
        }
    })
    return temp
}
/**
 * 判断是否禁止内部支付
 * @param {Object} item 当前支付方式，消费券或者实物券
 * @param {Number} needPayAmount  用户需支付的金额
 * @param {Object} proportion  消费券或实物券的兑换比例
 */
export function handleInnerPayPer (item, needPayAmount, proportion) {
    const { xfqProportion, swqProportion } = proportion
    // 获取兑换比例
    let proprotion = (item.payChannel === 'xfq') ? xfqProportion : (item.payChannel === 'swq') ? swqProportion : null;
    if (proprotion === null) return true
    if (item.amount == 0) {
        return true
    } else {
        if (item.isInner === 1) {
            // 当前商品值多少券
            let allTickets = (needPayAmount) * proprotion
            // 用户剩余券足够支付时
            if (math.multiply(item.amount, 100) >= allTickets) {
                return false
            }
            return true
        }
        return true
    }
}
/**
 * 
 * @param {Number} cashierResponse 服务器响应的收银台数据
 * @param {Object} proportion 消费券或实物券的兑换比例
 */
export function handleDefaultSelectStatus(cashierResponse, proportion){
    let swqItem = cashierResponse.channelConfigs.filter(item => item.payChannel === 'xfq')[0]
    return handleInnerPayPer(swqItem, cashierResponse.amount, proportion)
}

/**
 * 计算当前收银台状态
 *
 * 需支付金额为0，只能消费券支付
 *
 * 需支付金额不为0，没有实物券，不显示实物券前置支付，可选支付宝、微信、消费券，且默认消费券支付
 *
 * 需支付金额不为0，如果有实物券，显示实物券前置支付，并且默认开启， 如果需支付金额 > 实物券余额 默认使用所有实物券，需要根据兑换比率重新计算剩余支付的金额， 如果需支付金额 < 实物券金额， 使用与需支付金额等额的实物券（因为还有兑换比率，目前（2019/06/04）默认为1:1）
 *
 *  重要！！！（三遍） 如果不使用实物券，实物券的两个字段 prePayChannel，prePayAmount，全部传null，否则 BOOM！BOOM！BOOM！
 *
 * @param {Object} filter_data 对收银台数据进行过滤后的数据
 * @param {Number} needPayAmount 需要支付的金额,后台返回的金额，精确到  ‘分’
 */
export function computeCashierData (filter_data, needPayAmount, proportion = { swqProportion: 1, xfqProportion: 1 }) {
    console.log('filter_data',filter_data)
    console.log('cashierResponse',needPayAmount)
    const { swqProportion, xfqProportion } = proportion
    let data = filter_data
    let surplusPayAmount = 0; // 剩余支付
    let swqItem = data.filter(item => item.type === 'swq')[0]
    let otherPayItem = data.filter(item => item.type !== 'swq')
    let needPayAmountDecimal = math.divide(needPayAmount, 100); // 需要支付的金额，转换为RMB
    // 需支付金额为0，只能消费券,且禁用前置支付和其他方式
    if (needPayAmount === 0) {
        swqItem.disable = true // 禁止点击
        swqItem.useSwqPrePay = false
        swqItem.deductionAmount = 0
        surplusPayAmount = needPayAmountDecimal
        swqItem.useAmount = 0
        otherPayItem.map(item => { item.type === 'xfq' ? item.disable = false : item.disable = true })
    } else {
        // 需支付不为0， 实物券余额为0，不显示前置支付
        if (parseFloat(swqItem.amount) === 0) {
            data.shift()
        } else {
            // 需支付不为0， 实物券不为0，比较金额大小，决定使用实物券的金额（需要将剩余的实物券转换为RMB，然后比较是否足够支付）
            // 剩余实物券转换为RMB后是否超过需支付金额
            // 需支付金额 值 多少实物券 eg: 汇率为1，50 RMB = 50 Swq
            let needPayAmountSwq = swqProportion >= 1 ? math.multiply(needPayAmountDecimal, swqProportion) : math.divide(needPayAmountDecimal, swqProportion)
            // 剩余实物券是否足够支付
            if (swqItem.amount >= needPayAmountSwq) {
                // 使用金额 = 这个商品值多少实物券
                swqItem.useAmount = needPayAmountSwq
                // 抵扣金额 = 商品金额
                swqItem.deductionAmount = needPayAmountDecimal
                // 实物券足够 && 默认开启 && 默认全额抵扣时，其他支付方式禁用，且清除选择状态 除非关闭使用前置支付，或者使用实物券金额不足以抵扣商品金额
                data.filter(item => item.type !== 'swq').map(item => { item.disable = true; item.selectStatus = false })
                swqItem.useSwqPrePay = true
            } else {
                // 抵扣金额
                let deduction_amount = swqProportion >= 1 ? math.divide(parseFloat(swqItem.amount), swqProportion) : math.multiply(parseFloat(swqItem.amount), swqProportion);
                // 使用全额实物券
                swqItem.useAmount = swqItem.amount
                // 已抵扣金额
                swqItem.deductionAmount = deduction_amount
                // 剩余支付金额
                surplusPayAmount = math.subtract(needPayAmountDecimal, deduction_amount)
                swqItem.useSwqPrePay = true
            }
        }
    }
    return {
        data,
        surplusPayAmount
    }
}

/**
 * 根据是否使用前置支付，设置收银台数据
 *
 * 如果不使用前置支付，其他支付方式解除禁用，且默认选中消费券，实物券的使用，抵扣金额 为 0，剩余支付为 needPayAmount
 *
 * 如果使用前置支付，计算当前收银台数据
 *
 * @param {Object} cashierInfo 修改之前的收银台数据
 * @param {Boolean} status 是否使用前置支付
 * @param {Number} needPayAmount 需要支付的金额
 */
export function setPrePaySwitch (cashierInfo, status,needPayAmount) {
    if (status) {
        return computeCashierData(cashierInfo.data,needPayAmount)
    }
    let deepCopyCashierInfo = JSON.parse(JSON.stringify(cashierInfo))
    let payArr = deepCopyCashierInfo.data;
    let prePayItem = payArr.filter(item => item.type === 'swq')[0]
    let otherPayItem = payArr.filter(item => item.type !== 'swq')
    // 剩余支付金额
    let surplusPayAmount = 0;
    // 其他支付方式解开禁止选择,且默认选中消费券
    otherPayItem.map(item => { item.disable = false; item.type === 'xfq' ? item.selectStatus = true : item.selectStatus = false; })
    // 设置是否使用前置支付
    prePayItem.useSwqPrePay = status
    // 抵扣金额 = 0
    prePayItem.deductionAmount = 0
    // 剩余支付 = 需要支付的总额
    surplusPayAmount = math.divide(needPayAmount, 100)
    // 当前使用实物券 = 0
    prePayItem.useAmount = 0
    return {
        data: deepCopyCashierInfo.data,
        surplusPayAmount
    }
}
// 获取支付方式
/**
 *
 * @param {Object} cashierInfo 收银台数据
 */
export function getPayType(cashierInfo) {
    return cashierInfo.data.filter(item => item.type !== 'swq' && item.selectStatus)[0]
}
// 余额支付
export function handleBalancePay (navigation, params) {
    Loading.show()
    console.log('参数',params)
    requestApi.uniPayment(params).then(res => {
        console.log('支付结果',res)
        if (res.tradePaymentStatus === 'success') {
            // this.props.actions.payOrderInfo({}) // 支付成功，清除重新支付参数
            navigation.replace('SOMPayResult', { payFailed: false, routerIn: 'OrderConfirm' });
        }
        if (res.tradePaymentStatus === 'fail') {
            navigation.replace('SOMPayResult', { payFailed: true, routerIn: 'OrderConfirm' });
        }
    }).catch(err => {
        console.log(err)
        navigation.replace('SOMPayResult', { payFailed: true, routerIn: 'OrderConfirm', });

    })
}
// 支付宝支付
export function handleAliPay (navigation, params) {
    Loading.show()
    requestApi.uniPayment(params).then(res => {
        console.log(res)
        customPay.alipay({
            param: res.next.channelPrams.aliPayStr,
            successCallBack: () => {
                navigation.replace('SOMPayResult', { payFailed: false });
            },
            faildCallBack: () => {
                navigation.replace('SOMPayResult', { payFailed: true });
            }
        })
    }).catch(err => {
        navigation.replace('SOMPayResult', { payFailed: true });
        console.log(err)
    })

}
// 微信支付
export function handleWeChatPay (navigation, params) {
    Loading.show()
    requestApi.uniPayment(params).then(res => {
        console.log('wechat', res)
        let wx_param = {
            partnerId: res.next.channelPrams.partnerId,
            prepayId: res.next.channelPrams.prepayId,
            nonceStr: res.next.channelPrams.nonceStr,
            timeStamp: res.next.channelPrams.timestamp,
            package: res.next.channelPrams.pack,
            sign: res.next.channelPrams.sign,
        }
        customPay.wechatPay({
            param: wx_param,
            successCallBack: () => {
                navigation.replace('SOMPayResult', { payFailed: false });
            },
            faildCallBack: () => {
                navigation.replace('SOMPayResult', { payFailed: true });
            }
        })
    }).catch(err => {
        navigation.replace('SOMPayResult', { payFailed: true });
        console.log(err)
    })
}
