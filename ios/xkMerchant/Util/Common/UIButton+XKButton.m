//
//  UIButton+XKButton.m
//  XKSquare
//
//  Created by hupan on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "UIButton+XKButton.h"

@implementation UIButton (XKButton)

- (void)setImageAndTitleVerticalAlignmentCenterWithSpace:(CGFloat)space {

    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height - space, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height - space, 0, 0, -titleSize.width);
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

@end
