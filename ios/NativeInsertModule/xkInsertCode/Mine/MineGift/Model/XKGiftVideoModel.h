/*******************************************************************************
 # File        : XKGiftVideoModel.h
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

#import "XKGiftBaseModel.h"
@class XKGiftVideoReceiver;

@interface XKGiftVideoModel : XKGiftBaseModel
@property(nonatomic, strong) XKGiftVideoReceiver *receiver;
@end

@interface XKGiftVideoReceiver:NSObject
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *content;
@end
