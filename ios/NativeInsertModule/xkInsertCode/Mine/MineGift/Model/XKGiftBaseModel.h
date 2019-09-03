/*******************************************************************************
 # File        : XKGiftBaseModel.h
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
@class XKGiftInfoModel;
@interface XKGiftBaseModel : XKWithImgBaseModel <YYModel>

@property(nonatomic, copy) NSString *giverUserId;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *dateTime;
@property(nonatomic, copy) NSArray<XKGiftInfoModel *> *gift;

- (NSArray *)getGiftArr;
@end

@interface XKGiftInfoModel:NSObject
@property(nonatomic, copy) NSString *number;
@property(nonatomic, copy) NSString *name;
@end
