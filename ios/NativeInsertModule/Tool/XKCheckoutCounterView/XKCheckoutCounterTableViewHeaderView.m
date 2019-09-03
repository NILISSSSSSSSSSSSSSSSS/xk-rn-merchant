//
//  XKCheckoutCounterTableViewHeaderView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKCheckoutCounterTableViewHeaderView.h"

@interface XKCheckoutCounterTableViewHeaderView ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *amountLab;

@end

@implementation XKCheckoutCounterTableViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.containerView];
        self.containerView.layer.cornerRadius = 8.0;
        
        self.amountLab = [[UILabel alloc] init];
        self.amountLab.numberOfLines = 0;
        self.amountLab.textAlignment = NSTextAlignmentCenter;
        [self.containerView addSubview:self.amountLab];

        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)).priorityHigh();
        }];
        
        [self.amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)setAmount:(CGFloat)amount {
    _amount = amount;
    [self.amountLab rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentCenter).lineSpacing(0);
        confer.text([NSString stringWithFormat:@"¥%.2f", self.amount]).font(XKMediumFont(24.0)).textColor(HEX_RGB(0x222222));
        confer.text(@"\n");
        confer.text(@"支付金额").font(XKMediumFont(14.0)).textColor(HEX_RGB(0x555555));
    }];
}

@end
