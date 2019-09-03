//
//  XKMallSearchGoodsViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallSearchGoodsViewController.h"
#import "XKMallTopFilterView.h"
#import "XKMallListViewModel.h"
#import "XKMallListSingleCell.h"
#import "XKMallListDoubleCell.h"
#import "XKMainMallOrderViewController.h"
#import "XKMallGoodsDetailViewController.h"
#import "XKMallBuyCarViewController.h"
#import "XKCustomeSerMessageManager.h"
@interface XKMallSearchGoodsViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, copy) NSString  *text;
@property (nonatomic, strong)XKMallTopFilterView *filterView;
@property (nonatomic, strong)XKCustomNavBar *toolsBar;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *dataArr;
@end

@implementation XKMallSearchGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.toolsBar.searchBar.textField resignFirstResponder];
}

- (void)handleData {
    [super handleData];
}

- (void)addCustomSubviews {
    [self hideNavigation];

}

- (void)searchText:(NSString *)text withCategoryCode:(NSInteger)code {
    _text = text;
    self.viewModel = [XKMallListViewModel new];
    self.viewModel.page = 0;
    self.viewModel.type = @"popularity";
    self.viewModel.isDesc = 1;
    self.viewModel.limit = 10;
    self.viewModel.category = code;
    self.viewModel.timestamp = ceilf([[NSDate date] timeIntervalSince1970]);
    [self.view addSubview:self.toolsBar];
    [self.view addSubview:self.filterView];
    [self.view addSubview:self.collectionView];
    _toolsBar.searchBar.textField.text = text;
    [self.collectionView.mj_header beginRefreshing];
}

- (void)reSearchTextWithText:(NSString *)text {
     _text = text;
    self.viewModel.page = 0;
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark 网络请求
- (void)filterRefreshWithType:(XKMllFilterType)filterType sort:(NSInteger)sort {
    switch (filterType) {
        case 0:
            self.viewModel.type = @"popularity";
            break;
        case 1:
            self.viewModel.type = @"saleQ";
            break;
        case 2:
            self.viewModel.type = @"price";
            break;
            
        default:
            break;
    }
    self.viewModel.isDesc = sort;
    self.viewModel.page = 0;
    [self.collectionView.mj_header beginRefreshing];
}

//请求第一页数据 可能有缓存
- (void)requestDataWithTips:(BOOL)tip code:(NSInteger)code {
    if(tip) {
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    self.viewModel.page ++;

    NSDictionary *dic = @{@"condition":@{@"category":@(self.viewModel.category),
                                         @"keyword":_text ?:@""
                                         },
                          @"sort":@{@"type":self.viewModel.type,
                                    @"isDesc":@(self.viewModel.isDesc)
                                    },
                          @"page":@(self.viewModel.page),
                          @"limit":@(self.viewModel.limit),
                          @"lastUpdateAt":@(self.viewModel.timestamp)
                          };
    
    [XKMallGoodsListModel requestMallGoodsListWithParam:dic Success:^(NSArray *modelList) {
        [self handleSuccessDataWithModel:modelList];
    } failed:^(NSString *failedReason) {
        [self handleErrorDataWithReason:failedReason];
    }];
}

- (void)handleSuccessDataWithModel:(NSArray *)listModel {
    [XKHudView hideAllHud];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
    if (self.viewModel.page == 1)
        _dataArr = nil;
    
    if (listModel == nil) {
        self.viewModel.page --;
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    } else {
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:_dataArr];
        [tmp addObjectsFromArray:listModel];
        _dataArr = [tmp copy];
    }
    [self.collectionView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    self.viewModel.page --;
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
    [XKHudView showErrorMessage:reason];
}

#pragma mark collectionview代理 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 10);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.layoutType == XKMallListLayoutSingle) {
        XKMallListSingleCell *singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKMallListSingleCell" forIndexPath:indexPath];
        [singleCell bindData:_dataArr[indexPath.row]];
        if(_dataArr.count == 1) {
            [singleCell cutCornerForType:XKCornerCutTypeOnlyCell WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 90)];
        } else {
            if(indexPath.row == 0) {
                [singleCell cutCornerForType:XKCornerCutTypeFitstCell WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 90)];
            } else if(indexPath.row == _dataArr.count - 1) {
                [singleCell cutCornerForType:XKCornerCutTypeLastCell WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 90)];
            } else {
                singleCell.layer.mask = nil;
            }
        }
        return singleCell;
    } else {
        XKMallListDoubleCell *doubleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKMallListDoubleCell" forIndexPath:indexPath];
        
        [doubleCell bindData:_dataArr[indexPath.row]];
        return doubleCell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.layoutType == XKMallListLayoutSingle) {
        return CGSizeMake(SCREEN_WIDTH - 20, 90);
    } else {
        return  CGSizeMake((SCREEN_WIDTH - 30)/2, 240);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if(self.layoutType == XKMallListLayoutSingle) {
        return 0;
    } else {
        return  10;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if(self.layoutType == XKMallListLayoutSingle) {
        return 0;
    } else {
        return  10;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    MallGoodsListItem *item = _dataArr[indexPath.row];
    XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
    [detail creatWkWebViewWithMethodNameArray:nil requestUrlString:[NSString stringWithFormat:@"http://test.xksquare.com/web/#/goodsdetail?client=xk&id=%@",item.ID]];
//    [detail updateDataWithItem:item];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10,kIphoneXNavi(64) + 44, SCREEN_WIDTH - 20, SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight - 44) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKWelfareListHeader"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XKWelfareListFooter"];
        [_collectionView registerClass:[XKMallListSingleCell class] forCellWithReuseIdentifier:@"XKMallListSingleCell"];
        [_collectionView registerClass:[XKMallListDoubleCell class] forCellWithReuseIdentifier:@"XKMallListDoubleCell"];
        
        XKWeakSelf(ws);
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ws.viewModel.page = 0;
            [ws requestDataWithTips:NO code:ws.model.code];
        }];
        narmalHeader.lastUpdatedTimeText = ^NSString *(NSDate *lastUpdatedTime) {
            ws.viewModel.timestamp = ceilf([lastUpdatedTime timeIntervalSince1970]);
            return [XKTimeSeparateHelper backYMDHMSStringByStrigulaSegmentWithDate:[NSDate date]];
        };
        self.collectionView.mj_header = narmalHeader;
        
        
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [ws requestDataWithTips:NO code:ws.model.code];
        }];
        [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
        self.collectionView.mj_footer = foot;
    }
    return _collectionView;
}

- (XKCustomNavBar *)toolsBar {
    if(!_toolsBar) {
        XKWeakSelf(ws);
        _toolsBar  =  [[XKCustomNavBar alloc] init];
        [_toolsBar customWelfareNaviBar];
        _toolsBar.inputTextFieldBlock = ^(NSString *text) {
            [ws reSearchTextWithText:text];
        };
        
        _toolsBar.leftButtonBlock = ^{
            [ws.navigationController popViewControllerAnimated:YES];
        };
        
        _toolsBar.messageButtonBlock = ^{
            [XKCustomeSerMessageManager createXKCustomerSerChat];
        };
        
        _toolsBar.buyCarButtonBlock = ^{
            XKMallBuyCarViewController *buyCarVC = [XKMallBuyCarViewController new];
            [ws.navigationController pushViewController:buyCarVC animated:YES];
        };
        
        _toolsBar.orderButtonBlock = ^{
            XKMainMallOrderViewController *orderVC = [XKMainMallOrderViewController new];
            [ws.navigationController pushViewController:orderVC animated:YES];
        };
        
        _toolsBar.layoutButtonBlock = ^{
            ws.layoutType =  (ws.layoutType == XKMallListLayoutSingle) ? XKMallListLayoutDouble : XKMallListLayoutSingle;
            [ws updateLayout];
        };
    }
    return _toolsBar;
}

- (XKMallTopFilterView *)filterView {
    if(!_filterView) {
        XKWeakSelf(ws);
      
        _filterView = [[XKMallTopFilterView alloc] initWithFrame:CGRectMake(0,kIphoneXNavi(64), SCREEN_WIDTH, 44)];
        _filterView.hotBClickBlock = ^(UIButton *sender) {
            sender.selected = !sender.selected;
            if(sender.selected) {
                [ws filterRefreshWithType:XKMllFilterTypePopularity sort:0];
            } else {
                [ws filterRefreshWithType:XKMllFilterTypePopularity sort:1];
            }
            
        };
        
        _filterView.sellBClickBlock = ^(UIButton *sender) {
            sender.selected = !sender.selected;
            if(sender.selected) {
                [ws filterRefreshWithType:XKMllFilterTypeSaleQ sort:0];
            } else {
                [ws filterRefreshWithType:XKMllFilterTypeSaleQ sort:1];
            }
        };
        
        _filterView.priceBClickBlock = ^(UIButton *sender) {
            sender.selected = !sender.selected;
            if(sender.selected) {
                [ws filterRefreshWithType:XKMllFilterTypePrice sort:0];
            } else {
                [ws filterRefreshWithType:XKMllFilterTypePrice sort:1];
            }
            
        };
    }
    return _filterView;
}
@end
