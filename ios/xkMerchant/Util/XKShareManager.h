//
//  XKShareManager.h
//  XKSquare
//
//  Created by Lin Li on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSHAREService.h"

@interface XKShareManager : NSObject

/**
 显示分享界面

 @param url 链接url
 @param text 链接的内容描述
 @param title 标题
 @param imageURL 图片
 */
- (void)showSharePanelWithLinkUrl:(NSString *)url LinkText:(NSString *)text LinkTitle:(NSString *)title LinkImageURL:(NSString *)imageURL;

/**
 ShareManager单例
 
 @return ShareManager
 */
+ (instancetype)shared;

/**
 通过传入平台
 JSHAREPlatformWechatSession = 1,
 JSHAREPlatformWechatTimeLine = 2,
 JSHAREPlatformWechatFavourite = 3,
 JSHAREPlatformQQ = 4,
 JSHAREPlatformQzone = 5,
 JSHAREPlatformSinaWeibo = 6,
 JSHAREPlatformSinaWeiboContact = 7,
 JSHAREPlatformFacebook = 8,
 JSHAREPlatformFacebookMessenger = 9,
 JSHAREPlatformTwitter = 10,
 JSHAREPlatformJChatPro = 11
 直接分享链接类型

 @param url 链接url
 @param text 链接的内容描述
 @param title 标题
 @param imageURL 图片
 @param platform 平台
 */
- (void)shareLinkUrl:(NSString *)url LinkText:(NSString *)text LinkTitle:(NSString *)title LinkImageURL:(NSString *)imageURL WithPlatform:(JSHAREPlatform)platform complete:(void(^)(NSString *err))complete;
@end
