//
//  XKCustomeSerMessageManager.m
//  XKSquare
//
//  Created by william on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCustomeSerMessageManager.h"
#import "XKIMGlobalMethod.h"
#import "XKTransformHelper.h"
#import "XKIMMessageNomalImageAttachment.h"
#import "XKIMMessageAudioAttachment.h"
#import "XKCustomerSerRootViewController.h"
#import "XKIM.h"
#import "XKIMCustomerState.h"
@implementation XKCustomeSerMessageManager

+(void)createXKCustomerSerChat{
  NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc]init];
  option.type = NIMTeamTypeAdvanced;
  option.intro = @"3";
  NSString *myUserID = [XKUserInfo getCurrentIMUserID];
  NSDictionary *param = @{
                          @"userId":myUserID,
                          @"shopId":@""
                          };
  [HTTPClient postEncryptRequestWithURLString:@"im/ua/customerServiceTid/1.0" timeoutInterval:10 parameters:param success:^(id responseObject) {
    NSDictionary *dict = [XKTransformHelper dictByJsonString:responseObject];
    option.avatarUrl = dict[@"cover"];
    option.name = dict[@"name"];
    
    if ([dict[@"tid"] isEqual:[NSNull null]]) {
      NSLog(@"");
      [[NIMSDK sharedSDK].teamManager createTeam:option users:@[myUserID] completion:^(NSError * _Nullable error, NSString * _Nullable teamId, NSArray<NSString *> * _Nullable failedUserIds) {
        if (error) {
          NSLog(@"创建客服聊天失败");
          
        }
        else{
          NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
          XKCustomerSerRootViewController *vc = [[XKCustomerSerRootViewController alloc] initWithSession:session vcType:XKCustomerSerRootVCTypeUserContactCustomerService];
          [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
        }
      }];
    }
    else{
      NSLog(@"");
      NSString *tid = dict[@"tid"];
      NIMSession *session = [NIMSession session:tid type:NIMSessionTypeTeam];
      XKCustomerSerRootViewController *vc = [[XKCustomerSerRootViewController alloc] initWithSession:session vcType:XKCustomerSerRootVCTypeUserContactCustomerService];
      [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
  } failure:^(XKHttpErrror *error) {
    
  }];
}

+(void)createShopCustomerWithCustomerID:(NSString *)customerID{
  if (!customerID) {
    [XKHudView showErrorMessage:@"创建聊天失败"];
    return;
  }
  NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc]init];
  option.type = NIMTeamTypeAdvanced;
  option.intro = @"4"; // 店铺客服是4
  NSString *myUserID = [XKUserInfo getCurrentIMUserID];
  NSDictionary *param = @{
                          @"userId":myUserID,
                          @"shopId":customerID
                          };
  [HTTPClient postEncryptRequestWithURLString:@"im/ua/customerServiceTid/1.0" timeoutInterval:10 parameters:param success:^(id responseObject) {
    NSDictionary *dict = [XKTransformHelper dictByJsonString:responseObject];
    option.avatarUrl = dict[@"cover"];
    option.name = dict[@"name"];
    
    if ([dict[@"tid"] isEqual:[NSNull null]]) {
      NSLog(@"");
      [[NIMSDK sharedSDK].teamManager createTeam:option users:@[myUserID] completion:^(NSError * _Nullable error, NSString * _Nullable teamId, NSArray<NSString *> * _Nullable failedUserIds) {
        if (error) {
          NSLog(@"创建客服聊天失败");
          
        }
        else{
          NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
          XKCustomerSerRootViewController *vc = [[XKCustomerSerRootViewController alloc] initWithSession:session vcType:XKCustomerSerRootVCTypeUserContactCustomerService];
          vc.shopID = customerID;
          [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
        }
      }];
    }
    else{
      NSLog(@"");
      NSString *tid = dict[@"tid"];
      NIMSession *session = [NIMSession session:tid type:NIMSessionTypeTeam];
      XKCustomerSerRootViewController *vc = [[XKCustomerSerRootViewController alloc] initWithSession:session vcType:XKCustomerSerRootVCTypeUserContactCustomerService];
      [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
  } failure:^(XKHttpErrror *error) {
    
  }];
}

+(void)senSerTestMessageWithMessage:(NSString *)messageStr session:(NIMSession *)session{
  [XKIMGlobalMethod sendTextMessage:messageStr session:session];
  XKIMMessageNomalTextAttachment *attachment = [[XKIMMessageNomalTextAttachment alloc] init];
  attachment.msgContent = messageStr;
  [[NIMSDK sharedSDK].teamManager fetchTeamInfo:session.sessionId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
    if (team.memberNumber == 1 && [XKIMGlobalMethod isCutomerServerSession:team]) {
      NSMutableDictionary *para = [NSMutableDictionary dictionary];
      para[@"group"] = @(0);
      para[@"type"] = [NSNumber numberWithInteger:attachment.type];
      para[@"tid"] = team.teamId;
      para[@"shopId"] = [XKIMCustomerState sharedManager].shopID;
      para[@"data"] = [attachment getEncodeDataDic];
      [HTTPClient postEncryptRequestWithURLString:[XKIMCustomerState sharedManager].shopID.length > 0 ? @"im/ua/mCustomerServiceTaskAdd/1.0" : @"im/ua/xkCustomerServiceTaskAdd/1.0" timeoutInterval:10 parameters:para success:^(id responseObject) {
        NSLog(@"");
      } failure:^(XKHttpErrror *error) {
        NSLog(@"");
      }];
    }
  }];
}

+(void)senSerAudioMessageWithPath:(NSString *)pathString session:(NIMSession *)session{
  NSData *audioData= [NSData dataWithContentsOfFile:pathString];
  double length = [audioData length] / 1024.0;
  
  AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:pathString] options:nil];
  CMTime audioDuration = audioAsset.duration;
  float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
  
  if (audioDurationSeconds < 1.0) {
    [XKHudView showErrorMessage:@"说话时间太短"];
    return;
  }
  
  if ((audioDurationSeconds - (NSUInteger)(audioDurationSeconds)) > 0.0) {
    audioDurationSeconds = (NSUInteger)(audioDurationSeconds) + 1;
  }
  [[XKUploadManager shareManager]uploadData:audioData WithKey:@"XKIM_audioMessage.aac" Progress:^(CGFloat progress) {
    
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
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
    
    if (!error) {
      [[NIMSDK sharedSDK].teamManager fetchTeamInfo:session.sessionId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
        if (team.memberNumber == 1 && [XKIMGlobalMethod isCutomerServerSession:team]) {
          NSMutableDictionary *para = [NSMutableDictionary dictionary];
          para[@"group"] = @(0);
          para[@"type"] = [NSNumber numberWithInteger:attachment.type];
          para[@"tid"] = team.teamId;
          para[@"shopId"] = [XKIMCustomerState sharedManager].shopID;
          para[@"data"] = [attachment getEncodeDataDic];
          [HTTPClient postEncryptRequestWithURLString:[XKIMCustomerState sharedManager].shopID.length > 0 ? @"im/ua/mCustomerServiceTaskAdd/1.0" : @"im/ua/xkCustomerServiceTaskAdd/1.0" timeoutInterval:10 parameters:para success:^(id responseObject) {
            NSLog(@"");
          } failure:^(XKHttpErrror *error) {
            NSLog(@"");
          }];
        }
      }];
    }
    
  } Failure:^(NSString *error) {
    NSLog(@"");
  }];
}

+(void)sendSerOrderMessageWithOrderDictionary:(XKIMMessageCustomerSerOrderAttachment *)orderAttachment session:(NIMSession *)session{
  NIMCustomObject *object    = [[NIMCustomObject alloc] init];
  object.attachment = orderAttachment;
  // 构造出具体消息并注入附件
  NIMMessage *message = [[NIMMessage alloc] init];
  message.messageObject = object;
  // 错误反馈对象
  NSError *error = nil;
  // 发送消息
  [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
  
  if (!error) {
    [[NIMSDK sharedSDK].teamManager fetchTeamInfo:session.sessionId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
      if (team.memberNumber == 1 && [XKIMGlobalMethod isCutomerServerSession:team]) {
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        para[@"group"] = @(0);
        para[@"type"] = [NSNumber numberWithInteger:orderAttachment.type];
        para[@"tid"] = team.teamId;
        para[@"shopId"] = [XKIMCustomerState sharedManager].shopID;
        para[@"data"] = [orderAttachment getEncodeDataDic];
        [HTTPClient postEncryptRequestWithURLString:[XKIMCustomerState sharedManager].shopID.length > 0 ? @"im/ua/mCustomerServiceTaskAdd/1.0" : @"im/ua/xkCustomerServiceTaskAdd/1.0" timeoutInterval:10 parameters:para success:^(id responseObject) {
          NSLog(@"");
        } failure:^(XKHttpErrror *error) {
          NSLog(@"");
        }];
      }
    }];
  }
}

+(void)sendSerImageMessageWithImageArr:(NSArray *)imageArr sessoin:(NIMSession *)session{
  if (imageArr.count > 0) {
    for (UIImage *image in imageArr) {
      XKIMMessageNomalImageAttachment *attachment = [[XKIMMessageNomalImageAttachment alloc] init];
      NIMCustomObject *object = [[NIMCustomObject alloc]init];
      NIMMessage *message = [[NIMMessage alloc] init];
      NSData * imageData = UIImageJPEGRepresentation(image,0.5);
      NSInteger length = [imageData length]/1024;
      attachment.imgSize = [NSString stringWithFormat:@"%tu",length];
      attachment.imgWidth = [NSString stringWithFormat:@"%f",image.size.width];
      attachment.imgHeight = [NSString stringWithFormat:@"%f",image.size.height];
      attachment.imgName = [NSString stringWithFormat:@"XKIM_ImageMessage_%@",[XKTimeSeparateHelper backTimestampSecondStringWithDate:[NSDate date]]];
      [XKHudView showLoadingTo:[self getCurrentUIVC].view animated:YES];
      [[XKUploadManager shareManager]uploadImage:image withKey:@"XKIM_ImageMessage" progress:nil success:^(NSString *url) {
        [XKHudView hideHUDForView:[self getCurrentUIVC].view];
        attachment.imgUrl = kQNPrefix(url);
        object.attachment = attachment;
        message.messageObject = object;
        [self sendImageToUIMWithMessage:message session:session attachment:attachment];
      } failure:^(id data) {
        [XKHudView hideHUDForView:[self getCurrentUIVC].view];
        [XKHudView showErrorMessage:@"图片发送失败"];
      }];
    }
  }
}

+ (void)sendSerVideoMessageWithVideovideoTime:(NSUInteger)videoTime videoUrl:(NSString *)videoUrl firstImg:(UIImage *)firstImg videoWidth:(double)videoWidth videoHeight:(double)videoHeight sessoin:(NIMSession *)session {
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [XKHudView showLoadingMessage:@"视频处理中..." to:KEY_WINDOW animated:YES];
  });
  [[XKUploadManager shareManager] uploadVideoWithUrl:[NSURL URLWithString:videoUrl] FirstImg:firstImg WithKey:@"IMMessage_Video.mp4" Progress:^(CGFloat progress) {
    NSLog(@"%f",progress);
  } Success:^(NSString *videoKey, NSString *imgKey) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [XKHudView hideHUDForView:KEY_WINDOW animated:YES];
    });
    XKIMMessageNomalVideoAttachment *videoAttachment = [[XKIMMessageNomalVideoAttachment alloc] init];
    videoAttachment.videoTime = videoTime;
    videoAttachment.videoUrl = kQNPrefix(videoKey);
    videoAttachment.videoIcon = kQNPrefix(imgKey);
    videoAttachment.videoWidth = [NSString stringWithFormat:@"%.2f", videoWidth];
    videoAttachment.videoHeight = [NSString stringWithFormat:@"%.2f", videoHeight];
    NIMMessage *message = [[NIMMessage alloc] init];
    NIMCustomObject *object = [[NIMCustomObject alloc]init];
    object.attachment = videoAttachment;
    message.messageObject = object;
    [self sendVideoToUIMWithMessage:message session:session attachment:videoAttachment];
    
  } Failure:^(NSString *error) {
    NSLog(@"视频上传失败");
    dispatch_async(dispatch_get_main_queue(), ^{
      [XKHudView hideHUDForView:KEY_WINDOW animated:YES];
      [XKHudView showErrorMessage:@"视频发送失败"];
    });
  }];
}

+(void)sendImageToUIMWithMessage:(NIMMessage *)message session:(NIMSession *)session attachment:(XKIMMessageNomalImageAttachment *)attachment{
  NSError *error = nil;
  // 发送消息
  [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
  [XKHudView hideHUDForView:[self getCurrentUIVC].view];
  if (!error) {
    [[NIMSDK sharedSDK].teamManager fetchTeamInfo:session.sessionId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
      if (team.memberNumber == 1 && [XKIMGlobalMethod isCutomerServerSession:team]) {
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        para[@"group"] = @(0);
        para[@"type"] = [NSNumber numberWithInteger:attachment.type];
        para[@"tid"] = team.teamId;
        para[@"shopId"] = [XKIMCustomerState sharedManager].shopID;
        para[@"data"] = [attachment getEncodeDataDic];
        [HTTPClient postEncryptRequestWithURLString:[XKIMCustomerState sharedManager].shopID.length > 0 ? @"im/ua/mCustomerServiceTaskAdd/1.0" : @"im/ua/xkCustomerServiceTaskAdd/1.0" timeoutInterval:10 parameters:para success:^(id responseObject) {
          NSLog(@"");
        } failure:^(XKHttpErrror *error) {
          NSLog(@"");
        }];
      }
    }];
  }
  else{
    [XKHudView hideHUDForView:[self getCurrentUIVC].view];
    [XKHudView showErrorMessage:@"图片发送失败"];
  }
}

+ (void)sendVideoToUIMWithMessage:(NIMMessage *)message session:(NIMSession *)session attachment:(XKIMMessageNomalVideoAttachment *)attachment{
  NSError *error = nil;
  // 发送消息
  [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
  [XKHudView hideHUDForView:[self getCurrentUIVC].view];
  if (!error) {
    [[NIMSDK sharedSDK].teamManager fetchTeamInfo:session.sessionId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
      if (team.memberNumber == 1 && [XKIMGlobalMethod isCutomerServerSession:team]) {
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        para[@"group"] = @(0);
        para[@"type"] = [NSNumber numberWithInteger:attachment.type];
        para[@"tid"] = team.teamId;
        para[@"shopId"] = [XKIMCustomerState sharedManager].shopID;
        para[@"data"] = [attachment getEncodeDataDic];
        [HTTPClient postEncryptRequestWithURLString:[XKIMCustomerState sharedManager].shopID.length > 0 ? @"im/ua/mCustomerServiceTaskAdd/1.0" : @"im/ua/xkCustomerServiceTaskAdd/1.0" timeoutInterval:10 parameters:para success:^(id responseObject) {
          NSLog(@"");
        } failure:^(XKHttpErrror *error) {
          NSLog(@"");
        }];
      }
    }];
  }
  else{
    [XKHudView hideHUDForView:[self getCurrentUIVC].view];
    [XKHudView showErrorMessage:@"视频发送失败"];
  }
}

@end

