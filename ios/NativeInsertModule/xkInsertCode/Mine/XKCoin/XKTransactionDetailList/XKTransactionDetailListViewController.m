//
//  XKTransactionDetailListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTransactionDetailListViewController.h"
#import "XKTransactionDetailListCell.h"
#import "XKTranscationDetailHeaderView.h"
#import "XKSubscriptionFooterView.h"
#import "XKTransactionDetailModel.h"
#import "XKTransactionDetailViewController.h"
#import "XKCommonSheetView.h"
#import "XKTransactionDetailTimeChooseView.h"


static NSString * const transactionDetailListCellID      = @"transactionDetailListCellID";
static NSString * const sectionHeaderViewID              = @"sectionHeaderView";
static NSString * const sectionFooterViewID              = @"sectionFooterView";

static CGFloat const SectoionHeaderHeight = 72;

@interface XKTransactionDetailListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView                         *tableView;
@property (nonatomic, strong) NSMutableArray                      *dataMutArray;
@property (nonatomic, strong) XKTransactionDetailTimeChooseView   *timeChooseView;
@property (nonatomic, strong) XKCommonSheetView                   *timeChooseSheetView;

@end

@implementation XKTransactionDetailListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self configNavigationBar];
    NSArray *arr = @[@{@"title":@"晓霖家猫粮", @"dec":@"支付宝返消费券",
                       @"time":@"2018-08-24", @"price":@"20", @"add":@"1"},
                     @{@"title":@"李林屋头狗粪", @"dec":@"购物券",
                       @"time":@"2018-08-11", @"price":@"110", @"add":@"0"}];
    _dataMutArray = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        [_dataMutArray addObject:[XKTransactionDetailModel yy_modelWithDictionary:dic]];
    }
    [self configTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Private Metheods
- (void)configTableView {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height, 0, 0, 0));
    }];
}
- (void)configNavigationBar {
    
    [self setNavTitle:@"晓可币明细" WithColor:[UIColor whiteColor]];
}





#pragma mark - UITableViewDelegate && UITableViewDataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataMutArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKTransactionDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:transactionDetailListCellID];
    if (!cell) {
        cell = [[XKTransactionDetailListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:transactionDetailListCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setVaules:self.dataMutArray[indexPath.row]];
    if (self.dataMutArray.count == indexPath.row + 1) {
        [cell hiddenLineView:YES];
    } else {
        [cell hiddenLineView:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKTransactionDetailViewController *vc = [[XKTransactionDetailViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SectoionHeaderHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    

    XKTranscationDetailHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderViewID];
    if (!sectionHeaderView) {
        sectionHeaderView = [[XKTranscationDetailHeaderView alloc] initWithReuseIdentifier:sectionHeaderViewID];
    }
    XKWeakSelf(weakSelf);
    sectionHeaderView.chooseTimeBlock = ^(UIButton *sender, NSString *currentTime) {
        [weakSelf chooseButtonClicked:sender currentTime:currentTime];
    };
    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    XKSubscriptionFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionFooterViewID];
    if (!sectionFooterView) {
        sectionFooterView = [[XKSubscriptionFooterView alloc] initWithReuseIdentifier:sectionFooterViewID];
    }
    return sectionFooterView;
}

#pragma mark - Custom Delegates

#pragma mark - Custom Block
- (void)chooseButtonClicked:(UIButton *)sender currentTime:(NSString *)currentTime {
    [self.timeChooseSheetView show];
}

- (void)refreshDataListWithTime1:(NSString *)time1 time2:(NSString *)time2 time3:(NSString *)time3 way:(NSInteger)way {
    
    [self.timeChooseSheetView dismiss];
    //网络请求
}

#pragma mark - Lazy load

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 65;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (XKTransactionDetailTimeChooseView *)timeChooseView {
    if (!_timeChooseView) {
        _timeChooseView = [[XKTransactionDetailTimeChooseView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 330)];
        XKWeakSelf(weakSelf);
        _timeChooseView.cancelBlock = ^{
            [weakSelf.timeChooseSheetView dismiss];
        };
        _timeChooseView.sureBlock = ^(NSString *time1, NSString *time2, NSString *time3, NSInteger way) {
            [weakSelf refreshDataListWithTime1:time1 time2:time2 time3:time3 way:way];
        };
    }
    return _timeChooseView;
}

- (XKCommonSheetView *)timeChooseSheetView {
    
    if (!_timeChooseSheetView) {
        _timeChooseSheetView = [[XKCommonSheetView alloc] init];
        _timeChooseSheetView.contentView = self.timeChooseView;
        [_timeChooseSheetView addSubview:self.timeChooseView];
    }
    return _timeChooseSheetView;
}


@end
