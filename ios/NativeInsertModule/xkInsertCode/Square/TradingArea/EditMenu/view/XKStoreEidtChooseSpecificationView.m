//
//  XKStoreEidtChooseSpecificationView.m
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreEidtChooseSpecificationView.h"
#import "XKStoreGuigeChooseCollectionViewCell.h"
#import "XKMallTypeCollectionReusableView.h"
#import "XKTradingAreaGoodsInfoModel.h"

#define itemWidth  70
#define itemHeight 26
#define headerHeight 34

static NSString * const collectionViewCellID          = @"storeCollectionViewCell";
static NSString * const collectionViewReusableViewID  = @"collectionViewReusableViewID";

@interface XKStoreEidtChooseSpecificationView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel          *nameLabel;
@property (nonatomic, strong) UIButton         *closeBtn;
//@property (nonatomic, strong) UILabel          *guigeLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView           *chooseView;
@property (nonatomic, strong) XKHotspotButton  *addBtn;
@property (nonatomic, strong) UILabel          *numLabel;
@property (nonatomic, strong) XKHotspotButton  *reduceBtn;
@property (nonatomic, strong) UIView           *bottomView;
@property (nonatomic, strong) UILabel          *priceLabel;
@property (nonatomic, strong) UIButton         *addCarButton;

@property (nonatomic, assign) NSInteger        selectedIndex;
@property (nonatomic, strong) NSMutableArray   *subIndexMuArr;

@property (nonatomic, strong) XKTradingAreaGoodsInfoModel *model;

@end

@implementation XKStoreEidtChooseSpecificationView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
        [self layoutViews];
    }
    return self;
    
}

#pragma mark - Private

- (void)initViews {
    
    self.selectedIndex = -1;
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.closeBtn];
    
//    [self addSubview:self.guigeLabel];
    [self addSubview:self.collectionView];
    [self addSubview:self.chooseView];
    [self.chooseView addSubview:self.addBtn];
    [self.chooseView addSubview:self.numLabel];
    [self.chooseView addSubview:self.reduceBtn];
    
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.priceLabel];
    [self.bottomView addSubview:self.addCarButton];
    
}

- (void)layoutViews {
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.centerX.equalTo(self);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.nameLabel);
        make.width.height.equalTo(@20);
    }];
    
//    [self.guigeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(15);
//        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
//    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.equalTo(@(headerHeight+itemHeight));
    }];
    
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@70);
        make.height.equalTo(@20);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.collectionView.mas_bottom).offset(15);
    }];
    
    [self.reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chooseView);
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.chooseView);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reduceBtn.mas_right);
        make.right.equalTo(self.addBtn.mas_left);
        make.centerY.equalTo(self.chooseView);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chooseView);
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.chooseView);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@46);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(10);
        make.centerY.equalTo(self.bottomView);
    }];
    
    [self.addCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).offset(-10);
        make.centerY.equalTo(self.bottomView);
    }];
}


#pragma mark - Events

- (void)closeBtnClicked:(UIButton *)sender {
    
    if (self.closeBtn) {
        self.closeBlock();
    }
}


- (void)addBtnClicekd:(UIButton *)sender {
    self.numLabel.text = [NSString stringWithFormat:@"%d", self.numLabel.text.intValue + 1];
    if (self.numLabel.text.intValue >= 99) {
        self.numLabel.text = @"99";
    }
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.model.goods.discountPrice.floatValue * self.numLabel.text.integerValue];
}


- (void)reduceBtnClicked:(UIButton *)sender {
    
    if (self.numLabel.text.intValue <= 2) {
        self.numLabel.text = @"1";
    } else {
        self.numLabel.text = [NSString stringWithFormat:@"%d", self.numLabel.text.intValue - 1];
    }
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.model.goods.discountPrice.floatValue * self.numLabel.text.integerValue];
}


- (void)addCarBtnClicked:(UIButton *)sender {
    if (self.selectedIndex < 0) {
        [XKHUD showErrorWithText:@"请选择规格！"];
        return;
    }
    NSMutableArray *muarr = [NSMutableArray array];
    GoodsSkuVOListItem *item = self.model.goodsSkuVOList[self.selectedIndex];
    for (int i = 0; i < self.numLabel.text.intValue; i++) {
        [muarr addObject:item];
    }
   
    if (self.addCarBlock) {
        self.addCarBlock(muarr.copy);
    }
}



#pragma mark - getter && setter


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
//        _nameLabel.text = @"鲜毛肚";
        _nameLabel.textColor = HEX_RGB(0x030303);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    }
    return _nameLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"xk_btn_TradingArea_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

/*
- (UILabel *)guigeLabel {
    if (!_guigeLabel) {
        _guigeLabel = [[UILabel alloc] init];
        _guigeLabel.text = @"规格";
        _guigeLabel.textColor = HEX_RGB(0x777777);
        _guigeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _guigeLabel;
}*/

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//        flowLayout.estimatedItemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.headerReferenceSize = CGSizeMake(self.width-30, headerHeight);
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XKStoreGuigeChooseCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];
        [_collectionView registerClass:[XKMallTypeCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewReusableViewID];
        
    }
    return _collectionView;
}

- (UIView *)chooseView {
    if (!_chooseView) {
        _chooseView = [[UIView alloc] init];
        _chooseView.backgroundColor = [UIColor whiteColor];
    }
    return _chooseView;
}

- (XKHotspotButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[XKHotspotButton alloc] init];
        [_addBtn setImage:[UIImage imageNamed:@"xk_btn_TradingArea_add"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnClicekd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}


- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.text = @"1";
        _numLabel.textColor = HEX_RGB(0x222222);
        _numLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _numLabel;
}

- (XKHotspotButton *)reduceBtn {
    if (!_reduceBtn) {
        _reduceBtn = [[XKHotspotButton alloc] init];
        [_reduceBtn setImage:[UIImage imageNamed:@"xk_btn_TradingArea_reduce"] forState:UIControlStateNormal];
        [_reduceBtn addTarget:self action:@selector(reduceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceBtn;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = HEX_RGB(0xe5e5e5);
    }
    return _bottomView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
//        _priceLabel.text = @"￥33";
        _priceLabel.textColor = HEX_RGB(0xEE6161);
        _priceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:18];
    }
    return _priceLabel;
}

- (UIButton *)addCarButton {
    if (!_addCarButton) {
        _addCarButton = [[UIButton alloc] init];
        [_addCarButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        _addCarButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        [_addCarButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        [_addCarButton addTarget:self action:@selector(addCarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addCarButton;
}

- (NSMutableArray *)subIndexMuArr {
    if (!_subIndexMuArr) {
        _subIndexMuArr = [NSMutableArray array];
    }
    return _subIndexMuArr;
}


- (void)setValueWithModel:(XKTradingAreaGoodsInfoModel *)model {
    
    self.model = model;
    self.numLabel.text = @"1";
    self.nameLabel.text = model.goods.goodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.goods.discountPrice.floatValue / 100.0];
    
    
    [self.subIndexMuArr removeAllObjects];
    for (int i = 0; i < self.model.goodsSkuAttrsVO.attrList.count; i++) {
        [self.subIndexMuArr addObject:@(-1)];
    }
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.subIndexMuArr.count * (headerHeight + itemHeight)));
    }];
    self.collectionView.contentSize = CGSizeMake(0, 0);
    self.selectedIndex = -1;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.model.goodsSkuAttrsVO.attrList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    GoodsAttrListItem *item = self.model.goodsSkuAttrsVO.attrList[section];
    return item.attrValues.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKStoreGuigeChooseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    
    [cell itemSeleced:[self.subIndexMuArr[indexPath.section] integerValue] == indexPath.row ? YES : NO];
    
    GoodsAttrListItem *item = self.model.goodsSkuAttrsVO.attrList[indexPath.section];
    GoodsAttrValuesItem *value = item.attrValues[indexPath.row];
    [cell setTitleName:value.name];
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    XKMallTypeCollectionReusableView *reusableView;
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewReusableViewID forIndexPath:indexPath];
        GoodsAttrListItem *item = self.model.goodsSkuAttrsVO.attrList[indexPath.section];
        [reusableView setTitleWithTitleStr:item.name titleColor:HEX_RGB(0x777777) font:XKRegularFont(14)];
        [reusableView titleTextAlignmentLeft:5];
    }
    return reusableView;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //过滤重复选择
    if ([self.subIndexMuArr[indexPath.section] integerValue] == indexPath.row) {
        return;
    }
    //赋值
    [self.subIndexMuArr replaceObjectAtIndex:indexPath.section withObject:@(indexPath.row)];
    [self.collectionView reloadData];
    
    //遍历看是否选完  并且拼凑code
    NSString *skuCode;
    NSMutableArray *codeMuArr = [NSMutableArray array];
    for (int i = 0; i < self.subIndexMuArr.count; i++) {
        NSNumber *number = self.subIndexMuArr[i];
        //规格没选完时
        if (number.integerValue < 0) {
            return;
        }
        GoodsAttrListItem *item = self.model.goodsSkuAttrsVO.attrList[i];
        GoodsAttrValuesItem *value = item.attrValues[number.integerValue];
        [codeMuArr addObject:value.code];
    }
    skuCode = [codeMuArr componentsJoinedByString:@"|"];
    
    for (GoodsSkuVOListItem *listItem in self.model.goodsSkuVOList) {
        if ([listItem.skuCode isEqualToString:skuCode]) {
            
            self.selectedIndex = [self.model.goodsSkuVOList indexOfObject:listItem];
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", listItem.discountPrice.floatValue * self.numLabel.text.intValue / 100.0];

            [self.collectionView reloadData];
            return;
        }
    }
    [XKHudView showWarnMessage:@"暂无该规格商品，请重新选取"];
}


@end
