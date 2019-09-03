//
//  AppDelegate+XKComponentConfig.m
//  XKSquare
//
//  Created by Jamesholy on 2019/2/28.
//  Copyright © 2019 xk. All rights reserved.
//

#import "AppDelegate+XKComponentConfig.h"
#import "HTTPClient.h"
#import "XKInfoProvider.h"
#import "XKLoginConfig.h"
#import "XKDeviceDataLibrery.h"
#import <XKContactCacheManager.h>
#import "xkMerchantEmitterModule.h"
@implementation AppDelegate (XKComponentConfig)


- (void)componentConfig {
    [self configInfoProvider];
    [self configNetWordResponseHander];
    [self configFriendCacheComplete];
}


- (void)configInfoProvider {
    [XKInfoProvider providerConfig:^(XKInfoProvider *provider) {
        provider.getUser = ^XKUserInfo *{
            return [XKUserInfo currentUser];
        };
        provider.getSalt = ^NSString *{
            return [self getRandomStringWithNum:6];
        };
        provider.getCurrentTimestamp = ^NSString *{
            return [XKTimeSeparateHelper backTimestampStringWithDate:[NSDate date]];
        };
        provider.getTimestampDifference = ^NSNumber *{
            return @(0);
        };
        provider.getBaseUrlStr = ^NSString *{
            return BaseUrl;
        };
        provider.getIMAccoutId = ^NSString *{
            return [NIMSDK sharedSDK].loginManager.currentAccount;
        };
        provider.platformNetCode = @"ma";
        provider.deviceName = (NSString *)[[XKDeviceDataLibrery sharedLibrery] getDiviceName];
        provider.guid = [XKGlobleCommonTool getCurrentUserDeviceToken];
        provider.tokenFailCodeArr = @[@"419",@"1413",@"1089",@"1349",@"1356"];
        
    }];
}

- (void)configNetWordResponseHander {
    [[HTTPClient sharedHttpClient] handleSpecialResponse:^(XKNetWorkStatus status, NSInteger code, NSString *message, XKCompletionHandler completeHandler) {
        switch (status) {
            case XKNetWorkLoginFailStatus: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
               [XKHudView hideAllHud];
#pragma clang diagnostic pop
              
              [XKLoginConfig loginDropOutConfig];
              [xkMerchantEmitterModule loginTokenFail:[NSString stringWithFormat:@"%ld",code] message:message];
              completeHandler();
            }
                break;
            case XKNetWorkNoDataStatus: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                [XKHudView hideAllHud];
#pragma clang diagnostic pop
                completeHandler();
            }
                break;
            default:
                break;
        }
    }];
}

- (void)configFriendCacheComplete {
    [[XKContactCacheManager shareManager] setInfoUpdateComplete:^(NSArray<NSString *> *ids) {
        [[NIMSDK sharedSDK].userManager fetchUserInfos:ids completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
            
        }];
    }];
}

@end
