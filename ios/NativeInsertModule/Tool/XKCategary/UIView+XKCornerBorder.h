//
//  UIView+XKCornerBorder.h
//  XKSquare
//
//  Created by Jamesholy on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//


// 加边框模式  addSubLayer

#import <UIKit/UIKit.h>



typedef NS_OPTIONS (NSUInteger, XKCornerBorderType) {
    XKBorderTypeNone = 0,
    XKBorderTypeTopLeft     = 1 << 0,
    XKBorderTypeTopRight    = 1 << 1,
    XKBorderTypeBottomLeft  = 1 << 2,
    XKBorderTypeBottomRight = 1 << 3,
    XKBorderTypeAllCorners  = 1 << 4
};

@interface UIView (XKCornerBorder)

/**是否启动加边框  defualt NO  -- tip：加边框 XKCornerBorder*/
@property(nonatomic, assign) BOOL xk_openBorder;
/**边框圆角大小 -- tip：加边框 XKCornerBorder*/
@property(nonatomic, assign) CGFloat xk_borderRadius;
/**边框圆角颜色  -- tip：加边框 XKCornerBorder*/
@property(nonatomic, strong) UIColor *xk_borderColor;
/**填充颜色  -- tip：加边框 XKCornerBorder*/
@property(nonatomic, strong) UIColor *xk_borderFillColor;
/**边框宽度  -- tip：加边框 XKCornerBorder*/
@property(nonatomic, assign) CGFloat xk_borderWidth;
/**边框圆角类型  -- tip：加边框 XKCornerBorder*/
@property(nonatomic, assign) XKCornerBorderType xk_borderType;


@end

