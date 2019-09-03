//
//  XKCustomeSerListViewController.m
//  XKSquare
//
//  Created by william on 2018/9/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCustomeSerListViewController.h"
#import "XKFriendMessageListTableViewCell.h"
#import "XKIMGlobalMethod.h"
#import "XKCustomerSerRootViewController.h"
#import <NIMKit.h>
#import "UIView+XKCornerRadius.h"
#import "XKTransformHelper.h"
@interface XKCustomeSerListViewController ()
<UITableViewDelegate,UITableViewDataSource,NIMConversationManagerDelegate>

@property (nonatomic,strong) UITableView *recentChatListTableView;
@property (nonatomic,strong) UISearchBar *chatListSearchBar;
@property (nonatomic,strong) NSMutableArray *messageListDataArr;
@end

@implementation XKCustomeSerListViewController


#pragma mark – Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _messageListDataArr = [NSMutableArray array];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMessageRefreshData:) name:XKCustomerServerListViewControllerRefreshDataNotification object:nil];
    [self configView];
    [self refreshData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
}

-(void)dealloc{
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark – Private Methods
-(void)configView{
    self.navigationView.hidden = YES;
    [self.view addSubview:self.recentChatListTableView];
}

-(void)newMessageRefreshData:(NSNotification *)noti{
    if (noti.object) {
        NIMRecentSession *recentSession = noti.object;
        [self deleteNewNotiMessageWithMessage:recentSession];
    }
    [self refreshData];
}

-(void)refreshData{
    //筛选出最近列表中的客服
    _messageListDataArr = [NSMutableArray arrayWithArray:[XKIMGlobalMethod getLatestMessageListArray]];
    NSMutableArray * array = [NSMutableArray arrayWithArray: _messageListDataArr];
    for (NIMRecentSession *session in array) {
        if (session.session.sessionType == 1){
            NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:session.session.sessionId];
            if (![XKIMGlobalMethod isCutomerServerSession:team]) {
                [_messageListDataArr removeObject:session];
            }
        }
        else{
            [_messageListDataArr removeObject:session];
        }
    }
    
    //从云信拉取客服列表用户信息
    for (NIMRecentSession *session in _messageListDataArr) {
        [[NIMSDK sharedSDK].teamManager fetchTeamMembers:session.session.sessionId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
            
        }];
    }
    [_recentChatListTableView reloadData];
}
#pragma mark - Events

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"XKFriendMessageListTableViewCell";
    XKFriendMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =[[XKFriendMessageListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.recentSession = _messageListDataArr[indexPath.row];
    
  cell.contentView.xk_radius = 8;
  cell.contentView.xk_openClip = YES;
  if (_messageListDataArr.count == 1) {
    cell.contentView.xk_clipType = XKCornerClipTypeAllCorners;
  } else {
    if (indexPath.row == (_messageListDataArr.count - 1)) {
      cell.contentView.xk_clipType = XKCornerClipTypeBottomBoth;
    } else if (indexPath.row == 0) {
      cell.contentView.xk_clipType = XKCornerClipTypeTopBoth;
    } else {
      cell.contentView.xk_clipType = XKCornerClipTypeNone;
    }
  }
  [cell.contentView xk_forceClip];
  
    return cell;
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _messageListDataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70 * ScreenScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *searchView = [[UIView alloc]init];
//    [searchView addSubview:self.chatListSearchBar];
//    [_chatListSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(searchView.mas_centerX);
//        make.centerY.mas_equalTo(searchView.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 38 * ScreenScale));
//    }];
    return searchView;
}

#pragma mark -- cell左划手势

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  if (indexPath.row < 0 || indexPath.row > _messageListDataArr.count) {
    return nil;
  }
    NIMRecentSession *session = _messageListDataArr[indexPath.row];
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:session.session.sessionId];
    // delete action
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NIMRecentSession *session = self->_messageListDataArr[indexPath.row];
        [[NIMSDK sharedSDK].conversationManager deleteRecentSession:session];
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
    }];
    
    
    // 静音 action
    NSString *readTitle = team.notifyStateForNewMsg == NIMTeamNotifyStateAll?@"消息静音":@"消息提醒";
    UITableViewRowAction *readAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:readTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){

        [[NIMSDK sharedSDK].teamManager updateNotifyState:team.notifyStateForNewMsg == NIMTeamNotifyStateAll ? NIMTeamNotifyStateNone : NIMTeamNotifyStateAll inTeam:team.teamId completion:^(NSError * _Nullable error) {
            [self refreshData];
        }];
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
    }];
    return @[deleteAction, readAction];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_chatListSearchBar.isFirstResponder) {
        [_chatListSearchBar resignFirstResponder];
    }
    
    NIMRecentSession *session = _messageListDataArr[indexPath.row];
    XKCustomerSerRootViewController *vc = [[XKCustomerSerRootViewController alloc] initWithSession:session.session vcType:XKCustomerSerRootVCTypeUserContactCustomerService];
    vc.hidesBottomBarWhenPushed = YES;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_chatListSearchBar.isFirstResponder) {
        [_chatListSearchBar resignFirstResponder];
    }
}

#pragma mark - Custom Delegates

#pragma mark – Getters and Setters
-(UITableView *)recentChatListTableView{
    if (!_recentChatListTableView) {
        _recentChatListTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, SCREEN_HEIGHT - NavigationAndStatue_Height - TabBar_Height -40) style:UITableViewStyleGrouped];
        _recentChatListTableView.delegate = self;
        _recentChatListTableView.dataSource = self;
        _recentChatListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _recentChatListTableView;
}

-(UISearchBar *)chatListSearchBar{
    if (!_chatListSearchBar) {
        _chatListSearchBar = [[UISearchBar alloc]init];
        _chatListSearchBar.barTintColor = _recentChatListTableView.backgroundColor;
        _chatListSearchBar.searchBarStyle = UISearchBarStyleDefault;
        for (UIView *view in _chatListSearchBar.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
    }
    return _chatListSearchBar;
}

//收到新消息判断是否是客服进入或者退出
-(void)deleteNewNotiMessageWithMessage:(NIMRecentSession *)recentSession{
    if (recentSession.lastMessage.messageType == NIMMessageTypeNotification) {
        [[NIMSDK sharedSDK].conversationManager deleteMessage:recentSession.lastMessage];
    }
    
    NSString* dictJsonString = [NSString stringWithFormat:@"%@",recentSession.lastMessage.messageObject];
    NSDictionary *dict = [XKTransformHelper dictByJsonString:dictJsonString];
  if (dict[@"question"] && [dict[@"question"] integerValue] == 1 &&
      [recentSession.lastMessage.from isEqualToString:[XKUserInfo currentUser].userImAccount.accid]) {
        [[NIMSDK sharedSDK].conversationManager deleteMessage:recentSession.lastMessage];
    }
}


@end
