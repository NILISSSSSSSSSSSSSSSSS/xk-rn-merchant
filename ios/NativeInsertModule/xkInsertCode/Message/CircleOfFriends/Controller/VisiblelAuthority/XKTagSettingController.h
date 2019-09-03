/*******************************************************************************
 # File        : XKTagSettingController.h
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

#import "XKContactBaseController.h"
#import "XKFriendGroupModel.h"
@interface XKTagSettingController : XKContactBaseController

/**标签id*/
@property(nonatomic, copy) NSString *tagId;
/**修改完成回调*/
@property(nonatomic, copy) void(^changeBlock)(XKFriendGroupModel *model);

@end
