//
//  XKTradingAreaPrizeViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/6.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKTradingAreaPrizeViewController.h"
#import "XKTradingAreaPrizeHeaderView.h"
#import "XKTradingAreaPrizeTableViewCell.h"

@interface XKTradingAreaPrizeViewController ()<UITableViewDelegate,UITableViewDataSource>
/**tableView*/
@property(nonatomic, strong) UITableView *tableView;
/**headerView*/
@property(nonatomic, strong) XKTradingAreaPrizeHeaderView *headerView;

/**请求页数*/
@property(nonatomic, assign) NSInteger page;
/**请求条数*/
@property(nonatomic, assign) NSInteger limit;

@property(nonatomic, assign) RefreshDataStatus refreshStatus;

/**数据数组*/
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation XKTradingAreaPrizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.limit = 10;
    [self creatUI];
    [self setNavTitle:@"活动商家" WithColor:[UIColor whiteColor]];
}

- (void)creatUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(240, 240, 240);
        // 注册cell
        [_tableView registerClass:[XKTradingAreaPrizeTableViewCell class] forCellReuseIdentifier:@"cell"];
        __weak typeof(self) weakSelf = self;
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadListDataRefresh:NO];
        }];
        self.tableView.mj_footer = footer;
        [footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
        self.tableView.mj_footer.hidden = YES;
    }
    return _tableView;
}

- (XKTradingAreaPrizeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XKTradingAreaPrizeHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    }
    return _headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKTradingAreaPrizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.myContentView.xk_radius = 8;
    cell.myContentView.xk_openClip = YES;
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.myContentView.xk_clipType = XKCornerClipTypeTopBoth;
        }else if (indexPath.row == 4){
            cell.myContentView.xk_clipType = XKCornerClipTypeBottomBoth;
        }else {
            cell.myContentView.xk_clipType = XKCornerClipTypeNone;
        }
    }
    return cell;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0.0000001;
    }else {
        return 130;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40;
    }else {
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.headerView;
    }else {
        return [[UIView alloc]init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)loadListDataRefresh:(BOOL)isRefresh Block:(void(^)(NSMutableArray *array))block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [XKHudView showLoadingTo:self.tableView animated:YES];
    if (isRefresh) {
        parameters[@"page"] = @(1);
    }else {
        parameters[@"page"] = @(self.page + 1);
    }
    parameters[@"limit"] = @(self.limit);

    [HTTPClient postEncryptRequestWithURLString:@"" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        NSArray *array = [NSArray array];
        if (responseObject) {
            if (isRefresh) {
                self.page = 1;
            } else {
                self.page += 1;
            }
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
//            XKTradingShopListModel *model = [XKTradingShopListModel yy_modelWithJSON:responseObject];
//            array = model.data.mutableCopy;
            if (self.dataArray.count < self.limit) {
                self.refreshStatus = Refresh_NoDataOrHasNoMoreData;
            } else {
                self.refreshStatus = Refresh_HasDataAndHasMoreData;
            }
            [self.dataArray addObjectsFromArray:array];
            block(self.dataArray);
        }
        [XKHudView hideHUDForView:self.tableView animated:YES];
    } failure:^(XKHttpErrror *error) {
        self.refreshStatus = Refresh_NoNet;
        [XKHudView hideHUDForView:self.tableView animated:YES];
    }];
}


- (void)loadListDataRefresh:(BOOL)isRefresh {
    XKWeakSelf(ws);
    [self loadListDataRefresh:isRefresh Block:^(NSMutableArray *array) {
        [ws resetMJHeaderFooter:self.refreshStatus tableView:self.tableView dataArray:array];
        [self.tableView reloadData];
    }];
}
@end
