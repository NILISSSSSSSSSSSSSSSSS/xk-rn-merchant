import DeviceInfo from 'react-native-device-info';
import { NativeEventEmitter, NativeModules, Platform } from 'react-native';
import * as wechat from '@scxkkj/react-native-wechat';
import JPushModule from 'jpush-react-native';
import { imJudge, moduleJudge } from '../config/imJudge';
import NavigatorService from '../common/NavigatorService';
import * as nativeApi from '../config/nativeApi';
import * as requestApi from '../config/requestApi';
import { checkOutVerRang } from '../config/utils';
import config from '../config/config';


const xkMerchantEmitterModule = NativeModules.xkMerchantEmitterModule;
const xkMerchantModule = NativeModules.xkMerchantModule;
let redPointStatusTimeoutInt;

const getRedPointStatus = async () => {
  const redPointStatus = await xkMerchantModule.getRedPointStatus();
  const {
    union = '1', friend = '0', xkSer = '1', shopSer = '0',
  } = redPointStatus;
  const objModules = {
    friends: friend == '1',
    'home.unionGroup': union == '1',
    service: xkSer == '1',
    'shop.service': shopSer == '1',
  };
  app._store.dispatch({ type: 'application/changeMessageModulesExt', payload: { objModules } });
};

export default {
  listener: null,
  jumpListener: null,
  systemMessageListener: null,
  openNotificationLaunchAppListener(map) {
    console.log('application.openNotificationLaunchAppListener', map);
    this.openNotificationListener(map);
  },
  openNotificationListener: (map) => {
    if (global.loginInfo && global.loginInfo.userId) {
      let extras = null;
      try {
        extras = typeof map.extras === 'string' ? JSON.parse(map.extras) : map.extras;
      } catch (error) {
        extras = map.extras;
      }
      map && map.extras && imJudge(extras);
      console.log('打开通知: ', extras);
    } else {
      // that.goToLogin();
    }
  },
  receiveNotificationListener: (map) => {
    let extras = {};
    try {
      extras = typeof map.extras === 'string' ? JSON.parse(map.extras) : map.extras;
    } catch (error) {}

    if (global.loginInfo && global.loginInfo.userId) {
      console.log('推送消息0', map);
      map && map.extras && moduleJudge({ ...extras, message: map.alertContent }, false);
    }
  },
  onFriendRedPointStatusChange: () => {
    if (redPointStatusTimeoutInt) clearTimeout(redPointStatusTimeoutInt);
    redPointStatusTimeoutInt = setTimeout(() => getRedPointStatus(), 400);
  },
  onJumpRNPage: (screen) => {
    console.log(screen);
    switch (screen) {
      case 'FriendScreen':
        NavigatorService.resetTab('Friends');
        break;
      default:
        break;
    }
  },
  onSystemMessage: (_extras) => {
    try {
      const extras = typeof _extras === 'string' ? JSON.parse(_extras) : _extras;
      const { data = {}, type } = extras || {};
      const systemMessageType = data.systemMessageType;
      const msgData = {
        msgType: systemMessageType || type,
        ...data,
        message: data.msgContent,
      };
      moduleJudge(msgData, true);
    } catch (error) {
      if (error && error.message) {
        Toast.show(`消息接收失败:${error.message}`);
      } else {
        Toast.show('消息接收失败:未知原因');
      }
    }
  },
  initRequestTime: async () => {
    // if (global.requestTime) return { ...global.requestTime };
    const requestTime = {
      localTime: Date.now(),
      systemTime: Date.now(),
    };
    try {
      const res = await requestApi.requestSystemTime();
      requestTime.systemTime = res.timestamp;
    } catch (error) {
      console.log(error);
    }
    global.requestTime = { ...requestTime };
    return requestTime;
  },
  getUniqueIdentifier: async () => {
    if (global.uniqueIdentifier) return global.uniqueIdentifier;
    let uniqueIdentifier = '';
    try {
      uniqueIdentifier = await nativeApi.getUniqueIdentifier();
    } catch (error) {
      console.log(error);
    }
    global.uniqueIdentifier = uniqueIdentifier;
    return uniqueIdentifier;
  },
  getUserLocations: async () => {
    if (global.userLocations) return global.userLocations;
    let userLocations = null;
    try {
      userLocations = await nativeApi.getLocation();
    } catch (error) {
      console.log(error);
    }
    global.userLocations = userLocations;
    return userLocations;
  },
  getReginCode: async (userLocations) => {
    if (global.regionCode) return global.regionCode;
    let regionCode = '510100';
    const keyword = (userLocations && userLocations.region) ? userLocations.region.toLowerCase() : 'cds';
    try {
      const res = await requestApi.regionPage({ page: 1, limit: 10, keyword });
      if (res && res.data && res.data[0]) {
        regionCode = res.data[0].code;
      }
    } catch (error) {
      console.log(error);
    }
    global.regionCode = regionCode;
    return regionCode;
  },
  getGeolocation: async (userLocations) => {
    if (global.geolocation) return global.geolocation;
    let geolocation = {
      lng: '104.07',
      lat: '30.67',
    };
    try {
      geolocation = await nativeApi.getGeolocation(userLocations);
    } catch (error) {
      console.log(error);
    }
    global.geolocation = geolocation;
    return geolocation;
  },
  fetchUpgradeInfo: async () => {
    const upgradeInfo = {
      modalVisible: false, // 是否显示对话框
      updateInfo: {}, // 更新信息
      isMandatory: false, // 是否强制更新
    };
    const res = await requestApi.clientVersionQuery({ clientVersion: DeviceInfo.getVersion() }) || {};
    if (res) {
      upgradeInfo.isMandatory = res.isForce || false;
      upgradeInfo.updateInfo = res;

      const isNeedUpdate = checkOutVerRang(res.maxVersion, res.minVersion, DeviceInfo.getVersion());
      if (isNeedUpdate) {
        // 全量更新
        if (res.updateType === 'all') {
          console.log(`当前版本：${DeviceInfo.getVersion()}`, `是否需要更新：${isNeedUpdate}`, '更新类型：all,全量更新');
          upgradeInfo.modalVisible = true;
        }
        // 增量更新，查分升级
        if (res.updateType === 'part') {
          console.log(`当前版本：${DeviceInfo.getVersion()}`, `是否需要更新：${isNeedUpdate}`, '更新类型：part,增量更新，查分升级');
          upgradeInfo.modalVisible = true;
        }
        // 热更新
        if (res.updateType === 'hot') {
          console.log(`当前版本：${DeviceInfo.getVersion()}`, `是否需要更新：${isNeedUpdate}`, '更新类型：hot,热更新');
        }
      }
    }
    return { ...upgradeInfo };
  },
  /** 登录过后，需要动态更新的系统数据 */
  initWechat() {
    wechat.registerApp(config.wechatAppId);
  },
  initJPush() {
    if (Platform.OS === 'android') {
      JPushModule.initPush();
      JPushModule.getInfo((map) => {
        console.log('极光推送', map);
      });
      JPushModule.notifyJSDidLoad((resultCode) => {
        if (resultCode === 0) {
          console.log(resultCode);
        }
      });
    } else {
      JPushModule.setupPush();
    }
    JPushModule.getRegistrationID((registrationId) => {
      if (registrationId) global.registrationId = registrationId;
    });
    // 获取注册id
    JPushModule.addGetRegistrationIdListener((registrationId) => {
      console.log(`Device register succeed, registrationId ${registrationId}`);
    });
  },
  initNativeMessage() {
    const myNativeEvt = new NativeEventEmitter(xkMerchantEmitterModule); // 创建自定义事件接口
    if (Platform.OS === 'android') {
      this.listener = myNativeEvt.addListener('friendRedPointStatusChange', this.onFriendRedPointStatusChange);
    } else {
      this.listener = myNativeEvt.addListener('redPointStatusChange', this.onFriendRedPointStatusChange);
    }
    if (Platform.OS === 'android') {
      this.jumpListener = myNativeEvt.addListener('jumpRNPage', this.onJumpRNPage);
    }
    this.systemMessageListener = myNativeEvt.addListener('systemMessage', this.onSystemMessage);
  },
  setAlias(user) {
    JPushModule.getRegistrationID((registrationId) => {
      if (registrationId) {
        global.registrationId = registrationId;
        // Alert.alert("极光设备注册", "获取registrationId:" + global.registrationId)
        JPushModule.deleteAlias(() => {
          JPushModule.setAlias(user.id, (map) => {
            if (map.errorCode === 0) {
              console.log('set alias succeed', map, global.registrationId);
              requestApi.jpushReg({
                userId: user.id,
                alias: map.alias,
                registrationId: global.registrationId,
              }).then(() => {
                // Alert.alert("极光设备注册","注册设备成功");
                JPushModule.addReceiveCustomMsgListener(this.receiveNotificationListener);
                JPushModule.addReceiveNotificationListener(this.receiveNotificationListener);
                JPushModule.addReceiveOpenNotificationListener(this.openNotificationListener);
                JPushModule.addOpenNotificationLaunchAppListener(this.openNotificationListener);
              }).catch((error) => {
                // Alert.alert("极光设备注册", "未获取registrationId")
              });
            } else {
              console.log(`set alias failed, errorCode: ${map.errorCode}`);
              // Alert.alert("极光设备注册",'set alias failed, errorCode: ' + map.errorCode)
            }
          });
        });
      } else {
        // Alert.alert("极光设备注册", "未获取registrationId")
      }
    });
  },
  removeJPushListeners() {
    JPushModule.deleteAlias(() => {
      JPushModule.removeReceiveCustomMsgListener(this.receiveNotificationListener);
      JPushModule.removeReceiveNotificationListener(this.receiveNotificationListener);
      JPushModule.removeReceiveOpenNotificationListener(this.openNotificationListener);
      JPushModule.removeOpenNotificationLaunchAppEventListener(this.openNotificationListener);
    });
  },
};
