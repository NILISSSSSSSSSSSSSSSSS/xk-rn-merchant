/*******************************************************************************
 # File        : XKReplyForWelfareModel.h
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
@class XKCommentForWelfareModel;
@interface XKReplyForWelfareModel : XKReplyBaseInfo
@property (nonatomic , strong) XKCommentForWelfareModel    *comment;
@end
