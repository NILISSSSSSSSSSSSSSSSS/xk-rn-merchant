/*******************************************************************************
 # File        : XKGlobalSearchController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/6
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

@interface XKGlobalSearchController : BaseViewController

/**<##>*/
@property(nonatomic, assign) BOOL isSecret;
@property(nonatomic, copy) NSString *secretId;
/**不包含陌生人*/
@property(nonatomic, assign) BOOL justSearchFriend;

@end
