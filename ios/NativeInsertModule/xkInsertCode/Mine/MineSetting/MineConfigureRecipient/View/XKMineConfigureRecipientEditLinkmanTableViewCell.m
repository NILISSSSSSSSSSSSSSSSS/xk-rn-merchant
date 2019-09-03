//
//  XKMineConfigureRecipientEditLinkmanTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/8/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineConfigureRecipientEditLinkmanTableViewCell.h"
#import "XKMineConfigureRecipientListModel.h"

@interface XKMineConfigureRecipientEditLinkmanTableViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UILabel *phoneNumLabel;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIControl *addressBookControl;

@property (nonatomic, strong) XKMineConfigureRecipientItem *recipientItem;

@end

@implementation XKMineConfigureRecipientEditLinkmanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

- (void)configTableViewCell:(XKMineConfigureRecipientItem *)recipientItem {
    
    self.recipientItem = recipientItem;
    
    if (recipientItem.receiver && ![recipientItem.receiver isEqualToString:@""]) {
        self.nameTextField.text = recipientItem.receiver;
    }
    if (recipientItem.phone && ![recipientItem.phone isEqualToString:@""]) {
        self.phoneTextField.text = recipientItem.phone;
    }
}

- (void)clickAddressBookControl:(UIControl *)sender {
    
    if ([self.delegate respondsToSelector:@selector(linkmanCell:clickAddressBookControl:)]) {
        [self.delegate linkmanCell:self clickAddressBookControl:sender];
    }
}

- (void)textFieldChange:(UITextField *)textField {
    
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 有高亮选择的字 则不搜索
        if (position) {
            return;
        }
    }
    if (textField == self.nameTextField) {
        NSInteger length = textField.text.length;
        if (length >= 21) {
            textField.text = [textField.text substringToIndex:20];
        }
        self.recipientItem.receiver = textField.text;
    } else if (textField == self.phoneTextField) {
        NSInteger length = textField.text.length;
        if (length >= 12) {
            textField.text = [textField.text substringToIndex:11];
        }
        self.recipientItem.phone = textField.text;
    }
}

- (void)configureSubviews {
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).multipliedBy(0.5);
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.width.mas_equalTo(80);
    }];
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).multipliedBy(1.5);
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.width.mas_equalTo(80);
    }];
    [self.addressBookControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(self.contentView.mas_height);
        make.width.mas_equalTo(100);
    }];
    UIImageView *addressBookBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xk_ic_recipient_linkman"]];
    [self.addressBookControl addSubview:addressBookBackgroundImageView];
    [addressBookBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressBookControl.mas_top).offset(20);
        make.centerX.equalTo(self.addressBookControl.mas_centerX);
        make.width.height.equalTo(@(40));
    }];
    UIImageView *plusSignImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xk_ic_recipient_plus_sign"]];
    [self.addressBookControl addSubview:plusSignImageView];
    [plusSignImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressBookBackgroundImageView.mas_bottom).offset(10);
        make.right.equalTo(addressBookBackgroundImageView.mas_left).offset(2);
        make.width.height.equalTo(@(12));
    }];
    UILabel *linkmanLabel = [UILabel new];
    linkmanLabel.text = @"联系人";
    linkmanLabel.textColor = XKMainTypeColor;
    linkmanLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
    [self.addressBookControl addSubview:linkmanLabel];
    [linkmanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(plusSignImageView.mas_centerY);
        make.left.equalTo(plusSignImageView.mas_right).offset(5);
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right);
        make.right.equalTo(self.addressBookControl.mas_left).offset(-10);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.nameTextField);
        make.centerY.equalTo(self.phoneNumLabel.mas_centerY);
    }];
    
    UIView *centerSeparatorView = [UIView new];
    centerSeparatorView.backgroundColor = XKSeparatorLineColor;
    [self.contentView addSubview:centerSeparatorView];
    [centerSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.self.addressBookControl.mas_left);
        make.height.mas_equalTo(1);
    }];
    
    UIView *bottomSeparatorView = [UIView new];
    bottomSeparatorView.backgroundColor = XKSeparatorLineColor;
    [self.contentView addSubview:bottomSeparatorView];
    [bottomSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    UIView *verticalSeparatorView = [UIView new];
    verticalSeparatorView.backgroundColor = XKSeparatorLineColor;
    [self.contentView addSubview:verticalSeparatorView];
    [verticalSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.addressBookControl.mas_left);
        make.width.mas_equalTo(1);
    }];
    
    
    self.nameLabel.text = @"收货人";
    self.phoneNumLabel.text = @"联系电话";
    [self.addressBookControl addTarget:self action:@selector(clickAddressBookControl:) forControlEvents:UIControlEventTouchUpInside];
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UITextField *)nameTextField {
    
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] initWithFrame:self.contentView.frame];
        _nameTextField.borderStyle = UITextBorderStyleNone;
        _nameTextField.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        _nameTextField.textColor = [UIColor darkGrayColor];
        _nameTextField.placeholder = @"请输入";
        _nameTextField.delegate = self;
        [_nameTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_nameTextField];
    }
    return _nameTextField;
}

- (UILabel *)phoneNumLabel {
    
    if (!_phoneNumLabel) {
        _phoneNumLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
        _phoneNumLabel.numberOfLines = 1;
        _phoneNumLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        [self.contentView addSubview:_phoneNumLabel];
    }
    return _phoneNumLabel;
}

- (UITextField *)phoneTextField {
    
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] initWithFrame:self.contentView.frame];
        _phoneTextField.borderStyle = UITextBorderStyleNone;
        _phoneTextField.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        _phoneTextField.textColor = [UIColor darkGrayColor];
        _phoneTextField.placeholder = @"请输入";
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        _phoneTextField.delegate = self;
        [_phoneTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_phoneTextField];
    }
    return _phoneTextField;
}

- (UIControl *)addressBookControl {
    
    if (!_addressBookControl) {
        _addressBookControl = [UIControl new];
        _addressBookControl.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_addressBookControl];
    }
    return _addressBookControl;
}

@end
