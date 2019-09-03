//
//  XKSecretFrientManager.h
//  XKSquare
//
//  Created by william on 2018/11/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import "XKIMSecretChatLastMessageModel.h"
#import "XKSecretMessageFireManager.h"
typedef NS_ENUM(NSInteger ,XKShowMessagesScene) {
  XKShowMessagesSceneNomal = 0, // 可友
  XKShowMessagesSceneSecret, // 密友
  XKShowMessagesSceneAll, //两边都显示
  XKShowMessagesSceneRespective, //可友发的显示可友 密友发的显示密友
  XKShowMessagesBlackList,        //黑名单
};
@interface XKSecretFrientManager : NSObject

/**
 密友信息显示场景
 
 @param userID 密友ID
 @return 显示场景
 */
+(XKShowMessagesScene)showMessagesSceneWithUserID:(NSString *)userID;


/**
 密友最后一条消息保存到数据库
 用于显示判断
 
 @param message 消息体
 @return 是否成功
 */
+(BOOL)saveLastMessageInDBWithMessage:(NIMMessage *)message;


/**
 从数据库获取最后一条保存的密友消息
 
 @param sessionID sessionID
 @return 最后一条消息Model
 */
+(XKIMSecretChatLastMessageModel *)getLastMessageInDBWithSessionID:(NSString *)sessionID;


/**
 判断消息是否是密友发送
 判断object内的group
 
 @param message message
 @return YES or NO
 */
+(BOOL)messageIsFromSecretFriend:(NIMMessage *)message;


/**
 删除某个密友的所有密友消息
 
 @param session 对话session
 @param complete 完成回调
 */
+(void)deleteAllSecretChatHistoryInSession:(NIMSession *)session complete:(void(^)(BOOL success))complete;


/**
 删除密友中的某些消息
 
 @param messageArray 消息数组
 @param session 对话session
 @param complete 完成回调
 */
+(void)deleteSecretMessage:(NSArray *)messageArray session:(NIMSession *)session complete:(void(^)(BOOL success))complete;

/**
 判断收到的消息是否需要显示遮罩
 判断object中的fireStatus
 
 @param message message
 @return YES or NO
 */
+ (BOOL)receivedMessageShouldShowFireView:(NIMMessage *)message;

/**
 判断收到的消息是否需要删除
 判断object中的fireStatus
 
 @param message message
 @return YES or NO
 */
+ (BOOL)receivedMessageShouldDelete:(NIMMessage *)message;


/**
 密友对话是否静音
 
 @param session session
 @return YES or NO
 */
+(BOOL)secretSessionIsSilence:(NIMSession *)session;


/**
 取消置顶
 
 @param userID userID
 */
+(void)cancelSecretTopChatWithUserID:(NSString *)userID;
@end
