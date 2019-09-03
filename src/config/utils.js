import CryptoJS from 'crypto-js';
import moment from 'moment';
import { Platform, StatusBar, Linking } from 'react-native';
import config from './config';
import * as requestApi from './requestApi';
import FastScanner from '../utils/fastscan';
import sensitiveDectionary from './sensitiveDectionary';
/**
 * 随机数
 * @param len 随机数长度，默认为1
 * @returns {string}
 */
export function MathRand(len = 1) {
  let num = '';
  for (let i = 0; i < len; i++) {
    num += Math.floor(Math.random() * 10);
  }
  return num;
}
export function compareNumber(prop) { // 比较数组对象中元素的大小,用法：lists.sort(compareObj.compareNumber('d'))
  return function (obj1, obj2) {
    let val1 = obj1[prop];
    let val2 = obj2[prop];
    if (!isNaN(Number(val1)) && !isNaN(Number(val2))) {
      val1 = Number(val1);
      val2 = Number(val2);
    }
    if (val1 < val2) {
      return 1;
    } if (val1 > val2) {
      return -1;
    }
    return 0;
  };
}

/**
 * 转为Base64的字符串
 * CryptoJS.enc.Utf8.parse  转为128bit的字符串
 * @returns {string}
 */
export function Base64(data) {
  return CryptoJS.enc.Base64.stringify(CryptoJS.enc.Utf8.parse(data));
}

/**
 * md5加密
 * @returns {string}
 */
export function MD5(data) {
  return CryptoJS.MD5(data).toString();
}

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
      padding: CryptoJS.pad.Pkcs7,
    },
  ).toString();
}

/**
 * 3des解密
 * @returns {string}
 */
export function DESdecrypt(data, key) {
  return CryptoJS.TripleDES.decrypt(
    {
      ciphertext: CryptoJS.enc.Base64.parse(data),
    },
    CryptoJS.enc.Utf8.parse(key),
    {
      mode: CryptoJS.mode.ECB,
      padding: CryptoJS.pad.Pkcs7,
    },
  ).toString(CryptoJS.enc.Utf8);
}

/**
 * 解析七牛返回的图片地址
 * @param {*} url  // 图片地址
 */
export function qiniuUrlAdd(url) {
  if (url) {
    if (url.indexOf('http') >= 0) {
      return url;
    }
    return config.qiniuUrl + url;
  }
  return config.qiniuUrl;
}

export function formatDate(date, fmt) {
  if (date) {
    if (/(y+)/.test(fmt)) {
      fmt = fmt.replace(RegExp.$1, (`${date.getFullYear()}`).substr(4 - RegExp.$1.length));
    }
    const o = {
      'M+': date.getMonth() + 1,
      'd+': date.getDate(),
      'h+': date.getHours(),
      'm+': date.getMinutes(),
      's+': date.getSeconds(),
    };
    for (const k in o) {
      if (new RegExp(`(${k})`).test(fmt)) {
        const str = `${o[k]}`;
        fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? str : (`00${str}`).substr(str.length));
      }
    }
    return fmt;
  }

  return '';
}
// 防抖
export const debounce = (fn, wait = 300) => {
  let timeout = null;
  return function () {
    if (timeout !== null) clearTimeout(timeout);
    timeout = setTimeout(fn, wait);
  };
};
// 节流
export const throttle = (func, delay = 300) => {
  let prev = Date.now();
  return function () {
    const context = this;
    const args = arguments;
    const now = Date.now();
    if (now - prev >= delay) {
      func.apply(context, args);
      prev = Date.now();
    }
  };
};
// 格式化金额
export const formatPriceStr = (str = '') => {
  let priceStr = '';
  if (typeof str !== 'string') {
    priceStr = String(str);
  } else {
    priceStr = str;
  }
  const pointIdx = priceStr.indexOf('.');
  let integer = '';
  let decimal = '';

  if (pointIdx > -1) {
    integer = priceStr.substr(0, pointIdx);
    decimal = priceStr.substr(pointIdx);
  } else {
    integer = priceStr;
    decimal = '.00';
  }

  let num = 0;
  const arr = [];
  for (let i = integer.length - 1; i >= 0; i -= 1) {
    arr.push(integer[i]);
    if ((num + 1) % 3 === 0 && i !== 0) {
      arr.push(',');
    }
    num += 1;
  }

  return arr.reverse().join('') + decimal;
};

// 四舍五入保留2位小数（若第二位小数为0，则保留一位小数）
export function keepTwoDecimal(num) {
  let result = parseFloat(num);
  if (isNaN(result)) {
    console.log('传递参数错误，请检查！');
    return false;
  }
  result = Math.round(num * 100) / 100;
  return result;
}

// 四舍五入保留2位小数（不够位数，则用0替补）
export function keepTwoDecimalFull(num) {
  let result = parseFloat(num);
  if (isNaN(result)) {
    console.log('传递参数错误，请检查！');
    return false;
  }
  result = Math.round(num * 100) / 100;
  let s_x = result.toString();
  let pos_decimal = s_x.indexOf('.');
  if (pos_decimal < 0) {
    pos_decimal = s_x.length;
    s_x += '.';
  }
  while (s_x.length <= pos_decimal + 2) {
    s_x += '0';
  }
  return s_x;
}
// 显示销量的文本
export function showSaleNumText(num, fixedNum = 2) {
  const baseNum_wan = 10000;
  const baseNum_sw = 100000;
  const baseNum_bw = 1000000;
  const baseNum_qw = 10000000;
  const baseNum_y = 100000000;
  const baseNum_sy = 1000000000;
  const baseNum_by = 10000000000;
  const baseNum_qy = 100000000000;
  const baseNum_wy = 1000000000000;
  if (num >= baseNum_wan && num < baseNum_sw) {
    return `${(num / baseNum_wan).toFixed(fixedNum)}万`;
  }
  if (num >= baseNum_sw && num < baseNum_bw) {
    return `${(num / baseNum_sw).toFixed(fixedNum)}十万`;
  }
  if (num >= baseNum_bw && num < baseNum_qw) {
    return `${(num / baseNum_bw).toFixed(fixedNum)}百万`;
  }
  if (num >= baseNum_qw && num < baseNum_y) {
    return `${(num / baseNum_qw).toFixed(fixedNum)}千万`;
  }
  if (num >= baseNum_y && num < baseNum_sy) {
    return `${(num / baseNum_y).toFixed(fixedNum)}亿`;
  }
  if (num >= baseNum_sy && num < baseNum_by) {
    return `${(num / baseNum_sy).toFixed(fixedNum)}十亿`;
  }
  if (num >= baseNum_by && num < baseNum_qy) {
    return `${(num / baseNum_by).toFixed(fixedNum)}百亿`;
  }
  if (num >= baseNum_qy && num < baseNum_wy) {
    return `${(num / baseNum_qy).toFixed(fixedNum)}千亿`;
  }
  if (num >= baseNum_wy) {
    return `${(num / baseNum_wy).toFixed(fixedNum)}万亿`;
  }
  // console.log('销量',num)
  return num;
}
// 对价格进行 万 处理
export function getSalePriceText(num = 0, fixedNum = 2) {
  
  const baseNum_wan = 10000;
  const baseNum_y = 100000000;
  const baseNum_sy = 1000000000;
  const baseNum_by = 10000000000;
  const baseNum_qy = 100000000000;
  const baseNum_wy = 1000000000000;
  if (num >= baseNum_wan && num < baseNum_y) {
    return `${(parseInt((num / baseNum_wan) * 100) / 100 )}万`;
  }
  if (num >= baseNum_y && num < baseNum_sy) {
    return `${(parseInt((num / baseNum_y) * 100) / 100 )}亿`;
  }
  if (num >= baseNum_sy && num < baseNum_by) {
    return `${(parseInt((num / baseNum_sy) * 100) / 100 )}十亿`;
  }
  if (num >= baseNum_by && num < baseNum_qy) {
    return `${(parseInt((num / baseNum_by) * 100) / 100 )}百亿`;
  }
  if (num >= baseNum_qy && num < baseNum_wy) {
    return `${(parseInt((num / baseNum_qy) * 100) / 100 )}千亿`;
  }
  if (num >= baseNum_wy) {
    return `${(parseInt((num / baseNum_wy) * 100) / 100 )}万亿`;
  }
  return num;
}

// 密码验证
export function regExpPassWord(pwd) {
  console.log(pwd);
  // 检测空格
  if (pwd.indexOf(' ') !== -1) {
    Toast.show('密码不能包含空格');
    return false;
  }
  // 验证是否是 6-20 数字和字母或者符号的组合
  if (!(/^(?![\d]+$)(?![a-zA-Z]+$)(?![^\da-zA-Z]+$).{6,20}$/.test(pwd))) {
    Toast.show('密码为6-20位数字、英文、符号的组合');
    return false;
  }
  return true;
}
// 判断是否更新
export function checkOutVerRang(max = 10000, min = 10000, nowVer = 10000) {
  console.log('nowVer', nowVer);
  const _nowVerArr = nowVer.split('.');
  const temp = [];
  _nowVerArr.map((item, index) => {
    if (index >= 1) {
      temp.push(item.padStart(2, '0'));
    } else {
      temp.push(item);
    }
  });
  const _nowVer = parseInt(temp.join(''));
  console.log(_nowVer);
  if (_nowVer >= min && _nowVer <= max) {
    return true;
  }
  return false;
}
/**
 *
 * @param {String} name 用户名
 */
export function OmitUserName(name = '') {
  if (!name) return;
  const temp = name.split('');
  const arr = temp.map((item, i) => {
    if (i >= 2 && i < temp.length - 1) {
      return '*';
    }
    return item;
  });
  return arr.join('');
}
function getBannerRedirection(router = 'Home', params = {}) {
  return {
    router,
    params,
  };
}
/**
 * bannerJumpFun banner跳转规则
 * @param {Object} param type 1: http跳转, type 2: app 内部跳转
 */
export function bannerJumpFun(param = {}) {
  console.log('param', param);
  // 设置默认值
  const webViewUrl = param.type === 1 ? { uri: '', showLoading: false, headers: { 'Cache-Control': 'no-cache' } } : { router: 'Home', params: {} };
  // 判断跳转类型
  const type = param.type;
  if (type === 1) { //  http跳转
    if (!param.jumpRN) return webViewUrl;// 跳转链接为空，不处理
    webViewUrl.uri = param.jumpRN;
    // 检测是否是公司域名，如果是显示WebView Loading
    if (param.jumpRN.indexOf('xksquare.com') !== -1) {
      webViewUrl.showLoading = true;
    }
    return webViewUrl;
  }
  if (type === 2) { // app 内部跳转
    let jumpRN;
    try {
      jumpRN = JSON.parse(param.jumpRN);
    } catch (error) {
      console.log(error);
      return webViewUrl;
    }
    StatusBar.setBarStyle('light-content');
    switch (jumpRN.modular) {
      // 福利商品详情
      case 'welfGoods': return getBannerRedirection('WMGoodsDetail', { goodsId: jumpRN.id, sequenceId: jumpRN.sequenceId });
        // 批发商品详情
      case 'selfGoods': recodeGoGoodsDetailRoute();return getBannerRedirection('SOMGoodsDetail', { goodsId: jumpRN.id });
        // 自营商品某分类商品列表
      case 'selfClass': return getBannerRedirection('SOMListsThird', { item: { code: jumpRN.id, name: jumpRN.name } });
        // 自营商城推荐商品列表
      case 'selfRe': return getBannerRedirection('SOMLists', { categoryLists: [] });
        // 福利商城推荐商品列表
      case 'welfRe': return getBannerRedirection('WMLists', { index: 10 });
      default: return getBannerRedirection();
    }
  }
  return webViewUrl;
}
// 检查权限
/**
 *
 * @param {Number} isAdmin 是否是主账号 1主账号 0 分号
 * @param {String} role 当前功能权限
 * @param {Array} allRole 所有权限
 */
export const checkoutRole = (role = '', allRole = [], isAdmin = global.loginInfo.isAdmin || 0) => {
  // 主账号，全部权限（店铺已单独判断）
  if (isAdmin) return true;
  const isPass = allRole.includes(role);
  if (!isPass) {
    Toast.show('没有权限访问！');
  }
  return isPass;
};
// 获取快递公司
export const getLogisticsInfo = (logisticsName) => {
  switch (logisticsName) {
    case 'XK': return '晓可自营物流';
    case 'SF': return '顺丰';
    case 'YD': return '韵达';
    case 'ZT': return '中通';
    case 'ST': return '申通';
    case 'YT': return '圆通';
    case 'BSHT': return '百世汇通';
    case 'HIMSELF': return '用户自行配送';
    default: return '加载中...';
  }
};
// 图片地址加后缀，获取缩略图
export const getPreviewImage = (url = '', percent = '25p') => {
  if (!url) return url;
  // if (url.indexOf('xksquare') !== -1) {
  //     return url
  // }
  if (url.indexOf('?') !== -1) {
    return `${url}|imageMogr2/thumbnail/!${percent}`;
  }
  return `${url}?imageMogr2/thumbnail/!${percent}`;
};
// 获取订单状态
export const getOrderStatus = (state = '') => {
  switch (state) {
    case 'NO_LOTTERY': return '未开奖';
    case 'LOSING_LOTTERY': return '未中奖';
    case 'NOT_SHARE': return '未分享';
    case 'NOT_DELIVERY': return '未发货';
    case 'DELIVERY': return '已发货';
    case 'WINNING_LOTTERY': return '待晒单';
    case 'SHARE_LOTTERY': return '已晒单';
    case 'SHARE_AUDIT_ING': return '晒单审核中';
    case 'SHARE_AUDIT_FAIL': return '晒单未通过';
    default: return '查询中...';
  }
};
// 获取售后订单小标签文案
export const getRefundOrderTagText = (status = '') => {
  /**
        申请售后的时候，图片上标签显示 “售后中”
        售后被拒后  不显示图片上的标签
        已完成售后的时候，显示“已售后”
     * */
  switch (status) {
    case 'COMPLETE': return '已售后';
    default: return '售后中';
  }
};
// 设定moment.from字符串
export const initMomentFromString = () => {
  moment.locale('en', {
    relativeTime: {
      future: '未来',
      past: '%s',
      s: '刚刚',
      m: '1分钟前',
      mm: '%d分钟前',
      h: '1小时前',
      hh: '%d小时前',
      d: '1天前',
      dd: '%d天前',
      M: '1个月前',
      MM: '%d个月前',
      y: '1年前',
      yy: '%d年前',
    },
  });
};
// 获取协议地址
/**
 *
 * @param {Array} merchant
 * @param {*String} contractConfigKey
 */
export const getProtocolUrl = (contractConfigKey = '') => {
  if (!contractConfigKey) {
    return null;
  }
  return new Promise((resolve, reject) => {
    requestApi.merchantContractAgreement({
      contractConfigKey,
      forPlatform: 'mam',
    }).then((res) => {
      console.log('获取的协议地址', res);
      resolve(res);
    }).catch((err) => {
      reject(err);
      // Toast.show("协议请求失败")
    });
  });
};

// 敏感词汇屏蔽为 ****
sensitiveWords = (offWords = [], _content = '') => {
  if (offWords.length === 0 || _content === '') return _content;
  const str = '**********';
  offWords.forEach(([key, value]) => {
    _content = _content.replace(value, str.substring(0, value.length > str.length ? str.length : value.length));
  });
  console.log('_content', _content);
  return _content;
};

export const getRemoteSensitiveWords = () => {
  try {
    const state = app._store.getState();
    const remoteSensitiveWords = state.application.remoteSensitiveWords;
    return remoteSensitiveWords;
  } catch (error) {
    return [];
  }
};

// 查找敏感词
export const ScanSensitiveWords = (content = '') => {
  const _content = content;
  const remoteSensitiveWords = getRemoteSensitiveWords();
  const scanner = new FastScanner(remoteSensitiveWords.length > 0 ? remoteSensitiveWords : sensitiveDectionary);
  const offWords = scanner.search(_content);
  console.log('offWords', offWords);
  return sensitiveWords(offWords, _content);
};

// 计算字符串大小
export const CalculatingStringSize = (clearModelsArrToStr) => {
  const fileSizeByte = clearModelsArrToStr.length;
  let fileSizeMsg = '';
  if (fileSizeByte < 1048576) fileSizeMsg = `${(fileSizeByte / 1024).toFixed(2)}KB`;
  else if (fileSizeByte == 1048576) fileSizeMsg = '1MB';
  else if (fileSizeByte > 1048576 && fileSizeByte < 1073741824) fileSizeMsg = `${(fileSizeByte / (1024 * 1024)).toFixed(2)}MB`;
  else if (fileSizeByte > 1048576 && fileSizeByte == 1073741824) fileSizeMsg = '1GB';
  else if (fileSizeByte > 1073741824 && fileSizeByte < 1099511627776) fileSizeMsg = `${(fileSizeByte / (1024 * 1024 * 1024)).toFixed(2)}GB`;
  else fileSizeMsg = '文件超过1TB';
  return fileSizeMsg;
};

// 计算时差

export const getDiffTime = (endDate) => {
  let diff = (Date.parse(new Date(endDate)) - Date.parse(new Date())) / 1000;

  if (diff <= 0) {
    return false;
  }

  const timeLeft = {
    years: 0,
    days: 0,
    hours: 0,
    min: 0,
    sec: 0,
    millisec: 0,
  };

  if (diff >= (365.25 * 86400)) {
    timeLeft.years = Math.floor(diff / (365.25 * 86400));
    diff -= timeLeft.years * 365.25 * 86400;
  }
  if (diff >= 86400) {
    timeLeft.days = Math.floor(diff / 86400);
    diff -= timeLeft.days * 86400;
  }
  if (diff >= 3600) {
    timeLeft.hours = Math.floor(diff / 3600);
    diff -= timeLeft.hours * 3600;
  }
  if (diff >= 60) {
    timeLeft.min = Math.floor(diff / 60);
    diff -= timeLeft.min * 60;
  }
  timeLeft.sec = diff;
  return timeLeft;
};

export const delay = (second = 1) => new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve();
  }, second * 1000);
});

// 记录进入商品详情页的路由以及购买状态
export const recodeGoGoodsDetailRoute = (routeName = '', payStatus = false) => {
  // app._store.dispatch({ type: 'mall/save', payload: { inGoodsDetailRoute: { routeName, payStatus } } })
}

/**
 * 替换电话号码为****
 * @param {String} str 替换的号码
 * @param {String} replaceChar 替换的字符
 * @param {Number} startIndex 起始位置
 * @param {Number} endIndex 终止位置
 */
export const customReplacePhoneNumber = (str = '13524526854', replaceChar = '****', startIndex = 3, endIndex = -4) => {
  if (!str || !endIndex) return str;
  return `${str.slice(0, startIndex)}${replaceChar}${endIndex > 0 ? str.slice(endIndex, str.length) : str.slice(endIndex)}`;
};


export const callPhone = (phone) => {
  console.log('callNumber ----> ', phone);
  const phoneNumber = Platform.OS !== 'android' ? `telprompt:${phone}` : `tel:${phone}`;
  Linking.canOpenURL(phoneNumber)
    .then((supported) => {
      if (!supported) {
        Toast.show('拨打失败，请手动拨打');
      } else {
        return Linking.openURL(phoneNumber);
      }
    })
    .catch(err => console.log(err));
};

export const sortLists = (arr,key) => {//排序
  var objectArraySort = function (index) {
    return function (objectN, objectM) {
      var valueN = objectN[index]
      var valueM = objectM[index]
      if (valueN < valueM) return -1
      else if (valueN > valueM) return 1
      else return 0
    }
  }
  arr.sort(objectArraySort(key || 'index'))
  return arr
}
