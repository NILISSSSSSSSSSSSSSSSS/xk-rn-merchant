//
//  AppDelegate+XKJPush.h
//  XKSquare
//
//  Created by Lin Li on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "JPUSHService.h"

@interface AppDelegate (XKJPush)<UNUserNotificationCenterDelegate>

/**
 极光分享和登录的配置
 */
- (void)JShareConfig;

/**
 极光推送配置

 @param launchOptions launchOptions
 */
- (void)JPushConfigWithOptions:(NSDictionary *)launchOptions;

/**
 DeviceToken获取

 @param application application
 @param deviceToken AppDelegate中didRegisterForRemoteNotificationsWithDeviceToken方法deviceToken
 */
- (void)JPushApplication:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

/**
 Error

 @param application application
 @param error AppDelegate中didFailToRegisterForRemoteNotificationsWithError方法error
 */
- (void)JPushApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

/**
 didReceiveRemoteNotification

 @param application application
 @param userInfo userInfo
 @param completionHandler completionHandler
 */
- (void)JPushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

- (BOOL)JPushApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

- (BOOL)JPushApplication:(UIApplication *)application handleOpenURL:(NSURL *)url;
@end
