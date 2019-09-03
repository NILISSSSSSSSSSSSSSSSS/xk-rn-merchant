/*******************************************************************************
 # File        : XKReplyForVideoModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/27
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
#import <UIKit/UIKit.h>
#import "XKCommentForVideoModel.h"
#import "XKReplyBaseInfo.h"

@interface XKReplyForVideoModel : XKReplyBaseInfo

@property (nonatomic , strong) XKCommentForVideoModel      * comment;

@end
