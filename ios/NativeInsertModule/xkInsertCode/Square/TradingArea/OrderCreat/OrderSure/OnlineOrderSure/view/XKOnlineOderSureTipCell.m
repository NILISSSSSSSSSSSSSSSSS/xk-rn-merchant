//
//  XKOnlineOderSureTipCell.m
//  XKSquare
//
//  Created by hupan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOnlineOderSureTipCell.h"
#import "XKCommonStarView.h"

@interface XKOnlineOderSureTipCell ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UILabel           *phoneLabel;
@property (nonatomic, strong) UITextField       *textField;
@property (nonatomic, strong) UIView            *lineView1;

@property (nonatomic, strong) UILabel           *tipLabel;
@property (nonatomic, strong) UITextView        *textView;

@end

@implementation XKOnlineOderSureTipCell

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
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.lineView1];
    
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.textView];
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView1.mas_bottom).offset(15);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_top).offset(-6);
        make.left.equalTo(self.tipLabel.mas_right).offset(5);
        make.right.bottom.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@58);
    }];
    
}

- (void)setValueWithPhoneNum:(NSString *)phoneNum tipStr:(NSString *)tipStr {
    
    self.textField.text = phoneNum;
    self.textView.text = tipStr;
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


- (void)textFieldDidChange:(UITextField *)textField {
    //电话号码
    if (textField.text.length >= 12) {
        self.textField.text = [textField.text substringToIndex:11];
    }
    [self refreshValue:NO];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        [self.textField endEditing:YES];
        return NO;
    }
    return YES;
}


- (void)refreshValue:(BOOL)refresh {
    if (self.orderValueBlock) {
        self.orderValueBlock(self.textField.text, self.textView.text, refresh);
    }
}


#pragma mark - Setter


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

@end



