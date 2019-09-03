//
//  UIView+Corner.m
//  ErpApp
//
//  Created by Virusboo on 2018/1/2.
//  Copyright © 2018年 haofangtongerp. All rights reserved.
//

#import "UIView+Corner.h"

@implementation UIView (Corner)

- (void)cutRoundCornerWithColor:(UIColor *)color lineWidth:(CGFloat)lineWidth {
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    if (width == 0 || height == 0) {
        return;
    }
    CGFloat radius = MIN(width, height) / 2;
    [self cutCornerWithRadius:radius color:color lineWidth:lineWidth];
}

- (void)cutCornerWithRadius:(CGFloat)radius color:(UIColor *)color lineWidth:(CGFloat)lineWidth {
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    if (width == 0 || height == 0) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path  = path.CGPath;
    self.layer.mask = maskLayer;
    if (color && lineWidth > 0) {
        CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
        borderLayer.lineWidth = lineWidth;
        borderLayer.strokeColor = color.CGColor;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.path = path.CGPath;
        [self.layer addSublayer:borderLayer];
    }
}

- (void)cutCornerWithRoundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
