//
//  XKIMGlobalMethod.h
//  IMTest
//
//  Created by william on 2018/8/21.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMKit.h>
#import "XKIM.h"
@interface XKIMGlobalMethod : NSObject


/**
 IM登录
 
 @param account 账号ID
 @param token IMToken
 @param returnError 返回值 成功为nil
 */
+(void)IMLoginWithAccount:(NSString *)account andToken:(NSString *)token error:(void (^)(NSError *)) returnError;


/**
 自动登录，用于用户已登录的自动登录状态
 */
+(void)IMAutoLogin;


/**
 获取最近消息列表
 数组内为NIMRecentSession类型数据
 */
+(NSArray *)getLatestMessageListArray;
// 获取p2p
+(NSArray *)getLatestP2PChatListArray;
// 获取群聊
+(NSArray *)getLatestGroupChatListArray;
// 获取客服
+(NSArray *)getLatestServerChatListArray;
// 获取系统消息
+(NSArray *)getLatestSysChatListArray;
/**
 发送图片消息
 
 @param imageArr 图片数组 内容为UIImage类型
 @param session 对话session
 
 */
+(void)sendImagesMessage:(NSArray *)imageArr session:(NIMSession *)session;


/**
 发送自定义文字消息
 
 @param messageStr 消息内容
 @param session 对话session
 */
+(void)sendTextMessage:(NSString *)messageStr session:(NIMSession *)session;


/**
 发送自定义语音消息
 
 @param pathStr 语音文件本地路径
 @param sessioin 对话session
 */
+(void)sendAudioMessage:(NSString *)pathStr session:(NIMSession *)sessioin;


/**
 发送自定义视频消息
 
 @param attachment 视频attachment
 @param session 对话session
 */
+(void)sendVideoMessage:(XKIMMessageNomalVideoAttachment *)attachment session:(NIMSession *)session;

/**
 发送好友卡
 
 @param attachment 好友内容attachment
 @param session 对话session
 */
+(void)sendFriendCard:(XKIMMessageFirendCardAttachment *)attachment session:(NIMSession *)session;

/**
 创建单聊
 
 @param NIMIDString 云信ID
 */
+(void)createP2PChatWithNIMID:(NSString *)NIMIDString;

/**
 创建客服聊天
 */
+(void)createCustomerSerChatWithName:(NSString *)serName imageUrl:(NSString *)imageUrl shopID:(NSString *)shopID;


/**
 前往二级客服列表页面
 */
+(void)gotoCustomerSerChatList;


/**
 判断群聊是否是客服
 
 @param team NIMTeam对象
 */
+(BOOL)isCutomerServerSession:(NIMTeam *)team;


/**
 发送小视频
 
 @param attachment 小视频attachment
 @param session 对话session
 */
+(void)sendLittleVideo:(XKIMMessageLittleVideoAttachment *)attachment session:(NIMSession *)session;


/**
 发送分享
 
 @param shareArray 分享model数组
 @param session 对话session
 */
+(void)sendShareWithShareArray:(NSArray *)shareArray session:(NIMSession *)session;

/**
 发送收藏的项目 商品 店铺 游戏 小视频福利 福利
 
 @param collectItem 收藏的项目
 @param session 对话session
 */
+ (void)sendCollectItem:(XKIMMessageBaseAttachment *)collectItem session:(NIMSession *)session;

/**
 发送礼物
 
 @param attachment 礼物attachment
 @param session 对话session
 */
+ (void)sendGift:(XKIMMessageGiftAttachment *) attachment session:(NIMSession *)session;


/**
 发送红包
 
 @param attachment 红包attachment
 @param session 对话session
 */
+ (void)sendRedEnvelope:(XKIMMessageRedEnvelopeAttachment *) attachment session:(NIMSession *)session;


/**
 发送红包提示消息
 
 @param attachment 红包attachment
 @param session 对话session
 */
+ (void)sendRedEnvelopeTip:(XKIMMessageRedEnvelopeTipAttachment *) attachment session:(NIMSession *)session;

/**
 发送卡券 晓可卡 商户卡 晓可券 商户券
 
 @param cardCoupon 卡券
 @param session 对话session
 */
+ (void)sendCardCoupon:(XKIMMessageBaseAttachment *)cardCoupon session:(NIMSession *)session;


/**
 发送音乐
 
 @param music 音乐
 @param session 对话session
 */
+ (void)sendMusic:(XKIMMessageMusicAttachment *)music session:(NIMSession *)session;


/**
 发送订单
 
 @param order 订单
 @param session 对话session
 */
+ (void)sendOrder:(XKIMMessageCustomerSerOrderAttachment *)order session:(NIMSession *)session;

/**
 发送大奖
 
 @param grandPrize 平台大奖 店铺大奖
 @param session 对话session
 */
+ (void)sendGrandPrize:(XKIMMessageBaseAttachment *)grandPrize session:(NIMSession *)session;

/**
 发送新闻资讯
 
 @param news 新闻资讯
 @param session 对话session
 */
+ (void)sendNews:(XKIMMessageNewsAttachment *)news session:(NIMSession *)session;

/**
 根据sessionid获取最后一条消息
 
 @param sessionID sessionID
 @return 消息体
 */
+ (NIMMessage *)getLastMessageWithSessionID:(NSString *)sessionID sessionType:(NIMSessionType)sessionType;


/**
 失败后点击重发消息
 
 @param message 重发message
 */
+ (BOOL)resendMessage:(NIMMessage *)message;


/**
 查询包含关键字的所有聊天记录
 
 @param keyWord 关键字
 @param complete 完成回调
 */
+(void)searchAllTextMessageWithKeyWord:(NSString *)keyWord complete:(void(^)(NSArray <NIMMessage *>*messages))complete;


/**
 查询包含关键字的所有可友聊天记录
 
 @param keyWord 关键字
 @param complete 完成回调
 */
+(void)searchAllKeFriendTextMessageWithKeyWord:(NSString *)keyWord complete:(void(^)(NSArray <NIMMessage *>*messages))complete;

/**
 查询包含关键字的所有密友聊天记录
 
 @param keyWord 关键字
 @param complete 完成回调
 */
+(void)searchAllSecretFriendTextMessageWithKeyWord:(NSString *)keyWord complete:(void(^)(NSArray <NIMMessage *>*messages))complete;


/**
 搜索某个人的可友消息
 
 @param session session
 @param complete 完成回调
 */
+(void)searchKeFriendMessageWithSession:(NIMSession *)session complete:(void(^)(NSArray <NIMMessage *>*messages))complete;


/**
 删除某个好友的所有可友消息
 
 @param session 对话session
 @param deleteRecentSession 是否删除对话
 @param complete 完成回调
 */
+(void)deleteAllKeFriendChatHistoryInSession:(NIMSession *)session deleteRecentSession:(BOOL)delete complete:(void(^)(BOOL success))complete;


/**
 取消可友置顶
 
 @param userID 可友ID
 */
+(void)cancelNormalTopChatWithUserID:(NSString *)userID;

/**是密友提醒消息或者投射消息*/
+ (BOOL)isSecretTipMsgType:(NIMMessage *)message;
@end
