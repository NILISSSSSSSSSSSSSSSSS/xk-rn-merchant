//
//  XKGamesSupermarketViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKGamesSupermarketViewController.h"
#import "BaseViewFactory.h"
#import "XKSqureSectionHeaderView.h"
#import "XKSqureSectionFooterView.h"
#import "XKSubscriptionFooterView.h"

#import "XKGamesWalletTableViewCell.h"
#import "XKHistoryGamesTableViewCell.h"
#import "XKRecommendTableViewCell.h"
#import "XKRecommendGamesTableViewCell.h"

#import "XKGamesTransactionListViewController.h"
#import "XKGamesDetailViewController.h"
#import "XKBuyCoinListViewController.h"
#import "XKAddGameCoinAccountViewController.h"



static NSString * const walletCellID            = @"gamesWalletTableViewCell";
static NSString * const historyGamesCellID      = @"historyGamesCell";
static NSString * const recommendCellID         = @"recommendCell";
static NSString * const recommendGamesCellID    = @"recommendGamesCell";

static NSString * const sectionHeaderViewID     = @"sectionHeaderView";
static NSString * const sectionFooterViewID     = @"sectionFooterView";

static CGFloat const SectoionHeaderHeight       = 40;
static CGFloat const SectoionFooterHeight       = 40;


@interface XKGamesSupermarketViewController ()<UITableViewDelegate, UITableViewDataSource, GamesWalletDelegate>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *recommedDataArray;


@end

@implementation XKGamesSupermarketViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    
    [self configNavigationBar];
    [self configTableView];
    
    [self configTableFooterView];
    
//    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Metheods

- (void)configNavigationBar {
    
    [self setNavTitle:@"游戏超市" WithColor:[UIColor whiteColor]];
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setTitle:@"交易明细" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
    [rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self setNaviCustomView:rightButton withframe:CGRectMake(SCREEN_WIDTH - 80, 0, 70, 30)];
}

- (void)configTableView {
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height, 0, 0, 0));
    }];
}

- (void)configTableFooterView {
    
    UILabel *footerLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, SCREEN_WIDTH, 30) text:@"到底了..." font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:12] textColor:HEX_RGB(0xCCCCCC) backgroundColor:HEX_RGB(0xf6f6f6)];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = footerLabel;
}


#pragma mark - Events

- (void)rightButtonClicked {
    XKGamesTransactionListViewController *vc = [[XKGamesTransactionListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
//        return self.recommedDataArray.count;
        return 5;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        XKGamesWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:walletCellID];
        if (!cell) {
            cell = [[XKGamesWalletTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:walletCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        return cell;
        
    } else if (indexPath.section == 1) {
        
        XKHistoryGamesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyGamesCellID];
        if (!cell) {
            cell = [[XKHistoryGamesTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:historyGamesCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            XKWeakSelf(weakSelf);
            cell.historyGamesItemBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath, NSDictionary *dic) {
                [weakSelf historyGamesItemClicked:collectionView indexPath:indexPath info:dic];
            };
        }
        
        return cell;
        
    } else {
        
        if (indexPath.row == 0) {
            
            
            XKRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendCellID];
            if (!cell) {
                cell = [[XKRecommendTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:recommendCellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
            
        } else {
            
            XKRecommendGamesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendGamesCellID];
            if (!cell) {
                cell = [[XKRecommendGamesTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:recommendGamesCellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (indexPath.row == 4) {
                [cell hiddenLineView:YES];
            } else {
                [cell hiddenLineView:NO];
            }
            return cell;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) {
        return SectoionHeaderHeight;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return SectoionFooterHeight + 10;
    }
    return 15;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1 || section == 2) {
        
        XKSqureSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderViewID];
        if (!sectionHeaderView) {
            sectionHeaderView = [[XKSqureSectionHeaderView alloc] initWithReuseIdentifier:sectionHeaderViewID];
        }
        NSString *title = @"";
        if (section == 1) {
            title = @"历史游戏";
        } else if (section == 2) {
            title = @"推荐游戏";
        }
        [sectionHeaderView setTitleName:title];
        return sectionHeaderView;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        
        XKSqureSectionFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionFooterViewID];
        if (!sectionFooterView) {
            sectionFooterView = [[XKSqureSectionFooterView alloc] initWithReuseIdentifier:sectionFooterViewID];
            [sectionFooterView setFooterViewImg:[UIImage imageNamed:@"xk_btn_home_sectionFooter_more"]];
        }
        return sectionFooterView;
    } else if (section == 2) {
        XKSubscriptionFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerViewID"];
        if (!sectionFooterView) {
            sectionFooterView = [[XKSubscriptionFooterView alloc] initWithReuseIdentifier:@"footerViewID"];
        }
        return sectionFooterView;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 2) {
        XKGamesDetailViewController *vc = [[XKGamesDetailViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - Custom Blocks

- (void)historyGamesItemClicked:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath info:(NSDictionary *)info {

    
}

#pragma mark - Custom Delegates

- (void)bindCoinButtonClicked:(UIButton *)sender index:(NSInteger)inxex {
    
    XKAddGameCoinAccountViewController *vc = [[XKAddGameCoinAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)buyButtonClicked:(UIButton *)sender {
    XKBuyCoinListViewController *vc = [[XKBuyCoinListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Lazy load

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
