/*******************************************************************************
 # File        : XKContactListViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/10
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>
#import "XKContactBaseViewModel.h"

@interface XKContactBlackListViewModel :XKContactBaseViewModel

/**<##>*/
@property(nonatomic, copy) void(^remove)(NSIndexPath *indexPath);

- (void)removeBlackList:(NSIndexPath *)indexPath complete:(void (^)(NSString *, id))complete;
- (void)requestComplete:(void(^)(NSString *error,NSArray *array))complete;

@end
