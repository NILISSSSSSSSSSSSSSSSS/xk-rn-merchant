//
//  XKIMUserDataProvider.m
//  XKSquare
//
//  Created by william on 2018/10/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMUserDataProvider.h"
#import <NIMKit.h>
#import <NIMSDK/NIMSDK.h>
#import "XKSecretDataSingleton.h"
#import "XKSecretContactCacheManager.h"
#import "XKContactCacheManager.h"
@interface XKIMUserDataProvider()<NIMKitDataProvider>

@end

@implementation XKIMUserDataProvider

- (NIMKitInfo *)infoByUser:(NSString *)userId
                    option:(NIMKitInfoFetchOption *)option {
  NIMUser *userObj = [[NIMSDK sharedSDK].userManager userInfo:userId];
  NIMKitInfo *info;
  info = [[NIMKitInfo alloc] init];
  info.infoId = userId;
  info.avatarImage = kDefaultHeadImg;
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret) {
    XKContactModel *model = [XKSecretContactCacheManager queryContactWithUserId:userId];
    info.showName = model.displaySecretName;
    if ([userId isEqualToString:[XKUserInfo currentUser].userId]) {
      info.avatarUrlString = [XKSecretDataSingleton sharedManager].currentMySecretInfo.avatar?[XKSecretDataSingleton sharedManager].currentMySecretInfo.avatar:model.avatar;
    }
    else{
      info.avatarUrlString = model.avatar;
    }
  }
  else{
    XKContactModel *model = [XKContactCacheManager queryContactWithUserId:userId];
    if ([userId isEqualToString:[XKUserInfo currentUser].userId]) {
      info.avatarUrlString = userObj.userInfo.avatarUrl;
      
    }
    else{
      info.avatarUrlString = model.avatar;
    }
    info.showName = userObj.alias ? userObj.alias : userObj.userInfo.nickName;
  }
  
  if (info.avatarUrlString == nil) {
    info.avatarUrlString = userObj.userInfo.avatarUrl;
  }
  
  return info;
}
@end
