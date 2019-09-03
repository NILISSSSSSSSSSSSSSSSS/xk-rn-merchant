/*******************************************************************************
 # File        : XKInputTextView.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/11
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>

@interface XKInputTextView : UIView
/**字数*/
@property (nonatomic, strong,readonly) UILabel *countLabel;
/**文字内容*/
@property (nonatomic, copy, readonly) NSString *contentText;
/**字数限制*/
@property (nonatomic, assign) NSInteger limitNumber;
/**占位符*/
@property (nonatomic, copy) NSString *placeholderText;
/**文本变化的回调*/
@property (nonatomic, copy) void (^textDidChangeBlock)(NSString *text);
/**textView*/
@property (nonatomic, strong, readonly) UITextView *inputTextView;

/**
 配置初始文本
 */
- (void)configInitText:(NSString *)text;
/**
 弹出键盘
 */
- (void)showKeybord;

@end
