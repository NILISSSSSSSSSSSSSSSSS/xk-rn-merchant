//
//  BaseViewFactory.h
//  xiaohua
//
//  Created by william on 16/8/12.
//  Copyright © 2016年 zld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIFont+XKFont.h"
@interface BaseViewFactory : NSObject

/**
 获取一个textField
 
 @param frame frame
 @param font font
 @param placeholder 占位文字
 @param color 文字颜色
 @param placeholderColor 占位文字颜色
 @param delegate 代理
 @return textField
 */
+ (UITextField *)textFieldWithFrame:(CGRect)frame
                               font:(UIFont *)font
                        placeholder:(NSString *)placeholder
                          textColor:(UIColor *)color
                   placeholderColor:(UIColor *)placeholderColor
                           delegate:(id<UITextFieldDelegate>)delegate;


/**
 设置一个button

 @param frame frame
 @param font font
 @param title 标题
 @param titleColor 标题颜色
 @param backColor 背景颜色
 @return button
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
                         font:(UIFont *)font
                        title:(NSString *)title
                   titleColor:(UIColor *)titleColor
                    backColor:(UIColor *)backColor;

/**
 获取一个view 前面带imageview 后面textField

 @param frame frame
 @param image 图片
 @param textField textField
 @param line 是否带下分割线
 @return view
 */
+(UIView *)viewWithFram:(CGRect)frame Image:(UIImage *)image textField:(UITextField *)textField withLine:(BOOL)line;


/**
 获取一个label

 @param frame frame
 @param text 文字
 @param font 字体
 @param textColor 文字颜色
 @param backColor 背景颜色
 @return label
 */
+(UILabel *)labelWithFram:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backColor;

/**
 获取一个view 前面带title 后面TextField

 @param frame frame
 @param title 标题
 @param textField TextField
 @param line 是否带下分割线
 @return view
 */
+(UIView *)viewWithFram:(CGRect)frame title:(NSString *)title textField:(UITextField *)textField withLine:(BOOL)line;


@end
