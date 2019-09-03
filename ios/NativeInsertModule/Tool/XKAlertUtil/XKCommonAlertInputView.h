/*******************************************************************************
 # File        : CommonAlertInputView.h
 # Project     : Erp4iOS
 # Author      : Jamesholy
 # Created     : 2017/9/18
 # Corporation : 成都好房通科技股份有限公司
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>

typedef void(^LeftClickBlock)(NSString *text);
typedef void(^RightClickBlock)(NSString *text);
typedef void(^CloseClickBlock)(void);
typedef void(^DismissClickBlock)(void);

@interface XKCommonAlertInputView : UIView

- (instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder maxNum:(NSInteger)maxNum message:(NSString *)messageString leftButton:(NSString *)leftButtonString rightButton:(NSString *)rightButtonString leftBlock:(LeftClickBlock)leftBlock rightBlock:(RightClickBlock)rightBlock isBeginFirstResponder:(BOOL)beginFirstResponder;

- (instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder maxNum:(NSInteger)maxNum message:(NSString *)messageString leftButton:(NSString *)leftButtonString rightButton:(NSString *)rightButtonString leftBlock:(LeftClickBlock)leftBlock rightBlock:(RightClickBlock)rightBlock  closeBlock:(CloseClickBlock)closeBlock isBeginFirstResponder:(BOOL)beginFirstResponder;
/**
 *  弹框
 */
- (void)show;

/**
 *  设置左边按钮颜色
 *
 *  @param leftButtonColor 左边按钮颜色
 */
- (void)setLeftButtonColor:(UIColor *)color;

/**
 *  设置右边按钮颜色
 *
 *  @param rightButtonColor 右边按钮颜色
 */
- (void)setRightButtonColor:(UIColor *)color;

/**
 *  设置标题颜色
 *
 *  @param titleColor 标题颜色
 */
- (void)setTitleColor:(UIColor *)color;

/**
 *  设置背景颜色
 *
 *  @param color 背景颜色
 */
- (void)setBGColor:(UIColor *)color;

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
@end

