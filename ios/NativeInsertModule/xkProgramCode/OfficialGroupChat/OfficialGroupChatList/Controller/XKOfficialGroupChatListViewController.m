//
//  XKOfficialGroupChatListViewController.m
//  xkMerchant
//
//  Created by RyanYuan on 2018/12/25.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKOfficialGroupChatListViewController.h"
#import "XKOfficialGroupChatListModel.h"
#import "XKOfficialGroupChatListViewTableViewCell.h"
#import "XKFriendMessageListTableViewCell.h"
#import "XKP2PChatViewController.h"
#import "XKTransformHelper.h"
#import "XKEmptyPlaceView.h"

static const CGFloat kOfficialGroupChatListViewControllerTableViewEdge = 10.0;

@interface XKOfficialGroupChatListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray  *tidArr;
@property (nonatomic, strong) NSMutableArray  *messageListDataArr;
@property (nonatomic, strong) XKEmptyPlaceView *emptyView;
@end

@implementation XKOfficialGroupChatListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _tidArr = [NSMutableArray array];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XKFriendChatListViewControllerRefreshDataNotification object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XKUserCacheChangeNoti object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XKTeamChatListViewControllerRefreshDataNotification object:nil];
  [self initializeView];
}
-(void)dealloc{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - private method

-(void)refreshData{
  
  _messageListDataArr = [NSMutableArray arrayWithArray:[XKIMGlobalMethod getLatestMessageListArray]];
  for (NIMRecentSession *session in _messageListDataArr) {
    if ([_tidArr containsObject:session.session.sessionId]) {
      if (_tidArr.count > 1) {
        [_tidArr exchangeObjectAtIndex:[_tidArr indexOfObject:session.session.sessionId] withObjectAtIndex:_tidArr.count - 1];
      }
    }
  }
  
  //设置置顶
  if ([[XKDataBase instance]existsTable:XKIMTeamTopChatDataBaseTable]) {
    NSString *jsonString = [[XKDataBase instance]select:XKIMTeamTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
    NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
    NSMutableArray *array = [NSMutableArray arrayWithArray:_tidArr];
    if (idArr && idArr.count > 0) {
      NSInteger index = 0;
      for (NSString *tid in array) {
        if ([idArr containsObject:tid]) {
          [_messageListDataArr removeObject:tid];
          [_messageListDataArr insertObject:tid atIndex:index];
          index ++;
        }
      }
    }
  }
  [_tableView reloadData];
}

- (void)initializeView {
  
  self.view.backgroundColor = HEX_RGB(0xEEEEEE);
  
  self.tableView = [UITableView new];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.showsVerticalScrollIndicator = NO;
  self.tableView.showsHorizontalScrollIndicator = NO;
  self.tableView.estimatedRowHeight = 0;
  self.tableView.estimatedSectionHeaderHeight = 0;
  self.tableView.estimatedSectionFooterHeight = 0;
  self.tableView.bounces = YES;
  self.tableView.backgroundColor = HEX_RGB(0xFFFFFF);
  self.tableView.layer.masksToBounds = YES;
  self.tableView.layer.cornerRadius = 8;
  [self.tableView registerClass:[XKOfficialGroupChatListViewTableViewCell class] forCellReuseIdentifier:@"XKOfficialGroupChatListViewTableViewCell"];
  [self.view addSubview:self.tableView];
  
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kOfficialGroupChatListViewControllerTableViewEdge, kOfficialGroupChatListViewControllerTableViewEdge, kOfficialGroupChatListViewControllerTableViewEdge, kOfficialGroupChatListViewControllerTableViewEdge));
  }];
  
  if (@available(iOS 11.0, *)) {
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
  } else {
    self.automaticallyAdjustsScrollViewInsets = NO;
  }
  
  // 空白页
  XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
  config.viewAllowTap = NO;
  config.verticalOffset = -80;
  config.backgroundColor = self.tableView.backgroundColor;
  config.btnColor = [UIColor whiteColor];
  config.btnBackImg = XKMainTypeColor;
  config.spaceImgBtmHeight = 15;
  config.spaceTitleBtmHeight = 0;
  config.spaceDesBtmHeight = 40;
  config.btnFont = XKRegularFont(17);
  self.emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
  
  // 下拉刷新
//  XKWeakSelf(weakSelf)
//  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//    XKStrongSelf(strongSelf)
//
//  }];
//
//  self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//    XKStrongSelf(strongSelf)
//
//  }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.dataArr.count == 0) {
    [self.emptyView showWithImgName:kEmptyPlaceForMsgImgName title:@"" des:@"暂无联盟商群" tapClick:nil];
  } else {
    [self.emptyView hide];
  }
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.dataArr.count > 0) {
    return self.dataArr.count;
  }
  else{
    return 0;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60 * ScreenScale;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *cellID=@"XKFriendMessageListTableViewCell";
  XKFriendMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell =[[XKFriendMessageListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  
  
  
  cell.xk_openClip = YES;
  cell.xk_radius = 8;
  NIMSession *session = [NIMSession session:_tidArr[indexPath.row] type:NIMSessionTypeTeam];
  NIMRecentSession *recentSession = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
  if (recentSession) {
    cell.recentSession = recentSession;
  }else{
    [[NIMSDK sharedSDK].teamManager fetchTeamInfo:session.sessionId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
      [cell.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:team.avatarUrl]];
      cell.userNameLabel.text = team.teamName;
      cell.messageCountLabel.hidden = YES;
      if (team.notifyStateForNewMsg == NIMTeamNotifyStateNone) {
        cell.remindImageView.hidden = NO;
      }else{
        cell.remindImageView.hidden = YES;
      }
    }];
  }
  
  //设置置顶样式
  if ([[XKDataBase instance]existsTable:XKIMTeamTopChatDataBaseTable]) {
    NSString *jsonString = [[XKDataBase instance]select:XKIMTeamTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
    NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
    if (idArr && idArr.count > 0) {
      NSString *tid = _tidArr[indexPath.row];
      if ([idArr containsObject:tid]) {
        [cell setTopChat:YES];
      }
      else{
        [cell setTopChat:NO];
      }
    }
    else{
      [cell setTopChat:NO];
    }
  }
  
  if (indexPath.row == (_dataArr.count - 1)) {
    cell.xk_clipType = XKCornerClipTypeBottomBoth;
    if (_dataArr.count == 1) {
      cell.xk_clipType = XKCornerClipTypeBottomBoth | XKCornerClipTypeTopBoth;
    }
  }
  else{
    cell.xk_clipType = XKCornerClipTypeNone;

  }

  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  NIMSession *session = [NIMSession session:_tidArr[indexPath.row] type:NIMSessionTypeTeam];
  if (session.sessionType == NIMSessionTypeTeam) {
    XKP2PChatViewController *vc = [[XKP2PChatViewController alloc] initWithSession:session];
    vc.isOfficialTeam = YES;
    vc.merchantType = self.merchantType;
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
  }else{
    
  }
}

- (void)setDataArr:(NSArray *)dataArr {
  
  _dataArr = dataArr;
  _tidArr = [NSMutableArray array];
  for (NSDictionary *d in dataArr) {
    [_tidArr addObject:d[@"tid"]];
  }
  
  [self refreshData];
}

@end
