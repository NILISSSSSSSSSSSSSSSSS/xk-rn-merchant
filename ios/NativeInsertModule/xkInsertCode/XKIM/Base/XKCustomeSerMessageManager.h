//
//  XKCustomeSerMessageManager.h
//  XKSquare
//
//  Created by william on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMKit.h>
#import "XKIMMessageCustomerSerOrderAttachment.h"
@interface XKCustomeSerMessageManager : NSObject



/**
 创建晓可客服聊天
 */
+(void)createXKCustomerSerChat;


/**
 创建商铺客服
 
 @param customerID 商铺ID
 */
+(void)createShopCustomerWithCustomerID:(NSString *)customerID;

/**
 发送客服文字消息
 
 @param messageStr 消息内容
 @param session 对话session
 */
+(void)senSerTestMessageWithMessage:(NSString *)messageStr session:(NIMSession *)session;


/**
 发送客服语音消息
 
 @param pathString 语音路径
 @param session 对话session
 */
+(void)senSerAudioMessageWithPath:(NSString *)pathString session:(NIMSession *)session;

/**
 发送客服order消息
 
 @param orderAttachment 订单详情
 @param session 对话session
 */
+(void)sendSerOrderMessageWithOrderDictionary:(XKIMMessageCustomerSerOrderAttachment *)orderAttachment session:(NIMSession *)session;


/**
 发送客服图片消息
 
 @param imageArr 图片数组
 @param session 对话session
 */
+(void)sendSerImageMessageWithImageArr:(NSArray *)imageArr sessoin:(NIMSession *)session;


/**
 发送客服视频消息
 
 @param videoTime 视频时长 毫秒
 @param videoUrl 视频本地地址
 @param firstImg 首帧图
 @param videoWidth 视频宽
 @param videoHeight 视频高
 @param session 对话session
 */
+ (void)sendSerVideoMessageWithVideovideoTime:(NSUInteger)videoTime videoUrl:(NSString *)videoUrl firstImg:(UIImage *)firstImg videoWidth:(double)videoWidth videoHeight:(double)videoHeight sessoin:(NIMSession *)session;

@end
