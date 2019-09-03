//
//  XKHistoryGamesTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKHistoryGamesTableViewCell.h"
#import "XKHistoryGamesCollectionViewCell.h"

static NSString *const collectionViewCellID = @"historyGamesCollectionViewCell";

@interface XKHistoryGamesTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView       *collectionView;
@property (nonatomic, copy  ) NSArray                *dataArr;
@property (nonatomic, strong) UIView                 *lineView;

@end


@implementation XKHistoryGamesTableViewCell


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
        make.height.equalTo(@(130*ScreenScale));
        make.edges.equalTo(self.contentView);
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

#pragma mark - Setter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 20) / 3, 130*ScreenScale);
        flowLayout.minimumLineSpacing = 0.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XKHistoryGamesCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];
        
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


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return _dataArr.count;
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKHistoryGamesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    if (indexPath.row == 3) {
        [cell hiddenLineView:YES];
    } else {
        [cell hiddenLineView:NO];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.historyGamesItemBlock) {
        self.historyGamesItemBlock(collectionView, indexPath, nil);
    }
}

@end




