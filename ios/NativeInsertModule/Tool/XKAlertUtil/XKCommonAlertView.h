//
//  XKUploadManager.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/9.
//  Copyright © 2018年 xk. All rights reserved.
/**
 *  普通自定义弹框
 */
#import <UIKit/UIKit.h>
@class XKCommonAlertView;

typedef void(^LeftActionBlock)(void);
typedef void(^RightActionBlock)(void);
typedef void(^CloseActionBlock)(void);
typedef void(^DismissActionBlock)(void);

@interface XKCommonAlertView : UIView

/** 内容信息*/
@property (nonatomic, copy, readonly) NSString *message;

/**
 最全样式，block方式

 @param titleString 标题
 @param messageString 信息
 @param leftButtonString 左边按钮
 @param rightButtonString 右边按钮
 @param leftBlock 左边事件
 @param rightBlock 右边事件
 @return 实例
 */
- (instancetype)initWithTitle:(NSString *)titleString message:(NSString *)messageString leftButton:(NSString *)leftButtonString rightButton:(NSString *)rightButtonString leftBlock:(LeftActionBlock)leftBlock rightBlock:(RightActionBlock)rightBlock textAlignment:(NSTextAlignment)textAlignment;

/**
 最全样式，block方式
 
 @param titleString 标题
 @param messageBlock 点击信息事件
 @param leftButtonString 左边按钮
 @param rightButtonString 右边按钮
 @param leftBlock 左边事件
 @param rightBlock 右边事件
 @return 实例
 */
- (instancetype)initWithTitle:(NSString *)titleString messageAttribute:(NSAttributedString *)message messageBlock:(LeftActionBlock)messageBlock leftButton:(NSString *)leftButtonString rightButton:(NSString *)rightButtonString leftBlock:(LeftActionBlock)leftBlock rightBlock:(RightActionBlock)rightBlock textAlignment:(NSTextAlignment)textAlignment;


/**
 *  弹框
 */
- (void)show;

/**
 *  设置左边按钮颜色
 *
 *  @param color 左边按钮颜色
 */
- (void)setLeftButtonColor:(UIColor *)color;

/**
 *  设置右边按钮颜色
 *
 *  @param color 右边按钮颜色
 */
- (void)setRightButtonColor:(UIColor *)color;

/**
 *  设置标题颜色
 *
 *  @param color 标题颜色
 */
- (void)setTitleColor:(UIColor *)color;

/**
 *  设置内容颜色
 *
 *  @param color 内容颜色
 */
- (void)setMessageColor:(UIColor *)color;

/**
 *  设置内容的对齐方式
 *
 *  @param aligment 对齐方式
 */
- (void)setMessageAligment:(NSTextAlignment)aligment;

/**
 *  设置背景颜色
 *
 *  @param color 背景颜色
 */
- (void)setBGColor:(UIColor *)color;

/**
 *  设置标题字体大小
 *
 *  @param value 大小
 */
- (void)setTitleFontSize:(CGFloat)value;

/**
 *  设置内容字体大小
 *
 *  @param value 大小
 */
- (void)setMessageFontSize:(CGFloat)value;

/**
 *  设置按钮字体大小
 *
 *  @param value 大小
 */
- (void)setButtonFontSize:(CGFloat)value;

/**
 *  设置背景是否可以点击消失,默认为no
 *
 *  @param isTaped bool
 */
- (void)setBackgroundViewCouldTaped:(BOOL)isTaped;

/**
 *  设置是否隐藏关闭按钮
 *
 *  @param isHidden <#isHidden description#>
 */
- (void)setCloseButtonHidden:(BOOL)isHidden;

- (void)setContentRadius:(CGFloat)radius;

@end
