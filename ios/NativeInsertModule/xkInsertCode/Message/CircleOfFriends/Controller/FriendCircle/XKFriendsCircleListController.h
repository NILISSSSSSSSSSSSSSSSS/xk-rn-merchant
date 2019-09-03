/*******************************************************************************
 # File        : XKFriendsCircleListController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/8/24
 # Corporation : 水木科技
 # Description :
 带日期的朋友圈
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "BaseViewController.h"

@interface XKFriendsCircleListController : BaseViewController <RootChildControllerProtocol>

/**请求第一页后的回调*/
@property (nonatomic, copy  ) void(^requestFirstPageSuccess)(void);
@property (nonatomic, assign) BOOL showNaviBar;

- (void)refreshList;

@end
