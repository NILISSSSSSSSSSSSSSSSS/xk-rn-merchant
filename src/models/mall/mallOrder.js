import * as requestApi from '../../config/requestApi'
import * as Address from '../../const/address';
import * as customPay from '../../config/customPay';
import math from '../../config/math'
import NavigatorService from "../../common/NavigatorService";


import { handleCategotyListLoadMore,handleCheckOrderParams,filterCashierData, computeCashierData, setPrePaySwitch, getPayType, handleBalancePay } from '../../services/mall'
const errorJsName = 'mallOrderModel'

export default {
    // 获取初始信息
    *getInitData({ payload }, { call, put, select }){
        try {
            let { goodsList } = payload
            let somOrderConfiirm = yield select(state => state.mall.somOrderConfiirm)
            let user = yield select(state => state.user.user)
            // 商品列表数据
            somOrderConfiirm.goodsList = goodsList
            // 获取优惠券所需参数
            somOrderConfiirm.userInfo = { merchantId: user.merchantId }
            // 设置商品数据
            yield put({ type: 'save', payload: { somOrderConfiirm: JSON.parse(JSON.stringify(somOrderConfiirm)) } })
            // 获取默认地址
            yield put({ type: 'fetchDefaultAddress' })
            // 获取优惠列表
            yield put({ type: 'fetchUserConponList' })
            // 获取默认发票
            yield put({ type: 'fetchDefaultInvoice' })
        } catch (error) {
            console.log(`${errorJsName},getInitData`, error)
        }
    },
    // 获取默认地址
    *fetchDefaultAddress ({ payload }, { call, put, select }) {
        let somOrderConfiirm = yield select(state => state.mall.somOrderConfiirm)
        try {
            // 获取默认地址信息
            let defaultAddress = yield call(requestApi.merchantDefault)
            let [ provinceName, cityName, districtName ] = Address.getNamesByDistrictCode(defaultAddress.districtCode)
            console.log('defaultAddress',defaultAddress)
            somOrderConfiirm.address = { ...defaultAddress, provinceName,  cityName,  districtName }
            yield put({ type: 'save', payload: { somOrderConfiirm } })
             // 计算金额 地址和优惠券会影响订单价格，see 'http://showdoc.xksquare.com/web/?#/3?page_id=1020'
             yield put({ type: 'getUserValidateAmount'})
        } catch (error) {
            somOrderConfiirm.address = { id: '' }
            yield put({ type: 'save', payload: { somOrderConfiirm: JSON.parse(JSON.stringify(somOrderConfiirm)) } })
            console.log(`${errorJsName},fetchDefaultAddress`, error)
        }
    },
    // 获取默认发票
    *fetchDefaultInvoice({ payload }, { call, put, select }){
        try {
            let defaultInvoice = yield call(requestApi.merchantDefaultInvoice)
            let somOrderConfiirm = yield select(state => state.mall.somOrderConfiirm)
            somOrderConfiirm.selectInvoice = defaultInvoice ? defaultInvoice : { id: '', head: '' }
            yield put({ type: 'save', payload: { somOrderConfiirm } })
        } catch (error) {
            console.log(`${errorJsName},fetchDefaultInvoice`, error)
        }
    },
    // 获取优惠券列表
    *fetchUserConponList({ payload }, { call, put, select }){
        try {
            let somOrderConfiirm = yield select(state => state.mall.somOrderConfiirm)
            let { goodsList, userInfo } = somOrderConfiirm
            let params = {
                orderGoods: [],
                merchantId: userInfo.merchantId
            }
            goodsList.map(item => {
                params.orderGoods.push({
                    goodsId: item.goodsId,
                    goodsSum: item.quantity,
                    goodsSkuCode: item.goodsSkuCode
                })
            })
            let couponList = yield call(requestApi.findMUserCoupons, params)
            console.log('couponList',couponList)
            let filterData = (couponList || []).map(item => { item.checkedData = 0; return item })
            somOrderConfiirm.couponList = filterData
            yield put({ type: 'save', payload: { somOrderConfiirm } })
        } catch (error) {
            console.log(`${errorJsName},fetchUserConponList`, error)
        }
    },
    // 获取订单金额
    *getUserValidateAmount ({ payload }, { call, put, select }) {
        try {
            // 设置参数
            let somOrderConfiirm = yield select(state => state.mall.somOrderConfiirm)
            let { goodsList } = somOrderConfiirm
            let param = {
                mallOrderValidateAmountParams: {
                    goodsParams: [], // 购买的商品集合
                    addressId: somOrderConfiirm.address.id, // 地址id
                    userDiscountId: somOrderConfiirm.selectCoupon.id, // 优惠券id
                    discountType: somOrderConfiirm.selectCoupon.cardType, // 优惠券类型
                }

            }
            goodsList.map(item => {
                param.mallOrderValidateAmountParams.goodsParams.push({
                    goodsId: item.goodsId,
                    goodsSum: item.quantity,
                    goodsSkuCode: item.goodsSkuCode
                })
            })

            let userAmount =  yield call(requestApi.mallOrderMUserValidateAmount, param)
            somOrderConfiirm.goodsAmount = userAmount.goodsAmount // 商品总额
            somOrderConfiirm.postAmount = userAmount.postAmount // 运费
            somOrderConfiirm.orderAmount = (userAmount.goodsAmount + userAmount.postAmount) / 100 // 总价
            yield put({ type: 'save', payload: { somOrderConfiirm: JSON.parse(JSON.stringify(somOrderConfiirm)) } })
        } catch (error) {
            console.log(`${errorJsName},getUserValidateAmount`, error)
        }
    },
    // 选择优惠券
    *handleSelectCoupon({ payload }, { call, put, select }){
        try {
            let { data } = payload
            let somOrderConfiirm = yield select(state => state.mall.somOrderConfiirm)
            console.log('data11',data)
            if (somOrderConfiirm.selectCoupon.id === data.id && somOrderConfiirm.selectCoupon.cardId === data.cardId) {
                somOrderConfiirm.selectCoupon.id = ''
                somOrderConfiirm.selectCoupon.cardType = ''
                somOrderConfiirm.selectCoupon.cardName = '请选择优惠券'
                somOrderConfiirm.selectCoupon.cardId = ''
                console.log('selectCoupon',somOrderConfiirm.selectCoupon)
            } else {
                somOrderConfiirm.selectCoupon = data
            }
            yield put({ type: 'save', payload: { somOrderConfiirm: JSON.parse(JSON.stringify(somOrderConfiirm)) } })
            // 选择优惠券后 重新计算金额
            yield put({ type: 'getUserValidateAmount'})
        } catch (error) {
            console.log(`${errorJsName},fetchUserConponList`, error)
        }
    },
    // 选择发票
    *handleSelectInvoice({ payload }, { call, put, select }){
        try {
            let { data } = payload
            let somOrderConfiirm = yield select(state => state.mall.somOrderConfiirm)
            // console.log('somOrderConfiirm.selectInvoice',somOrderConfiirm.selectInvoice)
            somOrderConfiirm.selectInvoice.id = data.id === somOrderConfiirm.selectInvoice.id ? '' : data.id;
            somOrderConfiirm.selectInvoice.head = data.head === somOrderConfiirm.selectInvoice.head ? '' : data.head;
            yield put({ type: 'save', payload: { somOrderConfiirm: JSON.parse(JSON.stringify(somOrderConfiirm)) } })
        } catch (error) {
            console.log(`${errorJsName},handleSelectInvoice`, error)
        }
    },
    // 选择地址
    *handleSelectAddress({ payload }, { call, put, select }) {
        try {
            let { address } = payload
            let somOrderConfiirm = yield select(state => state.mall.somOrderConfiirm)
            somOrderConfiirm.address = address
            yield put({ type: 'save', payload: { somOrderConfiirm: JSON.parse(JSON.stringify(somOrderConfiirm)) } })
            // 选择地址后 重新计算金额
            yield put({ type: 'getUserValidateAmount'})
        } catch (error) {
            console.log(`${errorJsName},handleSelectAddress`, error)
        }
    },
    // 创建订单
    *handleCreateOrder({ payload }, { call, put, select }) {
        try {
            let { remarkText } = payload
            let userInfo = yield select(state => state.user.user)
            let somOrderConfiirm = yield select(state => state.mall.somOrderConfiirm)
            yield put({ type: 'getUserValidateAmount' })
            // 是否通过验证
            if (!handleCheckOrderParams(somOrderConfiirm)) return
            let goodsData = somOrderConfiirm.goodsList.map(({ goodsId, goodsSkuCode, quantity }, index) => {
                return {
                    goodsId,
                    goodsSkuCode,
                    goodsSum: quantity
                }
            })
            let params = {
                mallCreateOrderParams: {
                    payAmount: somOrderConfiirm.goodsAmount + somOrderConfiirm.postAmount, // 不需要 * 100，使用返回的金额
                    goodsParams: goodsData,
                    referralCode: userInfo.securityCode,
                    remark: remarkText,
                    addressId: somOrderConfiirm.address.id,
                    invoiceId: somOrderConfiirm.selectInvoice.id,
                    discountType: somOrderConfiirm.selectCoupon.cardType,
                    userDiscountId: somOrderConfiirm.selectCoupon.id
                }
            }
            let res = yield call(requestApi.createOrder, params)
            if (res) {
                // cashierResponse 记录后台返回的收银台数据，以便于收银台页面过滤
                yield put({ type: 'save', payload: { cashierResponse: res } })
                // 跳转收银台
                yield put({ type: 'system/navPage', payload: { routeName: "SOMCashier" } })
                // 进行收银台页面数据的过滤,便于渲染
                yield put({ type: 'handleCashierData' })
                Loading.hide();
             }
        } catch (error) {
            Toast.show('创建订单失败，请重试！')
            console.log(`${errorJsName},handleCreateOrder`, error)
        }
    },
    // 更新收银台数据
    *refreshCashier ({ payload }, { call, put, select }){
        try {
            let { cashierData } = payload
            // cashierResponse 记录后台返回的收银台数据，以便于收银台页面过滤
            yield put({ type: 'save', payload: { cashierResponse: cashierData } })
            // 跳转收银台
            yield put({ type: 'system/navPage', payload: { routeName: "SOMCashier" } })
            // 进行收银台页面数据的过滤,便于渲染
            yield put({ type: 'handleCashierData' })
        } catch (error) {
            console.log(`${errorJsName},refreshCashier`, error)            
        }
    },
    // 支付成功，清除确认订单信息数据，防止数据叠加
    *handleClearSomOrderInfo({ payload }, { call, put, select }){
        try {
            let obj = {
                address: '',
                goodsList: [],
                userInfo: {merchantId: ''},
                goodsAmount: '', // 商品金额
                postAmount: '', // 运费
                orderAmount: '0', // 需支付金额
                couponList: [], // 优惠券列表
                couponIndex: '', // 选择的优惠券索引
                selectCoupon: { // 选择的优惠券
                    cardType: '',
                    id: '',
                    cardName: '请选择优惠券',
                    cardId: '',
                },
                selectInvoice: { // 选择的发票
                    id: '',
                    head: ''
                }
            }
            yield put({ type: 'save', payload: { somOrderConfiirm: obj } })
        } catch (error) {
            console.log(`${errorJsName},handleClearSomOrderInfo`, error)
        }
    },
    // 过滤出收银台所需数据
    *handleCashierData({ payload }, { call, put, select }){
        try {
            // 获取后台返回收银台数据
            Loading.show();
            let cashierResponse = yield select(state => state.mall.cashierResponse )
            let cashierInfo = yield select(state => state.mall.cashierInfo )
            // 获取过滤后的收银台数据
            let filter_data = filterCashierData(cashierResponse,cashierInfo.proportion)
            // 初始支付方式
            // 获取默认选项
            let defaultSetting = computeCashierData(filter_data, cashierResponse.amount,cashierInfo.proportion)
            const { data, surplusPayAmount } = defaultSetting
            cashierInfo.data = data
            cashierInfo.surplusPayAmount = surplusPayAmount
            console.log('???', cashierInfo)
            yield put({ type: 'save', payload: { cashierInfo: JSON.parse(JSON.stringify(cashierInfo)) } })
            Loading.hide();
        } catch (error) {
            console.log(`${errorJsName},handleCashierData`, error)
        }
    },
    // 设置是否使用前置支付
    *handlePrePaySwitch({ payload }, { call, put, select }){
        try {
            let { result } = payload
            let cashierResponse = yield select(state => state.mall.cashierResponse)
            let preCashierInfo = yield select(state => state.mall.cashierInfo)
            let nowCashierInfo = setPrePaySwitch(preCashierInfo, result, cashierResponse.amount)
            preCashierInfo.data = nowCashierInfo.data
            preCashierInfo.surplusPayAmount = nowCashierInfo.surplusPayAmount
            console.log('preCashierInfo', preCashierInfo)
            console.log('nowCashierInfo', nowCashierInfo)
            yield put({ type: 'save', payload: { cashierInfo: JSON.parse(JSON.stringify(preCashierInfo)) } })
        } catch (error) {
            console.log(`${errorJsName},handlePrePaySwitch`, error)
        }
    },
    // 选择支付方式
    *handleSelectPayType ({ payload }, { call, put, select }) {
        try {
            let { params } = payload
            console.log('params',params)
            let cashierInfo = yield select(state => state.mall.cashierInfo)
            cashierInfo.data.map(item => {
                if (item.type === params.selectItem.type) {
                    item.selectStatus = true
                } else {
                    item.selectStatus = false
                }
            })
            yield put({ type:'save', payload: { cashierInfo } })
        } catch (error) {
            console.log(`${errorJsName},handleSelectPayType`, error)
        }
    },
    // 输入使用多少实物券
    *handleUseAmount ({ payload }, { call, put, select }) {
        try {
            let { useAmount = 0 } = payload
            let cashierInfo = yield select(state => JSON.parse(JSON.stringify(state.mall.cashierInfo)))
            let swqProportion = cashierInfo.proportion.swqProportion;
            let cashierResponse = yield select(state => state.mall.cashierResponse)
            let swqItem = cashierInfo.data.filter(item => item.type === 'swq')[0];
            swqItem.useAmount = useAmount;
            // 抵扣金额
            let deduction_amount = swqProportion >= 1 ? math.divide(useAmount, swqProportion) : math.multiply(useAmount, swqProportion);
            swqItem.deductionAmount = deduction_amount
            // 剩余支付金额
            surplusPayAmount = math.subtract(math.divide(cashierResponse.amount, 100), deduction_amount)
            cashierInfo.surplusPayAmount = surplusPayAmount
            // 如果剩余支付为0， 禁止选择其他支付方式
            if (surplusPayAmount === 0) {
                cashierInfo.data.filter(item => item.type !== 'swq').map(item => { item.disable = true;item.selectStatus = false })
            } else { // 否则取消其他支付方式禁用，使用默认消费券支付
                cashierInfo.data.filter(item => item.type !== 'swq').map(item => {
                    item.disable = false;
                    if (item.type === 'xfq') {
                        item.selectStatus = true
                    } else {
                        item.selectStatus = false
                    }
                })
            }
            console.log('inputAmount',useAmount, cashierInfo)
            yield put({ type: 'save', payload: { cashierInfo } })

        } catch (error) {
            console.log(`${errorJsName},handleUseAmount`, error)
        }
    },
    // 收银台支付
    *handlePayOrder ({ payload }, { call, put, select }){
        try {
            let cashierInfo = yield select(state => state.mall.cashierInfo)
            let cashierResponse = yield select(state => state.mall.cashierResponse)
            let setPayPwdStatus = yield select(state => state.shop.setPayPwdStatus)
            let swqItem = cashierInfo.data.filter(item => item.type === 'swq')[0];
            let payType = getPayType(cashierInfo);
            console.log('payType',payType)
            // 实物券全额支付 payChannel = null,payAmount = null ，不使用实物券 prePayChannel为null，prePayAmount为null

            let payChannel = swqItem && swqItem.useSwqPrePay ? math.multiply(swqItem.useAmount, 100) === cashierResponse.amount ? null : payType.type : payType.type;
            let payAmount = (swqItem && swqItem.useSwqPrePay) ? math.multiply(swqItem && cashierInfo.surplusPayAmount, 100) === 0 ? null : math.multiply(swqItem && cashierInfo.surplusPayAmount, 100) : cashierResponse.amount;
            let prePayChannel = swqItem && swqItem.useSwqPrePay && swqItem.useAmount != 0 ? 'swq' : null;
            let prePayAmount = (swqItem && swqItem.useSwqPrePay && swqItem.useAmount != 0) ? math.multiply(swqItem.useAmount, 100) : null;
            let params = {
                "body": cashierResponse.body,//【提交订单接口返回body字符串】
                prePayChannel,
                payChannel,
                payAmount,
                prePayAmount,
                authType: [],
                authValue: "",
                platform: 'ma'
            }
            // 流程：
            // 内部支付（消费券，或者实物券全额支付）验证支付密码流程
            // 三方支付 调用三方库
            // 组合支付，即使用了实物券又选择以上两种中的一种支付，先验证支付密码，再调用三方支付
            console.log('params',params)
            // 实物券存在余额，并且使用实物券，并且剩余支付为0，则使用实物券全额支付
            if (swqItem && swqItem.useSwqPrePay && cashierInfo.surplusPayAmount === 0) { // 使用实物券支付，直接进入密码验证然后支付
                console.log('swq全额支付')
                // 如果是组合支付，内部支付，传入支付方式
                yield put({ type: 'system/navPage', payload: { routeName: "SOMBalancePay", params:{ payType: 'swq', params } } })
            }
            // 实物券存在余额，并且使用实物券，并且剩余支付余额不为0
            if (swqItem && swqItem.useSwqPrePay && cashierInfo.surplusPayAmount !== 0) { // 组合支付，
                console.log('组合支付', payType.type)
                yield put({ type: 'system/navPage', payload: { routeName: "SOMBalancePay", params:{ payType: payType.type, params } } })
            }
            // 实物券余额存在，并且不使用实物券 或者 实物券不存在余额
            if ((swqItem && !swqItem.useSwqPrePay) || !swqItem) { // 非组合支付
                if (payType.type === 'alipay') {
                    console.log('非组合支付alipay')
                    yield put({ type: 'handleAliPay', payload: { params } })
                }
                if (payType.type === 'wxpay') {
                    console.log('非组合支付wxpay')
                    yield put({ type: 'handleWeChatPay', payload: { params } })
                }
                if (payType.type === 'xfq') {
                    console.log('非组合支付xfq')
                    yield put({ type: 'system/navPage', payload: { routeName: "SOMBalancePay", params:{ payType: 'xfq', params } } })
                }
            }
            Loading.hide();
        } catch (error) {
            console.log(`${errorJsName},handlePayOrder`, error)
            Loading.hide();
        }
    },
    // 支付宝支付
    *handleAliPay({ payload }, { call, put, select }){
        try {
            Loading.show()
            let { params } = payload
            let response = yield call(requestApi.uniPayment,params)
            customPay.alipay({
                param: response.next.channelPrams.aliPayStr,
                successCallBack: () => {
                    NavigatorService.replace('SOMPayResult', { payFailed: false });
                },
                faildCallBack: () => {
                    NavigatorService.replace('SOMPayResult', { payFailed: true });
                }
            })
        } catch (error) {
            console.log(`${errorJsName},handleAliPay`, error)
            yield put({ type: 'system/replacePage', payload: { routeName: 'SOMPayResult', params: {  payFailed: true, } } })
        }
    },
    // 微信支付
    *handleWeChatPay ({ payload }, { call, put, select }) {
        try {
            Loading.show()
            let { params } = payload
            let res = yield call(requestApi.uniPayment, params)
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
                    NavigatorService.replace('SOMPayResult', { payFailed: false });
                },
                faildCallBack: () => {
                    NavigatorService.replace('SOMPayResult', { payFailed: true });
                }
            })
        } catch (error) {
            console.log(`${errorJsName},handleWeChatPay`, error)
            yield put({ type: 'system/replacePage', payload: { routeName: 'SOMPayResult', params: {  payFailed: true } } })
        }
    },
    // 余额支付
    *handleBalancePay({ payload }, { call, put, select }){
        try {
            Loading.show()
            let { params } = payload
            console.log('参数',params)
            let res = yield call(requestApi.uniPayment,params)
            if (res.tradePaymentStatus === 'success') {
                yield put({ type: 'system/replacePage', payload: { routeName: 'SOMPayResult', params: {  payFailed: false,  routerIn: 'OrderConfirm' } } })
            }
            if (res.tradePaymentStatus === 'fail') {
                yield put({ type: 'system/replacePage', payload: { routeName: 'SOMPayResult', params: {  payFailed: true,  routerIn: 'OrderConfirm' } } })
            }
        } catch (error) {
            yield put({ type: 'system/replacePage', payload: { routeName: 'SOMPayResult', params: {  payFailed: true, routerIn: 'OrderConfirm' } } })
            console.log(`${errorJsName},handleBalancePay`, error)
        }
    },
    // 收银台获取
    *fetchNormalOrderListData({ payload }, { call, put, select }) {
        try {
            let orderList = yield call(requestApi.fetchMallOrderList,payload.params)
            let prevData = yield select(state => state.mall.somOrderList)
            let listData = handleCategotyListLoadMore(payload.params, payload.params.currentTab, orderList, prevData)
            yield put({ type: 'save', payload: { somOrderList: JSON.parse(JSON.stringify(listData)) } })
        } catch (error) {
            console.log(`${errorJsName},fetchOrderListData`, error)
         }
    },
    // 获取用户支付密码状态
    *getUserPayPwdStatus ({ payload }, { call, put, select }) {
        try {
            let payPwdStatus = yield call(requestApi.merchantPayPasswordIsSet)
            yield put({ type: 'user/save', payload: { setPayPwdStatus: payPwdStatus } })
        } catch (error) {
            
        }
    },
    *fetchAfterSaleOrderList({ payload }, { call, put }) {
        try {
            // let orderList = yield call(requestApi.fetchMallOrderList,payload.params)
            // console.log('orderList',orderList)
        } catch (error) {
            console.log(`${errorJsName},fetchOrderListData`, error)
         }
    }
}
