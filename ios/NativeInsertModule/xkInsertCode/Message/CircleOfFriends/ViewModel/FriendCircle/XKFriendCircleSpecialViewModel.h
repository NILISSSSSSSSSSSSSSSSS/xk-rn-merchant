/*******************************************************************************
 # File        : XKFriendCircleSpecialViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/19
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendCircleBaseViewModel.h"
#import "XKContactModel.h"
@interface XKFriendCircleSpecialViewModel : XKFriendCircleBaseViewModel
@property(nonatomic, assign) BOOL isFetchNet;
/**是否是嵌入个人详情的的*/
@property(nonatomic, assign) BOOL isInsertPersonalVC;
/**<##>*/
@property(nonatomic, strong) XKContactModel *userInfo;

@property(nonatomic, copy) NSString *userId;

/**标记为需要刷新回调*/
@property(nonatomic, copy) void(^needRequestRefresh)(void);

/**请求列表*/
- (void)requestRefresh:(BOOL)isRefresh complete:(void (^)(id error,id data))complete;
@end
