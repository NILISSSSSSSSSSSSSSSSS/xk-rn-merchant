//
//  XKMyProductionPreviewViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMyProductionPreviewViewController.h"
#import "XKVideoDisplayModel.h"
#import "XKMyProductionPreviewModel.h"
#import "XKMyProductionPreviewCollectionViewCell.h"
#import "UIView+XKCornerBorder.h"

@interface XKMyProductionPreviewViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *previewCollevtionView;

@property (nonatomic, strong) UICollectionView *imgCollectionView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *finishBtn;

@property (nonatomic, strong) NSMutableArray *previews;

@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation XKMyProductionPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeViews];
    [self updateViews];
}

- (void)initializeViews {
    [self.containView addSubview:self.previewCollevtionView];
    [self.containView addSubview:self.imgCollectionView];
    [self.containView addSubview:self.bottomView];
    [self.bottomView addSubview:self.finishBtn];
}

- (void)updateViews {
    [self.previewCollevtionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.containView);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    [self.imgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_equalTo(self.previewCollevtionView);
        make.height.mas_equalTo(100.0);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kBottomSafeHeight);
        make.leading.trailing.mas_equalTo(self.containView);
        make.height.mas_equalTo(50.0);
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(105.0);
    }];
}

- (void)previewWithPreviews:(NSArray<XKMyProductionPreviewModel *> *)previews {
    self.currentIndex = 0;
    [self.previews removeAllObjects];
    [self.previews addObjectsFromArray:previews];
    self.previewCollevtionView.contentOffset = CGPointZero;
    self.imgCollectionView.contentOffset = CGPointZero;
    [self.previewCollevtionView reloadData];
    [self.imgCollectionView reloadData];
    [self.finishBtn setTitle:[NSString stringWithFormat:@"%@(%tu)", self.finishBtnTitle, self.previews.count] forState:UIControlStateNormal];
}

- (void)finishBtnAction:(UIButton *)sender {
    if (self.finishBtnBlock) {
        self.finishBtnBlock(self.previews);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.previewCollevtionView) {
        // 滑动时，停止播放的CELL
        for (UICollectionView *cell in self.previewCollevtionView.visibleCells) {
            XKMyProductionPreviewCollectionViewCell *theCell = (XKMyProductionPreviewCollectionViewCell *)cell;
            [theCell pause];
        }
        if (self.previewCollevtionView.contentOffset.x >= 0 && self.previewCollevtionView.contentOffset.x <= self.previewCollevtionView.contentSize.width - CGRectGetWidth(self.previewCollevtionView.frame)) {
            // 处理正常范围内的滑动事件
            NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                                              scale:0
                                                                                                   raiseOnExactness:NO
                                                                                                    raiseOnOverflow:NO
                                                                                                   raiseOnUnderflow:NO
                                                                                                raiseOnDivideByZero:NO];
            NSDecimalNumber *number = [[NSDecimalNumber alloc] initWithDouble:self.previewCollevtionView.contentOffset.x / CGRectGetWidth(self.previewCollevtionView.frame)];
            NSUInteger index = [number decimalNumberByRoundingAccordingToBehavior:roundingBehavior].unsignedIntegerValue;
            self.currentIndex = index;
            [self.imgCollectionView reloadData];
            UICollectionViewCell *cell = [self collectionView:self.imgCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [UIView animateWithDuration:0.33 animations:^{
                if (cell.centerX <= CGRectGetWidth(self.imgCollectionView.frame) / 2.0) {
                    self.imgCollectionView.contentOffset = CGPointZero;
                } else if (self.imgCollectionView.contentSize.width - cell.centerX <= CGRectGetWidth(self.imgCollectionView.frame) / 2.0) {
                    self.imgCollectionView.contentOffset = CGPointMake(self.imgCollectionView.contentSize.width - CGRectGetWidth(self.imgCollectionView.frame), 0.0);
                } else {
                    [self.imgCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                }
            }];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.previews.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKMyProductionPreviewModel *preview = self.previews[indexPath.row];
    if (collectionView == self.previewCollevtionView) {
        XKMyProductionPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XKMyProductionPreviewCollectionViewCell class]) forIndexPath:indexPath];
        [cell configCellWithPreviewModel:preview];
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        for (UIView *temp in cell.contentView.subviews) {
            [temp removeFromSuperview];
        }
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imgView];
        if (preview.imgUrl && preview.imgUrl.length) {
            [imgView sd_setImageWithURL:[NSURL URLWithString:preview.imgUrl]];
        } else {
            imgView.image = kDefaultPlaceHolderImg;
        }
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cell.contentView);
        }];
        imgView.clipsToBounds = YES;
        imgView.layer.cornerRadius = 4.0;
        imgView.layer.masksToBounds = YES;
        imgView.layer.borderWidth = 2.0;
        imgView.layer.borderColor = indexPath.row == self.currentIndex ? XKMainTypeColor.CGColor : [UIColor clearColor].CGColor;
        UIView *maskView = [[UIView alloc] init];
        maskView.backgroundColor = indexPath.row == self.currentIndex ? [UIColor clearColor] : HEX_RGBA(0x000000, 0.35);
        [imgView addSubview:maskView];
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (indexPath.row == self.currentIndex) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(imgView.layer.borderWidth = 2.0, imgView.layer.borderWidth = 2.0, imgView.layer.borderWidth = 2.0, imgView.layer.borderWidth = 2.0));
            } else {
                make.edges.mas_equalTo(cell.contentView);
            }
        }];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (collectionView == self.previewCollevtionView) {
        XKMyProductionPreviewCollectionViewCell *cell = (XKMyProductionPreviewCollectionViewCell *)self.previewCollevtionView.visibleCells.firstObject;
        XKMyProductionPreviewModel *preview = self.previews[indexPath.row];
        preview.playFinishedBlock = ^{
            [cell pause];
        };
        if (preview.isPlaying) {
            [cell pause];
            preview.isPlaying = NO;
        } else {
            [cell play];
            preview.isPlaying = YES;
        }
    }
    if (collectionView == self.imgCollectionView) {
        if (indexPath.row == self.currentIndex) {
            return;
        }
        self.currentIndex = indexPath.row;
        [self.imgCollectionView reloadData];
        UICollectionViewCell *cell = [self collectionView:self.imgCollectionView cellForItemAtIndexPath:indexPath];
        [UIView animateWithDuration:0.33 animations:^{
            if (cell.centerX <= CGRectGetWidth(self.imgCollectionView.frame) / 2.0) {
                self.imgCollectionView.contentOffset = CGPointZero;
            } else if (self.imgCollectionView.contentSize.width - cell.centerX <= CGRectGetWidth(self.imgCollectionView.frame) / 2.0) {
                self.imgCollectionView.contentOffset = CGPointMake(self.imgCollectionView.contentSize.width - CGRectGetWidth(self.imgCollectionView.frame), 0.0);
            } else {
                [self.imgCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
        }];
        self.previewCollevtionView.contentOffset = CGPointMake(CGRectGetWidth(self.previewCollevtionView.frame) * indexPath.row, 0.0);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.previewCollevtionView) {
        return self.previewCollevtionView.bounds.size;
    } else {
        return CGSizeMake(80.0, 80.0);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.previewCollevtionView) {
        return UIEdgeInsetsZero;
    } else {
        return UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
    }
}

#pragma mark - getter setter

- (UICollectionView *)previewCollevtionView {
    if (!_previewCollevtionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        _previewCollevtionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _previewCollevtionView.dataSource = self;
        _previewCollevtionView.delegate = self;
        _previewCollevtionView.pagingEnabled = YES;
        _previewCollevtionView.showsHorizontalScrollIndicator = NO;
        [_previewCollevtionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [_previewCollevtionView registerClass:[XKMyProductionPreviewCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([XKMyProductionPreviewCollectionViewCell class])];
        _previewCollevtionView.backgroundColor = HEX_RGB(0x222222);
    }
    return _previewCollevtionView;
}

- (UICollectionView *)imgCollectionView {
    if (!_imgCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = 10.0;
        _imgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _imgCollectionView.dataSource = self;
        _imgCollectionView.delegate = self;
        _imgCollectionView.showsHorizontalScrollIndicator = NO;
        [_imgCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        _imgCollectionView.backgroundColor = HEX_RGBA(000000, 0.5);
//        _imgCollectionView.xk_radius = 8.0;
//        _imgCollectionView.xk_clipType = XKCornerClipTypeTopBoth;
//        _imgCollectionView.xk_openClip = YES;
    }
    return _imgCollectionView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.titleLabel.font = XKRegularFont(17.0);
        [_finishBtn setTitle:self.finishBtnTitle forState:UIControlStateNormal];
        [_finishBtn setTitleColor:HEX_RGB(0xffffff) forState:UIControlStateNormal];
        _finishBtn.backgroundColor = XKMainTypeColor;
        [_finishBtn addTarget:self action:@selector(finishBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (NSString *)finishBtnTitle {
    if (_finishBtnTitle && _finishBtnTitle.length) {
        return _finishBtnTitle;
    }
    return @"完成";
}

- (NSMutableArray *)previews {
    if (!_previews) {
        _previews = [NSMutableArray array];
    }
    return _previews;
}

@end
