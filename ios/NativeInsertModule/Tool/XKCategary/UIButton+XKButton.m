//
//  UIButton+XKButton.m
//  XKSquare
//
//  Created by hupan on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "UIButton+XKButton.h"

@implementation UIButton (XKButton)

- (void)setImageAtTopAndTitleAtBottomWithSpace:(CGFloat)space {

    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height - space, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height - space, 0, 0, -titleSize.width);
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}


- (void)setImageAtRightAndTitleAtLeftWithSpace:(CGFloat)space {
    
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageSize.width - space, 0, imageSize.width + space)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width + space, 0, -titleSize.width- space)];
    self.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
}

- (void)setImageAtLeftAndTitleAtRightWithSpace:(CGFloat)space {
    
    [self setTitleEdgeInsets:UIEdgeInsetsZero];
    [self setImageEdgeInsets:UIEdgeInsetsZero];
    self.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
}

@end
