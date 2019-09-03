//
//  UIView+Corner.h
//  ErpApp
//
//  Created by Virusboo on 2018/1/2.
//  Copyright © 2018年 haofangtongerp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Corner)

/**
 给控件切圆以及添加边框

 @param color 边框颜色
 @param lineWidth 边框宽度
 */
- (void)cutRoundCornerWithColor:(UIColor *)color lineWidth:(CGFloat)lineWidth;

/**
 给控件切圆角以及添加边框

 @param radius 圆角半径
 @param color 边框颜色
 @param lineWidth 边框宽度
 */
- (void)cutCornerWithRadius:(CGFloat)radius color:(UIColor *)color lineWidth:(CGFloat)lineWidth;

/**
 给控件切指定方向圆角
 
 @param rect rect
 @param corners 圆角方向
 @param cornerRadii 切角大小
 */
- (void)cutCornerWithRoundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

@end
