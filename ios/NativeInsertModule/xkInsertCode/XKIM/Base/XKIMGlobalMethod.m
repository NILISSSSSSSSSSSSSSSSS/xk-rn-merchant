//
//  XKIMGlobalMethod.m
//  IMTest
//
//  Created by william on 2018/8/21.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMGlobalMethod.h"
#import <NIMSDK/NIMSDK.h>
#import "XKUserInfo.h"
#import "XKCustomerSerRootViewController.h"
#import "XKUploadManager.h"
#import "XKTransformHelper.h"
#import "XKCustomerSerSecondaryListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XKP2PChatViewController.h"
#import "XKCollectGoodsModel.h"
#import "XKCollectShopModel.h"
#import "XKCollectGamesModel.h"
#import "XKVideoDisplayModel.h"
#import "XKCollectWelfareModel.h"
#import "XKSecretDataSingleton.h"
#import "XKSecretFrientManager.h"
#import "XKRelationUserCacheManager.h"
#import "XKSecretMessageFireManager.h"
#import "XKIM.h"
@interface XKIMGlobalMethod()<NIMLoginManagerDelegate>

@end
@implementation XKIMGlobalMethod

+(void)IMLoginWithAccount:(NSString *)account andToken:(NSString *)token error:(void (^)(NSError *))returnError{
  [[[NIMSDK sharedSDK] loginManager] login:account
                                     token:token
                                completion:^(NSError *error) {
                                  NSLog(@"");
                                  returnError(error);
                                }];
}

+(void)IMAutoLogin{
  NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
  loginData.account = [XKUserInfo getCurrentIMUserID];
  loginData.token = [XKUserInfo getCurrentIMUserToken];
  
  [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
}

+(NSArray *)getLatestMessageListArray{
  NSMutableArray *arr = [NSMutableArray array];
  NSArray *recentSessions = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
  if (recentSessions.count > 0) {
    arr = [NSMutableArray arrayWithArray:recentSessions];
  }
  return [NSArray arrayWithArray:arr];
}

+(NSArray *)getLatestP2PChatListArray{
  NSMutableArray *arr = [NSMutableArray array];
  NSArray *recentSessions = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
  for (NIMRecentSession *recentSession in recentSessions) {
    //排除系统消息
    if ([recentSession.session.sessionId containsString:@"system_"]) {
      continue;
    }
    if (recentSession.session.sessionType == NIMSessionTypeP2P) {
      [arr addObject: recentSession];
    }
  }
  return arr;
}

+(NSArray *)getLatestGroupChatListArray{
  NSMutableArray *arr = [NSMutableArray array];
  NSArray *recentSessions = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
  for (NIMRecentSession *recentSession in recentSessions) {
    if (recentSession.session.sessionType == NIMSessionTypeTeam){
      NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recentSession.session.sessionId];
      if (![XKIMGlobalMethod isCutomerServerSession:team]) {
        [arr addObject:recentSession];
      }
    }
  }
  return arr;
}


+(NSArray *)getLatestServerChatListArray{
  NSMutableArray *arr = [NSMutableArray array];
  NSArray *recentSessions = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
  for (NIMRecentSession *recentSession in recentSessions) {
    if (recentSession.session.sessionType == NIMSessionTypeTeam){
      NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recentSession.session.sessionId];
      if ([XKIMGlobalMethod isCutomerServerSession:team]) {
        [arr addObject:recentSession];
      }
    }
  }
  return arr;
}


+(NSArray *)getLatestSysChatListArray{
  NSMutableArray *arr = [NSMutableArray array];
  NSArray *recentSessions = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
  for (NIMRecentSession *recentSession in recentSessions) {
    //排除系统消息
    if ([recentSession.session.sessionId hasPrefix:@"system_"]) {//zb_system_100_xitongxiaoxi
      [arr addObject: recentSession];
    }
  }
  return arr;
}



- (void)onLogin:(NIMLoginStep)step{
  NSLog(@"%ld",(long)step);
}

#pragma mark - 发送消息

+(void)sendImagesMessage:(NSArray <UIImage *>*)imageArr session:(NIMSession *)session{
  if (imageArr.count > 0) {
    for (UIImage *image in imageArr) {
      XKIMMessageNomalImageAttachment *attachment = [[XKIMMessageNomalImageAttachment alloc]init];
      NIMCustomObject *object = [[NIMCustomObject alloc]init];
      NIMMessage *message = [[NIMMessage alloc] init];
      
      
      NSData * imageData = UIImageJPEGRepresentation(image,0.5);
      NSInteger length = [imageData length]/1024;
      
      attachment.imgSize = [NSString stringWithFormat:@"%tu",length];
      attachment.imgWidth = [NSString stringWithFormat:@"%f",image.size.width];
      attachment.imgHeight = [NSString stringWithFormat:@"%f",image.size.height];
      attachment.imgName = [NSString stringWithFormat:@"XKIM_ImageMessage_%@",[XKTimeSeparateHelper backTimestampSecondStringWithDate:[NSDate date]]];
      
      [XKHudView showLoadingTo:KEY_WINDOW animated:YES];
      
      [[XKUploadManager shareManager]uploadImage:image withKey:@"XKIM_ImageMessage" progress:nil success:^(NSString *url) {
        attachment.imgUrl = kQNPrefix(url);
        object.attachment = attachment;
        message.messageObject = object;
        NSError *error = nil;
        // 发送消息
        error = [self sendMessage:message session:session error:error];
        if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
          [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
        }
        [XKHudView hideHUDForView:KEY_WINDOW];
      } failure:^(id data) {
        [XKHudView hideHUDForView:KEY_WINDOW];
        [XKHudView showErrorMessage:@"图片发送失败"];
      }];
      
    }
  }
}

+(void)sendTextMessage:(NSString *)messageStr session:(NIMSession *)session{
  XKIMMessageNomalTextAttachment *attachment = [[XKIMMessageNomalTextAttachment alloc] init];
  attachment.msgContent = messageStr;
  NIMCustomObject *object = [[NIMCustomObject alloc] init];
  object.attachment = attachment;
  
  // 构造出具体消息并注入附件
  NIMMessage *message = [[NIMMessage alloc] init];
  message.messageObject = object;
  
  // 错误反馈对象
  NSError *error = nil;
  // 发送消息
  error = [self sendMessage:message session:session error:error];
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
    [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
  }
  //同意好友消息本地删除
  if ([messageStr isEqualToString:@"我通过了你的好友验证，现在我们可以聊天了。"]) {
    [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
  }
}

+(void)sendAudioMessage:(NSString *)pathStr session:(NIMSession *)sessioin{
  NSData *audioData= [NSData dataWithContentsOfFile:pathStr];
  double length = [audioData length] / 1024.0;
  
  AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:pathStr] options:nil];
  CMTime audioDuration = audioAsset.duration;
  float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
  
  if (audioDurationSeconds < 1.0) {
    [XKHudView showErrorMessage:@"说话时间太短"];
    return;
  }
  
  if ((audioDurationSeconds - (NSUInteger)(audioDurationSeconds)) > 0.0) {
    audioDurationSeconds = (NSUInteger)(audioDurationSeconds) + 1;
  }
  
  [[XKUploadManager shareManager] uploadData:audioData WithKey:@"XKIM_audioMessage.aac" Progress:^(CGFloat progress) {
    
  } Success:^(NSString *key, NSString *hash) {
    NSString *urlString = kQNPrefix(key);
    
    XKIMMessageAudioAttachment *attachment = [[XKIMMessageAudioAttachment alloc]init];
    NIMCustomObject *object = [[NIMCustomObject alloc]init];
    NIMMessage *message = [[NIMMessage alloc] init];
    
    attachment.voiceSize = length;
    attachment.voiceUrl = urlString;
    attachment.voiceTime = audioDurationSeconds * 1000;
    
    object.attachment = attachment;
    message.messageObject = object;
    NSError *error = nil;
    error = [self sendMessage:message session:sessioin error:error];
    if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
      [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
    }
  } Failure:^(NSString *error) {
    NSLog(@"");
  }];
}

+(void)sendVideoMessage:(XKIMMessageNomalVideoAttachment *)attachment session:(NIMSession *)session{
  NIMCustomObject *object    = [[NIMCustomObject alloc] init];
  object.attachment = attachment;
  
  NIMMessage *message = [[NIMMessage alloc] init];
  message.messageObject = object;
  
  NSError *error = nil;
  // 发送消息
  error = [self sendMessage:message session:session error:error];
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
    [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
  }
}

+(void)sendFriendCard:(XKIMMessageFirendCardAttachment *)attachment session:(NIMSession *)session{
  NIMCustomObject *object    = [[NIMCustomObject alloc] init];
  object.attachment = attachment;
  
  NIMMessage *message = [[NIMMessage alloc] init];
  message.messageObject = object;
  
  NSError *error = nil;
  // 发送消息
  error = [self sendMessage:message session:session error:error];
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
    [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
  }
}

+(void)createP2PChatWithNIMID:(NSString *)NIMIDString{
  NIMSession *session = [NIMSession session:NIMIDString type:NIMSessionTypeP2P];
  XKP2PChatViewController *vc = [[XKP2PChatViewController alloc] initWithSession:session];
  [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

+(void)createCustomerSerChatWithName:(NSString *)serName imageUrl:(NSString *)imageUrl shopID:(NSString *)shopID{
  NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc]init];
  option.name = serName;
  option.avatarUrl = imageUrl;
  option.type = NIMTeamTypeAdvanced;
  option.intro = shopID ? @"4":@"3";
  NSString *myUserID = [XKUserInfo getCurrentIMUserID];
  NSDictionary *param = @{
                          @"userId":myUserID,
                          @"shopId":shopID?shopID:@""
                          };
  [HTTPClient postEncryptRequestWithURLString:@"im/ua/customerServiceTid/1.0" timeoutInterval:10 parameters:param success:^(id responseObject) {
    NSDictionary *dict = [XKTransformHelper dictByJsonString:responseObject];
    if ([dict[@"tid"] isEqual:[NSNull null]]) {
      NSLog(@"");
      [[NIMSDK sharedSDK].teamManager createTeam:option users:@[myUserID] completion:^(NSError * _Nullable error, NSString * _Nullable teamId, NSArray<NSString *> * _Nullable failedUserIds) {
        if (error) {
          NSLog(@"创建客服聊天失败");
          
        }
        else{
          NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
          XKCustomerSerRootViewController *vc = [[XKCustomerSerRootViewController alloc] initWithSession:session];
          [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
        }
      }];
    }
    else{
      NSLog(@"");
      NSString *tid = dict[@"tid"];
      NIMSession *session = [NIMSession session:tid type:NIMSessionTypeTeam];
      XKCustomerSerRootViewController *vc = [[XKCustomerSerRootViewController alloc] initWithSession:session];
      [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
  } failure:^(XKHttpErrror *error) {
    [XKHudView showErrorMessage:@"请检查网络情况"];
  }];
  
  
}

+(void)gotoCustomerSerChatList{
  XKCustomerSerSecondaryListViewController *vc = [[XKCustomerSerSecondaryListViewController alloc]init];
  [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

+(BOOL)isCutomerServerSession:(NIMTeam *)team{
  if (team.intro && ([team.intro isEqualToString:@"3"] || [team.intro isEqualToString:@"4"])) {
    return YES;
  }
  else
  {
    return NO;
  }
}

+(void)sendLittleVideo:(XKIMMessageLittleVideoAttachment *)attachment session:(NIMSession *)session{
  NIMCustomObject *object    = [[NIMCustomObject alloc] init];
  object.attachment = attachment;
  NIMMessage *message = [[NIMMessage alloc] init];
  message.messageObject = object;
  NSError *error = nil;
  
  // 发送消息
  error = [self sendMessage:message session:session error:error];
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
    [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
  }
}

+(void)sendShareWithShareArray:(NSArray *)shareArray session:(NIMSession *)session{
  for (id idModel in shareArray) {
    // 商品
    if ([[idModel class] isEqual:[XKCollectGoodsDataItem class]]) {
      XKIMMessageShareGoodsAttachment *attachment = [[XKIMMessageShareGoodsAttachment alloc]init];
      XKCollectGoodsDataItem *item = idModel;
      attachment.commodityType = 1;
      attachment.commodityId = item.target.targetId;
      attachment.goodsTypeId = nil;
      attachment.commodityIconUrl = item.target.showPics;
      attachment.commodityName = item.target.name;
      attachment.commoditySpecification = item.target.showSkuName;
      attachment.commoditySalesVolume = item.target.mouthVolume;
      attachment.commodityPrice = [item.target.buyPrice integerValue];
      attachment.messageSourceName = @"我的收藏";
      
      NIMCustomObject *object = [[NIMCustomObject alloc] init];
      object.attachment = attachment;
      
      NIMMessage *message = [[NIMMessage alloc] init];
      message.messageObject = object;
      
      NSError *error = nil;
      
      error = [self sendMessage:message session:session error:error];
      if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
        [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
      }
    }
    // 店铺
    if ([idModel isKindOfClass:[XKCollectShopModelDataItem class]]) {
      XKCollectShopModelDataItem *item = (XKCollectShopModelDataItem *)idModel;
      
      XKIMMessageShareShopAttachment *attachment = [[XKIMMessageShareShopAttachment alloc] init];
      attachment.storeId = item.target.targetId;
      attachment.storeName = item.target.name;
      attachment.storeIconUrl = item.target.showPics;
      // TODO: 添加新字段
      attachment.storeDescription = @"店铺描述";
      attachment.storeScore = item.target.starLevel;
      attachment.storeLongitude = [item.target.lng doubleValue];
      attachment.storeLatitude = [item.target.lat doubleValue];
      attachment.storeSalesVolume = item.target.mouthCount;
      attachment.messageSourceName = @"我的收藏";
      
      NIMCustomObject *object = [[NIMCustomObject alloc] init];
      object.attachment = attachment;
      
      NIMMessage *message = [[NIMMessage alloc] init];
      message.messageObject = object;
      
      NSError *error = nil;
      
      error = [self sendMessage:message session:session error:error];
      if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
        [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
      }
    }
    // 游戏
    if ([idModel isKindOfClass:[XKCollectGamesModelDataItem class]]) {
      XKCollectGamesModelDataItem *item = (XKCollectGamesModelDataItem *)idModel;
      
      XKIMMessageShareGameAttachment *attachment = [[XKIMMessageShareGameAttachment alloc] init];
      attachment.gameId = item.target.targetId;
      attachment.gameRecommendCode = @"";
      attachment.gameIconUrl = item.target.showPics;
      attachment.gameName = item.target.name;
      attachment.gameScore = item.target.popularity;
      attachment.gameDescription = item.target.describe;
      // TODO: 游戏url
      attachment.gameUrl = @"";
      attachment.messageSourceName = @"我的收藏";
      
      NIMCustomObject *object = [[NIMCustomObject alloc] init];
      object.attachment = attachment;
      
      NIMMessage *message = [[NIMMessage alloc] init];
      message.messageObject = object;
      
      NSError *error = nil;
      
      error = [self sendMessage:message session:session error:error];
      if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
        [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
      }
    }
    // 小视频
    if ([idModel isKindOfClass:[XKVideoDisplayVideoListItemModel class]]) {
      XKVideoDisplayVideoListItemModel *item = (XKVideoDisplayVideoListItemModel *)idModel;
      
      XKIMMessageShareLittleVideoAttachment *attachment = [[XKIMMessageShareLittleVideoAttachment alloc] init];
      attachment.videoId = [NSString stringWithFormat:@"%tu", item.video.video_id];
      attachment.videoIconUrl = item.video.zdy_cover && item.video.zdy_cover.length ? item.video.zdy_cover : item.video.first_cover;
      attachment.videoAuthorAvatarUrl = item.user.user_img;
      attachment.videoAuthorName = item.user.user_name;
      attachment.videoDescription = item.video.describe;
      attachment.messageSourceName = @"我的收藏";
      
      NIMCustomObject *object = [[NIMCustomObject alloc] init];
      object.attachment = attachment;
      
      NIMMessage *message = [[NIMMessage alloc] init];
      message.messageObject = object;
      
      NSError *error = nil;
      
      error = [self sendMessage:message session:session error:error];
      if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
        [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
      }
    }
    // 福利
    if ([idModel isKindOfClass:[XKCollectWelfareDataItem class]]) {
      XKCollectWelfareDataItem *item = (XKCollectWelfareDataItem *)idModel;
      
      XKIMMessageShareWelfareAttachment *attachment = [[XKIMMessageShareWelfareAttachment alloc] init];
      attachment.welfareId = item.ID;
      attachment.sequenceId = item.target.sequenceId;
      attachment.goodsId = item.target.targetId;
      attachment.orderId = @"";
      attachment.welfareIconUrl = item.target.showPics;
      attachment.welfareName = item.target.name;
      attachment.welfareDescription = item.target.showAttr;
      attachment.welfarePrice = item.target.perPrice;
      attachment.messageSourceName = @"我的收藏";
      attachment.lotteryIsOpened = NO;
      attachment.messageSenderIsWinner = NO;
      
      NIMCustomObject *object = [[NIMCustomObject alloc] init];
      object.attachment = attachment;
      
      NIMMessage *message = [[NIMMessage alloc] init];
      message.messageObject = object;
      
      NSError *error = nil;
      
      error = [self sendMessage:message session:session error:error];
      if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
        [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
      }
    }
  }
}

+ (void)sendCollectItem:(XKIMMessageBaseAttachment *)collectItem session:(NIMSession *)session {
  if (![collectItem isKindOfClass:[XKIMMessageShareGoodsAttachment class]] &&
      ![collectItem isKindOfClass:[XKIMMessageShareShopAttachment class]] &&
      ![collectItem isKindOfClass:[XKIMMessageShareGameAttachment class]] &&
      ![collectItem isKindOfClass:[XKIMMessageShareLittleVideoAttachment class]] &&
      ![collectItem isKindOfClass:[XKIMMessageShareWelfareAttachment class]]) {
    [XKHudView showErrorMessage:@"参数错误"];
    return;
  }
  NIMCustomObject *object = [[NIMCustomObject alloc] init];
  object.attachment = collectItem;
  NIMMessage *message = [[NIMMessage alloc] init];
  message.messageObject = object;
  NSError *error = nil;
  error = [self sendMessage:message session:session error:error];
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
    [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
  }
}

+ (void)sendGift:(XKIMMessageGiftAttachment *)attachment session:(NIMSession *)session {
  NIMCustomObject *object    = [[NIMCustomObject alloc] init];
  object.attachment = attachment;
  NIMMessage *message = [[NIMMessage alloc] init];
  message.messageObject = object;
  NSError *error = nil;
  // 礼物
  error = [self sendMessage:message session:session error:error];
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
    [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
  }
}

+ (void)sendRedEnvelope:(XKIMMessageRedEnvelopeAttachment *)attachment session:(NIMSession *)session {
  NIMCustomObject *object    = [[NIMCustomObject alloc] init];
  object.attachment = attachment;
  NIMMessage *message = [[NIMMessage alloc] init];
  message.messageObject = object;
  NSError *error = nil;
  // 红包
  error = [self sendMessage:message session:session error:error];
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
    [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
  }
}

+ (void)sendRedEnvelopeTip:(XKIMMessageRedEnvelopeTipAttachment *) attachment session:(NIMSession *)session {
  NIMCustomObject *object    = [[NIMCustomObject alloc] init];
  object.attachment = attachment;
  NIMMessage *message = [[NIMMessage alloc] init];
  message.messageObject = object;
  NSError *error = nil;
  // 红包提示消息
  error = [self sendMessage:message session:session error:error];
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
    [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
  }
}

+ (void)sendCardCoupon:(XKIMMessageBaseAttachment *)cardCoupon session:(NIMSession *)session {
  if (![cardCoupon isKindOfClass:[XKIMMessageCardAttachment class]] &&
      ![cardCoupon isKindOfClass:[XKIMMessageCouponAttachment class]] ) {
    [XKHudView showErrorMessage:@"参数错误"];
    return;
  }
  NIMCustomObject *object = [[NIMCustomObject alloc] init];
  object.attachment = cardCoupon;
  NIMMessage *message = [[NIMMessage alloc] init];
  message.messageObject = object;
  NSError *error = nil;
  error = [self sendMessage:message session:session error:error];
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
    [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
  }
}

+ (void)sendMusic:(XKIMMessageMusicAttachment *)music session:(NIMSession *)session {
  if (![music isKindOfClass:[XKIMMessageMusicAttachment class]]) {
    [XKHudView showErrorMessage:@"参数错误"];
    return;
  }
  NIMCustomObject *object = [[NIMCustomObject alloc] init];
  object.attachment = music;
  NIMMessage *message = [[NIMMessage alloc] init];
  message.messageObject = object;
  NSError *error = nil;
  error = [self sendMessage:message session:session error:error];
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
    [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
  }
}

+ (void)sendOrder:(XKIMMessageCustomerSerOrderAttachment *)order session:(NIMSession *)session {
  if (![order isKindOfClass:[XKIMMessageCustomerSerOrderAttachment class]]) {
    [XKHudView showErrorMessage:@"参数错误"];
    return;
  }
  NIMCustomObject *object = [[NIMCustomObject alloc] init];
  object.attachment = order;
  NIMMessage *message = [[NIMMessage alloc] init];
  message.messageObject = object;
  NSError *error = nil;
  error = [self sendMessage:message session:session error:error];
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
    [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
  }
}

+ (void)sendGrandPrize:(XKIMMessageBaseAttachment *)grandPrize session:(NIMSession *)session {
  if (![grandPrize isKindOfClass:[XKIMMessagePlatformGrandPrizeAttachment class]] &&
      ![grandPrize isKindOfClass:[XKIMMessageShopGrandPrizeAttachment class]] ) {
    [XKHudView showErrorMessage:@"参数错误"];
    return;
  }
  NIMCustomObject *object = [[NIMCustomObject alloc] init];
  object.attachment = grandPrize;
  NIMMessage *message = [[NIMMessage alloc] init];
  message.messageObject = object;
  NSError *error = nil;
  error = [self sendMessage:message session:session error:error];
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
    [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
  }
}

+ (void)sendNews:(XKIMMessageNewsAttachment *)news session:(NIMSession *)session {
  if (![news isKindOfClass:[XKIMMessageNewsAttachment class]] ) {
    [XKHudView showErrorMessage:@"参数错误"];
    return;
  }
  NIMCustomObject *object = [[NIMCustomObject alloc] init];
  object.attachment = news;
  NIMMessage *message = [[NIMMessage alloc] init];
  message.messageObject = object;
  NSError *error = nil;
  error = [self sendMessage:message session:session error:error];
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret && !error) {
    [XKSecretFrientManager saveLastMessageInDBWithMessage:message];
  }
}

+ (NIMMessage *)getLastMessageWithSessionID:(NSString *)sessionID sessionType:(NIMSessionType)sessionType{
  NIMRecentSession *recentSession = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:[NIMSession session:sessionID type:sessionType]];
  return recentSession.lastMessage;
}

+ (BOOL)resendMessage:(NIMMessage *)message{
  NIMMessage *newMessage = [[NIMMessage alloc]init];
  newMessage.messageObject = message.messageObject;
  NSError *error = nil;
  error = [self resendMessage:message session:message.session error:error];
  if (error) {
    return NO;
  }
  else{
    return YES;
  }
}

+(void)searchAllTextMessageWithKeyWord:(NSString *)keyWord complete:(void(^)(NSArray <NIMMessage *>*messages))complete{
  NSMutableArray *resultArr = [NSMutableArray array];
  if (keyWord.length > 0) {
    NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
    option.limit = 0;
    option.order = NIMMessageSearchOrderDesc;
    option.messageTypes = @[@(NIMMessageTypeCustom)];
    [[NIMSDK sharedSDK].conversationManager searchAllMessages:option result:^(NSError * _Nullable error, NSDictionary<NIMSession *,NSArray<NIMMessage *> *> * _Nullable messages){
      NSLog(@"");
      NSMutableArray *messageArr = [NSMutableArray array];
      for (NIMSession *session in messages) {
        [messageArr addObjectsFromArray:messages[session]];
      }
      
      for (NIMMessage *message in messageArr) {
        if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
          NIMCustomObject *obj = message.messageObject;
          if ([obj.attachment isKindOfClass:[XKIMMessageNomalTextAttachment class]]) {
            XKIMMessageNomalTextAttachment *attachment = obj.attachment;
            if ([attachment.msgContent containsString:keyWord]) {
              [resultArr addObject:message];
            }
          }
        }
      }
      complete([NSArray arrayWithArray:resultArr]);
    }];
  }
  else{
    complete([NSArray arrayWithArray:resultArr]);
  }
}


/**
 查询包含关键字的所有可友聊天记录
 
 @param keyWord 关键字
 @param complete 完成回调
 */
+(void)searchAllKeFriendTextMessageWithKeyWord:(NSString *)keyWord complete:(void(^)(NSArray <NIMMessage *>*messages))complete{
  NSMutableArray *resultArr = [NSMutableArray array];
  if (keyWord.length > 0) {
    NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
    option.limit = 0;
    option.order = NIMMessageSearchOrderDesc;
    option.messageTypes = @[@(NIMMessageTypeCustom)];
    [[NIMSDK sharedSDK].conversationManager searchAllMessages:option result:^(NSError * _Nullable error, NSDictionary<NIMSession *,NSArray<NIMMessage *> *> * _Nullable messages){
      NSLog(@"");
      NSMutableArray *messageArr = [NSMutableArray array];
      for (NIMSession *session in messages) {
        [messageArr addObjectsFromArray:messages[session]];
      }
      
      for (NIMMessage *message in messageArr) {
        if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
          NIMCustomObject *obj = message.messageObject;
          if ([obj.attachment isKindOfClass:[XKIMMessageNomalTextAttachment class]]) {
            XKIMMessageNomalTextAttachment *attachment = obj.attachment;
            if ([attachment.msgContent containsString:keyWord]) {
              if (message.isOutgoingMsg) {
                if (![XKSecretFrientManager messageIsFromSecretFriend:message]) {
                  [resultArr addObject:message];
                }
              } else {
                if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneNomal || [XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneAll) {
                  [resultArr addObject:message];
                } else if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneRespective){
                  if (![XKSecretFrientManager messageIsFromSecretFriend:message]) {
                    [resultArr addObject:message];
                  }
                } else {
                  
                }
              }
            }
          }
        }
      }
      complete([NSArray arrayWithArray:resultArr]);
    }];
  }
  else{
    complete([NSArray arrayWithArray:resultArr]);
  }
}

/**
 查询包含关键字的所有密友聊天记录
 
 @param keyWord 关键字
 @param complete 完成回调
 */
+(void)searchAllSecretFriendTextMessageWithKeyWord:(NSString *)keyWord complete:(void(^)(NSArray <NIMMessage *>*messages))complete{
  NSMutableArray *resultArr = [NSMutableArray array];
  if (keyWord.length > 0) {
    NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
    option.limit = 0;
    option.order = NIMMessageSearchOrderDesc;
    option.messageTypes = @[@(NIMMessageTypeCustom)];
    [[NIMSDK sharedSDK].conversationManager searchAllMessages:option result:^(NSError * _Nullable error, NSDictionary<NIMSession *,NSArray<NIMMessage *> *> * _Nullable messages){
      NSLog(@"");
      NSMutableArray *messageArr = [NSMutableArray array];
      for (NIMSession *session in messages) {
        [messageArr addObjectsFromArray:messages[session]];
      }
      
      for (NIMMessage *message in messageArr) {
        if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
          NIMCustomObject *obj = message.messageObject;
          if ([obj.attachment isKindOfClass:[XKIMMessageNomalTextAttachment class]]) {
            XKIMMessageNomalTextAttachment *attachment = obj.attachment;
            if ([attachment.msgContent containsString:keyWord]) {
              if (message.isOutgoingMsg) {
                if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
                  [resultArr addObject:message];
                }
              } else {
                if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneSecret || [XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneAll) {
                  [resultArr addObject:message];
                } else if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneRespective){
                  if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
                    [resultArr addObject:message];
                  }
                } else {
                  
                }
              }
            }
          }
        }
      }
      complete([NSArray arrayWithArray:resultArr]);
    }];
  }
  else{
    complete([NSArray arrayWithArray:resultArr]);
  }
}


+(NSError *)sendMessage:(NIMMessage *)message session:(NIMSession *)session error:(NSError*)error{
  
  if (session.sessionType == NIMSessionTypeP2P) {
    // 非好友关系处理
    XKContactModel *model = [XKRelationUserCacheManager queryContactWithUserId:session.sessionId];
    if (model.friendRelation == XKRelationNoting && model.secretRelation == XKRelationNoting) {
      [XKAlertView showCommonAlertViewWithTitle:@"对方已不是你的好友,请重新添加!" block:^{
        [[self getCurrentUIVC].navigationController popViewControllerAnimated:YES];
      }];
      error = [[NSError alloc] init];
      return error;
    }
    // 黑名单处理
    if (model.isFriendBlackList) {
      [XKAlertView showCommonAlertViewWithTitle:@"您已被对方拉黑，无法发送消息!" block:^{
        [[self getCurrentUIVC].navigationController popViewControllerAnimated:YES];
      }];
      error = [[NSError alloc] init];
      return error;
    }
    
    [self setSecretFriendMessage:message session:session];
  }
  
  // 消息推送设置
  XKContactModel *receiver = [XKRelationUserCacheManager queryContactWithUserId:session.sessionId];
  NIMMessageSetting *setting = [NIMMessageSetting new];
  message.setting = setting;
  if (!receiver.friendSecretId) {
    // 我未在对方密友圈，即我不是对方的密友，我是对方可友，对方绝对在可友接收 带推送
    message.setting.apnsEnabled = YES;
  } else {
    // 我在对方密友圈
    if (receiver.friendRelation == XKRelationTwoWay &&
        receiver.secretRelation == XKRelationTwoWay) {
      // 我和对方互为可密友：我在密友发 对方在密友收；我在可友发，对方在可友收；可友收时带推送。
      if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret) {
        // 从密友圈发送消息
        message.setting.apnsEnabled = NO;
      } else {
        message.setting.apnsEnabled = YES;
      }
    } else {
      // 除上面的其他情况，对方都在密友圈收，都不会收到推送。
      message.setting.apnsEnabled = NO;
    }
  }
  
  [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
  return error;
}

+(NSError *)resendMessage:(NIMMessage *)message session:(NIMSession *)session error:(NSError*)error{
  return [self sendMessage:message session:session error:error];
}

// 自己 0 1 0 1
// 对方 0 0 1 1
// ———————————
// 结果 0 1 2 3 fireStatus
// 密友消息设置
+ (void)setSecretFriendMessage:(NIMMessage *)message session:(NIMSession *)session {
  if (!message ||
      !session) {
    return;
  }
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret) {
    NIMCustomObject *obj;
    XKIMMessageBaseAttachment *attachment;
    if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
      obj = message.messageObject;
      if ([obj.attachment isKindOfClass:[XKIMMessageBaseAttachment class]]) {
        attachment = (XKIMMessageBaseAttachment *)obj.attachment;
      }
    }
    attachment.group = 2;
    
    NSArray *mySelfArray;
    NSArray *otherArray;
    if ([[XKDataBase instance] existsTable:XKIMSecretMessageFireMyselfDataBaseTable]) {
      NSString *jsonString = [[XKDataBase instance] select:XKIMSecretMessageFireMyselfDataBaseTable key:[XKUserInfo getCurrentUserId]];
      mySelfArray = [XKTransformHelper jsonStringToArr:jsonString];
    }
    if ([[XKDataBase instance] existsTable:XKIMSecretMessageFireOtherDataBaseTable]) {
      NSString *jsonString = [[XKDataBase instance] select:XKIMSecretMessageFireOtherDataBaseTable key:[XKUserInfo getCurrentUserId]];
      otherArray = [XKTransformHelper jsonStringToArr:jsonString];
    }
    if (![mySelfArray containsObject:session.sessionId] &&
        ![otherArray containsObject:session.sessionId]) {
      // 未设置任何阅后即焚 都不删除
      attachment.fireStatus = 0;
    } else if ([mySelfArray containsObject:session.sessionId] &&
               ![otherArray containsObject:session.sessionId]) {
      // 自己阅后即焚 发送方删除
      attachment.fireStatus = 1;
      [[XKSecretMessageFireManager sharedManager] addMessageToMyselfFireMessageArr:@[message]];
      message.localExt = @{@"isLocalFire":@"1"};
    } else if (![mySelfArray containsObject:session.sessionId] &&
               [otherArray containsObject:session.sessionId]) {
      // 对方阅后即焚 接收方删除
      attachment.fireStatus = 2;
    } else if ([mySelfArray containsObject:session.sessionId] &&
               [otherArray containsObject:session.sessionId]) {
      // 自己、对方阅后即焚 都删除
      attachment.fireStatus = 3;
      [[XKSecretMessageFireManager sharedManager] addMessageToMyselfFireMessageArr:@[message]];
      message.localExt = @{@"isLocalFire":@"1"};
    }
  }
}

+(void)searchKeFriendMessageWithSession:(NIMSession *)session complete:(void(^)(NSArray <NIMMessage *>*messages))complete{
  NSMutableArray *resultArr = [NSMutableArray array];
  NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
  option.limit = 0;
  option.order = NIMMessageSearchOrderDesc;
  option.messageTypes = @[@(NIMMessageTypeCustom)];
  [[NIMSDK sharedSDK].conversationManager searchMessages:session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
    for (NIMMessage *message in messages) {
      if (message.isOutgoingMsg) {
        if (![XKSecretFrientManager messageIsFromSecretFriend:message]) {
          [resultArr addObject:message];
        }
      }
      else{
        if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneNomal || [XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneAll) {
          [resultArr addObject:message];
        }
        else if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneRespective){
          if (![XKSecretFrientManager messageIsFromSecretFriend:message]) {
            [resultArr addObject:message];
          }
        }else{
          
        }
      }
      if (message.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *object = message.messageObject;
        if ([object.attachment isKindOfClass:[XKIMMessageBaseAttachment class]]) {
          XKIMMessageBaseAttachment *baseAtt = object.attachment;
          if (baseAtt.group == 3 && ![resultArr containsObject:message]) {
            [resultArr addObject: message];
          }
        }
        XKIMMessageBaseAttachment *baseAtt = object.attachment;
        if ([baseAtt isKindOfClass:[XKIMMessageBaseAttachment class]]) {
          if (baseAtt.extraType == XKIMExtraAttachmentSecretTipMsgType) { // 密友提醒和投射消息
            [resultArr addObject: message];
          }
        }
      }
      
    }
    complete([NSArray arrayWithArray:resultArr]);
  }];
}

+(void)deleteAllKeFriendChatHistoryInSession:(NIMSession *)session deleteRecentSession:(BOOL)delete complete:(void(^)(BOOL success))complete {
  NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
  option.limit = 0;
  option.order = NIMMessageSearchOrderDesc;
  option.messageTypes = @[@(NIMMessageTypeNotification), @(NIMMessageTypeTip), @(NIMMessageTypeCustom)];
  [[NIMSDK sharedSDK].conversationManager searchMessages:session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
    for (NIMMessage *message in messages) {
      if (message.messageType == NIMMessageTypeCustom) {
        // 自定义消息按条件删除
        if (message.isOutgoingMsg) {
          if (![XKSecretFrientManager messageIsFromSecretFriend:message]) {
            [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
          }
        }
        else{
          if ([XKIMGlobalMethod isSecretTipMsgType:message]) {
            [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
          } else {
            if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneNomal || [XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneAll) {
              [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
            }
            else if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneRespective){
              if (![XKSecretFrientManager messageIsFromSecretFriend:message]) {
                [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
              }
            }else{
              
            }
          }
        }
      } else {
        // 其他类型消息直接删除
        [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
      }
    }
    if (delete) {
      NIMRecentSession *recentSession = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
      [[NIMSDK sharedSDK].conversationManager deleteRecentSession:recentSession];
    }
    complete(YES);
  }];
}

+(void)cancelNormalTopChatWithUserID:(NSString *)userID{
  if ([[XKDataBase instance]exists:XKIMP2PTopChatDataBaseTable key:[XKUserInfo currentUser].userId]) {
    NSString *jsonString = [[XKDataBase instance]select:XKIMP2PTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
    NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
    NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
    [idMuArr removeObject:userID];
    BOOL success =  [[XKDataBase instance]replace:XKIMP2PTopChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
    NSLog(@"%d",success);
  }
}

+ (BOOL)isSecretTipMsgType:(NIMMessage *)message {
  if (message.messageType == NIMMessageTypeCustom) {
    NIMCustomObject *object = message.messageObject;
    XKIMMessageBaseAttachment *baseAtt = object.attachment;
    if ([baseAtt isKindOfClass:[XKIMMessageBaseAttachment class]]) {
      if (baseAtt.extraType == XKIMExtraAttachmentSecretTipMsgType) {
        return YES;
      }
    }
  }
  return NO;
}

@end
