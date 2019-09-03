//
//  XKMyWinningRecordsViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMyWinningRecordsViewController.h"
#import "XKMyWinningRecordsHeader.h"
#import "XKMyWinningRecordTableViewCell.h"
#import "XKWinningRecordModel.h"
#import "XKMenuView.h"
#import "XKCommonSheetView.h"
#import "XKTransactionDetailTimeChooseView.h"

@interface XKMyWinningRecordsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *winningRecords;


@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, assign) NSUInteger winningRecordCount;

@property (nonatomic, strong) NSMutableArray *categorys;

@property (nonatomic, assign) NSInteger selectedCategoryIndex;

@property (nonatomic, strong) XKEmptyPlaceView *emptyView;

@end

@implementation XKMyWinningRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedCategoryIndex = -1;
    self.navigationView.backgroundColor = XKMainTypeColor;
    [self setNavTitle:@"我的中奖记录" WithColor:[UIColor whiteColor]];
    [self initializeViews];
    [self updateViews];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf postMyWinningRecords];
    }];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.winningRecords.count >= weakSelf.winningRecordCount) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [weakSelf postMyWinningRecords];
    }];
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经到底了～" forState:MJRefreshStateNoMoreData];
    footer.ignoredScrollViewContentInsetBottom = kBottomSafeHeight;
    self.tableView.mj_footer = footer;
    
    self.emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    self.emptyView.config.verticalOffset = -50.0;
    
    self.page = 1;
    [self postMyWinningRecords];
}

- (void)initializeViews {
    [self.containView addSubview:self.tableView];
}

- (void)updateViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containView);
    }];
}

#pragma mark - privite method

#pragma mark - POST

- (void)postMyWinningRecords {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [HTTPClient postEncryptRequestWithURLString:@"" timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.page == 1) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.winningRecords removeAllObjects];
        }
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (self.page == 1) {
                self.winningRecordCount = dict[@"total"] ? [dict[@"total"] integerValue] : 0;
            }
            [self.winningRecords addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKWinningRecordModel class] json:dict[@"data"]]];
            [self.tableView reloadData];
        }
        if (self.winningRecords.count) {
            [self.emptyView hide];
        } else {
            self.emptyView.config.viewAllowTap = YES;
            [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:nil];
        }
        self.page += 1;
    } failure:^(XKHttpErrror *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.winningRecords.count == 0) {
            __weak typeof(self) weakSelf = self;
            self.emptyView.config.viewAllowTap = YES;
            [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [weakSelf postMyWinningRecords];
            }];
        }
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.winningRecords.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XKMyWinningRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKMyWinningRecordTableViewCell class]) forIndexPath:indexPath];
    if (indexPath.row == self.winningRecords.count -1) {
        cell.containerView.xk_radius = 8.0;
        cell.containerView.xk_clipType = XKCornerClipTypeBottomBoth;
        cell.containerView.xk_openClip = YES;
        [cell.containerView xk_forceClip];
        [cell setDownLineHidden:YES];
    } else {
        cell.containerView.xk_radius = 0.0;
        cell.containerView.xk_clipType = XKCornerClipTypeNone;
        cell.containerView.xk_openClip = YES;
        [cell.containerView xk_forceClip];
        [cell setDownLineHidden:NO];
    }
    return cell;
}
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 98.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    XKMyWinningRecordsHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([XKMyWinningRecordsHeader class])];
    __weak typeof(self) weakSelf = self;
    __weak typeof(header) weakHeader = header;
    header.categoryBtnBlock = ^(UIButton * _Nonnull sender) {
        XKMenuView *menuView = [XKMenuView menuWithTitles:self.categorys images:nil width:100 relyonView:sender clickBlock:^(NSInteger index, NSString *text) {
            weakSelf.selectedCategoryIndex = index;
            weakHeader.currentCategoryStr = weakSelf.categorys[weakSelf.selectedCategoryIndex];
            [weakSelf.winningRecords removeAllObjects];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
        menuView.menuColor = HEX_RGBA(0xffffff, 1);
        menuView.textColor = UIColorFromRGB(0x222222);
        menuView.separatorPadding = 5;
        menuView.textImgSpace = 10;
        [menuView show];
    };

    header.dateBtnBlock = ^(UIButton * _Nonnull sender) {
        XKCommonSheetView *timeChooseSheetView = [[XKCommonSheetView alloc] init];
        
        XKTransactionDetailTimeChooseView *timeChooseView = [[XKTransactionDetailTimeChooseView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 330)];
        timeChooseView.cancelBlock = ^{
            [timeChooseSheetView dismiss];
        };
        timeChooseView.sureBlock = ^(NSString *time1, NSString *time2, NSString *time3, NSInteger way) {
            if (way == 0) {
                weakHeader.startDate = [XKTimeSeparateHelper backYMDateByStrigulaSegmentWithTimeString:time1];
            } else {
                if (!time2 || !time3) {
                    [XKHudView showWarnMessage:@"请选择起止日期"];
                    return ;
                }
                if ([[XKTimeSeparateHelper backYMDDateByStrigulaSegmentWithTimeString:time2] compare:[XKTimeSeparateHelper backYMDDateByStrigulaSegmentWithTimeString:time3]] == NSOrderedDescending) {
                    [XKHudView showWarnMessage:@"结束日期不能早于开始日期"];
                    return ;
                }
                weakHeader.startDate = [XKTimeSeparateHelper backYMDDateByStrigulaSegmentWithTimeString:time2];
                weakHeader.endDate = [XKTimeSeparateHelper backYMDDateByStrigulaSegmentWithTimeString:time3];
            }
            [timeChooseSheetView dismiss];
            [weakSelf.winningRecords removeAllObjects];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        timeChooseSheetView.contentView = timeChooseView;
        [timeChooseSheetView addSubview:timeChooseView];
        [timeChooseSheetView show];
    };
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - getter setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [_tableView registerClass:[XKMyWinningRecordsHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([XKMyWinningRecordsHeader class])];
        [_tableView registerClass:[XKMyWinningRecordTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKMyWinningRecordTableViewCell class])];
    }
    return _tableView;
}

- (NSMutableArray *)winningRecords {
    if (!_winningRecords) {
        _winningRecords = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            [_winningRecords addObject:[[XKWinningRecordModel alloc] init]];
        }
    }
    return _winningRecords;
}

- (NSMutableArray *)categorys {
    if (!_categorys) {
        _categorys = [NSMutableArray array];
        [_categorys addObjectsFromArray:@[@"随机红包",
                                          @"大奖",
                                          ]
         ];
    }
    return _categorys;
}

@end
