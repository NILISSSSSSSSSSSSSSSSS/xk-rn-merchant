/*******************************************************************************
 # File        : XKReplyForShopsModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/1
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKReplyBaseInfo.h"
#import "XKCommentForShopsModel.h"
@interface XKReplyForShopsModel : XKReplyBaseInfo
@property(nonatomic, strong) XKCommentForShopsModel *comment;
@end
