/*******************************************************************************
 # File        : XKLoginConfig.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/18
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKLoginConfig.h"
#import "XKIMGlobalMethod.h"
#import "XKUserInfo.h"
#import "XKUploadManager.h"
#import "XKMallCategoryListModel.h"
#import "JPUSHService.h"
#import <NIMSDK/NIMSDK.h>
#import "XKContactCacheManager.h"
//#import "XKLoginViewController.h"
#import "XKRelationUserCacheManager.h"
#import "XKSecretTipMsgManager.h"
#import "XKCityDBManager.h"
#import "XKCityListNetworkMethod.h"
#import "XKCityListDefaults.h"
#import "xkMerchantEmitterModule.h"
@implementation XKLoginConfig



/**
 退出之后的配置
 */
+ (void)loginDropOutConfig {
    [XKUserInfo cleanUser];

    //云信登出
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        NSLog(@"====================云信登出成功===============================");
    }];
    //取消极光注册别名
    [JPUSHService setAlias:@"" completion:nil seq:0];
    NSLog(@"======================取消极光注册别名================================");
//    XKLoginViewController *vc = [XKLoginViewController new];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
  
}


/**
 登录之后的配置
 */
+ (void)loginConfig {
    [XKIMGlobalMethod IMLoginWithAccount:[XKUserInfo getCurrentIMUserID] andToken:[XKUserInfo getCurrentIMUserToken] error:^(NSError *error) {
        if (!error) {
            NSLog(@"-------------IM登陆成功--------------\n  ID:%@ \n token:%@ \n----------------------------",[XKUserInfo getCurrentIMUserID],[XKUserInfo getCurrentIMUserToken]);
          
        }
    }];
    //注册极光别名
    // [JPUSHService setAlias:[XKUserInfo getCurrentUserId] completion:nil seq:0];
    // NSLog(@"======================极光注册别名：%@================================",[XKUserInfo getCurrentUserId]);
    // NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    // parameters[@"userId"] = [XKUserInfo getCurrentUserId];
    // parameters[@"registrationId"] = [JPUSHService registrationID];
    // parameters[@"alias"] = [XKUserInfo getCurrentUserId];
    
    // [HTTPClient postEncryptRequestWithURLString:@"im/ua/jpushReg/1.0" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
    // } failure:^(XKHttpErrror *error) {
    // }];
    
    [self autoLoginConfig:NO];
}

#pragma mark - 自动登录后的配置
+ (void)autoLoginConfig:(BOOL)autoLogin {
  if (autoLogin) {
    [XKIMGlobalMethod IMAutoLogin];
  }
  //更新通讯录
  [XKRelationUserCacheManager refreshTotal];
  //配置用户订阅数据
//  [XKGlobleCommonTool saveSubscriptionData];
  //密友提醒设置配置
  [[XKSecretTipMsgManager shareManager] updateSecretTipSetting];
  [[XKSecretTipMsgManager shareManager] fetchUnReadTimerMsgListComplete:nil];
  
  [XKUploadManager getQNUploadToken:^(NSString *token) {
    NSLog(@"七牛token请求成功");
  } Failure:^(NSString *errorStr) {
    NSLog(@"七牛token请求失败");
  }];
  
  // 配置红点
  [XKRedPointManager configAllItem];
  [XKRedPointManager refreshAllTabbarRedPoint];
  [self updateCityListDB];
}


+ (void)updateCityListDB {
  [[XKCityDBManager shareInstance]createTable];
  [XKCityDBManager shareInstance].isShowDebugLog = NO;
  [XKCityListNetworkMethod getCityCacheListParameters:@{@"v":[XKCityListDefaults getCityCacheListVersion] ? [XKCityListDefaults getCityCacheListVersion] : @"",@"limit":@0,@"level":@2} Block:^(id responseObject, BOOL isSuccess) {
    if ([responseObject isEqualToString: @""]) {}else{
      XKCityListModel *model = [XKCityListModel yy_modelWithJSON:responseObject];
      [XKCityListDefaults saveCityCacheListVersion:model.v];
      dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (DataItem *dataModel in model.cityList) {
          [[XKCityDBManager shareInstance]updateCityTable:dataModel];
        }
      });
    }
  }];
  
  [XKCityListNetworkMethod getDistrictCacheListParameters:@{@"v":[XKCityListDefaults getDistrictCacheListVersion] ? [XKCityListDefaults getDistrictCacheListVersion] : @"",@"limit":@0,@"level":@3} Block:^(id responseObject, BOOL isSuccess) {
    if ([responseObject isEqualToString: @""]) {}else{
      XKCityListModel *model = [XKCityListModel yy_modelWithJSON:responseObject];
      [XKCityListDefaults saveDistrictCacheListVersion:model.v];
      dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (DataItem *dataModel in model.districtList) {
          [[XKCityDBManager shareInstance]updateDistrictTable:dataModel];
        }
      });
    }
  }];
  [XKCityListNetworkMethod getProvinceCacheListParameters:@{@"v":[XKCityListDefaults getProvinceCacheListVersion] ? [XKCityListDefaults getProvinceCacheListVersion] : @"",@"limit":@0,@"level":@1} Block:^(id responseObject, BOOL isSuccess) {
    if ([responseObject isEqualToString: @""]) {}else {
      XKCityListModel *model = [XKCityListModel yy_modelWithJSON:responseObject];
      [XKCityListDefaults saveProvinceCacheListVersion:model.v];
      dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (DataItem *dataModel in model.provinceList) {
          [[XKCityDBManager shareInstance]updateProvinceTable:dataModel];
        }
      });
    }
  }];
}


@end
