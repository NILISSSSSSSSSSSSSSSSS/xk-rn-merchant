//
//  ProjectHeader.h
//  xkMerchant
//
//  Created by Jamesholy on 2018/9/27.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#ifndef ProjectHeader_h
#define ProjectHeader_h


//--------------------------  数据库表名  --------------------------
//#define XKHistorySearchTable    [NSString stringWithFormat:@"%@_%@", @"XKHistorySearchTable", [XKUserInfo getCurrentUserId]]
#define XKHistorySearchTable    [NSString stringWithFormat:@"%@_%@", @"XKHistorySearchTable", @"111"]

//--------------------------  数据库表名  --------------------------


//app信息
#define XKAppVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define KEY_WINDOW [UIApplication sharedApplication].keyWindow
//NavBar高度
#define NavigationBar_HEIGHT 44 //默认的NAVERgationBar 高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度。 iPhone X 之前是 20 iPhone X 是 44
#define NavigationAndStatue_Height (kStatusBarHeight+NavigationBar_HEIGHT)

#define kBottomSafeHeight ((iPhoneX)?(34):(0))  //距离底部的安全距离

#define TabBar_Height (50 + kBottomSafeHeight)   // Tabbar height.

//头像 大
#define BigAvatarWidth     (SCREEN_WIDTH>320?44:40)
//获取屏幕 宽度、高度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define BUTTON_WIDTH ((([UIScreen mainScreen].bounds.size.width) / 4) * 3)
#define BUTTON_HEIGHT (((([UIScreen mainScreen].bounds.size.width) / 4) * 3) / 6.3)

//根据375得到的比例
#define ScreenScale [[UIScreen mainScreen] bounds].size.width/375.f
//根据667得到的比例
#define ScreenHeightScale [[UIScreen mainScreen] bounds].size.height/667.f
// 三个屏幕尺寸对应的宽度高度 从大到小
#define kLMSScreenFit(L,M,S) ((iPhone6P||SCREEN_WIDTH>414.0f) ? (L) : ((iPhone6||iPhoneX||SCREEN_WIDTH>375.0f) ? (M) : (S)))
// 建议用这个适配
#define kLMS(L,M,S) kLMSScreenFit(L,M,S)
// 导航栏适配X
#define kIphoneXNavi(XValue) (iPhoneX ? (XValue + 24) : (XValue))

//是否iphone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//是否iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 是否为iPhone4/4S
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)
// 是否为iPhone6/6S/7/7S
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO)
// 是否为iPhone6*Plus/7*Plus
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)
//键盘弹起高度
#define KeyBoardHeightMax   70
#define KeyBoardHeightLow   10

//**************************  常用资源 **************************************************
#define kRightBlackArrowImgName @"xk_btn_Mine_Setting_nextBlack"
#define kRightWhiteArrowImgName @"xk_btn_Mine_Setting_nextWhite"
#define kleftBlackArrowImgName @"xk_ic_login_back"
#define kleftWhiteArrowImgName @"xk_btn_Mine_setting_back"
#define kRightGrayArrowImgName @"xk_btn_order_grayArrow"

//**************************  颜色  **************************************************

// RGB颜色
#define RGB(r,g,b) RGBA(r,g,b,1)
// RGB颜色 灰色
#define RGBGRAY(A) RGB(A,A,A)
// 16进制颜色
#define HEX_RGB(rgbValue) HEX_RGBA(rgbValue, 1.0)
// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 16进制颜色+透明度
#define HEX_RGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0f \
blue:((float)(rgbValue & 0x0000FF))/255.0f \
alpha:alphaValue]
//默认分割线颜色
#define XKSeparatorLineColor UIColorFromRGB(0xF1F1F1)
//主体颜色
#define XKMainTypeColor UIColorFromRGB(0x4A90FA)
//密友颜色
#define XKSecreatFriendTypeColor UIColorFromRGB(0x4A90FA)
//***************************** 字体 *************************************************
#define XKFont(fontName,fontSize)   [UIFont setFontWithFontName:fontName andSize:fontSize]
#define XKRegularFont(fontSize)     XKFont(XK_PingFangSC_Regular,fontSize)
#define XKSemiboldFont(fontSize)    XKFont(XK_PingFangSC_Semibold,fontSize)
#define XKMediumFont(fontSize)      XKFont(XK_PingFangSC_Medium,fontSize)

#define XK_PingFangSC_Regular   @"PingFangSC-Regular"
#define XK_PingFangSC_Semibold  @"PingFangSC-Semibold"
#define XK_PingFangSC_Medium    @"PingFangSC-Medium"

//******************************* 强弱引用 ***********************************************
#define XKWeakSelf(weakSelf)     __weak __typeof(&*self)    weakSelf  = self;
#define XKStrongSelf(strongSelf)  __strong __typeof(&*self) strongSelf = weakSelf;

// 一般对象的弱引用
#define WEAK_TYPES(instance) __weak typeof(instance) weak##instance = instance;
//******************************* 安全执行block *******************************
#define EXECUTE_BLOCK(A,...) if(A){A(__VA_ARGS__);}

/* --------------------------- 常用工具宏-----------------------------*/
#define IMG_NAME(imgName) [UIImage imageNamed:imgName]
#define kURL(urlStr) [NSURL URLWithString:urlStr]


#endif /* ProjectHeader_h */
