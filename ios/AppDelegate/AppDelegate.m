/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"
#import <RCTJPushModule.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "DragStickinessView.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "RNSplashScreen.h"
#import "LocationManager.h"
#import "JSHAREService.h"
#import "ProjectHeader.h"
#import "RNUMConfigure.h"
#import <JPUSHService.h>
#import <UMAnalytics/MobClick.h>
#import <React/RCTLinkingManager.h>

#import "BaseRNViewController.h"
#import "AppDelegate+XKIMConfig.h"
#import "AppDelegate+XKJPush.h"
#import "AlipayModule.h"
#import "XKAPPNetworkConfig.h"
#import <XKCrashRecord.h>
#import <XKConsoleBoard.h>
#import "ReactRootViewManager.h"

#import "AppDelegate+XKComponentConfig.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // 组件初始化配置
  [self componentConfig];
  [self configEnvir];
  
  for(NSString *fontfamilyname in [UIFont familyNames])
  {
    NSLog(@"family:'%@'",fontfamilyname);
    for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
    {
      NSLog(@"\tfont:'%@'",fontName);
    }
    NSLog(@"-------------");
  }

  NSURL *jsCodeLocation;
  #if DEBUG // sedd
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil]; // sedd
  #else // sedd
 jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
  #endif // sedd
  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"xkMerchant"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
  [ReactRootViewManager manager].bridge = rootView.bridge;
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  BaseRNViewController *rootViewController = [BaseRNViewController new];
  rootViewController.view = rootView;
  rootViewController.rnId = @"rnId";
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootViewController];
  self.window.rootViewController = nav;
  [self.window makeKeyAndVisible];
  [self defaultSetting:launchOptions];
  [RNSplashScreen show];

#ifdef DEBUG
  [self configTestBtn];
#endif

  return YES;
}


#ifdef DEBUG
- (void)configTestBtn {
  DragStickinessView *dragView = [[DragStickinessView alloc] initWithPoint:CGPointMake(10,SCREEN_HEIGHT-130-kBottomSafeHeight) superView:self.window];
  dragView.tag = 10101;
  dragView.viscosity  = 8;
  dragView.bubbleWidth = 55;
  dragView.bubbleColor = RGB(254, 67, 101);
  dragView.limitInset = UIEdgeInsetsMake(20, 5, 60, 5);
  dragView.autoBackMode = DragStickinessBackMixMode;
  [dragView setUp];
  dragView.bubbleLabel.text = @"测试";
  dragView.bubbleLabel.textColor = [UIColor whiteColor];
  dragView.bubbleLabel.font = [UIFont boldSystemFontOfSize:18];
  dragView.bubbleLabel.userInteractionEnabled = YES;
  [dragView.bubbleLabel bk_whenTapped:^{
    [self testClick];
  }];
}

- (void)testClick {
   [[XKConsoleBoard borad] show];
}
#endif

- (void)configEnvir {
  // 获取文件路径
  NSString *path = [[NSBundle mainBundle] pathForResource:@"requestConfig" ofType:@"json"];
  // 将文件数据化
  NSData *data = [[NSData alloc] initWithContentsOfFile:path];
  // 对数据进行JSON格式化并返回字典形式
  NSDictionary *config = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  NSString *envir = config[@"envir"];
  NSAssert(envir.length != 0, @"requestConfig.json 请配置，并且拖入项目 不要copy的那种");
  [APPDebug saveDebugModeStatus:envir.integerValue];
  [APPDebug setNetHeader:config[@"netHeader"]];
}

- (void)defaultSetting:(NSDictionary *)launchOptions {
  [LocationManager shareInstance];
  [self setupNIMSDK];
  //极光分享和登录的配置
  [self JShareConfig];
  //极光推送配置
  [self JPushConfigWithOptions:launchOptions];



  [UMConfigure setLogEnabled:NO];
  [RNUMConfigure initWithAppkey:@"5bf29183b465f5a1ca000439" channel:@"App Store"];
  [MobClick setScenarioType:E_UM_NORMAL];
  [MobClick setCrashReportEnabled:YES];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  [JPUSHService registerDeviceToken:deviceToken];
  [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kJPFDidReceiveRemoteNotification object:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kJPFDidReceiveRemoteNotification object: notification.userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)   (UIBackgroundFetchResult))completionHandler
{
  [self JPushApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
  [[NSNotificationCenter defaultCenter] postNotificationName:kJPFDidReceiveRemoteNotification object:userInfo];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
  if([[sourceApplication substringToIndex:10] isEqualToString:@"com.alipay"]){
    [AlipayModule handleCallback:url];
  }
  return [RCTLinkingManager application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
  // ios9 以上微信支付回调
  if([url.host isEqualToString:@"pay"]) {
    return [RCTLinkingManager application:app openURL:url options:options];
  }
  
  // ios9 支付宝支付回调
  if([url.host isEqualToString:@"safepay"]) {
    [AlipayModule handleCallback:url];
  }
  return  [self JPushApplication:app openURL:url options:options];
}

@end
