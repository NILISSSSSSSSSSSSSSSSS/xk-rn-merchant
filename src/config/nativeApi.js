/**
 * 原生接口调用
 */
import {
  NativeModules, Platform, PermissionsAndroid,
} from 'react-native';
import CameraRoll from '@react-native-community/cameraroll'
import RNFS from 'react-native-fs';
import * as requestApi from './requestApi';
import { RequestWriteAndReadPermission, RequestContactPermission, RequestWritePermission } from './permission';
import { QiniuUploadFiles } from '../utils/qiniuUpload';
import config from './config';

const WeChat = NativeModules.WeChat;

// 获取设备唯一标识
export function getUniqueIdentifier() {
  return NativeModules.xkMerchantModule.getUniqueIdentifier();
}
export function loginSuccess(param, atuologin) { // 登录成功
  console.log('调原生登录成功', param);
  NativeModules.xkMerchantModule.loginSuccess(param, atuologin);
}
export function loginOut(param) { // 退出登录
  console.log('调原生登出', param);
  NativeModules.xkMerchantModule.loginOut(param);
}

// 获取定位信息
export function getLocation() {
  return NativeModules.xkMerchantModule.getLocation();
}

export const getLocationCode = async () => {
  const defaultRegionCode = '510100';
  const keyword = (global.userLocations && global.userLocations.region && global.userLocations.region.toLowerCase()) || '德阳市'; // 成都市510100
  try {
    const res = await requestApi.regionPage({ page: 1, limit: 10, keyword });
    global.regionCode = res && res.data && res.data[0] ? res.data[0].code : defaultRegionCode;
  } catch (error) {
    global.regionCode = defaultRegionCode;
  }
  return null;
};

// 获取经纬度信息
export function getGeolocation() {
  const lng = '104.07';
  const lat = '30.67';
  return new Promise((resolve, reject) => {
    if (global.userLocations) {
      global.lng = global.userLocations.lon;
      global.lat = global.userLocations.lat;
    } else {
      global.lng = lng;
      global.lat = lat;
    }
    resolve({
      lng: global.lng,
      lat: global.lat,
    });
  });
}

/**
 * 分享
 * @param {string} type 分享到哪个平台 { QQ (QQ好友), QQ_Z (QQ空间), WX (微信好友), WX_P (微信朋友圈), WB (微博) }
 * @param {string} url  网页链接
 * @param {string} title 标题
 * @param {string} info 分享备注
 * @param {string} iconUrl 缩略图地址
 */
export function nativeShare(type = 'WX', url = '', title = '', info = '', iconUrl = '') {
  if (type === 'WX' || type === 'WX_P') {
    WeChat.registerApp(config.wechatAppId, () => { });
  }
  return NativeModules.xkMerchantModule.share(type, url, title, info, iconUrl);
}
/**
 *
 * @param {String} info 参数拼接在字符串中 type (0 商品 1 福利), sequenceId(自营可不传期id),goodsId 商品id, iconUrl 图片地址， name 名称， price 价格， 规格描述： description
 */
export function shareToKYFriend(info = '') {
  return NativeModules.xkMerchantModule.shareToKYFriend(info);
}
// 调用客服服务
export function openAppCustomerService() {
  // return NativeModules.xkMerchantModule.openAppCustomerService();
}
/**
 * 下载网页图片
 * @param uri  图片地址
 * @returns {*}
 */
export function DownloadImage(uri) {
  if (!uri) return null;
  return new Promise((resolve, reject) => {
    const timestamp = new Date().getTime(); // 获取当前时间错
    const random = String((Math.random() * 1000000) | 0); // 六位随机数
    const dirs = Platform.OS === 'ios'
      ? RNFS.LibraryDirectoryPath
      : RNFS.ExternalDirectoryPath; // 外部文件，共享目录的绝对路径（仅限android）
    const downloadDest = `${dirs}/${timestamp + random}.jpg`;
    const formUrl = uri;
    const options = {
      fromUrl: formUrl,
      toFile: downloadDest,
      background: true,
      progress: (res) => {
        // console.log(res)
      },
      begin: (res) => {
        // console.log('begin', res);
        // console.log('contentLength:', res.contentLength / 1024 / 1024, 'M');
      },
    };
    try {
      const ret = RNFS.downloadFile(options);
      ret.promise
        .then(async (res) => {
          // console.log('res', res)
          // console.log('success', res);
          // console.log('file://' + downloadDest)
          const granted = await RequestWritePermission();
          if (!granted) return;
          const promise = CameraRoll.saveToCameraRoll(downloadDest);
          promise.then((result) => {
            Loading.hide();
            Toast.show(`保存成功！地址如下：\n${result}`);
          }).catch((error) => {
            console.log('error', error);
            Loading.hide();
            Toast.show(`保存失败！\n${error}`);
          });
          resolve(res);
        })
        .catch((err) => {
          Loading.hide();
          reject(new Error(err));
        });
    } catch (e) {
      Loading.hide();
      reject(new Error(e));
    }
  });
}

/**
 * 选择图片和视频
 * @param {string} token 七牛上传token
 * @param {number} type 选择类型 1 图片 2 视频 3 选择图片或者视频
 * @param {number} crop 是否需要裁剪 0 不裁剪 1 裁剪
 * @param {number} totalNum 需要选择的文件数量
 * @param {number} limit 限制上传的文件大小 0 不限制大小 >0 限制大小（单位KB）
 * @param {number} duration  限制上传视频的长度 0 不限制视频时长 >0 限制视频时长(单位秒)
 */
export async function pickImageAndVideo(token, type, crop = 0, totalNum = 1, limit = 0, duration = 0) {
  Platform.OS == 'android' ? onBackPressed() : null;
  try {
    const granted = await RequestWriteAndReadPermission();
    if (!granted) {
      Toast.show('未获取到存储权限');
      return [];
    }
    const result = await NativeModules.xkMerchantModule.pickImageAndVideo(type, crop, totalNum, limit, duration);
    console.log('选择图片和视频', result);
    if (!Array.isArray(result)) {
      Loading.hide();
      Toast.show('原生接口返回结果不是数组');
      return [];
    }
    Loading.show('开始上传');
    const urls = result.filter(item => !!(item.videoPath || item.imagePath)).map(item => `file://${item.videoPath || item.imagePath}`);
    if (urls.length === 0) {
      Loading.hide();
      Toast.show('未获取到需要上传的内容');
      return [];
    }
    const values = await QiniuUploadFiles(urls, token, (evt) => {
      console.log(evt);
      Loading.show(`上传进度${evt.loadedFileNum}/${evt.totalFileNum}`);
    });
    Loading.hide();
    Toast.show('上传成功');
    return values;
  } catch (error) {
    if (error && error.message) {
      Toast.show(error.message);
    } else {
      Loading.hide();
      Toast.show('上传失败');
    }
    return [];
  }
}

/**
 * 拍摄（拍照或者视频）
 * @param {string} token 七牛上传token
 * @param {number} type 选择类型 0:拍照，1:拍视频，2:既能拍照又能拍视频
 * @param {number} crop 是否需要裁剪 0 不裁剪 1 裁剪
 * @param {number} duration  限制上传视频的长度 0 不限制视频时长 >0 限制视频时长(单位秒)
 */
export async function takeImageAndVideo(token, type, crop = 0, duration = 0) {
  Platform.OS == 'android' ? onBackPressed() : null;
  try {
    const granted = await RequestWriteAndReadPermission();
    if (!granted) {
      Loading.hide();
      Toast.show('未获取到存储权限');
      return [];
    }
    const result = await NativeModules.xkMerchantModule.takeImageAndVideo(type, crop, duration);
    if (!Array.isArray(result)) {
      Loading.hide();
      Toast.show('原生接口返回结果不是数组');
      return [];
    }
    Loading.show('开始上传');
    const urls = result.filter(item => !!(item.videoPath || item.imagePath)).map(item => `file://${item.videoPath || item.imagePath}`);
    if (urls.length === 0) {
      Loading.hide();
      Toast.show('未获取到需要上传的内容');
      return [];
    }
    const values = await QiniuUploadFiles(urls, token, (evt) => {
      Loading.show(`上传进度${evt.loadedFileNum}/${evt.totalFileNum}`);
    });
    Loading.hide();
    Toast.show('上传成功');
    return values;
  } catch (error) {
    if (error && error.message) {
      Toast.show(error.message);
    } else {
      Loading.hide();
      Toast.show('上传失败');
    }
    return [];
  }
}

// 获取屏幕宽度
export function getScreenWidth() {
  return NativeModules.xkMerchantModule.getScreenWidth();
}
// 安卓物理键返回
function onBackPressed() {
  if (Platform.OS === 'android') {
    return new Promise((resolve, reject) => {
      NativeModules.xkMerchantModule.onBackPressed().then((result) => {
        Loading.hide();
        resolve(result);
      }).catch((res) => {
        reject(res);
        Loading.hide();
      });
    });
  }
}
// 测试
export function test() {
  return NativeModules.xkMerchantModule.test();
}
// 扫码
export function scanQRCode() {
  return NativeModules.xkMerchantModule.scanQRCode();
}

// 本地联盟商群
export function jumpLocalUnionGroup() {
  return NativeModules.xkMerchantModule.jumpLocalUnionGroup();
}

// 店铺客服
export function jumpShopService() {
  return NativeModules.xkMerchantModule.jumpShopService();
}

// 好友
export function clickFriendScreen() {
  return NativeModules.xkMerchantModule.clickFriendScreen();
}
// 店铺订单里商铺客服
export function createShopCustomerWithCustomerID(groupId, customerId, customerName, shopId) {
  console.log('店铺客服', groupId, customerId, customerName);
  return Platform.OS == 'ios'
    ? NativeModules.xkMerchantModule.customerServiceContactUser(customerId, shopId)
    : NativeModules.xkMerchantModule.createShopCustomerWithCustomerID(groupId, customerId, customerName);
}
// 平台客服
export function createXKCustomerSerChat() {
  return NativeModules.xkMerchantModule.createXKCustomerSerChat();
}
// apple内购
export function applePay(param) {
  return NativeModules.xkMerchantModule.applePay(param);
}
// 通讯录
// 返回{name:'',phoneNumber:''}
export const openContact = () => (new Promise(async (resolve, reject) => {
  const granted = await RequestContactPermission();
  if (granted) {
    NativeModules.xkMerchantModule.openContact().then((res) => {
      resolve(res);
    }).catch((error) => {
      Toast.show('读取通讯录失败');
      reject(new Error('读取通讯录失败'));
    });
  } else {
    Toast.show('获取读取通讯录权限失败');
    reject(new Error('获取读取通讯录权限失败'));
  }
}));

// 传递店铺信息
export function changeShopSuccess(shopId) { // 切换店铺
  return NativeModules.xkMerchantModule.changeShopSuccess(shopId);
}

export function openPermissionSettings() {
  return NativeModules.xkMerchantModule.openPermissionSettings();
}

// 调取更新操作
export async function downloadAndInstall(url) {
  const granted = await PermissionsAndroid.request(
    PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE,
    {
      title: '获取存储权限',
      message: '应用需要获取你的存储权限，以便下载最新的更新包',
      buttonNeutral: '稍后询问',
      buttonNegative: '取消',
      buttonPositive: '确定',
    },
  );
  if (granted === PermissionsAndroid.RESULTS.GRANTED) {
    NativeModules.xkMerchantModule.downloadAndInstall(url);
    return true;
  }
  Toast.show('获取存储权限失败，请给应用设置存储权限');
  return false;
}
// 清除缓存
export function cleanCache() {
  return NativeModules.xkMerchantModule.cleanCache();
}
// 跳转到好友主页
export function jumpPersonalCenter(userId) {
  return NativeModules.xkMerchantModule.jumpPersonalCenter(userId);
}
// 安卓平台的通知管理
export function jumpToAppNotificationSetting() {
  return NativeModules.xkMerchantModule.jumpToAppNotificationSetting();
}

export function updateUser(user = {}) {
  console.log('更新user', user);
  NativeModules.xkMerchantModule.updateUser(user);
}
export function popToNative() { // rn返回原生界面
  NativeModules.xkMerchantModule.popToNative();
}

export function getUserInfo() { // 从原生获取用户信息
  NativeModules.xkMerchantModule.getUserInfo();
}

// 获取IM消息通知声音状态
// flag 整数类型 0 开启 1关闭
export function getIMMute() {
  return NativeModules.xkMerchantModule.getIMMute();
}
// 获取可友消息推送状态  1:开  0：关
export function getFriendMsgSwitch() {
  return NativeModules.xkMerchantModule.getFriendMsgSwitch();
}

// 开关IM消息通知声音  1:开  0：关
// export function switchIMMute(flag) {
//   return NativeModules.xkMerchantModule.switchIMMute(flag);
// }

export function jumpSysSetting() {
  return NativeModules.xkMerchantModule.jumpSysSetting();
}
// 可有消息免打扰开关   1:开  0：关
export function onSwitchFriendMsg(flag) {
  return NativeModules.xkMerchantModule.onSwitchFriendMsg(flag);
}

// 获取私密时间戳
export function secreteMessageTimer() {
  return NativeModules.xkMerchantModule.secreteMessageTimer();
}
