//
//  XKSecretFrientManager.m
//  XKSquare
//
//  Created by william on 2018/11/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKSecretFrientManager.h"
#import "XKRelationUserCacheManager.h"
#import "XKSecretDataSingleton.h"
#import "XKTransformHelper.h"
@implementation XKSecretFrientManager

+(XKShowMessagesScene)showMessagesSceneWithUserID:(NSString *)userID{
  XKContactModel *model = [XKRelationUserCacheManager queryContactWithUserId:userID];
  NSLog(@"");
  
  if (model.secretRelation == XKRelationNoting && model.friendRelation == XKRelationNoting) {
    return XKShowMessagesBlackList;
  }
  
  //仅为可友
  if (model.secretRelation == XKRelationNoting && model.friendRelation == XKRelationTwoWay) {
    return XKShowMessagesSceneNomal;
  }
  
  //仅仅对方是我的密友
  if (model.secretRelation == XKRelationOneWay) {
    if (model.friendRelation == XKRelationTwoWay) {
      return XKShowMessagesSceneSecret;
    }
    if (model.friendRelation == XKRelationNoting) {
      return XKShowMessagesSceneSecret;
    }
    //        if (model.friendRelation == XKRelationOneWay) {
    //            //不存在此情况
    //        }
  }
  
  //互为密友
  if (model.secretRelation == XKRelationTwoWay) {
    if (model.friendRelation == XKRelationOneWay) {
      //两边都接收
      return XKShowMessagesSceneSecret;
    }
    if (model.friendRelation == XKRelationNoting) {
      //密友接收
      return XKShowMessagesSceneSecret;
    }
    if (model.friendRelation == XKRelationTwoWay) {
      //哪里发哪里收
      return XKShowMessagesSceneRespective;
    }
  }
  
  return XKShowMessagesSceneNomal;
}


+(BOOL)saveLastMessageInDBWithMessage:(NIMMessage *)message{
  if ([XKIMGlobalMethod isSecretTipMsgType:message]) {
    return YES;
  }
  if ([[XKDataBase instance]exists:XKIMSecretChatLastMessageDataBaseTable key:message.session.sessionId]) {
    XKIMSecretChatLastMessageModel *model = [XKIMSecretChatLastMessageModel new];
    model.sessionID = message.session.sessionId;
    model.messageId = message.messageId;
    model.messageObject = [NSString stringWithFormat:@"%@", message.messageObject];
    model.time = message.timestamp;
    return [[XKDataBase instance]update:XKIMSecretChatLastMessageDataBaseTable key:message.session.sessionId value:[model yy_modelToJSONString]];
  } else {
    if ([[XKDataBase instance]createTable:XKIMSecretChatLastMessageDataBaseTable]) {
      XKIMSecretChatLastMessageModel *model = [XKIMSecretChatLastMessageModel new];
      model.sessionID = message.session.sessionId;
      model.messageId = message.messageId;
      model.messageObject = [NSString stringWithFormat:@"%@", message.messageObject];
      model.time = message.timestamp;
      
      BOOL result = [[XKDataBase instance]replace:XKIMSecretChatLastMessageDataBaseTable key:message.session.sessionId value:[model yy_modelToJSONString]];
      // fix 密友圈里第一条消息不显示问题
      [[NSNotificationCenter defaultCenter]postNotificationName:XKSecretChatListViewControllerrRefreshDataNotification object:nil];
      return result;
    }
    else{
      return NO;
    }
  }
}

+(XKIMSecretChatLastMessageModel *)getLastMessageInDBWithSessionID:(NSString *)sessionID{
  if ([[XKDataBase instance]exists:XKIMSecretChatLastMessageDataBaseTable key:sessionID]) {
    NSString *jsonString = [[XKDataBase instance]select:XKIMSecretChatLastMessageDataBaseTable key:sessionID];
    XKIMSecretChatLastMessageModel *model = [XKIMSecretChatLastMessageModel yy_modelWithJSON:jsonString];
    return model;
  }
  else{
    return nil;
  }
}

+(BOOL)messageIsFromSecretFriend:(NIMMessage *)message{
  if (message.messageType == NIMMessageTypeCustom) {
    NIMCustomObject *object = message.messageObject;
    XKIMMessageBaseAttachment *baseAtt = object.attachment;
    if (![baseAtt isKindOfClass:[XKIMMessageBaseAttachment class]]) {
      return NO;
    }
    if (baseAtt.group == 2 ) {
      return YES;
    }
    else{
      return NO;
    }
  }
  else{
    return NO;
  }
}

+(void)deleteAllSecretChatHistoryInSession:(NIMSession *)session complete:(void(^)(BOOL success))complete{
  if ([[XKDataBase instance]exists:XKIMSecretChatLastMessageDataBaseTable key:session.sessionId]) {
    [[XKDataBase instance]deleteValueForTable:XKIMSecretChatLastMessageDataBaseTable key:session.sessionId];
  }
  
  NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
  option.limit = 0;
  option.order = NIMMessageSearchOrderDesc;
  option.messageTypes = @[@(NIMMessageTypeCustom)];
  [[NIMSDK sharedSDK].conversationManager searchMessages:session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
    for (NIMMessage *message in messages) {
      if (message.isOutgoingMsg) {
        if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
          [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
        }
      }
      else{
        if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneSecret) {
          [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
        }
        else if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneRespective){
          if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
            [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
          }
        }else{
          
        }
      }
    }
    
    complete(YES);
  }];
}

+(void)deleteSecretMessage:(NSArray *)messageArray session:(NIMSession *)session complete:(void(^)(BOOL success))complete{
  for (NIMMessage *message in messageArray) {
    
    if ([[XKDataBase instance] exists:XKIMSecretChatLastMessageDataBaseTable key:session.sessionId]) {
      NSString *jsonString = [[XKDataBase instance] select:XKIMSecretChatLastMessageDataBaseTable key:session.sessionId];
      XKIMSecretChatLastMessageModel *model = [XKIMSecretChatLastMessageModel yy_modelWithJSON:jsonString];
      if ([model.messageId isEqualToString:message.messageId]) {
        [[XKDataBase instance] deleteValueForTable:XKIMSecretChatLastMessageDataBaseTable key:session.sessionId];
      }
    }
    
    if (message.isOutgoingMsg) {
      if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
        [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
      }
    } else {
      if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneSecret) {
        [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
      } else if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneRespective) {
        if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
          [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
        }
      } else {
        
      }
    }
  }
  
  
  NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
  option.limit = 0;
  option.order = NIMMessageSearchOrderDesc;
  option.messageTypes = @[@(NIMMessageTypeCustom)];
  [[NIMSDK sharedSDK].conversationManager searchMessages:session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
    NSArray *arr = [[messages reverseObjectEnumerator]allObjects];
    for (NIMMessage *message in arr) {
      if (message.isOutgoingMsg ) {
        if ([self messageIsFromSecretFriend:message]) {
          [self saveLastMessageInDBWithMessage:message];
          complete(YES);
          return;
        } else {
        }
      } else {
        if ([XKIMGlobalMethod isSecretTipMsgType:message]) {
          continue;
        }
        if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneSecret) {
          [self saveLastMessageInDBWithMessage:message];
          complete(YES);
          return;
        } else if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneRespective) {
          if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
            [self saveLastMessageInDBWithMessage:message];
            complete(YES);
            return;
          }
        } else {
          
        }
      }
    }
    complete(NO);
  }];
}

+ (BOOL)receivedMessageShouldShowFireView:(NIMMessage *)message {
  if (message.messageType == NIMMessageTypeCustom) {
    NIMCustomObject *object = message.messageObject;
    XKIMMessageBaseAttachment *baseAtt = object.attachment;
    if (![baseAtt isKindOfClass:[XKIMMessageBaseAttachment class]]) {
      return NO;
    }
    if (baseAtt.fireStatus == 1 ||
        baseAtt.fireStatus == 2 ||
        baseAtt.fireStatus == 3) {
      return YES;
    } else {
      return NO;
    }
  } else {
    return NO;
  }
}

+(BOOL)receivedMessageShouldDelete:(NIMMessage *)message{
  if (message.messageType == NIMMessageTypeCustom) {
    NIMCustomObject *object = message.messageObject;
    XKIMMessageBaseAttachment *baseAtt = object.attachment;
    if (![baseAtt isKindOfClass:[XKIMMessageBaseAttachment class]]) {
      return NO;
    }
    if (baseAtt.fireStatus == 2 ||
        baseAtt.fireStatus == 3) {
      return YES;
    } else {
      return NO;
    }
  } else {
    return NO;
  }
}

+(BOOL)secretSessionIsSilence:(NIMSession *)session{
  if ([[XKDataBase instance]existsTable:XKIMSecretSilenceChatDataBaseTable]) {
    NSString *jsonString = [[XKDataBase instance]select:XKIMSecretSilenceChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
    NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
    if (idArr && idArr.count > 0) {
      if ([idArr containsObject:session.sessionId]) {
        return YES;
      }
      else{
        return NO;
      }
    }
    else{
      return NO;
    }
  }else{
    return NO;
  }
}

+(void)cancelSecretTopChatWithUserID:(NSString *)userID{
  if ([[XKDataBase instance]exists:XKIMSecretTopChatDataBaseTable key:[XKUserInfo currentUser].userId]) {
    NSString *jsonString = [[XKDataBase instance]select:XKIMSecretTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
    NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
    NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
    [idMuArr removeObject:userID];
    BOOL success =  [[XKDataBase instance]replace:XKIMSecretTopChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
    NSLog(@"%d",success);
  }
}
@end
