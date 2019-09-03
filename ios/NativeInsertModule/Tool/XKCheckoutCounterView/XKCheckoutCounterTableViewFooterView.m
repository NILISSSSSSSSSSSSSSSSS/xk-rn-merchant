//
//  XKCheckoutCounterTableViewFooterView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKCheckoutCounterTableViewFooterView.h"

@implementation XKCheckoutCounterTableViewFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        payBtn.titleLabel.font = XKMediumFont(17.0);
        [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        payBtn.backgroundColor = XKMainTypeColor;
        [self addSubview:payBtn];
        [payBtn addTarget:self action:@selector(payBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        payBtn.layer.cornerRadius = 8.0;
        payBtn.layer.masksToBounds = YES;
        payBtn.clipsToBounds = YES;
        [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(20.0, 10.0, 20.0, 10.0)).priorityHigh();
        }];
    }
    return self;
}

- (void)payBtnAction:(UIButton *)sender {
    if (self.payBtnBlock) {
        self.payBtnBlock();
    }
}

@end
