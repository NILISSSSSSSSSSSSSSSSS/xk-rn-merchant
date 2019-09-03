/*******************************************************************************
 # File        : XKFriendCircleGiftModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/14
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGiftBaseModel.h"

@interface XKFriendCircleGiftModel : XKGiftBaseModel

@end


@interface XKFriendGiftReceiver:NSObject
/**<##>*/
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *content;
@end
