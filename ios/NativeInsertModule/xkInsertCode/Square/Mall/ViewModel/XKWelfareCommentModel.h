/*******************************************************************************
 # File        : XKWelfareCommentModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/22
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKWithImgBaseModel.h"
#import "XKContactModel.h"
#import "XKCommentForGoodsModel.h"
#import "XKCommentForWelfareModel.h"
@interface XKWelfareCommentModel : XKWithImgBaseModel

@property(nonatomic, strong) XKContactModel        * commenter;
@property(nonatomic, strong) XKWelfareInfo           * goods;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSArray               * pictures;
@property (nonatomic , strong) XKMediaInfo           * video;
@property (nonatomic , copy) NSString              * score;
@property (nonatomic , copy) NSString              * replyCount;
@property (nonatomic , copy) NSString              * createdAt;
@property (nonatomic , copy) NSString              * commentId;
- (NSString *)getDisplayTime ;

@end

