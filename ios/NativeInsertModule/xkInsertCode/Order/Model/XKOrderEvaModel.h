/*******************************************************************************
 # File        : XKOrderEvaModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/5
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>
#import "XKUploadMediaInfo.h"
@class XKOrderEvaStarInfo;

@interface XKOrderEvaModel : NSObject

@property(nonatomic, strong) id goodsInfo;
/**评价文本*/
@property(nonatomic, copy) NSString *commentText;
/**评论的图片视频信息*/
@property(nonatomic, strong) NSMutableArray<XKUploadMediaInfo *> *mediaInfoArr;
/**评分数组 没有评分就不传*/
@property(nonatomic, strong) NSArray<XKOrderEvaStarInfo *> *evaStarArr;
//自营订单评论
+ (void)submitOrderCommentWithParm:(NSDictionary *)parmDic Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;
//货物意见反馈
+ (void)submitGoodsOpinionWithParm:(NSDictionary *)parmDic Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;
//福利订单换货
+ (void)submitGoodsChangeWithParm:(NSDictionary *)parmDic Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;
@end


@interface XKOrderEvaStarInfo:NSObject

/**title*/
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, assign) NSInteger starNum;
@property(nonatomic, copy) NSString *des;
@end

