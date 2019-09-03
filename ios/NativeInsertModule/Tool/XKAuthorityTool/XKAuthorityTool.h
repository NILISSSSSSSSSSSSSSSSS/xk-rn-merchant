//
//  AuthorityTool.h
//  权限判断
//
//  Created by Jamesholy on 2017/7/24.
//  Copyright © 2017年 Jamesholy. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PrivacyAuthorityType) {
	PrivacyAuthorityTypeCamera      = 1, // 相机
	PrivacyAuthorityTypeAlbum       = 2, // 相册
	PrivacyAuthorityTypeMicroPhone  = 3, // 麦克风
	PrivacyAuthorityTypeAddressBook = 4, // 通讯录
	PrivacyAuthorityTypeRemotePush  = 5, // 远程通知
	PrivacyAuthorityTypeLocation             = 6, // 定位 包括使用期间和一直使用
	PrivacyAuthorityTypeLocationAlways       = 7, // 定位 一直使用
//    PrivacyAuthorityTypeCalendar             = 8, // 日历

};

@interface XKAuthorityTool : UIView

/**
 判断权限

 @param type 权限判断类型
 @param needGuide 是否需要引导进去设置界面
 @param has 有权限的回调
 @param hasnt 无权限的回调
 */
+ (void)judgeAuthorityType:(PrivacyAuthorityType)type needGuide:(BOOL)needGuide has:(void(^)(void))has hasnt:(void(^)(void))hasnt;

/**
 判断权限 单纯的判断
 */
/**
 判断权限 单纯的判断
 
 @param type 权限判断类型
 @param has 有权限的回调
 @param hasnt 无权限的回调
 */
+ (void)judgeAuthorityType:(PrivacyAuthorityType)type has:(void(^)(void))has hasnt:(void(^)(void))hasnt;

/**
 判断是否可以拍摄视频  缺少权限会引导开启

 @param canRecord 回调
 */
+ (void)judegeCanRecord:(void(^)(void))canRecord;


@end
