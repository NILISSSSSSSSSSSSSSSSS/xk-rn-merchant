//
//  XKMainWaitPayViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderWaitPayViewController.h"
#import "XKMallOrderWaitPaySingleCell.h"
#import "XKMallOrderListBottomView.h"
#import "XKMallOrderWaitPayManyCell.h"
#import "XKAlertView.h"
#import "XKMallOrderDetailWaitPayViewController.h"
#import "XKMallOrderViewModel.h"
#import "XKPayAlertSheetView.h"
#import "XKMallOrderDetailInfoTableViewCell.h"
@interface XKMallOrderWaitPayViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XKMallOrderListBottomView *bottomView;
@property (nonatomic, strong) XKMallOrderViewModel *viewModel;;
@end

@implementation XKMallOrderWaitPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
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
    XKWeakSelf(ws);
    [self hideNavigation];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];

    self.emptyTipView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    
    self.cancelOrderBlock = ^{
        MallOrderListDataItem *item = ws.viewModel.dataArr[ws.cancelIndex];
        [ws cancelOrderWithGoodsItem:item suucessBlock:^(id  _Nonnull data) {
            [XKHudView showSuccessMessage:@"取消成功"];
            [ws.tableView.mj_header beginRefreshing];
        } failedBlock:^(NSString * _Nonnull reason) {
            [XKHudView showErrorMessage:reason];
        }];
    };
    
    self.payOrderBlock = ^{
         [XKHudView showSuccessMessage:@"支付成功"];
        [ws.tableView.mj_header beginRefreshing];
    };

 
}

#pragma mark 网络请求
- (void)requestDataWithTips:(BOOL)tip {
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
    [XKMallOrderListWaitPayModel requestMallOrderListWithType:MOT_PRE_PAY ParamDic:dic Success:^(XKMallOrderListWaitPayModel *model) {
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
            [ws requestDataWithTips:YES];
        }];
    } else {//请求更多出错
        [self.emptyTipView hide];
        [XKHudView showErrorMessage:reason];
    }
}

#pragma mark 响应事件



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
        XKMallOrderWaitPayManyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderWaitPayManyCell" forIndexPath:indexPath];
        [cell bindData:item];
        
        cell.choseBtnBlock = ^(UIButton *sender,NSIndexPath *index) {
            
        };
        
        cell.payBtnBlock = ^(UIButton *sender,NSIndexPath *index) {
            MallOrderListDataItem *item = ws.viewModel.dataArr[index.section];
            [ws showPayWithItem:item successBlock:^(id  _Nonnull data) {
                [XKHudView showSuccessMessage:@"支付成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ws.navigationController popViewControllerAnimated:YES];
                });
               
            } failedBlock:^(NSString * _Nonnull reason) {
                 [XKHudView showErrorMessage:reason];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [ws.navigationController popViewControllerAnimated:YES];
                });
            }];
           
        };
        
        cell.moreBtnBlock = ^(UIButton *sender,NSIndexPath *index) {
             MallOrderListDataItem *item = ws.viewModel.dataArr[index.section];
             ws.cancelIndex = index.section;
            [ws moreBtnClickForList:sender withGoodsItem:item functionName:@[@"联系客服",@"取消订单"]];
        };
        
        cell.selectedBlock = ^(NSIndexPath *index) {
            [ws tableView:ws.tableView didSelectRowAtIndexPath:index];
        };
        return cell;
    } else {
        XKMallOrderWaitPaySingleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderWaitPaySingleCell" forIndexPath:indexPath];
        [cell bindData:item];
        
        cell.choseBtnBlock = ^(UIButton *sender,NSIndexPath *index) {
        };
    
        cell.payBtnBlock = ^(UIButton *sender,NSIndexPath *index) {
            MallOrderListDataItem *item = ws.viewModel.dataArr[index.section];
            [ws showPayWithItem:item successBlock:^(id  _Nonnull data) {
                [XKHudView showSuccessMessage:@"支付成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ws.navigationController popViewControllerAnimated:YES];
                });
                
            } failedBlock:^(NSString * _Nonnull reason) {
                [XKHudView showErrorMessage:reason];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ws.navigationController popViewControllerAnimated:YES];
                });
            }];
        };
    
        cell.moreBtnBlock = ^(UIButton *sender,NSIndexPath *index) {
            MallOrderListDataItem *item = ws.viewModel.dataArr[index.section];
             ws.cancelIndex = index.section;
            [ws moreBtnClickForList:sender withGoodsItem:item functionName:@[@"联系客服",@"取消订单"]];

        };
        return cell;
    }
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
    XKMallOrderDetailWaitPayViewController *detail = [XKMallOrderDetailWaitPayViewController new];
    detail.orderId = item.orderId;
    [self.parentViewController.navigationController pushViewController:detail animated:YES];
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
       CGFloat h = self.entryType == 0 ?  SCREEN_HEIGHT - NavigationAndStatue_Height - 40 - 40 - kBottomSafeHeight: SCREEN_HEIGHT - NavigationAndStatue_Height - 50  - TabBar_Height - 40 - 40;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
     
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XKMallOrderWaitPaySingleCell class] forCellReuseIdentifier:@"XKMallOrderWaitPaySingleCell"];
        [_tableView registerClass:[XKMallOrderWaitPayManyCell class] forCellReuseIdentifier:@"XKMallOrderWaitPayManyCell"];
        XKWeakSelf(ws);
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ws.viewModel.page = 0;
            [ws requestDataWithTips:NO];
        }];
        _tableView.mj_header = narmalHeader;
        
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [ws requestDataWithTips:NO];
        }];
        [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
        _tableView.mj_footer = foot;

    }
    return _tableView;
}

- (XKMallOrderListBottomView *)bottomView {
    if(!_bottomView) {
        XKWeakSelf(ws);
        _bottomView = [XKMallOrderListBottomView MallOrderListBottomViewWithType:MallOrderListBottomViewWaitPay];
        CGFloat y = self.entryType == 0 ?  SCREEN_HEIGHT - NavigationAndStatue_Height - 40 - 40 - kBottomSafeHeight: SCREEN_HEIGHT - NavigationAndStatue_Height - 50  - TabBar_Height - 40 - 40;
        _bottomView.frame = CGRectMake(0, y, SCREEN_WIDTH, 50 + kBottomSafeHeight);

        _bottomView.choseBlock = ^(UIButton *sender) {
            for (MallOrderListDataItem *item in ws.viewModel.dataArr) {
                item.isChose = sender.isSelected;
                [ws.tableView reloadData];
            };
        };
        
        _bottomView.totalBtnBlock = ^(UIButton *sender) {
          
        //    [ws showPayWithItems:nil];
        };
    }
    return _bottomView;
}


@end
