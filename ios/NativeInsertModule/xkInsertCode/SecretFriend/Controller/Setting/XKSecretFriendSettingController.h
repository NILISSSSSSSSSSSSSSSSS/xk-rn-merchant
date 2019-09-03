/*******************************************************************************
 # File        : XKSecretFriendSettingController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/10
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

@interface XKSecretFriendSettingController : BaseViewController

/***/
@property(nonatomic, copy) NSString *secretId;
/**用户id*/
@property(nonatomic, copy) NSString *userId;

/**修改回调*/
@property(nonatomic, copy) void(^changeInfo)(UIViewController *settingVC);
@property(nonatomic, copy) void(^deleteBlock)(UIViewController *settingVC);

@end
