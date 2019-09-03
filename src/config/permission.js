import { PermissionsAndroid, Platform } from 'react-native'

/** 请求存储权限 */
export const RequestWriteAndReadPermission = async ()=> {
    if(Platform.OS === "ios") return true;
    const grantedPermisions = await PermissionsAndroid.requestMultiple(
        [
            PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE,
            PermissionsAndroid.PERMISSIONS.CAMERA,
            PermissionsAndroid.PERMISSIONS.RECORD_AUDIO,
        ],
        {
          title: '获取权限',
          message: '应用需要获取你的存储权限，以便实现拍照或者录音功能',
          buttonNeutral: '稍后询问',
          buttonNegative: '取消',
          buttonPositive: '确定',
        },
    );
    const granted = Object.keys(grantedPermisions).filter(key=> grantedPermisions[key]=== PermissionsAndroid.RESULTS.GRANTED).length === Object.keys(grantedPermisions).length;
    if (granted) {
        return true;
    } else {
        Toast.show("获取权限失败，请给应用设置权限");
        return false;
    }
}


export const RequestContactPermission = async ()=> {
    if(Platform.OS === "ios") return true;
    const granted = await PermissionsAndroid.request(PermissionsAndroid.PERMISSIONS.READ_CONTACTS,
        {
            title: '获取读取通讯录权限',
            message: '应用需要获取你的读取通讯录权限，以便读取你的通讯录',
            buttonNeutral: '稍后询问',
            buttonNegative: '取消',
            buttonPositive: '确定',
        })
    if(granted === PermissionsAndroid.RESULTS.GRANTED) {
        return true;
    } else {
        return false;
    }
}

/** 请求存储和定位权限 */
export const RequestWriteAndLocationPermission = async ()=> {
    if(Platform.OS === "ios") return true;
    const grantedPermisions = await PermissionsAndroid.requestMultiple(
        [
            PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE,
            PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
        ],
        {
          title: '获取权限',
          message: '应用需要获取你的存储和定位权限，以便正常定位位置',
          buttonNeutral: '稍后询问',
          buttonNegative: '取消',
          buttonPositive: '确定',
        },
    );
    const granted = Object.keys(grantedPermisions).filter(key=> grantedPermisions[key]=== PermissionsAndroid.RESULTS.GRANTED).length === Object.keys(grantedPermisions).length;
    if (granted) {
        return true;
    } else {
        Toast.show("获取权限失败，请给应用设置权限");
        return false;
    }
}

/** 请求存储权限 */
export const RequestWritePermission = async ()=> {
  if(Platform.OS === "ios") return true;
  const grantedPermisions = await PermissionsAndroid.requestMultiple(
      [
          PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE,
      ],
      {
        title: '获取权限',
        message: '应用需要获取你的存储权限，以便保存图片',
        buttonNeutral: '稍后询问',
        buttonNegative: '取消',
        buttonPositive: '确定',
      },
  );
  const granted = Object.keys(grantedPermisions).filter(key=> grantedPermisions[key]=== PermissionsAndroid.RESULTS.GRANTED).length === Object.keys(grantedPermisions).length;
  if (granted) {
      return true;
  } else {
      Toast.show("获取权限失败，请给应用设置权限");
      return false;
  }
}
