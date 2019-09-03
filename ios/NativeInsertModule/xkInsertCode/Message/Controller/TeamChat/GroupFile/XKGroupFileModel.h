/*******************************************************************************
 # File        : XKGroupFileModel.h
 # Project     : xkMerchant
 # Author      : Jamesholy
 # Created     : 2019/2/18
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

@interface XKGroupFileModel : NSObject<YYModel>

@property (nonatomic , copy) NSString              * tid;
@property (nonatomic , copy) NSString              * updatedAt;
@property (nonatomic , copy) NSString              * fileName;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * username;
@property (nonatomic , copy) NSString              * uploadUserId;
@property (nonatomic , copy) NSString              * fileUrl;
@property (nonatomic , copy) NSString              * fileSize;
@property (nonatomic , copy) NSString              * userTeamIdentity;
@property (nonatomic , copy) NSString              * icon;

@end
