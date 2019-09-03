//
//  XKSquareSearchSynthesisListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareSearchSynthesisListViewController.h"
#import "XKWelfareGoodsDetailViewController.h"
#import "XKSquareSearchTradingAreaCell.h"
#import "XKSquareSearchDetailMainViewController.h"
#import "XKSquareSearchSynthesisListModel.h"
#import "XKMallListSingleCell.h"
#import "XKWelfareListSingleTimeCell.h"
#import "XKWelfareListSingleProgressCell.h"
#import "XKWelfareListSingleProgressOrTimeCell.h"
#import "XKWelfareListSingleProgressAndTimeCell.h"
#import "XKTradingAreaShopListModel.h"
#import "XKMallGoodsDetailViewController.h"
#import "XKStoreRecommendViewController.h"

//自营
static NSString * const XKMallListSingleCellID   = @"XKMallListSingleCellID";
//福利
static NSString * const XKWelfareListSingleTimeCellID = @"XKWelfareListSingleTimeCellID";
static NSString * const XKWelfareListSingleProgressCellID   = @"XKWelfareListSingleProgressCellID";
static NSString * const XKWelfareListSingleProgressOrTimeCellID   = @"XKWelfareListSingleProgressOrTimeCellID";
static NSString * const XKWelfareListSingleProgressAndTimeCellID   = @"XKWelfareListSingleProgressAndTimeCellID";
//店铺
static NSString * const XKSquareSearchTradingAreaCellID   = @"XKSquareSearchTradingAreaCellID";


@interface XKSquareSearchSynthesisListViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong  ) NSMutableArray           *dataSource;
/**请求页数*/
@property(nonatomic, assign) NSInteger page;
/**请求条数*/
@property(nonatomic, assign) NSInteger limit;
@property(nonatomic, assign) RefreshDataStatus refreshStatus;
@property (nonatomic, copy  ) NSString           *searchText;

@end

@implementation XKSquareSearchSynthesisListViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    self.navigationView.hidden = YES;
    self.page = 1;
    self.limit = 10;
    XKSquareSearchDetailMainViewController * vc = (XKSquareSearchDetailMainViewController *)self.parentViewController;
    self.searchText = vc.searchText;
    [self configTableView];
    [self loadRequestShopListisRefresh:YES KeyWord:self.searchText];
}


#pragma mark - Private Metheods
- (void)configTableView {
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(5, 0, 0, 0));
    }];
}





#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    UICollectionViewCell *cell;
    
    XKSquareSearchSynthesisListDataItem *itemModel = self.dataSource[indexPath.row];
    
    if ([itemModel.xKModule isEqualToString:XKModuleMall]) {
        
         cell = (XKMallListSingleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:XKMallListSingleCellID forIndexPath:indexPath];
        XKMallListSingleCell *mallCell = (XKMallListSingleCell *)cell;
        [mallCell bindData:[self getMallListItemModelWithDataItem:itemModel]];
        
    }else if ([itemModel.xKModule isEqualToString:XKModuleshop]){
        
        cell = (XKSquareSearchTradingAreaCell *)[collectionView dequeueReusableCellWithReuseIdentifier:XKSquareSearchTradingAreaCellID forIndexPath:indexPath];
        XKSquareSearchTradingAreaCell *areaCell = (XKSquareSearchTradingAreaCell *)cell;
        [areaCell setValueWithModle:[self getShopListItemModelWithDataItem:itemModel]];

    }else if ([itemModel.xKModule isEqualToString:XKModulejf_mall]){
        
        if ([itemModel.drawType isEqualToString:Jf_MallBytime]) {
             cell = (XKWelfareListSingleTimeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:XKWelfareListSingleTimeCellID forIndexPath:indexPath];
            XKWelfareListSingleTimeCell *timeCell = (XKWelfareListSingleTimeCell *)cell;
            [timeCell bindData:[self getWelfareListItemModelWithDataItem:itemModel] WithType:0];
            
            
        }else if ([itemModel.drawType isEqualToString:Jf_MallBymember]){
            
             cell = (XKWelfareListSingleProgressCell *)[collectionView dequeueReusableCellWithReuseIdentifier:XKWelfareListSingleProgressCellID forIndexPath:indexPath];
            XKWelfareListSingleProgressCell *timeCell = (XKWelfareListSingleProgressCell *)cell;
            [timeCell bindData:[self getWelfareListItemModelWithDataItem:itemModel] WithType:0];
            
        }
        else if ([itemModel.drawType isEqualToString:Jf_MallBytimeorbymember]){
            
             cell = (XKWelfareListSingleProgressOrTimeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:XKWelfareListSingleProgressOrTimeCellID forIndexPath:indexPath];
            XKWelfareListSingleProgressOrTimeCell *timeCell = (XKWelfareListSingleProgressOrTimeCell *)cell;
            [timeCell bindData:[self getWelfareListItemModelWithDataItem:itemModel] WithType:0];
            
        }
        else if ([itemModel.drawType isEqualToString:Jf_MallBytimeandbymember]){
            
             cell = (XKWelfareListSingleProgressAndTimeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:XKWelfareListSingleProgressAndTimeCellID forIndexPath:indexPath];
            XKWelfareListSingleProgressAndTimeCell *timeCell = (XKWelfareListSingleProgressAndTimeCell *)cell;
            [timeCell bindData:[self getWelfareListItemModelWithDataItem:itemModel] WithType:0];
            
        }
    }
    cell.xk_openClip = YES;
    cell.xk_radius = 5;
    if (indexPath.row == 0) {
        cell.xk_clipType = XKCornerClipTypeTopBoth;
    } else if (indexPath.row == self.dataSource.count - 1) {
        cell.xk_clipType = XKCornerClipTypeBottomBoth;
    } else {
        cell.xk_clipType = XKCornerClipTypeNone;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XKSquareSearchSynthesisListDataItem * item = self.dataSource[indexPath.row];
    if ([item.xKModule isEqualToString:XKModuleMall]){
        
        XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
        detail.goodsId = item.goodsId;
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if ([item.xKModule isEqualToString:XKModuleshop]){
        
        XKStoreRecommendViewController *vc = [[XKStoreRecommendViewController alloc] init];
        vc.shopId = item.ID;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([item.xKModule isEqualToString:XKModulejf_mall]){
        
        XKWelfareGoodsDetailViewController *detail = [XKWelfareGoodsDetailViewController new];
        detail.goodsId = item.goodsId;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKSquareSearchSynthesisListDataItem * item = self.dataSource[indexPath.row];
    if ([item.xKModule isEqualToString:XKModuleMall]){
        return CGSizeMake(SCREEN_WIDTH, 90);

    }else if ([item.xKModule isEqualToString:XKModuleshop]){
        return CGSizeMake(SCREEN_WIDTH-20, ScreenScale*100+30);
        
    }else if ([item.xKModule isEqualToString:XKModulejf_mall]){
        
        if ([item.drawType isEqualToString:Jf_MallBytime]) {
            return CGSizeMake(SCREEN_WIDTH, 135);
        } else if ([item.drawType isEqualToString:Jf_MallBymember]) {
            return CGSizeMake(SCREEN_WIDTH, 130);
        } else if ([item.drawType isEqualToString:Jf_MallBytimeorbymember]) {
            return CGSizeMake(SCREEN_WIDTH, 155);
        } else if ([item.drawType isEqualToString:Jf_MallBytimeandbymember]) {
            return CGSizeMake(SCREEN_WIDTH, 155);
        }
    }
    
        return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
        return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
        return 0;
}

#pragma mark - lazy load
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, ScreenScale * 100 + 30);
        layout.minimumLineSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationAndStatue_Height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[XKMallListSingleCell class] forCellWithReuseIdentifier:XKMallListSingleCellID];
        
        [_collectionView registerClass:[XKWelfareListSingleTimeCell  class] forCellWithReuseIdentifier:XKWelfareListSingleTimeCellID];
        
        [_collectionView registerClass:[XKWelfareListSingleProgressCell class] forCellWithReuseIdentifier:XKWelfareListSingleProgressCellID];
        
        [_collectionView registerClass:[XKWelfareListSingleProgressOrTimeCell class] forCellWithReuseIdentifier:XKWelfareListSingleProgressOrTimeCellID];
        
        [_collectionView registerClass:[XKWelfareListSingleProgressAndTimeCell class] forCellWithReuseIdentifier:XKWelfareListSingleProgressAndTimeCellID];
        
        [_collectionView registerClass:[XKSquareSearchTradingAreaCell class] forCellWithReuseIdentifier:XKSquareSearchTradingAreaCellID];

        XKWeakSelf(weakSelf);
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadRequestShopListisRefresh:YES KeyWord:weakSelf.searchText];
        }];
        _collectionView.mj_header = narmalHeader;
        
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadRequestShopListisRefresh:NO KeyWord:weakSelf.searchText];
        }];
        [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
        _collectionView.mj_footer = foot;
    }
    return _collectionView;
}

-(void)loadDataWithisRefresh:(BOOL)isRefresh KeyWord:(NSString *)keyWord Block:(void(^)(NSMutableArray *array))block{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        [XKHUD showLoadingText:nil];
        [parameters setObject:@(1) forKey:@"page"];
    } else {
        [parameters setObject:@(self.page + 1) forKey:@"page"];
        
    }
    parameters[@"jCondition"] = @{@"keyword":keyWord};
    parameters[@"limit"] = @(self.limit);
    
    [HTTPClient postEncryptRequestWithURLString:@"goods/ua/integrateSearch/1.0" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
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
            XKSquareSearchSynthesisListModel *model = [XKSquareSearchSynthesisListModel yy_modelWithJSON:responseObject];
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

- (void)loadRequestShopListisRefresh:(BOOL)refresh KeyWord:(NSString *)KeyWord{
    XKWeakSelf(ws);
    [self loadDataWithisRefresh:refresh KeyWord:KeyWord Block:^(NSMutableArray *array) {
        [self resetMJHeaderFooter:self.refreshStatus tableView:self.collectionView dataArray:array];
        [ws.collectionView reloadData];
    }];
}


- (ShopListItem *)getShopListItemModelWithDataItem:(XKSquareSearchSynthesisListDataItem *)dataItem {
    ShopListItem *listItem = [[ShopListItem alloc]init];
    listItem.cover = dataItem.cover;
    listItem.name = dataItem.name;
    listItem.level = dataItem.level;
    listItem.distance = dataItem.distance;
    listItem.monthVolume = dataItem.monthVolume;
    return listItem;
}


- (MallGoodsListItem *)getMallListItemModelWithDataItem:(XKSquareSearchSynthesisListDataItem *)dataItem {
    MallGoodsListItem *mallItem = [[MallGoodsListItem alloc]init];
    mallItem.pic = dataItem.mainUrl;
    mallItem.name = dataItem.goodsName;
    mallItem.saleQ = dataItem.saleM;
    mallItem.price = dataItem.price;
    return mallItem;
}

- (WelfareDataItem *)getWelfareListItemModelWithDataItem:(XKSquareSearchSynthesisListDataItem *)dataItem {
    WelfareDataItem *welfarItem = [[WelfareDataItem alloc]init];
    welfarItem.mainUrl = dataItem.mainUrl;
    welfarItem.goodsName = dataItem.goodsName;
    welfarItem.perPrice = dataItem.perPrice;
    welfarItem.expectDrawTime = dataItem.expectDrawTime;
    welfarItem.joinCount = dataItem.joinCount;
    welfarItem.maxStake = dataItem.maxStake;
    return welfarItem;
}
@end
