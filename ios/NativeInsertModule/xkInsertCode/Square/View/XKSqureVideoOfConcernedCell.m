//
//  XKSqureVideoOfConcernedCell.m
//  XKSquare
//
//  Created by hupan on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureVideoOfConcernedCell.h"
#import "XKSqureVideoOfConcernedCollectionCell.h"
#import "XKVideoDisplayModel.h"

#define itemWidth  (int)((SCREEN_WIDTH - 20) / 2)
#define itemHeight itemWidth

static NSString *const collectionViewCellID = @"CollectionViewCell";

@interface XKSqureVideoOfConcernedCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView       *collectionView;
@property (nonatomic, strong) UIView                 *lineView;
@property (nonatomic, copy  ) NSArray                *dataArr;

@end


@implementation XKSqureVideoOfConcernedCell


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
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.lineView];
}



- (void)layoutViews {
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(itemHeight*2+5));
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

#pragma mark - Setter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.minimumLineSpacing = 5.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XKSqureVideoOfConcernedCollectionCell class] forCellWithReuseIdentifier:collectionViewCellID];

    }
    return _collectionView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}

- (void)setValueWithArr:(NSArray *)recommendModelArr {
    self.dataArr = recommendModelArr;
    if (self.dataArr.count <= 2) {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(itemHeight+5));
        }];
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKSqureVideoOfConcernedCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    
    XKVideoDisplayVideoListItemModel *model = self.dataArr[indexPath.row];
    [cell setValueWithName:model.user.user_name address:model.adds.city imgUrl:model.video.first_cover];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XKVideoDisplayVideoListItemModel *model = self.dataArr[indexPath.row];

    if (self.videoItemBlock) {
        self.videoItemBlock(collectionView, indexPath, @{@"videoModel":model});
    }
}

@end
