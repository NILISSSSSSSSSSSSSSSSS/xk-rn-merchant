//
//  XKCustomPageControl.m
//  XKSquare
//
//  Created by hupan on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCustomPageControl.h"

@implementation XKCustomPageControl

- (instancetype)init{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setCurrentPage:(NSInteger)currentPage{
    [super setCurrentPage:currentPage];
    
    [self updateDots];
}


- (void)layoutSubviews {
    [super layoutSubviews];

    NSInteger dotH = _inactiveImageSize.height ? _inactiveImageSize.height : 5;
    NSInteger magrin = _margin ? _margin : 6;
    
    //遍历subview,设置圆点frame
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        NSInteger width = self.inactiveImageSize.width;
        if (i == self.currentPage) {
            width = self.currentImageSize.width;
        }
        if (i == 0) {
            [dot setFrame:CGRectMake(0, dot.frame.origin.y, width, dotH)];
        } else {
            UIImageView* lastDot = [self.subviews objectAtIndex:i-1];
            [dot setFrame:CGRectMake(CGRectGetMaxX(lastDot.frame)+magrin, dot.frame.origin.y, width, dotH)];
        }
    }
}

- (void)updateDots{
    
    NSInteger dotW = _inactiveImageSize.width ? _inactiveImageSize.width : 5;
    NSInteger magrin = _margin ? _margin : 6;
    
    //计算整个pageControll的宽度
    CGFloat newW = (self.subviews.count - 1) * magrin + (self.subviews.count - 1) * dotW + _currentImageSize.width;
    //设置新frame
    if (self.loopViewWith) {
        self.frame = CGRectMake((self.loopViewWith - newW) / 2, self.frame.origin.y, newW, self.frame.size.height);
    } else {
        self.frame = CGRectMake((SCREEN_WIDTH - newW) / 2, self.frame.origin.y, newW, self.frame.size.height);
    }
    
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView *dot = [self imageViewForSubview:[self.subviews objectAtIndex:i] currPage:i];
        if (i == self.currentPage) {
            dot.image = self.currentImage;
            dot.size = self.currentImageSize;
        } else {
            dot.image = self.inactiveImage;
            dot.size = self.inactiveImageSize;
        }
    }
}
- (UIImageView *)imageViewForSubview:(UIView *)view currPage:(int)currPage{
    UIImageView *dot = nil;
    if ([view isKindOfClass:[UIView class]]) {
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                dot = (UIImageView *)subview;
                break;
            }
        }
        
        if (dot == nil) {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
            
            [view addSubview:dot];
        }
    } else {
        dot = (UIImageView *)view;
    }
//    dot.center = CGPointMake(view.width / 2, view.height / 2);
    return dot;
}
@end

