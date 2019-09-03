//
//  XKSquareSearchStoreListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareSearchStoreListViewController.h"
#import "XKMallListSingleCell.h"
#import "XKMallGoodsDetailViewController.h"
#import "XKAlertView.h"
#import "XKSizerView.h"
#import "XKSizerSiftView.h"
#import "XKDeviceDataLibrery.h"
#import "XKSquareSearchDetailMainViewController.h"

@interface XKSquareSearchStoreListViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
SizerSiftViewDelegate
>

@property (nonatomic, strong) UICollectionView         *collectionView;
@property (nonatomic, strong) NSMutableArray           *dataSource;
@property (nonatomic, strong) XKSizerView               *sizerView;
@property (nonatomic, strong) XKSizerSiftView          *sizerSiftView;
/**请求页数*/
@property (nonatomic, assign) NSInteger                page;
/**请求条数*/
@property (nonatomic, assign) NSInteger                limit;
@property (nonatomic, assign) RefreshDataStatus        refreshStatus;
@property (nonatomic, copy  ) NSString                 *searchText;
@property (nonatomic, copy  ) NSString                 *type;

@end

@implementation XKSquareSearchStoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.limit = 10;
    self.type = @"POPULARITY";
    XKSquareSearchDetailMainViewController * vc = (XKSquareSearchDetailMainViewController *)self.parentViewController;
    self.searchText = vc.searchText;
    [self addCustomSubviews];
    [self loadRequestListisRefresh:YES KeyWord:self.searchText];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    [self.view addSubview:self.collectionView];
    
    CGFloat topHight = 0;
    if (self.parentViewController.childViewControllers.count > 1) {
        [self.view addSubview:self.sizerView];
        topHight = 40;
    }
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(5 + topHight, 0, 0, 0));
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

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKMallListSingleCell *singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKMallListSingleCell" forIndexPath:indexPath];
    MallGoodsListItem *itemModel = self.dataSource[indexPath.row];
    [singleCell bindData:itemModel];
    if(self.dataSource.count == 1) {
        singleCell.bgContainView.xk_clipType = XKCornerClipTypeAllCorners;
    } else {
        if(indexPath.row == 0) {
            singleCell.bgContainView.xk_clipType = XKCornerClipTypeTopBoth;
        } else if(indexPath.row == self.dataSource.count - 1) {
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
     return UIEdgeInsetsZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.sizerSiftView.hidden = YES;

    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    MallGoodsListItem * item = self.dataSource[indexPath.row];
    XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
    detail.goodsId = item.ID;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.sizerSiftView.hidden = YES;
}

#pragma mark - Custom Block

- (void)sizerViewClicked:(UIButton *)sender {
    self.sizerSiftView.hidden = !self.sizerSiftView.hidden;
}


#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight - 44) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKWelfareListHeader"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XKWelfareListFooter"];
        [_collectionView registerClass:[XKMallListSingleCell class] forCellWithReuseIdentifier:@"XKMallListSingleCell"];

        XKWeakSelf(weakSelf);
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadRequestListisRefresh:YES KeyWord:weakSelf.searchText];
        }];
        _collectionView.mj_header = narmalHeader;
        
        
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadRequestListisRefresh:YES KeyWord:weakSelf.searchText];
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

- (XKSizerView *)sizerView {
    if (!_sizerView) {
        _sizerView = [[XKSizerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _sizerView.backgroundColor = [UIColor whiteColor];
        [_sizerView setTitle:@"人气优先"];
        
        XKWeakSelf(weakSelf);
        _sizerView.sizerViewBlock = ^(UIButton *sender) {
            [weakSelf sizerViewClicked:sender];
        };
    }
    return _sizerView;
}



- (XKSizerSiftView *)sizerSiftView {
    
    if (!_sizerSiftView) {
        NSArray *array = @[@{@"title":@"人气优先", @"image":@""},
                           @{@"title":@"销量优先", @"image":@""},
                           @{@"title":@"低价优先", @"image":@""},
                           @{@"title":@"高价优先", @"image":@""}
                           ];
        _sizerSiftView = [[XKSizerSiftView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, CGRectGetMaxY(self.sizerView.frame)-10, 90, array.count*44)];
        [_sizerSiftView setDataSource:array];
        _sizerSiftView.delegate = self;
        _sizerSiftView.layer.borderColor = HEX_RGB(0xD8D8D8).CGColor;
        _sizerSiftView.layer.borderWidth = 1;
        _sizerSiftView.layer.masksToBounds = YES;
        _sizerSiftView.layer.cornerRadius = 5;
        _sizerSiftView.hidden = YES;
        [self.view addSubview:_sizerSiftView];
    }
    return _sizerSiftView;
}

- (void)siftTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath selectedTitle:(NSString *)selectedTitle {
    //网络请求
    if ([selectedTitle isEqualToString:@"人气优先"]) {
        self.type = @"POPULARITY";
    } else if ([selectedTitle isEqualToString:@"销量优先"]) {
        self.type = @"SALE_NUM";
    } else if ([selectedTitle isEqualToString:@"低价优先"]) {
        self.type = @"PRICE_ASC";
    } else if ([selectedTitle isEqualToString:@"高价优先"]) {
        self.type = @"PRICE_DESC";
    }
    [self loadRequestListisRefresh:YES KeyWord:self.searchText];
    [self.sizerView setTitle:selectedTitle];
    self.sizerSiftView.hidden = YES;
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
    parameters[@"sCondition"] = @{@"goodsName":keyWord, @"orderType":self.type};
    parameters[@"limit"] = @(self.limit);
    
    [HTTPClient postEncryptRequestWithURLString:@"goods/ua/mallEsSearch/1.0" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
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
            XKMallGoodsListModel *model = [XKMallGoodsListModel yy_modelWithJSON:responseObject];
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


- (void)loadRequestListisRefresh:(BOOL)refresh KeyWord:(NSString *)KeyWord {
    XKWeakSelf(ws);
    [self loadDataWithisRefresh:refresh KeyWord:KeyWord Block:^(NSMutableArray *array) {
        [self resetMJHeaderFooter:self.refreshStatus tableView:self.collectionView dataArray:array];
        [ws.collectionView reloadData];
    }];
}
@end
