//
//  XKCustomerServiceManageListViewController.m
//  xkMerchant
//
//  Created by Jamesholy on 2018/12/19.
//  Copyright © 2018 . All rights reserved.
//

#import "XKGroupChatSettingInviteViewController.h"
#import "XKCustomerServiceManageCell.h"
#import "XKGroupChatManageAddViewController.h"
@interface XKGroupChatSettingInviteViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)XKCustomNavBar *navBar;
/**<##>*/
@property(nonatomic, strong) NSMutableArray *dataArray;
/**headerView*/
@property(nonatomic, strong) UIView *headerView;

/**<##>*/
@property(nonatomic, assign) BOOL infoChange;
@end

@implementation XKGroupChatSettingInviteViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _dataArray = @[].mutableCopy;
  [self requestDataNeedTip:YES];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}


- (void)didPopToPreviousController {
  if (self.infoChange) {
    EXECUTE_BLOCK(self.userListChange);
  }
}

- (void)handleData {
  [super handleData];
  
}

- (void)addCustomSubviews {
  XKWeakSelf(ws);
  [self hideNavigation];
  _navBar =  [[XKCustomNavBar alloc] init];
  [_navBar customNaviBarWithTitle:@"群分号" andRightButtonTitle:@"新增" andRightColor:[UIColor whiteColor]];
  _navBar.rightButton.titleLabel.font = XKNormalFont(16);
  _navBar.rightButtonBlock = ^(UIButton *sender) {
    XKGroupChatManageAddViewController * add = [XKGroupChatManageAddViewController new];
    add.teamId = ws.teamId;
    add.merchantType = ws.merchantType;
    [add setAddBlock:^(NSArray<XKContactModel *> * _Nonnull users) {
      if (users) {
        ws.infoChange = YES;
        [ws requestDataNeedTip:NO];
      }
    }];
    [ws.navigationController pushViewController:add animated:YES];

  };
  _navBar.leftButtonBlock = ^{
    [ws.navigationController popViewControllerAnimated:YES];
  };
  
  [self.view addSubview:self.navBar];
  [self.view addSubview:self.tableView];
  self.emptyTipView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
  
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view.mas_left).offset(10);
    make.right.equalTo(self.view.mas_right).offset(-10);
    make.bottom.equalTo(self.view);
    make.top.equalTo(self.navigationView.mas_bottom);
  }];
  [self updateUI];
}

- (void)requestDataNeedTip:(BOOL)needTip {
  if (needTip) {
    [XKHudView showLoadingTo:self.tableView animated:YES];
  }
  NSMutableDictionary *parmas = @{}.mutableCopy;
  parmas[@"merchantType"] = self.merchantType;
  parmas[@"tid"] = self.teamId;
  [HTTPClient getEncryptRequestWithURLString:@"im/ma/employeeList/1.0" timeoutInterval:20 parameters:parmas success:^(id responseObject) {
    
    NSArray *employeeList= [NSArray yy_modelArrayWithClass:[XKContactModel class] json:responseObject];
    self.infoChange = YES;
    [[NIMSDK sharedSDK].teamManager fetchTeamMembersFromServer:self.teamId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
      [XKHudView hideHUDForView:self.tableView];
      if (error) {
        [XKHudView showErrorMessage:@"网络错误" to:self.tableView animated:YES];
      } else {
        [self.dataArray removeAllObjects];
        for (XKContactModel *employee in employeeList) {
          for (NIMTeamMember *teamMember in members) {
            if ([employee.userId isEqualToString:teamMember.userId]) {
              [self.dataArray addObject:employee];
            }
          }
        }
      }
      [self updateUI];
    }];
  } failure:^(XKHttpErrror *error) {
    [XKHudView hideHUDForView:self.tableView];
    [XKHudView showErrorMessage:error.message to:self.tableView animated:YES];
  }];
}

- (void)updateUI {
  [self.tableView reloadData];
  UILabel *label =  [self.headerView viewWithTag:123];
  label.text = [NSString stringWithFormat:@"当前群分号列表"];
}

#pragma mark 网络请求

#pragma mark 响应事件

#pragma mark tableview代理 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 65 * ScreenScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *rid=@"XKCustomerServiceManageCell";
  
 XKCustomerServiceManageCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
  if(cell==nil){
    cell=[[XKCustomerServiceManageCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:rid];
  }
  
  [cell managerModel:YES];

  cell.user = self.dataArray[indexPath.row];

  cell.xk_openClip = YES;
  cell.xk_radius = 6.f;
  if(indexPath.section == 0) {
    
    cell.xk_clipType = XKCornerClipTypeTopBoth;
  } else if(indexPath.section == 2) {
    
    cell.xk_clipType = XKCornerClipTypeBottomBoth;
  } else {
    
    cell.xk_clipType = XKCornerClipTypeNone;
  }

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  return self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  return  self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  
}

#pragma mark - 侧滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
   return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [XKAlertView showCommonAlertViewWithTitle:@"确认删除" leftText:@"取消" rightText:@"确认" leftBlock:^{
    } rightBlock:^{
      [XKHudView showLoadingTo:self.tableView animated:YES];
      XKContactModel *user = self.dataArray[indexPath.row];
      NSMutableDictionary *parmas = @{}.mutableCopy;
      parmas[@"tid"] = self.teamId;
      parmas[@"employeeId"] = user.userId;
      [HTTPClient getEncryptRequestWithURLString:@"im/ma/employeeDelete/1.0" timeoutInterval:20 parameters:parmas success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView];
        [self.dataArray removeObject:user];
        [self updateUI];
      } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showErrorMessage:error.message];
      }];
    }];
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
#pragma mark 懒加载
- (UITableView *)tableView {
  if(!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.cornerRadius = 6.f;
    _tableView.layer.masksToBounds = YES;
    _tableView.tableHeaderView = self.headerView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[XKCustomerServiceManageCell class] forCellReuseIdentifier:@"XKCustomerServiceManageCell"];
    
  }
  return _tableView;
}

- (UIView *)headerView {
  if (!_headerView) {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    _headerView.backgroundColor = [UIColor clearColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, SCREEN_WIDTH - 50, 25)];
    headerLabel.textColor = UIColorFromRGB(0x999999);
    headerLabel.font = XKRegularFont(13);
    headerLabel.tag = 123;
    [_headerView addSubview:headerLabel];
  }
  return _headerView;
}

@end
