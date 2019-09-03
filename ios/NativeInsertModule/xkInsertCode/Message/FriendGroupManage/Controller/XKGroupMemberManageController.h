/*******************************************************************************
 # File        : XKGroupMemberManagController.h
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

#import "XKContactBaseController.h"

@interface XKGroupMemberManageController : XKContactBaseController

/**是否是密友圈*/
@property(nonatomic, assign) BOOL isSecret;
@property(nonatomic, copy) NSString *secretId;
/**<##>*/
@property(nonatomic, copy) void(^memberChange)(void);

/**0 分组 1 标签*/
@property(nonatomic, assign) NSInteger mode;
/**id*/
@property(nonatomic, copy) NSString *groupId;
@end
