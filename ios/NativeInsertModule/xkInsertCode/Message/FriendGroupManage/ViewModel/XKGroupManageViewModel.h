/*******************************************************************************
 # File        : XKGroupManageViewModel.h
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

#import <Foundation/Foundation.h>
#import "XKFriendGroupModel.h"
@interface XKGroupManageViewModel : NSObject

/**s*/
@property(nonatomic, strong) NSMutableArray <XKFriendGroupModel *>*dataArray;
/**是否是密友圈*/
@property(nonatomic, assign) BOOL isSecret;
/**密友圈id*/
@property(nonatomic, copy) NSString *secretId;
/**mode  0 分组管理 1 标签管理*/
@property(nonatomic, assign) BOOL isTag;

/**默认选中id 1 选择模式下设置*/
@property(nonatomic, copy) NSString *defaultGroupId;

/**是否发送通知*/
@property(nonatomic, assign) BOOL isSendNotification;

/**请求列表*/
- (void)requestListComplete:(void(^)(NSString *error,id data))complete;
/**创建分组*/
- (void)requestCreateGroupName:(NSString *)name complete:(void(^)(NSString *error,id data))complete;
/**修改分组名称*/
- (void)requestModifyGroupName:(NSString *)name groupId:(NSString *)groupId complete:(void(^)(NSString *error,id data))complete;
/**删除分组*/
- (void)requestDeleteGroup:(NSString *)groupId complete:(void(^)(NSString *error,id data))complete;
/**请求交换*/
- (void)requestExchangeComplete:(void(^)(NSString *error,id data))complete;
@end
