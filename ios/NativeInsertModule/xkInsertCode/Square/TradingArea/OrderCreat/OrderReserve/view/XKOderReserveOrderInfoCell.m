//
//  XKOderReserveOrderInfoCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOderReserveOrderInfoCell.h"

@interface XKOderReserveOrderInfoCell ()<UITextFieldDelegate, UITextViewDelegate>


@property (nonatomic, strong) UILabel           *userNameLabel;
@property (nonatomic, strong) UITextField       *textField0;
@property (nonatomic, strong) UIView            *lineView0;

@property (nonatomic, strong) UILabel           *phoneLabel;
@property (nonatomic, strong) UITextField       *textField;
@property (nonatomic, strong) UIView            *lineView1;

/*
@property (nonatomic, strong) UILabel           *couponLabel;
@property (nonatomic, strong) UIButton          *chooseCouponBtn;
@property (nonatomic, strong) UIImageView       *imgView;
@property (nonatomic, strong) UIView            *lineView2;*/

@property (nonatomic, strong) UILabel           *priceNameLabel;
@property (nonatomic, strong) UILabel           *totalPriceLabel;

@property (nonatomic, strong) UIView            *lineView3;

@property (nonatomic, strong) UILabel           *tipLabel;



@end

@implementation XKOderReserveOrderInfoCell

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
    
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.textField0];
    [self.contentView addSubview:self.lineView0];
    
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.lineView1];
/*
    [self.contentView addSubview:self.couponLabel];
    [self.contentView addSubview:self.chooseCouponBtn];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.lineView2];*/
    
    [self.contentView addSubview:self.priceNameLabel];
    [self.contentView addSubview:self.totalPriceLabel];
    
    [self.contentView addSubview:self.lineView3];
    [self.contentView addSubview:self.tipLabel];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@43);
        make.width.equalTo(@100);
    }];
    
    [self.textField0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_right);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.userNameLabel);
    }];
    
    [self.lineView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLabel.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];

    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView0.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@14);
        make.width.equalTo(@100);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneLabel.mas_right);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.phoneLabel);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    /*
    [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView1.mas_bottom).offset(15);
        make.height.equalTo(@14);
        make.width.equalTo(@100);
    }];
    
    [self.chooseCouponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.couponLabel.mas_right).offset(10);
        make.right.equalTo(self.imgView.mas_left).offset(-5);
        make.centerY.equalTo(self.couponLabel);
    }];

    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.width.equalTo(@7);
        make.height.equalTo(@10);
        make.centerY.equalTo(self.couponLabel);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.couponLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];*/
    
    
    [self.priceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@14);
        make.width.equalTo(@100);
    }];
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceNameLabel.mas_right);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.priceNameLabel);
    }];
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceNameLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView3.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
}


#pragma mark - Events

/*
- (void)chooseCouponBtnClicked:(UIButton *)sender {
    
    if (self.chooseCouponBlock) {
        self.chooseCouponBlock(@"123");
    }
}*/

- (void)setValueWithSinglePrice:(CGFloat)price num:(NSInteger)num days:(NSInteger)days phoneNum:(NSString *)phone userName:(NSString *)userName {
    
    if (price && num && days) {
        self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", price * num * days];
    } else {
        self.totalPriceLabel.text = @"￥0";
    }
    
    self.userNameLabel.hidden = self.hiddenUserName;
    self.textField0.hidden = self.hiddenUserName;
    self.lineView0.hidden = self.hiddenUserName;
    
    [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height = self.hiddenUserName ? 0 : 43;
        make.height.equalTo(@(height));
    }];
    self.textField.text = phone;
    self.textField0.text = userName;
}


#pragma mark - textFieldDelegate

- (void)textFieldDidChange:(UITextField *)textField {
    //电话号码
    if (textField == self.textField) {
        if (textField.text.length >= 12) {
            self.textField.text = [textField.text substringToIndex:11];
        }
    }
    
    if (self.valueBlock) {
        self.valueBlock(self.textField.text, self.textField0.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (self.valueBlock) {
//        self.valueBlock(self.textField.text, self.textField0.text);
//    }
    
    if (textField == self.textField0) {
        [self.textField0 resignFirstResponder];
    } else {
        [self.textField resignFirstResponder];
    }
    return NO;
}

#pragma mark - Setter


- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _userNameLabel.textColor = HEX_RGB(0x222222);
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        _userNameLabel.text = @"联系人";
    }
    return _userNameLabel;
}

- (UITextField *)textField0 {
    if (!_textField0) {
        _textField0 = [[UITextField alloc] init];
        _textField0.textAlignment = NSTextAlignmentRight;
        _textField0.placeholder = @"请输入联系人姓名";
        [_textField0 setValue:HEX_RGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        _textField0.delegate = self;
        _textField0.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _textField0.textColor = HEX_RGB(0x555555);
        _textField0.returnKeyType = UIReturnKeyDone;
        [_textField0 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField0;
}

- (UIView *)lineView0 {
    if (!_lineView0) {
        _lineView0 = [[UIView alloc] init];
        _lineView0.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView0;
}



- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _phoneLabel.textColor = HEX_RGB(0x222222);
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        _phoneLabel.text = @"手机号";
    }
    return _phoneLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.placeholder = @"请输入您的手机号";
        [_textField setValue:HEX_RGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        _textField.delegate = self;
        _textField.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _textField.textColor = HEX_RGB(0x555555);
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.keyboardType = UIKeyboardTypePhonePad;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _textField;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView1;
}
/*
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
        _chooseCouponBtn = [[UIButton alloc] init];
        _chooseCouponBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_chooseCouponBtn setTitle:@"选择优惠券" forState:UIControlStateNormal];
        [_chooseCouponBtn setTitleColor:HEX_RGB(0x555555) forState:UIControlStateNormal];
        [_chooseCouponBtn addTarget:self action:@selector(chooseCouponBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseCouponBtn;
}

-(UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"];
    }
    return _imgView;
}



- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView2;
}*/


- (UILabel *)priceNameLabel {
    
    if (!_priceNameLabel) {
        _priceNameLabel = [[UILabel alloc] init];
        _priceNameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _priceNameLabel.textColor = HEX_RGB(0x222222);
        _priceNameLabel.textAlignment = NSTextAlignmentLeft;
        _priceNameLabel.text = @"订单总额";
    }
    return _priceNameLabel;
}

- (UILabel *)totalPriceLabel {
    
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        _totalPriceLabel.textColor = HEX_RGB(0xEE6161);
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
//        _totalPriceLabel.text = @"￥50";
    }
    return _totalPriceLabel;
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
        _tipLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _tipLabel.textColor = HEX_RGB(0xEE6161);
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.text = @"商家提示：到店时间前1小时可退款，逾期不可退款。";
    }
    return _tipLabel;
}



@end








