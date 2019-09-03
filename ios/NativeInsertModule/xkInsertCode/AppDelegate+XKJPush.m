//
//  AppDelegate+XKJPush.m
//  XKSquare
//
//  Created by Lin Li on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "AppDelegate+XKJPush.h"
#import "JSHAREService.h"
#import "XKPushSysConfig.h"
#import "XKRelationUserCacheManager.h"
#import "XKGlobalNotificationManager.h"
#import "XKSecretTipMsgManager.h"
#import "IAPCenter.h"
#import <RCTJPushModule.h>

static NSString *MSG_WAY_DIYMSG = @"MSG_WAY_DIYMSG";
static NSString *MSG_WAY_PUSH = @"MSG_WAY_PUSH";

@implementation AppDelegate (XKJPush)

- (void)JShareConfig {
    JSHARELaunchConfig *config = [[JSHARELaunchConfig alloc] init];
    config.appKey = XKJPushAppKey;
    config.SinaWeiboAppKey = XKSinaWeiboAppKey;
    config.SinaWeiboAppSecret = XKSinaWeiboAppKey;
    config.SinaRedirectUri = XKSinaRedirectUri;
    config.QQAppId = XKQQAppId;
    config.QQAppKey = XKQQAppKey;
    config.WeChatAppId = [self getWeChatAppId];
    config.WeChatAppSecret = [self getWeChatAppSecret];
    [JSHAREService setupWithConfig:config];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    //日志打印
//    [JSHAREService setDebug:YES];
}


- (NSString *)getWeChatAppId {
  NSString *appId;
  appId = XKReleaseWeChatAppId;
//#ifdef DEBUG
//  if ([APPDebug getDebugModeStatus] == 0) {
//    // 正式环境
//    appId = XKReleaseWeChatAppId;
//  } else if ([APPDebug getDebugModeStatus] == 1) {
//    // dev
//    appId = XKTestWeChatAppId;
//  } else if ([APPDebug getDebugModeStatus] == 2) {
//    // test
//    appId = XKTestWeChatAppId;
//  }
//#else
//  appId = XKReleaseWeChatAppId;
//#endif
  return appId;
}

- (NSString *)getWeChatAppSecret {
  if ([[self getWeChatAppId] isEqualToString:XKTestWeChatAppId]) {
    return XKTestWeChatAppSecret;
  } else {
    return XKReleaseWeChatAppSecret;
  }
}




//仅支持 iOS9 以上系统，iOS8 及以下系统不会回调
- (BOOL)JPushApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    [JSHAREService handleOpenUrl:url];
    return YES;
}

- (BOOL)JPushApplication:(UIApplication *)application handleOpenURL:(NSURL *)url {
   return  [JSHAREService handleOpenUrl:url];
}

-(void)JPushConfigWithOptions:(NSDictionary *)launchOptions {
    //注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
  
    NSString *appKey = XKJPushAppKey;
    NSString *channel = @"ios";
#ifdef DEBUG
    BOOL isProduction = false;
#else
    BOOL isProduction = true;
#endif
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
  
  // rn 项目代理被桥接文件拦截了  所以这里只有通过内部的通知拿到具体的事件
  // 前台收到推送的事件
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushNotificationCenterWillPresentNotification:) name:kJPFDidReceiveRemoteNotification object:nil];
  // 点击通知栏的时间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushNotificationCenterDidReceiveNotification:) name:kJPFOpenNotification object:nil];
}

- (void)JPushApplication:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)JPushApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#pragma mark- JPUSHRegisterDelegate

// 静默推送调用此方法
- (void)JPushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    [self managerBackgroudPushMessage:userInfo complete:^{
        completionHandler(UIBackgroundFetchResultNewData); // 告诉系统，我后台操作完毕了，
    }];
}

// iOS 10 Support   正常推送 和静默推送在都会前台调用此方法
- (void)jpushNotificationCenterWillPresentNotification:(NSNotification *)noti {
  NSDictionary * userInfo = noti.object;
  if ([userInfo[@"aps"][@"content-available"] integerValue] == 1) { // 过滤
    // 前台的静默推送 避免重复处理 didReceiveRemoteNotification中会处理
  } else {
    [self managerPushMessage:userInfo way:MSG_WAY_PUSH];
  }
}

// iOS 10 Support  点击通知栏会调用
- (void)jpushNotificationCenterDidReceiveNotification:(NSNotification *)noti  {
  NSDictionary * userInfo = noti.object;
  if ([userInfo[@"aps"][@"content-available"] integerValue] == 1) { // 静默推送
    [self managerBackgroudPushMessage:userInfo complete:nil];
  } else {
    [self managerPushMessage:userInfo way:MSG_WAY_PUSH];
  }
}

#pragma mark - 自定义消息  前台才能收到
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    [self managerPushMessage:userInfo[@"extras"] way:MSG_WAY_DIYMSG];
}


/*
 ##################################
 消息的处理入口 1 普通推送和自定义消息的处理
 ###################################
*/
#pragma mark - 普通推送和自定义消息
- (void)managerPushMessage:(NSDictionary *)userInfo way:(NSString *)way{
    NSString *pushType = userInfo[@"pushType"];
    // 跳转类型
    if ([pushType isEqualToString: @"jumpType"]) { // 跳转类型
        // 比如指定界面跳转的推送 在前台收到 应该不处理
        if ([way isEqualToString:MSG_WAY_PUSH]) {
            UIApplicationState state = [UIApplication sharedApplication].applicationState;
            if (state != UIApplicationStateActive) {
                [self jumpTypeConfig:userInfo];
            }
        } else { // 自定义消息
            [self jumpTypeConfig:userInfo];
        }
    } else if ([pushType isEqualToString: @"businessType"]) { // 业务类型
        [self businessTypeConfig:userInfo];
    }
}

// 普通推送和自定义消息的处理 de 路由跳转
- (void)jumpTypeConfig:(NSDictionary *)userInfo {
    NSString *routerUrl = userInfo[@"routerUrl"];
    NSURL *url = [NSURL URLWithString:routerUrl];
    
    if ([url.scheme containsString:@"xksquare"]) {
        if ([url.host isEqualToString:@"com.dynamic"]) { // 动态跳转 不需要用户登录的
            [[XKRouter sharedInstance] runRemoteUrl:routerUrl ParentVC:[self getCurrentUIVC]];
        } else if ([url.host isEqualToString:@"com.authDynamic"]) {// 需要验证用户登录的 动态跳转
            if (XKUserInfo.getCurrentUserId) {
                [[XKRouter sharedInstance] runRemoteUrl:routerUrl ParentVC:[self getCurrentUIVC]];
            }else{
                
            }
        }
    }
}

// 普通推送和自定义消息的处理 de 自定义业务
- (void)businessTypeConfig:(NSDictionary *)userInfo {
    BOOL ring = NO;
    NSString *msgType = [NSString stringWithFormat:@"%@",userInfo[@"msgType"]];
    if ([msgType isEqualToString:@"friend_relation_ship_update"] || [msgType isEqualToString:@"friend_apply_agree"]) {
        // 好友关系处理
        [XKRelationUserCacheManager refreshTotal];
       [[NSNotificationCenter defaultCenter] postNotificationName:XKFriendListInfoChangeNoti object:nil];
    } else if ([msgType isEqualToString:@"friend_apply"]) {
        ring = YES;
        [[XKRedPointManager getMsgTabBarRedPointItem].newFriendItem resetItemRedPointStatus];
    } else if ([msgType isEqualToString:@"has_timer_msg"]) { // 密友提醒消息
      [[XKSecretTipMsgManager shareManager] fetchUnReadTimerMsgListComplete:^{}];
    } else {
        
    }
    if (ring) {
        [XKPushSysConfig pushSysConfig];
    }
}

/*
 ##########################
 消息的处理入口 2  静默推送的处理
 注意：静默推送业务场景主要用于后台数据刷新。该静默推送处理代码可能会执行多次 所以跳转或者业务流程相关请用自定义消息或者普通推送
 ##########################
 */
#pragma mark - 静默推送
- (void)managerBackgroudPushMessage:(NSDictionary *)userInfo complete:(void (^)(void))completionHandler {
    NSString *pushType = userInfo[@"pushType"];
    // 跳转类型
    if ([pushType isEqualToString: @"jumpType"]) {
        // 路由跳转业务 不应该用静默推送
        EXECUTE_BLOCK(completionHandler);
    } else if ([pushType isEqualToString: @"businessType"]){
        [self businessTypeConfigForBackRemote:userInfo complete:completionHandler];
    }
}

// 静默推送 de 自定义业务 处理完必须回调completionHandler
- (void)businessTypeConfigForBackRemote:(NSDictionary *)userInfo complete:(void (^)(void))completionHandler {
    NSString *msgType = [NSString stringWithFormat:@"%@",userInfo[@"msgType"]];
    if ([msgType isEqualToString:@"has_timer_msg"]) { // 密友提醒消息
        [[XKSecretTipMsgManager shareManager] fetchUnReadTimerMsgListComplete:^{
            EXECUTE_BLOCK(completionHandler);
        }];
    } else if ([msgType isEqualToString:@"400028"]) {//晓可币充值后台验证苹果服务器结果
      [[IAPCenter shareCenter] handleRemoteNotification:userInfo];
        EXECUTE_BLOCK(completionHandler);
    } else {
        EXECUTE_BLOCK(completionHandler);
    }
}


//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//  <#code#>
//}
//
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//  <#code#>
//}

@end
