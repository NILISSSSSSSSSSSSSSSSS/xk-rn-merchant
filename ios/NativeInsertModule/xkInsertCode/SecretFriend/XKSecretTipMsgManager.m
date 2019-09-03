/*******************************************************************************
 # File        : XKSecretTipMsgManager.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/29
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSecretTipMsgManager.h"
#import "XKSecretTipEditController.h"
#import <UserNotifications/UserNotifications.h>
#import "XKIMMessageNomalTextAttachment.h"
#import <NIMKit.h>
#import "XKContactCacheManager.h"
#import "XKSecretFrientManager.h"
#import "XKRelationUserCacheManager.h"
#define kSecretCicleActiveRecordCache [NSString stringWithFormat:@"XKSecretActiveRecord_%@",[XKUserInfo getCurrentUserId]]

#define kSecretCicleTipSettingCache [NSString stringWithFormat:@"XKSecretCirleTipSetting_%@",[XKUserInfo getCurrentUserId]]

@interface XKSecretTipMsgManager ()

@property(nonatomic, copy) NSArray <XKSecretTipMsg *>*allSecretTipSettings;

@end

@implementation XKSecretTipMsgManager

+ (instancetype)shareManager {
  static dispatch_once_t onceToken;
  static XKSecretTipMsgManager * _instance;
  dispatch_once(&onceToken, ^{
    _instance = [XKSecretTipMsgManager new];
  });
  return _instance;
}

#pragma mark - 更新密友提醒设置信息
- (void)updateSecretTipSetting {
  NSMutableDictionary *params = @{}.mutableCopy;
  [HTTPClient getEncryptRequestWithURLString:@"im/ua/allNormalMsgList/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
    [[NSUserDefaults standardUserDefaults] setValue:responseObject forKey:kSecretCicleTipSettingCache];
    self.allSecretTipSettings = [NSArray yy_modelArrayWithClass:[XKSecretTipMsg class] json:responseObject];
  } failure:^(XKHttpErrror *error) {
    //
  }];
}

- (NSArray *)allSecretTipSettings {
  if (_allSecretTipSettings == nil) {
    id res = [[NSUserDefaults standardUserDefaults] valueForKey:kSecretCicleTipSettingCache];
    if (res) {
      _allSecretTipSettings = [NSArray yy_modelArrayWithClass:[XKSecretTipMsg class] json:res];
    } else {
      _allSecretTipSettings = @[];
    }
  }
  return _allSecretTipSettings;
}

#pragma mark - 更新密友圈操作时间
- (void)updateSecretCircleActiveTime:(NSString *)secretId {
  if (secretId.length == 0 || [XKUserInfo getCurrentUserId].length == 0) {
    return;
  }
  NSMutableDictionary *cacheDic = [[XKUserDefault objectForKey:kSecretCicleActiveRecordCache] mutableCopy];
  if (cacheDic == nil) {
    cacheDic = @{}.mutableCopy;
  }
  cacheDic[secretId] = [NSString stringWithFormat:@"%@",@([[NSDate date] timeIntervalSince1970])];
  [XKUserDefault setObject:cacheDic.copy forKey:kSecretCicleActiveRecordCache];
}

- (NSString *)getActiveTimeForSecretCircle:(NSString *)secretId {
  NSDictionary *cacheDic = [XKUserDefault objectForKey:kSecretCicleActiveRecordCache];
  return cacheDic[secretId];
}

#pragma mark - 判断该密友圈消息是否应该外置显示
- (BOOL)judgeMessageShouldShowOutside:(NSString *)secretId {
  for (XKSecretTipMsg *obj in self.allSecretTipSettings) {
    if ([obj.secretId isEqualToString:secretId]) {
      NSString *activeTime = [self getActiveTimeForSecretCircle:secretId];
      NSInteger invaildDay = obj.invalidDay;
      return ![self outActiveTime:invaildDay lastActiveTime:activeTime];
    }
  }
  return NO;
}

- (XKSecretTipMsg *)getSecretMappingTip:(NSString *)secretId {
  for (XKSecretTipMsg *obj in self.allSecretTipSettings) {
    if ([obj.secretId isEqualToString:secretId]) {
      return obj;
    }
  }
  return nil;
}

#pragma mark - 判断是否失效
- (BOOL)outActiveTime:(NSInteger)invaildDay lastActiveTime:(NSString *)timesStampStr {
  if (timesStampStr.length == 0) {
    return NO;
  }
  if (invaildDay == 0) {
    return NO;
  }
  long currentTimeStamp = [[NSDate date] timeIntervalSince1970];
  if (currentTimeStamp - timesStampStr.longLongValue >   invaildDay * 24 * 60 * 60) { // 过期
    return YES;
  } else {
    return NO;
  }
}

#pragma mark - 设置密友透传提醒消息
- (void)dealOutsideMessage:(NIMMessage *)message{
  
  if (message.messageType != NIMMessageTypeCustom) {
    return;
  }
  NIMCustomObject *object = message.messageObject;
  XKIMMessageBaseAttachment *baseAtt = object.attachment;
  if (![baseAtt isKindOfClass:[XKIMMessageBaseAttachment class]]) {
    return;
  }
  if (baseAtt.extraType == XKIMExtraAttachmentSecretTipMsgType) { // 防止循环
    return;
  }
  
  if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneAll &&
      [XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneNomal) {
    return;
  }
  if (baseAtt.group != 2) {
    if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneRespective) {
      return;
    }
  }
  
  XKContactModel *userModel = [XKRelationUserCacheManager queryContactWithUserId:message.session.sessionId];
  NSString *secretId = userModel.secretId;
  if (userModel.isStrange) {
    return;
  }
  if ([self judgeMessageShouldShowOutside:secretId]) { // 能够外置显示 判断密友圈活跃程度
    XKSecretTipMsg *tipMsg = [self getSecretMappingTip:secretId];
    // 还要判断映射人是否是好友
    XKContactModel *user = [XKContactCacheManager queryContactWithUserId:tipMsg.msgMappingUserId];
    if (!user.isStrange) { // 是好友 并且不是同一个人
      NSString *msgContent = tipMsg.msgContent;
      NSString *userId = tipMsg.msgMappingUserId;
      NIMSession *session = [NIMSession session:userId type:NIMSessionTypeP2P];
      [self writeLoacalMessage:msgContent session:session detailSetting:^(NIMMessage *message) {
        message.timestamp = message.timestamp;
        // 详细信息设置
      } completion:^(NSError * _Nullable error) {
        
      }];
    }
  } else { // 不能外置显示
    // fix 逻辑
  }
}

#pragma mark - 获取到期的提醒消息
- (void)fetchUnReadTimerMsgListComplete:(void (^)(void))completionHandler {
  [HTTPClient getEncryptRequestWithURLString:@"im/ua/unReadTimerMsgList/1.0" timeoutInterval:20 parameters:nil success:^(id responseObject) {
    NSArray *tips = [NSArray yy_modelArrayWithClass:[XKSecretTipMsg class] json:responseObject];
    for (XKSecretTipMsg *msg in tips) {
      [self dealClockTipsMessage:msg];
    }
    EXECUTE_BLOCK(completionHandler);
  } failure:^(XKHttpErrror *error) {
    
  }];
}

#pragma mark - 设置定时提醒消息
- (void)dealClockTipsMessage:(XKSecretTipMsg *)tipMsg {
  if (tipMsg == nil) {
    return;
  }
  // 还要判断映射人是否是好友
  XKContactModel *user = [XKContactCacheManager queryContactWithUserId:tipMsg.msgMappingUserId];
  if (!user.isStrange) {
    NSString *userId = tipMsg.msgMappingUserId;
    XKContactModel *user = [XKContactCacheManager queryContactWithUserId:userId];
    if (!user.isStrange) {
      NIMSession *session = [NIMSession session:userId type:NIMSessionTypeP2P];
      
      [self writeLoacalMessage:tipMsg.msgContent?:@" " session:session detailSetting:^(NIMMessage *message) {
        message.timestamp = [tipMsg.sendTime longLongValue];
      } completion:^(NSError * _Nullable error) {
        NSLog(@"%@",error.localizedDescription);
        
      }];
    }
  }
}

#pragma mark - 以对方名义发消息给自己
- (void)writeLoacalMessage:(NSString *)messageStr session:(NIMSession *)session detailSetting:(void(^)(NIMMessage *message))messageDetailSetting completion:(void(^)(NSError * _Nullable error))completion {
  XKIMMessageNomalTextAttachment *attachment = [[XKIMMessageNomalTextAttachment alloc] init];
  attachment.msgContent = messageStr;
  attachment.extraType = XKIMExtraAttachmentSecretTipMsgType;
  NIMCustomObject *object = [[NIMCustomObject alloc] init];
  object.attachment = attachment;
  
  // 构造出具体消息并注入附件
  NIMMessage *message = [[NIMMessage alloc] init];
  message.messageObject = object;
  message.from = session.sessionId;
  EXECUTE_BLOCK(messageDetailSetting,message);
  // 发送消息
  [[NIMSDK sharedSDK].conversationManager saveMessage:message forSession:session completion:^(NSError * _Nullable error) {
    EXECUTE_BLOCK(completion,error);
  }];
}

- (BOOL)isOutsiderMan:(NSString *)userId {
  for (XKSecretTipMsg *obj in self.allSecretTipSettings) {
    if ([obj.msgMappingUserId isEqualToString:userId]) {
      return YES;
    }
  }
  return NO;
}

@end
