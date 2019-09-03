/*******************************************************************************
 # File        : XKReplyForGoodsModel.h
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
@class XKCommentForGoodsModel;

@interface XKReplyForGoodsModel : XKReplyBaseInfo

@property (nonatomic , strong) XKCommentForGoodsModel    *comment;

@end
