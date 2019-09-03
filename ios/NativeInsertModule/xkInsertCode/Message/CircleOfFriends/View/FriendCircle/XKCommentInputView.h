/*******************************************************************************
 # File        : CommentInputView.h
 # Project     : ErpApp
 # Author      : Jamesholy
 # Created     : 2018/2/8
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

@interface XKCommentInputView : UIView

+ (instancetype)inputView;
/**设置占位 会加@   显示ex ： 回复xxx*/
- (void)setAtUserName:(NSString *)userName;
/**显示占位 不会帮加@*/
- (void)setPlaceHolderText:(NSString *)text;
- (void)setOriginText:(NSString *)orignText;
/**确定的回调 */
@property(nonatomic, copy) void(^sureClick)(NSString *text);
/**文本变化的的回调 */
@property(nonatomic, copy) void(^textChange)(NSString *text);
/**自动隐藏*/
@property(nonatomic, assign) BOOL autoHidden;
@property(nonatomic, copy) NSString *sendBtnText;
- (void)beginEditing;
- (void)endEditing;
@end

@interface XKCommentInputInfo: NSObject
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *did; // 动态id
@property(nonatomic, assign) BOOL isReply; // 是否是回复人
@property(nonatomic, copy) NSString *replyId; // 回复人
@property(nonatomic, strong) NSIndexPath *indexPath;
@end
