//
//  XKCustomerServiceHistoryListViewController.m
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/19.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKCustomerServiceHistoryListViewController.h"
#import "XKRNMerchantCustomerConsultationModel.h"
#import "XKCustomerSerciveHistoryCell.h"
#import "XKFriendMessageListTableViewCell.h"
#import "XKCustomerSerHistoryConsultationViewController.h"

@interface XKCustomerServiceHistoryListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *consultations;

@end

@implementation XKCustomerServiceHistoryListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self postConsultations];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)handleData {
  [super handleData];
}

- (void)addCustomSubviews {
  [self hideNavigation];
  [self.view addSubview:self.tableView];
  self.emptyTipView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
  self.emptyTipView.config.allowScroll = YES;
  self.emptyTipView.config.viewAllowTap = YES;
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view.mas_left).offset(10);
    make.right.equalTo(self.view.mas_right).offset(-10);
    make.bottom.equalTo(self.view);
    make.top.equalTo(self.view.mas_top).offset(10);
  }];
}

#pragma mark 网络请求

- (void)postConsultations {
  NSMutableDictionary *para = [NSMutableDictionary dictionary];
  para[@"shopId"] = [XKUserInfo currentUser].currentShopId;
  if (self.serviceType == XKCustomerServiceTypeNormal) {
    para[@"taskStatus"] = @"normalFinish";
  } else if (self.serviceType == XKCustomerServiceTypeAbnormal) {
    para[@"taskStatus"] = @"abnormalFinish";
  }
  
  __weak typeof(self) weakSelf = self;
  [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig RNMerchantCustomerConsultationsUrl] timeoutInterval:20.0 parameters:para success:^(id responseObject) {
    [self.tableView.mj_header endRefreshing];
    [self.consultations removeAllObjects];
    if (responseObject) {
      NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
      NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
      for (NSDictionary *tempDic in array) {
        XKRNMerchantCustomerConsultationModel *consultation = [XKRNMerchantCustomerConsultationModel yy_modelWithDictionary:tempDic];
        if ([tempDic[@"msg"] isKindOfClass:[NSDictionary class]]) {
          NSDictionary *msgDic = tempDic[@"msg"];
          if ([msgDic[@"body"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *bodyDic = msgDic[@"body"];
            if ([bodyDic[@"type"] integerValue] == XK_NORMAL_TEXT) {
              consultation.msg.messageObject = [XKIMMessageNomalTextAttachment attachmentWithDict:bodyDic];
            } else if ([bodyDic[@"type"] integerValue] == XK_NORMAL_AUDIO) {
              consultation.msg.messageObject = [XKIMMessageAudioAttachment attachmentWithDict:bodyDic];
            } else if ([bodyDic[@"type"] integerValue] == XK_NORMAL_IMG) {
              consultation.msg.messageObject = [XKIMMessageNomalImageAttachment attachmentWithDict:bodyDic];
            } else if ([bodyDic[@"type"] integerValue] == XK_NORMAL_VIDEO) {
              consultation.msg.messageObject = [XKIMMessageNomalVideoAttachment attachmentWithDict:bodyDic];
            } else if ([bodyDic[@"type"] integerValue] == XK_CUSTOMER_SERVICE_ORDER) {
              consultation.msg.messageObject = [XKIMMessageCustomerSerOrderAttachment attachmentWithDict:bodyDic];
            }
            [self.consultations addObject:consultation];
          }
        }
      }
    }
    [self.tableView reloadData];
    if (self.consultations.count) {
      [self.emptyTipView hide];
    } else {
      [self.emptyTipView showWithImgName:kEmptyPlaceImgName title:@"温馨提示" des:@"暂无数据" tapClick:nil];
    }
  } failure:^(XKHttpErrror *error) {
    [self.tableView.mj_header endRefreshing];
    if (self.consultations.count == 0) {
      self.emptyTipView.config.viewAllowTap = YES;
      [self.emptyTipView showWithImgName:kNetErrorPlaceImgName title:@"温馨提示" des:@"网络错误 点击重试" tapClick:^{
        [weakSelf postConsultations];
      }];
    }
  }];
}

#pragma mark 响应事件

#pragma mark tableview代理 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.consultations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   if (self.serviceType == XKCustomerServiceTypeNormal) {
     return 60 * ScreenScale;
   } else {
      return 100 * ScreenScale;
   }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.serviceType == XKCustomerServiceTypeNormal) {
    XKFriendMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKFriendMessageListTableViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = HEX_RGB(0xFFFFFF);
    [cell configCellWithCustomerConsultationModel:self.consultations[indexPath.row]];
    if (self.consultations.count == 1) {
      cell.contentView.xk_radius = 8.0;
      cell.contentView.xk_clipType = XKCornerClipTypeAllCorners;
      cell.contentView.xk_openClip = YES;
      [cell.contentView xk_forceClip];
    } else {
      if(indexPath.row == 0) {
        cell.contentView.xk_radius = 8.0;
        cell.contentView.xk_clipType = XKCornerClipTypeTopBoth;
        cell.contentView.xk_openClip = YES;
        [cell.contentView xk_forceClip];
      } else if(indexPath.row == self.consultations.count - 1) {
        cell.contentView.xk_radius = 8.0;
        cell.contentView.xk_clipType = XKCornerClipTypeBottomBoth;
        cell.contentView.xk_openClip = YES;
        [cell.contentView xk_forceClip];
      } else {
        cell.contentView.xk_radius = 0.0;
        cell.contentView.xk_clipType = XKCornerClipTypeNone;
        cell.contentView.xk_openClip = YES;
        [cell.contentView xk_forceClip];
      }
    }
    return cell;
  } else {
    XKCustomerSerciveHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKCustomerSerciveHistoryCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = HEX_RGB(0xFFFFFF);
    [cell configCellWithCustomerConsultationModel:self.consultations[indexPath.row]];
    if (self.consultations.count == 1) {
      cell.contentView.xk_radius = 8.0;
      cell.contentView.xk_clipType = XKCornerClipTypeAllCorners;
      cell.contentView.xk_openClip = YES;
      [cell.contentView xk_forceClip];
    } else {
      if(indexPath.row == 0) {
        cell.contentView.xk_radius = 8.0;
        cell.contentView.xk_clipType = XKCornerClipTypeTopBoth;
        cell.contentView.xk_openClip = YES;
        [cell.contentView xk_forceClip];
      } else if(indexPath.row == self.consultations.count - 1) {
        cell.contentView.xk_radius = 8.0;
        cell.contentView.xk_clipType = XKCornerClipTypeBottomBoth;
        cell.contentView.xk_openClip = YES;
        [cell.contentView xk_forceClip];
      } else {
        cell.contentView.xk_radius = 0.0;
        cell.contentView.xk_clipType = XKCornerClipTypeNone;
        cell.contentView.xk_openClip = YES;
        [cell.contentView xk_forceClip];
      }
    }
    return cell;
  }
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
  XKRNMerchantCustomerConsultationModel *model = self.consultations[indexPath.row];
  XKCustomerSerHistoryConsultationViewController *vc = [[XKCustomerSerHistoryConsultationViewController alloc] init];
  vc.title = model.nickname;
  vc.vcType = XKCustomerSerHistoryConsultationVCTypeSingle;
  vc.taskId = model.taskId;
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 懒加载
- (UITableView *)tableView {
  if(!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[XKCustomerSerciveHistoryCell class] forCellReuseIdentifier:@"XKCustomerSerciveHistoryCell"];
    [_tableView registerClass:[XKFriendMessageListTableViewCell class] forCellReuseIdentifier:@"XKFriendMessageListTableViewCell"];
    _tableView.backgroundColor = [UIColor clearColor];
    XKWeakSelf(ws);
    MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      [ws postConsultations];
    }];
    _tableView.mj_header = narmalHeader;

  }
  return _tableView;
}

- (NSMutableArray *)consultations {
  if (!_consultations) {
    _consultations = [NSMutableArray array];
  }
  return _consultations;
}

@end
