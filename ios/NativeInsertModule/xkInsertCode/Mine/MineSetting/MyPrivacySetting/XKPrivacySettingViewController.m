//
//  XKPrivacySettingViewController.m
//  XKSquare
//
//  Created by william on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPrivacySettingViewController.h"
#import "XKPrivacyCreateSecretFriendCircleViewController.h"
#import "XKPrivacyFriendsCirclePermissionsViewController.h"
#import "XKPrivacyContactBlacklistViewController.h"
#import "XKContactBlackListController.h"
#import "XKTransformHelper.h"
#import "XKBottomAlertSheetView.h"
#import "XKGuidanceManager.h"
#import "XKGuidanceView.h"

@interface XKPrivacySettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView    *mainBackTableView;

@property (nonatomic,strong) NSArray        *cellNameArr;

@property (nonatomic,strong) UISwitch       *allowCircleSwitch;

@property (nonatomic,strong) UISwitch       *allowVideoSwitch;

@property (nonatomic,strong) UISwitch       *allowSeeInfomationSwitch;

@property (nonatomic,strong) UILabel        *friendCircleShowLabel;

@property (nonatomic,strong) XKBottomAlertSheetView *chooseCircleShowTimeView;
@end

@implementation XKPrivacySettingViewController

#pragma mark – Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _cellNameArr = @[@[@"密友圈"],@[@"不让Ta看我的可友圈",@"不看Ta的可友圈",@"设置可友圈显示时间",@"允许陌生人查看我的可友圈"],@[@"通讯录黑名单"],@[@"允许别人查看我的个人资料"]];
    [self initViews];
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  UITableViewCell *cell = [self.mainBackTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
  [XKGuidanceManager configShowGuidanceViewType:XKGuidanceManagerXKPrivacySettingViewController TransparentRectArr:@[[NSValue valueWithCGRect:cell.getWindowFrame]]];
}

#pragma mark – Private Methods
-(void)loadData{
    [HTTPClient postEncryptRequestWithURLString:GetXkPrivacySettingUrl timeoutInterval:10 parameters:nil success:^(id responseObject) {
        [self handleDataWith:responseObject];
    } failure:^(XKHttpErrror *error) {
        NSLog(@"%@",error);
    }];
}

-(void)changeCircleData{
    NSDictionary *param = @{@"action":[NSNumber numberWithInteger:_allowCircleSwitch.on?1:0]};
    [HTTPClient postEncryptRequestWithURLString:GetXKPrivacySwitchVistCircle timeoutInterval:10 parameters:param success:^(id responseObject) {
        NSLog(@"修改成功");
    } failure:^(XKHttpErrror *error) {
        self->_allowCircleSwitch.on = !self->_allowCircleSwitch.on;
    }];
}

-(void)changeVedioData{
    NSDictionary *param = @{@"action":[NSNumber numberWithInteger:_allowVideoSwitch.on?1:0]};
    [HTTPClient postEncryptRequestWithURLString:GetXKPrivacySwitchVistVideo timeoutInterval:10 parameters:param success:^(id responseObject) {
        NSLog(@"修改成功");
    } failure:^(XKHttpErrror *error) {
        self->_allowVideoSwitch.on = !self->_allowVideoSwitch;
    }];
}

-(void)changeInfomationData{
  NSDictionary *param = @{@"action":[NSNumber numberWithInteger:_allowSeeInfomationSwitch.on?1:0]};
  [HTTPClient postEncryptRequestWithURLString:@"im/ua/strangerVisitMUserInfoSwitch/1.0" timeoutInterval:10 parameters:param success:^(id responseObject) {
    NSLog(@"修改成功");
  } failure:^(XKHttpErrror *error) {
    self->_allowSeeInfomationSwitch.on = !self->_allowSeeInfomationSwitch;
  }];
}

-(void)handleDataWith:(id)response{
    NSDictionary *dic = [XKTransformHelper dictByJsonString:response];
    NSLog(@"%@",dic);
    if (dic) {
        if ([dic[@"strangerVisitCircle"]integerValue] == 0) {
            [_allowCircleSwitch setOn:NO];
        }
        else{
            [_allowCircleSwitch setOn:YES];
        }
        
        if ([dic[@"strangerVisitVideo"]integerValue] == 0) {
            [_allowVideoSwitch setOn:NO];
        }else{
            [_allowVideoSwitch setOn:YES];
        }
      
        if ([dic[@"strangerVisitMUserInfo"]integerValue] == 0) {
          [_allowSeeInfomationSwitch setOn:NO];
        }else{
          [_allowSeeInfomationSwitch setOn:YES];
        }
        
        if (dic[@"dynamicShowTime"] && [dic[@"dynamicShowTime"]isEqualToString:@"all"]) {
            _friendCircleShowLabel.text = @"全部";
        }
        else if (dic[@"dynamicShowTime"] && [dic[@"dynamicShowTime"]isEqualToString:@"three_days"]){
            _friendCircleShowLabel.text = @"三天";
        }
        else if(dic[@"dynamicShowTime"] && [dic[@"dynamicShowTime"]isEqualToString:@"half_a_year"]){
            _friendCircleShowLabel.text = @"半年";
        }
        else{
            _friendCircleShowLabel.text = @"一年";
        }
        
    }else{
        [_allowVideoSwitch setOn:YES];
        [_allowCircleSwitch setOn:YES];
        [_allowSeeInfomationSwitch setOn:YES];

    }
}

-(void)initViews{
    self.view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self setNavTitle:@"隐私设置" WithColor:UIColorFromRGB(0xffffff)];
    [self.view addSubview:self.mainBackTableView];
}

#pragma mark - Events
-(void)switchBarSwitched:(UISwitch *)sender{
    switch (sender.tag) {
        case 1001:
            [self changeCircleData];
            break;
        case 1002:
            [self changeVedioData];
            break;
        case 1003:
            [self changeInfomationData];
            break;
        default:
            break;
    }
}
#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.font = XKRegularFont(14);
    cell.textLabel.textColor  = UIColorFromRGB(0x222222);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xk_openClip = YES;
    cell.xk_radius = 8 * ScreenScale;
    
    NSString *cellName = _cellNameArr[indexPath.section][indexPath.row];
    cell.textLabel.text = cellName;

    if ([cellName isEqualToString:@"密友圈"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.xk_clipType = XKCornerClipTypeAllCorners;
        UILabel *label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"新建" font:XKRegularFont(14) textColor:[UIColor lightGrayColor] backgroundColor:[UIColor clearColor]];
        label.adjustsFontSizeToFitWidth = YES;
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.mas_equalTo(cell);
            make.right.mas_equalTo(cell.mas_right).offset(-31 * ScreenScale);
        }];
    }
    else if ([cellName isEqualToString:@"不让Ta看我的可友圈"]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.xk_clipType = XKCornerClipTypeTopBoth;
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [cell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.mas_equalTo(cell);
            make.height.mas_equalTo(1);
        }];
    }
    else if ([cellName isEqualToString:@"不看Ta的可友圈"]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [cell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.mas_equalTo(cell);
            make.height.mas_equalTo(1);
        }];

    }
    else if ([cellName isEqualToString:@"通讯录黑名单"]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.xk_clipType = XKCornerClipTypeTopBoth;
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [cell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.mas_equalTo(cell);
            make.height.mas_equalTo(1);
        }];

    }
    else if ([cellName isEqualToString:@"允许陌生人查看我的可友圈"]){
        cell.xk_clipType = XKCornerClipTypeBottomBoth;
        [cell addSubview:self.allowCircleSwitch];
        [_allowCircleSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.right.mas_equalTo(cell.mas_right).offset(-15 * ScreenScale);
        }];
    }
    else if ([cellName isEqualToString:@"允许陌生人查看我的小视频"]){
        cell.xk_clipType = XKCornerClipTypeBottomBoth;
        [cell addSubview:self.allowVideoSwitch];
        [_allowVideoSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.right.mas_equalTo(cell.mas_right).offset(-15 * ScreenScale);
        }];
    }
    else if ([cellName isEqualToString:@"设置可友圈显示时间"]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.xk_clipType = XKCornerClipTypeNone;
        [cell addSubview:self.friendCircleShowLabel];
        [_friendCircleShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.mas_equalTo(cell);
            make.right.mas_equalTo(cell.mas_right).offset(-31 * ScreenScale);
        }];
    }
    else if ([cellName isEqualToString:@"允许别人查看我的个人资料"]){
      cell.xk_clipType = XKCornerClipTypeBottomBoth;
      [cell addSubview:self.allowSeeInfomationSwitch];
      [_allowSeeInfomationSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.mas_centerY);
        make.right.mas_equalTo(cell.mas_right).offset(-15 * ScreenScale);
      }];
    }
    else{
        
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
      UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10 * ScreenScale, 0, SCREEN_WIDTH - 20 * ScreenScale, 50 * ScreenScale)];
        
      UILabel *label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"可友圈" font:XKRegularFont(14) textColor:UIColorFromRGB(0x999999) backgroundColor:[UIColor clearColor]];
      label.adjustsFontSizeToFitWidth = YES;
      [backView addSubview:label];
      [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(backView.mas_centerY);
        make.left.mas_equalTo(backView.mas_left).offset(15 * ScreenScale);
        make.height.mas_equalTo(20);
      }];
        
      return backView;

  }
  else{
      return [UIView new];
  }
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45 * ScreenScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 13.0 * ScreenScale;
            break;
        case 1:
            return 50.0 * ScreenScale;
            break;
        case 2:
            return 10.0 * ScreenScale;
            break;
        default:
            return 0.000000001f;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000001f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _cellNameArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_cellNameArr[section] count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellName = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    if ([cellName isEqualToString:@"密友圈"]) {
        XKPrivacyCreateSecretFriendCircleViewController *vc =[[XKPrivacyCreateSecretFriendCircleViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([cellName isEqualToString:@"不让Ta看我的可友圈"]){
        XKPrivacyFriendsCirclePermissionsViewController *vc = [[XKPrivacyFriendsCirclePermissionsViewController alloc]init];
        vc.permissionsType = PermissionsType_notLookMine;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([cellName isEqualToString:@"不看Ta的可友圈"]){
        XKPrivacyFriendsCirclePermissionsViewController *vc = [[XKPrivacyFriendsCirclePermissionsViewController alloc]init];
        vc.permissionsType = PermissionsType_notLookTheir;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if ([cellName isEqualToString:@"通讯录黑名单"]){
        XKContactBlackListController *vc = [[XKContactBlackListController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([cellName isEqualToString:@"设置可友圈显示时间"]){
        [self.chooseCircleShowTimeView show];
    }
    else{
        
    }
    

}

#pragma mark - Custom Delegates

#pragma mark – Getters and Setters
-(UITableView *)mainBackTableView{
    if (!_mainBackTableView) {
        _mainBackTableView = [[UITableView alloc]initWithFrame:CGRectMake(10 * ScreenScale, NavigationAndStatue_Height, SCREEN_WIDTH - 20*ScreenScale, SCREEN_HEIGHT - NavigationAndStatue_Height) style:UITableViewStyleGrouped];
        _mainBackTableView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _mainBackTableView.delegate = self;
        _mainBackTableView.dataSource = self;
        _mainBackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainBackTableView;
}

-(UISwitch *)allowCircleSwitch{
    if (!_allowCircleSwitch) {
        _allowCircleSwitch = [[UISwitch alloc]init];
        _allowCircleSwitch.tag = 1001;
        [_allowCircleSwitch addTarget:self action:@selector(switchBarSwitched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allowCircleSwitch;
}

-(UISwitch *)allowVideoSwitch{
    if (!_allowVideoSwitch) {
        _allowVideoSwitch = [[UISwitch alloc]init];
        _allowVideoSwitch.tag = 1002;
        [_allowVideoSwitch addTarget:self action:@selector(switchBarSwitched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allowVideoSwitch;
}

-(UISwitch *)allowSeeInfomationSwitch{
  if (!_allowSeeInfomationSwitch) {
    _allowSeeInfomationSwitch = [[UISwitch alloc]init];
    _allowSeeInfomationSwitch.tag = 1003;
    [_allowSeeInfomationSwitch addTarget:self action:@selector(switchBarSwitched:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _allowSeeInfomationSwitch;
}

-(UILabel *)friendCircleShowLabel{
    if (!_friendCircleShowLabel) {
        _friendCircleShowLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(14) textColor:[UIColor lightGrayColor] backgroundColor:[UIColor clearColor]];
        _friendCircleShowLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _friendCircleShowLabel;
}

-(XKBottomAlertSheetView *)chooseCircleShowTimeView{
    if (!_chooseCircleShowTimeView) {
        XKWeakSelf(weakSelf);
        _chooseCircleShowTimeView = [[XKBottomAlertSheetView alloc]initWithBottomSheetViewWithDataSource:@[@"三天",@"半年",@"一年",@"全部",@"取消"] firstTitleColor:[UIColor blackColor] choseBlock:^(NSInteger index, NSString *choseTitle) {
            NSString *timeString = @"";
            if ([choseTitle isEqualToString:@"取消"]) {
                return;
            }
            if ([choseTitle isEqualToString:@"三天"]) {
                timeString = @"three_days";
            }
            if ([choseTitle isEqualToString:@"半年"]) {
                timeString = @"half_a_year";
            }
            if ([choseTitle isEqualToString:@"全部"]) {
                timeString = @"all";
            }
            if ([choseTitle isEqualToString:@"一年"]) {
                timeString = @"a_year";
            }
            [HTTPClient postEncryptRequestWithURLString:@"im/ua/dynamicShowTimeUpdate/1.0" timeoutInterval:10 parameters:@{@"dynamicShowTime":timeString} success:^(id responseObject) {
                weakSelf.friendCircleShowLabel.text = choseTitle;
            } failure:^(XKHttpErrror *error) {
                [XKHudView showErrorMessage:@"修改失败"];
            }];
        }];
    }
    return _chooseCircleShowTimeView;
}
@end
