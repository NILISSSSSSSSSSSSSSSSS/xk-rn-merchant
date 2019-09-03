import CryptoJS from 'crypto-js';
import { Platform } from 'react-native';
import DeviceInfo from 'react-native-device-info';
import config from '../config/config'
/**
 * 随机数
 * @param len 随机数长度，默认为1
 * @returns {string}
 */
export function MathRand(len = 1) {
    let num = "";
    for (let i = 0; i < len; i++) {
        num += Math.floor(Math.random() * 10);
    }
    return num;
};

/**
 * 转为Base64的字符串
 * CryptoJS.enc.Utf8.parse  转为128bit的字符串
 * @returns {string}
 */
export function Base64(data) {
    return CryptoJS.enc.Base64.stringify(CryptoJS.enc.Utf8.parse(data));
};

/**
 * md5加密
 * @returns {string}
 */
export function MD5(data) {
    return CryptoJS.MD5(data).toString();
};

/**
 * 3des加密
 * @returns {string}
 */
export function DESencrypt(data, key) {
    return CryptoJS.TripleDES.encrypt(
        data,
        CryptoJS.enc.Utf8.parse(key),
        {
            mode: CryptoJS.mode.ECB,
            padding: CryptoJS.pad.Pkcs7
        }
    ).toString();
};

/**
 * 3des解密
 * @returns {string}
 */
export function DESdecrypt(data, key) {
    return CryptoJS.TripleDES.decrypt(
        {
            ciphertext: CryptoJS.enc.Base64.parse(data)
        },
        CryptoJS.enc.Utf8.parse(key),
        {
            mode: CryptoJS.mode.ECB,
            padding: CryptoJS.pad.Pkcs7
        }
    ).toString(CryptoJS.enc.Utf8);
};

/**
 * reqeust加密参数
 * @param {*} params
 * @param {*} serviceName
 * @param {*} clientVersion
 * @param {*} isEncrypt
 */
export function EncryptoRequestParams(params, serviceName = "", serviceVersion = "1.0", isEncrypt = true) {
    let requestParams = {
        os: Platform.OS,  // 操作系统
        clientVersion: DeviceInfo.getVersion(),  // 版本号
        mobileType: 'mobile',  // 手机型号
        guid: global.uniqueIdentifier || '000',  // 设备编号
        channel: 'App Store',  // 渠道
        token: global.loginInfo && global.loginInfo.token || '',
        userId: global.loginInfo && global.loginInfo.userId || '',
        ...params
    }
    console.log("[src/utils/crypto.js][EncryptoRequestParams]", requestParams, global.requestTime)
    let salt =  MathRand(6);
    let timestamp = global.requestTime ? new Date().getTime() - global.requestTime.localTime + global.requestTime.systemTime : new Date().getTime();
    let data = isEncrypt ? DESencrypt(JSON.stringify(requestParams), MD5(salt + config.dataKey)) : JSON.stringify(requestParams);
    let sign = MD5(serviceName + timestamp + data + serviceVersion + salt + config.signKey);
    return {
        service: serviceName,
        version: serviceVersion,
        timestamp,
        salt,
        sign,
        data
    }
}

/**
 * response解密数据
 * @param {*} data
 */
export function DecryptResponseRequest(data) {
    let key = MD5(data.key + config.dataKey);
    data.body = data.key ? JSON.parse(DESdecrypt(data.body, key)) : data.body ? typeof data.body === "object" ? data.body : JSON.parse(data.body) : data.body;
    return data
}
