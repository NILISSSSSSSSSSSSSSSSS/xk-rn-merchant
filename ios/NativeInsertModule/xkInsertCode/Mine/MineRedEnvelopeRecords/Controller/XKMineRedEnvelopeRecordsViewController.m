//
//  XKMineRedEnvelopeRecordsViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/11/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineRedEnvelopeRecordsViewController.h"
#import "XKMenuView.h"
#import "XKCommonSheetView.h"
#import "XKTransactionDetailTimeChooseView.h"
#import "XKMineRedEnvelopeRecordsTableViewHeader.h"
#import "XKMineRedEnvelopeRecordsTableViewCell.h"

CGFloat const kMineRedEnvelopeRecordsViewControllerHeaderHeight = 120.0;
CGFloat const kMineRedEnvelopeRecordsViewControllerCellHeight = 66.0;

typedef NS_ENUM(NSInteger, XKMineRedEnvelopeRecordsViewControllerType) {
    XKMineRedEnvelopeRecordsViewControllerTypeReceived = 0,
    XKMineRedEnvelopeRecordsViewControllerTypeGiven,
};

@interface XKMineRedEnvelopeRecordsViewController () <UITableViewDataSource, UITableViewDelegate, XKMineRedEnvelopeRecordsTableViewHeaderDelegate>

@property (nonatomic, assign) XKMineRedEnvelopeRecordsViewControllerType type;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSArray *categorys;
@property (nonatomic, assign) NSInteger currentCategoryIndex;

@end

@implementation XKMineRedEnvelopeRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentCategoryIndex = -1;
    if (self.type == XKMineRedEnvelopeRecordsViewControllerTypeReceived) {
        [self setNavTitle:@"收到的红包" WithColor:[UIColor whiteColor]];
        self.categorys = @[@"晓可币", @"积分", @"消费券", @"卡券", @"礼物"];
    } else {
        [self setNavTitle:@"发出的红包" WithColor:[UIColor whiteColor]];
        self.categorys = @[@"小视频红包", @"可友红包"];
    }
    self.navigationView.backgroundColor = XKMainTypeColor;
    UIButton *exchangeBtn = [UIButton new];
    [exchangeBtn setImage:[UIImage imageNamed:@"xk_btn_red_envelop_records_exchange"] forState:UIControlStateNormal];
    [exchangeBtn setFrame:CGRectMake(0, 0, XKViewSize(35), XKViewSize(25))];
    [exchangeBtn addTarget:self action:@selector(clickExchangeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:exchangeBtn withframe:exchangeBtn.bounds];
    [self initializeViews];
}

- (void)initializeViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    [self.tableView registerClass:[XKMineRedEnvelopeRecordsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKMineRedEnvelopeRecordsTableViewCell class])];
    [self.tableView registerClass:[XKMineRedEnvelopeRecordsTableViewHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([XKMineRedEnvelopeRecordsTableViewHeader class])];
    [self.containView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containView);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
}

#pragma mark - XKMineRedEnvelopeRecordsTableViewHeaderDelegate

/** 点击分类按钮 */
- (void)headerView:(XKMineRedEnvelopeRecordsTableViewHeader *)headerView categaryButtonAction:(UIButton *)sender {
    
    XKMenuView *menuView = [XKMenuView menuWithTitles:self.categorys images:nil width:100 relyonView:sender clickBlock:^(NSInteger index, NSString *text) {
        self.currentCategoryIndex = index;
        [self.tableView reloadData];
        self.page = 1;
        [self loadData];
    }];
    menuView.menuColor = HEX_RGBA(0xffffff, 1);
    menuView.textColor = UIColorFromRGB(0x222222);
    menuView.separatorPadding = 5;
    menuView.textImgSpace = 10;
    [menuView show];
}

/** 点击时间按钮 */
- (void)headerView:(XKMineRedEnvelopeRecordsTableViewHeader *)headerView dateButtonAction:(UIButton *)sender {
    
    XKCommonSheetView *timeChooseSheetView = [[XKCommonSheetView alloc] init];
    XKTransactionDetailTimeChooseView *timeChooseView = [[XKTransactionDetailTimeChooseView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 330)];
    timeChooseView.cancelBlock = ^{
        [timeChooseSheetView dismiss];
    };
    timeChooseView.sureBlock = ^(NSString *time1, NSString *time2, NSString *time3, NSInteger way) {
        NSString *string = @"";
        if (way == 0) {
            string = time1;
        } else {
            string = [NSString stringWithFormat:@"%@ 至 %@", time2, time3];
        }
        [headerView configHeaderViewWithDateString:string];
        [timeChooseSheetView dismiss];
    };
    timeChooseSheetView.contentView = timeChooseView;
    [timeChooseSheetView addSubview:timeChooseView];
    [timeChooseSheetView show];
}

#pragma mark - events

- (void)clickExchangeButton:(UIButton *)sender {
    
    self.type = 1 - self.type;
    self.currentCategoryIndex = -1;
    if (self.type == XKMineRedEnvelopeRecordsViewControllerTypeReceived) {
        [self setNavTitle:@"收到的红包" WithColor:[UIColor whiteColor]];
        self.categorys = @[@"晓可币", @"积分", @"消费券", @"卡券", @"礼物"];
    } else {
        [self setNavTitle:@"发出的红包" WithColor:[UIColor whiteColor]];
        self.categorys = @[@"小视频红包", @"可友红包"];
    }
    [self loadData];
}

#pragma mark - privite method

/** 请求数据 */
- (void)loadData {
    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArr.count;
    // yuan'mock
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    XKMineRedEnvelopeRecordsTableViewHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([XKMineRedEnvelopeRecordsTableViewHeader class])];
    header.delegate = self;
    [header configHeaderViewWithTitleArray:self.categorys currentCategoryIndex:self.currentCategoryIndex];
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XKMineRedEnvelopeRecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKMineRedEnvelopeRecordsTableViewCell class]) forIndexPath:indexPath];
    if (indexPath.row == self.dataArr.count -1) {
        [cell clipBottomRadius:YES];
        [cell setDownLineHidden:YES];
    } else {
        [cell clipBottomRadius:NO];
        [cell setDownLineHidden:NO];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kMineRedEnvelopeRecordsViewControllerHeaderHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMineRedEnvelopeRecordsViewControllerCellHeight;
}

@end
