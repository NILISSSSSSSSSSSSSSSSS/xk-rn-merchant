//
//  XKLotteryTicketBallVIew.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLotteryTicketBallVIew.h"

@interface XKLotteryTicketBallVIew ()

@property (nonatomic, strong) UILabel *ballLab;

@end

@implementation XKLotteryTicketBallVIew

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _ballColor = XKMainTypeColor;
        _ballFont = XKRegularFont(17.0);
        _ballSelected = NO;
        self.ballLab = [[UILabel alloc] init];
        self.ballLab.font = _ballFont;
        self.ballLab.textColor = XKMainTypeColor;
        self.ballLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.ballLab];
        [self.ballLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutIfNeeded];
    self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2.0;
    self.layer.borderWidth = 1.0;
    
    if (self.ballSelected) {
        self.ballLab.textColor = HEX_RGB(0xFFFFFF);
        self.backgroundColor = self.ballColor;
        self.layer.borderColor = self.ballColor.CGColor;
    } else {
        self.ballLab.textColor = self.ballColor;
        self.backgroundColor = HEX_RGB(0xFFFFFF);
        self.layer.borderColor = XKSeparatorLineColor.CGColor;
    }
}

#pragma mark - getter setter

- (void)setTitle:(NSString *)title {
    _title = title;
    self.ballLab.text = title;
}

- (void)setBallColor:(UIColor *)ballColor {
    _ballColor = ballColor;
    [self layoutSubviews];
}

- (void)setBallFont:(UIFont *)ballFont {
    _ballFont = ballFont;
    self.ballLab.font = _ballFont;
}

- (void)setBallSelected:(BOOL)ballSelected {
    _ballSelected = ballSelected;
    [self layoutSubviews];
}

@end
