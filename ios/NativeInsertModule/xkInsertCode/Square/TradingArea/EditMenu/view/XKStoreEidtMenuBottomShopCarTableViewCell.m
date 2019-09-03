//
//  XKStoreEidtMenuBottomShopCarTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreEidtMenuBottomShopCarTableViewCell.h"
#import "XKTradingAreaShopCarManager.h"
#import "XKTradingAreaGoodsInfoModel.h"


@interface XKStoreEidtMenuBottomShopCarTableViewCell ()

@property (nonatomic, strong) UILabel          *nameLabel;
@property (nonatomic, strong) UILabel          *priceLabel;

@property (nonatomic, strong) UIView           *chooseView;
@property (nonatomic, strong) XKHotspotButton  *addBtn;
@property (nonatomic, strong) UILabel          *numLabel;
@property (nonatomic, strong) XKHotspotButton  *reduceBtn;

@property (nonatomic, strong) UIView           *lineView;
@property (nonatomic, copy  ) NSString         *shopId;
@property (nonatomic, strong) GoodsSkuVOListItem *item;


@end


@implementation XKStoreEidtMenuBottomShopCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

- (void)initViews {
    

    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];

    [self.contentView addSubview:self.chooseView];
    [self.chooseView addSubview:self.addBtn];
    [self.chooseView addSubview:self.numLabel];
    [self.chooseView addSubview:self.reduceBtn];
    
    [self.contentView addSubview:self.lineView];
    
}


- (void)layoutViews {

    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.priceLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chooseView.mas_left).offset(-5);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@0);
    }];
    
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@70);
        make.height.equalTo(@20);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
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
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}


#pragma mark - Events

- (void)addBtnClicekd:(UIButton *)sender {
    //加入购物车
    [[XKTradingAreaShopCarManager shareManager] addToShopCarWithGoodsModel:self.item shopId:self.shopId industryType:self.xkIndustryType];
    
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}


- (void)reduceBtnClicked:(UIButton *)sender {
    //从购物车减去
    [[XKTradingAreaShopCarManager shareManager] deleteGoodsWithGoodsModel:self.item shopId:self.shopId industryType:self.xkIndustryType];
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}



- (void)setValueWithModel:(GoodsSkuVOListItem *)model shopId:(NSString *)shopId num:(NSInteger)num {
    self.item = model;
    self.shopId = shopId;
    self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)", model.goodsName, model.skuName];
    self.numLabel.text = [NSString stringWithFormat:@"%ld", (long)num];
}

#pragma mark - Setter


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.text = @"票脚牛肉";
    }
    return _nameLabel;
}


- (UILabel *)priceLabel {
    
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
//        _priceLabel.text = @"￥30";
        _priceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _priceLabel.textColor = HEX_RGB(0xEE6161);
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



- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


@end
