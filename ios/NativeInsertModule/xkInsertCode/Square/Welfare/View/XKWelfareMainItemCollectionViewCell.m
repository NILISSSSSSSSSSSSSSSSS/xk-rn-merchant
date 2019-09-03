//
//  XKWelfareMainItemCollectionViewCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/23.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfareMainItemCollectionViewCell.h"
#import "XKWelfareMainToolsItemCell.h"
#import "XKMallCategoryListModel.h"
#import "XKWelfareCategoryModel.h"

@interface XKWelfareMainItemCollectionViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation XKWelfareMainItemCollectionViewCell
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
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.contentView);
    }];
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
    
    XKWelfareMainToolsItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareMainToolsItemCell" forIndexPath:indexPath];
    if (indexPath.row == self.dataSourceArr.count) {
        [cell setTitle:@"全部" iconName:@"xk_btn_home_all"];
    } else {
        WelfareIconItem *item = self.dataSourceArr[indexPath.row];
        [cell setTitle:item.name iconName:item.icon];
        
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
     return  CGSizeMake((SCREEN_WIDTH - 60 * ScreenScale) / 4, (SCREEN_WIDTH - 60 * ScreenScale) / 4 * 87 / 78);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (self.choseBlock) {
        self.choseBlock(indexPath.row);
    }
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20 * ScreenScale;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumLineSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 60 * ScreenScale) / 4, SCREEN_WIDTH * 87 / 78);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH - 20, 145) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[XKWelfareMainToolsItemCell class] forCellWithReuseIdentifier:@"XKWelfareMainToolsItemCell"];
    }
    return _collectionView;
}
@end
