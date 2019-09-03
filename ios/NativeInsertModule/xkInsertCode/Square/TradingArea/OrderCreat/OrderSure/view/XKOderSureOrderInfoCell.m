//
//  XKOderSureOrderInfoCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOderSureOrderInfoCell.h"
#import "XKCommonStarView.h"

@interface XKOderSureOrderInfoCell ()<UITextFieldDelegate, UITextViewDelegate>
/*
@property (nonatomic, strong) UILabel           *phoneLabel;
@property (nonatomic, strong) UITextField       *textField;
@property (nonatomic, strong) UIView            *lineView1;

@property (nonatomic, strong) UILabel           *couponLabel;
@property (nonatomic, strong) UIButton          *chooseCouponBtn;
@property (nonatomic, strong) UIImageView       *imgView;
@property (nonatomic, strong) UIView            *lineView2;*/

@property (nonatomic, strong) UILabel            *numNameLabel;
@property (nonatomic, strong) UIView             *chooseView;
@property (nonatomic, strong) XKHotspotButton    *addBtn;
@property (nonatomic, strong) UILabel            *numLabel;
@property (nonatomic, strong) XKHotspotButton    *reduceBtn;
@property (nonatomic, strong) UIView             *lineView23;

@property (nonatomic, strong) UILabel           *seatLable;
@property (nonatomic, strong) UITextField       *textField2;
@property (nonatomic, strong) UIView            *lineView4;

@property (nonatomic, strong) UILabel           *tipLabel;
@property (nonatomic, strong) UITextView        *textView;
@property (nonatomic, strong) UIView            *lineView3;

@property (nonatomic, strong) UILabel           *priceNameLabel;
@property (nonatomic, strong) UILabel           *totalPriceLabel;
@property (nonatomic, assign) CGFloat           totalPrice;


@end

@implementation XKOderSureOrderInfoCell

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
    
    /*[self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.lineView1];

    [self.contentView addSubview:self.couponLabel];
    [self.contentView addSubview:self.chooseCouponBtn];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.lineView2];*/
    
    [self.contentView addSubview:self.numNameLabel];
    [self.contentView addSubview:self.chooseView];
    [self.chooseView addSubview:self.reduceBtn];
    [self.chooseView addSubview:self.numLabel];
    [self.chooseView addSubview:self.addBtn];
    [self.contentView addSubview:self.lineView23];
    
    [self.contentView addSubview:self.seatLable];
    [self.contentView addSubview:self.textField2];
    [self.contentView addSubview:self.lineView4];
    
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.lineView3];
    
    [self.contentView addSubview:self.priceNameLabel];
    [self.contentView addSubview:self.totalPriceLabel];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    

   /* [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
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
    
    
    [self.numNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
        make.height.equalTo(@14);
        make.width.equalTo(@100);
    }];
    
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@70);
        make.height.equalTo(@20);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.numNameLabel);
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
    
    
    [self.lineView23 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numNameLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    [self.seatLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView23.mas_bottom);
        make.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@43);
        make.width.equalTo(@100);
    }];
    
    [self.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.seatLable.mas_right);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.seatLable);
    }];
    
    [self.lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seatLable.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView4.mas_bottom).offset(15);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_top).offset(-6);
        make.left.equalTo(self.tipLabel.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@58);
    }];
    
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    [self.priceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView3.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@14);
        make.width.equalTo(@100);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceNameLabel.mas_right);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.priceNameLabel);
    }];
}


#pragma mark - Events
/*
- (void)chooseCouponBtnClicked:(UIButton *)sender {
    
    if (self.chooseCouponBlock) {
        self.chooseCouponBlock(@"123");
    }
}*/


- (void)addBtnClicekd:(UIButton *)sender {
    self.numLabel.text = [NSString stringWithFormat:@"%d", self.numLabel.text.intValue + 1];
    if (self.numLabel.text.intValue >= 99) {
        self.numLabel.text = @"99";
    }
    
    [self refreshValue:NO];

}


- (void)reduceBtnClicked:(UIButton *)sender {
    
    if (self.numLabel.text.intValue <= 2) {
        self.numLabel.text = @"1";
    } else {
        self.numLabel.text = [NSString stringWithFormat:@"%d", self.numLabel.text.intValue - 1];
    }
    [self refreshValue:NO];

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

#pragma mark - UITextFieldDelegate
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        [self.textField endEditing:YES];
        return NO;
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self refreshValue:NO];
}*/


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (self.chooseBookingNum) {
        self.chooseBookingNum();
    }
    return NO;
}

- (void)refreshValue:(BOOL)refresh {
    if (self.orderValueBlock) {
        self.orderValueBlock(self.textField2.text, self.numLabel.text, self.textView.text, self.totalPrice, refresh);
    }
}




- (void)setValueWithSeatName:(NSString *)seatName peopleNum:(NSString *)peopleNum tipStr:(NSString *)tipStr totalPrice:(CGFloat)totalPrice {
    
    self.textField2.text = seatName;
    
    self.numLabel.text = peopleNum;
    
    self.textView.text = tipStr;
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", totalPrice];
    
    self.totalPrice = totalPrice;
}




#pragma mark - Setter

/*
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
        _textField.text = [XKUserInfo getCurrentUserRealPhoneNumber];
        [_textField setValue:HEX_RGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        _textField.delegate = self;
        _textField.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _textField.textColor = HEX_RGB(0x555555);
        _textField.returnKeyType = UIReturnKeyDone;
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

- (UILabel *)numNameLabel {
    if (!_numNameLabel) {
        _numNameLabel = [[UILabel alloc] init];
        _numNameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _numNameLabel.textColor = HEX_RGB(0x222222);
        _numNameLabel.textAlignment = NSTextAlignmentLeft;
        _numNameLabel.text = @"人数";
    }
    return _numNameLabel;
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



- (UIView *)lineView23 {
    if (!_lineView23) {
        _lineView23 = [[UIView alloc] init];
        _lineView23.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView23;
}


- (UILabel *)seatLable {
    if (!_seatLable) {
        _seatLable = [[UILabel alloc] init];
        _seatLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _seatLable.textColor = HEX_RGB(0x222222);
        _seatLable.textAlignment = NSTextAlignmentLeft;
        _seatLable.text = @"餐桌号";
    }
    return _seatLable;
}

- (UITextField *)textField2 {
    if (!_textField2) {
        _textField2 = [[UITextField alloc] init];
        _textField2.textAlignment = NSTextAlignmentRight;
        [_textField2 setValue:HEX_RGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        _textField2.delegate = self;
        _textField2.placeholder = @"请选择您的餐桌号";
        _textField2.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _textField2.textColor = HEX_RGB(0x555555);
        _textField2.returnKeyType = UIReturnKeyDone;
        
    }
    return _textField2;
}

- (UIView *)lineView4 {
    if (!_lineView4) {
        _lineView4 = [[UIView alloc] init];
        _lineView4.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView4;
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

- (UIView *)lineView3 {
    if (!_lineView3) {
        _lineView3 = [[UIView alloc] init];
        _lineView3.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView3;
}


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
        _totalPriceLabel.text = @"￥0";
    }
    return _totalPriceLabel;
}



@end








