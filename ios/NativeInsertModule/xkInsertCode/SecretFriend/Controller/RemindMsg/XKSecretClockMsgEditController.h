/*******************************************************************************
 # File        : XKSecretClockMsgEditController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/12
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
#import "XKSecretTipEditController.h"

@interface XKSecretClockMsgEditController : BaseViewController

/**<##>*/
@property(nonatomic, copy) NSString *secretId;

/**<##>*/
@property(nonatomic, strong) XKSecretTipMsg *msgClockInfo;

/**<##>*/
@property(nonatomic, copy) void(^editSuccess)(void);

@end
