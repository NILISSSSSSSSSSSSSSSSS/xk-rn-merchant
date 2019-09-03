//
//  XKOnlineOrderDetailGoodsInfoFooterView.m
//  XKSquare
//
//  Created by hupan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOnlineOrderDetailGoodsInfoFooterView.h"
#import "XKHotspotButton.h"
#import "XKCommonStarView.h"

@interface XKOnlineOrderDetailGoodsInfoFooterView ()

@property (nonatomic, strong) UILabel          *nameLabel;
@property (nonatomic, strong) UILabel          *priceLabel;
@property (nonatomic, strong) UIView           *lineView1;
@property (nonatomic, strong) UIView           *lineView2;
@property (nonatomic, strong) UILabel          *totalNameLabel;
@property (nonatomic, strong) UILabel          *totalPriceLabel;



@end

@implementation XKOnlineOrderDetailGoodsInfoFooterView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = HEX_RGB(0xf6f6f6);
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
    
    [self.contentView addSubview:self.backView];

    [self.backView addSubview:self.lineView1];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.priceLabel];
    [self.backView addSubview:self.lineView2];
    [self.backView addSubview:self.totalNameLabel];
    [self.backView addSubview:self.totalPriceLabel];
}

- (void)layoutViews {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.backView);
        make.height.equalTo(@1);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1.mas_bottom).offset(15);
        make.left.equalTo(self.backView).offset(15);
        make.height.equalTo(@14);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.backView).offset(-15);
    }];

    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.backView);
        make.height.equalTo(@1);
    }];
    
    [self.totalNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView2.mas_bottom).offset(15);
        make.left.equalTo(self.backView).offset(15);
        make.height.equalTo(@14);

    }];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalNameLabel);
        make.right.equalTo(self.backView).offset(-15);
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
        _nameLabel.text = @"配送费";
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = @"￥10";
        _priceLabel.textColor = HEX_RGB(0xEE6161);
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

- (UILabel *)totalNameLabel {
    if (!_totalNameLabel) {
        _totalNameLabel = [[UILabel alloc] init];
        _totalNameLabel.textColor = HEX_RGB(0x222222);
        _totalNameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _totalNameLabel.textAlignment = NSTextAlignmentLeft;
        _totalNameLabel.text = @"订单总额";
    }
    return _totalNameLabel;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.textColor = HEX_RGB(0xEE6161);
        _totalPriceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
        NSString *str = @"￥150";
        _totalPriceLabel.text = str;
    }
    return _totalPriceLabel;
}



@end






