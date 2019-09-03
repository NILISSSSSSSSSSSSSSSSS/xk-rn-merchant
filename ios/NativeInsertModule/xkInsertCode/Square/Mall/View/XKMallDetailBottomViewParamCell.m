//
//  XKMallDetailBottomViewParamCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallDetailBottomViewParamCell.h"
#import "XKParmItemCell.h"
@interface XKMallDetailBottomViewParamCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)XKMallGoodsDetailAttrListItem  *item;
@end

@implementation XKMallDetailBottomViewParamCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.lineView];
    
}

- (void)updateDataWithAttr:(XKMallGoodsDetailAttrListItem *)item {
    _item = item;
    _nameLabel.text = _item.name;
    [self.collectionView reloadData];
}

- (void)addUIConstraint {
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(20);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark -  UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _item.attrValues.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKParmItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKParmItemCell" forIndexPath:indexPath];
    XKMallGoodsDetailAttrValuesItem *item = _item.attrValues[indexPath.row];
    [cell setUpDataWithItem:item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    XKMallGoodsDetailAttrValuesItem *choseItem = _item.attrValues[indexPath.row];
    BOOL selected = choseItem.selected;                          //拿到当前的选中状态
    for(NSInteger i = 0; i < _item.attrValues.count; i++) {//遍历
        XKMallGoodsDetailAttrValuesItem *item = _item.attrValues[i]; //遍历模型
        if(selected) {//之前是选中  点击后全部不选中
            item.selected = NO;
        } else {
            if(indexPath.row == i) {//之前不是选中 则选择这个  其他的不选中
                item.selected = YES;
            } else {
                item.selected = NO;
            }
        }
    }
    [self.collectionView reloadData];
    if(self.choseIndexBlock) {
        self.choseIndexBlock(indexPath.row);
 //       [[NSNotificationCenter defaultCenter] postNotificationName:XKToolsBottomSheetViewDismissNotification object:nil];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 26);
}

#pragma mark - setter && getter

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 20)];
        _nameLabel.textColor = HEX_RGB(0x777777);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
    }
    return _nameLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 15, 10);
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40,SCREEN_WIDTH,60) collectionViewLayout:flowlayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XKParmItemCell class] forCellWithReuseIdentifier:@"XKParmItemCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    }
    return _collectionView;
}

- (UIView *)lineView {
    if(!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}



@end
