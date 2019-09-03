//
//  XKTradingAreaRootHeaderView.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaRootHeaderView.h"
#import "XKSqureHeaderToolCollectionViewCell.h"
#import "XKSquareBannerModel.h"
#import "XKAutoScrollView.h"
#import "XKSquareHomeToolModel.h"
#import "XKJumpWebViewController.h"
#import "XKGlobleCommonTool.h"
static NSString *const collectionViewCellID = @"headerCollectionViewCell";

@interface XKTradingAreaRootHeaderView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,XKAutoScrollViewDelegate>

@property (nonatomic, strong) XKAutoScrollView *loopView;
@property (nonatomic, strong) UIView           *toolBackView;
@property (nonatomic, strong) NSMutableArray   *bannerArray;

@end
@implementation XKTradingAreaRootHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEX_RGB(0xf6f6f6);
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    [self addSubview:self.loopView];
    [self addSubview:self.toolBackView];
    [self.toolBackView addSubview:self.collectionView];
}

- (void)reloadLayoutToolBackView {
    [self layoutIfNeeded];
    [self.toolBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((10 + 70 * (ceilf(self.dataArray.count/5.0))*ScreenScale)));
    }];
}

- (void)layoutViews {
    
    [self.loopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.equalTo(@(ScreenScale*170));
    }];
    
    [self.toolBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.loopView.mas_bottom).offset(-10);
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.height.equalTo(@(ScreenScale*150));
        
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.right.bottom.mas_equalTo(-10);
    }];
    
}

- (void)loopViewImageArray:(NSMutableArray *)bannerAarray {
    [_loopView setScrollViewItems:bannerAarray.copy];
}


#pragma mark - Setter
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}
- (XKAutoScrollView *)loopView {
    if (!_loopView) {
        XKWeakSelf(ws);
        _loopView = [[XKAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenScale * 170) delegate:self isShowPageControl:YES isAuto:YES];
        _loopView.tapBlock = ^(NSInteger type, NSString *jumpStr) {
            if (type == 1) {//h5
                XKJumpWebViewController *vc = [[XKJumpWebViewController alloc] init];
                vc.url = jumpStr;
                [[ws getCurrentUIVC].navigationController pushViewController:vc animated:YES];
            } else if (type == 2) {//app内部跳转
                [XKGlobleCommonTool bannerViewJumpAppInner:jumpStr currentViewController:[self getCurrentUIVC]];
            }
        };
    }
    return _loopView;
}


- (UIView *)toolBackView {
    if (!_toolBackView) {
        _toolBackView = [[UIView alloc] init];
        _toolBackView.backgroundColor = [UIColor whiteColor];
        [_toolBackView drawShadowPathWithShadowColor:HEX_RGB(0x000000) shadowOpacity:0.2 shadowRadius:8.0 shadowPathWidth:2.0 shadowOffset:CGSizeMake(0,1)];
    }
    return _toolBackView;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 20 - 20) / 5, 70*ScreenScale);
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        self.flowLayout = flowLayout;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XKSqureHeaderToolCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];
        
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKSqureHeaderToolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    XKSquareHomeToolModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.text = model.name;
    if (model.iconInLocation) {
        cell.imgView.image = [UIImage imageNamed:model.icon];
    }else {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.icon]placeholderImage:kDefaultPlaceHolderImg];
    }
    cell.imgView.xk_openClip = YES;
    cell.imgView.xk_clipType = XKCornerClipTypeAllCorners;
    cell.imgView.xk_radius = ((SCREEN_WIDTH - 20 - 20) / 5)/2;
    return cell;
}


#pragma mark - XKAutoScrollViewDelegate

//- (void)autoScrollView:(XKAutoScrollView *)autoScrollView didSelectItem:(XKAutoScrollImageItem *)item index:(NSInteger)index {
//    if (self.viewItemBlock) {
//        self.viewItemBlock(autoScrollView,item,index);
//    }
//}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XKSquareHomeToolModel *model = self.dataArray[indexPath.row];
    if (self.headerItemBlock) {
        self.headerItemBlock(collectionView, indexPath,model.code);
    }
}


- (void)autoScrollView:(XKAutoScrollView *)autoScrollView didScrollIndex:(NSInteger)index {
    //    NSLog(@"%d", (int)index);
}
@end
