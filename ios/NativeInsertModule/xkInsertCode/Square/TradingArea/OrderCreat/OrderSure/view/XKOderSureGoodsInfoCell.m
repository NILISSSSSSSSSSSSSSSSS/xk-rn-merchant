//
//  XKOderSureGoodsInfoCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOderSureGoodsInfoCell.h"
#import "XKCommonStarView.h"
#import "XKTradingAreaGoodsInfoModel.h"
#import "XKTradingAreaOrderDetaiModel.h"

@interface XKOderSureGoodsInfoCell ()

@property (nonatomic, strong) UIButton          *selectBtn;
@property (nonatomic, strong) UIImageView       *imgView;
@property (nonatomic, strong) UILabel           *nameLabel;

@property (nonatomic, strong) UILabel           *priceLabel;
@property (nonatomic, strong) UILabel           *oldPriceLabel;

@property (nonatomic, strong) UILabel           *guigeLabel;
@property (nonatomic, strong) UILabel           *refundLabel;
@property (nonatomic, strong) UILabel           *salesLabel;
@property (nonatomic, strong) UIButton          *statuBtn;
@property (nonatomic, strong) UIView            *lineView;

@end

@implementation XKOderSureGoodsInfoCell

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

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

#pragma mark - Private

- (void)initViews {
    
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.oldPriceLabel];
    [self.contentView addSubview:self.guigeLabel];
    [self.contentView addSubview:self.refundLabel];
    [self.contentView addSubview:self.salesLabel];
    [self.contentView addSubview:self.statuBtn];
    [self.contentView addSubview:self.lineView];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.height.with.equalTo(@0);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtn.mas_right).offset(-5);
        make.top.equalTo(self.contentView).offset(15).priorityHigh();
        make.width.height.equalTo(@(80*ScreenScale)).priorityHigh();
        make.bottom.equalTo(self.contentView).offset(-15).priorityHigh();
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top).offset(0);
        make.left.equalTo(self.imgView.mas_right).offset(10);
//        make.right.equalTo(self.contentView).offset(-35);
    }];
    
    [self.salesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.width.equalTo(@20);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    [self.guigeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.nameLabel.mas_left);
    }];
    
    [self.refundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guigeLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel.mas_left);
//        make.right.equalTo(self.contentView).offset(-15).priorityLow();
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refundLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel.mas_left);
    }];
    
    [self.oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(5);
        make.centerY.equalTo(self.priceLabel);
    }];
    
    [self.statuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.salesLabel.mas_right);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.oldPriceLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

- (void)showSelectedBtn:(BOOL)show {
    
    self.selectBtn.hidden = !show;
    if (show) {
        [self.selectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.with.equalTo(@16);
        }];
    }
}

//下单时使用
- (void)setValueWithModel:(GoodsSkuVOListItem *)model num:(NSInteger)num {
    
    [self.imgView sd_setImageWithURL:kURL(model.skuUrl) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];
    self.nameLabel.text = model.goodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.discountPrice.floatValue / 100.0];
    self.guigeLabel.text = model.skuName;
    self.salesLabel.text = [NSString stringWithFormat:@"x%ld", (long)num];
    
    NSString *str = [NSString stringWithFormat:@"市场价￥%.2f", model.originalPrice.floatValue / 100.0];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSDictionary *dic = @{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)};
    [attributedStr addAttributes:dic range:NSMakeRange(0, str.length)];
    self.oldPriceLabel.attributedText = attributedStr;
    self.statuBtn.hidden = YES;
    
    self.refundLabel.hidden = YES;
    
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guigeLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel.mas_left);
    }];
}

//订单详情使用
- (void)setValueWithModel:(OrderItems *)model {
    
    [self.imgView sd_setImageWithURL:kURL(model.skuUrl) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];
    self.nameLabel.text = model.goodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.platformShopPrice.floatValue / 100.0];
    self.guigeLabel.text = model.skuName;
    if (model.refundId.length) {
        self.refundLabel.hidden = NO;
        self.refundLabel.text = [NSString stringWithFormat:@"售后号：%@", model.refundId];
        [self.guigeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.nameLabel.mas_left);
        }];
        [self.refundLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.guigeLabel.mas_bottom).offset(3);
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.equalTo(self.contentView).offset(-15).priorityLow();
        }];
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.refundLabel.mas_bottom).offset(3);
            make.left.equalTo(self.nameLabel.mas_left);
        }];
    } else {
        self.refundLabel.hidden = YES;
        [self.guigeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.left.equalTo(self.nameLabel.mas_left);
        }];
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.guigeLabel.mas_bottom).offset(5);
            make.left.equalTo(self.nameLabel.mas_left);
        }];
    }
    
    self.salesLabel.text = [NSString stringWithFormat:@"x%ld", (long)1];
    
    NSString *str = [NSString stringWithFormat:@"市场价￥%.2f", model.originalPrice.floatValue / 100.0];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSDictionary *dic = @{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)};
    [attributedStr addAttributes:dic range:NSMakeRange(0, str.length)];
    self.oldPriceLabel.attributedText = attributedStr;

    if (model.refundId.length) {
        NSString *statusName = @"";
        self.statuBtn.hidden = NO;

        if ([model.payStatus isEqualToString:@"APPLY_REFUND"]) {
            statusName = @"待退款";
        } else if ([model.payStatus isEqualToString:@"AGREE_REFUND"]) {
            statusName = @"同意退款";
        } else if ([model.payStatus isEqualToString:@"REFUSE_REFUND"]) {
            statusName = @"拒绝退款";
        } else if ([model.payStatus isEqualToString:@"SUCCESS_REFUND"]) {
            statusName = @"已退款";
        } else {
            self.statuBtn.hidden = YES;
        }
        if (!self.statuBtn.hidden) {
            [self.statuBtn setTitle:statusName forState:UIControlStateNormal];
            [self.statuBtn setTitleColor:HEX_RGB(0xee6161) forState:UIControlStateNormal];
        }
    } else {
        self.statuBtn.hidden = YES;
    }
}

//订单加购使用
- (void)setValueWithPurchasesModel:(PurchasesItem *)model orderTpye:(NSString *)orderType {
    
    [self.imgView sd_setImageWithURL:kURL(model.goodsSkuUrl) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];
    self.nameLabel.text = model.goodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.platformShopPrice.floatValue / 100.0];
    self.guigeLabel.text = model.goodsSkuName;
    if (model.refundId.length) {
        self.refundLabel.hidden = NO;
        self.refundLabel.text = [NSString stringWithFormat:@"售后号：%@", model.refundId];
        [self.guigeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.nameLabel.mas_left);
        }];
        [self.refundLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.guigeLabel.mas_bottom).offset(3);
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.equalTo(self.contentView).offset(-15).priorityLow();
        }];
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.refundLabel.mas_bottom).offset(3);
            make.left.equalTo(self.nameLabel.mas_left);
        }];
    } else {
        self.refundLabel.hidden = YES;
        [self.guigeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.left.equalTo(self.nameLabel.mas_left);
        }];
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.guigeLabel.mas_bottom).offset(5);
            make.left.equalTo(self.nameLabel.mas_left);
        }];
    }
    
    self.salesLabel.text = [NSString stringWithFormat:@"x%ld", (long)1];
    
    NSString *str = [NSString stringWithFormat:@"市场价￥%.2f", model.originalPrice.floatValue / 100.0];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSDictionary *dic = @{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)};
    [attributedStr addAttributes:dic range:NSMakeRange(0, str.length)];
    self.oldPriceLabel.attributedText = attributedStr;
    
    
    self.statuBtn.hidden = NO;
    
    /*payStatus 商品支付状态， 未支付NOT_PAY,支付中DURING_PAY,支付成功SUCCESS_PAY,申请退款中APPLY_REFUND,同意退款 商家改变AGREE_REFUND,拒绝退款REFUSE_REFUND,退款成功 结算后改变状态SUCCESS_REFUND,支付失败FAILED_PAY*/
    
    /*mainStatus 加购商品主状态，待接单STAY_ORDER，已接单=消费中=进行中=消费中CONSUMPTION_CENTRE,待结算STAY_CLEARING,已结算STAY_EVALUATE*/
    
    NSString *statusName = @"";
    if ([orderType isEqualToString:@"STAY_CLEARING"]) {
        statusName = @"待支付";
    } else if ([model.mainStatus isEqualToString:@"STAY_ORDER"]) {
        statusName = @"待接单";
    } else {
        if ([model.payStatus isEqualToString:@"NOT_PAY"]) {
            if (model.isFree) {
                statusName = @"已确认";
            } else {
                statusName = @"去支付";
            }
        } else if ([model.payStatus isEqualToString:@"DURING_PAY"]) {
            statusName = @"支付中";
        } else if ([model.payStatus isEqualToString:@"SUCCESS_PAY"]) {
            statusName = @"已支付";
        } else if ([model.payStatus isEqualToString:@"APPLY_REFUND"]) {
            statusName = @"待退款";
        } else if ([model.payStatus isEqualToString:@"AGREE_REFUND"]) {
            statusName = @"同意退款";
        } else if ([model.payStatus isEqualToString:@"REFUSE_REFUND"]) {
            statusName = @"拒绝退款";
        } else if ([model.payStatus isEqualToString:@"SUCCESS_REFUND"]) {
            statusName = @"已退款";
        } else if ([model.payStatus isEqualToString:@"FAILED_PAY"]) {
            statusName = @"支付失败";
        }
    }
    
    [self.statuBtn setTitle:statusName forState:UIControlStateNormal];
}

- (void)hiddenStatusBtn:(BOOL)hidden {
    self.statuBtn.hidden = hidden;
}

- (void)gotoPay:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"去支付"]) {
        if (self.gotoPayBlock) {
            self.gotoPayBlock();
        }
    }
}


#pragma mark - Setter

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        _selectBtn.hidden = YES;
        [_selectBtn setImage:IMG_NAME(@"xk_ic_contact_nochose") forState:UIControlStateNormal];
        [_selectBtn setImage:IMG_NAME(@"xk_ic_contact_chose") forState:UIControlStateSelected];
    }
    return _selectBtn;
}


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
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        //        _nameLabel.text = @"新疆大盘鸡";
    }
    return _nameLabel;
}


- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _priceLabel.textColor = HEX_RGB(0xEE6161);
        _priceLabel.textAlignment = NSTextAlignmentRight;
        //        _priceLabel.text = @"￥130";
    }
    return _priceLabel;
}

- (UILabel *)oldPriceLabel {
    
    if (!_oldPriceLabel) {
        _oldPriceLabel = [[UILabel alloc] init];
        _oldPriceLabel.textAlignment = NSTextAlignmentLeft;
        _oldPriceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _oldPriceLabel.textColor = HEX_RGB(0x999999);
    }
    return _oldPriceLabel;
}


- (UILabel *)guigeLabel {
    
    if (!_guigeLabel) {
        _guigeLabel = [[UILabel alloc] init];
        _guigeLabel.textAlignment = NSTextAlignmentLeft;
        //        _guigeLabel.text = @"小份250g";
        _guigeLabel.font = XKRegularFont(12);
        _guigeLabel.textColor = HEX_RGB(0x777777);
    }
    return _guigeLabel;
}

- (UILabel *)refundLabel {
    
    if (!_refundLabel) {
        _refundLabel = [[UILabel alloc] init];
        _refundLabel.textAlignment = NSTextAlignmentLeft;
        _refundLabel.font = XKRegularFont(12);
        _refundLabel.textColor = XKMainTypeColor;
    }
    return _refundLabel;
}


- (UILabel *)salesLabel {
    
    if (!_salesLabel) {
        _salesLabel = [[UILabel alloc] init];
        _salesLabel.textAlignment = NSTextAlignmentLeft;
        _salesLabel.text = @"x1";
        _salesLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _salesLabel.textColor = HEX_RGB(0x555555);
    }
    return _salesLabel;
}

- (UIButton *)statuBtn {
    if (!_statuBtn) {
        _statuBtn = [[UIButton alloc] init];
        [_statuBtn setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
        [_statuBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        [_statuBtn addTarget:self action:@selector(gotoPay:) forControlEvents:UIControlEventTouchUpInside];
        _statuBtn.titleLabel.font = XKRegularFont(14);
        _statuBtn.hidden = YES;
    }
    return _statuBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.hidden = YES;
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}

- (void)hiddenLineView:(BOOL)hidden {
    self.lineView.hidden = hidden;
}

@end



