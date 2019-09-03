//
//  XKOnlineOrderSureGoodsInfoFooterView.m
//  XKSquare
//
//  Created by hupan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOnlineOrderSureGoodsInfoFooterView.h"
#import "XKHotspotButton.h"
#import "XKCommonStarView.h"

@interface XKOnlineOrderSureGoodsInfoFooterView ()<UITextViewDelegate>

@property (nonatomic, strong) UIView           *lineView1;
@property (nonatomic, strong) UILabel          *goodsTotalLabel;
@property (nonatomic, strong) UILabel          *totalPriceLabel;
@property (nonatomic, strong) UIView           *lineView2;

@property (nonatomic, strong) UILabel          *yunFeiTotalLabel;
@property (nonatomic, strong) UILabel          *yunFeiPriceLabel;
@property (nonatomic, strong) UIView           *lineView3;

@property (nonatomic, strong) UILabel          *tipLabel;
@property (nonatomic, strong) UITextView       *textView;
@property (nonatomic, strong) UIView           *lineView4;

@property (nonatomic, strong) UILabel          *couponLabel;
@property (nonatomic, strong) UIButton         *chooseCouponBtn;
@property (nonatomic, strong) UILabel          *totaltotalPriceLabel;


@end

@implementation XKOnlineOrderSureGoodsInfoFooterView


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
    [self.contentView addSubview:self.goodsTotalLabel];
    [self.contentView addSubview:self.totalPriceLabel];
    [self.contentView addSubview:self.lineView2];
    
    [self.contentView addSubview:self.yunFeiTotalLabel];
    [self.contentView addSubview:self.yunFeiPriceLabel];
    [self.contentView addSubview:self.lineView3];
    
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.lineView4];
    /*
    [self.contentView addSubview:self.couponLabel];
    [self.contentView addSubview:self.chooseCouponBtn];*/
    [self.contentView addSubview:self.totaltotalPriceLabel];
}

- (void)layoutViews {
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];

    [self.goodsTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@14);
    }];
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goodsTotalLabel);
        make.right.equalTo(self.contentView).offset(-15);
    }];

    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsTotalLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    
    [self.yunFeiTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView2.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@14);
    }];
    
    [self.yunFeiPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.yunFeiTotalLabel);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yunFeiTotalLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView3.mas_bottom).offset(15);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_top).offset(-6);
        make.left.equalTo(self.tipLabel.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@50);
    }];
    
    
    [self.lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    /*
    [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView4.mas_bottom).offset(15);
        make.height.equalTo(@14);
        make.width.equalTo(@100);
    }];
    
    [self.chooseCouponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.couponLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.couponLabel);
    }];*/
    
    
    [self.totaltotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView4.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}

- (void)setValueWithTotalPrice:(CGFloat)totalPrice payPrice:(CGFloat)payPrice yunFei:(CGFloat)yunFei tipStr:(NSString *)tipStr {
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", totalPrice];
    self.yunFeiPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", yunFei];
    self.textView.text = tipStr;
    
    NSString *str = [NSString stringWithFormat:@"订单总额  ￥%.2f", payPrice+yunFei];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(0xEE6161), NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17]} range:NSMakeRange(4, str.length - 4)];
    self.totaltotalPriceLabel.attributedText = attStr;

}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length >= 20) {
        self.textView.text = [textView.text substringToIndex:20];
        [XKHudView showWarnMessage:@"已超出最大字符长度"];
    }
    [self refreshValue:NO];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.textView endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)refreshValue:(BOOL)refresh {
    if (self.tipStrBlock) {
        self.tipStrBlock(self.textView.text);
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

- (UILabel *)goodsTotalLabel {
    if (!_goodsTotalLabel) {
        _goodsTotalLabel = [[UILabel alloc] init];
        _goodsTotalLabel.text = @"商品总额";
        _goodsTotalLabel.textColor = HEX_RGB(0x777777);
        _goodsTotalLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _goodsTotalLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _goodsTotalLabel;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
//        _totalPriceLabel.text = @"￥150.00";
        _totalPriceLabel.textColor = HEX_RGB(0xEE6161);
        _totalPriceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _totalPriceLabel;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView2;
}




- (UILabel *)yunFeiTotalLabel {
    if (!_yunFeiTotalLabel) {
        _yunFeiTotalLabel = [[UILabel alloc] init];
        _yunFeiTotalLabel.text = @"费送费";
        _yunFeiTotalLabel.textColor = HEX_RGB(0x777777);
        _yunFeiTotalLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _yunFeiTotalLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _yunFeiTotalLabel;
}

- (UILabel *)yunFeiPriceLabel {
    if (!_yunFeiPriceLabel) {
        _yunFeiPriceLabel = [[UILabel alloc] init];
//        _yunFeiPriceLabel.text = @"￥10.00";
        _yunFeiPriceLabel.textColor = HEX_RGB(0xEE6161);
        _yunFeiPriceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
        _yunFeiPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _yunFeiPriceLabel;
}

- (UIView *)lineView3 {
    if (!_lineView3) {
        _lineView3 = [[UIView alloc] init];
        _lineView3.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView3;
}



- (UILabel *)tipLabel {
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _tipLabel.textColor = HEX_RGB(0x222222);
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.text = @"备注：";
    }
    return _tipLabel;
}


- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.placeholder = @"您可以填写您的需求，商家会尽量为您安排";
        [_textView setValue:HEX_RGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        _textView.delegate = self;
        _textView.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _textView.textColor = HEX_RGB(0x555555);
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}

- (UIView *)lineView4 {
    if (!_lineView4) {
        _lineView4 = [[UIView alloc] init];
        _lineView4.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView4;
}

- (UILabel *)couponLabel {
    if (!_couponLabel) {
        _couponLabel = [[UILabel alloc] init];
        _couponLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _couponLabel.textColor = HEX_RGB(0x222222);
        _couponLabel.textAlignment = NSTextAlignmentLeft;
        _couponLabel.text = @"优惠券";
    }
    return _couponLabel;
}

- (UIButton *)chooseCouponBtn {
    if (!_chooseCouponBtn) {
        _chooseCouponBtn = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 200, 40) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] title:@"选择优惠券" titleColor:UIColorFromRGB(0x555555) backColor:[UIColor clearColor]];
        [_chooseCouponBtn setImage:[UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"] forState:UIControlStateNormal];
        [_chooseCouponBtn setImageAtRightAndTitleAtLeftWithSpace:5];
        [_chooseCouponBtn addTarget:self action:@selector(chooseCouponBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _chooseCouponBtn;
}


- (UILabel *)totaltotalPriceLabel {
    if (!_totaltotalPriceLabel) {
        _totaltotalPriceLabel = [[UILabel alloc] init];
        _totaltotalPriceLabel.textColor = HEX_RGB(0x555555);
        _totaltotalPriceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
        _totaltotalPriceLabel.textAlignment = NSTextAlignmentRight;
        
//        NSString *str = @"订单总额  ￥150";
//        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
//        [attStr addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(0xEE6161), NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17]} range:NSMakeRange(4, str.length - 4)];
//        _totaltotalPriceLabel.attributedText = attStr;
    }
    return _totaltotalPriceLabel;
}


#pragma mark - Events

- (void)chooseCouponBtnClicked:(UIButton *)sender {
    
    
}


@end






