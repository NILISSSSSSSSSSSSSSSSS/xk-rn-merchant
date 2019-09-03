/*******************************************************************************
 # File        : XKCommentReplyCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/12
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCommentCommonCell.h"

@interface XKCommentReplyCell : XKCommentCommonCell

/**回复按钮点击事件*/
@property(nonatomic, copy) void(^replyClick)(NSIndexPath *indexPath);

@end
