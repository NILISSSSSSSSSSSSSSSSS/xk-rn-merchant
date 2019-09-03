/*******************************************************************************
 # File        : XKGroupChatSettingViewController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/29
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
#import "XKGroupChatSettingViewModel.h"
#import <NIMSDK/NIMSDK.h>
@interface XKGroupChatSettingViewController : BaseViewController

/**修改回调*/
@property(nonatomic, copy) void(^groupInfoChange)(XKGroupChatSettingModel *setting);
//当前群session
@property(nonatomic, strong) NIMSession *session;
/**<##>*/
@property(nonatomic, assign) BOOL isOffical;
@property (nonatomic, copy) NSString  *merchantType;

@end
