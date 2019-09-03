/*******************************************************************************
 # File        : XKAddFriendController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/15
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

@interface XKAddFriendController : BaseViewController

/**密友业务时必传*/
@property(nonatomic, assign) BOOL isSecret;
@property(nonatomic, copy) NSString * secretId;

@end
