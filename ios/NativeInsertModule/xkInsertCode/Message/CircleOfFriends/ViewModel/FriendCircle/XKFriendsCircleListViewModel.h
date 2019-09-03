/*******************************************************************************
 # File        : XKFriendsCircleListViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/8/24
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
#import "XKFriendCircleBaseViewModel.h"
#import "XKSquareFriendsCirclelModel.h"

@interface XKFriendsCircleListViewModel : XKFriendCircleBaseViewModel

/**请求列表*/
- (void)requestRefresh:(BOOL)refresh complete:(void (^)(id error,id data))completeBlock;

@end
