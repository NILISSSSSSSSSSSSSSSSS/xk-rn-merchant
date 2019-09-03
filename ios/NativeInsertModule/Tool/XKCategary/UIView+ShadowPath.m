//
//  UIView+ShadowPath.m
//  XKSquare
//
//  Created by hupan on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//
#import "UIView+ShadowPath.h"

@implementation UIView (LXShadowPath)


- (void)drawShadowPathWithShadowColor:(UIColor *)shadowColor
                        shadowOpacity:(CGFloat)shadowOpacity
                         shadowRadius:(CGFloat)shadowRadius
                           shadowSide:(ShadowPathSide)shadowPathSide
                      shadowPathWidth:(CGFloat)shadowPathWidth {
    
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowRadius =  shadowRadius;
    self.layer.shadowOffset = CGSizeZero;
    
    CGRect shadowRect;
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat originW = self.bounds.size.width;
    CGFloat originH = self.bounds.size.height;
    
    switch (shadowPathSide) {
        case 1://上
            shadowRect  = CGRectMake(originX, originY - shadowPathWidth/2, originW,  shadowPathWidth);
            break;
            
        case 2://左
            shadowRect  = CGRectMake(originX - shadowPathWidth/2, originY, shadowPathWidth, originH);
            break;

        case 3://上 左
            shadowRect  = CGRectMake(originX - shadowPathWidth/2, originY - shadowPathWidth/2, originW, originH);
            break;
            
        case 4://下
            shadowRect  = CGRectMake(originX, originH - shadowPathWidth/2, originW, shadowPathWidth);
            break;
            
        case 5://上 下
            shadowRect  = CGRectMake(originX, originY - shadowPathWidth/2, originW, originH + shadowPathWidth);
            break;
            
        case 6://左 下
            shadowRect  = CGRectMake(originX - shadowPathWidth/2, originY, originW, originH + shadowPathWidth/2);
            break;
            
        case 7://上 左 下
            shadowRect  = CGRectMake(originX - shadowPathWidth/2, originY - shadowPathWidth/2, originW, originH + shadowPathWidth/2);
            break;
            
        case 8://右
            shadowRect  = CGRectMake(originW - shadowPathWidth/2, originY, shadowPathWidth, originH);
            break;
            
        case 9://上 右
            shadowRect  = CGRectMake(originX, originY - shadowPathWidth/2, originW + shadowPathWidth/2, originH + shadowPathWidth/2);
            break;
            
        case 10://左 右
            shadowRect  = CGRectMake(originX - shadowPathWidth/2, originY, originW + shadowPathWidth, originH);
            break;
            
        case 11://上 左 右
            shadowRect  = CGRectMake(originX - shadowPathWidth/2, originY - shadowPathWidth/2, originW + shadowPathWidth, originH);
            break;
            
        case 12://下 右
            shadowRect  = CGRectMake(originX, originY, originW + shadowPathWidth/2, originH + shadowPathWidth/2);
            break;
            
        case 13://上 下 右
            shadowRect  = CGRectMake(originX, originY - shadowPathWidth/2, originW + shadowPathWidth/2, originH + shadowPathWidth);
            break;
            
        case 14://左 下 右
            shadowRect  = CGRectMake(originX - shadowPathWidth/2, originY, originW + shadowPathWidth, originH + shadowPathWidth/2);
            break;
            
        case 15://上 左 下 右
            shadowRect  = CGRectMake(originX - shadowPathWidth/2, originY - shadowPathWidth/2, originW + shadowPathWidth, originH + shadowPathWidth);
            break;
       
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    self.layer.shadowPath = path.CGPath;
    
}

- (void)drawShadowPathWithShadowColor:(UIColor *)shadowColor
                        shadowOpacity:(CGFloat)shadowOpacity
                         shadowRadius:(CGFloat)shadowRadius
                      shadowPathWidth:(CGFloat)shadowPathWidth
                         shadowOffset:(CGSize)shadowOffset {
    
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = shadowRadius;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowRadius = shadowPathWidth;
    self.layer.shadowOffset = shadowOffset;
}

- (void)drawCommonShadowUselayer {
    [self drawShadowPathWithShadowColor:HEX_RGB(0x000000) shadowOpacity:0.2 shadowRadius:5.0 shadowPathWidth:2.0 shadowOffset:CGSizeMake(0,1)];
}

- (void)addShadowLayerBelowView:(UIView *)targetView
                  subLayerFrame:(CGRect)frame
                   cornerRadius:(CGFloat)cornerRadius
                    shadowColor:(UIColor *)shadowColor
                   shadowRadius:(CGFloat)shadowRadius
                  shadowOpacity:(CGFloat)shadowOpacity
                   shadowOffset:(CGSize)shadowOffset {
    
    CALayer *subLayer = [CALayer layer];
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    subLayer.masksToBounds = NO;

    subLayer.frame = frame;
    subLayer.cornerRadius = cornerRadius;
    subLayer.shadowColor = shadowColor.CGColor;
    subLayer.shadowOpacity = shadowOpacity;
    subLayer.shadowRadius = shadowRadius;
    subLayer.shadowOffset = shadowOffset;

    [self.layer insertSublayer:subLayer below:targetView.layer];
}



@end
