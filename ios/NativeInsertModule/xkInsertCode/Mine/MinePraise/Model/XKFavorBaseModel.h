/*******************************************************************************
 # File        : XKFavorBaseModel.h
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

#import "XKWithImgBaseModel.h"
#import "XKContactModel.h"

@interface XKFavorBaseModel :XKWithImgBaseModel

/**<##>*/
@property(nonatomic, strong) XKContactModel *liker;
@property(nonatomic, strong) XKContactModel *author;

- (NSString *)getDisplayTime;

@end

