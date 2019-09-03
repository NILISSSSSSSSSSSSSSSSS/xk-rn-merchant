//
//  XKIMTeamChatManager.h
//  XKSquare
//
//  Created by william on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMKit.h>
@interface XKIMTeamChatManager : NSObject

/**
 创建群聊
 
 @param userIDArr 用户云信ID数组
 */
+(void)createTeamChatWithUserIDArr:(NSArray *)userIDArr;


/**
 判断是否是默认群名
 
 @param name 群名
 @return yes or no
 */
+(BOOL)isDefaultTeamName:(NSString *)name;

/**
 更新群头像
 
 @param teamId 群Id
 */
+ (void)updateTeamAvatar:(NSString *)teamId;

/**
 修改群头像
 
 @param userIDArr 用户ID数组
 @param teamID TeamID
 */
+(void)modifyTeamAvatarWithUserIDArr:(NSArray *)userIDArr teamID:(NSString *)teamID;

+ (void)modifyTeamAvatarWithUserIDArr:(NSArray *)userIDArr
                               teamID:(NSString *)teamID
                         succeedBlock:(void (^)(NSString *avatarUrl))succeedBlock
                          failedBlock:(void (^)(void))failedBlock;


/**
 根据群ID获取群名
 因为新建群没有名字
 获取群员名字拼接名字
 @param team team
 */
+(void)getTeamNameWithTeamID:(NIMTeam *)team complete:(void(^)(NSString *nameString))complete;


/**
 根据群名查询
 
 @param teamName 群名
 @param complete 完成回调
 */
+(void)getTeamListWithTeamName:(NSString *)teamName complete:(void(^)(NSArray <NIMTeam *>*teams))complete;
@end
