//
//  XKWelfareOrderFinishViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.

#import "XKWelfareOrderFinishViewController.h"
#import "XKWelfareOrderFinishCell.h"
#import "XKWelfareOrderDetailBottomView.h"
#import "XKWelfareOrderDetailWaitSendViewController.h"
#import "XKWelfareOrderDetailFinishViewController.h"
#import "XKWelfareOrderListViewModel.h"
@interface XKWelfareOrderFinishViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)XKWelfareOrderDetailBottomView *bottomView;
@property (nonatomic, strong)XKWelfareOrderListViewModel *viewModel;
@end

@implementation XKWelfareOrderFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void)handleData {
    [super handleData];
    _viewModel = [XKWelfareOrderListViewModel new];
    _viewModel.limit = 10;
    _viewModel.page = 0;
}

- (void)addCustomSubviews {
    [self hideNavigation];
    [self.view addSubview:self.tableView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bottomView];
    self.emptyTipView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
}

- (void)updateLayout {
    _viewModel.manager = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.height -= 50;
        self.bottomView.y -= 50 + kBottomSafeHeight;
    }];
    [self.tableView reloadData];
}

- (void)restoreLayout {
     _viewModel.manager = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.height += 50;
        self.bottomView.y += 50 + kBottomSafeHeight;
    }];
    [self.tableView reloadData];
}
#pragma mark 网络请求
- (void)requestDataWithTips:(BOOL)tip {
    if(tip) {
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    _viewModel.page ++;
    if(_viewModel.page == 1) { //第一页  更新时间戳
        _viewModel.timestamp = ceilf([[NSDate date] timeIntervalSince1970]);
    }
    NSDictionary *dic = @{
                          @"page":@(_viewModel.page),
                          @"limit":@(_viewModel.limit),
  //                        @"lastUpdateAt":@(_viewModel.timestamp)
                          };
    [XKWelfareOrderListViewModel requestWelfareGoodsListWithOrderType:WLT_WelfareListTypeFinish param:dic success:^(XKWelfareOrderListViewModel *model) {
        [self handleSuccessDataWithModel:model];
    } failed:^(NSString *failedReason) {
        [self handleErrorDataWithReason:failedReason];
    }];
    
}

- (void)handleSuccessDataWithModel:(XKWelfareOrderListViewModel *)model {
    [XKHudView hideAllHud];
    [self.emptyTipView hide];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    if (_viewModel.page == 1) {
        _viewModel.dataArr = nil;
        if (model == nil) {//第一页没数据
            self.emptyTipView.config.viewAllowTap = YES;
            [self.emptyTipView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:^{
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


#pragma mark tableview代理 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewModel.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKWelfareOrderFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKWelfareOrderFinishCell" forIndexPath:indexPath];
    WelfareOrderDataItem *item = _viewModel.dataArr[indexPath.row];
    item.index = indexPath;
    [cell bindData:item];
    switch (item.currentIndex) {
        case WLP_WelfareListPositionOnly:
        {
            cell.bgContainView.xk_clipType = XKCornerClipTypeAllCorners;
            [cell hiddenSeperateLine:YES];
        }
            break;
        case WLP_WelfareListPositionFirst:
        {
            cell.bgContainView.xk_clipType = XKCornerClipTypeTopBoth;
            [cell hiddenSeperateLine:NO];
        }
            break;
        case WLP_WelfareListPositionLast:
        {
            cell.bgContainView.xk_clipType = XKCornerClipTypeBottomBoth;
            [cell hiddenSeperateLine:YES];
        }
            break;
        case WLP_WelfareListPositionOther:
        {
            cell.bgContainView.xk_clipType = XKCornerClipTypeNone;
            [cell hiddenSeperateLine:NO];
        }
            break;
            
        default:
            break;
    }
        if(_viewModel.manager) {
            [cell updateLayout];
        } else {
            [cell restoreLayout];
        }
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    XKWelfareOrderDetailFinishViewController *finish = [XKWelfareOrderDetailFinishViewController new];
    WelfareOrderDataItem *item = _viewModel.dataArr[indexPath.row];
    [finish handleOrderItemModel:item];
    [self.parentViewController.navigationController pushViewController:finish animated:YES];
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
          CGFloat h = self.entryType == 0 ?  SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight : SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight - TabBar_Height;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h) style:UITableViewStyleGrouped];
        XKWeakSelf(ws);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ws.viewModel.page = 0;
            [ws requestDataWithTips:NO];
        }];
        _tableView.mj_header = narmalHeader;
        
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [ws requestDataWithTips:NO];
        }];
        _tableView.mj_footer = foot;
        
        [_tableView registerClass:[XKWelfareOrderFinishCell class] forCellReuseIdentifier:@"XKWelfareOrderFinishCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (XKWelfareOrderDetailBottomView *)bottomView {
    if(!_bottomView) {
        _bottomView = [XKWelfareOrderDetailBottomView WelfareOrderDetailBottomViewWithType:WelfareOrderDetailBottomViewFinish];
        _bottomView.frame = CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, 50 + kBottomSafeHeight);
        _bottomView.choseBlock = ^(UIButton *sender) {
            
        };
        _bottomView.deleteBlock = ^(UIButton *sender) {
            
        };
    }
    return _bottomView;
}

@end
