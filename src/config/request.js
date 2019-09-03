import qs from 'querystring';
import axios from 'axios';
import { Alert } from 'react-native';
import config from './config';
import { EncryptoRequestParams, DecryptResponseRequest } from '../utils/crypto';

/**
 * 重新登陆，重置路由至登陆页，弹窗提示登出信息
 * @param {Boolean} _goBack 是否允许返回
 * @param {Object} reason 原因 { code, message }
 */

export function ReLogin(_goBack = false, reason = { code: '', message: '当前登录已失效请重新登录' }) {
  app._store.dispatch({ type: 'user/logout', payload: { _goBack, reLogin: reason, pageFrom: 'request' } });
}

export function showForzenToast (reason = { code: '', message: '当前登录已失效请重新登录' }) {
  app._store.dispatch({ type: 'user/showToastUserIsForzen', payload: { reason } });
}

const ParseURL = (url) => {
  const urlParams = url.split('/');
  const funcName = urlParams[0];
  const platformName = urlParams[1];
  const serviceName = urlParams[2];
  const clientVersion = urlParams[3];
  let baseUrl = config.baseUrl;

  const requestUrl = `${baseUrl}api/${urlParams[0]}/${urlParams[1]}/${urlParams[2]}/${urlParams[3]}`;
  return {
    funcName,
    platformName,
    serviceName,
    clientVersion,
    requestUrl,
  };
};

/**
 * fetch请求
 * @param url 请求url
 * @param params  请求参数
 * @param params.method  请求方式
 * @param params.headers  请求头
 * @param params.data  请求数据
 * @param options 配置参数
 * @param options.isEncrypt  是否加密
 * @param options.timeout  请求超时
 * @param {boolean} options.closeLoading 服务接口响应后，是否关闭Loading，默认关闭
 * @param {boolean} options.toastWrong 是否显示toast
 */
export default async function request(method = 'GET', url, data = {}, closeLoading = true, isEncrypt = true, timeout = 15000, toastWrong = true) {
  const startTime = Date.now();
  let { requestUrl, serviceName, clientVersion } = ParseURL(url);
  // if(['mShopUpdate','mShopDetail','mShopCreate'].includes(serviceName)){
  //   requestUrl=requestUrl.replace('https://dev.api.xksquare.com','http://192.168.2.54:8084')
  // }
  // 1. 构建请求数据
  const requestParams = EncryptoRequestParams(data, serviceName, clientVersion, isEncrypt);
  // 2. 构建请求参数
  const fetchParams = {
    method,
    timeout,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    },
    withCredentials: true,
  };
  if (method.toUpperCase() === 'GET') {
    requestUrl += `?${qs.stringify(requestParams)}`;
  } else if (method.toUpperCase() === 'POST') {
    fetchParams.data = qs.stringify(requestParams);
  }
  // 3. 发起请求
  let response = null;
  try {
    const res = await axios(requestUrl, fetchParams);
    response = DecryptResponseRequest(res.data);
    console.log('地址', requestUrl);
    console.log('参数', data);
  } catch (error) {
    console.log('[src/config/request.js][request]', error);
    // Alert.alert("提示", error.toString())
    response = {
      code: 999,
      message: error.statusText || '网络正在开小差，请重新加载',
    };
  }
  // 4. 善后处理
  if (closeLoading && global.Loading) global.Loading.hide();
  switch (response.code) {
    case 1403: // 需要登录
    case 1413: // token 验证失败 两台手机同时登录一个账号，且其中一个手机发起带有token的操作，则会返回1413.
      ReLogin(false, response);
      response.body = null;
      break;
    case 1349: //
      ReLogin(false, response); // 被迫强制下线
      response.body = null;
    case 1356: // 用户被冻结
      ReLogin(false, response);
      response.body = null;
      break;
    case 409:
    case 1401:
      response.code = 200;
      response.body = null;
      break;
    case 415:
      response.code = 200;
      response.body = '';
      break;
    case 1352:
      response.code = 200;
      response.body = {
        code: 1352,
        message: '联盟商资料已经隐藏',
      };
      break;
    default:
      break;
  }
  const endTime = Date.now();
  console.log('[src/config/request.js][request]', url, `${(endTime - startTime) / 1000}s`);
  if (response.code !== 200) {
    if (response.message == '用户ID必须传入' || response.message == '用户token必须传入') {}// 没有传登录信息，代表已经退出了登录，其他请求的数据不需要toast错误信息
    else if (toastWrong && global.Toast) global.Toast.show(response.message || (`${response.code || ''}服务器异常`));
    console.log('%cerrorInfo', 'background-color: red;color: white', response, requestUrl);
    throw response;
  }
  console.log('[src/config/request.js][request]', response);
  return response.body;
}
