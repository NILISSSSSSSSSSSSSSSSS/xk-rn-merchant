/*******************************************************************************
 # File        : XKContactBaseViewModel.h
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

@interface XKFriendSettingController : BaseViewController
/**用户id*/
@property(nonatomic, copy) NSString *userId;


/**是否是是商户群设置禁言的业务
 */
@property(nonatomic, assign) BOOL isOfficalTeam;
@property(nonatomic, copy) NSString *teamId;

/**修改回调*/
@property(nonatomic, copy) void(^changeInfo)(UIViewController *settingVC);
@property(nonatomic, copy) void(^deleteBlock)(UIViewController *settingVC);
@end
