//
//  XKMainItemCollectionViewCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallMainItemCollectionViewCell.h"
#import "XKSqureHeaderToolCollectionViewCell.h"
#import "XKMallCategoryListModel.h"
#import "XKWelfareCategoryModel.h"
@interface XKMallMainItemCollectionViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;


@end

@implementation XKMallMainItemCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addCustomSubviews];
        [self addUIConstraint];
        self.xk_openClip = YES;
        self.xk_radius = 8;
        self.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.collectionView];

}

- (void)setDataSourceArr:(NSArray *)dataSourceArr {
    if (dataSourceArr.count > 0) {
        _dataSourceArr = dataSourceArr;
        [self.collectionView reloadData];
    }
}

- (void)addUIConstraint {

}

- (void)setType:(NSInteger)type {
    _type = type;
    if (_type == 1) {
        _collectionView.frame = CGRectMake(0, 15, SCREEN_WIDTH, 145);
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSourceArr.count < 1) {
        return 0;
    }
    return self.dataSourceArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKSqureHeaderToolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKSqureHeaderToolCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row == self.dataSourceArr.count) {
        [cell setTitle:@"更多" iconName:@"xk_btn_mall_mainmore"];
    } else {
        if (self.type == 1) {
            WelfareIconItem *item = self.dataSourceArr[indexPath.row];
            [cell setTitle:item.name iconUrl:item.icon];
        } else if (self.type == 0) {
            MallIconItem *item = self.dataSourceArr[indexPath.row];
            [cell setTitle:item.name iconUrl:item.icon];
        }

    }
    cell.clipsToBounds = YES;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.type == 1) {
        return  CGSizeMake((SCREEN_WIDTH ) / 4, 70*ScreenScale);
    } else {
        return  CGSizeMake(floorf((SCREEN_WIDTH - 20) / 5.f), 70*ScreenScale);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (self.choseBlock) {
        self.choseBlock(indexPath.row);
    }
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return section == 0 ? UIEdgeInsetsMake(10*ScreenScale, 0, 5*ScreenScale, 0) : UIEdgeInsetsMake(5*ScreenScale, 0, 10*ScreenScale, 0);
}
#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumLineSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        layout.itemSize = CGSizeMake(floorf((SCREEN_WIDTH - 20) / 5.f), 70*ScreenScale);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 160*ScreenScale) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[XKSqureHeaderToolCollectionViewCell class] forCellWithReuseIdentifier:@"XKSqureHeaderToolCollectionViewCell"];
        
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
        }];
        [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
        self.collectionView.mj_footer = foot;
    }
    return _collectionView;
}
@end
