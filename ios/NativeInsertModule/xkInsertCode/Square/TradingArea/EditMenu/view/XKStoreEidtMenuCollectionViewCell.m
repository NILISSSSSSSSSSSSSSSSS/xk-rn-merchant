//
//  XKStoreEidtMenuCollectionViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreEidtMenuCollectionViewCell.h"
#import "XKHotspotButton.h"
#import "XKCategaryGoodsListModel.h"

@interface XKStoreEidtMenuCollectionViewCell ()

@property (nonatomic, strong) UIImageView        *imgView;
@property (nonatomic, strong) UILabel            *nameLabel;
@property (nonatomic, strong) UILabel            *guigeLabel;
@property (nonatomic, strong) UILabel            *tradingLabel;
@property (nonatomic, strong) UILabel            *priceLabel;
@property (nonatomic, strong) UIView             *chooseView;
@property (nonatomic, strong) XKHotspotButton    *addBtn;
@property (nonatomic, strong) UILabel            *numLabel;
@property (nonatomic, strong) XKHotspotButton    *reduceBtn;
@property (nonatomic, strong) UIButton           *chooseBtn;
@property (nonatomic, strong) UIView             *lineView;



@end


@implementation XKStoreEidtMenuCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initViews];
        [self layoutViews];
    }
    
    return self;
}

- (void)initViews {
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.guigeLabel];
    [self.contentView addSubview:self.tradingLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.chooseView];
    [self.chooseView addSubview:self.addBtn];
    [self.chooseView addSubview:self.numLabel];
    [self.chooseView addSubview:self.reduceBtn];
    [self.contentView addSubview:self.chooseBtn];
    [self.contentView addSubview:self.lineView];
}


- (void)layoutViews {
    
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.width.equalTo(self.imgView.mas_height);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top).offset(0);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.guigeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(0);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.tradingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guigeLabel.mas_bottom).offset(0);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgView.mas_bottom).offset(0);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.chooseView.mas_left).offset(-5);
    }];
    
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@70);
        make.height.equalTo(@20);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.priceLabel);
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
    
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.chooseView);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.chooseView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}


#pragma mark - Setters


- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 5;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
//        [_imgView sd_setImageWithURL:[NSURL URLWithString:@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"]];
    }
    return _imgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
//        _nameLabel.text = @"毛肚";
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _nameLabel;
}

- (UILabel *)guigeLabel {
    if (!_guigeLabel) {
        _guigeLabel = [[UILabel alloc] init];
        _guigeLabel.hidden = YES;
        _guigeLabel.text = @"小份600g";
        _guigeLabel.textColor = HEX_RGB(0x777777);
        _guigeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
    }
    return _guigeLabel;
}


- (UILabel *)tradingLabel {
    if (!_tradingLabel) {
        _tradingLabel = [[UILabel alloc] init];
//        _tradingLabel.text = @"成交量：288";
        _tradingLabel.textColor = HEX_RGB(0x777777);
        _tradingLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
    }
    return _tradingLabel;
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
        _numLabel.hidden = YES;
        _numLabel.textAlignment = NSTextAlignmentCenter;
//        _numLabel.text = @"￥33";
        _numLabel.textColor = HEX_RGB(0x222222);
        _numLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _numLabel;
}

- (XKHotspotButton *)reduceBtn {
    if (!_reduceBtn) {
        _reduceBtn = [[XKHotspotButton alloc] init];
        _reduceBtn.hidden = YES;
        [_reduceBtn setImage:[UIImage imageNamed:@"xk_btn_TradingArea_reduce"] forState:UIControlStateNormal];
        [_reduceBtn addTarget:self action:@selector(reduceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceBtn;
}

- (UIButton *)chooseBtn {
    if (!_chooseBtn) {
        _chooseBtn = [[UIButton alloc] init];
        [_chooseBtn setTitle:@"选规格" forState:UIControlStateNormal];
        _chooseBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_chooseBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        _chooseBtn.layer.masksToBounds = YES;
        _chooseBtn.layer.cornerRadius = 10;
        _chooseBtn.layer.borderColor = XKMainTypeColor.CGColor;
        _chooseBtn.layer.borderWidth = 1;
        [_chooseBtn addTarget:self action:@selector(chooseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


#pragma mark - Events

- (void)addBtnClicekd:(UIButton *)sender {
    self.reduceBtn.hidden = NO;
    self.numLabel.hidden = NO;
    self.numLabel.text = [NSString stringWithFormat:@"%d", self.numLabel.text.intValue + 1];
    if (self.numLabel.text.intValue >= 99) {
        self.numLabel.text = @"99";
    }
    //加入购物车
}


- (void)reduceBtnClicked:(UIButton *)sender {
    
    if (self.numLabel.text.intValue <= 1) {
        self.numLabel.text = @"0";
        self.reduceBtn.hidden = YES;
        self.numLabel.hidden = YES;
    } else {
        self.numLabel.text = [NSString stringWithFormat:@"%d", self.numLabel.text.intValue - 1];
    }
    //从购物车减去
}

- (void)chooseBtnClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseGuigeButtonSelected:)]) {
        [self.delegate chooseGuigeButtonSelected:sender];
    }
}


- (void)hiddenLineView:(BOOL)hidden {
    self.lineView.hidden = hidden;
}

- (void)hiddenChooseView:(BOOL)viewHidden hiddenChooseGuigeBtn:(BOOL)btnHidden {
    self.chooseView.hidden = viewHidden;
    self.chooseBtn.hidden = btnHidden;
}


- (void)setValueWithModel:(CategaryGoodsItem *)model cellType:(EidtMenuCellType)cellType indexPath:(NSIndexPath *)indexPath {
    if (cellType == EidtMenuCellType_hotel) {
        [self.chooseBtn setTitle:@"预定" forState:UIControlStateNormal];
    } else {
        [self.chooseBtn setTitle:@"选规格" forState:UIControlStateNormal];
    }
    [self.imgView sd_setImageWithURL:kURL(model.mainPic) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];
    self.nameLabel.text = model.goodsName;
    self.tradingLabel.text = [NSString stringWithFormat:@"成交量:%ld", (long)model.saleM];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.discountPrice / 100.0];
    self.chooseBtn.tag = indexPath.row;
}






@end
