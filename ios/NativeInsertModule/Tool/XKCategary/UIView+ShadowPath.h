//
//  UIView+ShadowPath.h
//  XKSquare
//
//  Created by hupan on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, ShadowPathSide) {
    ShadowPathSideTop = 1 << 0,
    ShadowPathSideLeft = 1 << 1,
    ShadowPathSideBottom = 1 << 2,
    ShadowPathSideRight = 1 << 3,
};


@interface UIView (ShadowPath)

/**
 用贝塞尔画阴影

 @param shadowColor 阴影颜色
 @param shadowOpacity 透明度
 @param shadowRadius 圆角半径
 @param shadowPathSide 阴影边
 @param shadowPathWidth 阴影宽度
 */
- (void)drawShadowPathWithShadowColor:(UIColor *)shadowColor
                      shadowOpacity:(CGFloat)shadowOpacity
                       shadowRadius:(CGFloat)shadowRadius
                         shadowSide:(ShadowPathSide)shadowPathSide
                    shadowPathWidth:(CGFloat)shadowPathWidth;




/**
 用layer shadow阴影
 
 @param shadowColor 阴影颜色
 @param shadowOpacity 透明度
 @param shadowRadius 圆角半径
 @param shadowPathWidth 阴影宽度
  @param shadowOffset 阴影偏移
 */
- (void)drawShadowPathWithShadowColor:(UIColor *)shadowColor
                         shadowOpacity:(CGFloat)shadowOpacity
                          shadowRadius:(CGFloat)shadowRadius
                       shadowPathWidth:(CGFloat)shadowPathWidth
                          shadowOffset:(CGSize)shadowOffset;

/**用layer shadow阴影 通用配置*/
- (void)drawCommonShadowUselayer;

/**
 添加阴影layer

 @param targetView 需要添加阴影的view
 @param frame 阴影frame
 @param cornerRadius 阴影宽度
 @param shadowColor 阴影颜色
 @param shadowRadius 阴影圆角
 @param shadowOpacity 阴影透明度
 @param shadowOffset 阴影偏移位置
 */
- (void)addShadowLayerBelowView:(UIView *)targetView
                  subLayerFrame:(CGRect)frame
                   cornerRadius:(CGFloat)cornerRadius
                    shadowColor:(UIColor *)shadowColor
                   shadowRadius:(CGFloat)shadowRadius
                  shadowOpacity:(CGFloat)shadowOpacity
                   shadowOffset:(CGSize)shadowOffset;
@end
