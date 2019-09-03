//
//  XKUploadManager.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/9.
//  Copyright © 2018年 xk. All rights reserved.

#import <Foundation/Foundation.h>
#import "XKCommonAlertView.h"

@interface XKAlertView : NSObject

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 显示CommonAlertView
/**
 不需要交互的CommonAlertView 一个按钮 按钮文案默认确定
 
 @param title 标题
 */
+ (XKCommonAlertView *)showCommonAlertViewWithTitle:(NSString *)title;


/**
 title  message 一个按钮无交互
 
 @param title  标题
 @param messge message
 */
+ (XKCommonAlertView *)showCommonAlertViewWithTitle:(NSString *)title message:(NSString *)messge;

/**
 需要交互的CommonAlertView 一个按钮 按钮文案默认确定
 
 @param title 标题
 @param block 点击事件
 */
+ (XKCommonAlertView *)showCommonAlertViewWithTitle:(NSString *)title block:(nullable void(^)(void))block;

/**
 CommonAlertView弹窗
 左边按钮默认取消 左边无事件处理
 @param title 标题
 @param rightText 右边按钮文案
 @param rightBlock 右边按钮点击事件
 */
+ (XKCommonAlertView *)showCommonAlertViewWithTitle:(NSString *)title rightText:(nullable NSString *)rightText rightBlock:(nullable void(^)(void))rightBlock;

/**
 CommonAlertView弹窗
 
 @param title 标题
 @param leftText 左边按钮文案
 @param rightText 右边按钮文案
 @param leftBlock 左边按钮点击事件
 @param rightBlock 右边按钮点击事件
 */
+ (XKCommonAlertView *)showCommonAlertViewWithTitle:(NSString *)title leftText:(nullable NSString *)leftText rightText:(nullable NSString *)rightText leftBlock:(nullable void(^)(void))leftBlock rightBlock:(nullable void(^)(void))rightBlock;

/**
 CommonAlertView弹窗 带关闭按钮的 左右按钮没得颜色区分的
 
 @param title 标题
 @param leftText 左边按钮文案
 @param rightText 右边按钮文案
 @param leftBlock 左边按钮点击事件
 @param rightBlock 右边按钮点击事件
 */
+ (XKCommonAlertView *)showAlertViewWithCloseBtnWithTitle:(nullable NSString *)title message:(nullable NSString *)messge leftText:(nullable NSString *)leftText rightText:(nullable NSString *)rightText textColor:(UIColor *)color leftBlock:(nullable void(^)(void))leftBlock rightBlock:(nullable void(^)(void))rightBlock textAlignment:(NSTextAlignment)textAlignment ;


/**
 样式

 @param title 标题
 @param messge 内容
 @param leftText 左边按钮标题
 @param rightText 右边按钮标题
 @param leftBlock 左边按钮回调
 @param rightBlock 右边按钮回调
 @param textAlignment 文本对齐方式
 @return 提示框
 */
+ (XKCommonAlertView *)showCommonAlertViewWithTitle:(nullable NSString *)title message:(nullable NSString *)messge leftText:(nullable NSString *)leftText rightText:(nullable NSString *)rightText leftBlock:(nullable void(^)(void))leftBlock rightBlock:(nullable void(^)(void))rightBlock textAlignment:(NSTextAlignment)textAlignment;

@end

NS_ASSUME_NONNULL_END

