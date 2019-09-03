/*******************************************************************************
 # File        : XKNewFriendController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/17
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

@interface XKNewFriendController : BaseViewController

/***/
@property(nonatomic, copy) void(^friendStatusChange)(void);
@end
