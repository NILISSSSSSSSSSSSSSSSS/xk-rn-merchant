/*******************************************************************************
 # File        : XKFriendCircleDetailViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/18
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

@interface XKFriendCircleDetailViewModel : XKFriendCircleBaseViewModel

/**<##>*/
@property(nonatomic, assign) BOOL infoChange;
/**<##>*/
@property(nonatomic, copy) NSString *did;

/**<##>*/
@property(nonatomic, copy) void(^deleteClick)(void);

/**请求列表*/
- (void)requestCompleteBlock:(void (^)(id error,id data))completeBlock;

@end
