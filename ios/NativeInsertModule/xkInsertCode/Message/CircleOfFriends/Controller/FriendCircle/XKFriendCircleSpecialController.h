/*******************************************************************************
 # File        : XKFriendCircleSpecialController.h
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

#import "BaseViewController.h"

@interface XKFriendCircleSpecialController : BaseViewController
/**是否是嵌入个人详情的*/
@property(nonatomic, assign) BOOL isInsertPersonalVC;
@property(nonatomic, copy) NSString *userId;
@end
