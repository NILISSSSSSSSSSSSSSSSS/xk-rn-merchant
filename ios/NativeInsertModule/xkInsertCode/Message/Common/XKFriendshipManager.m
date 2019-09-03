/*******************************************************************************
 # File        : XKFriendshipManager.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/29
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendshipManager.h"
#import "XKApplyFriendController.h"
#import "XKContactCacheManager.h"
#import "XKRelationUserCacheManager.h"
#import "XKSecretFrientManager.h"

@implementation XKFriendshipManager

#pragma mark - 添加好友
/**
 添加好友
 
 @param userId 被添加者id
 @param successApply 回调 （添加好友会跳转新界面  成功发出好友申请会回调此block 弹框内部处理）
 */
+ (void)addFriend:(NSString *)userId successApply:(void(^)(void))successApply {
  XKApplyFriendController *vc = [[XKApplyFriendController alloc] init];
  vc.applyId = userId;
  vc.applyComplete = successApply;
  [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark - 添加密友
/**
 添加密友
 
 @param userId 被添加者id
 @param secretId 密友圈id
 @param successApply 回调 （添加密友会跳转新界面  成功发出密友申请会回调此block 弹框内部处理）
 */
+ (void)addSecretFriend:(NSString *)userId withSecretId:(NSString *)secretId successApply:(void(^)(void))successApply {
  XKApplyFriendController *vc = [[XKApplyFriendController alloc] init];
  vc.applyId = userId;
  vc.secretId = secretId;
  vc.isSecret = YES;
  vc.applyComplete = successApply;
  [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

/**
 添加密友  是可友的情况 不用验证 直接添加
 
 @param userId 被添加者id
 @param secretId 密友圈id
 @param complete 回调
 */
+ (void)addSecretFriendWithoutAgree:(NSString *)userId needDeleteFriend:(BOOL)delete withSecretId:(NSString *)secretId complete:(void(^)(NSString *error,id data))complete {
  
  NSString *url = @"im/ua/secretFriendAdd/1.0";
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"userId"] = [XKUserInfo getCurrentUserId];
  params[@"rid"] = userId;
  params[@"secretId"] = secretId;
  params[@"isDel"] = delete ? @(1) : @(0);
  [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    EXECUTE_BLOCK(complete,nil,responseObject);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                     [[NSNotificationCenter defaultCenter] postNotificationName:XKSecretFriendListInfoChangeNoti object:nil];
                     [XKRelationUserCacheManager refreshTotal];
                   });
    
    
  } failure:^(XKHttpErrror *error) {
    EXECUTE_BLOCK(complete,error.message,nil);
  }];
}

#pragma mark - 好友申请处理
+ (void)requestOperateFriendApply:(BOOL)allow applyId:(NSString *)applyId complete:(void(^)(NSString *error,id data))complete {
  NSString *url = @"im/ua/friendsApplyUpdate/1.0";
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"friendsApplyRecordId"] = applyId;
  params[@"action"] = allow ? @(1) : @(0);
  [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    EXECUTE_BLOCK(complete,nil,responseObject);
    if (allow) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                     ^{
                       [[NSNotificationCenter defaultCenter] postNotificationName:XKFriendListInfoChangeNoti object:nil];
                       [XKRelationUserCacheManager refreshTotal];
                     });
    }
  } failure:^(XKHttpErrror *error) {
    EXECUTE_BLOCK(complete,error.message,nil);
  }];
}

#pragma mark - 关注某人
+ (void)requestFocus:(NSString *)userId complete:(void(^)(NSString *error,id data))complete {
  NSString *url = @"im/ua/follow/1.0";
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"userId"] = [XKUserInfo getCurrentUserId];
  params[@"rid"] = userId;
  [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    EXECUTE_BLOCK(complete,nil,responseObject);
  } failure:^(XKHttpErrror *error) {
    EXECUTE_BLOCK(complete,error.message,nil);
  }];
}

#pragma mark - 取关某人
+ (void)requestNoFocus:(NSString *)userId complete:(void(^)(NSString *error,id data))complete {
  NSString *url = @"im/ua/unfollow/1.0";
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"userId"] = [XKUserInfo getCurrentUserId];
  params[@"rid"] = userId;
  [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    EXECUTE_BLOCK(complete,nil,responseObject);
  } failure:^(XKHttpErrror *error) {
    EXECUTE_BLOCK(complete,error.message,nil);
  }];
}

+ (void)requestFocus:(BOOL)focus userId:(NSString *)userId complete:(void (^)(NSString *, id))complete {
  if (focus) {
    [self requestFocus:userId complete:complete];
  } else {
    [self requestNoFocus:userId complete:complete];
  }
}

#pragma mark - 加入黑名单
+ (void)requestAddBlackList:(NSString *)userId complete:(void(^)(NSString *error,id data))complete {
  NSString *url = @"im/ua/blackListAdd/1.0";
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"userId"] = [XKUserInfo getCurrentUserId];
  params[@"rid"] = userId;
  [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    EXECUTE_BLOCK(complete,nil,responseObject);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                     [XKRelationUserCacheManager refreshTotal];
                     [XKIMGlobalMethod cancelNormalTopChatWithUserID:userId];
                     
                   });
    
  } failure:^(XKHttpErrror *error) {
    EXECUTE_BLOCK(complete,error.message,nil);
  }];
}

#pragma mark - 移除黑名单
+ (void)requestRemoveBlackList:(NSString *)userId complete:(void(^)(NSString *error,id data))complete {
  NSString *url = @"im/ua/blackListRemove/1.0";
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"userId"] = [XKUserInfo getCurrentUserId];
  params[@"rid"] = userId;
  [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    EXECUTE_BLOCK(complete,nil,responseObject);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                     [[NSNotificationCenter defaultCenter] postNotificationName:XKFriendListInfoChangeNoti object:nil];
                     [XKRelationUserCacheManager refreshTotal];
                   });
    
  } failure:^(XKHttpErrror *error) {
    EXECUTE_BLOCK(complete,error.message,nil);
  }];
}

+ (void)requestBlackListStatus:(BOOL)add userId:(NSString *)userId complete:(void (^)(NSString *, id))complete {
  if (add) {
    [self requestAddBlackList:userId complete:complete];
  } else {
    [self requestRemoveBlackList:userId complete:complete];
  }
}


#pragma mark -  修改密友所属组/移除组
/**
 修改密友所属组/移除组
 
 @param groupId 为空代表移除
 @param userId 用户id
 @param secretId 密友圈id
 @param complete 回调
 */
+ (void)requestChangeSecretFriendGroup:( NSString * _Nullable )groupId userId:(NSString *)userId withSecretId:(NSString *)secretId complete:(void(^)(NSString *error,id data))complete {
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"rid"] = userId;
  params[@"secretId"] = secretId;
  params[@"groupId"] = groupId;
  NSString *url = @"im/ua/secretFriendGroupUpdate/1.0";
  [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    complete(nil,responseObject);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                     [[NSNotificationCenter defaultCenter] postNotificationName:XKSecretFriendListInfoChangeNoti object:nil];
                     [XKRelationUserCacheManager refreshTotal];
                   });
  } failure:^(XKHttpErrror *error) {
    complete(error.message,nil);
  }];
}

#pragma mark -  修改可友所属组/移除组
/**
 修改可友所属组/移除组
 
 @param groupId 为空代表移除
 @param userId 用户id
 @param complete 回调
 */
+ (void)requestChangeFriendGroup:( NSString * _Nullable )groupId userId:(NSString *)userId complete:(void(^)(NSString *error,id data))complete {
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"rid"] = userId;
  params[@"groupId"] = groupId;
  NSString *url = @"im/ua/xkFriendGroupUpdate/1.0";
  [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    complete(nil,responseObject);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                     [[NSNotificationCenter defaultCenter] postNotificationName:XKFriendListInfoChangeNoti object:nil];
                     [XKRelationUserCacheManager refreshTotal];
                   });
    
    
  } failure:^(XKHttpErrror *error) {
    complete(error.message,nil);
  }];
}

#pragma mark - 设置朋友圈查看权限
/**
 设置朋友圈查看权限
 
 @param authorityType 0 不看他的朋友圈  1 不让他看我的朋友圈
 @param allow 是否允许
 @param friendId 朋友id
 @param complete complete description
 */
+ (void)requestSetFriendCircleAuthorityType:(NSInteger)authorityType allow:(BOOL)allow friendId:(NSString *)friendId complete:(void(^)(NSString *error,id data))complete {
  NSString *url = allow ? @"im/ua/friendCircleAuthDelete/1.0" : @"im/ua/friendCircleAuthAdd/1.0";
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"userId"] = [XKUserInfo getCurrentUserId];
  params[@"rid"] = friendId;
  params[@"authorityType"] = authorityType == 0 ? @"visitTaCF" : @"visitMeCF";
  [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    complete(nil,responseObject);
  } failure:^(XKHttpErrror *error) {
    complete(error.message,nil);
  }];
}

#pragma mark - 删除可友
/**删除可友*/
+ (void)requestDeleteFriend:(NSString *)userId complete:(void(^)(NSString *error,id data))complete {
  NSString *url = @"im/ua/friendDelete/1.0";
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"userId"] = [XKUserInfo getCurrentUserId];
  params[@"rid"] = userId;
  [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    complete(nil,responseObject);
    [XKIMGlobalMethod deleteAllKeFriendChatHistoryInSession:[NIMSession session:userId type:NIMSessionTypeP2P] deleteRecentSession:YES complete:^(BOOL success) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                     ^{
                       [[NSNotificationCenter defaultCenter] postNotificationName:XKFriendListInfoChangeNoti object:nil];
                       [XKRelationUserCacheManager refreshTotal];
                     });
    }];
  } failure:^(XKHttpErrror *error) {
    complete(error.message,nil);
  }];
}

#pragma mark - 删除密友
/**删除密友*/
+ (void)requestDeleteSecretFriend:(NSString *)userId complete:(void(^)(NSString *error,id data))complete {
  NSString *url = @"im/ua/secretFriendDelete/1.0" ;
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"userId"] = [XKUserInfo getCurrentUserId];
  params[@"rid"] = userId;
  [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    complete(nil,responseObject);
    [XKSecretFrientManager deleteAllSecretChatHistoryInSession:[NIMSession session:userId type:NIMSessionTypeP2P] complete:^(BOOL success) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                     ^{
                       [[NSNotificationCenter defaultCenter] postNotificationName:XKSecretFriendListInfoChangeNoti object:nil];
                       [XKRelationUserCacheManager refreshTotal];
                     });
    }];
    
  } failure:^(XKHttpErrror *error) {
    complete(error.message,nil);
  }];
}

#pragma mark - 删除密友 并删除可友
/**删除密友 并删除可友  同时为密友的情况*/
+ (void)requestDeleteSecretFriendBothDeleteFriend:(NSString *)userId complete:(void(^)(NSString *error,id data))complete {
  NSString *url = @"im/ua/secretFriendDelete/1.0" ;
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"userId"] = [XKUserInfo getCurrentUserId];
  params[@"rid"] = userId;
  params[@"isDel"] = @"1";
  [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    complete(nil,responseObject);
    [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:[NIMSession session:userId type:NIMSessionTypeP2P] option:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:XKSecretFriendListInfoChangeNoti object:nil];
                     [[NSNotificationCenter defaultCenter] postNotificationName:XKFriendListInfoChangeNoti object:nil];
                     [XKRelationUserCacheManager refreshTotal];
                   });
    
  } failure:^(XKHttpErrror *error) {
    complete(error.message,nil);
  }];
}

#pragma mark - 删除密友并转为可友
/**删除密友 并转为可友  单密友的情况*/
+ (void)requestDeleteSecretFriendBothReturnFriend:(NSString *)userId complete:(void(^)(NSString *error,id data))complete {
  NSString *url = @"im/ua/secretFriendDelete/1.0" ;
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"userId"] = [XKUserInfo getCurrentUserId];
  params[@"rid"] = userId;
  params[@"isDel"] = @"2";
  [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    complete(nil,responseObject);
    [XKSecretFrientManager deleteAllSecretChatHistoryInSession:[NIMSession session:userId type:NIMSessionTypeP2P] complete:^(BOOL success) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                     ^{
                       [[NSNotificationCenter defaultCenter] postNotificationName:XKSecretFriendListInfoChangeNoti object:nil];
                       [[NSNotificationCenter defaultCenter] postNotificationName:XKFriendListInfoChangeNoti object:nil];
                       [XKRelationUserCacheManager refreshTotal];
                     });
    }];
    
  } failure:^(XKHttpErrror *error) {
    complete(error.message,nil);
  }];
}


+ (void)filterStrangerUserWithUsers:(NSArray <XKContactModel *>*)users userKey:(NSString *)userKey result:(void (^)(NSArray *users,BOOL singleIsMyFriend))result {
  NSMutableArray *filterArr = @[].mutableCopy;
  if (users.count == 1) { //唯一一个用户
    XKContactModel *user = users.firstObject;
    if (user.isFriends && !user.isBlackList && ([user.nickname isEqualToString:userKey] || [user.uid isEqualToString:userKey])) { // 是我的好友 并且没拉黑  并且是精确搜索
      result(nil,YES);
      return;
    }
  }
  for (XKContactModel *model in users) {
    if (!model.isFriends || model.isBlackList) { // 不是好友 或者 是黑名单
      [filterArr addObject:model];
    }
  }
  result(filterArr,NO);
}

@end
