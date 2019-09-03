/*******************************************************************************
 # File        : XKSecretFriendSettingViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/10
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSecretFriendSettingViewModel.h"
#import "XKArrowTableViewCell.h"
#import "XKSwitchTableViewCell.h"
#import "XKChangeNicknameViewController.h"
#import "XKGroupManageController.h"
#import "XKSecretFriendMoveController.h"
#import "XKSettingUserComplainController.h"

static NSString *SettingForRemark = @"设置备注";
static NSString *SettingForChangeGroup = @"修改分组";
static NSString *SettingForMoveAccout = @"迁移至其他密友账号中";
static NSString *SettingForNoSeeMy = @"不让Ta看我的可友圈";
static NSString *SettingForNoSeeTa = @"不看Ta的可友圈";
static NSString *SettingForAddBlackList = @"加入黑名单";
static NSString *SetttingForReport = @"举报";

@interface XKSecretFriendSettingViewModel ()
/**数据源*/
@property(nonatomic, copy) NSArray *dataArray;
@end

@implementation XKSecretFriendSettingViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDefault];
    }
    return self;
}

- (void)createDefault {
    _dataArray = @[@[SettingForRemark,SettingForMoveAccout],@[SettingForNoSeeMy,SettingForNoSeeTa],@[SettingForAddBlackList,SetttingForReport]];
}

- (void)registerCellForTableView:(UITableView *)tableView {
    // 注册cell
    [tableView registerClass:[XKArrowTableViewCell class] forCellReuseIdentifier:@"arrow"];
    [tableView registerClass:[XKSwitchTableViewCell class] forCellReuseIdentifier:@"switch"];
}

#pragma mark - 配置cell
- (UITableViewCell *)configCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    NSString *cellType = self.dataArray[indexPath.section][indexPath.row];
    if ([cellType isEqualToString:SettingForRemark]) {
        XKArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"arrow" forIndexPath:indexPath];
        cell.arrowView.titleLabel.text = cellType;
        cell.arrowView.detailLabel.text = self.detailInfo.secretRemark;
        return cell;
    } else if ([cellType isEqualToString:SettingForNoSeeMy]) {
        XKSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switch" forIndexPath:indexPath];
        cell.switchView.titleLabel.text = cellType;
        cell.switchView.mySwitch.on = self.detailInfo.visitMeCF;
        [cell setSwitchClick:^(BOOL isOn) {
            [weakSelf settingForNoSeeMy];
        }];
        return cell;
    } else if ([cellType isEqualToString:SettingForNoSeeTa]) {
        XKSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switch" forIndexPath:indexPath];
        cell.switchView.titleLabel.text = cellType;
        cell.switchView.mySwitch.on = self.detailInfo.visitTaCF;
        [cell setSwitchClick:^(BOOL isOn) {
            [weakSelf settingForNoSeeTa];
        }];
        return cell;
    }  else if ([cellType isEqualToString:SettingForAddBlackList]) {
        XKSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switch" forIndexPath:indexPath];
        cell.switchView.titleLabel.text = cellType;
        cell.switchView.mySwitch.on = self.detailInfo.isBlackList;
        [cell setSwitchClick:^(BOOL isOn) {
            [weakSelf settingAboutBlackList];
        }];
        return cell;
    } else if ([cellType isEqualToString:SetttingForReport]) {
        XKArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"arrow" forIndexPath:indexPath];
        cell.arrowView.titleLabel.text = cellType;
        return cell;
    } else if ([cellType isEqualToString:SettingForChangeGroup]) {
        // 没放在这里了
        XKArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"arrow" forIndexPath:indexPath];
        cell.arrowView.titleLabel.text = cellType;
        cell.arrowView.detailLabel.text = @"分组2";
        return cell;
    }  else if ([cellType isEqualToString:SettingForMoveAccout]) {
        XKArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"arrow" forIndexPath:indexPath];
        cell.arrowView.titleLabel.text = cellType;
        return cell;
    } else {
        return [tableView dequeueReusableCellWithIdentifier:@"arrow" forIndexPath:indexPath];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self configCellWithTableView:tableView indexPath:indexPath];
    cell.xk_openClip = YES;
    cell.xk_radius = 5;
    if (indexPath.row == 0) {
        cell.xk_clipType = XKCornerClipTypeTopBoth;
    } else if (indexPath.row == [self.dataArray[indexPath.section] count] - 1) {
        cell.xk_clipType = XKCornerClipTypeBottomBoth;
    } else {
        cell.xk_clipType = XKCornerClipTypeNone;
    }
    return cell;
}

#pragma mark - 请求
- (void)requestDetailComplete:(void(^)(NSString *error,id data))complete {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    params[@"rid"] = self.userId;
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/friendDetail/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        self.detailInfo = [XKFriendDetailInfo yy_modelWithJSON:responseObject];
        EXECUTE_BLOCK(complete,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}

#pragma mark - 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = self.dataArray[indexPath.section][indexPath.row];
    if ([cellType isEqualToString:SettingForRemark]) {
        [self editRemark];
    } else if ([cellType isEqualToString:SettingForChangeGroup]) {
        // 没放这里了 so逻辑没写完
        NSString *orginGroupId = @"";
        XKGroupManageController *vc = [[XKGroupManageController alloc] init];
        vc.userType = 1;
        vc.isSecret = YES;
        vc.secretId = self.secretId;
        vc.defaultGroupId = orginGroupId;
        [vc setChooseBlock:^(XKFriendGroupModel *group,XKGroupManageController *grVC) {
            if (group == nil || [group.groupId isEqualToString:orginGroupId]) {
                [grVC.navigationController popViewControllerAnimated:YES];
                return ;
            }
            [XKHudView showLoadingTo:grVC.containView animated:NO];
            [XKFriendshipManager requestChangeSecretFriendGroup:group.groupId userId:@"" withSecretId:self.secretId complete:^(NSString *error, id data) {
                [XKHudView hideHUDForView:grVC.containView];
                if (error) {
                    [XKHudView showErrorMessage:error to:grVC.containView animated:NO];
                } else {
                    [grVC.navigationController popViewControllerAnimated:YES];
                }
            }];
        }];
        [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
        return;
    } else if ([cellType isEqualToString:SettingForMoveAccout]) {
        [self settingForMoveAccout];
    } else if ([cellType isEqualToString:SetttingForReport]) {
        [self settingForReport];
    }
}

#pragma mark - 修改备注点击
- (void)editRemark {
    XKChangeNicknameViewController *editVC = [XKChangeNicknameViewController new];
    editVC.rightBtnText = @"完成";
    editVC.useType = 1;
    editVC.placeHolder = @"请输入备注";
    editVC.title = @"设置备注";
    editVC.nickName = self.detailInfo.secretRemark;
    editVC.forbidAutoPop = YES;
    WEAK_TYPES(editVC);
    [editVC setBlock:^(NSString *nickName) {
        [XKHudView showLoadingTo:weakeditVC.view animated:YES];
        [self requsetEditRemark:nickName complete:^(NSString *error, id data) {
            [XKHudView hideHUDForView:weakeditVC.view animated:NO];
            if (error) {
                [XKHudView showErrorMessage:error to:weakeditVC.view animated:YES];
            } else {
                self.detailInfo.secretRemark = nickName;
                self.refreshTableView();
                [weakeditVC.navigationController popViewControllerAnimated:YES];
                self.refreshData(); // 备注清空 会显示原本名字 so请求一下
            }
        }];
    }];
    [self.getCurrentUIVC.navigationController pushViewController:editVC animated:YES];
}

#pragma mark - 修改备注请求
- (void)requsetEditRemark:(NSString *)name complete:(void(^)(NSString *error,id data))complete {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    params[@"rid"] = self.userId;
    params[@"remarkName"] = name;
    if (self.secretId == nil) {
         EXECUTE_BLOCK(complete,@"密友圈id为空",nil);
        return;
    }
    params[@"secretId"] = self.secretId;
    [HTTPClient postEncryptRequestWithURLString:@"im/ua/friendRemarkUpdate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        EXECUTE_BLOCK(complete,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}

#pragma mark - 不让他看我的朋友圈
- (void)settingForNoSeeMy {
    BOOL allow = self.detailInfo.visitMeCF == NO ? NO : YES;
    [XKFriendshipManager requestSetFriendCircleAuthorityType:1 allow:allow friendId:self.userId complete:^(NSString *error, id data) {
        if (error) {
            [XKHudView showErrorMessage:error];
        } else {
            self.detailInfo.visitMeCF = !self.detailInfo.visitMeCF;
        }
        self.refreshTableView();
    }];
}

#pragma mark - 不看他的朋友圈
- (void)settingForNoSeeTa {
    BOOL allow = self.detailInfo.visitTaCF == NO ? NO : YES; //
    [XKFriendshipManager requestSetFriendCircleAuthorityType:0 allow:allow friendId:self.userId complete:^(NSString *error, id data) {
        if (error) {
            [XKHudView showErrorMessage:error];
        } else {
            self.detailInfo.visitTaCF = !self.detailInfo.visitTaCF;
        }
        self.refreshTableView();
    }];
}

#pragma mark - 加入移除黑名单
- (void)settingAboutBlackList {
    if (self.detailInfo.isBlackList) {
        [XKFriendshipManager requestRemoveBlackList:self.userId complete:^(NSString *error, id data) {
            if (error) {
                [XKHudView showErrorMessage:error];
            } else {
                self.detailInfo.isBlackList = !self.detailInfo.isBlackList;
            }
            self.refreshTableView();
        }];
    } else {
        [XKFriendshipManager requestAddBlackList:self.userId complete:^(NSString *error, id data) {
            if (error) {
                [XKHudView showErrorMessage:error];
            } else {
                self.detailInfo.isBlackList = !self.detailInfo.isBlackList;
            }
            self.refreshTableView();
        }];
    }
}

#pragma mark - 密友迁移
- (void)settingForMoveAccout {
    XKSecretFriendMoveController *vc = [XKSecretFriendMoveController new];
    vc.secretId = self.secretId;
    vc.userId = self.userId;
    [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 举报
- (void)settingForReport {
    XKSettingUserComplainController *vc = [XKSettingUserComplainController new];
    [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
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
