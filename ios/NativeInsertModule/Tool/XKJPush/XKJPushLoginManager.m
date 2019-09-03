//
//  XKJPushLoginManager.m
//  XKSquare
//
//  Created by Lin Li on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKJPushLoginManager.h"
#import "XKAlertView.h"

static XKJPushLoginManager *_manager = nil;

@implementation XKJPushLoginManager

#pragma mark XKJPushLoginManager单例

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone ];
    });
    return _manager;
}
+ (instancetype)shared{
    if (_manager == nil) {
        _manager = [[super alloc]init];
    }
    return _manager;
}

- (id)copyWithZone:(NSZone *)zone{
    return _manager;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return _manager;
}


- (void)getUserInfoWithPlatformQQLoginBlock:(void(^)(XKJPushLoginModel* model))loginBlock{
     [self getUserInfoWithPlatform:JSHAREPlatformQQ LoginBlock:loginBlock];
}

- (void)getUserInfoWithPlatformWeChatLoginBlock:(void(^)(XKJPushLoginModel* model))loginBlock{
     [self getUserInfoWithPlatform:JSHAREPlatformWechatSession LoginBlock:loginBlock];
}

- (void)getUserInfoWithPlatformSinaWeiboLoginBlock:(void(^)(XKJPushLoginModel* model))loginBlock{
     [self getUserInfoWithPlatform:JSHAREPlatformSinaWeibo LoginBlock:loginBlock];
}

//获取登录信息
- (void)getUserInfoWithPlatform:(JSHAREPlatform)platfrom LoginBlock:(void(^)(XKJPushLoginModel *model))loginBlock{
    [JSHAREService getSocialUserInfo:platfrom handler:^(JSHARESocialUserInfo *userInfo, NSError *error) {
        XKJPushLoginModel *model = [[XKJPushLoginModel alloc]init];
        NSString *alertMessage;
        NSString *title;
        if (error) {
            title = @"失败";
            alertMessage = @"无法获取到用户信息";
            [XKAlertView showCommonAlertViewWithTitle:title message:alertMessage];
        }else{
            [JSHAREService cancelAuthWithPlatform:platfrom];
            model.name = userInfo.name;
            model.iconurl = userInfo.iconurl;
            model.gender = userInfo.gender;
            model.openid = userInfo.userOriginalResponse[@"openid"];
            model.unionid = userInfo.userOriginalResponse[@"unionid"];
            NSLog(@"%@", userInfo.userOriginalResponse);
            if(loginBlock){
                loginBlock(model);
            }
            
        }
    }];
}
@end
