/*******************************************************************************
 # File        : XKRealNameInfoModel.h
 # Project     : XKSquare
 # Author      : Lin Li
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

#import <Foundation/Foundation.h>

@interface XKRealNameInfoModel : NSObject
@property (nonatomic , copy) NSString              * acceptId;
@property (nonatomic , copy) NSString              * authStatus;
@property (nonatomic , copy) NSString              * authTips;
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , copy) NSString              * holdIdCardImage;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * idCardNum;
@property (nonatomic , copy) NSString              * realName;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , assign) NSInteger              updatedAt;
@property (nonatomic , copy) NSString              * userId;
@end
