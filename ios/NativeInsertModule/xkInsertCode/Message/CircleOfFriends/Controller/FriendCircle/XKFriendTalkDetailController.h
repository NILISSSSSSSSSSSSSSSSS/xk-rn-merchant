/*******************************************************************************
 # File        : XKFriendTalkDetailControllerViewController.h
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

#import "BaseViewController.h"
@class XKFriendTalkModel;

@interface XKFriendTalkDetailController : BaseViewController
/**<##>*/
@property(nonatomic, copy) NSString *did;

/***/
@property(nonatomic, copy) void(^talkDetailChange)(XKFriendTalkModel *talkModel);
@property(nonatomic, copy) void(^deleteClick)(XKFriendTalkModel *talkModel);

@end
