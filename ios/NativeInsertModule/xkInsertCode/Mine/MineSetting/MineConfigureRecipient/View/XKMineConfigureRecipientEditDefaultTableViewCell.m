//
//  XKMineConfigureRecipientEditDefaultTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/8/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineConfigureRecipientEditDefaultTableViewCell.h"
#import "XKMineConfigureRecipientListModel.h"

@interface XKMineConfigureRecipientEditDefaultTableViewCell ()

@property (nonatomic, strong) UILabel *defaultLabel;
@property (nonatomic, strong) UISwitch *switchButton;
@property (nonatomic, assign) BOOL isForceDefault;
@property (nonatomic, strong) XKMineConfigureRecipientItem *recipientItem;

@end

@implementation XKMineConfigureRecipientEditDefaultTableViewCell

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

- (void)configTableViewCell:(XKMineConfigureRecipientItem *)recipientItem isForceDefault:(BOOL)isForceDefault {
    
    self.isForceDefault = isForceDefault;
    self.recipientItem = recipientItem;
    if (isForceDefault) {
        self.switchButton.on = YES;
        self.recipientItem.isDefault = @"1";
    } else {
        if (recipientItem.isDefault && ![recipientItem.isDefault isEqualToString:@""]) {
            if ([recipientItem.isDefault isEqualToString:@"0"]) {
                self.switchButton.on = NO;
            } else {
                self.switchButton.on = YES;
            }
        }
    }
}

- (void)clickswitchButton:(UISwitch *)switchButton {
    
    if (self.isForceDefault) {
        switchButton.on = YES;
        return;
    }
    
    NSString *isOn;
    if (switchButton.isOn == YES) {
        isOn = @"1";
    } else {
        isOn = @"0";
    }
    self.recipientItem.isDefault = isOn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configureSubviews {
    
    [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.width.mas_equalTo(110);
    }];
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(6);
        make.right.equalTo(self.contentView.mas_right).offset(-25);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(20);
    }];
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = XKSeparatorLineColor;
    [self.contentView addSubview:separatorView];
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    self.defaultLabel.text = @"设置默认地址";
}

- (UILabel *)defaultLabel {
    
    if (!_defaultLabel) {
        _defaultLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
        _defaultLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        _defaultLabel.numberOfLines = 1;
        [self.contentView addSubview:_defaultLabel];
    }
    return _defaultLabel;
}

- (UISwitch *)switchButton {
    
    if (!_switchButton) {
        _switchButton =  [UISwitch new];
        [_switchButton addTarget:self action:@selector(clickswitchButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_switchButton];
    }
    return _switchButton;
}

@end
