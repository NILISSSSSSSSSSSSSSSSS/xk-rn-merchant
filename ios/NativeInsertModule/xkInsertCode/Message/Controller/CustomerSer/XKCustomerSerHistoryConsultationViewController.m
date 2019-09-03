//
//  XKCustomerSerHistoryConsultationViewController.m
//  xkMerchant
//
//  Created by xudehuai on 2019/1/31.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "XKCustomerSerHistoryConsultationViewController.h"
#import "XKIMMessageCustomerSerHistoryConfig.h"
#import "XKRNMerchantCustomerConsultationModel.h"
#import "XKIMMessageCustomConfig.h"
#import "XKCustomerSerHistoryConsultationHeaderView.h"
#import "XKCustomerSerHistoryConsultationFooterView.h"
#import <NIMMessageCell.h>
#import <NIMMessageCellFactory.h>
#import <NIMAvatarImageView.h>

@interface XKCustomerSerHistoryConsultationViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSUInteger startTime;

@property (nonatomic, assign) NSUInteger endTime;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, assign) NSUInteger maxCount;

@property (nonatomic, strong) NIMMessageCellFactory *cellFactory;

@end

@implementation XKCustomerSerHistoryConsultationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  [self setNavTitle:self.title WithColor:HEX_RGB(0xFFFFFF)];
  self.cellFactory = [[NIMMessageCellFactory alloc] init];
  
  [self initializeViews];
  [self updateViews];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[NIMKit sharedKit] registerLayoutConfig:[XKIMMessageCustomerSerHistoryConfig new]];
}

- (void)didPopToPreviousController {
  [[NIMKit sharedKit] registerLayoutConfig:[XKIMMessageCustomConfig new]];
}

- (void)initializeViews {
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.estimatedRowHeight = 0;
  self.tableView.estimatedSectionHeaderHeight = 0;
  self.tableView.estimatedSectionFooterHeight = 0;
  self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.tableView.backgroundColor = UIColorFromRGB(0xEEEEEE);
  [self.containView addSubview:self.tableView];
  
  __weak typeof(self) weakSelf = self;
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    if (weakSelf.datas.count >= weakSelf.maxCount) {
      [weakSelf.tableView.mj_header endRefreshing];
      return ;
    }
    [weakSelf postHistoryConsultations];
  }];
  
  self.emptyTipView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
  self.emptyTipView.config.allowScroll = YES;
  self.emptyTipView.config.viewAllowTap = YES;
  
  self.page = 1;
  [weakSelf postHistoryConsultations];
}

- (void)updateViews {
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(UIEdgeInsetsZero);
  }];
}

#pragma mark - POST

- (void)postHistoryConsultations {
  NSMutableDictionary *para = [NSMutableDictionary dictionary];
  NSString *urlStr;
  if (self.vcType == XKCustomerSerHistoryConsultationVCTypeSingle) {
    urlStr = @"im/ua/mCustomerTaskMsgRecords/1.0";
    para[@"taskId"] = self.taskId;
  } else if (self.vcType == XKCustomerSerHistoryConsultationVCTypeFull) {
    urlStr = @"im/ua/mCustomerUserMsgRecords/1.0";
    para[@"customerId"] = self.customerId;
    para[@"shopId"] = [XKUserInfo currentUser].currentShopId;
  }
  para[@"page"] = @(self.page);
  para[@"limit"] = @(10);
  
  [HTTPClient postEncryptRequestWithURLString:urlStr timeoutInterval:20.0 parameters:para success:^(id responseObject) {
    [self.tableView.mj_header endRefreshing];
    if (self.page == 1) {
      [self.datas removeAllObjects];
    }
    if (responseObject) {
      NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
      NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
      if (self.page == 1) {
        self.maxCount = dict[@"total"] && [dict[@"total"] integerValue] ? [dict[@"total"] integerValue] : 0;
        if (![dict[@"startTime"] isKindOfClass:[NSNull class]]) {
          self.startTime = [dict[@"startTime"] integerValue];
        }
        if (![dict[@"endTime"] isKindOfClass:[NSNull class]]) {
          self.endTime = [dict[@"endTime"] integerValue];
        }
      }
      NSArray *array = dict[@"data"];
      for (NSDictionary *tempDic in array) {
        XKRNMerchantCustomerConsultationMessageModel *msg = [XKRNMerchantCustomerConsultationMessageModel yy_modelWithDictionary:tempDic];
        if ([tempDic[@"body"] isKindOfClass:[NSDictionary class]]) {
          NSDictionary *bodyDic = tempDic[@"body"];
          if ([bodyDic[@"type"] integerValue] == XK_NORMAL_TEXT) {
            msg.messageObject = [XKIMMessageNomalTextAttachment attachmentWithDict:bodyDic];
          } else if ([bodyDic[@"type"] integerValue] == XK_NORMAL_AUDIO) {
            msg.messageObject = [XKIMMessageAudioAttachment attachmentWithDict:bodyDic];
          } else if ([bodyDic[@"type"] integerValue] == XK_NORMAL_IMG) {
            msg.messageObject = [XKIMMessageNomalImageAttachment attachmentWithDict:bodyDic];
          } else if ([bodyDic[@"type"] integerValue] == XK_NORMAL_VIDEO) {
            msg.messageObject = [XKIMMessageNomalVideoAttachment attachmentWithDict:bodyDic];
          } else if ([bodyDic[@"type"] integerValue] == XK_CUSTOMER_SERVICE_ORDER) {
            msg.messageObject = [XKIMMessageCustomerSerOrderAttachment attachmentWithDict:bodyDic];
          }
          [self.datas insertObject:msg atIndex:0];
        }
      }
    }
    [self refreshTableViewWithErrorStr:nil];
    
  } failure:^(XKHttpErrror *error) {
    [self.tableView.mj_header endRefreshing];
    [self refreshTableViewWithErrorStr:error.message];
  }];
}

#pragma mark - Privite Method

- (void)refreshTableViewWithErrorStr:(NSString *)errorStr {
  [self.tableView reloadData];
  
  __weak typeof(self) weakSelf = self;
  if (errorStr && errorStr.length) {
    if (self.datas.count == 0) {
      self.emptyTipView.config.viewAllowTap = YES;
      [self.emptyTipView showWithImgName:kNetErrorPlaceImgName title:errorStr des:@"点击屏幕重试" tapClick:^{
        [weakSelf postHistoryConsultations];
      }];
    }
  } else {
    if (self.datas.count) {
      self.page += 1;
      [self.emptyTipView hide];
    } else {
      self.emptyTipView.config.viewAllowTap = YES;
      [self.emptyTipView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:^{
        [weakSelf postHistoryConsultations];
      }];
    }
  }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (self.datas.count) {
    return 50.0;
  }
  return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (self.datas.count) {
    XKCustomerSerHistoryConsultationHeaderView *view = [[XKCustomerSerHistoryConsultationHeaderView alloc] init];
    view.timeLab.text = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%tu", self.startTime / 1000]];
    return view;
  }
  return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = nil;
  XKRNMerchantCustomerConsultationMessageModel *msg = self.datas[indexPath.row];
  NIMMessageModel *messageModel = [[NIMMessageModel alloc] init];
  [messageModel setValue:@(YES) forKey:@"shouldShowAvatar"];
  if ([msg.from isEqualToString:[XKUserInfo currentUser].userId]) {
    [messageModel setValue:@(NO) forKey:@"shouldShowLeft"];
  } else {
    [messageModel setValue:@(YES) forKey:@"shouldShowLeft"];
  }
  NIMMessage *message = [[NIMMessage alloc] init];
  NIMCustomObject *obj = [[NIMCustomObject alloc] init];
  obj.attachment = msg.messageObject;
  message.messageObject = obj;
  messageModel.message = message;
  cell = [self.cellFactory cellInTable:tableView forMessageMode:messageModel];
  [(NIMMessageCell *)cell refreshData:messageModel];
  if ([msg.from isEqualToString:[XKUserInfo currentUser].userId]) {
    [((NIMMessageCell *)cell).headImageView nim_setImageWithURL:[NSURL URLWithString:[XKUserInfo currentUser].avatar] placeholderImage:kDefaultHeadImg];
  } else {
    [((NIMMessageCell *)cell).headImageView nim_setImageWithURL:[NSURL URLWithString:msg.avatar] placeholderImage:kDefaultHeadImg];
  }
  ((NIMMessageCell *)cell).retryButton.hidden = YES;
  
  [(NIMMessageCell *)cell layoutSubviews];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  if (self.vcType == XKCustomerSerHistoryConsultationVCTypeFull &&
      self.datas.count) {
    return 66.0;
  }
  return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  if (self.vcType == XKCustomerSerHistoryConsultationVCTypeFull &&
      self.datas.count) {
    XKCustomerSerHistoryConsultationFooterView *view = [[XKCustomerSerHistoryConsultationFooterView alloc] init];
    view.timeLab.text = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%tu", self.endTime / 1000]];
    return view;
  }
  return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  XKIMMessageCustomConfig *config = [[XKIMMessageCustomConfig alloc] init];
  XKRNMerchantCustomerConsultationMessageModel *msg = self.datas[indexPath.row];
  NIMMessageModel *messageModel = [[NIMMessageModel alloc] init];
  NIMMessage *message = [[NIMMessage alloc] init];
  NIMCustomObject *obj = [[NIMCustomObject alloc] init];
  obj.attachment = msg.messageObject;
  message.messageObject = obj;
  messageModel.message = message;
  CGSize size = [config contentSize:messageModel cellWidth:SCREEN_WIDTH];
  UIEdgeInsets contentViewInsets = [config contentViewInsets:messageModel];
  UIEdgeInsets bubbleViewInsets  = [config cellInsets:messageModel];
  return size.height + contentViewInsets.top + contentViewInsets.bottom + bubbleViewInsets.top + bubbleViewInsets.bottom;
}

#pragma mark - Getter Setter

- (NSMutableArray *)datas {
  if (!_datas) {
    _datas = [NSMutableArray array];
  }
  return _datas;
}

@end
