/*******************************************************************************
 # File        : XKRealNameAuthController.h
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

#import "BaseViewController.h"

@interface XKRealNameAuthController : BaseViewController

/**提交成功回调*/
@property(nonatomic, copy) void(^sumbitCompelete)(void);

@end
