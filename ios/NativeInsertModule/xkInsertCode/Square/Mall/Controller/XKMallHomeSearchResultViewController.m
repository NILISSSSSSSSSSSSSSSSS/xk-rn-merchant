//
//  XKMallHomeSearchResultViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/29.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMallHomeSearchResultViewController.h"
#import "XKMallTopFilterView.h"
#import "XKMallListViewModel.h"
#import "XKMallListSingleCell.h"
#import "XKMallListDoubleCell.h"
#import "XKMainMallOrderViewController.h"
#import "XKMallGoodsDetailViewController.h"
#import "XKMallBuyCarViewController.h"
#import "XKCustomeSerMessageManager.h"
@interface XKMallHomeSearchResultViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, copy) NSString  *text;
@property (nonatomic, strong) XKMallTopFilterView *filterView;
@property (nonatomic, strong)XKCustomNavBar *toolsBar;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, assign) NSInteger  page;
@end

@implementation XKMallHomeSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)handleData {
    [super handleData];
  
}

- (void)addCustomSubviews {
    [self hideNavigation];
    [self.view addSubview:self.toolsBar];
    [self.view addSubview:self.collectionView];
    self.emptyTipView = [XKEmptyPlaceView configScrollView:self.collectionView config:nil];
    
}


#pragma mark 网络请求

//请求第一页数据 可能有缓存
- (void)requestDataWithTips:(BOOL)tip {
    if(tip) {
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    _page ++;

    NSDictionary *dic = @{@"condition": @{
                                          @"category": @(self.code),
//                                          @"keyword" : self.searchText
                                          },
                          @"sort"     : @{
                                          @"type"    : @"popularity",
                                          @"isDesc"  : @(1)
                                          },
                          @"page"     : @(_page),
                          @"limit"    : @(10),
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
    if (_page == 1) {
        _dataArr = nil;
        if (listModel.count == 0) {//第一页没数据
            self.emptyTipView.config.viewAllowTap = YES;
            [self.emptyTipView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:^{
                [self.collectionView.mj_header beginRefreshing];
            }];
        }
    }
    
    if (listModel == nil) {
        _page --;
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    } else {
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:_dataArr];
        [tmp addObjectsFromArray:listModel];
        _dataArr = [tmp copy];
    }
    [self.collectionView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    _page --;
    [self.emptyTipView hide];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
    XKWeakSelf(ws);
    if (_dataArr.count == 0) {//无数据 请求第一页 请求出错
        self.emptyTipView.config.viewAllowTap = YES;
        [self.emptyTipView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
            [ws requestDataWithTips:NO];
        }];
    } else {//请求更多出错
        [self.emptyTipView hide];
        [XKHudView showErrorMessage:reason];
    }
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
    XKMallListSingleCell *singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKMallListSingleCell" forIndexPath:indexPath];
    [singleCell bindData:_dataArr[indexPath.row]];
    if(_dataArr.count == 1) {
        singleCell.bgContainView.xk_clipType = XKCornerClipTypeAllCorners;
    } else {
        if(indexPath.row == 0) {
            singleCell.bgContainView.xk_clipType = XKCornerClipTypeTopBoth;
        } else if(indexPath.row == _dataArr.count - 1) {
            singleCell.bgContainView.xk_clipType = XKCornerClipTypeBottomBoth;
        } else {
            singleCell.bgContainView.xk_clipType = XKCornerClipTypeNone;
        }
    }
    return singleCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
     return CGSizeMake(SCREEN_WIDTH, 90);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    MallGoodsListItem *item = _dataArr[indexPath.row];
    XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
    detail.goodsId = item.ID;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kIphoneXNavi(64), SCREEN_WIDTH, SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) collectionViewLayout:layout];
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
            ws.page = 0;
            [ws requestDataWithTips:NO];
        }];
    
        self.collectionView.mj_header = narmalHeader;


        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [ws requestDataWithTips:NO];
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
        [_toolsBar customBaseNavigationBar];
         _toolsBar.titleLabel.text = self.searchText;
        _toolsBar.leftButtonBlock = ^{
            [ws.navigationController popViewControllerAnimated:YES];
        };
    }
    return _toolsBar;
}


@end
