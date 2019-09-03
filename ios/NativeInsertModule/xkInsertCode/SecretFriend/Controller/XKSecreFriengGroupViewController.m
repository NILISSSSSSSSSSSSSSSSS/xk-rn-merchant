//
//  XKSecreFriengGroupViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/12/7.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKSecreFriengGroupViewController.h"
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
@interface XKSecreFriengGroupViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *recentChatListTableView;
@property (nonatomic,strong) NSMutableArray *messageListDataArr;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation XKSecreFriengGroupViewController


#pragma mark – Life Cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [self configView];
  [self loadData];
  self.navStyle = BaseNavWhiteStyle;
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:XKSecretChatListViewControllerrRefreshDataNotification object:nil];
  XKWeakSelf(ws);
  [self requestComplete:^(NSString *errorMessage, NSArray *dataArray) {
    [ws.recentChatListTableView reloadData];
  }];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XKSecretFriendGroupChange object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XKSecretFriendListCacheChangeNoti object:nil];
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
  [self requestComplete:^(NSString *errorMessage, NSArray *dataArray) {
    [ws loadData];
    [ws.recentChatListTableView reloadData];
  }];
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
    NSLog(@"\n可友名：%@  \n密友关系：%ld  \n可友关系：%ld \nID:%@",model.nickname,(long)model.secretRelation,(long)model.friendRelation,recentSession.session.sessionId);
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
  
  [_recentChatListTableView reloadData];
}

#pragma mark - 网络请求
- (void)requestComplete:(void (^)(NSString *errorMessage, NSArray *dataArray))complete {
  _dataArray = [NSMutableArray array];
  NSString *url = @"im/ua/secretFriendGroupList/1.0";
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"meSecretId"] = self.secretId;
  params[@"groupId"] = self.groupId;
  params[@"page"] = @(1);
  params[@"limit"] = @(0);
  params[@"userId"] = [XKUserInfo getCurrentUserId];
  NSLog(@"%@",params);
  [HTTPClient getEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    NSArray *arr;
    NSDictionary *dic = [responseObject xk_jsonToDic];
    arr = [NSArray yy_modelArrayWithClass:[XKContactModel class] json:dic[@"data"]];
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:arr];
    complete(nil,self.dataArray);
  } failure:^(XKHttpErrror *error) {
    complete(error.message,nil);
  }];
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
  
  if (self.dataArray.count > 0) {
    XKContactModel *item = self.dataArray[indexPath.row];
    [self.messageListDataArr enumerateObjectsUsingBlock:^(NIMRecentSession *session, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([session.session.sessionId isEqualToString:item.accid]) {
        cell.recentSession = session;
        cell.lastMessageLabel.hidden = NO;
        cell.timeLabel.hidden = NO;
      }else {
        [cell.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:kDefaultHeadImg];
        cell.userNameLabel.text = item.displaySecretName;
        cell.remindImageView.hidden = YES;
        cell.messageCountLabel.hidden = YES;
        cell.lastMessageLabel.hidden = YES;
        cell.timeLabel.hidden = YES;
      }
    }];
    if (self.messageListDataArr.count == 0) {
      [cell.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:kDefaultHeadImg];
      cell.userNameLabel.text = item.displaySecretName;
      cell.remindImageView.hidden = YES;
      cell.messageCountLabel.hidden = YES;
      cell.lastMessageLabel.hidden = YES;
      cell.timeLabel.hidden = YES;
    }
    
  }
  cell.xk_openClip = YES;
  cell.xk_radius = 8;
  
  if (_dataArray.count == 1) {
    cell.xk_clipType = XKCornerClipTypeAllCorners;
  }
  else{
    if (indexPath.row == (_dataArray.count - 1)) {
      cell.xk_clipType = XKCornerClipTypeBottomBoth;
    }
    else if (indexPath.row == 0){
      cell.xk_clipType = XKCornerClipTypeTopBoth;
    }
    else{
      cell.xk_clipType = XKCornerClipTypeNone;
      
    }
  }
  
  return cell;
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 60 * ScreenScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return 0.000001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
  return [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  NIMSession *session;
  XKContactModel *model = self.dataArray[indexPath.row];
  session = [NIMSession session:model.accid type:NIMSessionTypeP2P];
  XKSecretChatViewController *vc = [[XKSecretChatViewController alloc] initWithSession:session];
  vc.secretID = _secretId;
  [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  
}

#pragma mark - Custom Delegates

#pragma mark – Getters and Setters
-(UITableView *)recentChatListTableView{
  if (!_recentChatListTableView) {
    _recentChatListTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, SCREEN_HEIGHT - NavigationAndStatue_Height -40) style:UITableViewStyleGrouped];
    _recentChatListTableView.delegate = self;
    _recentChatListTableView.dataSource = self;
    _recentChatListTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 10)];
    _recentChatListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  }
  return _recentChatListTableView;
}

@end
