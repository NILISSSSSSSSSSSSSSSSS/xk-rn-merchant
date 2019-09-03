//
//  XKStoreReserveChooseSpecificationView.m
//  XKSquare
//
//  Created by hupan on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreReserveChooseSpecificationView.h"
#import "XKStoreGuigeChooseCollectionViewCell.h"
#import "XKTradingAreaGoodsInfoModel.h"
#import "XKServiceBookTimeChooseView.h"
#import "XKMallTypeCollectionReusableView.h"
#import "XKCommonSheetView.h"


#define itemWidth  66
#define itemHeight 26
#define headerHeight 34

static NSString * const collectionViewCellID          = @"storeCollectionViewCell";
static NSString * const collectionViewReusableViewID  = @"collectionViewReusableViewID";

@interface XKStoreReserveChooseSpecificationView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UIImageView      *imgView;
@property (nonatomic, strong) UILabel          *nameLabel;
@property (nonatomic, strong) UILabel          *priceLabel;
@property (nonatomic, strong) UIButton         *closeBtn;
@property (nonatomic, strong) UIView           *lineView0;


@property (nonatomic, strong) UILabel          *guigeLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView           *lineView1;
@property (nonatomic, strong) UILabel          *timeNameLabel;
@property (nonatomic, strong) UIButton         *timebtn;
@property (nonatomic, strong) XKHotspotButton  *chooseTimeBtn;

@property (nonatomic, strong) UIView           *lineView2;
@property (nonatomic, strong) UIButton         *nextBtn;

@property (nonatomic, strong) UIView           *bottomSafeView;
@property (nonatomic, strong) UIView           *bottomSafeLineView;


@property (nonatomic, strong) XKCommonSheetView            *chooseTimeSheetView;
@property (nonatomic, strong) XKServiceBookTimeChooseView  *timeChooseView;

@property (nonatomic, assign) NSInteger        selectedIndex;
@property (nonatomic, strong) NSMutableArray   *subIndexMuArr;
@property (nonatomic, assign) NSString         *selectedGuigeText;

@property (nonatomic, strong) XKTradingAreaGoodsInfoModel *model;
@property (nonatomic, copy  ) NSString                    *serviceTime;
@property (nonatomic, assign) SpecificationViewType       viewType;



@end

@implementation XKStoreReserveChooseSpecificationView


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
    
    
    [self addSubview:self.imgView];
    [self addSubview:self.priceLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.closeBtn];
    [self addSubview:self.lineView0];
    
    /*[self addSubview:self.guigeLabel];*/
    [self addSubview:self.collectionView];
    [self addSubview:self.lineView1];
    
    [self addSubview:self.timeNameLabel];
    [self addSubview:self.timebtn];
    [self addSubview:self.chooseTimeBtn];

    [self addSubview:self.lineView2];
    [self addSubview:self.nextBtn];
    
    [self addSubview:self.bottomSafeView];
    [self.bottomSafeView addSubview:self.bottomSafeLineView];
    
}

- (void)layoutViews {
    
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(15);
        make.width.height.equalTo(@80);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.right.equalTo(self).offset(-50);
    }];
    
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.nameLabel);
        make.width.height.equalTo(@20);
    }];
    
    [self.lineView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.top.equalTo(self.imgView.mas_bottom).offset(15);
        make.left.equalTo(self.imgView.mas_left);
        make.right.equalTo(self).offset(-15);
    }];
    
//    [self.guigeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(15);
//        make.top.equalTo(self.lineView0.mas_bottom).offset(10);
//    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_left);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@(headerHeight+itemHeight));
        make.top.equalTo(self.lineView0.mas_bottom).offset(5);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(15);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@1);

    }];
    
    [self.timeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1.mas_bottom);
        make.left.equalTo(self).offset(15);
        make.width.equalTo(@60);
        make.height.equalTo(@43);
    }];
    
    [self.timebtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.equalTo(self.chooseTimeBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.timeNameLabel);
    }];
    
    [self.chooseTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.width.equalTo(@7);
        make.height.equalTo(@10);
        make.centerY.equalTo(self.timeNameLabel);
    }];
    
    
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeNameLabel.mas_bottom);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@1);
        
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lineView2.mas_bottom).offset(15);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@44);
    }];
    
    [self.bottomSafeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@kBottomSafeHeight);
    }];
    
    [self.bottomSafeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.bottomSafeView);
        make.height.equalTo(@(kBottomSafeHeight ? 1 : 0));
    }];

}




#pragma mark - Events

- (void)closeBtnClicked:(UIButton *)sender {
    
    if (self.closeBtn) {
        self.closeBlock();
    }
}

- (void)nextBtnClicked:(UIButton *)sender {
    
    if (self.selectedIndex < 0) {
        [XKHUD showErrorWithText:@"请选择规格！"];
        return;
    } else if ([self.timebtn.titleLabel.text isEqualToString:@"点击选择"]) {
        if (self.viewType == viewType_service) {
            [XKHUD showErrorWithText:@"请选择时间！"];
            return;
        }
    }
    
    //处理
    GoodsSkuVOListItem *item = self.model.goodsSkuVOList[self.selectedIndex];
    if (self.nextBlock) {
        self.nextBlock(item, self.serviceTime, self.viewType);
    }
}


- (void)chooseTimeButtonClicked:(UIButton *)sender {
    
    [self.chooseTimeSheetView showWithNoShield];
}


- (void)timeChoosedWithYMDHMSStr:(NSString *)ymdhmsStr {
    [self.chooseTimeSheetView dismiss];
    self.serviceTime = ymdhmsStr;

    NSString *serviceTime = ymdhmsStr;
    if (serviceTime.length >= 19) {
        serviceTime = [serviceTime substringToIndex:16];
    }
    [self.timebtn setTitle:serviceTime forState:UIControlStateNormal];
}

- (void)timeCance {
    [self.chooseTimeSheetView dismiss];
}


#pragma mark - getter && setter



- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.cornerRadius = 5;
        _imgView.layer.masksToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        //        [_imgView sd_setImageWithURL:[NSURL URLWithString:@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"]];
    }
    return _imgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        //        _nameLabel.text = @"鲜毛肚";
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HEX_RGB(0x777777);
        _priceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        //        NSString *str = @"价格：￥12";
        //        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
        //        [att addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(0xEE6161)} range:NSMakeRange(3, str.length-3)];
        //        _priceLabel.attributedText = att;
    }
    return _priceLabel;
    
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"xk_btn_TradingArea_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIView *)lineView0 {
    if (!_lineView0) {
        _lineView0 = [[UIView alloc] init];
        _lineView0.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView0;
}


- (UILabel *)guigeLabel {
    if (!_guigeLabel) {
        _guigeLabel = [[UILabel alloc] init];
        _guigeLabel.text = @"规格";
        _guigeLabel.textColor = HEX_RGB(0x777777);
        _guigeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _guigeLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
//        flowLayout.estimatedItemSize = CGSizeMake(itemWidth, itemHeight);
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

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView1;
}



- (UILabel *)timeNameLabel {
    if (!_timeNameLabel) {
        _timeNameLabel = [[UILabel alloc] init];
        _timeNameLabel.text = @"预约时间";
        _timeNameLabel.textColor = HEX_RGB(0x777777);
        _timeNameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _timeNameLabel;
}

- (UIButton *)timebtn {
    if (!_timebtn) {
        _timebtn = [[UIButton alloc] init];
        [_timebtn setTitle:@"点击选择" forState:UIControlStateNormal];
        [_timebtn setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        _timebtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_timebtn addTarget:self action:@selector(chooseTimeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timebtn;
}

- (XKHotspotButton *)chooseTimeBtn {
    if (!_chooseTimeBtn) {
        _chooseTimeBtn = [[XKHotspotButton alloc] init];
        [_chooseTimeBtn setImage:[UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"] forState:UIControlStateNormal];
        [_chooseTimeBtn addTarget:self action:@selector(chooseTimeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseTimeBtn;
}


- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView2;
}



- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] init];
        _nextBtn.backgroundColor = XKMainTypeColor;
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = 5;
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UIView *)bottomSafeView {
    if (!_bottomSafeView) {
        _bottomSafeView = [[UIView alloc] init];
        _bottomSafeView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomSafeView;
}

- (UIView *)bottomSafeLineView {
    if (!_bottomSafeLineView) {
        _bottomSafeLineView = [[UIView alloc] init];
        _bottomSafeLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _bottomSafeLineView;
}

- (XKServiceBookTimeChooseView *)timeChooseView {
    if (!_timeChooseView) {
        _timeChooseView = [[XKServiceBookTimeChooseView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.height-kBottomSafeHeight)];
        XKWeakSelf(weakSelf);
        _timeChooseView.sureBlock = ^(NSString *time) {
            [weakSelf timeChoosedWithYMDHMSStr:time];
        };
        _timeChooseView.cancelBlock = ^{
            [weakSelf timeCance];
        };
    }
    return _timeChooseView;
}

- (XKCommonSheetView *)chooseTimeSheetView {
    
    if (!_chooseTimeSheetView) {
        _chooseTimeSheetView = [[XKCommonSheetView alloc] init];
        _chooseTimeSheetView.addBottomSafeHeight = YES;
        _chooseTimeSheetView.contentView = self.timeChooseView;
        [_chooseTimeSheetView addSubview:self.timeChooseView];
    }
    return _chooseTimeSheetView;
}

- (NSMutableArray *)subIndexMuArr {
    if (!_subIndexMuArr) {
        _subIndexMuArr = [NSMutableArray array];
    }
    return _subIndexMuArr;
}


- (void)setValueWithModel:(XKTradingAreaGoodsInfoModel *)model viewType:(SpecificationViewType)viewType {
    
    self.viewType = viewType;
    self.model = model;
    [self.imgView sd_setImageWithURL:kURL(model.goods.mainPic) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];
    self.nameLabel.text = model.goods.goodsName;
    
    NSString *str = [NSString stringWithFormat:@"价格：￥%.2f", model.goods.discountPrice.floatValue / 100.0];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(0xEE6161)} range:NSMakeRange(3, str.length-3)];
    self.priceLabel.attributedText = att;
    
    
    [self.subIndexMuArr removeAllObjects];
    for (int i = 0; i < self.model.goodsSkuAttrsVO.attrList.count; i++) {
        [self.subIndexMuArr addObject:@(-1)];
    }
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.subIndexMuArr.count * (headerHeight + itemHeight)));
    }];
    self.selectedIndex = -1;
    
    if (viewType == viewType_hetol) {
        self.lineView1.hidden = YES;
        self.timeNameLabel.hidden = YES;
        self.timebtn.hidden = YES;
        self.chooseTimeBtn.hidden = YES;
        self.lineView2.hidden = YES;
        
        [self.timeNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.nextBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView2.mas_bottom);
        }];
        
    } else {
        self.lineView1.hidden = NO;
        self.timeNameLabel.hidden = NO;
        self.timebtn.hidden = NO;
        self.chooseTimeBtn.hidden = NO;
        self.lineView2.hidden = NO;
        
        [self.timeNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@43);
        }];
        [self.nextBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView2.mas_bottom).offset(15);
        }];
        
    }
    
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
            
            NSString *str = [NSString stringWithFormat:@"价格：￥%.2f", listItem.discountPrice.floatValue / 100.0];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
            [att addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(0xEE6161)} range:NSMakeRange(3, str.length-3)];
            self.priceLabel.attributedText = att;
            [self.imgView sd_setImageWithURL:kURL(listItem.skuUrl) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];
            [self.collectionView reloadData];
            
            return;
        }
    }
    [XKHudView showWarnMessage:@"暂无该规格商品，请重新选取"];
}


@end
