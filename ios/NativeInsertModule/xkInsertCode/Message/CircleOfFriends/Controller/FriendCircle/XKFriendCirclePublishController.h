/*******************************************************************************
 # File        : XKFriendCirclePublishController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/8
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

@interface XKFriendCirclePublishController : BaseViewController

/***/
@property(nonatomic, copy) void(^publishSuccess)(void);

@end
