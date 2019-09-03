//
//  UIButton+XKButton.h
//  XKSquare
//
//  Created by hupan on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XKButton)


/**
 设置button的图片和文字上下对齐 （需要保证btn的frame宽高大于img与title的总和）
 
 @param space 图片与文字的间距
 */

- (void)setImageAndTitleVerticalAlignmentCenterWithSpace:(CGFloat)space;

@end
