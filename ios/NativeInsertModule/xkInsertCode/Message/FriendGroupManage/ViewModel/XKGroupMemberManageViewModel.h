/*******************************************************************************
 # File        : XKGroupMemberManageViewModel.h
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

#import "XKContactBaseViewModel.h"

@interface XKGroupMemberManageViewModel : XKContactBaseViewModel

/**id*/
@property(nonatomic, copy) NSString *groupId;
/**id*/
@property(nonatomic, copy) NSString *secretId;
/**0 分组 1 标签*/
@property(nonatomic, assign) NSInteger isTag;

/**<##>*/
@property(nonatomic, copy) void(^remove)(NSIndexPath *indexPath);

- (void)requestComplete:(void(^)(NSString *error,NSArray *array))complete;
- (void)removeList:(NSIndexPath *)indexPath complete:(void (^)(NSString *, id))complete;
- (void)addMembers:(NSArray *)array complete:(void (^)(NSString *, id))complete;

@end
