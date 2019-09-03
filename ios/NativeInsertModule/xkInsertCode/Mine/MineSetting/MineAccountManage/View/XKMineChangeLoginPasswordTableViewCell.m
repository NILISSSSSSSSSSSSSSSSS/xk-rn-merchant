//
//  XKMineChangeLoginPasswordTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineChangeLoginPasswordTableViewCell.h"

@interface XKMineChangeLoginPasswordTableViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *secureButton;
@property (nonatomic, strong) UIView *separatorView;

@property (nonatomic, copy) NSString *password;

@end

@implementation XKMineChangeLoginPasswordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureSubviews];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configChangeLoginPasswordTableViewCell:(NSString *)password {
    
    if (self.type == XKMineChangeLoginPasswordTableViewCellTypeOldPassword) {
        self.titleLabel.text = @"*旧密码";
        self.inputTextField.placeholder = @"请输入旧密码";
    } else if (self.type == XKMineChangeLoginPasswordTableViewCellTypeNewPassword) {
        self.titleLabel.text = @"*新密码";
        self.inputTextField.placeholder = @"请输入新密码";
    } else {
        self.titleLabel.text = @"*再次输入";
        self.inputTextField.placeholder = @"请与新设置密码保持一致";
    }
    self.password = password;
}

- (void)configureSubviews {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.width.mas_equalTo(80);
    }];
    [self.secureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-18);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.secureButton.mas_left).offset(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.right.equalTo(self.clearButton.mas_left);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
}

- (void)showCellSeparator {
    self.separatorView.hidden = NO;
}

- (void)hiddenCellSeparator {
    self.separatorView.hidden = YES;
}

- (void)clearInputTextField {
    [self clearTextField:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *currentString;
    if ([string isEqualToString:@""] || !string) {
        currentString = [textField.text substringToIndex:[textField.text length] - 1];
    } else if ([string isEqualToString:@" "]) {
        return NO;
    } else {
        currentString = [textField.text stringByAppendingString:string];
    }
    
    self.password = currentString;
    [self.delegate cell:self changePasswordWithString:self.password];
    return YES;
}

- (void)clearTextField:(UIButton *)sender {
    
    self.inputTextField.text = @"";
    self.password = @"";
    [self.delegate cell:self changePasswordWithString:self.password];
}

- (void)changeTextFieldSecureState:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        self.inputTextField.secureTextEntry = YES;
    } else {
        self.inputTextField.secureTextEntry = NO;
    }
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UITextField *)inputTextField {
    
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] initWithFrame:self.contentView.frame];
        _inputTextField.borderStyle = UITextBorderStyleNone;
        _inputTextField.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        _inputTextField.delegate = self;
        _inputTextField.secureTextEntry = YES;
        [self.contentView addSubview:_inputTextField];
    }
    return _inputTextField;
}

- (UIButton *)clearButton {
    
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearButton setImage:[UIImage imageNamed:@"xk_btn_account_password_clear"] forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_clearButton];
    }
    return _clearButton;
}

- (UIButton *)secureButton {
    
    if (!_secureButton) {
        _secureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_secureButton setImage:[UIImage imageNamed:@"xk_btn_account_password_hidden"] forState:UIControlStateSelected];
        [_secureButton setImage:[UIImage imageNamed:@"xk_btn_account_password_show"] forState:UIControlStateNormal];
        [_secureButton addTarget:self action:@selector(changeTextFieldSecureState:) forControlEvents:UIControlEventTouchUpInside];
        _secureButton.selected = YES;
        [self.contentView addSubview:_secureButton];
    }
    return _secureButton;
}

- (UIView *)separatorView {
    
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = XKSeparatorLineColor;
        [self.contentView addSubview:_separatorView];
    }
    return _separatorView;
}

@end
