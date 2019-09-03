//
//  NIMKitUtil+XKIM.m
//  XKSquare
//
//  Created by xudehuai on 2019/5/13.
//  Copyright © 2019 xk. All rights reserved.
//

#import "NIMKitUtil+XKIM.h"

@implementation NIMKitUtil (XKIM)

+ (void)load {
    method_exchangeImplementations(class_getClassMethod(self.class, NSSelectorFromString(@"teamNotificationFormatedMessage:")),
                                   class_getClassMethod(self.class, @selector(XK_teamNotificationFormatedMessage:)));
//    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"makeComponents")),
//                                   class_getInstanceMethod(self.class, @selector(XK_IMMultipleSelection_makeComponents)));
}

+ (NSString*)XK_teamNotificationFormatedMessage:(NIMMessage *)message{
    NSString *formatedMessage = @"";
    NIMNotificationObject *object = message.messageObject;
    if (object.notificationType == NIMNotificationTypeTeam)
    {
        NIMTeamNotificationContent *content = (NIMTeamNotificationContent*)object.content;
        NSString *source = [NIMKitUtil teamNotificationSourceName:message];
        NSArray *targets = [NIMKitUtil teamNotificationTargetNames:message];
        NSString *targetText = [targets count] > 1 ? [targets componentsJoinedByString:@","] : [targets firstObject];
        NSString *teamName = [NIMKitUtil teamNotificationTeamShowName:message];
        
        switch (content.operationType) {
            case NIMTeamOperationTypeInvite:{
//                NSString *str = [NSString stringWithFormat:@"%@邀请%@",source,targets.firstObject];
//                if (targets.count>1) {
//                    str = [str stringByAppendingFormat:@"等%zd人",targets.count];
//                }
//                str = [str stringByAppendingFormat:@"进入了%@",teamName];
                NSString *str = targets.firstObject;
                if (targets.count>1) {
                    str = [str stringByAppendingFormat:@"等%zd人",targets.count];
                }
                str = [str stringByAppendingFormat:@"已加入%@",teamName];
                formatedMessage = str;
            }
                break;
            case NIMTeamOperationTypeDismiss:
//                formatedMessage = [NSString stringWithFormat:@"%@解散了%@",source,teamName];
                // xudehuai
                if ([self currentUserIsGroupOwner:message]) {
                    formatedMessage = [NSString stringWithFormat:@"%@已解散了该%@",source,teamName];
                } else {
                    formatedMessage = [NSString stringWithFormat:@"%@解散了%@",source,teamName];
                }
                break;
            case NIMTeamOperationTypeKick:{
//                NSString *str = [NSString stringWithFormat:@"%@将%@",source,targets.firstObject];
//                if (targets.count>1) {
//                    str = [str stringByAppendingFormat:@"等%zd人",targets.count];
//                }
//                str = [str stringByAppendingFormat:@"移出了%@",teamName];
//                formatedMessage = str;
                // xudehuai
                if ([targets containsObject:[NIMKitUtil showNick:[[NIMSDK sharedSDK].loginManager currentAccount] inSession:message.session]]) {
                    // 我被踢
                    formatedMessage = @"您已被群主踢出该群";
                } else {
                    if ([self currentUserIsGroupOwner:message]) {
                        // 群主
                        NSString *str = [NSString stringWithFormat:@"您已将\"%@\"",targets.firstObject];
                        if (targets.count>1) {
                            str = [str stringByAppendingFormat:@"等%zd人",targets.count];
                        }
                        str = [str stringByAppendingString:@"踢出该群"];
                        formatedMessage = str;
                    } else {
                        NSString *str = [NSString stringWithFormat:@"\"%@\"",targets.firstObject];
                        if (targets.count>1) {
                            str = [str stringByAppendingFormat:@"等%zd人",targets.count];
                        }
                        str = [str stringByAppendingString:@"已被踢出该群"];
                        formatedMessage = str;
                    }
                }
            }
                break;
            case NIMTeamOperationTypeUpdate:
            {
                id attachment = [content attachment];
                if ([attachment isKindOfClass:[NIMUpdateTeamInfoAttachment class]]) {
                    NIMUpdateTeamInfoAttachment *teamAttachment = (NIMUpdateTeamInfoAttachment *)attachment;
                    formatedMessage = [NSString stringWithFormat:@"%@更新了%@信息",source,teamName];
                    //如果只是单个项目项被修改则显示具体的修改项
                    if ([teamAttachment.values count] == 1) {
                        NIMTeamUpdateTag tag = [[[teamAttachment.values allKeys] firstObject] integerValue];
                        switch (tag) {
                            case NIMTeamUpdateTagName:
//                                formatedMessage = [NSString stringWithFormat:@"%@更新了%@名称",source,teamName];
                                // xudehuai
//                                formatedMessage = [NSString stringWithFormat:@"%@修改了群名称\"%@\"",source, [[NIMSDK sharedSDK].teamManager teamById: message.session.sessionId].teamName];
                                formatedMessage = [NSString stringWithFormat:@"%@修改了群名称\"%@\"",source, teamAttachment.values[@(NIMTeamUpdateTagName)]];
                                break;
                            case NIMTeamUpdateTagIntro:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了%@介绍",source,teamName];
                                break;
                            case NIMTeamUpdateTagAnouncement:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了%@公告",source,teamName];
                                break;
                            case NIMTeamUpdateTagJoinMode:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了%@验证方式",source,teamName];
                                break;
                            case NIMTeamUpdateTagAvatar:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了%@头像",source,teamName];
                                break;
                            case NIMTeamUpdateTagInviteMode:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了邀请他人权限",source];
                                break;
                            case NIMTeamUpdateTagBeInviteMode:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了被邀请人身份验证权限",source];
                                break;
                            case NIMTeamUpdateTagUpdateInfoMode:
                                formatedMessage = [NSString stringWithFormat:@"%@更新了群资料修改权限",source];
                                break;
                            case NIMTeamUpdateTagMuteMode:{
                                NSString *muteState = teamAttachment.values.allValues.firstObject;
                                BOOL muted = [muteState isEqualToString:@"0"] ? NO : YES;
                                formatedMessage = muted? [NSString stringWithFormat:@"%@设置了群全体禁言",source]: [NSString stringWithFormat:@"%@取消了全体禁言",source];
                                break;
                            }
                            default:
                                break;
                                
                        }
                    }
                }
                if (formatedMessage == nil){
                    formatedMessage = [NSString stringWithFormat:@"%@更新了%@信息",source,teamName];
                }
            }
                break;
            case NIMTeamOperationTypeLeave:
//                formatedMessage = [NSString stringWithFormat:@"%@离开了%@",source,teamName];
                // xudehuai
                if ([self currentUserIsGroupOwner:message]) {
                    formatedMessage = [NSString stringWithFormat:@"%@已退出%@",source,teamName];
                } else {
                    formatedMessage = [NSString stringWithFormat:@"%@退出了%@",source,teamName];
                }
                break;
            case NIMTeamOperationTypeApplyPass:{
                if ([source isEqualToString:targetText]) {
                    //说明是以不需要验证的方式进入
//                    formatedMessage = [NSString stringWithFormat:@"%@进入了%@",source,teamName];
                    // xudehuai
                    if ([self currentUserIsGroupOwner:message]) {
                        formatedMessage = [NSString stringWithFormat:@"%@已加入%@",source,teamName];
                    } else {
                        formatedMessage = [NSString stringWithFormat:@"%@已加入%@",source,teamName];
                    }
                }else{
                    formatedMessage = [NSString stringWithFormat:@"%@通过了%@的申请",source,targetText];
                }
            }
                break;
            case NIMTeamOperationTypeTransferOwner:
//                formatedMessage = [NSString stringWithFormat:@"%@转移了群主身份给%@",source,targetText];
                if ([self currentUserIsGroupOwner:message]) {
                    formatedMessage = [NSString stringWithFormat:@"%@已将群管权移交给\"%@\"",source,targetText];
                } else {
                    formatedMessage = [NSString stringWithFormat:@"群主已将群管权移交给\"%@\"",targetText];
                }
                break;
            case NIMTeamOperationTypeAddManager:
                formatedMessage = [NSString stringWithFormat:@"%@被添加为群管理员",targetText];
                break;
            case NIMTeamOperationTypeRemoveManager:
                formatedMessage = [NSString stringWithFormat:@"%@被撤销了群管理员身份",targetText];
                break;
            case NIMTeamOperationTypeAcceptInvitation:
                formatedMessage = [NSString stringWithFormat:@"%@接受%@的邀请进群",source,targetText];
                break;
            case NIMTeamOperationTypeMute:{
                id attachment = [content attachment];
                if ([attachment isKindOfClass:[NIMMuteTeamMemberAttachment class]])
                {
                    BOOL mute = [(NIMMuteTeamMemberAttachment *)attachment flag];
                    NSString *muteStr = mute? @"禁言" : @"解除禁言";
                    NSString *str = [targets componentsJoinedByString:@","];
//                    formatedMessage = [NSString stringWithFormat:@"%@被%@%@",str,source,muteStr];
                    // xudehuai
                    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:message.session.sessionId];
                    if ([team.intro isEqualToString:@"2"]) {
                        formatedMessage = [NSString stringWithFormat:@"%@已被管理员%@",str,muteStr];
                      
                    } else {
                        formatedMessage = [NSString stringWithFormat:@"%@被%@%@",str,source,muteStr];
                    }
                }
            }
                break;
            default:
                break;
        }
        
    }
    if (!formatedMessage.length) {
        formatedMessage = [NSString stringWithFormat:@"未知系统消息"];
    }
    return formatedMessage;
}

#pragma mark - Private Methods

+ (BOOL)currentUserIsGroupOwner:(NIMMessage *)message {
    return [[[NIMSDK sharedSDK].loginManager currentAccount] isEqualToString:[[NIMSDK sharedSDK].teamManager teamById:message.session.sessionId].owner];
}

+ (NSString *)teamNotificationSourceName:(NIMMessage *)message{
    NSString *source;
    NIMNotificationObject *object = message.messageObject;
    NIMTeamNotificationContent *content = (NIMTeamNotificationContent*)object.content;
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    if ([content.sourceID isEqualToString:currentAccount]) {
        source = @"您";
    }else{
//        source = [NIMKitUtil showNick:content.sourceID inSession:message.session];
        // xudehuai
        source = [NIMKitUtil showNick:content.sourceID inSession:message.session] ?: @"";
    }
    return source;
}

+ (NSArray *)teamNotificationTargetNames:(NIMMessage *)message{
    NSMutableArray *targets = [[NSMutableArray alloc] init];
    NIMNotificationObject *object = message.messageObject;
    NIMTeamNotificationContent *content = (NIMTeamNotificationContent*)object.content;
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    for (NSString *item in content.targetIDs) {
        if ([item isEqualToString:currentAccount]) {
            [targets addObject:@"您"];
        }else{
//            NSString *targetShowName = [NIMKitUtil showNick:item inSession:message.session];
            // xudehuai
            NSString *targetShowName = [NIMKitUtil showNick:item inSession:message.session] ?: @"";
            [targets addObject:targetShowName];
        }
    }
    return targets;
}


+ (NSString *)teamNotificationTeamShowName:(NIMMessage *)message{
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:message.session.sessionId];
    NSString *teamName = team.type == NIMTeamTypeNormal ? @"讨论组" : @"群聊";
    return teamName;
}

+ (BOOL)canEditTeamInfo:(NIMTeamMember *)member
{
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:member.teamId];
    if (team.updateInfoMode == NIMTeamUpdateInfoModeManager)
    {
        return member.type == NIMTeamMemberTypeOwner || member.type == NIMTeamMemberTypeManager;
    }
    else
    {
        return member.type == NIMTeamMemberTypeOwner || member.type == NIMTeamMemberTypeManager || member.type == NIMTeamMemberTypeNormal;
    }
}

+ (BOOL)canInviteMember:(NIMTeamMember *)member
{
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:member.teamId];
    if (team.inviteMode == NIMTeamInviteModeManager)
    {
        return member.type == NIMTeamMemberTypeOwner || member.type == NIMTeamMemberTypeManager;
    }
    else
    {
        return member.type == NIMTeamMemberTypeOwner || member.type == NIMTeamMemberTypeManager || member.type == NIMTeamMemberTypeNormal;
    }
    
}

@end
