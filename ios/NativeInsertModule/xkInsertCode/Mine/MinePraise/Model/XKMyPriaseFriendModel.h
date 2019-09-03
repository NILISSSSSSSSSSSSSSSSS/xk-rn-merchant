/*******************************************************************************
 # File        : XKMyPriaseFriendModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/14
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendTalkModel.h"
#import "XKFavorBaseModel.h"

@interface XKMyPriaseFriendModel : XKFavorBaseModel
@property(nonatomic, strong) XKFriendTalkModel *dynamic;
@end

