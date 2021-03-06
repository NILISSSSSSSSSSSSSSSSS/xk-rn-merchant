//
//  XKMallOrderFinishViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderFinishViewController.h"
#import "XKMallOrderFinishSingleCell.h"
#import "XKMallOrderFinishManyCell.h"
#import "XKAlertView.h"
#import "XKMenuView.h"
#import "XKMallApplyAfterSaleListViewController.h"
#import "XKMallOrderDetailFinishViewController.h"
#import "XKMallOrderViewModel.h"
#import "XKCustomeSerMessageManager.h"
#import "XKMallOrderDetailWaitPayViewController.h"
@interface XKMallOrderFinishViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)XKMallOrderViewModel *viewModel;
@end

@implementation XKMallOrderFinishViewController

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
    [self hideNavigation];
    [self.view addSubview:self.tableView];
    self.emptyTipView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
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
    [XKMallOrderListWaitPayModel requestMallOrderListWithType:MOT_COMPLETELY ParamDic:dic Success:^(XKMallOrderListWaitPayModel *model) {
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
        XKMallOrderFinishManyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderFinishManyCell" forIndexPath:indexPath];
        [cell bindData:item];
        cell.moreBtnBlock = ^(UIButton *sender, NSIndexPath *index) {
            MallOrderListDataItem *item = ws.viewModel.dataArr[index.section];
            [ws moreBtnClickForList:sender withGoodsItem:item functionName:@[@"联系客服",@"查看物流"]];
        };
        
        cell.selectedBlock = ^(NSIndexPath *index) {
            [ws tableView:ws.tableView didSelectRowAtIndexPath:index];
        };
        return cell;
    } else {
    
        XKMallOrderFinishSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderFinishSingleCell" forIndexPath:indexPath];
        [cell bindData:item];
        cell.moreBtnBlock = ^(UIButton *sender, NSIndexPath *index) {
            MallOrderListDataItem *item = ws.viewModel.dataArr[index.section];
            [ws moreBtnClickForList:sender withGoodsItem:item functionName:@[@"联系客服",@"查看物流"]];
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
    if ([item.status isEqualToString:@"del"]) {
        XKMallOrderDetailWaitPayViewController *cancel = [XKMallOrderDetailWaitPayViewController new];
        cancel.orderId = item.orderId;
        [[self getCurrentUIVC].navigationController pushViewController:cancel animated:YES];
    } else {
        XKMallOrderDetailFinishViewController *detail = [XKMallOrderDetailFinishViewController new];
        [detail updateModelWithItem:item];
        detail.orderId = item.orderId;
        [[self getCurrentUIVC].navigationController pushViewController:detail animated:YES];
    }

  
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        CGFloat h = self.entryType == 0 ?  SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight : SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight - TabBar_Height;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XKMallOrderFinishSingleCell class] forCellReuseIdentifier:@"XKMallOrderFinishSingleCell"];
        [_tableView registerClass:[XKMallOrderFinishManyCell class] forCellReuseIdentifier:@"XKMallOrderFinishManyCell"];
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

@end
