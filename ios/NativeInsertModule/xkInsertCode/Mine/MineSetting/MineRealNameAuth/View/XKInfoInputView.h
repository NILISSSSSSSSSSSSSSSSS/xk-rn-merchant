/*******************************************************************************
 # File        : XKInfoInputView.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/6
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

typedef NS_ENUM(NSInteger,XKInfoInputViewType) {
    XKInfoInputViewTypeNormal = 0, // 普通 普通时限制字数有用
    XKInfoInputViewTypeIdCard,  // 身份证
    XKInfoInputViewTypePhone,  // 手机号
};

@interface XKInfoInputView : UIView

/**title*/
@property(nonatomic, copy) NSString *title;
/**placeHolder*/
@property(nonatomic, copy) NSString *placeHolder;
/**text*/
@property(nonatomic, copy) NSString *text;
/**标题宽度*/
@property(nonatomic, assign) CGFloat width;
/**maxNum  type = XKInfoInputViewTypeNormal 时生效*/
@property(nonatomic, assign) NSInteger maxNum;
/**<##>*/
@property(nonatomic, assign) XKInfoInputViewType type;
/**<##>*/
@property(nonatomic, copy) void(^textChange)(NSString *text);




@property(nonatomic, strong,readonly) UITextField *textField;
@property(nonatomic, strong, readonly) UILabel *titleLabel;

@end
