/*******************************************************************************
 # File        : XKMineCommentInputController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/12
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

@interface XKMineCommentInputController : BaseViewController

/**获取请求参数*/
@property(nonatomic, copy) NSDictionary *(^getParmas)(void);

@end
