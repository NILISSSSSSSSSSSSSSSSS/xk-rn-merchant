////
////  XKVideoCitywideViewController.m
////  XKSquare
////
////  Created by RyanYuan on 2018/10/9.
////  Copyright © 2018年 xk. All rights reserved.
////
//
//#import "XKVideoCitywideViewController.h"
//#import "XKVideoCitywideCollectionViewLayout.h"
//#import "XKVideoCitywideCollectionViewCell.h"
//#import "XKVideoCitywideCollectionHeaderView.h"
//#import "XKCityListViewController.h"
//#import "XKBaiduLocation.h"
//#import "XKVideoDisplayModel.h"
//#import "XKVideoDisplayMediator.h"
//
//static const CGFloat kVideoCitywideViewControllerHeaderViewHeight = 65;
//
//@interface XKVideoCitywideViewController () <UICollectionViewDelegate, UICollectionViewDataSource, XKVideoCitywideCollectionHeaderViewDelegate, XKBaiduLocationDelegate>
//
//@property (nonatomic, strong) NSString *cityName;
////@property (nonatomic, strong) NSString *cityCode;
//
//@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) XKVideoCitywideCollectionViewLayout *layout;
//
//@property (nonatomic, assign) NSInteger currentPage;
//@property (nonatomic, strong) NSMutableArray *dataArr;
//
//@property (nonatomic, strong) NSMutableArray *picImageArr;
//@property (nonatomic, strong) NSMutableArray *heights;
//
//@end
//
//@implementation XKVideoCitywideViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    // 初始化城市
//    self.cityName = @"暂无定位";
//    //    self.cityCode = @"";
//    
//    // 开启定位
//    [self startLocation];
//    
//    // 初始化collectionViewbu布局
//    self.layout = [XKVideoCitywideCollectionViewLayout new];
//    self.layout.type = XKVideoCitywideCollectionViewLayoutTypeVertical;
//    self.layout.headerHeight = kVideoCitywideViewControllerHeaderViewHeight;
//    self.layout.numberOfColumns = 2;
//    self.layout.columnGap = 10;
//    self.layout.rowGap = 5;
//    self.layout.insets = UIEdgeInsetsMake(0, 10, 10, 10);
//    
//    // 初始化collectionView
//    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
//    self.collectionView.backgroundColor = HEX_RGB(0xF6F6F6);
//    self.collectionView.showsVerticalScrollIndicator = NO;
//    self.collectionView.showsHorizontalScrollIndicator = NO;
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    [self.collectionView registerClass:[XKVideoCitywideCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKVideoCitywideCollectionHeaderView"];
//    [self.collectionView registerClass:[XKVideoCitywideCollectionViewCell class] forCellWithReuseIdentifier:@"XKVideoCitywideCollectionViewCell"];
//    [self.view addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.equalTo(self.view);
//    }];
//    
//    // 下拉刷新
//    __weak typeof(self) weakSelf = self;
//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.currentPage = 0;
//        [weakSelf loadData];
//        [weakSelf.collectionView.mj_header endRefreshing];
//    }];
//    
//    // 上拉加载
//    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf loadData];
//    }];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    [self.collectionView reloadData];
//}
//
//#pragma mark - UICollectionViewDataSource
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.dataArr.count;
//}
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        XKVideoCitywideCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKVideoCitywideCollectionHeaderView" forIndexPath:indexPath];
//        [headerView configHeaderViewWithCityName:self.cityName];
//        headerView.delegate = self;
//        return headerView;
//    } else {
//        return nil;
//    }
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    XKVideoCitywideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKVideoCitywideCollectionViewCell" forIndexPath:indexPath];
//    XKVideoDisplayVideoListItemModel *model = self.dataArr[indexPath.row];
//    [cell configCellWithVideo:model];
//    return cell;
//}
//
//#pragma mark - UICollectionViewDelegate
//
///**
// * 进入单个小视频播放
// */
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    XKVideoDisplayVideoListItemModel *model = self.dataArr[indexPath.row];
//    XKVideoCitywideCollectionViewCell *cell = (XKVideoCitywideCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [XKVideoDisplayMediator displaySingleVideoWithViewController:self.parentViewController videoListItemModel:model fromView:[cell getCellMainImageView]];
//}
//
//#pragma mark - XKVideoCitywideCollectionHeaderViewDelegate
//
///**
// * 点击区域选择
// */
//- (void)headerView:(XKVideoCitywideCollectionHeaderView *)headerView clickBgControl:(UIControl *)control {
//    
//    XKCityListViewController *cityListViewController = [[XKCityListViewController alloc] init];
//    XKWeakSelf(weakSelf);
//    cityListViewController.citySelectedBlock = ^(NSString *cityName, double laititude, double longtitude, NSString *cityCode) {
//        weakSelf.cityName = cityName;
//        [weakSelf.collectionView.mj_header beginRefreshing];
//    };
//    [self presentViewController:cityListViewController animated:YES completion:nil];
//}
//
//#pragma mark - XKBaiduLocationDelegate
//
///**
// * 获取定位信息成功回调
// */
//- (void)userLocationCountry:(NSString *)country state:(NSString *)state city:(NSString *)city subLocality:(NSString *)subLocality name:(NSString *)name {
//    
//    self.cityName = city;
//    [self.collectionView.mj_header beginRefreshing];
//}
//
///**
// * 获取定位信息失败回调
// */
//- (void)failToLocateUserWithError:(NSError *)error {
//    
//    self.cityName = @"暂无定位";
//    [self.collectionView.mj_header beginRefreshing];
//}
//
//#pragma mark - private method
//
///**
// * 开始定位
// */
//- (void)startLocation {
//    
//    XKBaiduLocation *baiduLocation = [XKBaiduLocation shareManager];
//    baiduLocation.delegate = self;
//    if (baiduLocation.locationAuthorized) {
//        [baiduLocation startBaiduSingleLocationService];
//    } else {
//        self.cityName = @"暂无定位";
//        [self.collectionView.mj_header beginRefreshing];
//    }
//}
//
///**
// * 获取同城小视频
// */
//- (void)loadData {
//    
//    NSString *rand = [XKUserInfo getCurrentRecommendVideoRand] ? [XKUserInfo getCurrentRecommendVideoRand] : @"";
//    NSString *pageString = [NSString stringWithFormat:@"%@", @(self.currentPage)];
//    NSInteger limitCount = 8;
//    NSString *city;
//    if ([self.cityName isEqualToString:@"暂无定位"]) {
//        city = @"德阳市";
//    } else {
//        city = self.cityName;
//    }
//    NSMutableDictionary *params = @{@"rand": rand,
//                                    @"page": pageString,
//                                    @"limit": [NSString stringWithFormat:@"%@", @(limitCount)],
//                                    @"doc_type": @"1",
//                                    @"city": city}.mutableCopy;
//    [XKZBHTTPClient postRequestWithURLString:GetCityVideoUrl timeoutInterval:20.0 parameters:params success:^(id responseObject) {
//        [self.collectionView.mj_header endRefreshing];
//        [self.collectionView.mj_footer endRefreshing];
//        
//        XKVideoDisplayModel *model =  [XKVideoDisplayModel yy_modelWithJSON:responseObject];
//        NSString *rand = model.body.rand;
//        [XKUserInfo currentUser].recommendVideoRand = rand;
//        XKUserSynchronize;
//        NSArray *videoList = model.body.video_list;
//        
//        // 首页重置数据源
//        if (self.currentPage == 0) {
//            [self.dataArr removeAllObjects];
//            [self.picImageArr removeAllObjects];
//            [self.heights removeAllObjects];
//        }
//        [self.dataArr addObjectsFromArray:videoList];
//        [self refreshCollectionView:videoList];
//        self.currentPage++;
//        
//        // 区脚处理
//        if (videoList.count < limitCount) {
//            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
//        } else {
//            [self.collectionView.mj_footer resetNoMoreData];
//        }
//        
//    } failure:^(XKHttpErrror *error) {
//        [self.collectionView.mj_header endRefreshing];
//        [self.collectionView.mj_footer endRefreshing];
//    }];
//}
//
///**
// * 刷新collectionView高度
// */
//- (void)refreshCollectionView:(NSArray *)currentDataArr {
//    
//    // 数据源为空
//    if (currentDataArr.count == 0) {
//        [self.collectionView reloadData];
//        return;
//    }
//    
//    for (int i = 0; i < currentDataArr.count; i++) {
//        
//        // 获取首帧图
//        XKVideoDisplayVideoListItemModel *model = currentDataArr[i];
//        NSString *firstCoverUrlString = model.video.first_cover;
//        
//        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:firstCoverUrlString] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//            
//        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//            
//            if (self.heights.count == self.dataArr.count) {
//                return;
//            }
//            
//            if (image) {
//                if (self.picImageArr.count < self.dataArr.count) {
//                    [self.picImageArr addObject:image];
//                }
//                
//                // 未加载完全部数据
//                if (self.heights.count < self.dataArr.count) {
//                    
//                    // 根据图片原始比例 计算 当前图片的高度(宽度固定)
//                    CGFloat scale = image.size.height / image.size.width;
//                    CGFloat width = self.layout.itemWidth;
//                    CGFloat height = width * scale + kVideoCitywideCollectionViewCellAppendHeight;
//                    
//                    // 流式布局
//                    height = 300;
//                    NSNumber *heightNum = [NSNumber numberWithFloat:height];
//                    [self.heights addObject:heightNum];
//                }
//                
//                // 加载完全部数据
//                if (self.heights.count == self.dataArr.count) {
//                    // 赋值所有cell的高度数组itemHeights
//                    self.layout.itemHeights = self.heights;
//                    [self.collectionView reloadData];
//                }
//            }
//        }];
//    }
//}
//
//#pragma mark - setter and getter
//
//- (NSMutableArray *)dataArr {
//    
//    if (!_dataArr) {
//        _dataArr = @[].mutableCopy;
//    }
//    return _dataArr;
//}
//
//- (NSMutableArray *)picImageArr {
//    
//    if (!_picImageArr) {
//        _picImageArr = @[].mutableCopy;
//    }
//    return _picImageArr;
//}
//
//- (NSMutableArray *)heights {
//    
//    if (!_heights) {
//        _heights = [[NSMutableArray alloc] init];
//    }
//    return _heights;
//}
//
//@end
