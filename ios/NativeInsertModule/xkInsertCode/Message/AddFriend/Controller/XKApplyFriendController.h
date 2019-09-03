/*******************************************************************************
 # File        : XKApplyFriendController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/26
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

@interface XKApplyFriendController : BaseViewController

/**点击*/
@property(nonatomic, copy) void(^applyComplete)(void);
/**申请id*/
@property(nonatomic, copy) NSString *applyId;

/**密友圈 传入代表是密友*/
@property(nonatomic, assign) BOOL isSecret;
@property(nonatomic, copy) NSString *secretId;

@end
