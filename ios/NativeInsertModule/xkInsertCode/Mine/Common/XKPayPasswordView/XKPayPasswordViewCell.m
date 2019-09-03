//
//  XKPayPasswordViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPayPasswordViewCell.h"

static const CGFloat kPayPasswordViewCellCircleSymbolWidth = 12.0;
static const CGFloat kPayPasswordViewCellInputStringLabelWidth = 20.0;

@interface XKPayPasswordViewCell ()

@property (nonatomic, strong) UILabel *inputStringLabel;
@property (nonatomic, strong) CAShapeLayer *circleSymbol;

@end

@implementation XKPayPasswordViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = XKSeparatorLineColor.CGColor;
    return self;
}

- (void)reloadPayPasswordViewCellWithInputString:(NSString *)inputString {
    
    if (inputString && ![inputString isEqualToString:@""]) {
        self.inputStringLabel.text = inputString;
        self.inputStringLabel.hidden = NO;
        self.circleSymbol.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.inputStringLabel.text && ![self.inputStringLabel.text isEqualToString:@""]) {
                self.circleSymbol.hidden = NO;
                self.inputStringLabel.hidden = YES;
            }
        });
    } else {
        self.inputStringLabel.text = @"";
        self.inputStringLabel.hidden = YES;
        self.circleSymbol.hidden = YES;
    }
}

- (CAShapeLayer *)circleSymbol {
    
    if (!_circleSymbol) {
        _circleSymbol = [CAShapeLayer layer];
        _circleSymbol.fillColor = [UIColor blackColor].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((self.width - kPayPasswordViewCellCircleSymbolWidth) * 0.5, (self.height - kPayPasswordViewCellCircleSymbolWidth) * 0.5, kPayPasswordViewCellCircleSymbolWidth, kPayPasswordViewCellCircleSymbolWidth)];
        _circleSymbol.path = path.CGPath;
        _circleSymbol.hidden = YES;
        [self.layer addSublayer:_circleSymbol];
    }
    return _circleSymbol;
}

- (UILabel *)inputStringLabel {
    
    if (!_inputStringLabel) {
        _inputStringLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width - kPayPasswordViewCellInputStringLabelWidth) * 0.5, (self.height - kPayPasswordViewCellInputStringLabelWidth) * 0.5, kPayPasswordViewCellInputStringLabelWidth, kPayPasswordViewCellInputStringLabelWidth)];
        _inputStringLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:18.0];
        _inputStringLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_inputStringLabel];
    }
    return _inputStringLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
