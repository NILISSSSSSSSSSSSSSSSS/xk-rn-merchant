//
//  XKSquareSearchTradingAreaListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareSearchTradingAreaListViewController.h"
#import "XKSquareSearchTradingAreaCell.h"
#import "XKSizerView.h"
#import "XKSizerSiftView.h"
#import "XKTradingAreaShopListModel.h"
#import "XKSquareSearchDetailMainViewController.h"
#import "XKStoreRecommendViewController.h"


static NSString * const tradingAreaCellID   = @"TradingAreaCellId";

@interface XKSquareSearchTradingAreaListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, SizerSiftViewDelegate>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) XKSizerView       *sizerView;
@property (nonatomic, strong) XKSizerSiftView   *sizerSiftView;
@property (nonatomic, strong) NSMutableArray           *dataSource;
/**请求页数*/
@property(nonatomic, assign) NSInteger page;
/**请求条数*/
@property(nonatomic, assign) NSInteger limit;
@property(nonatomic, assign) RefreshDataStatus refreshStatus;
@property (nonatomic, copy  ) NSString           *searchText;
@property (nonatomic, copy  ) NSString           *orderType;

@end

@implementation XKSquareSearchTradingAreaListViewController



#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);

    self.navigationView.hidden = YES;
    XKSquareSearchDetailMainViewController * vc = (XKSquareSearchDetailMainViewController *)self.parentViewController;
    self.searchText = vc.searchText;
    self.orderType = TradingAreaOrderTypeIntelligenece;
    [self configView];
    self.page = 1;
    self.limit = 10;
    [self loadRequestShopListisRefresh:YES OrderType:self.orderType KeyWord:self.searchText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events

#pragma mark - Private Metheods

- (void)configView {
    
    CGFloat topHight = 0;
    if (self.parentViewController.childViewControllers.count > 1) {
        [self.view addSubview:self.sizerView];
        topHight = 40;
    }
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(5 + topHight, 0, 0, 0));
    }];
}



#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKSquareSearchTradingAreaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tradingAreaCellID forIndexPath:indexPath];
    ShopListItem *model = self.dataSource[indexPath.row];
    [cell setValueWithModle:model];
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
    self.sizerSiftView.hidden = YES;
    XKStoreRecommendViewController *vc = [[XKStoreRecommendViewController alloc] init];
    ShopListItem *model = self.dataSource[indexPath.row];
    vc.shopId = model.itemId;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.sizerSiftView.hidden = YES;
}


#pragma mark - Custom Delegates

- (void)siftTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath selectedTitle:(NSString *)selectedTitle {
    if ([selectedTitle isEqualToString:@"智能排序"]) {
        self.orderType = TradingAreaOrderTypeIntelligenece;
    }else if ([selectedTitle isEqualToString:@"距离优先"]){
        self.orderType = TradingAreaOrderTypeDistance;

    }else if ([selectedTitle isEqualToString:@"好评优先"]){
        self.orderType = TradingAreaOrderTypeLevel;

    }else if ([selectedTitle isEqualToString:@"低价优先"]){
        self.orderType = TradingAreaOrderTypeAvgconsumptionL;

    }else if ([selectedTitle isEqualToString:@"高价优先"]){
        self.orderType = TradingAreaOrderTypeAvgconsumptionH;

    }
    //网络请求
    [self loadRequestShopListisRefresh:YES OrderType:self.orderType KeyWord:self.searchText];
    [self.sizerView setTitle:selectedTitle];
    self.sizerSiftView.hidden = YES;
}

#pragma mark - Custom Block

- (void)sizerViewClicked:(UIButton *)sender {
    self.sizerSiftView.hidden = !self.sizerSiftView.hidden;
}

#pragma mark - Getters and Setters
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
        layout.itemSize = CGSizeMake(SCREEN_WIDTH-20, ScreenScale * 100 + 30);
        layout.minimumLineSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationAndStatue_Height) collectionViewLayout:layout];

        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[XKSquareSearchTradingAreaCell class] forCellWithReuseIdentifier:tradingAreaCellID];
        
        XKWeakSelf(weakSelf);
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadRequestShopListisRefresh:YES OrderType:weakSelf.orderType KeyWord:weakSelf.searchText];
        }];
        _collectionView.mj_header = narmalHeader;
        
        
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadRequestShopListisRefresh:NO OrderType:weakSelf.orderType KeyWord:weakSelf.searchText];
        }];
        [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
        _collectionView.mj_footer = foot;
    }
    return _collectionView;
}



- (XKSizerView *)sizerView {
    if (!_sizerView) {
        _sizerView = [[XKSizerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _sizerView.backgroundColor = [UIColor whiteColor];
        [_sizerView setTitle:@"智能排序"];

        XKWeakSelf(weakSelf);
        _sizerView.sizerViewBlock = ^(UIButton *sender) {
            [weakSelf sizerViewClicked:sender];
        };
    }
    return _sizerView;
}

- (XKSizerSiftView *)sizerSiftView {
    
    if (!_sizerSiftView) {
        NSArray *array = @[@{@"title":@"智能排序", @"image":@""},
                           @{@"title":@"距离优先", @"image":@""},
                           @{@"title":@"好评优先", @"image":@""},
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

-(void)loadDataWithisRefresh:(BOOL)isRefresh KeyWord:(NSString *)keyWord OrderType:(NSString *)orderType Block:(void(^)(NSMutableArray *array))block{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        [XKHUD showLoadingText:nil];
        [parameters setObject:@(1) forKey:@"page"];
    } else {
        [parameters setObject:@(self.page + 1) forKey:@"page"];
        
    }
    parameters[@"orderType"] = orderType;
    parameters[@"name"] = keyWord;
    parameters[@"lng"] = [NSString stringWithFormat:@"%f",[[XKBaiduLocation shareManager]getUserLocationLaititudeAndLongtitude].longitude];
    parameters[@"lat"] = [NSString stringWithFormat:@"%f",[[XKBaiduLocation shareManager]getUserLocationLaititudeAndLongtitude].latitude];
    parameters[@"limit"] = @(self.limit);

    [HTTPClient postEncryptRequestWithURLString:@"goods/ua/esShopPage/1.0" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
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
            XKTradingAreaShopListModel *model = [XKTradingAreaShopListModel yy_modelWithJSON:responseObject];
            array = model.data.mutableCopy;
            
            if (self.dataSource.count < self.limit) {
                self.refreshStatus = Refresh_NoDataOrHasNoMoreData;
            } else {
                self.refreshStatus = Refresh_HasDataAndHasMoreData;
            }
            [self.dataSource addObjectsFromArray:array];
            block(self.dataSource);
            [XKHUD dismiss];
        }else {
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

- (void)loadRequestShopListisRefresh:(BOOL)refresh OrderType:(NSString *)orderType KeyWord:(NSString *)KeyWord{
    XKWeakSelf(ws);
    [self loadDataWithisRefresh:refresh KeyWord:KeyWord OrderType:(NSString *)orderType Block:^(NSMutableArray *array) {
        [self resetMJHeaderFooter:self.refreshStatus tableView:self.collectionView dataArray:array];
        [ws.collectionView reloadData];
    }];
}
@end
