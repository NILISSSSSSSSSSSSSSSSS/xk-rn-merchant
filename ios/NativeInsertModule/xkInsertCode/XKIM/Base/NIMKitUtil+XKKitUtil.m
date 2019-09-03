//
//  NIMKitUtil+XKKitUtil.m
//  XKSquare
//
//  Created by william on 2018/11/2.
//  Copyright © 2018 xk. All rights reserved.
//

#import "NIMKitUtil+XKKitUtil.h"
#import <NIMKit.h>
#import <NIMKitInfoFetchOption.h>
@implementation NIMKitUtil (XKKitUtil)


//重写方法 添加对群聊内昵称的显示 并忽略警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
+(NSString *)showNick:(NSString *)uid inMessage:(NIMMessage *)message{
    if (!uid.length) {
        return nil;
    }
    NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
    option.message = message;
    if (message.messageType == NIMMessageTypeRobot)
    {
        NIMRobotObject *object = (NIMRobotObject *)message.messageObject;
        if (object.isFromRobot) {
            return [[NIMKit sharedKit] infoByUser:object.robotId option:option].showName;
        }
    }
    if (message.session.sessionType == NIMSessionTypeTeam) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:message.session.sessionId];
        NIMTeamMember *member = [[NIMSDK sharedSDK].teamManager teamMember:message.from inTeam:team.teamId];
        if (member.nickname) {
            return member.nickname;
        }
    }
    return [[NIMKit sharedKit] infoByUser:uid option:option].showName;
}
#pragma clang diagnostic pop
@end
