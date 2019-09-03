//
//  XKTradingAreaOrderFooterView.m
//  XKSquare
//
//  Created by hupan on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderFooterView.h"
#import "XKTradingAreaOrderDetaiModel.h"

@interface XKTradingAreaOrderFooterView ()

@property (nonatomic, strong) UILabel  *nameTitle;
@property (nonatomic, strong) UILabel  *nameLabel;

@property (nonatomic, strong) UIView   *lineView;
@property (nonatomic, strong) UILabel  *leftDecLabel;
@property (nonatomic, strong) UILabel  *rightDecLabel;


@end

@implementation XKTradingAreaOrderFooterView


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
    
    [self addSubview:self.backView];
    [self.backView addSubview:self.nameTitle];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.leftDecLabel];
    [self.backView addSubview:self.rightDecLabel];

}

- (void)layoutViews {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    [self.nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.backView).offset(15);

    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(15);
        make.right.equalTo(self.backView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.backView);
        make.height.equalTo(@1);
    }];
    
    [self.leftDecLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(0);
        make.left.equalTo(self.backView).offset(15);
        make.bottom.equalTo(self.backView);

    }];
    
    [self.rightDecLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftDecLabel.mas_top);
        make.right.equalTo(self.backView).offset(-15);
        make.bottom.equalTo(self.leftDecLabel.mas_bottom);

    }];
}

#pragma mark - Setter

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UILabel *)nameTitle {
    if (!_nameTitle) {
        _nameTitle = [[UILabel alloc] init];
        _nameTitle.hidden = YES;
        _nameTitle.numberOfLines = 0;
        _nameTitle.textColor = HEX_RGB(0x777777);
        _nameTitle.font = XKRegularFont(14);
        _nameTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _nameTitle;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:16];
        _nameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nameLabel;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.hidden = YES;
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


- (UILabel *)leftDecLabel {
    if (!_leftDecLabel) {
        _leftDecLabel = [[UILabel alloc] init];
        _leftDecLabel.hidden = YES;
        _leftDecLabel.numberOfLines = 0;
        _leftDecLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _leftDecLabel.textColor = HEX_RGB(0x777777);
        _leftDecLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _leftDecLabel;
}

- (UILabel *)rightDecLabel {
    if (!_rightDecLabel) {
        _rightDecLabel = [[UILabel alloc] init];
        _rightDecLabel.hidden = YES;
        _rightDecLabel.numberOfLines = 0;
        _rightDecLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _rightDecLabel.textColor = HEX_RGB(0x777777);
        _rightDecLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _rightDecLabel;
}



#pragma mark- Events

- (void)setTitleWithLogisticFee:(CGFloat)logisticFee goodsPrice:(CGFloat)price {
    
    self.nameLabel.textColor = HEX_RGB(0x222222);
    
    [self.nameLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentRight).lineSpacing(10);
        if (logisticFee) {
            confer.text(@"配送费 ");
            confer.text([NSString stringWithFormat:@"￥%.2f", logisticFee]).textColor(HEX_RGB(0xEE6161)).font(XKMediumFont(16));
            confer.text(@"\n");
        }
        confer.text(@"订单总额 ");
        confer.text([NSString stringWithFormat:@"￥%.2f", logisticFee + price]).textColor(HEX_RGB(0xEE6161)).font(XKMediumFont(16));
        
    }];
}

//售后显示 外卖
- (void)setAfterSaleValue:(XKTradingAreaOrderDetaiModel *)orderModel logisticFee:(CGFloat)logisticFee {
    self.leftDecLabel.hidden = NO;
    self.rightDecLabel.hidden = NO;
    
    if (logisticFee > 0) {
        self.nameTitle.hidden = NO;
        self.nameLabel.hidden = NO;
        self.lineView.hidden = NO;

        self.nameTitle.text = @"配送费";
        self.nameLabel.font = XKRegularFont(14);
        self.nameLabel.textColor = HEX_RGB(0x777777);
        self.nameLabel.text = [NSString stringWithFormat:@"￥%.2f", logisticFee];
    } else {
        self.nameTitle.hidden = YES;
        self.nameLabel.hidden = YES;
        self.lineView.hidden = YES;

        
        [self.nameTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(0);
        }];
        
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(0);
        }];
        
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(0);
        }];
        
    }
    [self.leftDecLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.bottom.equalTo(self.backView).offset(-15);
    }];
    
    [self.leftDecLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentLeft).lineSpacing(15);
        confer.text(@"订单总额");
        confer.text(@"\n");
        confer.text(@"商家优惠价");
        confer.text(@"\n");
        confer.text(@"实际支付");
        confer.text(@"\n");
        confer.text(@"现金支付");
        confer.text(@"\n");
        confer.text(@"商家券支付");
    }];
    
    [self.rightDecLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentRight).lineSpacing(15);
        confer.text([NSString stringWithFormat:@"￥%.2f", orderModel.totalPlatPrice.floatValue]);
        confer.text(@"\n");
        confer.text([NSString stringWithFormat:@"-￥%.2f", orderModel.totalPlatPrice.floatValue - orderModel.totalShopPrice.floatValue]);
        confer.text(@"\n");
        confer.text([NSString stringWithFormat:@"￥%.2f", orderModel.totalShopPrice.floatValue]).font(XKMediumFont(17)).textColor(HEX_RGB(0xee6161));
        confer.text(@"\n");
        confer.text([NSString stringWithFormat:@"￥%.2f", orderModel.totalRmbPrice.floatValue]);
        confer.text(@"\n");
        confer.text([NSString stringWithFormat:@"￥%.2f", orderModel.totalShopVoucherPrice.floatValue]);

    }];
}




//售后显示 服务或者加购
- (void)setAfterSaleValue:(XKTradingAreaOrderDetaiModel *)orderModel goodsNum:(CGFloat)goodsNum {
    self.leftDecLabel.hidden = NO;
    self.rightDecLabel.hidden = NO;
    
    if (goodsNum > 0) {
        self.nameTitle.hidden = YES;
        self.nameLabel.hidden = NO;
        self.lineView.hidden = NO;
        
        self.nameLabel.font = XKRegularFont(14);
        self.nameLabel.textColor = HEX_RGB(0x777777);
        [self.nameLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"数量");
            confer.text([NSString stringWithFormat:@" x%d", (int)goodsNum]).textColor(HEX_RGB(0xee6161));
        }];
    } else {
        self.nameTitle.hidden = YES;
        self.nameLabel.hidden = YES;
        self.lineView.hidden = YES;
        
        
        [self.nameTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(0);
        }];
        
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(0);
        }];
        
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(0);
        }];
        
    }
    [self.leftDecLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.bottom.equalTo(self.backView).offset(-15);
    }];
    
    [self.leftDecLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentLeft).lineSpacing(15);
        confer.text(@"订单总额");
        confer.text(@"\n");
        confer.text(@"商家优惠价");
        confer.text(@"\n");
        confer.text(@"实际支付");
        confer.text(@"\n");
        confer.text(@"现金支付");
        confer.text(@"\n");
        confer.text(@"商家券支付");
    }];

    [self.rightDecLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentRight).lineSpacing(15);
        
        //服务
        if (goodsNum == 0) {
            confer.text([NSString stringWithFormat:@"￥%.2f", orderModel.itemPlatPrice.floatValue]);
            confer.text(@"\n");
            confer.text([NSString stringWithFormat:@"-￥%.2f", orderModel.itemPlatPrice.floatValue - orderModel.itemShopPrice.floatValue]);
            confer.text(@"\n");
            confer.text([NSString stringWithFormat:@"￥%.2f", orderModel.itemShopPrice.floatValue]).font(XKMediumFont(17)).textColor(HEX_RGB(0xee6161));
            confer.text(@"\n");
            confer.text([NSString stringWithFormat:@"￥%.2f", orderModel.itemRmbPrice.floatValue]);
            confer.text(@"\n");
            confer.text([NSString stringWithFormat:@"￥%.2f", orderModel.itemShopVoucherPrice.floatValue]);
        } else {//加购
            
            CGFloat totalPurPlatPrice = 0;
            CGFloat totalPurShopPrice = 0;
            CGFloat totalPurRmbPrice = 0;
            CGFloat totalPurShopVoucherPrice = 0;

            for (OrderItems *items in orderModel.items) {
                totalPurPlatPrice += items.purPlatPrice.floatValue;
                totalPurShopPrice += items.purShopPrice.floatValue;
                totalPurRmbPrice += items.purRmbPayPrice.floatValue;
            }
            confer.text([NSString stringWithFormat:@"￥%.2f",totalPurPlatPrice]);
            confer.text(@"\n");
            confer.text([NSString stringWithFormat:@"-￥%.2f", totalPurPlatPrice - totalPurShopPrice]);
            confer.text(@"\n");
            confer.text([NSString stringWithFormat:@"￥%.2f", totalPurShopPrice]).font(XKMediumFont(17)).textColor(HEX_RGB(0xee6161));
            confer.text(@"\n");
            confer.text([NSString stringWithFormat:@"￥%.2f", totalPurRmbPrice]);
            confer.text(@"\n");
            confer.text([NSString stringWithFormat:@"￥%.2f", totalPurShopVoucherPrice]);
        }
    }];
}




- (void)setTitleWithTotalPrice:(CGFloat)price tip:(NSString *)tip {
    
    self.nameLabel.textColor = HEX_RGB(0x222222);
    
    [self.nameLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentRight).lineSpacing(10);
        confer.text(@"订单总额 ");
        confer.text([NSString stringWithFormat:@"￥%.2f", price]).textColor(HEX_RGB(0xEE6161)).font(XKMediumFont(16));
        if (tip) {
            confer.text(@"\n");
            confer.text(tip).textColor(HEX_RGB(0x555555)).font(XKRegularFont(16));
        }
    }];
}

- (void)setTitleWithNum:(NSInteger)num totalPrice:(CGFloat)price payPrice:(CGFloat)payPrice {
    
    self.nameLabel.textColor = HEX_RGB(0x222222);
    
    [self.nameLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentRight).lineSpacing(10);
        if (num) {
            confer.text(@"数量 ");
            confer.text([NSString stringWithFormat:@"x%d", (int)num]).textColor(HEX_RGB(0xEE6161)).font(XKMediumFont(16));
            confer.text(@"\n");
            confer.text(@"总金额 ");
            confer.text([NSString stringWithFormat:@"￥%.2f", price]).textColor(HEX_RGB(0xEE6161)).font(XKMediumFont(16));
        }
        if (payPrice) {
            confer.text(@"\n");
            confer.text(@"实际支付 ");
            confer.text([NSString stringWithFormat:@"￥%.2f", payPrice]).textColor(HEX_RGB(0xEE6161)).font(XKMediumFont(16));
        }
    }];
}




@end






