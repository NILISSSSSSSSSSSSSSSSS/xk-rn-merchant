/*******************************************************************************
 # File        : XKCommentDetailBaseViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/31
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import "XKCommentForGoodsModel.h"

typedef NS_ENUM(NSInteger,XKCommentDetailType) {
    XKCommentDetailTypeGoods = 0 , // 商品
    XKCommentDetailTypeCicle , // 商圈
    XKCommentDetailTypeWelfare // 福利
};

@interface XKCommentDetailBaseViewModel : NSObject

@property(nonatomic, assign) XKCommentDetailType detailType;
@property(nonatomic, copy) NSString *commentId;

/**<##>*/
@property(nonatomic, assign) RefreshDataStatus refreshStatus;
/**商品评论model*/
@property(nonatomic, strong) XKCommentBaseInfo *detailInfo;
/**评论列表*/
@property(nonatomic, strong) NSMutableArray *commentArray;

- (NSString *)getReplyUrl;

/**请求详情*/
- (void)requestDetailInfoComplete:(void(^)(NSString *error,id data))complete;

/**请求评论详情*/
- (void)requestIsRefresh:(BOOL)isRefresh complete:(void(^)(NSString *error, id data))complete;


@end
