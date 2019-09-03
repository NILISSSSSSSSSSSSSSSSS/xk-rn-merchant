//
//  XKSquareSearchWelfareListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareSearchWelfareListViewController.h"
#import "XKWelfareListSingleCell.h"
#import "XKWelfareListSingleTimeCell.h"
#import "XKWelfareListSingleProgressCell.h"
#import "XKWelfareListSingleProgressAndTimeCell.h"
#import "XKWelfareListSingleProgressOrTimeCell.h"
#import "XKWelfareGoodsDetailViewController.h"
#import "XKWelfareGoodsListViewModel.h"
#import "XKWelfareGoodsDetailViewController.h"
#import "XKDeviceDataLibrery.h"
#import "XKWelfareGoodsListViewModel.h"
#import "XKSquareSearchDetailMainViewController.h"

@interface XKSquareSearchWelfareListViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView         *collectionView;
@property (nonatomic, strong) NSMutableArray           *dataSource;
/**请求页数*/
@property (nonatomic, assign) NSInteger                page;
/**请求条数*/
@property (nonatomic, assign) NSInteger                limit;
@property (nonatomic, assign) RefreshDataStatus        refreshStatus;
@property (nonatomic, copy  ) NSString                 *searchText;

@end

@implementation XKSquareSearchWelfareListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.limit = 10;
    XKSquareSearchDetailMainViewController * vc = (XKSquareSearchDetailMainViewController *)self.parentViewController;
    self.searchText = vc.searchText;
    [self addCustomSubviews];
    [self loadRequestListisRefresh:YES KeyWord:self.searchText];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)addCustomSubviews {
    [self hideNavigation];

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(5, 0, 0, 0));
    }];
    self.emptyTipView = [XKEmptyPlaceView configScrollView:self.collectionView config:nil];
}

#pragma mark collectionview代理 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        WelfareDataItem * item = self.dataSource[indexPath.row];
        XKWelfareListSingleCell *singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListSingleCell" forIndexPath:indexPath];
        if ([item.drawType isEqualToString:Jf_MallBytime]) {
            singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListSingleTimeCell" forIndexPath:indexPath];
        } else if ([item.drawType isEqualToString:Jf_MallBymember]) {
            singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListSingleProgressCell" forIndexPath:indexPath];
        } else if ([item.drawType isEqualToString:Jf_MallBytimeorbymember]) {
            singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListSingleProgressOrTimeCell" forIndexPath:indexPath];
            
        } else if ([item.drawType isEqualToString:Jf_MallBytimeandbymember]) {
            singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListSingleProgressAndTimeCell" forIndexPath:indexPath];
        }
        [singleCell bindData:item WithType:0];
        
    if (_dataSource.count == 1) {
        singleCell.bgContainView.xk_clipType = XKCornerClipTypeAllCorners;
        [singleCell hiddenSeperateLine:YES];
    } else {
        if(indexPath.row == 0) {
            singleCell.bgContainView.xk_clipType = XKCornerClipTypeTopBoth;
            [singleCell hiddenSeperateLine:NO];
        } else if(indexPath.row == _dataSource.count - 1) {
            singleCell.bgContainView.xk_clipType = XKCornerClipTypeBottomBoth;
            [singleCell hiddenSeperateLine:NO];
        } else {
            singleCell.bgContainView.xk_clipType = XKCornerClipTypeNone;
            [singleCell hiddenSeperateLine:NO];
        }
    }
        
        return singleCell;
  
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        WelfareDataItem * item = self.dataSource[indexPath.row];
        if ([item.drawType isEqualToString:Jf_MallBytime]) {
            return CGSizeMake(SCREEN_WIDTH, 135);
        } else if ([item.drawType isEqualToString:Jf_MallBymember]) {
            return CGSizeMake(SCREEN_WIDTH, 130);
        } else if ([item.drawType isEqualToString:Jf_MallBytimeorbymember]) {
            return CGSizeMake(SCREEN_WIDTH, 155);
        } else if ([item.drawType isEqualToString:Jf_MallBytimeandbymember]) {
            return CGSizeMake(SCREEN_WIDTH, 155);
        }
        return CGSizeZero;
  
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
      return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
      return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
      return UIEdgeInsetsZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    WelfareDataItem *item = self.dataSource[indexPath.row];
    XKWelfareGoodsDetailViewController *detail = [XKWelfareGoodsDetailViewController new];
    detail.goodsId = item.goodsId;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKWelfareListHeader"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XKWelfareListFooter"];
        [_collectionView registerClass:[XKWelfareListSingleCell class] forCellWithReuseIdentifier:@"XKWelfareListSingleCell"];
        [_collectionView registerClass:[XKWelfareListSingleProgressCell class] forCellWithReuseIdentifier:@"XKWelfareListSingleProgressCell"];
        [_collectionView registerClass:[XKWelfareListSingleTimeCell class] forCellWithReuseIdentifier:@"XKWelfareListSingleTimeCell"];
        [_collectionView registerClass:[XKWelfareListSingleProgressOrTimeCell class] forCellWithReuseIdentifier:@"XKWelfareListSingleProgressOrTimeCell"];
        [_collectionView registerClass:[XKWelfareListSingleProgressAndTimeCell class] forCellWithReuseIdentifier:@"XKWelfareListSingleProgressAndTimeCell"];
        XKWeakSelf(weakSelf);
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadRequestListisRefresh:YES KeyWord:weakSelf.searchText];
        }];
        _collectionView.mj_header = narmalHeader;
        
        
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadRequestListisRefresh:NO KeyWord:weakSelf.searchText];
        }];
        [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
        _collectionView.mj_footer = foot;
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark network
-(void)loadDataWithisRefresh:(BOOL)isRefresh KeyWord:(NSString *)keyWord Block:(void(^)(NSMutableArray *array))block{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        [XKHUD showLoadingText:nil];
        [parameters setObject:@(1) forKey:@"page"];
    } else {
        [parameters setObject:@(self.page + 1) forKey:@"page"];
        
    }
    parameters[@"sCondition"] = @{@"keyword":keyWord};
    parameters[@"limit"] = @(self.limit);
    
    [HTTPClient postEncryptRequestWithURLString:@"goods/ua/jmallEsSearch/1.0" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        NSArray *array = [NSArray array];
        if (responseObject) {
            if (isRefresh) {
                self.page = 1;
            } else {
                self.page += 1;
            }
            if (isRefresh) {
                [self.dataSource removeAllObjects];
            }
            XKWelfareGoodsListViewModel *model = [XKWelfareGoodsListViewModel yy_modelWithJSON:responseObject];
            array = model.data.mutableCopy;
            
            if (self.dataSource.count < self.limit) {
                self.refreshStatus = Refresh_NoDataOrHasNoMoreData;
            } else {
                self.refreshStatus = Refresh_HasDataAndHasMoreData;
            }
            [self.dataSource addObjectsFromArray:array];
            block(self.dataSource);
            [XKHUD dismiss];
        }else{
            [XKHUD dismiss];
            self.refreshStatus = Refresh_NoDataOrHasNoMoreData;
            block(self.dataSource);
        }
    } failure:^(XKHttpErrror *error) {
        self.refreshStatus = Refresh_NoNet;
        block(self.dataSource);
        [XKHUD dismiss];
    }];
}

- (void)loadRequestListisRefresh:(BOOL)refresh KeyWord:(NSString *)KeyWord{
    XKWeakSelf(ws);
    [self loadDataWithisRefresh:refresh KeyWord:KeyWord Block:^(NSMutableArray *array) {
        [self resetMJHeaderFooter:self.refreshStatus tableView:self.collectionView dataArray:array];
        [ws.collectionView reloadData];
    }];
}
@end
