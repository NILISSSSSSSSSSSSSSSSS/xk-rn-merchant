/*******************************************************************************
 # File        : XKCommentForGoodsModel.h
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

#import "XKCommentBaseInfo.h"
@class XKGoodsInfo,XKCommentMallReply;

@interface XKCommentForGoodsModel : XKCommentBaseInfo
@property(nonatomic, strong) XKGoodsInfo *goods;
@property(nonatomic, strong) XKCommentMallReply *mallReply;

@end

@interface XKCommentMallReply: NSObject
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * createdAt;
@property (nonatomic , copy) NSArray               * pictures;
@end

@interface XKGoodsInfo:NSObject<YYModel>
@property (nonatomic , copy) NSString              * count;
@property (nonatomic , copy) NSString              * mainPic;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * price;
@property (nonatomic , copy) NSString              * skuValue;
@property (nonatomic , copy) NSString              * skuCode;
@property (nonatomic , copy) NSString              * goodsId;
@end
