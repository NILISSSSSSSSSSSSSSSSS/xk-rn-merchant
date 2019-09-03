//
//  XKIMTeamChatManager.m
//  XKSquare
//
//  Created by william on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMTeamChatManager.h"
#import "XKP2PChatViewController.h"
#import "UIImage+Addtions.h"

@implementation XKIMTeamChatManager

+(void)createTeamChatWithUserIDArr:(NSArray *)userIDArr{
  NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc]init];
  option.type = NIMTeamTypeAdvanced;
  option.joinMode = NIMTeamJoinModeNoAuth;
  option.inviteMode = NIMTeamInviteModeAll;
  option.beInviteMode = NIMTeamBeInviteModeNoAuth;
  option.updateInfoMode = NIMTeamUpdateInfoModeAll;
  
  [XKHudView showLoadingMessage:@"正在创建" to:nil animated:YES];
  [[NIMSDK sharedSDK].userManager fetchUserInfos:userIDArr completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
    NSMutableArray *memberNameArr= [NSMutableArray array];
    NSMutableArray *memberAvatorArr = [NSMutableArray array];
    
    for (NIMUser *user in users) {
      [memberNameArr addObject:user.userInfo.nickName];
      [memberAvatorArr addObject:user.userInfo.avatarUrl];
    }
    NSString *nameString = [memberNameArr componentsJoinedByString:@"、"];
    UIImage *groupAvator = [UIImage groupIconWithURLArray:memberAvatorArr bgColor:UIColorFromRGB(0xf1f1f1)];
    [[XKUploadManager shareManager]uploadImage:groupAvator withKey:@"XKIM_GroupAvator" progress:nil success:^(NSString *url) {
      option.avatarUrl = kQNPrefix(url);
      option.name = [NSString stringWithFormat:@"[$*$]%@",nameString];
      [[NIMSDK sharedSDK].teamManager createTeam:option users:userIDArr completion:^(NSError * _Nullable error, NSString * _Nullable teamId, NSArray<NSString *> * _Nullable failedUserIds) {
        [XKHudView hideHUDForView:nil animated:YES];
        if (error) {
          NSLog(@"创建客服聊天失败");
          [XKHudView showErrorMessage:@"创建失败"];
          
        } else {
          [[self getCurrentUIVC].navigationController popToRootViewControllerAnimated:NO];
          
          NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
          XKP2PChatViewController *vc = [[XKP2PChatViewController alloc] initWithSession:session];
          [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
          
          [[NIMSDK sharedSDK].userManager fetchUserInfos:userIDArr completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
            if (!error) {
              for (NIMUser *tempUser in users) {
                [[NIMSDK sharedSDK].teamManager updateUserNick:tempUser.userId newNick:tempUser.userInfo.nickName inTeam:teamId completion:^(NSError * _Nullable error) {
                  NSLog(@"%@群昵称更新成功", tempUser.userInfo.nickName);
                }];
              }
            } else {
              NSLog(@"获取群成员信息失败");
            }
          }];
        }
      }];
      
    } failure:^(id data) {
      NSLog(@"上传group头像失败");
      [XKHudView hideHUDForView:nil animated:YES];
      [XKHudView showErrorMessage:@"创建失败"];
    }];
  }];
  
  
}

+(BOOL)isDefaultTeamName:(NSString *)name{
  return [name isContainString:@"[$*$]"];
}

+ (void)updateTeamAvatar:(NSString *)teamId {
  [[NIMSDK sharedSDK].teamManager fetchTeamMembersFromServer:teamId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
    if (!error) {
      NSMutableArray *userIds = [NSMutableArray array];
      for (NIMTeamMember *tempMember in members) {
        [userIds addObject:tempMember.userId];
      }
      [self modifyTeamAvatarWithUserIDArr:userIds teamID:teamId];
    }
  }];
}

+(void)modifyTeamAvatarWithUserIDArr:(NSArray *)userIDArr teamID:(NSString *)teamID{
  [[NIMSDK sharedSDK].userManager fetchUserInfos:userIDArr completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
    NSMutableArray *memberNameArr= [NSMutableArray array];
    NSMutableArray *memberAvatorArr = [NSMutableArray array];
    
    for (NIMUser *user in users) {
      [memberNameArr addObject:user.userInfo.nickName];
      [memberAvatorArr addObject:user.userInfo.avatarUrl];
    }
    
    UIImage *groupAvator = [UIImage groupIconWithURLArray:memberAvatorArr bgColor:UIColorFromRGB(0xf1f1f1)];
    [[XKUploadManager shareManager]uploadImage:groupAvator withKey:@"XKIM_GroupAvator" progress:nil success:^(NSString *url) {
      [[NIMSDK sharedSDK].teamManager updateTeamAvatar:kQNPrefix(url) teamId:teamID completion:^(NSError * _Nullable error) {
        if (!error) {
          NSLog(@"修改头像成功");
        } else {
          NSLog(@"修改头像失败：%@", error.localizedDescription);
        }
      }];
    } failure:^(id data) {
      NSLog(@"上传group头像失败");
    }];
  }];
}

+ (void)modifyTeamAvatarWithUserIDArr:(NSArray *)userIDArr
                               teamID:(NSString *)teamID
                         succeedBlock:(void (^)(NSString *avatarUrl))succeedBlock
                          failedBlock:(void (^)(void))failedBlock {
  [[NIMSDK sharedSDK].userManager fetchUserInfos:userIDArr completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
    NSMutableArray *memberNameArr= [NSMutableArray array];
    NSMutableArray *memberAvatorArr = [NSMutableArray array];
    
    for (NIMUser *user in users) {
      [memberNameArr addObject:user.userInfo.nickName];
      [memberAvatorArr addObject:user.userInfo.avatarUrl];
    }
    
    UIImage *groupAvator = [UIImage groupIconWithURLArray:memberAvatorArr bgColor:UIColorFromRGB(0xf1f1f1)];
    [[XKUploadManager shareManager]uploadImage:groupAvator withKey:@"XKIM_GroupAvator" progress:nil success:^(NSString *url) {
      [[NIMSDK sharedSDK].teamManager updateTeamAvatar:kQNPrefix(url) teamId:teamID completion:^(NSError * _Nullable error) {
        if (!error) {
          NSLog(@"修改头像成功");
          if (succeedBlock) {
            succeedBlock(kQNPrefix(url));
          }
        } else {
          NSLog(@"修改头像失败：%@", error.localizedDescription);
          if (failedBlock) {
            failedBlock();
          }
        }
      }];
    } failure:^(id data) {
      NSLog(@"上传group头像失败");
      if (failedBlock) {
        failedBlock();
      }
    }];
  }];
}

+(void)getTeamNameWithTeamID:(NIMTeam *)team complete:(void(^)(NSString *nameString))complete{
  if (team.teamName) {
    if ([self isDefaultTeamName:team.teamName]) {
      complete([team.teamName stringByReplacingOccurrencesOfString:@"[$*$]" withString:@""]);
    }else{
      complete(team.teamName);
    }
  }
  else{
    [[NIMSDK sharedSDK].teamManager fetchTeamMembers:team.teamId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
      NSMutableArray *userIDArr = [NSMutableArray array];
      for (NIMTeamMember *member in members) {
        [userIDArr addObject:member.userId];
      }
      [[NIMSDK sharedSDK].userManager fetchUserInfos:userIDArr completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        if (!error) {
          NSMutableArray *nameArr = [[NSMutableArray alloc]init];
          for (NIMUser *user in users) {
            [nameArr addObject:user.userInfo.nickName];
          }
          complete([nameArr componentsJoinedByString:@"、"]);
        }
        else{
          complete(@"未知");
        }
      }];
    }];
  }
}

+(void)getTeamListWithTeamName:(NSString *)teamName complete:(void(^)(NSArray <NIMTeam *>*teams))complete{
    NSMutableArray *teamArr = [NSMutableArray array];
    NSArray *recentSessionArr = [[NIMSDK sharedSDK].conversationManager allRecentSessions];
    for (NIMRecentSession* recentSession in recentSessionArr) {
        if (recentSession.session.sessionType == NIMSessionTypeTeam) {
            NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recentSession.session.sessionId];
            if ([team.teamName containsString:teamName]) {
                [teamArr addObject:team];
            }
        }
    }
    complete(teamArr);
}
@end
