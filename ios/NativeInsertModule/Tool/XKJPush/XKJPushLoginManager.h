//
//  XKJPushLoginManager.h
//  XKSquare
//
//  Created by Lin Li on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSHAREService.h"
#import "XKJPushLoginModel.h"

@interface XKJPushLoginManager : NSObject

/**
 XKJPushLoginManager单例

 @return XKJPushLoginManager
 */
+ (instancetype)shared;


/**
 获取登录信息

 @param platfrom 平台类型
 @param loginBlock 登录信息
 */
- (void)getUserInfoWithPlatform:(JSHAREPlatform)platfrom LoginBlock:(void(^)(XKJPushLoginModel* model))loginBlock;

/**
 获取QQ登录信息

 @param loginBlock 登录信息
 */
- (void)getUserInfoWithPlatformQQLoginBlock:(void(^)(XKJPushLoginModel* model))loginBlock;
/**
 获取微信登录信息
 
 @param loginBlock 登录信息
 */
- (void)getUserInfoWithPlatformWeChatLoginBlock:(void(^)(XKJPushLoginModel* model))loginBlock;
/**
 获取微博登录信息
 
 @param loginBlock 登录信息
 */
- (void)getUserInfoWithPlatformSinaWeiboLoginBlock:(void(^)(XKJPushLoginModel* model))loginBlock;

@end
