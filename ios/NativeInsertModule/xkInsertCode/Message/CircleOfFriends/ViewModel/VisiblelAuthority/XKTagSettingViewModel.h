/*******************************************************************************
 # File        : XKTagSettingViewModel.h
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

#import "XKContactBaseViewModel.h"
#import "XKFriendGroupModel.h"

@interface XKTagSettingViewModel : XKContactBaseViewModel

@property(nonatomic, strong) XKFriendGroupModel *model;
/**标签id*/
@property(nonatomic, copy) NSString *tagId;
@property(nonatomic, copy) void(^remove)(NSIndexPath *indexPath);

- (void)requestComplete:(void (^)(NSString *, NSArray *))complete;

@end
