/**
 * app 配置
 */
// import ENV from './requestConfig.json'
import ENV from '../../android/app/src/main/assets/requestConfig';

const netHeader = ENV.netHeader;
const wechatAppidAdmin = 'wx852fa85c26f60106';// 微信正式appid
const wechatAppidTest = 'wx469f90e31aa7c9d8';// 微信测试appid

let prefix = 'dev.xksquare.com';
let prefix2 = 'dev.api.xksquare.com';
let envir = parseInt(ENV.envir, 10);
switch (envir) {
    case 0:
        prefix = 'xkadmin.xksquare.com';
        prefix2 = 'pe.api.xksquare.com';
        break;
    case 1:
        prefix = 'devw.xksquare.com';
        prefix2 = 'dev.api.xksquare.com';
        break;
    case 2:
        prefix = 'testw.xksquare.com';
        prefix2 = 'test.api.xksquare.com';
        break;
    case 3:
        prefix = 'final.xksquare.com';
        prefix2 = 'final.api.xksquare.com';
        break;
    default:
        break;
}

const config = {
    netHeader,
    // local
    baseUrl_h5: `${netHeader}://${prefix}/web/#/`,
    baseUrl: `${netHeader}://${prefix2}/`,
    // baseUrl: ENV.envir == 1 ?`http://192.168.2.18:8081/`: ENV.envir == 2 ?`${netHeader}://test.api.xksquare.com/`:`${netHeader}://pe.api.xksquare.com/`,
    baseUrl_profit_h5: `${netHeader}://${prefix}/profit/#/`,
    baseUrl_share_h5: `${netHeader}://${prefix}/share/#/`,
    qiniuUrl: `${netHeader}://gc.xksquare.com/`,
    signKey: 'e10adc3949ba59abbe56e057f20f883e', // 加密sign
    dataKey: 'c33367701511b4f6020ec61ded352059', // 解密datay
    wechatAppidAdmin, // 微信正式appid
    wechatAppidTest, // 微信正式appid
    wechatAppId: envir === 0 ? wechatAppidAdmin : wechatAppidTest, // 微信appid
    wechatSecret: '3c890a237dc25bd990294921cde1d393', // 微信密钥
    wechatMerchantId: '1519945971', // 微信商户号
    aliPayAppId: envir === 0 ? '2019041263857626' : '2018112962397184', // 支付宝appid
    jpushAppKey: '757dedda0859fccf90e2ed5d', // 极光appkey
    appName: '晓可联盟',
};

console.warn(config.baseUrl);
export default config;
