/*******************************************************************************
 # File        : XKCommentBaseInfo.h
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

#import "XKContactModel.h"
#import "XKUploadMediaInfo.h"

@interface XKMediaInfo:NSObject
/**<##>*/
@property(nonatomic, copy) NSString *mainPic;
@property(nonatomic, assign) BOOL isPic;
@property(nonatomic, copy) NSString *url;
@end

@interface XKCommentBaseInfo : NSObject <YYModel>

@property(nonatomic, strong) XKContactModel        * commenter;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSArray               * pictures;
@property (nonatomic , strong) XKMediaInfo           * video;
@property (nonatomic , copy) NSString              * score;
@property (nonatomic , copy) NSString              * replyCount;
@property (nonatomic , copy) NSString              * createdAt;
@property (nonatomic , copy) NSString              * commentId;

/**展开收起状态*/
@property(nonatomic, assign) BOOL showAllImg;
/**图片数组*/
@property(nonatomic, copy) NSArray <XKMediaInfo *>*imgsArray;

- (NSString *)getDisplayTime;
@end
