//
//  XKMainOrderAfterSaleViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderAfterSaleViewController.h"
#import "XKMallOrderAfterSaleSingleCell.h"
#import "XKMallOrderAfterSaleManyCell.h"
#import "XKAlertView.h"
#import "XKMallOrderApplyRefundViewController.h"
#import "XKMallOrderViewModel.h"
#import "XKRefundProgressViewController.h"
#import "XKMallOrderRefundWaittingViewController.h"
#import "XKMallOrderRefundWaitSendViewController.h"
#import "XKMallOrderApplyRefundGoodsViewController.h"
#import "XKMallOrderApplyRefundViewController.h"

@interface XKMallOrderAfterSaleViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)XKMallOrderViewModel *viewModel;
@end

@implementation XKMallOrderAfterSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)handleData {
    [super handleData];
    _viewModel = [XKMallOrderViewModel new];
    _viewModel.limit = 10;
    _viewModel.page = 0;
    
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    [self.view addSubview:self.tableView];
    self.emptyTipView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    
    self.cancelOrderBlock = ^{
        MallOrderListDataItem *item = ws.viewModel.dataArr[ws.cancelIndex];
        [ws cancelGoodsReturnWithGoodsItem:item suucessBlock:^(id  _Nonnull data) {
            [XKHudView showSuccessMessage:@"取消成功"];
            [ws.tableView.mj_header beginRefreshing];
        } failedBlock:^(NSString * _Nonnull reason) {
             [XKHudView showErrorMessage:reason];
        }];
    };
}

#pragma mark 网络请求
- (void)requestWithTip:(BOOL)tip {
    if(tip) {
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    _viewModel.page ++;
    if(_viewModel.page == 1) {
        _viewModel.timestamp = ceilf([[NSDate date] timeIntervalSince1970]);
    }
    NSDictionary *dic = @{
                          @"page":@(_viewModel.page),
                          @"limit":@(_viewModel.limit),
                          @"lastUpdateAt":@(_viewModel.timestamp)
                          };
    [XKMallOrderListWaitPayModel requestMallOrderListWithType:MOT_SALED_SERVICE ParamDic:dic Success:^(XKMallOrderListWaitPayModel *model) {
        [self handleSuccessDataWithModel:model];
    } failed:^(NSString *failedReason, NSInteger code) {
        [self handleErrorDataWithReason:failedReason];
    }];
}

- (void)handleSuccessDataWithModel:(XKMallOrderListWaitPayModel *)model {
    [XKHudView hideAllHud];
    [self.emptyTipView hide];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    if (_viewModel.page == 1) {
        _viewModel.dataArr = nil;
        if (model == nil) {//第一页没数据
            self.emptyTipView.config.viewAllowTap = YES;
            [self.emptyTipView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据，点击屏幕刷新" tapClick:^{
                [self.tableView.mj_header beginRefreshing];
            }];
        }
    }
    
    if (model == nil) {
        _viewModel.page --;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:_viewModel.dataArr];
        [tmp addObjectsFromArray:model.data];
        _viewModel.dataArr = [tmp copy];
    }
    [self.tableView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    _viewModel.page --;
    XKWeakSelf(ws);
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    if (self.viewModel.dataArr.count == 0) {//无数据 请求第一页 请求出错
        self.emptyTipView.config.viewAllowTap = YES;
        [self.emptyTipView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
            [ws requestWithTip:YES];
        }];
    } else {//请求更多出错
        [self.emptyTipView hide];
        [XKHudView showErrorMessage:reason];
    }
}

#pragma mark tableview代理 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewModel.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MallOrderListDataItem *item = _viewModel.dataArr[indexPath.section];
    return item.goods.count == 1 ? 175 : 190;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    MallOrderListDataItem *item = _viewModel.dataArr[indexPath.section];
    item.index = indexPath;
    if(item.goods.count > 1) {
        XKMallOrderAfterSaleManyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderAfterSaleManyCell" forIndexPath:indexPath];
        [cell bindData:item];
        cell.cancelBtnBlock = ^(UIButton *sender, NSIndexPath *index) {
            MallOrderListDataItem *item = ws.viewModel.dataArr[indexPath.section];
            if ([item.refundStatus isEqualToString:@"REFUSED"]) {
                if ([item.refundType isEqualToString:@"REFUND"]) {
                    XKMallOrderApplyRefundViewController * refund = [XKMallOrderApplyRefundViewController new];
                    refund.orderId = item.orderId;
                    refund.goodsArr = item.goods;
                    refund.refundType = @"REFUND";
                    [ws.navigationController pushViewController:refund animated:YES];
                } else if ([item.refundStatus isEqualToString:@"REFUND_GOODS"])  {
                    XKMallOrderApplyRefundGoodsViewController   *refund = [XKMallOrderApplyRefundGoodsViewController new];
                    refund.refundType = @"REFUND_GOODS";
                    refund.goodsArr = item.goods;
                    refund.orderId = item.orderId;
                    [self.navigationController pushViewController:refund animated:YES];
                }
            } else {
                [ws presentViewController:ws.cancelAlert animated:YES completion:nil];
            }
           
        };
        
        cell.selectedBlock = ^(NSIndexPath *index) {
            [ws tableView:ws.tableView didSelectRowAtIndexPath:index];
        };
        return cell;
    }
    
    XKMallOrderAfterSaleSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderAfterSaleSingleCell" forIndexPath:indexPath];
    [cell bindData:item];
    cell.cancelBtnBlock = ^(UIButton *sender, NSIndexPath *index) {
        MallOrderListDataItem *item = ws.viewModel.dataArr[indexPath.section];
        if ([item.refundStatus isEqualToString:@"REFUSED"]) {
            if ([item.refundType isEqualToString:@"REFUND"]) {
                XKMallOrderApplyRefundViewController * refund = [XKMallOrderApplyRefundViewController new];
                refund.orderId = item.orderId;
                refund.goodsArr = item.goods;
                refund.refundType = @"REFUND";
                [ws.navigationController pushViewController:refund animated:YES];
            } else if ([item.refundStatus isEqualToString:@"REFUND_GOODS"])  {
                XKMallOrderApplyRefundGoodsViewController   *refund = [XKMallOrderApplyRefundGoodsViewController new];
                refund.refundType = @"REFUND_GOODS";
                refund.goodsArr = item.goods;
                refund.orderId = item.orderId;
                [self.navigationController pushViewController:refund animated:YES];
            }
        } else if ([item.refundStatus isEqualToString:@"APPLY"]) {
            [ws presentViewController:ws.cancelAlert animated:YES completion:nil];
        } else {
            MallOrderListDataItem *item = ws.viewModel.dataArr[indexPath.section];
            XKRefundProgressViewController *progress = [XKRefundProgressViewController new];
            progress.refundId = item.refundId;
            [[self getCurrentUIVC].navigationController pushViewController:progress animated:YES];
        }
        
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == _viewModel.dataArr.count - 1 ? 10 : 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MallOrderListDataItem *item = _viewModel.dataArr[indexPath.section];
    if ([item.refundType isEqualToString:@"REFUND"]) {
        XKRefundProgressViewController *progress = [XKRefundProgressViewController new];
        progress.refundId = item.refundId;
        [[self getCurrentUIVC].navigationController pushViewController:progress animated:YES];
    } else {
        if ([item.refundStatus isEqualToString:@"APPLY"]) {
            XKMallOrderRefundWaittingViewController *waitting = [XKMallOrderRefundWaittingViewController new];
            waitting.item = item;
            [[self getCurrentUIVC].navigationController pushViewController:waitting animated:YES];
        } else if ([item.refundStatus isEqualToString:@"PRE_USER_SHIP"]) {
            XKMallOrderRefundWaitSendViewController *waitSend = [XKMallOrderRefundWaitSendViewController new];
            waitSend.item = item;
            [[self getCurrentUIVC].navigationController pushViewController:waitSend animated:YES];
        } else if ([item.refundStatus isEqualToString:@"REFUSED"]) {
            XKMallOrderApplyRefundGoodsViewController *refund = [XKMallOrderApplyRefundGoodsViewController new];
            refund.item = item;
            refund.refundType =  @"REFUND_GOODS";
            refund.goodsArr = item.goods;
            refund.orderId = item.orderId;
            [[self getCurrentUIVC].navigationController pushViewController:refund animated:YES];
        } else {
            XKRefundProgressViewController *progress = [XKRefundProgressViewController new];
            progress.refundId = item.refundId;
            [[self getCurrentUIVC].navigationController pushViewController:progress animated:YES];
        }
    }

}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        CGFloat h = self.entryType == 0 ?  SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight : SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight - TabBar_Height;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10,0, SCREEN_WIDTH - 20,  h) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XKMallOrderAfterSaleSingleCell class] forCellReuseIdentifier:@"XKMallOrderAfterSaleSingleCell"];
        [_tableView registerClass:[XKMallOrderAfterSaleManyCell class] forCellReuseIdentifier:@"XKMallOrderAfterSaleManyCell"];
        XKWeakSelf(ws);
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ws.viewModel.page = 0;
            [ws requestWithTip:NO];
        }];
        _tableView.mj_header = narmalHeader;
        
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [ws requestWithTip:NO];
        }];
        [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
        _tableView.mj_footer = foot;
        
    }
    return _tableView;
}



@end
