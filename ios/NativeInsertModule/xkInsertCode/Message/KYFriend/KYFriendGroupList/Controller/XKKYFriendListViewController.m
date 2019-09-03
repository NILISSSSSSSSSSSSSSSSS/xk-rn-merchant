//
//  XKKYFriendListViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKKYFriendListViewController.h"
#import "XKFriendMessageListTableViewCell.h"
#import "XKGroupManageController.h"
#import "XKListXkGroupModel.h"
#import "XKFriendSyncListModel.h"
#import "XKIMGlobalMethod.h"
#import <NIMSDK/NIMSDK.h>

@interface XKKYFriendListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *bgView;
/**tableView*/
@property (nonatomic, strong) UITableView *tableView;
//每组的数据
@property (nonatomic, strong) NSMutableArray * sectionArray;
//存储是否展开的BOOL值
@property (nonatomic, strong) NSMutableArray * boolArray;
/**line*/
@property(nonatomic, strong) UIView *line;
/**
 存储聊天的最后的NIMRecentSession
 */
@property (nonatomic,strong) NSMutableArray *messageListDataArr;

@end

@implementation XKKYFriendListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self creatTableView];
  [self refreshData];
  [self hideNavigation];
  [self loadData];
  
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewReloadNotification) name:XKFriendChatListViewControllerRefreshDataNotification object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReloadNotification) name:XKKYFriendGroupChange object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReloadNotification) name:XKFriendListInfoChangeNoti object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XKFriendChatListViewControllerRefreshDataNotification object:nil];
  
}
- (void)viewReloadNotification {
  [self.tableView reloadData];
}

- (void)dataReloadNotification {
  [self refreshData];
  [self loadData];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)creatTableView {
  
  self.bgView = [[UIView alloc] init];
  [self.view addSubview:self.bgView];
  self.bgView.xk_radius = 8.0;
  self.bgView.xk_openClip = YES;
  self.bgView.xk_clipType = XKCornerClipTypeBottomBoth;
  
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  self.tableView.backgroundColor = [UIColor whiteColor];
  self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.showsVerticalScrollIndicator = NO;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.sectionFooterHeight = CGFLOAT_MIN;
  self.tableView.tableFooterView = [[UIView alloc] init];
  [self.bgView addSubview:self.tableView];
  
  XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
  config.backgroundColor = UIColorFromRGB(0xffffff);
  config.verticalOffset = -60 * ScreenHeightScale;
  self.emptyTipView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
  
  self.line = [[UIView alloc] init];
  self.line.backgroundColor = XKSeparatorLineColor;
  [self.view addSubview:self.line];
  
  [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0));
  }];
  
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(UIEdgeInsetsZero);
  }];
  
  [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view);
    make.top.equalTo(self.view.mas_top);
    make.height.mas_equalTo(1);
  }];
  // 注册cell
  [self.tableView registerClass:[XKFriendMessageListTableViewCell class] forCellReuseIdentifier:@"cell"];
  
}
/**
 请求列表数据
 */
- (void)refreshData {
  //以往消息的数组（从云信拉取）
  _messageListDataArr = [[XKIMGlobalMethod getLatestMessageListArray] mutableCopy];
  [self.tableView reloadData];
}

/**
 请求每组的列表
 */
- (void)loadFriendListDataWithid:(NSString *)gorupId complete:(void(^)(BOOL success , id responseObject))complete{
  [HTTPClient postEncryptRequestWithURLString:@"im/ua/friendGroupList/1.0" timeoutInterval:20.0 parameters:@{@"groupId":gorupId,@"limit":@0,@"page":@1} success:^(id responseObject) {
    complete(YES,responseObject);
  } failure:^(XKHttpErrror *error) {
    complete(NO,error.message);
  }];
}

/**
 请求列表数据
 */
- (void)loadData {
  [HTTPClient postEncryptRequestWithURLString:@"im/ua/xkGroupList/1.0" timeoutInterval:20.0 parameters:@{} success:^(id responseObject) {
    [self.sectionArray removeAllObjects];
    [self.boolArray removeAllObjects];
    
    NSArray *secArr = [NSArray yy_modelArrayWithClass:[XKListXkGroupModel class] json:responseObject].mutableCopy;
    if (secArr.count) {
      for (XKListXkGroupModel *model in secArr) {
        [self.boolArray addObject:@NO];
        [self.sectionArray addObject:model];
        NSLog(@"%@", model.ID);
        NSString *modelId = model.ID;
        [self loadFriendListDataWithid:modelId complete:^(BOOL success, id responseObject) {
          if (success) {
            if ([modelId isEqualToString:model.ID]) {
              model.dataArray = [XKFriendSyncListModel yy_modelWithJSON:responseObject].data;
            }
          }
        }];
      }
      [self.tableView reloadData];
      [self.emptyTipView hide];
    } else {
      self.emptyTipView.config.viewAllowTap = YES;
      [self.emptyTipView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:nil];
    }
  } failure:^(XKHttpErrror *error) {
    if (self.sectionArray.count == 0) {
      self.emptyTipView.config.allowScroll = YES;
      self.emptyTipView.config.viewAllowTap = YES;
      __weak typeof(self) weakSelf = self;
      [self.emptyTipView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
        [weakSelf loadData];
      }];
    }
  }];
}

#pragma mark -UITableViewDelegate,UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  XKFriendMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  [cell.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.right.and.bottom.mas_equalTo(cell.contentView);
    make.left.mas_equalTo(76);
    make.height.mas_equalTo(1);
  }];
  XKListXkGroupModel *model = self.sectionArray[indexPath.section];
  XKFriendSyncListDataItem *item = model.dataArray[indexPath.row];
  [self.messageListDataArr enumerateObjectsUsingBlock:^(NIMRecentSession *session, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([session.session.sessionId isEqualToString:item.accid]) {
      cell.recentSession = session;
      cell.lastMessageLabel.hidden = NO;
      cell.timeLabel.hidden = NO;
      *stop = YES;
    }else {
      [cell.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:kDefaultHeadImg];
      cell.userNameLabel.text = item.friendRemark ?:item.nickname;
      cell.remindImageView.hidden = YES;
      cell.messageCountLabel.hidden = YES;
      cell.lastMessageLabel.hidden = YES;
      cell.timeLabel.hidden = YES;
    }
  }];
  if (self.messageListDataArr.count == 0) {
    [cell.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:kDefaultHeadImg];
    cell.userNameLabel.text = item.friendRemark ?:item.nickname;
    cell.remindImageView.hidden = YES;
    cell.messageCountLabel.hidden = YES;
  }
  return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.sectionArray.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //判断是否展开，如果未展开则返回0
  if ([self.boolArray[section] boolValue] == NO) {
    return 0;
  }else {
    XKListXkGroupModel *model = self.sectionArray[section];
    return [model.dataArray count];
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  //创建header的view
  UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
  headerView.tag = 2016 + section;
  headerView.backgroundColor = [UIColor whiteColor];
  
  //添加imageview
  UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectZero];
  iv.contentMode = UIViewContentModeCenter;
  //三目运算选择展开或者闭合时候的图标
//  iv.image = [_boolArray[section] boolValue] ? [UIImage imageNamed:@"xk_btn_mall_ticket_down"] : [UIImage imageNamed:@"xk_btn_mall_ticket_right"];
  iv.image = [UIImage imageNamed:@"xk_btn_mall_ticket_right"];
  if ([_boolArray[section] boolValue]) {
    iv.transform = CGAffineTransformMakeRotation(M_PI_2);
  } else {
    iv.transform = CGAffineTransformMakeRotation(0.0);
  }
  [headerView addSubview:iv];
  [iv mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(headerView);
    make.width.mas_equalTo(12);
    make.height.mas_equalTo(12);
    make.left.mas_equalTo(15);
  }];
  //添加标题label
  UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.font = XKRegularFont(14);
  XKListXkGroupModel *model = self.sectionArray[section];
  label.text = model.groupName;
  label.textColor = HEX_RGB(0x222222);
  [headerView addSubview:label];
  [label mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(headerView);
    make.left.equalTo(iv.mas_right).offset(10);
    make.right.mas_equalTo(-20);
  }];
  //添加点击手势
  UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
  [headerView addGestureRecognizer:tap];
  //添加长按手势
  UILongPressGestureRecognizer *longp = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)];
  longp.minimumPressDuration = 1.0f;
  [headerView addGestureRecognizer:longp];
  
  return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 66;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  XKListXkGroupModel *model = self.sectionArray[indexPath.section];
  XKFriendSyncListDataItem *item = model.dataArray[indexPath.row];
  [XKIMGlobalMethod createP2PChatWithNIMID:item.accid];
}
#pragma mark - action
- (void)tapGR:(UITapGestureRecognizer *)tapGR {
  
  //获取section
  NSInteger section = tapGR.view.tag - 2016;
  //判断改变bool值
  if ([_boolArray[section] boolValue] == YES) {
    [_boolArray replaceObjectAtIndex:section withObject:@NO];
  }else {
    [_boolArray replaceObjectAtIndex:section withObject:@YES];
  }
  //刷新某个section
  [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)longTap:(UIGestureRecognizer *)longTap {
  if (longTap.state == UIGestureRecognizerStateBegan) {
    XKGroupManageController *vc = [[XKGroupManageController alloc]init];
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
  }
}
#pragma mark - setter and getter
- (NSMutableArray *)sectionArray {
  
  if (!_sectionArray) {
    
    _sectionArray = [[NSMutableArray alloc] init];
  }
  return _sectionArray;
}

- (NSMutableArray *)boolArray {
  
  if (!_boolArray) {
    
    _boolArray = [[NSMutableArray alloc] init];
  }
  return _boolArray;
}

@end
