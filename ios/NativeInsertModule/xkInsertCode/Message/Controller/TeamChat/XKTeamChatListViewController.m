//
//  XKTeamChatListViewController.m
//  XKSquare
//
//  Created by william on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//
#import "XKTeamChatListViewController.h"
#import "XKFriendMessageListTableViewCell.h"
#import "XKIMGlobalMethod.h"
#import "XKTransformHelper.h"
#import "XKP2PChatViewController.h"

@interface XKTeamChatListViewController () <UITableViewDelegate, UITableViewDataSource, NIMConversationManagerDelegate, NIMChatManagerDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UITableView *recentChatListTableView;

@property (nonatomic, strong) NSMutableArray *messageListDataArr;

@end

@implementation XKTeamChatListViewController


#pragma mark – Life Cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  // 隐藏导航栏
  self.navigationView.hidden = YES;
  self.view.backgroundColor = [UIColor clearColor];
  // 添加代理
  [[NIMSDK sharedSDK].chatManager addDelegate:self];
  [[NIMSDK sharedSDK].conversationManager addDelegate:self];
  
  [self configView];
  [self refreshData];
  // 添加通知监听事件
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XKTeamChatListViewControllerRefreshDataNotification object:nil];
}

- (void)dealloc {
  [[NIMSDK sharedSDK].chatManager removeDelegate:self];
  [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark – Private Methods
// 页面布局
- (void)configView {
  
  [self.view addSubview:self.bgView];
  [self.bgView addSubview:self.recentChatListTableView];
  XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
  config.backgroundColor = UIColorFromRGB(0xffffff);
  config.verticalOffset = 0.0;
  self.emptyTipView = [XKEmptyPlaceView configScrollView:self.recentChatListTableView config:config];
  
  [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0));
  }];
  [self.recentChatListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(UIEdgeInsetsZero);
  }];
}
// 刷新数据
- (void)refreshData {
  self.messageListDataArr = [NSMutableArray arrayWithArray:[XKIMGlobalMethod getLatestMessageListArray]];
  // 过滤非群聊以及客服
  for (NIMRecentSession *session in [self.messageListDataArr copy]) {
    if (session.session.sessionType == NIMSessionTypeTeam){
      NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:session.session.sessionId];
      if ([XKIMGlobalMethod isCutomerServerSession:team]) {
        [self.messageListDataArr removeObject:session];
      }
    } else {
      [self.messageListDataArr removeObject:session];
    }
  }
  
  // 设置置顶
  if ([[XKDataBase instance] existsTable:XKIMTeamTopChatDataBaseTable]) {
    NSString *jsonString = [[XKDataBase instance]select:XKIMTeamTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
    NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
    if (idArr && idArr.count > 0) {
      NSInteger index = 0;
      for (NIMRecentSession *recentSession in [self.messageListDataArr copy]) {
        if ([idArr containsObject:recentSession.session.sessionId]) {
          [self.messageListDataArr removeObject:recentSession];
          [self.messageListDataArr insertObject:recentSession atIndex:index];
          index ++;
        }
      }
    }
  }
  
  if (self.messageListDataArr.count == 0) {
    self.emptyTipView.config.viewAllowTap = NO; // 整个背景是否可点击  否则只有按钮可以点击
    [self.emptyTipView showWithImgName:kEmptyPlaceForMsgImgName title:@"" des:@"暂无消息" tapClick:nil];
  } else {
    [self.emptyTipView hide];
  }
  [self.recentChatListTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.messageListDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60 * ScreenScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"XKFriendMessageListTableViewCell";
  XKFriendMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[XKFriendMessageListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  
  cell.recentSession = self.messageListDataArr[indexPath.row];
  
  cell.contentView.xk_radius = 8;
  cell.contentView.xk_openClip = YES;
  if (indexPath.row == (_messageListDataArr.count - 1)) {
    cell.contentView.xk_clipType = XKCornerClipTypeBottomBoth;
  } else {
    cell.contentView.xk_clipType = XKCornerClipTypeNone;
  }
  [cell.contentView xk_forceClip];
  
  // 设置置顶样式
  if ([[XKDataBase instance] existsTable:XKIMTeamTopChatDataBaseTable]) {
    NSString *jsonString = [[XKDataBase instance] select:XKIMTeamTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
    NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
    if (idArr && idArr.count > 0) {
      NIMRecentSession *recentSession = self.messageListDataArr[indexPath.row];
      if ([idArr containsObject:recentSession.session.sessionId]) {
        [cell setTopChat:YES];
      } else {
        [cell setTopChat:NO];
      }
    } else {
      [cell setTopChat:NO];
    }
  }
  return cell;
}
#pragma mark - UITableViewDelegate

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  
  if (indexPath.row < 0 || indexPath.row > self.messageListDataArr.count) {
    return nil;
  }
  
  NIMRecentSession *session = self.messageListDataArr[indexPath.row];
  NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:session.session.sessionId];
  
  // delete action
  UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
    // 删除最新会话刷新页面，退出编辑模式
    NIMRecentSession *session = self.messageListDataArr[indexPath.row];
    [[NIMSDK sharedSDK].conversationManager deleteRecentSession:session];
    [tableView setEditing:NO animated:YES];
  }];
  
  // 静音 action
  NSString *readTitle = team.notifyStateForNewMsg == NIMTeamNotifyStateAll ? @"消息静音" : @"消息提醒";
  UITableViewRowAction *readAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:readTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
    // 更新群聊提示状态，退出编辑模式
    [[NIMSDK sharedSDK].teamManager updateNotifyState:team.notifyStateForNewMsg == NIMTeamNotifyStateAll ? NIMTeamNotifyStateNone : NIMTeamNotifyStateAll inTeam:team.teamId completion:^(NSError * _Nullable error) {
      // 发送通知，告知群聊列表刷新
      [[NSNotificationCenter defaultCenter] postNotificationName:XKTeamChatListViewControllerRefreshDataNotification object:nil];
    }];
    [tableView setEditing:NO animated:YES];
  }];
  return @[deleteAction, readAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NIMRecentSession *session = self.messageListDataArr[indexPath.row];
  XKP2PChatViewController *vc = [[XKP2PChatViewController alloc] initWithSession:session.session];
  [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark – Getters and Setters

- (UIView *)bgView {
  if (!_bgView) {
    _bgView = [[UIView alloc] init];
    _bgView.xk_radius = 8.0;
    _bgView.xk_openClip = YES;
    _bgView.xk_clipType = XKCornerClipTypeBottomBoth;
  }
  return _bgView;
}

- (UITableView *)recentChatListTableView{
  if (!_recentChatListTableView) {
    _recentChatListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _recentChatListTableView.delegate = self;
    _recentChatListTableView.dataSource = self;
    _recentChatListTableView.showsVerticalScrollIndicator = NO;
    _recentChatListTableView.backgroundColor = [UIColor clearColor];
    _recentChatListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  }
  return _recentChatListTableView;
}

- (NSMutableArray *)messageListDataArr {
  if (!_messageListDataArr) {
    _messageListDataArr = [NSMutableArray array];
  }
  return _messageListDataArr;
}

#pragma mark - NIMChatManagerDelegate

// 消息撤回回调
- (void)onRecvRevokeMessageNotification:  (NIMRevokeMessageNotification *)notification {
  if (notification.message && notification.session.sessionType == NIMSessionTypeTeam) {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(1) forKey:@"group"];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = [[NIMTipObject alloc] init];
    message.text = [NSString stringWithFormat:@"%@撤回了一条消息", notification.message.senderName];
    message.timestamp = notification.message.timestamp;
    message.remoteExt = [dic copy];
    [[NIMSDK sharedSDK].conversationManager saveMessage:message forSession:notification.session completion:^(NSError * _Nullable error) {
      
    }];
  }
}

@end
