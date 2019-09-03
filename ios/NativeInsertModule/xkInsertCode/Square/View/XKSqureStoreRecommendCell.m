//
//  XKSqureStoreRecommendCell.m
//  XKSquare
//
//  Created by hupan on 2018/8/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureStoreRecommendCell.h"
#import "XKSqureStoreCollectionViewCell.h"
#import "XKSquareGoodsRecommendModel.h"

#define itemWidth  (int)((SCREEN_WIDTH - 20) / 3)
#define itemHeight (int)(115*ScreenScale)
static NSString *const collectionViewCellID = @"storeCollectionViewCell";

@interface XKSqureStoreRecommendCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView       *collectionView;
@property (nonatomic, copy  ) NSArray                *dataArr;



@end


@implementation XKSqureStoreRecommendCell


- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private


- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}


- (void)initViews {
    
//    [self addShadowLayerBelowView:self.contentView subLayerFrame:CGRectMake(11, 0, SCREEN_WIDTH - 22, 40) cornerRadius:5 shadowColor:[UIColor blackColor] shadowRadius:1 shadowOpacity:0.2 shadowOffset:CGSizeMake(0,1)];
    [self.contentView addSubview:self.collectionView];
}



- (void)layoutViews {
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(itemHeight));
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - Setter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.minimumLineSpacing = 0.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XKSqureStoreCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];

    }
    return _collectionView;
}

- (void)setValueWithArr:(NSArray *)recommendModelArr {
    self.dataArr = recommendModelArr;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKSqureStoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    if (indexPath.row == self.dataArr.count - 1) {
        [cell hiddenLineView:YES];
    } else {
        [cell hiddenLineView:NO];
    }
    GoodsItem *item = self.dataArr[indexPath.row];
    [cell setName:item.name dec:item.skuName imgUrl:item.pic];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsItem *item = self.dataArr[indexPath.row];
    if (self.storeRecommendItemBlock) {
        self.storeRecommendItemBlock(collectionView, indexPath, @{@"id":item.goodsId});
    }
}

@end
