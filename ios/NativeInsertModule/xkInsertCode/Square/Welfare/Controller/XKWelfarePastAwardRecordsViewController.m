//
//  XKWelfarePastAwardRecordsViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/3.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfarePastAwardRecordsViewController.h"
#import "XKWelfarePastAwardRecordModel.h"
#import "XKWelfarePastAwardRecordTableViewCell.h"

@interface XKWelfarePastAwardRecordsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) XKEmptyPlaceView *emptyView;

@property (nonatomic, strong) NSMutableArray *pastAwardRecords;

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, assign) NSUInteger pastAwardRecordCount;

@end

@implementation XKWelfarePastAwardRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"往期中奖记录" WithColor:HEX_RGB(0xffffff)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = XKSeparatorLineColor;
    self.tableView.separatorInset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[XKWelfarePastAwardRecordTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKWelfarePastAwardRecordTableViewCell class])];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.containView addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containView);
    }];
    
    self.emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    self.emptyView.config.verticalOffset = -75.0;
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf postPastAwardRecords];
    }];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.pastAwardRecords.count >= weakSelf.pastAwardRecordCount) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [weakSelf postPastAwardRecords];
    }];
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经到底了～" forState:MJRefreshStateNoMoreData];
    footer.ignoredScrollViewContentInsetBottom = kBottomSafeHeight;
    self.tableView.mj_footer = footer;
    
    self.page = 1;
    [self postPastAwardRecords];
}

#pragma mark - POST

- (void)postPastAwardRecords {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:self.goodsId forKey:@"goodsId"];
    [para setObject:@(self.page) forKey:@"page"];
    [para setObject:@(10) forKey:@"limit"];
    
    
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig getPastAwardRecordsUrl] timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.page == 1) {
            [self.pastAwardRecords removeAllObjects];
            [self.tableView.mj_footer resetNoMoreData];
        }
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (self.page == 1) {
                self.pastAwardRecordCount = dict[@"total"] ? [dict[@"total"] integerValue] : 0;
            }
            [self.pastAwardRecords addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKWelfarePastAwardRecordModel class] json:dict[@"data"]]];
            [self.tableView reloadData];
        }
        if (self.pastAwardRecords.count) {
            [self.emptyView hide];
        } else {
            __weak typeof(self) weakSelf = self;
            self.emptyView.config.viewAllowTap = YES;
            [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:^{
                [weakSelf postPastAwardRecords];
            }];
        }
        self.page += 1;
    } failure:^(XKHttpErrror *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.pastAwardRecords.count == 0) {
            __weak typeof(self) weakSelf = self;
            self.emptyView.config.viewAllowTap = YES;
            [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [weakSelf postPastAwardRecords];
            }];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pastAwardRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKWelfarePastAwardRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKWelfarePastAwardRecordTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithWelfarePastAwardRecordModel:indexPath.row < self.pastAwardRecords.count ? self.pastAwardRecords[indexPath.row] : [[XKWelfarePastAwardRecordModel alloc] init]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - getter setter

- (NSMutableArray *)pastAwardRecords {
    if (!_pastAwardRecords) {
        _pastAwardRecords = [NSMutableArray array];
    }
    return _pastAwardRecords;
}

@end
