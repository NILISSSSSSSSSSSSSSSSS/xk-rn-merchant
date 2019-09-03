//
//  XKOrderSureGoodsInfoFooterView.m
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOrderSureGoodsInfoFooterView.h"
#import "XKHotspotButton.h"
#import "XKCommonStarView.h"

@interface XKOrderSureGoodsInfoFooterView ()

@property (nonatomic, strong) UILabel          *nameLabel;
@property (nonatomic, strong) UILabel          *priceLabel;
@property (nonatomic, strong) UIView           *lineView1;
@property (nonatomic, strong) UIView           *lineView2;
@property (nonatomic, strong) UILabel          *totalPriceLabel;


@end

@implementation XKOrderSureGoodsInfoFooterView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initViews];
        [self layoutViews];
    }
    return self;
    
}


#pragma mark - Private
- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}


- (void)initViews {
    
    [self.contentView addSubview:self.lineView1];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.lineView2];
    [self.contentView addSubview:self.totalPriceLabel];
}

- (void)layoutViews {
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@14);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-15);
    }];

    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView2.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
}

- (void)setPriceValue:(NSString *)price totalPrice:(NSString *)totalPrice {
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", price];
    if (totalPrice.length) {
        NSString *str = [NSString stringWithFormat:@"订单总额  ￥%@", totalPrice];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(0xEE6161), NSFontAttributeName:XKMediumFont(17)} range:NSMakeRange(4, str.length - 4)];
        self.totalPriceLabel.attributedText = attStr;
    }
}

#pragma mark - Setter

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView1;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"商品总额";
        _nameLabel.textColor = HEX_RGB(0x777777);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
//        _priceLabel.text = @"￥150";
        _priceLabel.textColor = HEX_RGB(0x222222);
        _priceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView2;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.textColor = HEX_RGB(0x777777);
        _totalPriceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
        
//        NSString *str = @"订单总额  ￥150";
//        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
//        [attStr addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(0xEE6161), NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17]} range:NSMakeRange(4, str.length - 4)];
//        _totalPriceLabel.attributedText = attStr;
    }
    return _totalPriceLabel;
}


- (void)hiddenLine1View:(BOOL)hiddenView1 line2View:(BOOL)hiddenView2 {
    self.lineView1.hidden = hiddenView1;
    self.lineView2.hidden = hiddenView2;
    if (hiddenView2) {
        self.totalPriceLabel.hidden = YES;
    } else {
        self.totalPriceLabel.hidden = NO;
    }
}

- (void)cutCornerWithRoundedRect:(CGRect)rect {
    
    [self cutCornerWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
}


@end






