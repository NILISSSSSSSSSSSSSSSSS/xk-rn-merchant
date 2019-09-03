/*******************************************************************************
 # File        : XKSecretGroupMangeController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/9
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
#import "XKFriendGroupModel.h"
@interface XKGroupManageController : BaseViewController
/**useType  0 管理模式 1 选择模式*/
@property(nonatomic, assign) NSInteger userType;

/**mode  0 分组管理 1 标签管理*/
@property(nonatomic, assign) NSInteger mode;

/**是否是密友业务*/
@property(nonatomic, assign) BOOL isSecret;
@property(nonatomic, copy) NSString *secretId;

/**默认选中id  选择模式下可设置*/
@property(nonatomic, copy) NSString *defaultGroupId;
/**选中回调*/
@property(nonatomic, copy) void(^chooseBlock)(XKFriendGroupModel *group, XKGroupManageController *grVC);
@end
