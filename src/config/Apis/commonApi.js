
import request from '../request';
/**
 * 请求服务器时间 defaultAPP
 * 将服务器返回的时间和当前的本地时间全局声明
 */
export function requestSystemTime() {
  return request('GET', 'sys/ma/systemTime/1.0');
}

/**
 * 获取地区代号 defaultAPP
 * @param {number} level 1 省 2 市 3 区
 * @param {string} version 版本号
 */
export function getRegionMap(level, version = '') {
  return request('GET', 'sys/ma/regionPage/1.0', {
    level, v: version, limit: 0, page: 1,
  }, false);
}

/**
 * 获取七牛上传token defaultAPP
 * @param {Boolean} 是否需要返回请求结果 isReturn
 */
export function requestQiniuToken(isReturn = true, isShowLoading = true) {
  return storageQiniuToken('load').then((res) => {
    console.log('storageQiniuToken', res);
    return res;
  }).catch(e => request('GET', 'sys/ma/qosstoken/1.0', {}, isShowLoading).then((res) => {
    console.log('qosstoken', res);
    storageQiniuToken('save', res.upToken, 3000000); // 七牛云 token 默认 50 分钟 后 过期
    // storageQiniuToken('save', res.upToken, 10000); // 七牛云 token 默认 10s 测试 分钟 后 过期
    if (isReturn) {
      return storageQiniuToken('load');
    }
  }));
}
/**
 * 发送验证码 defaultAPP
 */
export function sendAuthMessage(params = { phone: '', bizType: '' }) {
  // bizType是业务类型
  // REGISTER	注册
  // LOGIN	登录
  // UNBIND_BANK_CARD 删除银行卡
  // RESET_PASSWORD	密码重置
  // RESET_PHONE	修改手机号
  // BIND_PHONE	绑定手机号
  // CREATE_BIND_CODE	创建授权码
  // BIND_SHOP	绑定店铺
  // DELETE_EMPLOYEE	删除员工
  // SEND_BIND_CODE	发送授权码
  // LIGHTEN_SECURITY_CODE	点亮安全码
  // EXTINGUISH_SECURITY_CODE	熄灭安全码
  // NEW_BIND_SECURITY_CODE	新绑定安全码
  return request('POST', 'sys/ma/sendAuthMessage/1.0', params);
}

/**
 * 请求敏感词库 defaultAPP
 */
export const sensitiveWordLibraryDetail = () => request('POST', 'sys/ma/sensitiveWordLibraryDetail/2.0.13');


/**
 * storage相关操作
 */
export function storageFnc(key, status = 'save', data = null, expires = null) {
  const params = {
    key,
  };

  if (status === 'save') {
    storage.save({
      ...params,
      data,
      expires,
    });
  } else if (status === 'load') {
    return storage.load({
      ...params,
    });
  } else if (status === 'remove') {
    storage.remove({
      ...params,
    });
  }
}
/**
 * 缓存七牛上传token
 */
export function storageQiniuToken(status = 'save', data = null, expires = null) {
  return storageFnc('qiniuToken', status, data, expires);
}

// 联盟商详情 defaultAPP
// export function merchantIdentityDetail(params = {}) {
//   return request('POST', 'user/ma/merchantIdentityDetail/2.0', params);
// }
