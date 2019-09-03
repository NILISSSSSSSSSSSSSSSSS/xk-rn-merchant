//
//  XKCheckoutCounterDiscountFooter.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/5.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKCheckoutCounterDiscountFooter.h"

@implementation XKCheckoutCounterDiscountFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.discountLab = [[UILabel alloc] init];
        self.discountLab.font = XKMediumFont(14.0);
        self.discountLab.textColor = HEX_RGB(0x000000);
        [self addSubview:self.discountLab];
        
        self.discountAmountLab = [[UILabel alloc] init];
        self.discountAmountLab.font = XKMediumFont(14.0);
        self.discountAmountLab.textColor = HEX_RGB(0x000000);
        self.discountAmountLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.discountAmountLab];
        
        self.paymentLab = [[UILabel alloc] init];
        self.paymentLab.text = @"剩余支付：";
        self.paymentLab.font = XKMediumFont(14.0);
        self.paymentLab.textColor = HEX_RGB(0x000000);
        [self addSubview:self.paymentLab];
        
        self.paymentAmountlab = [[UILabel alloc] init];
        self.paymentAmountlab.font = XKMediumFont(14.0);
        self.paymentAmountlab.textColor = HEX_RGB(0x000000);
        self.paymentAmountlab.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.paymentAmountlab];
        
//        [self.discountLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.discountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(25.0);
            make.bottom.mas_equalTo(self.mas_centerY).offset(-2.0);
            make.right.mas_equalTo(self.mas_centerX);
        }];
        
        [self.discountAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.discountLab.mas_right);
            make.centerY.mas_equalTo(self.discountLab);
            make.trailing.mas_equalTo(-25.0);
        }];
        
//        [self.paymentLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.paymentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(25.0);
            make.top.mas_equalTo(self.mas_centerY).offset(2.0);
            make.right.mas_equalTo(self.mas_centerX);
        }];
        
        [self.paymentAmountlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.paymentLab.mas_right);
            make.centerY.mas_equalTo(self.paymentLab);
            make.trailing.mas_equalTo(-25.0);
        }];
    }
    return self;
}

@end
