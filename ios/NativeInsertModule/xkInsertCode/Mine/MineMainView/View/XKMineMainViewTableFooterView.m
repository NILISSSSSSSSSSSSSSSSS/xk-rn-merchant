//
//  XKMineMainViewTableFooterView.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineMainViewTableFooterView.h"

@implementation XKMineMainViewTableFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    self.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
    UIView *cornerView = [UIView new];
    cornerView.backgroundColor = [UIColor whiteColor];
    cornerView.xk_openClip = YES;
    cornerView.xk_radius = 8;
    cornerView.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
    [self addSubview:cornerView];
    [cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@(10));
    }];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
