//
//  XKCustomerServiceManageAddViewController.m
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/19.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKGroupChatManageAddViewController.h"
#import "XKGroupChatManageAddBottomView.h"
#import "XKCustomerServiceManageCell.h"
#import "XKGroupChatManageAddViewController.h"
@interface XKGroupChatManageAddViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)XKCustomNavBar *navBar;
/**<##>*/
@property(nonatomic, strong) NSMutableArray *dataArray;
/**headerView*/
@property(nonatomic, strong) UIView *headerView;
/**底部视图*/
@property(nonatomic, strong) XKGroupChatManageAddBottomView *bottomView;
@end

@implementation XKGroupChatManageAddViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self requestDataNeedTip:YES];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView.mj_header beginRefreshing];
}

- (void)handleData {
  [super handleData];
}

- (void)requestDataNeedTip:(BOOL)needTip {
  if (needTip) {
    [XKHudView showLoadingTo:self.tableView animated:YES];
  }
  NSMutableDictionary *parmas = @{}.mutableCopy;
  parmas[@"merchantType"] = self.merchantType;
  parmas[@"tid"] = self.teamId;
  [HTTPClient getEncryptRequestWithURLString:@"im/ma/employeeList/1.0" timeoutInterval:20 parameters:parmas success:^(id responseObject) {
    NSMutableArray *employeeList= [NSArray yy_modelArrayWithClass:[XKContactModel class] json:responseObject].mutableCopy;
    [[NIMSDK sharedSDK].teamManager fetchTeamMembersFromServer:self.teamId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
      [XKHudView hideHUDForView:self.tableView];
      if (error) {
        [XKHudView showErrorMessage:@"网络错误" to:self.tableView animated:YES];
      } else {
        [self.dataArray removeAllObjects];
        NSMutableArray *existArr = @[].mutableCopy;
        for (XKContactModel *employee in employeeList) {
          for (NIMTeamMember *teamMember in members) {
            if ([employee.userId isEqualToString:teamMember.userId]) {
              [existArr addObject:employee];
            }
          }
        }
        // 移除在群里的 就是不在群里的
        [employeeList removeObjectsInArray:existArr];
        [self.dataArray addObjectsFromArray:employeeList];
      }
      [self updateUI];
    }];
  } failure:^(XKHttpErrror *error) {
    [XKHudView hideHUDForView:self.tableView];
    [XKHudView showErrorMessage:error.message to:self.tableView animated:YES];
  }];
}

- (void)addCustomSubviews {
  XKWeakSelf(ws);
  [self hideNavigation];
  _navBar =  [[XKCustomNavBar alloc] init];
  [_navBar customBaseNavigationBar];
  _navBar.titleLabel.text = @"邀请分号";
  _navBar.leftButtonBlock = ^{
    [ws.navigationController popViewControllerAnimated:YES];
  };
  [self.view addSubview:self.navBar];
  [self.view addSubview:self.tableView];
  [self.view addSubview:self.bottomView];
  self.emptyTipView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
  
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view.mas_left).offset(10);
    make.right.equalTo(self.view.mas_right).offset(-10);
    make.bottom.equalTo(self.view.mas_bottom).offset(-kBottomSafeHeight);
    make.top.equalTo(self.navigationView.mas_bottom);
  }];
  
  [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view);
    make.height.mas_equalTo(50);
    make.bottom.equalTo(self.view.mas_bottom).offset(-kBottomSafeHeight);
  }];
}

- (NSMutableArray *)dataArray {
  if (!_dataArray) {
    _dataArray = [NSMutableArray array];
  }
  return _dataArray;
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
  
  XKCustomerServiceManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKCustomerServiceManageCell"];
  [cell managerModel:NO];

  [cell setUser:self.dataArray[indexPath.row]];

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
  XKContactModel *user = self.dataArray[indexPath.row];
  user.selected = !user.selected;
  [self updateUI];
}

- (void)choseAll:(UIButton *)btn {
  if (btn.selected == YES) { // 全选
    for (XKContactModel *user in self.dataArray) {
      user.selected = YES;
    }
  } else {
    for (XKContactModel *user in self.dataArray) {
      user.selected = NO;
    }
  }
  [self updateUI];
 
}

- (void)add {
  NSArray *arr = [self.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected==YES"]];
  if (arr.count == 0) {
    [XKHudView showTipMessage:@"请选择用户"];
    return;
  }
  NSMutableArray *ids = @[].mutableCopy;
  for (XKContactModel *user in arr) {
    [ids addObject:user.userId];
  }
  
  [XKHudView showLoadingTo:self.tableView animated:YES];
  NSMutableDictionary *parmas = @{}.mutableCopy;
  parmas[@"tid"] = self.teamId;
  parmas[@"userIds"] = ids;
  [[NIMSDK sharedSDK].teamManager addUsers:ids toTeam:self.teamId postscript:@"" completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
    [XKHudView hideHUDForView:self.tableView];
    if (!error) {
      [XKHudView showLoadingTo:self.tableView animated:YES];
      NSMutableDictionary *para = [NSMutableDictionary dictionary];
      para[@"tid"] = self.teamId;
      para[@"userIds"] = ids;
      [HTTPClient postEncryptRequestWithURLString:@"im/ma/employeeAdd/1.0" timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView];
        [XKAlertView showCommonAlertViewWithTitle:@"添加分号成功" block:^{
          EXECUTE_BLOCK(self.addBlock,arr);
          [self.navigationController popViewControllerAnimated:YES];
        }];
      } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView];
        [XKAlertView showCommonAlertViewWithTitle:@"分号添加成功，添加管理员权限失败" block:^{
          EXECUTE_BLOCK(self.addBlock,arr);
          [self.navigationController popViewControllerAnimated:YES];
        }];
      }];
    } else {
      [XKHudView showErrorMessage:@"邀请分号失败"];
    }
  }];
}

- (void)updateUI {
  [self.tableView reloadData];
  if ([self.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected==YES"]].count == self.dataArray.count) {
    self.bottomView.choseBtn.selected = YES;
  } else {
    self.bottomView.choseBtn.selected = NO;
  }
}

#pragma mark 懒加载
- (UITableView *)tableView {
  if(!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.cornerRadius = 6.f;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    _tableView.layer.masksToBounds = YES;
    _tableView.tableHeaderView = self.headerView;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[XKCustomerServiceManageCell class] forCellReuseIdentifier:@"XKCustomerServiceManageCell"];
    //    XKWeakSelf(ws);
    //    MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //      ws.viewModel.page = 0;
    //      [ws requestDataWithTips:NO];
    //    }];
    //    _tableView.mj_header = narmalHeader;
    //
    //    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //      [ws requestDataWithTips:NO];
    //    }];
    //    [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
    //    _tableView.mj_footer = foot;
    
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
    headerLabel.text = @"员工列表";
    [_headerView addSubview:headerLabel];
  }
  return _headerView;
}

- (XKGroupChatManageAddBottomView *)bottomView {
  if(!_bottomView) {
    XKWeakSelf(ws);
    _bottomView = [[XKGroupChatManageAddBottomView alloc] init];
    _bottomView.allChoseBlock = ^(UIButton *sender) {
       [ws choseAll:sender];
    };
    _bottomView.sureBlock = ^(UIButton *sender) {
      [ws add];
    };
  }
  return _bottomView;
}

@end
