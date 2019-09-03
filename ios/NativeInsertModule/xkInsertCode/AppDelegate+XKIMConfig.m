//
//  AppDelegate+XKIMConfig.m
//  XKSquare
//
//  Created by william on 2018/8/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "AppDelegate+XKIMConfig.h"
#import "XKIMMessageCutomeDecoder.h"
#import "XKIMMessageCustomConfig.h"
#import "XKIMUserDataProvider.h"
#import <NIMKit.h>
#import "XKIMMessageRedEnvelopeAttachment.h"
#import "XKIMMessageRedEnvelopeTipAttachment.h"
#import "XKIMMessageGiftAttachment.h"
#import "XKPushSysConfig.h"
#import "XKSecretFrientManager.h"
#import "XKIMSecretChatLastMessageModel.h"
#import "XKIMMessageManager.h"
#import "XKSecretDataSingleton.h"
#import "XKGlobalNotificationManager.h"
#import "XKLittleVideoRedEnvelopeNotificationModel.h"
#import "XKLittleVideoGiftNotificationModel.h"
#import "XKMineRedEnvelopeRecordsViewController.h"
#import "XKMyGiftRootController.h"
#import "XKSecretTipMsgManager.h"
#import "XKLoginConfig.h"
#import "xkMerchantEmitterModule.h"
@interface AppDelegate()<NIMChatManagerDelegate,NIMSystemNotificationManagerDelegate,NIMLoginManagerDelegate>
@end

@implementation AppDelegate (XKIMConfig)
-(void)setupNIMSDK {
  [self setConfig];
  
  //推荐在程序启动的时候初始化 NIMSDK
  NSString *appKey        = XKNIMAppKey;
  NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
  option.apnsCername      = XKNIMAPNSCerName;
  option.pkCername        = nil;
  [NIMKit sharedKit].config.cellBackgroundColor = UIColorFromRGB(0xEEEEEE);
  
  NIMServerSetting *setting    = [[NIMServerSetting alloc] init];
  setting.httpsEnabled = YES;
  [[NIMSDK sharedSDK] setServerSetting:setting];
  
  [[NIMSDK sharedSDK] registerWithOption:option];
  //注入头像显示配置
  [NIMKit sharedKit].provider = [XKIMUserDataProvider new];
  [NIMKit sharedKit].config.avatarType = NIMKitAvatarTypeRadiusCorner;
  
  [self registerDecoder];
  [self registerConfig];
  [self registerAPNs];
  //消息通知声音
  [[NIMSDK sharedSDK].chatManager addDelegate:self];
  [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
  [[XKIMMessageManager shareManager] configDelegate];
  
  //云信登陆代理 监控被踢或链接失败
  [[NIMSDK sharedSDK].loginManager addDelegate:self];
}

-(void)registerDecoder{
  [NIMCustomObject registerCustomDecoder:[[XKIMMessageCutomeDecoder alloc]init]];
}

-(void)registerConfig{
  [[NIMKit sharedKit] registerLayoutConfig:[XKIMMessageCustomConfig new]];
}

-(void)setConfig{
  [NIMSDKConfig sharedConfig].enabledHttpsForInfo = NO;
  [NIMSDKConfig sharedConfig].enabledHttpsForMessage = YES;
}

- (void)registerAPNs
{
  if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
    UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
  } else {
    UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
  }
}

- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
  NSLog(@"");
}

- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages {
  // 处理无关的消息
  [self handleUnrelatedMessages:messages];
  // 处理新消息响铃和振动方式
  [self handleBellsAndVibration:messages];
  // 处理密友消息
  [self handleSecretNewMessages:messages];
  
  // rn端系统消息通知
  [self handleSysMessageForRN:messages];
  //    // TODO: 测试
  //    BOOL test = YES;
  //    if (test) {
  //        // 处理全局弹窗消息
  //        [self handleGlobalNotification:messages];
  //    }
}

- (void)handleSysMessageForRN:(NSArray <NIMMessage *>*)messages {
  for (NIMMessage *message in messages) {
    if ([message.session.sessionId hasPrefix:@"system_"]) {
      NSString *jsonStr = [NSString stringWithFormat:@"%@",message.messageObject];
      [xkMerchantEmitterModule RNSystemMessage:jsonStr];
    }
  }
}

// 处理无关的消息
- (void)handleUnrelatedMessages:(NSArray <NIMMessage *>*)messages {
  for (NIMMessage *message in messages) {
    if ([self checkRedEnvelopeTip:message] && ![self shouldSaveMessageRedEnvelopeTip:message]) {
      // 删除和我无关的红包提示消息
      [[[NIMSDK sharedSDK] conversationManager] deleteMessage:message];
      continue;
    }
  }
}

// 判断消息是不是红包提示消息类型
- (BOOL)checkRedEnvelopeTip:(NIMMessage *)message {
  if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
    NIMCustomObject *object = message.messageObject;
    if ([object.attachment isKindOfClass:[XKIMMessageRedEnvelopeTipAttachment class]]) {
      return YES;
    }
  }
  return NO;
}
// 判断是否保存该红包提示消息
- (BOOL)shouldSaveMessageRedEnvelopeTip:(NIMMessage *)message {
  if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
    NIMCustomObject *object = message.messageObject;
    if ([object.attachment isKindOfClass:[XKIMMessageRedEnvelopeTipAttachment class]]) {
      XKIMMessageRedEnvelopeTipAttachment *attach = object.attachment;
      NSString *me = [NIMSDK sharedSDK].loginManager.currentAccount;
      return [attach.redEnvelopeSenderId isEqualToString:me] || [attach.redEnvelopeReceiverId isEqualToString:me];
    }
  }
  return YES;
}

// 处理新消息响铃和震动
- (void)handleBellsAndVibration:(NSArray <NIMMessage *>*)messages {
  NSMutableArray *theMessages = [NSMutableArray array];
  for (NIMMessage *message in messages) {
    if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
      NIMCustomObject *object = message.messageObject;
      if ([object.attachment isKindOfClass:[XKIMMessageCustomerSerQuestionAttachment class]] &&
          [message.from isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
        // 如果是后台以我的名义代发的客服消息，则过滤
        continue;
      }
      if ([object.attachment isKindOfClass:[XKIMMessageRedEnvelopeTipAttachment class]]) {
        // 如果是红包提示消息，则过滤
        continue;
      }
      if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelNormal) {
        // 密友来消息不震动
        if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneSecret) {
          continue;
        }
        if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneAll || [XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneRespective) {
          if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
            continue;
          }
        }
      }
      else{
        if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneNomal) {
          continue;
        }
      }
      if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesBlackList  && message.session.sessionType == NIMSessionTypeP2P) {
        continue;
      }
      if ([XKSecretFrientManager secretSessionIsSilence:message.session] && [XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret) {
        continue;
      }
      
      
      // 可友免打扰后不提醒
      if (message.session.sessionType == NIMSessionTypeP2P && [XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelNormal) {
        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:message.session.sessionId];
        if (!user.notifyForNewMsg) {
          continue;
        }
      }else if (message.session.sessionType == NIMSessionTypeTeam){
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:message.session.sessionId];
        if (team.notifyStateForNewMsg != NIMTeamNotifyStateAll) {
          continue;
        }
      }else{
        
      }
      [theMessages addObject:message];
    }
  }
  if (theMessages.count) {
    [XKPushSysConfig pushSysConfig];
  }
}
// 处理新消息全局弹窗
- (void)handleGlobalNotification:(NSArray<NIMMessage *> *)messages {
  for (NIMMessage *message in messages) {
    if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
      NIMCustomObject *object = message.messageObject;
      if ([object.attachment isKindOfClass:[XKIMMessageRedEnvelopeAttachment class]]) {
        XKLittleVideoRedEnvelopeNotificationModel *redEnvelopeNotification = [[XKLittleVideoRedEnvelopeNotificationModel alloc] init];
        redEnvelopeNotification.idStr = @"idStr";
        redEnvelopeNotification.redEnvelopeId = @"redEnvelopeId";
        redEnvelopeNotification.videoId = @"videoId";
        redEnvelopeNotification.senderId = @"senderId";
        redEnvelopeNotification.senderName = @"某某某";
        redEnvelopeNotification.senderAvatar = @"";
        // 红包
        [[XKGlobalNotificationManager sharedManager] addLittleVideoRedEnvelopeNotificationView:redEnvelopeNotification checkBlock:^{
          NSLog(@"查看详情点击事件");
          XKMineRedEnvelopeRecordsViewController *vc = [[XKMineRedEnvelopeRecordsViewController alloc] init];
          [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
        }];
      }
      if ([object.attachment isKindOfClass:[XKIMMessageGiftAttachment class]]) {
        XKLittleVideoGiftNotificationModel *giftNotification = [[XKLittleVideoGiftNotificationModel alloc] init];
        giftNotification.idStr = @"idStr";
        giftNotification.giftId = @"giftId";
        giftNotification.giftType = 1;
        giftNotification.giftName = @"飞机";
        giftNotification.giftImg = @"";
        giftNotification.giftNum = 100;
        giftNotification.videoId = @"videoId";
        giftNotification.senderId = @"senderId";
        giftNotification.senderName = @"某某某";
        giftNotification.senderAvatar = @"";
        // 礼物
        [[XKGlobalNotificationManager sharedManager] addLittleVideoGiftNotificationView:giftNotification checkBlock:^{
          NSLog(@"查看详情点击事件");
          XKMyGiftRootController *vc = [[XKMyGiftRootController alloc] init];
          [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
        }];
      }
    }
  }
}

// 处理密友新消息
-(void)handleSecretNewMessages:(NSArray<NIMMessage *> *)messages{
  for (NIMMessage *message in messages) {
    if (message.session.sessionType == NIMSessionTypeP2P) {
      //密友透传
      [[XKSecretTipMsgManager shareManager]dealOutsideMessage:message];
      
      if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneSecret)
      {
        [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
      }
      else if([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneAll){
        
        [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
      }
      else if([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneRespective && [XKSecretFrientManager messageIsFromSecretFriend:message]){
        
        [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
        
      }
      else{
        
      }
    }
    else{
      
    }
  }
}

//云信登陆失败
- (void)onAutoLoginFailed:(NSError *)error{
  NSLog(@"NIM登陆失败");
  [XKHudView hideAllHud];
  [XKLoginConfig loginDropOutConfig];
  [XKAlertView showCommonAlertViewWithTitle:@"账号登陆过期" block:^{
    
  }];
}

//云信被踢
- (void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType{
  NSLog(@"NIM被踢");
  [XKHudView hideAllHud];
  [XKLoginConfig loginDropOutConfig];
  [XKAlertView showCommonAlertViewWithTitle:@"账号登陆过期" block:^{
    
  }];
}
//云信被踢

-(void)deallocIM{
  [[XKIMMessageManager shareManager] dellocManager];
  [[NIMSDK sharedSDK].chatManager removeDelegate:self];
  [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
  
  //云信登陆代理 监控被踢或链接失败
  [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}
@end
