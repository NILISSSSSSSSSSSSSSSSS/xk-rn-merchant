//
//  XKWelfareOrderDetailFinishViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailFinishViewController.h"
#import "XKCustomNavBar.h"
#import "XKWelfareOrderDetailFinishTopCell.h"
#import "XKWelfareOrderDetailFinishCell.h"
#import "XKCustomeSerMessageManager.h"
#import "XKWelfareOrderDetailViewModel.h"
@interface XKWelfareOrderDetailFinishViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XKCustomNavBar *navBar;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray  *listValueArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) WelfareOrderDataItem  *item;
@property (nonatomic, strong) XKWelfareOrderDetailViewModel  *viewModel;
@end

@implementation XKWelfareOrderDetailFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)handleData {
    [super handleData];
    _page = 0;
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar = [[XKCustomNavBar alloc] init];
    [_navBar customNaviBarWithTitle:@"中奖详情" andRightButtonImageTitle:@"xk_icon_snatchTreasure_order_trans"];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    _navBar.rightButtonBlock = ^(UIButton *sender){
        
    };
    [self.view addSubview:_navBar];
    [self.view addSubview:self.tableView];
}

//联系客服
- (void)chatBtnClick:(UIButton *)sender {
    [XKCustomeSerMessageManager createXKCustomerSerChat];
}

//提醒发货
- (void)tipBtnClick:(UIButton *)sender {
    
}

- (void)handleOrderItemModel:(WelfareOrderDataItem *)item {
    _item = item;
    [self requestDataWithTips:YES];
}
#pragma mark 网络请求
- (void)requestDataWithTips:(BOOL)tip {
    if(tip) {
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    self.page ++;
    NSDictionary *dic = @{
                          @"page"  : @(_page),
                          @"limit" : @(10),
                          @"sequenceId" : @(_item.termNumber) ?:@""
                          //     @"lastUpdateAt":@(_viewModel.timestamp)
                          };
    [XKWelfareOrderDetailViewModel requestWelfareOrderFinishDetailWithParamDic:dic Success:^(XKWelfareOrderDetailViewModel *model) {
        [self handleSuccessDataWithModel:model];
    } failed:^(NSString *failedReason, NSInteger code) {
        [self handleErrorDataWithReason:failedReason];
    }];
    
}

- (void)handleSuccessDataWithModel:(XKWelfareOrderDetailViewModel *)model {
    [XKHudView hideAllHud];
    [self.emptyTipView hide];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    if (self.page == 1) {
        _dataArr = nil;
        if (model == nil) {//第一页没数据
            self.emptyTipView.config.viewAllowTap = YES;
            [self.emptyTipView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:^{
                [self.tableView.mj_header beginRefreshing];
            }];
        }
    }
    if (model == nil) {
        self.page --;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:_dataArr];
        [tmp addObjectsFromArray:model.data];
        _dataArr = [tmp copy];
    }
    [self.tableView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    self.page --;
    XKWeakSelf(ws);
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    if (self.viewModel.data.count == 0) {//无数据 请求第一页 请求出错
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
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    if(indexPath.section == 0) {
        XKWelfareOrderDetailFinishTopCell *topCell = [XKWelfareOrderDetailFinishTopCell new];
        XKWelfareFinishDetailDataItem *item = _dataArr.firstObject;
        [topCell handleDataWithItem:item];
        return topCell;
    } else {
        XKWelfareOrderDetailFinishCell *cell = [XKWelfareOrderDetailFinishCell new];
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:_dataArr];
        [tmpArr removeObjectAtIndex:0];
        XKWelfareFinishDetailDataItem *item = _dataArr[indexPath.section];
        [cell handleDataWithItem:item];
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
    return section == 0 ?  0.01 : 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = XKSeparatorLineColor;
    return section == 0 ?  self.clearHeaderView : view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        XKWeakSelf(ws);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64) + 10, SCREEN_WIDTH - 20,  SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight - 10) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ws.page = 0;
            [ws requestDataWithTips:NO];
        }];
        _tableView.mj_header = narmalHeader;
        
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [ws requestDataWithTips:NO];
        }];
        _tableView.mj_footer = foot;
        
        [_tableView registerClass:[XKWelfareOrderDetailFinishTopCell class] forCellReuseIdentifier:@"XKWelfareOrderDetailFinishTopCell"];
        [_tableView registerClass:[XKWelfareOrderDetailFinishCell class] forCellReuseIdentifier:@"XKWelfareOrderDetailFinishCell"];
    }
    return _tableView;
}

@end
