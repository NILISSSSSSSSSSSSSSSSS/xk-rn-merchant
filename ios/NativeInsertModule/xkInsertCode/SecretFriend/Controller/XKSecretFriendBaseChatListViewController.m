//
//  XKSecretFriendBaseChatListViewController.m
//  XKSquare
//
//  Created by william on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSecretFriendBaseChatListViewController.h"
#import "XKFriendMessageListTableViewCell.h"
#import "XKIMGlobalMethod.h"
#import "XKSecretChatViewController.h"
#import <NIMKit.h>
#import "UIView+XKCornerRadius.h"
#import "XKSecretFriendbaseSearchViewController.h"
#import "XKRelationUserCacheManager.h"
#import "XKGlobalSearchController.h"
#import "XKSecretFrientManager.h"
#import "XKTransformHelper.h"
@interface XKSecretFriendBaseChatListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong) UITableView *recentChatListTableView;
@property (nonatomic,strong) UISearchBar *chatListSearchBar;
@property (nonatomic,strong) NSMutableArray *messageListDataArr;
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;

@end

@implementation XKSecretFriendBaseChatListViewController



#pragma mark – Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navStyle = BaseNavWhiteStyle;
    [self configView];
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:XKSecretChatListViewControllerrRefreshDataNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XKSecretFriendGroupChange object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark – Private Methods
-(void)configView{
    self.navigationView.hidden = YES;
    [self.view addSubview:self.recentChatListTableView];
}

- (void)refreshData {
    XKWeakSelf(ws);
    [ws loadData];
    [ws.recentChatListTableView reloadData];
}

-(void)loadData{
    _messageListDataArr = [[XKIMGlobalMethod getLatestMessageListArray] mutableCopy];
    
    //排除群聊
    NSMutableArray * array = [NSMutableArray arrayWithArray: _messageListDataArr];
    for (NIMRecentSession *session in array) {
        if (session.session.sessionType != 0){
            [_messageListDataArr removeObject:session];
        }
    }

    NSMutableArray * array1 = [NSMutableArray arrayWithArray: _messageListDataArr];
    for (NIMRecentSession *recentSession in array1) {
        XKContactModel *model = [XKRelationUserCacheManager queryContactWithUserId:recentSession.session.sessionId];
//        NSLog(@"\n可友名：%@  \n密友关系：%ld  \n可友关系：%ld \nID:%@",model.nickname,(long)model.secretRelation,(long)model.friendRelation,recentSession.session.sessionId);
        //排除无密友关系
        if (model.secretRelation == XKRelationNoting) {
                [_messageListDataArr removeObject:recentSession];
        }
        //排除密友圈没有接收过密友消息的
        if (![XKSecretFrientManager getLastMessageInDBWithSessionID:recentSession.session.sessionId]) {
            [_messageListDataArr removeObject:recentSession];
        }
    }
    
    //设置置顶
    if ([[XKDataBase instance]existsTable:XKIMSecretTopChatDataBaseTable]) {
        NSString *jsonString = [[XKDataBase instance]select:XKIMSecretTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
        NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
        if (idArr && idArr.count > 0) {
            NSInteger index = 0;
            for (NIMRecentSession *recentSession in array) {
                if ([idArr containsObject:recentSession.session.sessionId]) {
                    [_messageListDataArr removeObject:recentSession];
                    [_messageListDataArr insertObject:recentSession atIndex:index];
                    index ++;
                }
            }
        }
    }
  if (_messageListDataArr.count == 0) {
    self.emptyView.config.viewAllowTap = NO; // 整个背景是否可点击  否则只有按钮可以点击
    [self.emptyView showWithImgName:kEmptyPlaceForMsgImgName title:@"" des:@"暂无消息" tapClick:^{
    }];
  }else{
    [self.emptyView hide];
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
    
    //设置置顶样式
        if ([[XKDataBase instance]existsTable:XKIMSecretTopChatDataBaseTable]) {
            NSString *jsonString = [[XKDataBase instance]select:XKIMSecretTopChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
            NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
            if (idArr && idArr.count > 0) {
                NIMRecentSession *recentSession = _messageListDataArr[indexPath.row];
                if ([idArr containsObject:recentSession.session.sessionId]) {
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
    return 60 * ScreenScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60 * ScreenScale;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *searchView = [[UIView alloc]init];
    [searchView addSubview:self.chatListSearchBar];
    [_chatListSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(searchView.mas_centerX);
        make.centerY.mas_equalTo(searchView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 38 * ScreenScale));
    }];
    return searchView;
}

#pragma mark -- cell左划手势

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  
  if (indexPath.row < 0 || indexPath.row > _messageListDataArr.count) {
    return nil;
  }
  
    NIMRecentSession *recentSession = _messageListDataArr[indexPath.row];
    
    // delete action
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [XKSecretFrientManager deleteAllSecretChatHistoryInSession:recentSession.session complete:^(BOOL success) {
            if (success) {
                [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
            }
        }];
    }];
    
    
    // 静音 action
    NSString *readTitle = @"消息静音";
    if ([XKSecretFrientManager secretSessionIsSilence:recentSession.session]) {
        readTitle = @"消息提醒";
    }
    else{
        readTitle = @"消息静音";
    }
    UITableViewRowAction *readAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:readTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        if ([XKSecretFrientManager secretSessionIsSilence:recentSession.session]) {
            NSString *jsonString = [[XKDataBase instance]select:XKIMSecretSilenceChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
            NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
            NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
            [idMuArr removeObject:recentSession.session.sessionId];
            BOOL success =  [[XKDataBase instance]replace:XKIMSecretSilenceChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
        }
        else{
            if ([[XKDataBase instance]existsTable:XKIMSecretSilenceChatDataBaseTable]) {
                NSString *jsonString = [[XKDataBase instance]select:XKIMSecretSilenceChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
                NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
                NSMutableArray *idMuArr = [NSMutableArray arrayWithArray:idArr];
                [idMuArr addObject:recentSession.session.sessionId];
                BOOL success =  [[XKDataBase instance]replace:XKIMSecretSilenceChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idMuArr yy_modelToJSONString]];
                NSLog(@"%d",success);
            }
            else{
                if ([[XKDataBase instance]createTable:XKIMSecretSilenceChatDataBaseTable]) {
                    NSMutableArray *idArr = [NSMutableArray array];
                    [idArr addObject: recentSession.session.sessionId];
                    BOOL success =  [[XKDataBase instance]replace:XKIMSecretSilenceChatDataBaseTable key:[XKUserInfo getCurrentUserId] value:[idArr yy_modelToJSONString]];
                    NSLog(@"%d",success);
                }
            }
        }
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
        [self refreshData];
    }];
    return @[deleteAction, readAction];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_chatListSearchBar.isFirstResponder) {
        [_chatListSearchBar resignFirstResponder];
    }
    NIMSession *session;
    NIMRecentSession *recentSession = _messageListDataArr[indexPath.row];
    session = recentSession.session;
   
    XKSecretChatViewController *vc = [[XKSecretChatViewController alloc] initWithSession:session];
    vc.secretID = _secretId;
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
        _recentChatListTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, SCREEN_HEIGHT - NavigationAndStatue_Height -40) style:UITableViewStyleGrouped];
        _recentChatListTableView.delegate = self;
        _recentChatListTableView.dataSource = self;
        _recentChatListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
      config.verticalOffset = 0;
      _emptyView = [XKEmptyPlaceView configScrollView:_recentChatListTableView config:config];

    }
    return _recentChatListTableView;
}

-(UISearchBar *)chatListSearchBar{
    if (!_chatListSearchBar) {
        _chatListSearchBar = [[UISearchBar alloc]init];
        _chatListSearchBar.barTintColor = _recentChatListTableView.backgroundColor;
        _chatListSearchBar.searchBarStyle = UISearchBarStyleDefault;
        _chatListSearchBar.delegate = self;
        for (UIView *view in _chatListSearchBar.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
    }
    return _chatListSearchBar;
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    XKGlobalSearchController *vc = [XKGlobalSearchController new];
    vc.isSecret = YES;
    vc.secretId = self.secretId;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

@end
