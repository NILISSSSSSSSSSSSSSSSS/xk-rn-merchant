//
//  XKMineMainViewProductionTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineMainViewProductionTableViewCell.h"
#import "XKMineMainViewProductionCollectionViewCell.h"

@interface XKMineMainViewProductionTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XKMineMainViewProductionCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, assign) CGFloat collectionViewContentViewHeight;
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;

@end

@implementation XKMineMainViewProductionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = HEX_RGB(0xF6F6F6);
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(152 * ScreenScale, 162 * ScreenScale);
    flowLayout.minimumLineSpacing = 10 * ScreenScale;
    flowLayout.minimumInteritemSpacing = 10 * ScreenScale;
    flowLayout.estimatedItemSize = CGSizeZero;
    flowLayout.headerReferenceSize = CGSizeZero;
    flowLayout.footerReferenceSize = CGSizeZero;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.bounces = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[XKMineMainViewProductionCollectionViewCell class] forCellWithReuseIdentifier:@"XKMineMainViewProductionCollectionViewCell"];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    // 空白视图
    XMEmptyViewConfig *emptyViewConfig = [XMEmptyViewConfig new];
    emptyViewConfig.backgroundColor = [UIColor whiteColor];
    emptyViewConfig.verticalOffset = 0;
    emptyViewConfig.descriptionFont = XKRegularFont(14);
    self.emptyView = [XKEmptyPlaceView configScrollView:self.collectionView config:emptyViewConfig];
    
    return self;
}

- (void)configCellWithProductionListArray:(NSArray *)productionArr collectionViewHeight:(CGFloat)collectionViewHeight {
    
    self.dataArr = productionArr;
    if (self.dataArr.count == 0) {
        self.emptyView.config.viewAllowTap = NO;
        [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无作品" tapClick:nil];
    } else {
        [self.emptyView hide];
    }
    
    self.collectionViewContentViewHeight = collectionViewHeight - 6;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKMineMainViewProductionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKMineMainViewProductionCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell configCellWithVideoListItem:self.dataArr[indexPath.row]];
    
    CGFloat tempCollectionViewHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    if (self.collectionViewContentViewHeight != tempCollectionViewHeight) {
        
        // 刷新collectionView高度
        self.collectionViewContentViewHeight = tempCollectionViewHeight;
        [self.delegate productionTableViewCellReloadCollectionViewHeight:tempCollectionViewHeight + 6];
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"\n1...scrollView.size:%@\n2...scrollView.contentSize:%@\n3...self.contentView.size:%@\n4...scrollView.contentOffset:%@",
          NSStringFromCGSize(scrollView.size),
          NSStringFromCGSize(scrollView.contentSize),
          NSStringFromCGSize(self.contentView.size),
          NSStringFromCGPoint(scrollView.contentOffset))
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

// 点击作品回到
- (void)productionCollectionViewCell:(UICollectionViewCell *)cell clickProductionWithModel:(XKVideoDisplayVideoListItemModel *)model {
    [self.delegate productionTableViewCell:self clickProductionWithModel:model];
}

@end
