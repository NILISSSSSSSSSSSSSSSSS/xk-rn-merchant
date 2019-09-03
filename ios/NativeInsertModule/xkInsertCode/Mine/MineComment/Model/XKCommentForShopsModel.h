/*******************************************************************************
 # File        : XKCommentForShopsModel.h
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

#import "XKCommentBaseInfo.h"
#import "XKCommentForGoodsModel.h"

@interface XKCommentForShopsModel : XKCommentBaseInfo
@property(nonatomic, strong) XKGoodsInfo *goods;
@property(nonatomic, strong) XKCommentMallReply *shopReplier;
@end

