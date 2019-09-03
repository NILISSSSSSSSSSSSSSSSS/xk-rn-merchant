//
//  XKVideoHomePageViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/10/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoHomePageViewController.h"
#import "XKVideoHomePageCollectionHeaderView.h"
//#import "XKCityListViewController.h"
#import "XKVideoCitywideCollectionViewLayout.h"
#import "XKVideoCitywideCollectionViewCell.h"
#import "XKVideoDisplayModel.h"
#import "XKVideoDisplayMediator.h"
#import "XKLiveBannerModel.h"
#import "XKJumpWebViewController.h"

static const CGFloat kVideoHomePageViewControllerHeaderViewHeight = 177;

@interface XKVideoHomePageViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XKVideoHomePageCollectionHeaderViewDelegate>

@property (nonatomic, strong) NSArray<XKLiveBannerModelListItem *> *liveBannerModelList;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) XKVideoCitywideCollectionViewLayout *layout;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *picImageArr;
@property (nonatomic, strong) NSMutableArray *heights;

@end

@implementation XKVideoHomePageViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化collectionView布局
    self.layout = [XKVideoCitywideCollectionViewLayout new];
    self.layout.type = XKVideoCitywideCollectionViewLayoutTypeVertical;
    self.layout.headerHeight = kVideoHomePageViewControllerHeaderViewHeight;
    self.layout.numberOfColumns = 2;
    self.layout.columnGap = 10;
    self.layout.rowGap = 5;
    self.layout.insets = UIEdgeInsetsMake(0, 10, 10, 10);
    
    // 初始化collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = HEX_RGB(0xF6F6F6);
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[XKVideoHomePageCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKVideoHomePageCollectionHeaderView"];
    [self.collectionView registerClass:[XKVideoCitywideCollectionViewCell class] forCellWithReuseIdentifier:@"XKVideoCitywideCollectionViewCell"];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    // 上拉加载
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    self.currentPage = 0;
    [self loadData];
    [self getLiveBannerUrl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        XKVideoHomePageCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKVideoHomePageCollectionHeaderView" forIndexPath:indexPath];
        headerView.delegate = self;
        [headerView configHeaderViewWithModel:self.liveBannerModelList];
        return headerView;
    } else {
        return nil;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKVideoCitywideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKVideoCitywideCollectionViewCell" forIndexPath:indexPath];
    XKVideoDisplayVideoListItemModel *model = self.dataArr[indexPath.row];
    [cell configCellWithVideo:model];
    return cell;
}

#pragma mark - UICollectionViewDelegate

/**
 * 进入单个小视频播放
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKVideoDisplayVideoListItemModel *model = self.dataArr[indexPath.row];
    XKVideoCitywideCollectionViewCell *cell = (XKVideoCitywideCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [XKVideoDisplayMediator displaySingleVideoWithViewController:self.parentViewController videoListItemModel:model fromView:[cell getCellMainImageView]];
}

#pragma mark - XKVideoHomePageCollectionHeaderViewDelegate

- (void)headerView:(XKVideoHomePageCollectionHeaderView *)headerView clickBannerWithUrlLink:(NSString *)urlString {

    XKJumpWebViewController *squreBannerJumpWebViewController = [[XKJumpWebViewController alloc] init];
    squreBannerJumpWebViewController.url = urlString;
    [self.navigationController pushViewController:squreBannerJumpWebViewController animated:YES];
}

#pragma mark - private method

/**
 * 获取直播banner
 */
- (void)getLiveBannerUrl {
    
    [XKZBHTTPClient postRequestWithURLString:GetLiveBannerUrl timeoutInterval:20.0 parameters:@{} success:^(id responseObject) {
        XKLiveBannerModel *model =  [XKLiveBannerModel yy_modelWithJSON:responseObject];
        self.liveBannerModelList = model.body.list;
        [self.collectionView reloadData];
    } failure:^(XKHttpErrror *error) {
    }];
}

/**
 * 获取推荐小视频
 */
- (void)loadData {
    
    NSString *rand = [XKUserInfo getCurrentRecommendVideoRand] ? [XKUserInfo getCurrentRecommendVideoRand] : @"";
    NSString *pageString = [NSString stringWithFormat:@"%@", @(self.currentPage)];
    NSInteger limitCount = 8;
    NSMutableDictionary *params = @{@"rand": rand,
                                    @"page": pageString,
                                   @"limit": [NSString stringWithFormat:@"%@", @(limitCount)]}.mutableCopy;
    [XKZBHTTPClient postRequestWithURLString:GetRecommendVideoUrl timeoutInterval:20.0 parameters:params success:^(id responseObject) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        XKVideoDisplayModel *model =  [XKVideoDisplayModel yy_modelWithJSON:responseObject];
        NSString *rand = model.body.rand;
        [XKUserInfo currentUser].recommendVideoRand = rand;
        XKUserSynchronize;
        NSArray *videoList = model.body.video_list;
        [self.dataArr addObjectsFromArray:videoList];
        [self refreshCollectionView:videoList];
        self.currentPage++;
        
        // 区脚处理
        if (videoList.count < limitCount) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.collectionView.mj_footer resetNoMoreData];
        }
        
    } failure:^(XKHttpErrror *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

/**
 * 刷新collectionView高度
 */
- (void)refreshCollectionView:(NSArray *)currentDataArr {
    
    __weak typeof(self) weakSelf = self;
    if (self.currentPage == 0) {
        [weakSelf.picImageArr removeAllObjects];
        [weakSelf.heights removeAllObjects];
    }
    for (int i = 0; i < currentDataArr.count; i++) {
        
        // 获取首帧图
        XKVideoDisplayVideoListItemModel *model = currentDataArr[i];
        NSString *firstCoverUrlString = model.video.first_cover;
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:firstCoverUrlString] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            if (weakSelf.heights.count == self.dataArr.count) {
                return;
            }
            
            if (image) {
                if (weakSelf.picImageArr.count < self.dataArr.count) {
                    [weakSelf.picImageArr addObject:image];
                }
                
                // 未加载完全部数据
                if (weakSelf.heights.count < self.dataArr.count) {
                    
                    // 根据图片原始比例 计算 当前图片的高度(宽度固定)
                    CGFloat scale = image.size.height / image.size.width;
                    CGFloat width = weakSelf.layout.itemWidth;
                    CGFloat height = width * scale + kVideoCitywideCollectionViewCellAppendHeight;
                    
                    // 流式布局
                    height = 275;
                    NSNumber *heightNum = [NSNumber numberWithFloat:height];
                    [weakSelf.heights addObject:heightNum];
                }
                
                // 加载完全部数据
                if (weakSelf.heights.count == self.dataArr.count) {
                    // 赋值所有cell的高度数组itemHeights
                    weakSelf.layout.itemHeights = weakSelf.heights;
                    [weakSelf.collectionView reloadData];
                }
            }
        }];
    }
}

#pragma mark - setter and getter

- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

- (NSMutableArray *)picImageArr {
    
    if (!_picImageArr) {
        _picImageArr = @[].mutableCopy;
    }
    return _picImageArr;
}

- (NSMutableArray *)heights {
    
    if (!_heights) {
        _heights = [[NSMutableArray alloc] init];
    }
    return _heights;
}

// 2018.10.19版本
//#import "XKVideoAnchorRankViewController.h"
//#import "XKVideoMoneyRankViewController.h"
//#import "XKVideoHomePageCollectionViewCell.h"

// 初始化collectionView布局
//    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    flowLayout.itemSize = CGSizeMake(175, 175);
//    flowLayout.minimumLineSpacing = 5;
//    flowLayout.minimumInteritemSpacing = 5;
//    flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 10, 10);
//    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, kVideoHomePageViewControllerHeaderViewHeight);


//#pragma mark - XKVideoHomePageCollectionHeaderViewDelegate
//
//- (void)headerView:(XKVideoHomePageCollectionHeaderView *)headerView clickAnchorControl:(UIControl *)control {
//
//    XKVideoAnchorRankViewController *anchorRankViewController = [XKVideoAnchorRankViewController new];
//    [self.navigationController pushViewController:anchorRankViewController animated:YES];
//}
//
//- (void)headerView:(XKVideoHomePageCollectionHeaderView *)headerView clickMoneyControl:(UIControl *)control {
//
//    XKVideoMoneyRankViewController *moneyRankViewController = [XKVideoMoneyRankViewController new];
//    [self.navigationController pushViewController:moneyRankViewController animated:YES];
//}


//    XKVideoHomePageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKVideoHomePageCollectionViewCell" forIndexPath:indexPath];
//    [cell configCollectionViewCell:self.productionArr[indexPath.row]];

@end
