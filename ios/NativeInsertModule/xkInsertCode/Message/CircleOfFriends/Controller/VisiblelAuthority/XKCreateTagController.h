/*******************************************************************************
 # File        : XKCreateTagController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/17
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
#import "XKContactModel.h"
#import "XKFriendGroupModel.h"

@interface XKCreateTagController : BaseViewController
/**<##>*/
@property(nonatomic, copy) NSArray<XKContactModel *> *userArray;
/**保存成功回调*/
@property(nonatomic, copy) void(^successBlock)(XKFriendGroupModel *groupInfo);
@end
