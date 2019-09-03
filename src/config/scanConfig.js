/** 二维码内容*/
import * as nativeApi from "./nativeApi";
import config from './config'
import { recodeGoGoodsDetailRoute } from './utils'
import {fetchBcleMUserConfirmConsume,fetchOBMBcleOrderMuserAppDetail} from '../config/Apis/order'
// 1. 我的二维码名片 type:business_card  // xksl://business_card?userId=123&securityCode=123 🐶
// 2. 群名片 type:group_business_card  // xksl://group_business_card?groupId=123
// 3. 商品详情 type:commodity_detail  // xksl://commodity_detail?userId=123&securityCode=123
// 4. 店铺详情 type:store_detail  // xksl://store_detail?storeId=111&userId=111🐶
// 5. 店铺收款 type:store_receipt  // xksl://store_receipt?storeId=1&orderId=1&offerType=1&offerValue=1&originalPrice=1&actualAmount=1&expireTime=1&mercahantId=1
// 6. 出售晓可币 type:sales_xiaoke_currentcy  // xksl://sales_xiaoke_currentcy?verificationSignatureId=1
// 7. 线下收款订单 type:offline_receipt_order  // xksl://offline_receipt_order?storeId=1&orderId=1
// 6. 线下消费订单 type:offline_consumption_order  // xksl://offline_consumption_order?orderId=1&orderType=1&consumptionCode=1
export const qrCodeValue = (type, params) => {
    console.log(params)
    let url = ''
    if (type == 'store_detail') {
        url = `${config.baseUrl_share_h5}businessDetail?client=sh&shopId=${params.storeId}&lng=${params.lng}&lat=${params.lat}&securityCode=${params.securityCode}&QRCode=xksl://${type}?`
        // url = `${config.baseUrl_h5}businessDetail?client=sh&shopId=${params.storeId}&lng=${params.lng}&lat=${params.lat}&securityCode=${params.securityCode}$info=&QRCode=xksl://${type}?`
        params={
            storeId:params.storeId,
            userId:params.userId
        }
    }
    else {
        url = `xksl://${type}?`
    }
    for (key in params) {
        params[key] ? url = url + key + '=' + params[key] + '&' : null
    }
    return url.substring(0, url.length - 1)
}

export const scanQRCode = ()=> {
    return nativeApi.scanQRCode();
}

export const scan = (navigation, userId, storeId,securityCode, callback = (() => { })) => {
    nativeApi.scanQRCode().then(res => {
        let params = {}
        console.log("scanresult1", res);
        if (res.indexOf("?") > 0) {
            for (let item of res.split('?')[1].split('&')) {
                params[item.split('=')[0]] = item.split('=')[1]
            }
        }

        const routeName = navigation && navigation.state.routeName || 'Shop'//当前页面
        console.log("scanresult2", res, navigation, params);
        if (routeName == 'FinancialAccount') {
            //生成二维码转账
            if (res.indexOf("://business_card") < 0) {
                Toast.show("扫码失败，请扫描正确的二维码");
            } else {
                //1.我的二维码
                navigation.navigate("FinanceMakeQrcode", {
                    userId: params.userId
                });
            }
        } else {
            // if (res.indexOf("://business_card") > 0) {
            //     //1.我的二维码----(加可友)
            //     Toast.show('加可友功能还未实现')
            // }else if (res.indexOf("://group_business_card") > 0) {
            //     //2.群名片---⾃自定义群 加⼊入⽤用户分享的群,并打开该群聊（注意: 地区群⽆无⼆二维码）
            //     Toast.show('群聊功能还未实现')
            // } else
            if (res.indexOf("://commodity_detail") > 0 || res.indexOf("/share/#/goodsdetail?") > 0 ) {
                //2.商品详情
                recodeGoGoodsDetailRoute()
                navigation.navigate("SOMGoodsDetail", {
                    goodsId:res.indexOf("://commodity_detail") > 0?params.commodity_id:params.id
                });
            } else if (res.indexOf("://store_detail") > 0){
                navigation.navigate('Scan',{useWebview:true,ScanData:res})
            }
            else if (res.indexOf("://store_detail") > 0||res.indexOf("://sales_xiaoke_currency") > 0 || res.indexOf("://store_receipt") > 0 || res.indexOf("://offline_receipt_order") > 0 ) {
                CustomAlert.onShow(
                    "alert",
                    "请用晓可广场APP查看！",
                    "提示",
                    // (onConfirm = () => {
                    //     navigation.navigate("Scan", {
                    //         ScanData: res,
                    //         useWebview: true
                    //     });
                    // })
                );
            }
            else if (res.indexOf("://offline_consumption_order") > 0 ) {
                //线下消费订单----打开订单详情(商家点击到店)--xkgc://offline_consumption_order?orderId=111&orderType=111&consumptionCode=111
                let orderId = params.orderId
                let orderType = params.orderType
                let consumptionCode = params.consumptionCode
                let shopId = storeId
                Loading.show()
                fetchOBMBcleOrderMuserAppDetail({orderId}).then((res)=>{
                    if(res && res.shopId==shopId){
                        let sceneStatus = res.sceneStatus;
                        fetchBcleMUserConfirmConsume({consumeCode:consumptionCode,orderId}).then((res)=>{
                            callback(orderId)
                            switch (sceneStatus) {
                                case 'SERVICE_OR_STAY':
                                    //服务或者住宿类
                                    navigation.navigate('AccommodationOrder', { orderId: orderId, shopId: shopId, userId })
                                    break;
                                case 'TAKE_OUT':
                                    //外卖   售后
                                    navigation.navigate('GoodsTakeOut', { page: 'ScanConfig', orderId, shopId: shopId, userId })
                                    break;
                                case 'LOCALE_BUY':
                                    //现场消费E
                                    navigation.navigate('GoodsSceneConsumption', { orderId: orderId, shopId: shopId, userId })
                                    break;
                                case 'SERVICE_AND_LOCALE_BUY':
                                    navigation.navigate('StayStatementOrder', { orderId: orderId, shopId: shopId })
                                    //服务+现场消费+加购
                                    break;
                                case 'SHOP_HAND_ORDER':
                                    //线下订单
                                    navigation.navigate('OfflneOrder', { orderId: orderId, shopId: shopId })
                                    break;
                            }
                        })
                    }else{
                        Toast.show('该订单不属于该店铺，请切换正确的店铺')
                    }
                }).catch(err => {
                    console.log(err)
                });
            }
            // else if (res.indexOf("://order_detail") > 0) {
            //     //4.订单详情
            //     if (params.storeId == storeId) {
            //         callback(params)
            //     } else {
            //         CustomAlert.onShow(
            //             "confirm",
            //             "请切换正确的店铺！",
            //             "提示",
            //             (onConfirm = () => {
            //                 navigation.navigate(
            //                     "UserShopLists",
            //                     { canGoBack: true, chooseShop: true }
            //                 );
            //             }),
            //         );
            //     }
            // }
            else {
                const reg = /(http:\/\/|https:\/\/)((\w|=|\?|\.|\/|&|-)+)/g; //正则表达式判断http：// https：// 为合法
                const objExp = new RegExp(reg);
                const valuableUrl = objExp.test(res)
                navigation.navigate("Scan", {
                    ScanData: res,
                    useWebview: valuableUrl
                });
            }
        }
    }).catch(err => {
        console.log(err)
    });
};
