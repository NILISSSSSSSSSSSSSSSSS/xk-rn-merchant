//
//  XKCheckoutCounterDiscountAmountTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKCheckoutCounterDiscountAmountTableViewCell.h"

@interface XKCheckoutCounterDiscountAmountTableViewCell ()

@end

@implementation XKCheckoutCounterDiscountAmountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = HEX_RGB(0xffffff);
        [self.contentView addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
        }];
        
        self.useLab = [[UILabel alloc] init];
        self.useLab.text = @"使用：";
        self.useLab.font = XKRegularFont(14.0);
        self.useLab.textColor = HEX_RGB(0x222222);
        [self.containerView addSubview:self.useLab];
        [self.useLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.useLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.containerView);
            make.leading.mas_equalTo(15.0);
        }];
        
        self.discountAmountTF = [[UITextField alloc] init];
        self.discountAmountTF.placeholder = @"请输入金额";
        self.discountAmountTF.font = XKRegularFont(14.0);
        self.discountAmountTF.textColor = HEX_RGB(0xEE6161);
        self.discountAmountTF.textAlignment = NSTextAlignmentRight;
        self.discountAmountTF.keyboardType = UIKeyboardTypeDecimalPad;
        self.discountAmountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.containerView addSubview:self.discountAmountTF];
        [self.discountAmountTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.containerView);
            make.left.mas_equalTo(self.useLab.mas_right).offset(10.0);
            make.trailing.mas_equalTo(-15.0);
        }];
        
    }
    return self;
}

- (void)setCellEnabled:(BOOL)enabled {
    self.useLab.enabled = enabled;
    self.useLab.textColor = enabled ? HEX_RGB(0x222222) : HEX_RGB(0xCCCCCC);
    self.discountAmountTF.enabled = enabled;
    self.discountAmountTF.textColor = enabled ? HEX_RGB(0xEE6161) : HEX_RGB(0xCCCCCC);
}

@end
