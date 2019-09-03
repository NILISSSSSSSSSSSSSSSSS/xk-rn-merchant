//
//  XKMineConfigureRecipientListTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/8/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineConfigureRecipientListTableViewCell.h"
#import "XKMineConfigureRecipientListModel.h"

@interface XKMineConfigureRecipientListTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneNumLabel;
@property (nonatomic, strong) UILabel *defaultAddressMarkLabel;
@property (nonatomic, strong) UIButton *editingButton;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation XKMineConfigureRecipientListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureSubviews];
    return self;
}

- (void)configTableViewCell:(XKMineConfigureRecipientItem *)recipientItem {
    
    if (recipientItem.receiver && ![recipientItem.receiver isEqualToString:@""]) {
        self.nameLabel.text = recipientItem.receiver;
    }
    if (recipientItem.phone && ![recipientItem.phone isEqualToString:@""]) {
        self.phoneNumLabel.text = recipientItem.phone;
    }
    
    NSString *provinceName = recipientItem.provinceName? recipientItem.provinceName: @"";
    NSString *cityName = recipientItem.cityName? recipientItem.cityName: @"";
    NSString *districtName = recipientItem.districtName? recipientItem.districtName: @"";
    NSString *street = recipientItem.street? recipientItem.street: @"";
    NSString *addressString = [NSString stringWithFormat:@"%@ %@ %@ %@", provinceName, cityName, districtName, street];
    self.addressLabel.text = addressString;
    
    NSString *isDefault = recipientItem.isDefault;
    if (isDefault && ![isDefault isEqualToString:@""]) {
        if ([isDefault isEqualToString:@"1"]) {
            self.defaultAddressMarkLabel.hidden = NO;
            self.defaultAddressMarkLabel.text = @"[默认地址]";
        } else {
            self.defaultAddressMarkLabel.hidden = YES;
            self.defaultAddressMarkLabel.text = @"";
        }
    }
}

- (void)showCellSeparator {
    self.separatorView.hidden = NO;
}

- (void)hiddenCellSeparator {
    self.separatorView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureSubviews {
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10.0);
        make.left.equalTo(self.contentView.mas_left).offset(18.0);
    }];
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(10.0);
        make.bottom.equalTo(self.nameLabel.mas_bottom);
    }];
    [self.defaultAddressMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10.0);
        make.left.equalTo(self.nameLabel.mas_left).offset(0);
    }];
    [self.editingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-10.0);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.defaultAddressMarkLabel.mas_top);
        make.left.equalTo(self.defaultAddressMarkLabel.mas_right).offset(2);
        make.right.equalTo(self.editingButton.mas_left).offset(-10);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
}

- (void)clickEditButton:(UIButton *)sender {
    [self.delegate configureRecipientList:self clickEditingButton:sender];
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)phoneNumLabel {
    
    if (!_phoneNumLabel) {
        _phoneNumLabel = [UILabel new];
        _phoneNumLabel.textAlignment = NSTextAlignmentLeft;
        _phoneNumLabel.numberOfLines = 1;
        _phoneNumLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
        [self.contentView addSubview:_phoneNumLabel];
    }
    return _phoneNumLabel;
}

- (UILabel *)defaultAddressMarkLabel {
    
    if (!_defaultAddressMarkLabel) {
        _defaultAddressMarkLabel = [UILabel new];
        _defaultAddressMarkLabel.numberOfLines = 1;
        _defaultAddressMarkLabel.textColor = [UIColor colorWithRed:89/255.0 green:144/255.0 blue:250/255.0 alpha:1];
        _defaultAddressMarkLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _defaultAddressMarkLabel.text = @"[默认地址]";
        [self.contentView addSubview:_defaultAddressMarkLabel];
    }
    return _defaultAddressMarkLabel;
}

- (UIButton *)editingButton {
    
    if (!_editingButton) {
        _editingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editingButton setImage:[UIImage imageNamed:@"xk_btn_main_recipient_edit"] forState:UIControlStateNormal];
        [_editingButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_editingButton];
    }
    return _editingButton;
}

- (UILabel *)addressLabel {
    
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
        _addressLabel.textColor = [UIColor greenColor];
        _addressLabel.numberOfLines = 2;
        _addressLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _addressLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_addressLabel];
    }
    return _addressLabel;
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
