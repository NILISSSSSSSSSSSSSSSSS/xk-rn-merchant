//
//  XKMyGrandPrizesSubViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/25.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMyGrandPrizesSubViewController.h"
#import "XKLotteryTicketWaitingChooseNumsTableViewCell.h"
#import "XKGrandPrizeTimeTableViewCell.h"
#import "XKGrandPrizeProgressTableViewCell.h"
#import "XKGrandPrizeTimeAndProgressTableViewCell.h"
#import "XKGrandPrizeTimeOrProgressTableViewCell.h"
#import "XKGrandPrizeAlreadyTableViewCell.h"
#import "XKGrandPrizeModel.h"
#import "XKContactListController.h"
#import "XKGrandPrizeConfirmOrderViewController.h"
#import "XKGrandPrizeFeedBackViewController.h"
#import "XKMallOrderTraceViewController.h"
#import "XKGrandPrizeDetailViewController.h"
#import "XKMyGrandPrizesViewController.h"

@interface XKMyGrandPrizesSubViewController () <UITableViewDataSource, UITableViewDelegate, XKCustomShareViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) XKEmptyPlaceView *emptyView;

@property (nonatomic, strong) NSMutableArray *grandPrizes;

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, assign) NSUInteger grandPrizeCount;


@property (nonatomic, strong) NSIndexPath *shareIndexPath;

@end

@implementation XKMyGrandPrizesSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (self.vcType != XKMyGrandPrizeSubVCTypeWaitingChooseNums) {
        self.tableView.estimatedRowHeight = 160.0;

    } else {
        self.tableView.rowHeight = 110.0;
    }
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = HEX_RGB(0xf1f1f1);
    self.tableView.separatorInset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
    self.tableView.backgroundColor = HEX_RGB(0xF6F6F6);
    [self.tableView registerClass:[XKLotteryTicketWaitingChooseNumsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKLotteryTicketWaitingChooseNumsTableViewCell class])];
    [self.tableView registerClass:[XKGrandPrizeTimeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKGrandPrizeTimeTableViewCell class])];
    [self.tableView registerClass:[XKGrandPrizeProgressTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKGrandPrizeProgressTableViewCell class])];
    [self.tableView registerClass:[XKGrandPrizeTimeAndProgressTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKGrandPrizeTimeAndProgressTableViewCell class])];
    [self.tableView registerClass:[XKGrandPrizeTimeOrProgressTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKGrandPrizeTimeOrProgressTableViewCell class])];
    [self.tableView registerClass:[XKGrandPrizeAlreadyTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKGrandPrizeAlreadyTableViewCell class])];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf postGrandPrizes];
    }];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.grandPrizes.count >= weakSelf.grandPrizeCount) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [weakSelf postGrandPrizes];
    }];
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经到底了～" forState:MJRefreshStateNoMoreData];
    footer.ignoredScrollViewContentInsetBottom = kBottomSafeHeight;
    
    self.tableView.mj_footer = footer;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    self.emptyView.config.verticalOffset = -75.0;
    
    self.page = 1;
    [self postGrandPrizes];
}

#pragma mark - POST
// 大奖列表
- (void)postGrandPrizes {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [HTTPClient postEncryptRequestWithURLString:@"" timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.page == 1) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.grandPrizes removeAllObjects];
        }
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (self.page == 1) {
                self.grandPrizeCount = dict[@"total"] ? [dict[@"total"] integerValue] : 0;
            }
            [self.grandPrizes addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKGrandPrizeModel class] json:dict[@"data"]]];
            [self.tableView reloadData];
        }
        if (self.grandPrizes.count) {
            [self.emptyView hide];
        } else {
            self.emptyView.config.viewAllowTap = YES;
            [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:nil];
        }
        self.page += 1;
    } failure:^(XKHttpErrror *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.grandPrizes.count == 0) {
            __weak typeof(self) weakSelf = self;
            self.emptyView.config.viewAllowTap = YES;
            [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [weakSelf postGrandPrizes];
            }];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.grandPrizes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.vcType == XKMyGrandPrizeSubVCTypeWaitingChooseNums) {
        XKLotteryTicketWaitingChooseNumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKLotteryTicketWaitingChooseNumsTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.confirmBtnBlock = ^{
            
        };
        return cell;
    } else if (self.vcType == XKMyGrandPrizeSubVCTypeWaiting) {
        UITableViewCell *cell;
        XKGrandPrizeModel *grandPrize = self.grandPrizes[indexPath.row];
        UIView *containerView;
        __weak typeof(self) weakSelf = self;
        if (indexPath.row % 4 == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKGrandPrizeTimeTableViewCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            XKGrandPrizeTimeTableViewCell *theCell = (XKGrandPrizeTimeTableViewCell *)cell;
            containerView = theCell.containerView;
            [theCell configCellWithGrandPrizeModel:grandPrize detailBtnBlock:^{
//                订单详情
                XKGrandPrizeDetailViewController *vc = [[XKGrandPrizeDetailViewController alloc] init];
                [vc creatWkWebViewWithMethodNameArray:@[] requestUrlString:@"http://www.bing.com"];
                [weakSelf.parentViewController.navigationController pushViewController:vc animated:YES];
            }];
        } else if (indexPath.row % 4 == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKGrandPrizeProgressTableViewCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            XKGrandPrizeProgressTableViewCell *theCell = (XKGrandPrizeProgressTableViewCell *)cell;
            containerView = theCell.containerView;
            [theCell configCellWithGrandPrizeModel:grandPrize detailBtnBlock:^{
//                订单详情
                XKGrandPrizeDetailViewController *vc = [[XKGrandPrizeDetailViewController alloc] init];
                [vc creatWkWebViewWithMethodNameArray:@[] requestUrlString:@"http://www.bing.com"];
                [weakSelf.parentViewController.navigationController pushViewController:vc animated:YES];
            }];
        } else if ((indexPath.row % 4 == 2)) {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKGrandPrizeTimeAndProgressTableViewCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            XKGrandPrizeTimeAndProgressTableViewCell *theCell = (XKGrandPrizeTimeAndProgressTableViewCell *)cell;
            containerView = theCell.containerView;
            [theCell configCellWithGrandPrizeModel:grandPrize detailBtnBlock:^{
//                订单详情
                XKGrandPrizeDetailViewController *vc = [[XKGrandPrizeDetailViewController alloc] init];
                [vc creatWkWebViewWithMethodNameArray:@[] requestUrlString:@"http://www.bing.com"];
                [weakSelf.parentViewController.navigationController pushViewController:vc animated:YES];
            }];
        } else if ((indexPath.row % 4 == 3)) {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKGrandPrizeTimeOrProgressTableViewCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            XKGrandPrizeTimeOrProgressTableViewCell *theCell = (XKGrandPrizeTimeOrProgressTableViewCell *)cell;
            containerView = theCell.containerView;
            [theCell configCellWithGrandPrizeModel:grandPrize detailBtnBlock:^{
//                订单详情
                XKGrandPrizeDetailViewController *vc = [[XKGrandPrizeDetailViewController alloc] init];
                [vc creatWkWebViewWithMethodNameArray:@[] requestUrlString:@"http://www.bing.com"];
                [weakSelf.parentViewController.navigationController pushViewController:vc animated:YES];
            }];
        }
        if (self.grandPrizes.count == 1) {
            containerView.xk_radius = 8.0;
            containerView.xk_clipType =XKCornerClipTypeAllCorners;
            containerView.xk_openClip = YES;
            [containerView xk_forceClip];
        } else if (indexPath.row == 0) {
            containerView.xk_radius = 8.0;
            containerView.xk_clipType =XKCornerClipTypeTopBoth;
            containerView.xk_openClip = YES;
            [containerView xk_forceClip];
        } else if (indexPath.row == self.grandPrizes.count - 1) {
            containerView.xk_radius = 8.0;
            containerView.xk_clipType =XKCornerClipTypeBottomBoth;
            containerView.xk_openClip = YES;
            [containerView xk_forceClip];
        } else {
            containerView.xk_radius = 0.0;
            containerView.xk_clipType =XKCornerClipTypeNone;
            containerView.xk_openClip = YES;
            [containerView xk_forceClip];
        }
        return cell;
    } else {
        XKGrandPrizeAlreadyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKGrandPrizeAlreadyTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        XKGrandPrizeModel *grandPrize = [[XKGrandPrizeModel alloc] init];
        [cell configCellWithGrandPrizeModel:grandPrize];
        __weak typeof(self) weakSelf = self;
        cell.shareBtnBlock = ^(XKGrandPrizeModel * _Nonnull grandPrize) {
//            分享
            weakSelf.shareIndexPath = indexPath;
            XKCustomShareView *shareView = [[XKCustomShareView alloc] init];
            shareView.autoThirdShare = YES;
            shareView.customView = nil;
            shareView.delegate = self;
            shareView.layoutType = XKCustomShareViewLayoutTypeBottom;
            shareView.shareItems = [@[XKShareItemTypeCircleOfFriends,
                                      XKShareItemTypeWechatFriends,
                                      XKShareItemTypeQQ,
                                      XKShareItemTypeSinaWeibo,
                                      XKShareItemTypeMyFriends,
                                      XKShareItemTypeCopyLink
                                      ] mutableCopy];
            XKShareDataModel *shareData = [[XKShareDataModel alloc] init];
            shareData.title = @"";
            shareData.content = @"";
            shareData.url = @"www.baidu.com";
            shareData.img = @"";
            shareView.shareData = shareData;
            [shareView showInView:nil];
        };
        cell.confirmOrderBtnBlock = ^(XKGrandPrizeModel * _Nonnull grandPrize) {
//            确认订单
            XKGrandPrizeConfirmOrderViewController *vc = [[XKGrandPrizeConfirmOrderViewController alloc] init];
            [weakSelf.parentViewController.navigationController pushViewController:vc animated:YES];
        };
        cell.showOrderBtnBlock = ^(XKGrandPrizeModel * _Nonnull grandPrize) {
//            晒单
            XKGrandPrizeFeedBackViewController *vc = [[XKGrandPrizeFeedBackViewController alloc] init];
            vc.vcType = XKGrandPrizeFeedBackVCTypeShowOrder;
            [weakSelf.parentViewController.navigationController pushViewController:vc animated:YES];
        };
        cell.logisticsBtnBlock = ^(XKGrandPrizeModel * _Nonnull grandPrize) {
//            物流
            XKMallOrderTraceViewController *vc = [[XKMallOrderTraceViewController alloc] init];
            [weakSelf.parentViewController.navigationController pushViewController:vc animated:YES];
        };
        cell.detailBtnBlock = ^(XKGrandPrizeModel * _Nonnull grandPrize) {
//            订单详情
            XKGrandPrizeDetailViewController *vc = [[XKGrandPrizeDetailViewController alloc] init];
            [vc creatWkWebViewWithMethodNameArray:@[] requestUrlString:@"http://www.bing.com"];
            [weakSelf.parentViewController.navigationController pushViewController:vc animated:YES];
        };
        if (self.grandPrizes.count == 1) {
            cell.containerView.xk_radius = 8.0;
            cell.containerView.xk_clipType =XKCornerClipTypeAllCorners;
            cell.containerView.xk_openClip = YES;
            [cell.containerView xk_forceClip];
        } else if (indexPath.row == 0) {
            cell.containerView.xk_radius = 8.0;
            cell.containerView.xk_clipType =XKCornerClipTypeTopBoth;
            cell.containerView.xk_openClip = YES;
            [cell.containerView xk_forceClip];
        } else if (indexPath.row == self.grandPrizes.count - 1) {
            cell.containerView.xk_radius = 8.0;
            cell.containerView.xk_clipType =XKCornerClipTypeBottomBoth;
            cell.containerView.xk_openClip = YES;
            [cell.containerView xk_forceClip];
        } else {
            cell.containerView.xk_radius = 0.0;
            cell.containerView.xk_clipType =XKCornerClipTypeNone;
            cell.containerView.xk_openClip = YES;
            [cell.containerView xk_forceClip];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - XKCustomShareViewDelegate

- (void)customShareView:(XKCustomShareView *) customShareView didClickedShareItem:(NSString *) shareItem {
    if ([shareItem isEqualToString:XKShareItemTypeMyFriends]) {
        XKContactListController *vc = [[XKContactListController alloc] init];
        vc.useType = XKContactUseTypeManySelect;
        vc.rightButtonText = @"完成";
        vc.sureClickBlock = ^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
            [listVC.navigationController popViewControllerAnimated:YES];
        };
        [self.parentViewController.navigationController pushViewController:vc animated:YES];
    }
    else if ([shareItem isEqualToString:XKShareItemTypeCopyLink]) {
        [UIPasteboard generalPasteboard].string = @"";
        [XKAlertView showCommonAlertViewWithTitle:@"链接已复制"];
    }
}

- (void)customShareView:(XKCustomShareView *)customShareView didAutoThirdShareSucceed:(NSString *)shareItem {
//    分享成功
//    先请求接口，告知后台分享成功了
    [self postSetGrandPrizeSharedWithIndexPath:self.shareIndexPath];
}

#pragma mark - POST
// 告知后台分享操作成功，修改状态，便于二次进入后可继续操作
- (void)postSetGrandPrizeSharedWithIndexPath:(NSIndexPath *) indexPath {
    XKMyGrandPrizesViewController *vc = (XKMyGrandPrizesViewController *)self.parentViewController;
    [XKHudView showLoadingTo:vc.containView animated:YES];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [HTTPClient postEncryptRequestWithURLString:@"" timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [XKHudView hideHUDForView:vc.containView];
//        更新数据源，刷新页面
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        后台修改状态成功
        if (1) {
//            虚拟货币 - 直接存入用户账户
            [XKHudView showSuccessMessage:@"分享成功，奖品已存入您的账户"];
        } else {
//            实物 - 跳转确认订单页面
            [XKHudView showSuccessMessage:@"分享成功，请确认订单"];
//            此处，待提示框显示完后，才进行页面跳转
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                XKGrandPrizeConfirmOrderViewController *vc = [[XKGrandPrizeConfirmOrderViewController alloc] init];
                [self.parentViewController.navigationController pushViewController:vc animated:YES];
            });
        }
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:vc.containView];
        [XKHudView showErrorMessage:error.message to:vc.containView animated:YES];
    }];
}

#pragma mark - getter setter

- (NSMutableArray *)grandPrizes {
    if (!_grandPrizes) {
        _grandPrizes = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            XKGrandPrizeModel *grandPrize = [[XKGrandPrizeModel alloc] init];
            [_grandPrizes addObject:grandPrize];
        }
    }
    return _grandPrizes;
}

@end
