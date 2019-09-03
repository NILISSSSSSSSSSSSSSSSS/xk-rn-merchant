/**
 * 公共样式
 */

import {
  Platform,
  StatusBar,
  Dimensions,
} from 'react-native';
// import * as nativeApi from '../config/nativeApi';
// let _width
// nativeApi.getScreenWidth().then(res => {
//     console.log('%cgetScreenWidth', 'color: red', res)
//     _width = res
// })
let headerPadding = 0;
let footerPadding = 0;
const { width, height } = Dimensions.get('window');
if (Platform.OS === 'android') {
  headerPadding = StatusBar.currentHeight;
} else {
  // 判断iPhone X
  // console.log( height, width);
  // if (DeviceInfo.isIPhoneX_deprecated) {
  if (Platform.OS === 'ios' && (Number((`${height / width}`).substr(0, 4)) * 100) === 216) {
    headerPadding = 44;
    footerPadding = 34;
  } else {
    headerPadding = 20;
  }
}
console.log('StatusBar height: ', headerPadding);
console.log('Footer height: ', footerPadding);
const globalBgColor = '#EEEEEE';
const globalHeaderColor = '#4A90FA';
// let globalHeaderColor = 'white';
console.log('宽度', width);

export default {
  globalBgColor, // 全局背景颜色
  globalHeaderColor,
  globalRedColor: '#EE6161',
  globalText: {
    fontSize: 14,
  },
  defaultHeaderText: {
    fontSize: 17,
    color: '#fff',
  },
  headerPadding,
  footerPadding,
  container: {
    flex: 1,
    paddingTop: headerPadding,
    paddingBottom: footerPadding,
    backgroundColor: globalBgColor,
  },
  containerWithoutPadding: {
    flex: 1,
    width,
    backgroundColor: globalBgColor,
  },
  shadowStyle: {
    // 以下是阴影属性：
    shadowOffset: { width: 0, height: 0.3 },
    shadowOpacity: 0.5,
    shadowRadius: 3,
    shadowColor: '#D7D7D7',
    // 注意：这一句是可以让安卓拥有灰色阴影,现在不要阴影，修改为背景颜色为eee
    // elevation: 0.7,
    elevation: 2,
    zIndex: Platform.OS === 'ios' ? 1 : 0,
  },
  flex_around: {
    justifyContent: 'space-around',
    flexDirection: 'row',
    alignItems: 'center',
  },
  flex_center: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  flex_start: {
    justifyContent: 'flex-start',
    flexDirection: 'row',
    alignItems: 'center',
  },
  flex_end: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'flex-end',
  },
  flex_end_noCenter: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
  },
  flex_start_noCenter: {
    justifyContent: 'flex-start',
    flexDirection: 'row',
  },
  flex_between: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  flex_1: {
    flex: 1,
  },
  flex_start_column: {
    justifyContent: 'flex-start',
    flexDirection: 'column',
    alignItems: 'center',
  },
};
