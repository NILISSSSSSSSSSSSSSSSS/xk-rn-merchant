//
//  XKPayPasswordView.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKPayPasswordView;

@protocol XKPayPasswordViewDelegate <NSObject>

@optional
/**
 *  输入支付密码即时回调
 *
 *  @param payPasswordView 支付密码视图
 *
 *  @param inputString 输入密码
 *
 */
- (void)payPasswordView:(XKPayPasswordView *)payPasswordView inputPasswordString:(NSString *)inputString;

/**
 *  输入完整支付密码后点击完成回调方法
 *
 *  @param payPasswordView 支付密码视图
 *
 *  @param sender 完成按钮
 *
 *  @param inputString 输入密码
 *
 */
- (void)payPasswordView:(XKPayPasswordView *)payPasswordView didClickConfirmButton:(UIBarButtonItem *)sender inputString:(NSString *)inputString;

@end

@interface XKPayPasswordView : UIView

@property (nonatomic, weak) id<XKPayPasswordViewDelegate> delegate;

/**
 *  为指定View添加固定尺寸支付密码视图
 *
 *  @param view 父视图
 *
 *  @return 支付密码视图对象
 */
+ (XKPayPasswordView *)addPayPasswordViewToView:(UIView *)view;

/**
 *  为指定View添加固定尺寸支付密码视图（不带toolbar）
 *
 *  @param view 父视图
 *
 *  @return 支付密码视图对象
 */
+ (XKPayPasswordView *)addPayPasswordViewWithoutToolBarToView:(UIView *)view;

/** 控制弹出输入支付密码键盘 */
- (void)startInputPayPassword;

/** 控制收起输入支付密码键盘 */
- (void)stopInputPayPassword;

@end
