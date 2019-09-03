//
//  XKCheckoutCounterDiscountHeader.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/5.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKCheckoutCounterDiscountHeader.h"

@interface XKCheckoutCounterDiscountHeader ()

@end

@implementation XKCheckoutCounterDiscountHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.containerView];
        self.containerView.xk_radius = 8.0;
        self.containerView.xk_clipType = XKCornerClipTypeTopBoth;
        self.containerView.xk_openClip = YES;
        
        self.titleLab = [[UILabel alloc] init];
        [self.containerView addSubview:self.titleLab];
        
        self.ratioLab = [[UILabel alloc] init];
        self.ratioLab.text = @"比率";
        self.ratioLab.font = XKRegularFont(12.0);
        self.ratioLab.textColor = HEX_RGB(0xCCCCCC);
        [self.containerView addSubview:self.ratioLab];
        
        self.switchControl = [[UISwitch alloc] init];
        self.switchControl.on = NO;
        [self.containerView addSubview:self.switchControl];
        [self.switchControl addTarget:self action:@selector(switchControlAction:) forControlEvents:UIControlEventValueChanged];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
        }];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.containerView.mas_centerY);
            make.leading.mas_equalTo(15.0);
            make.trailing.mas_equalTo(-(CGRectGetWidth(self.switchControl.frame) + 15));
        }];
        
        [self.ratioLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.containerView.mas_centerY);
            make.leading.mas_equalTo(15.0);
            make.trailing.mas_equalTo(-(CGRectGetWidth(self.switchControl.frame) + 15));
        }];
        
        [self.switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-15.0);
            make.centerY.mas_equalTo(self.containerView);
        }];
        
    }
    return self;
}

- (void)switchControlAction:(UISwitch *)sender {
    if (self.switchBlock) {
        self.switchBlock(sender.isOn);
    }
}

@end
