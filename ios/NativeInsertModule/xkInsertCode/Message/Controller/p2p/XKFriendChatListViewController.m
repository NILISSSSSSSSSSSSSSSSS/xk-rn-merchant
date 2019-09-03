//
//  XKFriendChatListViewController.m
//  XKSquare
//
//  Created by william on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKFriendChatListViewController.h"
#import "XKFriendMessageListTableViewCell.h"
#import "XKIMGlobalMethod.h"
#import "XKTransformHelper.h"
#import "XKP2PChatViewController.h"
#import "XKRelationUserCacheManager.h"

@interface XKFriendChatListViewController ()<UITableViewDelegate,UITableViewDataSource,NIMConversationManagerDelegate, NIMChatManagerDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic,strong) UITableView *recentChatListTableView;

@property (nonatomic,strong) NSMutableArray *messageListDataArr;

@end

@implementation XKFriendChatListViewController


#pragma mark – Life Cycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationView.hidden = YES;
  self.view.backgroundColor = [UIColor clearColor];
  // 添加NIMSDK代理事件，处理部分业务逻辑
  [[NIMSDK sharedSDK].chatManager addDelegate:self];
  [[NIMSDK sharedSDK].conversationManager addDelegate:self];
  // 刷新数据
  [self refreshData];
  // 添加通知监听事件
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XKFriendChatListViewControllerRefreshDataNotification object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XKUserCacheChangeNoti object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XKTeamChatListViewControllerRefreshDataNotification object:nil];
  
}

- (void)dealloc {
  [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
  [[NIMSDK sharedSDK].chatManager removeDelegate:self];
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

- (void)refreshData {
  // 获取到所有的会话
  self.messageListDataArr = [NSMutableArray arrayWithArray:[XKIMGlobalMethod getLatestMessageListArray]];
  
  for (NIMRecentSession *session in [self.messageListDataArr copy]) {
    // 排除客服消息
    if (session.session.sessionType == NIMSessionTypeTeam){
      NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:session.session.sessionId];
      if ([XKIMGlobalMethod isCutomerServerSession:team]) {
        [_messageListDataArr removeObject:session];
      }
      if (team.intro && [team.intro isEqualToString:@"2"]) {
        [_messageListDataArr removeObject:session];
      }
      continue;
    }
    // 排除无可友关系
    XKContactModel *model = [XKRelationUserCacheManager queryContactWithUserId:session.session.sessionId];
    if (model.friendRelation == XKRelationNoting) {
      [_messageListDataArr removeObject:session];
    }
    // 排除系统消息
    if ([session.session.sessionId containsString:@"system"]) {
      [_messageListDataArr removeObject:session];
    }
  }
  // 创建群组队列
  dispatch_group_t group = dispatch_group_create();
  dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    for (NIMRecentSession *session in [self.messageListDataArr copy]) {
//        dispatch_group_enter(group);
//        dispatch_group_async(group, queue, ^{
//            if (session.session.sessionType == NIMSessionTypeP2P) {
//                [XKIMGlobalMethod searchKeFriendMessageWithSession:session.session complete:^(NSArray<NIMMessage *> *messages) {
////                    if (messages.count <= 0) {
////                        [self.messageListDataArr removeObject:session];
////                    }
//                    dispatch_group_leave(group);
//                }];
//            } else {
//                dispatch_group_leave(group);
//            }
//        });
//    }
  // 所有任务执行完毕后
  dispatch_group_notify(group, queue, ^{
    dispatch_async(dispatch_get_main_queue(), ^{
      // 设置群聊置顶
      if ([[XKDataBase instance] existsTable:XKIMTeamTopChatDataBaseTable]) {
        NSString *jsonString = [[XKDataBase instance] select:XKIMTeamTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        if (idArr && idArr.count > 0) {
          NSInteger index = 0;
          for (NIMRecentSession *recentSession in [self.messageListDataArr copy]) {
            if (recentSession.session.sessionType == NIMSessionTypeTeam &&
                [idArr containsObject:recentSession.session.sessionId]) {
              [self.messageListDataArr removeObject:recentSession];
              [self.messageListDataArr insertObject:recentSession atIndex:index];
              index++;
            }
          }
        }
      }
      // 设置单聊置顶
      if ([[XKDataBase instance] existsTable:XKIMP2PTopChatDataBaseTable]) {
        NSString *jsonString = [[XKDataBase instance] select:XKIMP2PTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        if (idArr && idArr.count > 0) {
          NSInteger index = 0;
          for (NIMRecentSession *recentSession in [self.messageListDataArr copy]) {
            if (recentSession.session.sessionType == NIMSessionTypeP2P &&
                [idArr containsObject:recentSession.session.sessionId]) {
              [self.messageListDataArr removeObject:recentSession];
              [self.messageListDataArr insertObject:recentSession atIndex:index];
              index++;
            }
          }
        }
      }
      if (!self.recentChatListTableView.superview) {
        [self configView];
      }
      [self.recentChatListTableView reloadData];
      if (self.messageListDataArr.count == 0) {
        self.emptyTipView.config.viewAllowTap = NO; // 整个背景是否可点击  否则只有按钮可以点击
        [self.emptyTipView showWithImgName:kEmptyPlaceForMsgImgName title:@"" des:@"暂无消息" tapClick:nil];
      } else {
        [self.emptyTipView hide];
      }
    });
  });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.messageListDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 60 * ScreenScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"XKFriendMessageListTableViewCell";
  XKFriendMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[XKFriendMessageListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  NIMRecentSession *recentSession = self.messageListDataArr[indexPath.row];
  cell.recentSession = recentSession;
  cell.contentView.xk_openClip = YES;
  cell.contentView.xk_radius = 8;
  if (indexPath.row == (self.messageListDataArr.count - 1)) {
    cell.contentView.xk_clipType = XKCornerClipTypeBottomBoth;
  } else {
    cell.contentView.xk_clipType = XKCornerClipTypeNone;
  }
  [cell.contentView xk_forceClip];
  BOOL recentSessionIsTop = NO;
  if (recentSession.session.sessionType == NIMSessionTypeP2P ) {
    // 单聊置顶
    if ([[XKDataBase instance] existsTable:XKIMP2PTopChatDataBaseTable]) {
      NSString *jsonString = [[XKDataBase instance] select:XKIMP2PTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
      NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
      if (idArr && idArr.count > 0) {
        if ([idArr containsObject:recentSession.session.sessionId]) {
          recentSessionIsTop = YES;
        }
      }
    }
  } else if (recentSession.session.sessionType == NIMSessionTypeTeam) {
    // 群聊置顶
    if ([[XKDataBase instance] existsTable:XKIMTeamTopChatDataBaseTable]) {
      NSString *jsonString = [[XKDataBase instance] select:XKIMTeamTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
      NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
      if (idArr && idArr.count > 0) {
        if ([idArr containsObject:recentSession.session.sessionId]) {
          recentSessionIsTop = YES;
        }
      }
    }
  } else {
    recentSessionIsTop = NO;
  }
  [cell setTopChat:recentSessionIsTop];
  
  return cell;
}

#pragma mark - UITableViewDelegate

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  if (indexPath.row < 0 || indexPath.row > self.messageListDataArr.count) {
    return nil;
  }
  NIMRecentSession *session = self.messageListDataArr[indexPath.row];
  if (session.session.sessionType == NIMSessionTypeTeam) {
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:session.session.sessionId];
    // delete action
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
      // 删除最近会话，退出编辑模式
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
    return @[deleteAction,readAction];
  } else {
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:session.session.sessionId];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
      // 删除可友最近会话以及所有的聊天消息，退出编辑模式
      NIMRecentSession *session = self.messageListDataArr[indexPath.row];
      [[NIMSDK sharedSDK].conversationManager deleteRecentSession:session];
      [XKIMGlobalMethod deleteAllKeFriendChatHistoryInSession:session.session deleteRecentSession:YES complete:^(BOOL success) {
        
      }];
      [tableView setEditing:NO animated:YES];
    }];
    // 静音 action
    NSString *readTitle = user.notifyForNewMsg ? @"消息静音" : @"消息提醒";
    UITableViewRowAction *readAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:readTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
      // 更新单聊提示状态，退出编辑模式
      [[NIMSDK sharedSDK].userManager updateNotifyState:!user.notifyForNewMsg forUser:session.session.sessionId completion:^(NSError * _Nullable error) {
        // 刷新数据
        [self refreshData];
      }];
      [tableView setEditing:NO animated:YES];
    }];
    return @[deleteAction, readAction];
  }
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

- (UITableView *)recentChatListTableView {
  if (!_recentChatListTableView) {
    _recentChatListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _recentChatListTableView.delegate = self;
    _recentChatListTableView.dataSource = self;
    _recentChatListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _recentChatListTableView.backgroundColor = [UIColor clearColor];
  }
  return _recentChatListTableView;
}

// 消息撤回回调
- (void)onRecvRevokeMessageNotification:  (NIMRevokeMessageNotification *)notification {
  if (notification.message && notification.session.sessionType == NIMSessionTypeP2P) {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(1) forKey:@"group"];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = [[NIMTipObject alloc] init];
    message.text = @"对方撤回了一条消息";
    message.timestamp = notification.message.timestamp;
    message.remoteExt = [dic copy];
    [[NIMSDK sharedSDK].conversationManager saveMessage:message forSession:notification.session completion:^(NSError * _Nullable error) {
      
    }];
  } else if (notification.message && notification.session.sessionType == NIMSessionTypeTeam) {
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

- (NSMutableArray *)messageListDataArr {
  if (!_messageListDataArr) {
    _messageListDataArr = [NSMutableArray array];
  }
  return _messageListDataArr;
}

@end
