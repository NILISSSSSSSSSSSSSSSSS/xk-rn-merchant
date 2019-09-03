//
//  XKCustomerServiceViewController.m
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/19.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKCustomerServiceViewController.h"
#import "XKRNMerchantCustomerConsultationModel.h"
#import "XKFriendMessageListTableViewCell.h"
#import "XKCustomerServiceHistoryMainViewController.h"
#import "XKCustomerSerRootViewController.h"
@interface XKCustomerServiceViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)XKCustomNavBar *navBar;
/**headerView*/
@property(nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) NSMutableArray *currentConsultations;

@end

@implementation XKCustomerServiceViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self postCurrentConsultations];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:XKCustomerServerListViewControllerRefreshDataNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
//  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleData {
  [super handleData];
}

- (void)addCustomSubviews {
  [self setNavTitle:@"客户咨询" WithColor:[UIColor whiteColor]];
  UIButton *hisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  hisBtn.titleLabel.font = XKMediumFont(17.0);
  [hisBtn setTitle:@"历史咨询" forState:UIControlStateNormal];
  [hisBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [hisBtn addTarget:self action:@selector(hisBtnClick) forControlEvents:UIControlEventTouchUpInside];
  [hisBtn sizeToFit];
  [self setRightView:hisBtn withframe:CGRectMake(0.0, 0.0, CGRectGetWidth(hisBtn.frame), CGRectGetHeight(hisBtn.frame))];
  
  
  [self.view addSubview:self.navBar];
  [self.view addSubview:self.tableView];
  self.emptyTipView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
  
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view.mas_left).offset(10);
    make.right.equalTo(self.view.mas_right).offset(-10);
    make.bottom.equalTo(self.view);
    make.top.equalTo(self.navigationView.mas_bottom);
  }];

}

- (void)hisBtnClick {
  XKCustomerServiceHistoryMainViewController *history = [XKCustomerServiceHistoryMainViewController new];
  [self.navigationController pushViewController:history animated:YES];
}

#pragma mark 网络请求

- (void)postCurrentConsultations {
  NSMutableDictionary *para = [NSMutableDictionary dictionary];
  para[@"shopId"] = [XKUserInfo currentUser].currentShopId;
  para[@"taskStatus"] = @"receipt";
  
  __weak typeof(self) weakSelf = self;
  [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig RNMerchantCustomerConsultationsUrl] timeoutInterval:20.0 parameters:para success:^(id responseObject) {
    [self.tableView.mj_header endRefreshing];
    NSMutableArray <XKRNMerchantCustomerConsultationModel *>*consultations = [NSMutableArray array];
    if (responseObject) {
      [consultations addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKRNMerchantCustomerConsultationModel class] json:responseObject]];
    }
    [self handleCurrentConsultationsWithConsultations:[consultations copy]];

  } failure:^(XKHttpErrror *error) {
    [self.tableView.mj_header endRefreshing];
    if (self.currentConsultations.count == 0) {
      self.emptyTipView.config.viewAllowTap = YES;
      [self.emptyTipView showWithImgName:kNetErrorPlaceImgName title:@"温馨提示" des:@"网络错误 点击重试" tapClick:^{
        [weakSelf postCurrentConsultations];
      }];
    }
  }];
}

- (void)handleCurrentConsultationsWithConsultations:(NSArray <XKRNMerchantCustomerConsultationModel *>*)consultations {
  //筛选出最近列表中的客服
  [self.currentConsultations removeAllObjects];
  for (XKRNMerchantCustomerConsultationModel *consultation in consultations) {
    BOOL hasRelatedSession = NO;
    for (NIMRecentSession *recentSession in [[XKIMGlobalMethod getLatestMessageListArray] copy]) {
      if (recentSession.session.sessionType == NIMSessionTypeTeam &&
          [recentSession.session.sessionId isEqualToString:consultation.tid]) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recentSession.session.sessionId];
        if ([XKIMGlobalMethod isCutomerServerSession:team]) {
          hasRelatedSession = YES;
          [self.currentConsultations addObject:recentSession];
          break;
        }
      }
    }
    if (!hasRelatedSession) {
      [self.currentConsultations addObject:consultation];
    }
  }

  [self refreshTableView];
  __weak typeof(self) weakSelf = self;
  if (self.currentConsultations.count) {
    [self.emptyTipView hide];
  } else {
    self.emptyTipView.config.viewAllowTap = YES;
    [self.emptyTipView showWithImgName:kEmptyPlaceImgName title:@"" des:@"暂无数据" tapClick:^{
      [weakSelf postCurrentConsultations];
    }];
  }
}

- (void)refreshData:(NSNotification *)sender {
  NIMRecentSession *theRecentSession = sender.object;
  BOOL isExist = NO;
  for (id model in [self.currentConsultations copy]) {
    if ([model isKindOfClass:[NIMRecentSession class]]) {
      NIMRecentSession *session = (NIMRecentSession *)model;
      if (session.session.sessionType == NIMSessionTypeTeam &&
          [session.session.sessionId isEqualToString:theRecentSession.session.sessionId]) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:session.session.sessionId];
        if ([XKIMGlobalMethod isCutomerServerSession:team]) {
          [self.currentConsultations removeObject:model];
          isExist = YES;
          break;
        }
      }
    } else if ([model isKindOfClass:[XKRNMerchantCustomerConsultationModel class]]) {
      XKRNMerchantCustomerConsultationModel *consultation = (XKRNMerchantCustomerConsultationModel *)model;
      if ([consultation.tid isEqualToString:theRecentSession.session.sessionId]) {
        [self.currentConsultations removeObject:model];
        isExist = YES;
        break;
      }
    }
  }
  if (isExist) {
    [self.currentConsultations insertObject:theRecentSession atIndex:0];
    [self refreshTableView];
  } else {
    [self postCurrentConsultations];
  }
}

- (void)refreshTableView {
  if (self.currentConsultations.count) {
    /*
    NSArray *tempArray = [[self.currentConsultations copy] sortedArrayUsingComparator:^NSComparisonResult(NIMRecentSession *obj1, NIMRecentSession *obj2) {
      if (obj1.lastMessage.timestamp < obj2.lastMessage.timestamp) {
        return NSOrderedDescending;
      } else if (obj1.lastMessage.timestamp > obj2.lastMessage.timestamp) {
        return NSOrderedAscending;
      } else {
        return NSOrderedSame;
      }
    }];
    [self.currentConsultations removeAllObjects];
    [self.currentConsultations addObjectsFromArray:tempArray];
     */
    self.tableView.tableHeaderView = self.headerView;
  } else {
    self.tableView.tableHeaderView = nil;
  }
  [self.tableView reloadData];
}

#pragma mark 响应事件

#pragma mark tableview代理 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.currentConsultations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60 * ScreenScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
  XKFriendMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKFriendMessageListTableViewCell" forIndexPath:indexPath];
  if ([self.currentConsultations[indexPath.row] isKindOfClass:[NIMRecentSession class]]) {
    [cell configCellWithIMType:XKIMTypeMerchantCustomerService recentSession:self.currentConsultations[indexPath.row]];
  } else if ([self.currentConsultations[indexPath.row] isKindOfClass:[XKRNMerchantCustomerConsultationModel class]]) {
    [cell configCellWithCustomerConsultationModel:self.currentConsultations[indexPath.row]];
  }
  cell.xk_openClip = YES;
  cell.xk_radius = 6.f;
  if (self.currentConsultations.count == 1) {
    cell.xk_clipType = XKCornerClipTypeAllCorners;
  } else {
    if(indexPath.row == 0) {
      cell.xk_clipType = XKCornerClipTypeTopBoth;
    } else if (indexPath.row == self.currentConsultations.count - 1) {
      cell.xk_clipType = XKCornerClipTypeBottomBoth;
    } else {
       cell.xk_clipType = XKCornerClipTypeNone;
    }
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
  return self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  __weak typeof(self) weakSelf = self;
  NIMSession *session;
  if ([self.currentConsultations[indexPath.row] isKindOfClass:[NIMRecentSession class]]) {
    session = ((NIMRecentSession *)self.currentConsultations[indexPath.row]).session;
  } else if ([self.currentConsultations[indexPath.row] isKindOfClass:[XKRNMerchantCustomerConsultationModel class]]) {
    session = [NIMSession session:((XKRNMerchantCustomerConsultationModel *)self.currentConsultations[indexPath.row]).tid type:NIMSessionTypeTeam];
  }
  
  XKCustomerSerRootViewController *vc = [[XKCustomerSerRootViewController alloc] initWithSession:session vcType:XKCustomerSerRootVCTypeCurrentConsultations];
  vc.finishCustomerServiceBlock = ^{
    [weakSelf.currentConsultations removeObjectAtIndex:indexPath.row];
    [weakSelf.tableView reloadData];
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (weakSelf.currentConsultations.count) {
      [weakSelf.emptyTipView hide];
    } else {
      [weakSelf.emptyTipView showWithImgName:kEmptyPlaceImgName title:@"温馨提示" des:@"暂无数据" tapClick:nil];
    }
    [weakSelf.navigationController popViewControllerAnimated:YES];
  };
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 懒加载
- (UITableView *)tableView {
  if(!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.cornerRadius = 6.f;
    _tableView.layer.masksToBounds = YES;
//    _tableView.tableHeaderView = self.headerView;
//    _tableView.tableHeaderView = self.headerView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[XKFriendMessageListTableViewCell class] forCellReuseIdentifier:@"XKFriendMessageListTableViewCell"];
    XKWeakSelf(ws);
    MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      [ws postCurrentConsultations];
    }];
    _tableView.mj_header = narmalHeader;

  }
  return _tableView;
}

- (UIView *)headerView {
  if (!_headerView) {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    _headerView.backgroundColor = [UIColor clearColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 30, 25)];
    headerLabel.textColor = UIColorFromRGB(0x999999);
    headerLabel.font = XKRegularFont(13);
    headerLabel.text = @"当前咨询";
    [_headerView addSubview:headerLabel];
  }
  return _headerView;
}

- (NSMutableArray *)currentConsultations {
  if (!_currentConsultations) {
    _currentConsultations = [NSMutableArray array];
  }
  return _currentConsultations;
}

@end
