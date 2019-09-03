//
//  XKP2PChatSettingViewController.m
//  XKSquare
//
//  Created by william on 2018/10/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKP2PChatSettingViewController.h"
#import "XKPersonDetailInfoViewController.h"
#import "XKContactListController.h"
#import "XKIMTeamChatManager.h"
#import "XKMessageChatHistoryViewController.h"
#import "XKDataBase.h"
#import "XKTransformHelper.h"
#import "XKGroupManageController.h"
#import "XKFriendshipManager.h"
#import "XKIMGlobalMethod.h"
#import "XKContactCacheManager.h"
@interface XKP2PChatSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView    *mainTableView;

@property (nonatomic,strong) NSArray        *cellNameArr;

@property (nonatomic,strong) UILabel        *groupLabel;

@property (nonatomic,strong) UISwitch       *topChatSwitch;

@property (nonatomic,strong) UISwitch       *silenceSwitch;

@property (nonatomic,copy) NSString         *curentGroupID;
@end

@implementation XKP2PChatSettingViewController

#pragma mark – Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellNameArr = @[@[@"空白"],@[@"置顶聊天",@"消息免打扰",@"分组"],@[@"查找聊天记录",@"清空聊天记录"]];
    _curentGroupID = [NSString string];
    [self cofigViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setData];
}

#pragma mark – Private Methods
-(void)cofigViews{
    [self setNavTitle:@"聊天设置" WithColor:[UIColor whiteColor]];
    [self.view addSubview:self.mainTableView];

}

-(UIView *)getLineView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH - 20, 1)];
    view.backgroundColor  = UIColorFromRGB(0xf1f1f1);
    return view;
}

-(void)setData{
    XKWeakSelf(weakSelf);
    [[NIMSDK sharedSDK].userManager fetchUserInfos:@[_session.sessionId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        NIMUser *user = users[0];
        weakSelf.silenceSwitch.on = !user.notifyForNewMsg;
    }];
    
    //判断是否置顶
    if ([[XKDataBase instance]existsTable:XKIMP2PTopChatDataBaseTable]) {
        NSString *jsonString = [[XKDataBase instance]select:XKIMP2PTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        if (idArr && idArr.count > 0) {
            if ([idArr containsObject:_session.sessionId]) {
                [self.topChatSwitch setOn:YES animated:YES];
            }
        }
    }
    
    [HTTPClient postEncryptRequestWithURLString:@"im/ua/chatSettingQuery/1.0"
                                timeoutInterval:10
                                     parameters:@{@"userId":[XKUserInfo getCurrentUserId],@"rid":_session.sessionId}
                                        success:^(id responseObject) {
                                            
                                            NSDictionary *dict = [XKTransformHelper dictByJsonString:[NSString stringWithFormat:@"%@",responseObject]];
                                            if (dict[@"friendGroupName"]) {
                                                weakSelf.groupLabel.text = dict[@"friendGroupName"];
                                                weakSelf.curentGroupID = dict[@"friendGroupId"];
                                            }
    } failure:^(XKHttpErrror *error) {
        NSLog(@"")
    }];
}


#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.xk_openClip = YES;
    cell.xk_radius = 8;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:{
            cell.xk_clipType = XKCornerClipTypeAllCorners;
            [cell addSubview:[self getAvatarView]];
        }
            break;
        case 1:{
            cell.textLabel.text = _cellNameArr[1][indexPath.row];
            cell.textLabel.font = XKRegularFont(14);
            if (indexPath.row == 0) {
                cell.xk_clipType = XKCornerClipTypeTopBoth;
                [cell addSubview: [self getLineView]];
            }
            if (indexPath.row == 1) {
                [cell addSubview: [self getLineView]];

            }
            if (indexPath.row == 2) {
                cell.xk_clipType = XKCornerClipTypeBottomBoth;
            }
        }
            break;
        case 2:{
            cell.textLabel.text = _cellNameArr[2][indexPath.row];
            cell.textLabel.font = XKRegularFont(14);
            if (indexPath.row == 0) {
                cell.xk_clipType = XKCornerClipTypeTopBoth;
                [cell addSubview: [self getLineView]];
            }
            if (indexPath.row == 1) {
                cell.xk_clipType = XKCornerClipTypeBottomBoth;
            }
        }
        default:
            break;
    }
    
    if ([cell.textLabel.text isEqualToString:@"查找聊天记录"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if ([cell.textLabel.text isEqualToString:@"清空聊天记录"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if ([cell.textLabel.text isEqualToString:@"分组"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell addSubview:self.groupLabel];
        [_groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.right.mas_equalTo(cell.mas_right).offset(-30 * ScreenScale);
            make.height.mas_equalTo(20);
        }];
    }
    if ([cell.textLabel.text isEqualToString:@"置顶聊天"]) {
        [cell addSubview:self.topChatSwitch];
        [_topChatSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.right.mas_equalTo(cell.mas_right).offset(-15 * ScreenScale);
        }];
    }
    if ([cell.textLabel.text isEqualToString:@"消息免打扰"]) {
        [cell addSubview:self.silenceSwitch];
        [_silenceSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.right.mas_equalTo(cell.mas_right).offset(-15 * ScreenScale);
        }];
    }
    return cell;
}
#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _cellNameArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return 3;
    }
    else{
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90 * ScreenScale;
    }
    else{
        return 45;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000001f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    XKWeakSelf(weakSelf);
    if ([cell.textLabel.text isEqualToString:@"清空聊天记录"]) {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认清空聊天记录?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [XKIMGlobalMethod deleteAllKeFriendChatHistoryInSession:weakSelf.session deleteRecentSession:NO complete:^(BOOL success) {
                
            }];
            [XKHudView showSuccessMessage:@"删除成功"];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertCon addAction:confirmAction];
        [alertCon addAction:cancelAction];
        [self presentViewController:alertCon animated:YES completion:nil];
        return;
    }
    if ([cell.textLabel.text isEqualToString:@"查找聊天记录"]) {
      XKMessageChatHistoryViewController *vc = [[XKMessageChatHistoryViewController alloc]init];
      vc.session = _session;
      [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([cell.textLabel.text isEqualToString:@"分组"]) {
        NSString *orginGroupId = _curentGroupID;
        XKGroupManageController *vc = [[XKGroupManageController alloc] init];
        vc.userType = 1;
        vc.defaultGroupId = orginGroupId;
        [vc setChooseBlock:^(XKFriendGroupModel *group,XKGroupManageController *grVC) {
            if (group == nil || [group.groupId isEqualToString:orginGroupId]) {
                    [grVC.navigationController popViewControllerAnimated:YES];
                    return ;
            }
            [XKHudView showLoadingTo:grVC.containView animated:NO];

            [XKFriendshipManager requestChangeFriendGroup:group.groupId userId:weakSelf.session.sessionId complete:^(NSString *error, id data) {
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
    }
}

-(UIView *)getAvatarView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 90 * ScreenScale)];
    
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *firstImageView = [[UIImageView alloc]init];
    firstImageView.xk_openClip = YES;
    firstImageView.xk_radius = 8;
    firstImageView.xk_clipType = XKCornerClipTypeAllCorners;

  
  XKContactModel *model = [XKContactCacheManager queryContactWithUserId:self.session.sessionId];
  [firstImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
  

    [view addSubview:firstImageView];
    [firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(10);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60 * ScreenScale, 60 * ScreenScale));
    }];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoPersonInfo:)];
    firstImageView.userInteractionEnabled = YES;
    [firstImageView addGestureRecognizer:tapGest];
    
    
    UIButton *addButton = [[UIButton alloc]init];
    [addButton setBackgroundImage:[UIImage imageNamed:@"xk_btn_friendsCirclePermissions_add"] forState:UIControlStateNormal];
    addButton.xk_openClip = YES;
    addButton.xk_radius = 8;
    addButton.xk_clipType = XKCornerClipTypeAllCorners;
    [view addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(firstImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60 * ScreenScale, 60 * ScreenScale));
    }];
    [addButton addTarget:self action:@selector(addTeamChat:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

#pragma mark – Getters and Setters
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, NavigationAndStatue_Height, SCREEN_WIDTH - 20, SCREEN_HEIGHT - NavigationAndStatue_Height) style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = self.view.backgroundColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

-(UILabel *)groupLabel{
    if (!_groupLabel) {
        _groupLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(14) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
        _groupLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _groupLabel;
}

-(UISwitch *)topChatSwitch{
    if (!_topChatSwitch) {
        _topChatSwitch = [[UISwitch alloc]init];
        [_topChatSwitch addTarget:self action:@selector(topChatSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _topChatSwitch;
}

-(UISwitch *)silenceSwitch{
    if (!_silenceSwitch) {
        _silenceSwitch = [[UISwitch alloc]init];
        [_silenceSwitch addTarget:self action:@selector(silenceSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _silenceSwitch;
}
#pragma mark - Events
-(void)silenceSwitchAction:(UISwitch *)sender{
    BOOL oldStatus = !sender.on;
    [[NIMSDK sharedSDK].userManager updateNotifyState:!sender.on forUser:_session.sessionId completion:^(NSError * _Nullable error) {
        if (error) {
            [XKHudView showErrorMessage:@"修改失败"];
            [sender setOn:oldStatus animated:YES];
        }
    }];
    [[NSNotificationCenter defaultCenter]postNotificationName:XKFriendChatListViewControllerRefreshDataNotification object:nil];
}

-(void)topChatSwitchAction:(UISwitch *)sender{
    if (sender.on) {
        NSLog(@"置顶");
        if ([[XKDataBase instance]existsTable:XKIMP2PTopChatDataBaseTable]) {
            NSString *jsonString = [[XKDataBase instance]select:XKIMP2PTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
            NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
            NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
            [idMuArr addObject:_session.sessionId];
            BOOL success =  [[XKDataBase instance]replace:XKIMP2PTopChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
            NSLog(@"%d",success);
        }
        else{
            if ([[XKDataBase instance]createTable:XKIMP2PTopChatDataBaseTable]) {
                NSMutableArray *idArr = [NSMutableArray array];
                [idArr addObject: _session.sessionId];
                BOOL success =  [[XKDataBase instance]replace:XKIMP2PTopChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idArr yy_modelToJSONString]];
                NSLog(@"%d",success);
            }
        }
    }
    else{
        NSLog(@"取消置顶");
        NSString *jsonString = [[XKDataBase instance]select:XKIMP2PTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
        [idMuArr removeObject:_session.sessionId];
        BOOL success =  [[XKDataBase instance]replace:XKIMP2PTopChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
        NSLog(@"%d",success);
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:XKFriendChatListViewControllerRefreshDataNotification object:nil];

}

-(void)gotoPersonInfo:(UITapGestureRecognizer *)tap{
    XKPersonDetailInfoViewController *vc = [[XKPersonDetailInfoViewController alloc]init];
    vc.userId = _session.sessionId;
    vc.deleteBlock = ^(NSString *userId) {
        [[self getCurrentUIVC].navigationController popToRootViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addTeamChat:(UIButton *)sender{
    XKWeakSelf(weakSelf);
    XKContactListController *vc = [[XKContactListController alloc]init];
    vc.useType = XKContactUseTypeManySelect;
    XKContactModel *model = [[XKContactModel alloc]init];
    model.userId = weakSelf.session.sessionId;
    vc.defaultSelected = @[model];
    vc.defaultIsGray = YES;
    vc.rightButtonText = @"完成";
    vc.sureClickBlock = ^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
        NSMutableArray *UIMIDArr = [NSMutableArray array];
        [UIMIDArr addObject:[XKUserInfo getCurrentIMUserID]];
        if (contacts.count > 0) {
            for (XKContactModel *model in contacts) {
                if (model.accid && (model.accid != weakSelf.session.sessionId)) {
                    [UIMIDArr addObject:model.accid];
                }
            }
            [UIMIDArr addObject:weakSelf.session.sessionId];
            [XKIMTeamChatManager createTeamChatWithUserIDArr:[NSArray arrayWithArray:UIMIDArr]];
        }
        
    };
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
@end
