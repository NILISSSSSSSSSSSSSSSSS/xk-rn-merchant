/*******************************************************************************
 # File        : XKSearchFriendController.h
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

@interface XKSearchFriendController : BaseViewController
@property(nonatomic, assign) BOOL isSecret;
@property(nonatomic, copy) NSString *secretId;
@end
