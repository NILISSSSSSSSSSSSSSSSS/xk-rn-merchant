/*******************************************************************************
 # File        : XKFavorVideoModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/26
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFavorBaseModel.h"

@class XKVideoLikeContent;
@interface XKFavorVideoModel : XKFavorBaseModel
@property(nonatomic, strong) XKVideoLikeContent *video;
@end

@interface XKVideoLikeContent :NSObject
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , copy) NSString              * userId;
//@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * describe;
@property (nonatomic , copy) NSString              * videoId;
@property (nonatomic , copy) NSString              * updatedAt;
@property (nonatomic , copy) NSString              * createdAt;
@property (nonatomic , copy) NSString              * likeCount;
@property (nonatomic , copy) NSString              * showPic;
@property (nonatomic , copy) NSString              * commentCount;

@end
