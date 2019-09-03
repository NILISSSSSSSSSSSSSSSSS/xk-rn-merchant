//
//  NIMSessionMsgDatasource+XKMessageSeparater.m
//  XKSquare
//
//  Created by william on 2018/12/3.
//  Copyright © 2018 xk. All rights reserved.
//

#import "NIMSessionMsgDatasource+XKMessageSeparater.h"
#import <NIMMessageModel.h>
#import "XKSecretDataSingleton.h"
#import "XKSecretFrientManager.h"
@implementation NIMSessionMsgDatasource (XKMessageSeparater)

+ (void)load {
  method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"insertMessages:")),
                                 class_getInstanceMethod(self.class, @selector(XK_MessageSeparater_insertMessages:)));
  method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"appendMessageModels:")),
                                 class_getInstanceMethod(self.class, @selector(XK_MessageSeparater_appendMessageModels:)));
  method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"insertMessageModels:")),
                                 class_getInstanceMethod(self.class, @selector(XK_MessageSeparater_insertMessageModels:)));
}

- (NIMMessageModel *)model {
  return (NIMMessageModel *)[self valueForKey:@"_model"];
}

/**
 *  从头插入消息
 *
 *  @param messages 消息
 *
 *  @return 插入后table要滑动到的位置
 */
- (NSInteger)XK_MessageSeparater_insertMessages:(NSArray *)messages{
  NSInteger count = self.items.count;
  NSArray *resultArr = [self separateMessages:messages];
  for (NIMMessage *message in resultArr.reverseObjectEnumerator.allObjects) {
    [self insertMessage:message];
  }
  NSInteger currentIndex = self.items.count - 1;
  return currentIndex - count;
}

/**
 *  从后插入消息
 *
 *  @param models 消息集合
 *
 *  @return 插入的消息的index
 */
- (NSArray *)XK_MessageSeparater_appendMessageModels:(NSArray *)models{
  if (!models.count) {
    return @[];
  }
  NSArray *resultArr = [self separateModels:models];
  NSMutableArray *append = [[NSMutableArray alloc] init];
  for (NIMMessageModel *model in resultArr) {
    if ([self modelIsExist:model]) {
      continue;
    }
    NSArray *result = [self insertMessageModel:model index:self.items.count];
    [append addObjectsFromArray:result];
  }
  return append;
}


/**
 *  从中间插入消息
 *
 *  @param models 消息集合
 *
 *  @return 插入消息的index
 */
- (NSArray *)XK_MessageSeparater_insertMessageModels:(NSArray *)models{
  if (!models.count) {
    return @[];
  }
  NSArray *resultArr = [self separateModels:models];
  NSMutableArray *insert = [[NSMutableArray alloc] init];
  //由于找到插入位置后会直接插入，所以这里按时间戳大小先排个序，避免造成先插了时间大的，再插了时间小的，导致之前时间大的消息的位置还需要后移的情况.
  NSArray *sortModels = [resultArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    NIMMessageModel *first  = obj1;
    NIMMessageModel *second = obj2;
    return first.messageTime < second.messageTime ? NSOrderedAscending : NSOrderedDescending;
  }];
  for (NIMMessageModel *model in sortModels) {
    if ([self modelIsExist:model]) {
      continue;
    }
    NSInteger i = [self findInsertPosistion:model];
    NSArray *result = [self insertMessageModel:model index:i];
    [insert addObjectsFromArray:result];
  }
  return insert;
}

#pragma mark -- 排除相对应数据
-(NSArray *)separateModels:(NSArray *)models{
  NSMutableArray *handleMutableArr = [NSMutableArray arrayWithArray:models];
  NSMutableArray *resultMuTableArr = [NSMutableArray arrayWithArray:models];
  
  for (id idItem in handleMutableArr) {
    if ([idItem isKindOfClass:[NIMMessageModel class]]) {
      NIMMessageModel *model = (NIMMessageModel *)idItem;
      NIMMessage *message = model.message;
      // 为自定义消息，且当前为多选模式
      if (message && message.messageObject && [message.messageObject isKindOfClass:[NIMCustomObject class]] && message.session.sessionType == NIMSessionTypeP2P){
        
        if (![self messageIsRight:message]) {
          [resultMuTableArr removeObject:idItem];
        }
        
      }
    }
  }
  
  return [NSArray arrayWithArray:resultMuTableArr];
}

-(NSArray *)separateMessages:(NSArray *)messages{
  NSMutableArray *handleMutableArr = [NSMutableArray arrayWithArray:messages];
  NSMutableArray *resultMuTableArr = [NSMutableArray arrayWithArray:messages];
  
  for (id idItem in handleMutableArr) {
    if ([idItem isKindOfClass:[NIMMessage class]]) {
      NIMMessage *message = (NIMMessage *)idItem;
      // 为自定义消息，且当前为多选模式
      if (message && message.messageObject && [message.messageObject isKindOfClass:[NIMCustomObject class]] && message.session.sessionType == NIMSessionTypeP2P){
        if (![self messageIsRight:message]) {
          [resultMuTableArr removeObject:idItem];
        }
      }
    }
  }
  
  return [NSArray arrayWithArray:resultMuTableArr];
}

-(BOOL)messageIsRight:(NIMMessage *)message{
  BOOL isRight = YES;
  if (message.isOutgoingMsg) {
    if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelNormal) {
      if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
        isRight = NO;
      }
      else{
        isRight = YES;
      }
    }
    else{
      if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
        isRight = YES;
      }
      else{
        isRight = NO;
      }
    }
  }
  else{
    if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelNormal) {
      if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneNomal   || [XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneAll) {
        isRight = YES;
      }
      else if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneSecret){
        isRight = NO;
        // 密友提醒和投射消息就显示
        if ([XKIMGlobalMethod isSecretTipMsgType:message]) {
          return YES;
        }
      }
      else{
        if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
          isRight = NO;
        }
        else{
          isRight = YES;
        }
      }
      if (message.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *object = message.messageObject;
        if ([object.attachment isKindOfClass:[XKIMMessageBaseAttachment class]]) {
          XKIMMessageBaseAttachment *baseAtt = object.attachment;
          if (baseAtt.group == 3) {
            isRight = YES;
          }
        }
      }
    } else {
      if (message.messageType != NIMMessageTypeCustom) {
        return NO;
      }
      // 密友提醒和投射消息就不在密友显示了
      if ([XKIMGlobalMethod isSecretTipMsgType:message]) {
        return NO;
      }
      if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneSecret   || [XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneAll) {
        isRight = YES;
      } else if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneNomal) {
        isRight = NO;
      } else {
        if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
          isRight = YES;
        }
        else{
          isRight = NO;
        }
      }
    }
  }
  return isRight;
}


@end
