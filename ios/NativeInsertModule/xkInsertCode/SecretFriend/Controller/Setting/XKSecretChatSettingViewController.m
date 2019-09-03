//
//  XKSecretChatSettingViewController.m
//  XKSquare
//
//  Created by william on 2018/11/20.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKSecretChatSettingViewController.h"
#import "XKPersonDetailInfoViewController.h"
#import "XKContactListController.h"
#import "XKIMTeamChatManager.h"
#import "XKMessageChatHistoryViewController.h"
#import "XKDataBase.h"
#import "XKTransformHelper.h"
#import "XKGroupManageController.h"
#import "XKFriendshipManager.h"
#import "XKSecretFrientManager.h"
#import "XKSettingUserComplainController.h"
#import "XKSecretContactCacheManager.h"
#import "XKGuidanceManager.h"
#import "XKGuidanceView.h"

@interface XKSecretChatSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView    *mainTableView;

@property (nonatomic,strong) NSArray        *cellNameArr;

@property (nonatomic,strong) UILabel        *groupLabel;

@property (nonatomic,strong) UISwitch       *topChatSwitch;

@property (nonatomic,strong) UISwitch       *silenceSwitch;

@property (nonatomic,strong) UISwitch       *fireMessageMyselfSwitch;

@property (nonatomic,strong) UISwitch       *fireMessageOtherSwitch;

@property (nonatomic,copy) NSString         *curentGroupID;

/**阅后即删：对方 (我发出的消息)cell*/
@property(nonatomic, strong) UITableViewCell *currentGuidanceCell1;

/**"阅后即删：自己 (我发出的信息)"cell*/
@property(nonatomic, strong) UITableViewCell *currentGuidanceCell2;
@end

@implementation XKSecretChatSettingViewController


#pragma mark – Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellNameArr = @[@[@"空白"],@[@"阅后即删：对方 (我发出的消息)",@"阅后即删：自己 (我发出的信息)",@"分组",@"置顶聊天",@"消息静音",@"查找聊天记录",@"清空聊天记录",@"投诉"]];
    _curentGroupID = [NSString string];
    [self cofigViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setData];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSArray *TransparentRectArr = @[[NSValue valueWithCGRect:self.currentGuidanceCell1.getWindowFrame],[NSValue valueWithCGRect:self.currentGuidanceCell2.getWindowFrame]];
  //添加引导视图
  [XKGuidanceManager configShowGuidanceViewType:XKGuidanceManagerXKSecretChatSettingViewController TransparentRectArr:TransparentRectArr];
  
}
#pragma mark – Private Methods
-(void)cofigViews{
    [self setNavTitle:@"聊天设置" WithColor:[UIColor whiteColor]];
    self.navStyle = BaseNavWhiteStyle;
    [self hideNavigationSeperateLine];
    [self.view addSubview:self.mainTableView];
    
}

-(UIView *)getLineView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH - 20, 1)];
    view.backgroundColor  = UIColorFromRGB(0xf1f1f1);
    return view;
}

-(void)setData{
    XKWeakSelf(weakSelf);
    
    //判断是否静音
    if ([[XKDataBase instance]existsTable:XKIMSecretSilenceChatDataBaseTable]) {
        NSString *jsonString = [[XKDataBase instance]select:XKIMSecretSilenceChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        if (idArr && idArr.count > 0) {
            if ([idArr containsObject:_session.sessionId]) {
                [self.silenceSwitch setOn:YES animated:YES];
            }
        }
    }
    
    //判断是否置顶
    if ([[XKDataBase instance]existsTable:XKIMSecretTopChatDataBaseTable]) {
        NSString *jsonString = [[XKDataBase instance]select:XKIMSecretTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        if (idArr && idArr.count > 0) {
            if ([idArr containsObject:_session.sessionId]) {
                [self.topChatSwitch setOn:YES animated:YES];
            }
        }
    }
    
    
    //判断阅后即焚对方
    if ([[XKDataBase instance]existsTable:XKIMSecretMessageFireOtherDataBaseTable]) {
        NSString *jsonString = [[XKDataBase instance]select:XKIMSecretMessageFireOtherDataBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        if (idArr && idArr.count > 0) {
            if ([idArr containsObject:_session.sessionId]) {
                [self.fireMessageOtherSwitch setOn:YES animated:YES];
            }
        }
    }
    
    //判断阅后即焚自己
    if ([[XKDataBase instance]existsTable:XKIMSecretMessageFireMyselfDataBaseTable]) {
        NSString *jsonString = [[XKDataBase instance]select:XKIMSecretMessageFireMyselfDataBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        if (idArr && idArr.count > 0) {
            if ([idArr containsObject:_session.sessionId]) {
                [self.fireMessageMyselfSwitch setOn:YES animated:YES];
            }
        }
    }
    
    [HTTPClient postEncryptRequestWithURLString:@"im/ua/chatSettingQuery/1.0"
                                timeoutInterval:10
                                     parameters:@{@"userId":[XKUserInfo getCurrentUserId],@"rid":_session.sessionId}
                                        success:^(id responseObject) {
                                            
                                            NSDictionary *dict = [XKTransformHelper dictByJsonString:[NSString stringWithFormat:@"%@",responseObject]];
                                            if (dict[@"friendGroupName"]) {
                                                weakSelf.groupLabel.text = dict[@"secretGroupName"];
                                                weakSelf.curentGroupID = dict[@"secretGroupId"];
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
    cell.textLabel.text = _cellNameArr[indexPath.section][indexPath.row];
    cell.textLabel.font = XKRegularFont(14);
    if (indexPath.section == 0) {
        cell.xk_clipType = XKCornerClipTypeAllCorners;
        [cell addSubview:[self getAvatarView]];
    }
    if ([cell.textLabel.text isEqualToString:@"阅后即删：对方 (我发出的消息)"]) {
        cell.xk_clipType = XKCornerClipTypeTopBoth;
        [cell addSubview:self.fireMessageOtherSwitch];
        [cell addSubview: [self getLineView]];
        [_fireMessageOtherSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.right.mas_equalTo(cell.mas_right).offset(-15 * ScreenScale);
        }];
      self.currentGuidanceCell1 = cell;
    }
    if ([cell.textLabel.text isEqualToString:@"阅后即删：自己 (我发出的信息)"]) {
        [cell addSubview:self.fireMessageMyselfSwitch];
        [cell addSubview: [self getLineView]];
        [_fireMessageMyselfSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.right.mas_equalTo(cell.mas_right).offset(-15 * ScreenScale);
        }];
      self.currentGuidanceCell2 = cell;
    }
    if ([cell.textLabel.text isEqualToString:@"分组"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell addSubview:self.groupLabel];
        [cell addSubview: [self getLineView]];
        [_groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.right.mas_equalTo(cell.mas_right).offset(-40 * ScreenScale);
            make.height.mas_equalTo(20);
        }];
    }
    if ([cell.textLabel.text isEqualToString:@"置顶聊天"]) {
        [cell addSubview:self.topChatSwitch];
        [cell addSubview: [self getLineView]];
        [_topChatSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.right.mas_equalTo(cell.mas_right).offset(-15 * ScreenScale);
        }];
    }
    if ([cell.textLabel.text isEqualToString:@"消息静音"]) {
        [cell addSubview:self.silenceSwitch];
        [cell addSubview: [self getLineView]];
        [_silenceSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.right.mas_equalTo(cell.mas_right).offset(-15 * ScreenScale);
        }];
    }
    if ([cell.textLabel.text isEqualToString:@"查找聊天记录"]) {
        [cell addSubview: [self getLineView]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if ([cell.textLabel.text isEqualToString:@"清空聊天记录"]) {
        [cell addSubview: [self getLineView]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if ([cell.textLabel.text isEqualToString:@"投诉"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.xk_clipType = XKCornerClipTypeBottomBoth;
    }
   
    
    return cell;
}
#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _cellNameArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _cellNameArr[section];
    return arr.count;
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
            [self cleanSecretChatHistory];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertCon addAction:confirmAction];
        [alertCon addAction:cancelAction];
        [self presentViewController:alertCon animated:YES completion:nil];
        return;
    }
    if ([cell.textLabel.text isEqualToString:@"查找聊天记录"]) {
        XKMessageChatHistoryViewController * vc = [[XKMessageChatHistoryViewController alloc]init];
        vc.session = self.session;
        vc.secretID = self.secretID;
      [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([cell.textLabel.text isEqualToString:@"分组"]) {
        NSString *orginGroupId = _curentGroupID;
        XKGroupManageController *vc = [[XKGroupManageController alloc] init];
        vc.userType = 1;
        vc.defaultGroupId = orginGroupId;
        vc.isSecret = YES;
        vc.secretId = _secretID;
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
    if ([cell.textLabel.text isEqualToString:@"投诉"]) {
        XKSettingUserComplainController *vc = [XKSettingUserComplainController new];
        vc.isSecret = YES;
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
    XKContactModel *model = [XKSecretContactCacheManager queryContactWithUserId:self.session.sessionId];
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
    
    
//    UIButton *addButton = [[UIButton alloc]init];
//    [addButton setBackgroundImage:[UIImage imageNamed:@"xk_btn_friendsCirclePermissions_add"] forState:UIControlStateNormal];
//    addButton.xk_openClip = YES;
//    addButton.xk_radius = 8;
//    addButton.xk_clipType = XKCornerClipTypeAllCorners;
//    [view addSubview:addButton];
//    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(firstImageView.mas_right).offset(10);
//        make.centerY.mas_equalTo(view.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(60 * ScreenScale, 60 * ScreenScale));
//    }];
//    [addButton addTarget:self action:@selector(addTeamChat:) forControlEvents:UIControlEventTouchUpInside];
    
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

-(UISwitch *)fireMessageOtherSwitch{
    if (!_fireMessageOtherSwitch) {
        _fireMessageOtherSwitch = [[UISwitch alloc]init];
        [_fireMessageOtherSwitch addTarget:self action:@selector(fireMessageOtherSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _fireMessageOtherSwitch;
}

-(UISwitch *)fireMessageMyselfSwitch{
    if (!_fireMessageMyselfSwitch) {
        _fireMessageMyselfSwitch = [[UISwitch alloc]init];
        [_fireMessageMyselfSwitch addTarget:self action:@selector(fireMessageMyselfSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _fireMessageMyselfSwitch;
}
#pragma mark - Events
-(void)silenceSwitchAction:(UISwitch *)sender{
    if (sender.on) {
        NSLog(@"静音");
        if ([[XKDataBase instance]existsTable:XKIMSecretSilenceChatDataBaseTable]) {
            NSString *jsonString = [[XKDataBase instance]select:XKIMSecretSilenceChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
            NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
            NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
            [idMuArr addObject:_session.sessionId];
            BOOL success =  [[XKDataBase instance]replace:XKIMSecretSilenceChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
            NSLog(@"%d",success);
        }
        else{
            if ([[XKDataBase instance]createTable:XKIMSecretSilenceChatDataBaseTable]) {
                NSMutableArray *idArr = [NSMutableArray array];
                [idArr addObject: _session.sessionId];
                BOOL success =  [[XKDataBase instance]replace:XKIMSecretSilenceChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idArr yy_modelToJSONString]];
                NSLog(@"%d",success);
            }
        }
    }
    else{
        NSLog(@"取消静音");
        NSString *jsonString = [[XKDataBase instance]select:XKIMSecretSilenceChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
        [idMuArr removeObject:_session.sessionId];
        BOOL success =  [[XKDataBase instance]replace:XKIMSecretSilenceChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
        NSLog(@"%d",success);
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:XKSecretChatListViewControllerrRefreshDataNotification object:nil];
}

-(void)topChatSwitchAction:(UISwitch *)sender{
    if (sender.on) {
        NSLog(@"置顶");
        if ([[XKDataBase instance]existsTable:XKIMSecretTopChatDataBaseTable]) {
            NSString *jsonString = [[XKDataBase instance]select:XKIMSecretTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
            NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
            NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
            [idMuArr addObject:_session.sessionId];
            BOOL success =  [[XKDataBase instance]replace:XKIMSecretTopChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
            NSLog(@"%d",success);
        }
        else{
            if ([[XKDataBase instance]createTable:XKIMSecretTopChatDataBaseTable]) {
                NSMutableArray *idArr = [NSMutableArray array];
                [idArr addObject: _session.sessionId];
                BOOL success =  [[XKDataBase instance]replace:XKIMSecretTopChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idArr yy_modelToJSONString]];
                NSLog(@"%d",success);
            }
        }
    }
    else{
        NSLog(@"取消置顶");
        NSString *jsonString = [[XKDataBase instance]select:XKIMSecretTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
        [idMuArr removeObject:_session.sessionId];
        BOOL success =  [[XKDataBase instance]replace:XKIMSecretTopChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
        NSLog(@"%d",success);
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:XKSecretChatListViewControllerrRefreshDataNotification object:nil];
    
}

-(void)fireMessageOtherSwitchAction:(UISwitch *)sender{
    if (sender.on) {
        NSLog(@"fire对方");
        if ([[XKDataBase instance]existsTable:XKIMSecretMessageFireOtherDataBaseTable]) {
            NSString *jsonString = [[XKDataBase instance]select:XKIMSecretMessageFireOtherDataBaseTable key:[XKUserInfo getCurrentUserId]];
            NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
            NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
            [idMuArr addObject:_session.sessionId];
            BOOL success =  [[XKDataBase instance]replace:XKIMSecretMessageFireOtherDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
            NSLog(@"%d",success);
        }
        else{
            if ([[XKDataBase instance]createTable:XKIMSecretMessageFireOtherDataBaseTable]) {
                NSMutableArray *idArr = [NSMutableArray array];
                [idArr addObject: _session.sessionId];
                BOOL success =  [[XKDataBase instance]replace:XKIMSecretMessageFireOtherDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idArr yy_modelToJSONString]];
                NSLog(@"%d",success);
            }
        }
    }
    else{
        NSLog(@"取消fire对方");
        NSString *jsonString = [[XKDataBase instance]select:XKIMSecretMessageFireOtherDataBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
        [idMuArr removeObject:_session.sessionId];
        BOOL success =  [[XKDataBase instance]replace:XKIMSecretMessageFireOtherDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
        NSLog(@"%d",success);
    }
}

-(void)fireMessageMyselfSwitchAction:(UISwitch *)sender{
    if (sender.on) {
        NSLog(@"fire自己");
        if ([[XKDataBase instance]existsTable:XKIMSecretMessageFireMyselfDataBaseTable]) {
            NSString *jsonString = [[XKDataBase instance]select:XKIMSecretMessageFireMyselfDataBaseTable key:[XKUserInfo getCurrentUserId]];
            NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
            NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
            [idMuArr addObject:_session.sessionId];
            BOOL success =  [[XKDataBase instance]replace:XKIMSecretMessageFireMyselfDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
            NSLog(@"%d",success);
        }
        else{
            if ([[XKDataBase instance]createTable:XKIMSecretMessageFireMyselfDataBaseTable]) {
                NSMutableArray *idArr = [NSMutableArray array];
                [idArr addObject: _session.sessionId];
                BOOL success =  [[XKDataBase instance]replace:XKIMSecretMessageFireMyselfDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idArr yy_modelToJSONString]];
                NSLog(@"%d",success);
            }
        }
    }
    else{
        NSLog(@"取消fire自己");
        NSString *jsonString = [[XKDataBase instance]select:XKIMSecretMessageFireMyselfDataBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
        [idMuArr removeObject:_session.sessionId];
        BOOL success =  [[XKDataBase instance]replace:XKIMSecretMessageFireMyselfDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
        NSLog(@"%d",success);
    }
}
-(void)gotoPersonInfo:(UITapGestureRecognizer *)tap{
    XKPersonDetailInfoViewController *vc = [[XKPersonDetailInfoViewController alloc]init];
    vc.userId = _session.sessionId;
    vc.isSecret = YES;
    vc.secretId = _secretID;
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

//清除密友聊天记录
-(void)cleanSecretChatHistory{
    [XKHudView showLoadingMessage:@"" to:self.view animated:YES];
    
    [XKSecretFrientManager deleteAllSecretChatHistoryInSession:_session complete:^(BOOL success) {
        if (success) {
            [XKHudView hideAllHud];
            [[NSNotificationCenter defaultCenter] postNotificationName:XKIMBaseChatViewControllrtRefreshViewNotification object:nil];
            [XKHudView showSuccessMessage:@"删除成功"];
        }
    }];
}
@end
