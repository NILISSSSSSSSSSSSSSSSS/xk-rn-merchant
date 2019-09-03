/*******************************************************************************
 # File        : XKVisibleAuthorityController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/16
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
#import "XKVisiblelAuthorityInfo.h"

@interface XKVisibleAuthorityController : BaseViewController

/**第二次进入时传入*/
@property(nonatomic, strong) XKVisiblelAuthorityResult *result;

/**结果回调*/
@property(nonatomic, copy) void(^resultBlock)(XKVisiblelAuthorityResult *result);

@end
