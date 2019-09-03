/**
 * 支付方法
 */
import { Platform, Alert, NativeModules } from 'react-native';
import * as wechat from '@scxkkj/react-native-wechat';
import config from './config';

const Alipay = NativeModules.AlipayModule;
const WeChat = NativeModules.WeChat;

export const wechatPay = (payParam = { param: {}, successCallBack: () => { }, faildCallBack: () => { } }) => {
  // let param = {
  //     partnerId: "...", // 商家向财付通申请的商家id
  //     prepayId: "xxxxxx", // 预支付订单
  //     nonceStr: "xxxxxx", // 随机串，防重发
  //     timeStamp: "xxxxxxx", // 时间戳，防重发.
  //     package: "Sign=WXPay", // 商家根据财付通文档填写的数据和签名
  //     sign: "xxxxxxxxx" // 商家根据微信开放平台文档对数据做的签名
  // };
  payParam.param.package = payParam.param.package || payParam.param.pack;
  console.log('微信支付1', payParam.param);
  wechat.isWXAppInstalled().then(async (isInstalled) => {
    console.log('isInstalled', isInstalled);
    if (!isInstalled) {
      payParam.faildCallBack && payParam.faildCallBack('没有安装微信');
      CustomAlert.onShow(
        'alert',
        '请先安装微信客户端再进行登录',
        '没有安装微信',
      );
    } else {
      if (payParam.param.appId) WeChat.registerApp(payParam.param.appId, () => {});
      else WeChat.registerApp(config.wechatAppId, () => {});

      wechat.pay(payParam.param).then((res) => {
        console.log('wechatPay', res);
        // 支付成功回调
        if (res.errCode == '0') {
          // 回调成功处理
          payParam.successCallBack && payParam.successCallBack(res);
        } else {
          payParam.faildCallBack && payParam.faildCallBack(res);
        }
      }).catch((err) => {
        console.log('wechatError', err);
        payParam.faildCallBack && payParam.faildCallBack(err);
      });
    }
  }).catch(() => {
    CustomAlert.onShow(
      'alert',
      '请先安装微信客户端再进行登录',
      '没有安装微信',
    );
  });
};
export const alipay = (payParam = { param: {}, successCallBack: () => { }, faildCallBack: () => { } }) => {
  payParam.successCallBack ? null : payParam.successCallBack = (() => {});
  payParam.faildCallBack ? null : payParam.faildCallBack = (() => {});
  console.log('aliPayParams', payParam);
  Alipay.pay(payParam.param).then((data) => {
    console.log('alipayResult', data);
    let str = '';
    if (Platform.OS === 'android') {
      const arr = data.split(';');
      str = arr[2].replace('result=', '');
      str = str.substr(1, str.length - 2);
    } else {
      str = data && data[0].result;
    }
    console.log(str);
    const str_json = JSON.parse(str);

    if (str_json && str_json.alipay_trade_app_pay_response) {
      /* 处理支付结果 */
      console.log('payCallBack', payParam.successCallBack);
      switch (str_json.alipay_trade_app_pay_response.code) {
        case '10000':
          payParam.successCallBack(str_json);
          break;
        case '9000':
          payParam.successCallBack(str_json);
          break;
        case '8000':
          CustomAlert.onShow(
            'alert',
            '支付结果未知,请查询订单状态',
          );
          payParam.faildCallBack(str_json);
          break;
        case '4000':
          CustomAlert.onShow('alert', '订单支付失败', 'lll');
          payParam.faildCallBack(str_json);
          break;
        case '5000':
          CustomAlert.onShow('alert', '重复请求');
          payParam.faildCallBack(str_json);
          break;
        case '6001':
          CustomAlert.onShow('alert', '用户中途取消');
          payParam.faildCallBack(str_json);
          break;
        case '6002':
          CustomAlert.onShow('alert', '网络连接出错');
          payParam.faildCallBack(str_json);
          break;
        case '6004':
          CustomAlert.onShow(
            'alert',
            '支付结果未知,请查询订单状态',
          );
          payParam.faildCallBack(str_json);
          break;
        default:
          // CustomAlert.onShow(
          //     "alert",
          //     "其他失败原因2",
          //     "支付失败！"
          // );
          payParam.faildCallBack(str_json);
          break;
      }
    } else {
      // CustomAlert.onShow(
      //     "alert",
      //     "其他失败原因1",
      //     "支付失败！"
      // );
      payParam.faildCallBack(str_json);
    }
  }, (err) => {
    console.log(err);
    // CustomAlert.onShow("alert", "请重试", "支付失败！");
    payParam.faildCallBack(err);
  }).catch((err) => {
    console.log(err);
    // CustomAlert.onShow("alert", "请重试", "支付失败！");
    payParam.faildCallBack(err);
  });
};
// 微信支付
// export const wechatPay = (param = { orderNo: '', totalAmount: 1, successCallBack: () => { }, faildCallBack: () => { } }) => {
//     // totalAmount是分，不是元
//     let payUrl = `http://192.168.2.57:8089/api/external/payment/createAppOrder?channel=WX&orderNo=${param.orderNo}&orderAmount=${parseFloat(param.totalAmount)}`;
//     wechat.isWXAppInstalled().then(isInstalled => {
//         if (isInstalled) {
//             Https.apiPost(payUrl)
//                 .then(data => {
//                     console.log('微信支付', data)
//                     if (data && data.status == "200") {
//                         let payParam = data.data;
//                         payParam.package = payParam.pack;
//                         // let param = {
//                         //     partnerId: "...", // 商家向财付通申请的商家id
//                         //     prepayId: "xxxxxx", // 预支付订单
//                         //     nonceStr: "xxxxxx", // 随机串，防重发
//                         //     timeStamp: "xxxxxxx", // 时间戳，防重发.
//                         //     package: "Sign=WXPay", // 商家根据财付通文档填写的数据和签名
//                         //     sign: "xxxxxxxxx" // 商家根据微信开放平台文档对数据做的签名
//                         // };
//                         wechat.pay(payParam).then(requestJson => {
//                             //支付成功回调
//                             if (requestJson.errCode == "0") {
//                                 //回调成功处理
//                                 param.successCallBack && param.successCallBack(data)
//                             }
//                             else {
//                                 param.faildCallBack && param.faildCallBack(data)
//                             }
//                         }).catch(err => {
//                             console.log(err);
//                             param.faildCallBack && param.faildCallBack(err)
//                         })
//                     }
//                     else {
//                         CustomAlert.onShow("alert", "请重试", data.message || "支付失败！");
//                     }
//                 })
//                 .catch(() => {
//                     CustomAlert.onShow("alert", "请重试", "支付失败！");
//                 });
//         } else {
//             CustomAlert.onShow(
//                 "alert",
//                 "请先安装微信客户端再进行登录",
//                 "没有安装微信"
//             );
//         }
//     });
// };

// /*打开支付宝进行支付*/
// export const alipay = (param = { orderNo: '', totalAmount: 1, successCallBack: () => { }, faildCallBack: (res) => { } }) => {
//     let payUrl = `${config.baseUrl}api/external/payment/createAppOrder?channel=ALI&orderNo=${param.orderNo}&totalAmount=${parseFloat(param.totalAmount)}`;
//     let successCallBack = param.successCallBack;
//     let faildCallBack = param.faildCallBack;
//     console.log('datadatadata', payUrl)
//     Https.apiPost(payUrl).then(data => {
//         console.log('datadatadata', data)
//         if (data && data.status == "200") {
//             Alipay.pay(data.data.aliPayStr).then(data => {
//                 console.log('datadatadata', data)
//                 if (data.length && data[0].resultStatus) {
//                     /*处理支付结果*/
//                     switch (data[0].resultStatus) {
//                         case "9000":
//                             successCallBack(data);
//                             break;
//                         case "8000":
//                             CustomAlert.onShow(
//                                 "alert",
//                                 "支付结果未知,请查询订单状态"
//                             );
//                             faildCallBack(data)
//                             break;
//                         case "4000":
//                             CustomAlert.onShow("alert", "订单支付失败", 'lll');
//                             faildCallBack(data)
//                             break;
//                         case "5000":
//                             CustomAlert.onShow("alert", "重复请求");
//                             faildCallBack(data)
//                             break;
//                         case "6001":
//                             CustomAlert.onShow("alert", "用户中途取消");
//                             faildCallBack(data)
//                             break;
//                         case "6002":
//                             CustomAlert.onShow("alert", "网络连接出错");
//                             faildCallBack(data)
//                             break;
//                         case "6004":
//                             CustomAlert.onShow(
//                                 "alert",
//                                 "支付结果未知,请查询订单状态"
//                             );
//                             faildCallBack(data)
//                             break;
//                         default:
//                             CustomAlert.onShow(
//                                 "alert",
//                                 "其他失败原因2",
//                                 "支付失败！"
//                             );
//                             faildCallBack(data)
//                             break;
//                     }
//                 } else {
//                     CustomAlert.onShow(
//                         "alert",
//                         "其他失败原因1",
//                         "支付失败！"
//                     );
//                     faildCallBack(data)
//                 }
//             }, err => {
//                 console.log(err);
//                 CustomAlert.onShow("alert", "请重试", "支付失败！");
//                 faildCallBack(err)
//             }
//             );
//         }
//     });
// };
