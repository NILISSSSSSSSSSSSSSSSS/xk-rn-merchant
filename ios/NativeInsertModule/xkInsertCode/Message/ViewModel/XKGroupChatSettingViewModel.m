/*******************************************************************************
 # File        : XKGroupChatSettingViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/29
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGroupChatSettingViewModel.h"
#import "XKPersonDetailInfoViewController.h"
#import "XKArrowTableViewCell.h"
#import "XKSwitchTableViewCell.h"
#import "XKContactCacheManager.h"
#import "XKUserChooseController.h"
#import "XKChangeNicknameViewController.h"
#import "XKGroupQRCodeController.h"
#import "XKTransformHelper.h"
#import "XKMessageChatHistoryViewController.h"
#import "XKSettingUserComplainController.h"
#import "XKContactListController.h"
#import "XKIMTeamChatManager.h"
#import "XKGroupChatSettingInviteViewController.h"
#import "XKGroupFileController.h"
static NSString *SettingForGroupName = @"群聊名称";
static NSString *SettingForQRCode = @"群二维码";
static NSString *SettingForGroupHistory = @"查看群聊天记录";
static NSString *SettingForMyNickName = @"我在本群的昵称";
static NSString *SettingForShowMemberNickName = @"显示成员昵称";
static NSString *SetttingForTop = @"置顶聊天";
static NSString *SetttingForMsgSlience = @"消息静音";
static NSString *SetttingForInvite = @"邀请分号";
static NSString *SetttingForTransferAuth = @"移交群管理权";
static NSString *SetttingForCleanHistory = @"清空聊天记录";
static NSString *SetttingForReport = @"投诉";
static NSString *SetttingForFile = @"群文件列表";

@interface XKGroupChatSettingViewModel()
/**<##>*/
@property(nonatomic, weak) UITableView *tableView;
/**数据源*/
@property(nonatomic, copy) NSArray *dataArray;
/**<##>*/
@property(nonatomic, strong) XKGroupChatSettingModel *settingModel;
@end

@implementation XKGroupChatSettingViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDefault];
    }
    return self;
}

- (void)createDefault {
    [self resetDataArray];
    [self configGroupSettingModel];
    
}

- (void)resetDataArray {
  // 按照不同的情况 配置数组  比如群主才有移交
  // 这里有切换逻辑
  if (self.isOffical) {
    //if ([XKUserInfo currentUser].isAdmin && self.settingModel.isManager) { // 是联盟商 并且是管理员就阔以拉分号
       if ([XKUserInfo currentUser].isAdmin) { // 是联盟商  不管是不是管理员都可以拉分号
      _dataArray = @[@[SettingForGroupName,SettingForQRCode,SettingForGroupHistory,SettingForMyNickName,SettingForShowMemberNickName,SetttingForTop,SetttingForMsgSlience,SetttingForInvite,SetttingForFile,SetttingForCleanHistory,SetttingForReport]];
    } else {
      _dataArray = @[@[SettingForGroupName,SettingForQRCode,SettingForGroupHistory,SettingForMyNickName,SettingForShowMemberNickName,SetttingForTop,SetttingForMsgSlience,SetttingForFile,SetttingForCleanHistory,SetttingForReport]];
    }
  } else {
    
    if (self.settingModel.isOwner) {
      _dataArray = @[@[SettingForGroupName,SettingForQRCode,SettingForGroupHistory,SettingForMyNickName,SettingForShowMemberNickName,SetttingForTop,SetttingForMsgSlience,SetttingForTransferAuth,SetttingForCleanHistory,SetttingForReport]];
    } else {
      _dataArray = @[@[SettingForGroupName,SettingForQRCode,SettingForGroupHistory,SettingForMyNickName,SettingForShowMemberNickName,SetttingForTop,SetttingForMsgSlience,SetttingForCleanHistory,SetttingForReport]];
    }
  }
}
#pragma mark - 初始时配置设置model
- (void)configGroupSettingModel {
    _settingModel = [XKGroupChatSettingModel new];
}

- (void)registerCellForTableView:(UITableView *)tableView {
    // 注册cell
    [tableView registerClass:[XKArrowTableViewCell class] forCellReuseIdentifier:@"arrow"];
    [tableView registerClass:[XKSwitchTableViewCell class] forCellReuseIdentifier:@"switch"];
}

#pragma mark - 重新构建collectionView数据源
- (void)rebuildUserAndAddDeleteArray {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_settingModel.userArray];
    
    NSMutableArray *addDeleteArr = @[].mutableCopy;
  
    if (self.isOffical == NO) {
      [addDeleteArr addObject:@"add"];
      if (_settingModel.isOwner) {
        [addDeleteArr addObject:@"delete"];
      }
    }
    NSInteger maxNum = kItemLines * kItemLineNum - addDeleteArr.count;
    _hasMoreUser = NO;
    if (arr.count > maxNum) {
        arr = [arr subarrayWithRange:NSMakeRange(0, maxNum)].mutableCopy;
        _hasMoreUser = YES;
    }
    [arr addObjectsFromArray:addDeleteArr];
    _userAndAddDeleteArray = arr.copy;
}

- (void)rebuildTotalUserAndAddDeleteArray {

  NSMutableArray *arr = [NSMutableArray arrayWithArray:_settingModel.userArray];
  NSMutableArray *addDeleteArr = @[].mutableCopy;
  if (self.isOffical == NO) {
    [addDeleteArr addObject:@"add"];
    if (_settingModel.isOwner) {
      [addDeleteArr addObject:@"delete"];
    }
  }
  [arr addObjectsFromArray:addDeleteArr];
  _totalUserAndAddDeleteArray = arr.copy;
}

#pragma mark - 获取设置相关的数据
- (void)requestSettingInfoComplete:(void (^)(NSString *, id))complete {
    
    XKWeakSelf(weakSelf);
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:_session.sessionId];
    
  if ([XKIMTeamChatManager isDefaultTeamName:team.teamName]) {
    _settingModel.groupName = nil;
  }else{
    _settingModel.groupName = team.teamName;
  }

    _settingModel.groupQRCode = _session.sessionId;
    _settingModel.groupIcon = team.avatarUrl;
    _settingModel.msgSlience = team.notifyStateForNewMsg == NIMTeamNotifyStateNone ? YES:NO;
    if ([team.owner isEqualToString:[XKUserInfo getCurrentIMUserID]]) {
        _settingModel.isOwner = YES;
    }
    else{
        _settingModel.isOwner = NO;
    }
    
    //判断是否置顶
    if ([[XKDataBase instance]existsTable:XKIMTeamTopChatDataBaseTable]) {
        NSString *jsonString = [[XKDataBase instance]select:XKIMTeamTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        if (idArr && idArr.count > 0) {
            if ([idArr containsObject:_session.sessionId]) {
                _settingModel.topChat = YES;
            }
        }
    }
    //判断是否显示群昵称
    //判断是否置顶
    if ([[XKDataBase instance]existsTable:XKIMTeamChatShowNickNameBaseTable]) {
        NSString *jsonString = [[XKDataBase instance]select:XKIMTeamChatShowNickNameBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        if (idArr && idArr.count > 0) {
            if ([idArr containsObject:_session.sessionId]) {
                _settingModel.showNickName = YES;
            }
        }
    }
    
    //获取群成员信息
  
  if (self.isOffical) { // 如果是官方群 
    [[NIMSDK sharedSDK].teamManager fetchTeamMembersFromServer:team.teamId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
      
      NSMutableArray *memberIDArr = [NSMutableArray array];
      NSMutableDictionary *cacheDic = @{}.mutableCopy;
      for (NIMTeamMember *member in members) {
        [memberIDArr addObject:member.userId];
        cacheDic[member.userId] = member;
        if ([member.userId isEqualToString:[XKUserInfo getCurrentIMUserID]]) {
          if (member.type == NIMTeamMemberTypeManager) {
            weakSelf.settingModel.isManager = YES;
          } else {
            weakSelf.settingModel.isManager = NO;
          }
        }
      }
      [self resetDataArray];
      
      //获取群成员个人信息
      [[NIMSDK sharedSDK].userManager fetchUserInfos:memberIDArr completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        NSMutableArray *arr = @[].mutableCopy;
        //
        for (NIMUser *user in users) {
          if ([user.userId isEqualToString:[XKUserInfo getCurrentIMUserID]]) {
            weakSelf.settingModel.myNickName = user.userInfo.nickName;
          }
          XKContactModel *model = [[XKContactModel alloc]init];
          model.userId = user.userId;
          model.avatar = user.userInfo.avatarUrl;
          model.nickname = user.userInfo.nickName;
          [arr addObject:model];
        }
        weakSelf.settingModel.userArray = arr;
        
        weakSelf.refreshTableView();
        EXECUTE_BLOCK(complete,nil,@"");
      }];
      
    }];
  } else {
    [[NIMSDK sharedSDK].teamManager fetchTeamMembers:team.teamId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
      
      NSMutableArray *memberIDArr = [NSMutableArray array];
      NSMutableDictionary *cacheDic = @{}.mutableCopy;
      for (NIMTeamMember *member in members) {
        [memberIDArr addObject:member.userId];
        cacheDic[member.userId] = member;
        if ([member.userId isEqualToString:[XKUserInfo getCurrentIMUserID]]) {
          weakSelf.settingModel.myNickName = member.nickname;
          if (member.type == NIMTeamMemberTypeManager) {
            weakSelf.settingModel.isManager = YES;
          } else {
            weakSelf.settingModel.isManager = NO;
          }
        }
      }
      
      //获取群成员个人信息
      [[NIMSDK sharedSDK].userManager fetchUserInfos:memberIDArr completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        NSMutableArray *arr = @[].mutableCopy;
        for (NIMUser *user in users) {
          XKContactModel *model = [[XKContactModel alloc]init];
          NIMTeamMember *member = [[NIMSDK sharedSDK].teamManager teamMember:user.userId inTeam:team.teamId];
          model.userId = user.userId;
          model.avatar = user.userInfo.avatarUrl;
          model.nickname = member.nickname ? member.nickname:user.userInfo.nickName;
          [arr addObject:model];
        }
        weakSelf.settingModel.userArray = arr;
        
        weakSelf.refreshTableView();
        EXECUTE_BLOCK(complete,nil,@"");
      }];
      
    }];
  }
    weakSelf.refreshTableView();
}

#pragma mark - 配置cell
- (UITableViewCell *)configCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    NSString *cellType = self.dataArray[indexPath.section][indexPath.row];
    if ([cellType isEqualToString:SettingForGroupName]) {
        XKArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"arrow" forIndexPath:indexPath];
        cell.arrowView.titleLabel.text = cellType;
        cell.arrowView.detailLabel.text = _settingModel.groupName.length == 0 ? @"未命名" : _settingModel.groupName;
      if (self.isOffical) {
        cell.arrowView.arrowImgView.hidden = YES;
      }
        return cell;
    } else if ([cellType isEqualToString:SettingForQRCode]) {
        XKArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"arrow" forIndexPath:indexPath];
        cell.arrowView.titleLabel.text = cellType;
        [cell.arrowView.detailLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.appendImage(IMG_NAME(@"xk_btn_QR"));
        }];
        return cell;
    } else if ([cellType isEqualToString:SettingForGroupHistory]) {
        XKArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"arrow" forIndexPath:indexPath];
        cell.arrowView.titleLabel.text = cellType;
        return cell;
    }  else if ([cellType isEqualToString:SettingForMyNickName]) {
        XKArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"arrow" forIndexPath:indexPath];
        cell.arrowView.titleLabel.text = cellType;
        cell.arrowView.detailLabel.text = _settingModel.myNickName?_settingModel.myNickName:@"未设置";
      if (self.isOffical) {
        cell.arrowView.arrowImgView.hidden = YES;
      }
        return cell;
    }  else if ([cellType isEqualToString:SettingForShowMemberNickName]) {
        XKSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switch" forIndexPath:indexPath];
        cell.switchView.titleLabel.text = cellType;
        cell.switchView.mySwitch.on = _settingModel.showNickName;
        cell.switchClick = ^(BOOL isOn) {
            [weakSelf switchShowNickName];
        };
        return cell;
    } else if ([cellType isEqualToString:SetttingForTop]) {
        XKSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switch" forIndexPath:indexPath];
        cell.switchView.titleLabel.text = cellType;
        cell.switchView.mySwitch.on = _settingModel.topChat;
        cell.switchClick = ^(BOOL isOn) {
            [weakSelf switchTop];
        };
        return cell;
    } else if ([cellType isEqualToString:SetttingForMsgSlience]) {
        XKSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switch" forIndexPath:indexPath];
        cell.switchView.titleLabel.text = cellType;
        cell.switchView.mySwitch.on = _settingModel.msgSlience;
        cell.switchClick = ^(BOOL isOn) {
            [weakSelf switchMsgSlience];
        };
        return cell;
    } else if ([cellType isEqualToString:SetttingForInvite]) {
      XKArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"arrow" forIndexPath:indexPath];
      cell.arrowView.titleLabel.text = cellType;
      return cell;
    } else if ([cellType isEqualToString:SetttingForTransferAuth]) {
        XKArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"arrow" forIndexPath:indexPath];
        cell.arrowView.titleLabel.text = cellType;
        return cell;
    } else if ([cellType isEqualToString:SetttingForCleanHistory]) {
        XKArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"arrow" forIndexPath:indexPath];
        cell.arrowView.titleLabel.text = cellType;
        return cell;
    } else if ([cellType isEqualToString:SetttingForReport]) {
        XKArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"arrow" forIndexPath:indexPath];
        cell.arrowView.titleLabel.text = cellType;
        return cell;
    }   else {
      XKArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"arrow" forIndexPath:indexPath];
      cell.arrowView.titleLabel.text = cellType;
      return cell;
    }
}
- (XKGroupChatSettingModel *)getSettingModel {
    return self.settingModel;
}
#pragma mark - 事件处理

#pragma mark 改群名称
- (void)editGroupName {
  if (self.isOffical) {
    return;
  }
    __weak typeof(self) weakSelf = self;
    XKChangeNicknameViewController *vc = [XKChangeNicknameViewController new];
    vc.title = @"修改群名称";
    vc.placeHolder = @"请输入群名称";
    vc.nickName = self.settingModel.groupName;
    vc.useType = 1;
    vc.limitNum = 16;
    vc.rightBtnText = @"完成";
    vc.grayIfNoChange = YES;
    vc.forbidAutoPop = YES;
    [vc setBlock:^(NSString *nickName) {
        if (nickName && nickName.length > 0) {
            NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:weakSelf.session.sessionId];
            [[NIMSDK sharedSDK].teamManager updateTeamName:nickName teamId:team.teamId completion:^(NSError * _Nullable error) {
                if (!error) {
                    weakSelf.settingModel.groupName = nickName;
                    weakSelf.refreshTableView();
                    [weakSelf.getCurrentUIVC.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [XKHudView showErrorMessage:@"修改失败"];
                }
            }];
        }
    }];
    [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
   
}

#pragma mark 进群二维码
- (void)gotoQrCode {
    XKGroupQRCodeController *vc = [XKGroupQRCodeController new];
    vc.groupName = _settingModel.groupName;
    vc.groupQrStr = _settingModel.groupQRCode;
    vc.groupIconUrl = _settingModel.groupIcon;
    [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
}

#pragma mark 查看历史记录
- (void)watchHistory {
    XKMessageChatHistoryViewController *vc = [[XKMessageChatHistoryViewController alloc]init];
    vc.session = _session;
    [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    [[self getCurrentUIVC] presentViewController:nav animated:YES completion:nil];
}

#pragma mark 修改自己的昵称
- (void)editMyNickName {
  if (self.isOffical) {
    return;
  }
    __weak typeof(self) weakSelf = self;
    XKChangeNicknameViewController *vc = [XKChangeNicknameViewController new];
    vc.title = @"修改本群昵称";
    vc.placeHolder = @"请输入昵称";
    vc.nickName = self.settingModel.myNickName;
    vc.useType = 1;
    vc.rightBtnText = @"完成";
    vc.grayIfNoChange = YES;
    vc.forbidAutoPop = YES;
    [vc setBlock:^(NSString *nickName) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:weakSelf.session.sessionId];
        [[NIMSDK sharedSDK].teamManager updateUserNick:[XKUserInfo getCurrentIMUserID] newNick:nickName inTeam:team.teamId completion:^(NSError * _Nullable error) {
            if (!error) {
                weakSelf.settingModel.myNickName = nickName;
                weakSelf.refreshTableView();
                [weakSelf.getCurrentUIVC.navigationController popViewControllerAnimated:YES];
            }
            else{
                [XKHudView showErrorMessage:@"修改失败"];
            }
        }];
        
    }];
    [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
    
    self.refreshTableView();
}


#pragma mark 切换是否显示群昵称
- (void)switchShowNickName {
    
    if (!_settingModel.showNickName) {
        //设置显示
        if ([[XKDataBase instance]existsTable:XKIMTeamChatShowNickNameBaseTable]) {
            NSString *jsonString = [[XKDataBase instance]select:XKIMTeamChatShowNickNameBaseTable key:[XKUserInfo getCurrentUserId]];
            NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
            NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
            [idMuArr addObject:_session.sessionId];
            BOOL success =  [[XKDataBase instance]replace:XKIMTeamChatShowNickNameBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
            if (success) {
                _settingModel.showNickName = !_settingModel.showNickName;
            }
            NSLog(@"%d",success);
        }
        else{
            if ([[XKDataBase instance]createTable:XKIMTeamChatShowNickNameBaseTable]) {
                NSMutableArray *idArr = [NSMutableArray array];
                [idArr addObject: _session.sessionId];
                BOOL success =  [[XKDataBase instance]replace:XKIMTeamChatShowNickNameBaseTable key:[XKUserInfo getCurrentUserId] value:[idArr yy_modelToJSONString]];
                if (success) {
                    _settingModel.showNickName = !_settingModel.showNickName;
                }
                NSLog(@"%d",success);
            }
        }
    }
    else{
        //设置不显示
        NSString *jsonString = [[XKDataBase instance]select:XKIMTeamChatShowNickNameBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
        [idMuArr removeObject:_session.sessionId];
        BOOL success =  [[XKDataBase instance]replace:XKIMTeamChatShowNickNameBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
        if (success) {
            _settingModel.showNickName = !_settingModel.showNickName;
        }
        NSLog(@"%d",success);
    }
    self.refreshTableView();
}

#pragma mark 切换是否置顶
- (void)switchTop {
    
    if (!_settingModel.topChat) {
        NSLog(@"置顶");
        if ([[XKDataBase instance]existsTable:XKIMTeamTopChatDataBaseTable]) {
            NSString *jsonString = [[XKDataBase instance]select:XKIMTeamTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
            NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
            NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
            [idMuArr addObject:_session.sessionId];
            BOOL success =  [[XKDataBase instance]replace:XKIMTeamTopChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
            if (success) {
                _settingModel.topChat = !_settingModel.topChat;
            }
            NSLog(@"%d",success);
        }
        else{
            if ([[XKDataBase instance]createTable:XKIMTeamTopChatDataBaseTable]) {
                NSMutableArray *idArr = [NSMutableArray array];
                [idArr addObject: _session.sessionId];
                BOOL success =  [[XKDataBase instance]replace:XKIMTeamTopChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idArr yy_modelToJSONString]];
                if (success) {
                    _settingModel.topChat = !_settingModel.topChat;
                }
                NSLog(@"%d",success);
            }
        }
    }
    else{
        NSLog(@"取消置顶");
        NSString *jsonString = [[XKDataBase instance]select:XKIMTeamTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
        [idMuArr removeObject:_session.sessionId];
        BOOL success =  [[XKDataBase instance]replace:XKIMTeamTopChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
        if (success) {
            _settingModel.topChat = !_settingModel.topChat;
        }
        NSLog(@"%d",success);
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:XKTeamChatListViewControllerRefreshDataNotification object:nil];
    self.refreshTableView();
}

#pragma mark 切换是否静音
- (void)switchMsgSlience {
    XKWeakSelf(weakSelf);
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:_session.sessionId];
    [[NIMSDK sharedSDK].teamManager updateNotifyState:team.notifyStateForNewMsg == NIMTeamNotifyStateAll ? NIMTeamNotifyStateNone : NIMTeamNotifyStateAll inTeam:team.teamId completion:^(NSError * _Nullable error) {
        if (error) {
            weakSelf.refreshTableView();
        }else{
            weakSelf.settingModel.msgSlience = !weakSelf.settingModel.msgSlience;
            weakSelf.refreshTableView();
        }
    }];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:XKTeamChatListViewControllerRefreshDataNotification object:nil];
    
}

#pragma mark - 移交群管理权
- (void)transferAuth {
    XKUserChooseController *vc = [XKUserChooseController new];
    // 取到排除自己的数据
    __weak typeof(self) weakSelf = self;
    NSPredicate *pred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userId != '%@'",[XKUserInfo getCurrentUserId]]];
    NSArray *dataArray = [self.settingModel.userArray filteredArrayUsingPredicate:pred];
    vc.dataArray = dataArray;
    [vc setSureClickBlock:^(NSArray<XKContactModel *> *contacts, XKUserChooseController *listVC) {
        if (contacts.count > 0) {
            NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:weakSelf.session.sessionId];
            XKContactModel *model = contacts.firstObject;
            [[NIMSDK sharedSDK].teamManager transferManagerWithTeam:team.teamId newOwnerId:model.userId isLeave:NO completion:^(NSError * _Nullable error) {
                if (!error) {
                    [XKAlertView showCommonAlertViewWithTitle:[NSString stringWithFormat:@"权限移交给了%@",contacts.firstObject.displayName]];
                    
                    weakSelf.settingModel.isOwner = NO;
                    weakSelf.refreshTableView();
                    [listVC.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [XKHudView showErrorMessage:@"权限移交失败"];
                }
            }];
        }

    }];
    [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
}



#pragma mark 清空聊天记录
- (void)cleanHistory {
    XKWeakSelf(weakSelf);
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认清空聊天记录?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:weakSelf.session option:nil];
        [XKHudView showSuccessMessage:@"删除成功"];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertCon addAction:confirmAction];
    [alertCon addAction:cancelAction];
    [[self getCurrentUIVC] presentViewController:alertCon animated:YES completion:nil];
}

#pragma mark 投诉
- (void)report {
    XKSettingUserComplainController *vc = [[XKSettingUserComplainController alloc]init];
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark 官方群拉分号
- (void)manangerInvite {
  if (!self.isOffical) {
    return;
  }
  if (self.settingModel.isManager == NO) {
    [XKHudView showTipMessage:@"您不是管理员无法邀请分号"];
    return;
  }
  // 邀请分号
  __weak typeof(self) weakSelf = self;
  XKGroupChatSettingInviteViewController *vc = [XKGroupChatSettingInviteViewController new];
  vc.teamId = _session.sessionId;
  vc.merchantType = self.merchantType;
  [vc setUserListChange:^{
    [weakSelf requestSettingInfoComplete:^(NSString *error, id data) {
      [weakSelf.delegate refreshTableView];
    }];
  }];
  [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark - 用户点击 删除 添加事件
- (void)dealCollectionViewClick:(NSIndexPath *)indexPath dataArray:(NSArray *)userAndAddDeleteArray vc:(UIViewController *)controller {
    
    __weak typeof(self) weakSelf = self;
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:_session.sessionId];
    NSString * model = userAndAddDeleteArray[indexPath.row];
    if ([model isKindOfClass:[NSString class]]) {
        if ([model isEqualToString:@"add"]) {
            
            XKContactListController *vc = [XKContactListController new];
            vc.defaultIsGray = YES;
            vc.useType = XKContactUseTypeManySelect;
            vc.sureBtnIsGrayWhenNoChoose = YES;
            vc.defaultSelected = [self getSettingModel].userArray;
            vc.showSelectedNum = YES;
            vc.rightButtonText = @"完成";
            vc.title = @"选择联系人";
            [vc setSureClickBlock:^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
                
                NSMutableArray *arr = [NSMutableArray array];
                for (XKContactModel *model in contacts) {
                    [arr addObject:model.userId];
                }
                
                [[NIMSDK sharedSDK].teamManager addUsers:arr toTeam:team.teamId postscript:@"" completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
                    if (!error) {
                        NSMutableArray *arr1 = [self getSettingModel].userArray;
                        [arr1 addObjectsFromArray:contacts];
                        NSMutableArray *idaArr = [NSMutableArray array];
                        for (XKContactModel *model in arr1) {
                            [idaArr addObject:model.userId];
                        }
                        //添加后修改
                        [XKIMTeamChatManager modifyTeamAvatarWithUserIDArr:idaArr teamID:team.teamId];
                        [controller.navigationController popViewControllerAnimated:YES];
                        weakSelf.refreshTableView();
                        if ([self.delegate respondsToSelector:@selector(refreshTableView)]) {
                            [self.delegate refreshTableView];
                        }
                    }
                    else{
                        [XKHudView showErrorMessage:@"添加失败"];
                    }
                }];
                
                
            }];
            [controller.navigationController pushViewController:vc animated:YES];
        } else {
            XKContactListController *vc = [XKContactListController new];
            vc.useType = XKContactUseTypeUseOutDateAndManySelected;
            vc.sureBtnIsGrayWhenNoChoose = YES;
            vc.showSelectedNum = YES;
            NSMutableArray *userMutableArr = [NSMutableArray arrayWithArray:[self getSettingModel].userArray];
            for (XKContactModel *model in [self getSettingModel].userArray) {
                if ([model.userId isEqualToString: [XKUserInfo getCurrentUserId]]) {
                    [userMutableArr removeObject:model];
                }
            }
            vc.outDataArray = userMutableArr;
            vc.rightButtonText = @"删除";
            vc.title = @"删除成员";
            [vc setSureClickBlock:^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
                NSMutableArray *deleteIDArr = [NSMutableArray array];
                for (XKContactModel *model in contacts) {
                    [deleteIDArr addObject:model.userId];
                }
                [[NIMSDK sharedSDK].teamManager kickUsers:deleteIDArr fromTeam:team.teamId completion:^(NSError * _Nullable error) {
                    if (!error) {
                        NSMutableArray *arr = [self getSettingModel].userArray;
                        [arr.copy enumerateObjectsUsingBlock:^(XKContactModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            for (XKContactModel *choose in contacts) {
                                if ([choose.userId isEqualToString:obj.userId]) {
                                    [arr removeObject:obj];
                                }
                            }
                        }];
                        NSMutableArray *newAvatorIDArr = [NSMutableArray array];
                        for (XKContactModel *model in arr) {
                            [newAvatorIDArr addObject:model.userId];
                        }
                        [XKIMTeamChatManager modifyTeamAvatarWithUserIDArr:newAvatorIDArr teamID:team.teamId];
                        [controller.navigationController popViewControllerAnimated:YES];
                        weakSelf.refreshTableView();
                        if ([self.delegate respondsToSelector:@selector(refreshTableView)]) {
                            [self.delegate refreshTableView];
                        }
                    }
                    else{
                        [XKHudView showErrorMessage:@"删除失败"];
                    }
                }];
            }];
            [controller.navigationController pushViewController:vc animated:YES];
        }
    } else if ([model isKindOfClass:[XKContactModel class]]) {
      XKContactModel *user = (XKContactModel *)model;
      [self jumpPersonCenter:user];
    }
}

- (void)jumpPersonCenter:(XKContactModel *)model {
  XKContactModel *user = (XKContactModel *)model;
  XKPersonDetailInfoViewController *userVC = [XKPersonDetailInfoViewController new];
  userVC.userId = user.userId;
  if (self.isOffical && (self.settingModel.isManager || self.settingModel.isOwner)) {
    userVC.isOfficalTeam = YES;
    userVC.teamId = _session.sessionId;
  }
  [[self getCurrentUIVC].navigationController pushViewController:userVC animated:YES];
}

- (void)watchFile {
  XKGroupFileController *vc = [XKGroupFileController new];
  vc.teamId = _session.sessionId;
  [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark - 代理事件

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self configCellWithTableView:tableView indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xk_openClip = YES;
    cell.xk_radius = 8;
    if (indexPath.row == 0) {
        cell.xk_clipType = XKCornerClipTypeTopBoth;
    } else if (indexPath.row == [self.dataArray[indexPath.section] count] - 1) {
        cell.xk_clipType = XKCornerClipTypeBottomBoth;
    } else {
        cell.xk_clipType = XKCornerClipTypeNone;
    }
    return cell;
}

#pragma mark - 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = self.dataArray[indexPath.section][indexPath.row];
    if ([cellType isEqualToString:SettingForGroupName]) {
        [self editGroupName];
    } else if ([cellType isEqualToString:SettingForQRCode]) {
        [self gotoQrCode];
    } else if ([cellType isEqualToString:SettingForGroupHistory]) {
        [self watchHistory];
    } else if ([cellType isEqualToString:SettingForMyNickName]) {
      [self editMyNickName];
    } else if ([cellType isEqualToString:SetttingForTransferAuth]) {
        [self transferAuth];
    } else if ([cellType isEqualToString:SetttingForCleanHistory]) {
        [self cleanHistory];
    } else if ([cellType isEqualToString:SetttingForReport]) {
        [self report];
    } else if ([cellType isEqualToString:SetttingForInvite]) {
      [self manangerInvite];
    } else if ([cellType isEqualToString:SetttingForFile]) {
      [self watchFile];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.dataArray.count - 1) {
        return 20;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

@end

@implementation XKGroupChatSettingModel

@end
