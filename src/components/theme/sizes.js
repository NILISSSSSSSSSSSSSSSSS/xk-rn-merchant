import { Dimensions, StatusBar, Platform } from 'react-native';

const { width, height } = Dimensions.get('window');

export const Sizes = {
  B: 'Base',
  S: 'Small',
  SX: 'SmallX',
  L: 'Large',
  LX: 'LargeX',
};

/** 字体大小 */
export const BaseFontSize = 14;
export const SmallXFontSize = 10;
export const SmallFontSize = 12;
export const LargeFontSize = 17;
export const LargeXFontSize = 20;

/** 字体间距 */
export const BaseLineHeight = 18;
export const SmallXLineHeight = 14;
export const SmallLineHeight = 16;
export const LargeLineHeight = 22;
export const LargeXLineHeight = 26;

export const FontSizeMap = new Map([
  [Sizes.B, BaseFontSize, BaseLineHeight],
  [Sizes.SX, SmallXFontSize, SmallXLineHeight],
  [Sizes.S, SmallFontSize, SmallLineHeight],
  [Sizes.L, LargeFontSize, LargeLineHeight],
  [Sizes.LX, LargeXFontSize, LargeXLineHeight],
].map(([key, fontSize, lineHeight]) => ([key, { fontSize, lineHeight }])));

/** 间距 */
export const BaseMargin = 15;
export const SmallXMargin = 5;
export const SmallMargin = 10;
export const LargeMargin = 20;
export const LargeXMargin = 25;

/** 圆角大小 */
export const BorderRadius = 6;
export const BorderSmallXRadius = 3;
export const BorderSmallRadius = 4;
export const BorderLargeRadius = 8;
export const BorderLargeXRadius = 10;

/** 容器 */
export const ContainerBaseSize = 24;
export const ContainerSmallXSize = 18;
export const ContainerSmallSize = 20;
export const ContainerLargeSize = 30;
export const ContaienrLargeXSize = 40;

export const ContainerSizeMap = new Map([
  [Sizes.B, ContainerBaseSize, BorderRadius],
  [Sizes.SX, ContainerSmallXSize, BorderSmallXRadius],
  [Sizes.S, ContainerSmallSize, BorderSmallRadius],
  [Sizes.L, ContainerLargeSize, BorderLargeRadius],
  [Sizes.LX, ContaienrLargeXSize, BorderLargeXRadius],
].map(([key, _height, borderRadius]) => ([key, { height: _height, borderRadius }])));

/** 其它大小 */
let headerPadding = 0;
let footerPadding = 0;

if (Platform.OS === 'android') {
  headerPadding = StatusBar.currentHeight;
} else {
  // 判断iPhone X
  console.log( height, width);
  // if (DeviceInfo.isIPhoneX_deprecated) {
  if (Platform.OS === 'ios' && (Number((`${height / width}`).substr(0, 4)) * 100) === 216) {
    headerPadding = 44;
    footerPadding = 34;
  } else {
    headerPadding = 20;
  }
}

export const WindowWidth = width;
export const WindowHeight = height;
export const HeaderPaddingTop = headerPadding;
export const HeaderContentHeight = 44;
export const HeaderHeight = headerPadding + 44;
export const FooterPaddingBottom = footerPadding;
