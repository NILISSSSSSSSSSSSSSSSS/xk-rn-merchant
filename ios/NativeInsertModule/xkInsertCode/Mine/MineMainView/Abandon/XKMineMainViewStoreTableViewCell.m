//
//  XKMineMainViewStoreTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineMainViewStoreTableViewCell.h"
#import "XKMineMainViewStoreCollectionViewCell.h"

@interface XKMineMainViewStoreTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *merchArr;
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation XKMineMainViewStoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = HEX_RGB(0xF6F6F6);
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(90, 120);
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[XKMineMainViewStoreCollectionViewCell class] forCellWithReuseIdentifier:@"XKMineMainViewStoreCollectionViewCell"];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView registerClass:[XKMineMainViewStoreCollectionViewCell class] forCellWithReuseIdentifier:@"XKMineMainViewStoreCollectionViewCell"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    self.isLoaded = NO;
    
    // 下拉刷新 & 上拉加载
//    self.collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.currentPage = 1;
//        [self getRecipientList];
//    }];
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.currentPage++;
//        [self getRecipientList];
//    }];
//    [footer setTitle:@"右滑加载更多数据" forState:MJRefreshStateIdle];
//    [footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
//    self.collectionView.mj_footer = footer;
    
    self.currentPage = 1;
    
    return self;
}

- (void)configCellWithMerchListArray:(NSArray *)merchArr {
    
    self.merchArr = merchArr;
    [self.collectionView reloadData];
    self.isLoaded = NO;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.merchArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKMineMainViewStoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKMineMainViewStoreCollectionViewCell" forIndexPath:indexPath];
    [cell configCellWithWelfareGoodsListViewModel:self.merchArr[indexPath.row]];
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

#pragma mark - UIScrollViewDelegate

/** 右滑加载 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.isLoaded) {
        return;
    }
    
    if (self.merchArr.count < self.currentPage * 10) {
        return;
    }
    
    CGFloat width = scrollView.frame.size.width;
    CGFloat contentXoffset = scrollView.contentOffset.x;
    CGFloat distance = scrollView.contentSize.width - width;
//    NSLog(@"----------\nwidth:%@\ncontentXoffset:%@\ndistance:%@",@(width),@(contentXoffset),@(distance));
    if (distance - contentXoffset <= 0) {
        self.isLoaded = YES;
        self.currentPage++;
        [self.delegate storeCell:self loadMerchListWithPage:self.currentPage];
    }
//    
//    if (contentXoffset == 0) {
//        self.isLoaded = YES;
//        self.currentPage = 0;
//        [self.delegate storeCell:self loadMerchListWithPage:self.currentPage];
//    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate storeCell:self didSelectItemAtIndexPath:indexPath];
}

@end
