/*******************************************************************************
 # File        : XKSecretCircleInfo.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/5
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

@interface XKSecretCircleInfo : NSObject <YYModel>

@property (nonatomic , copy) NSString              * secretId;
@property (nonatomic , copy) NSString              * secretName;
@property (nonatomic , copy) NSString              * updatedAt;
@property (nonatomic , copy) NSString              * nicknamePy;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * erCode;
@property (nonatomic , copy) NSString              * provinceCode;
@property (nonatomic , copy) NSString              * cityCode;
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * districtCode;
@property (nonatomic , copy) NSString              * birthday;
@property (nonatomic , copy) NSString              * secretPwd;
@property (nonatomic , copy) NSString              * signature;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * createdAt;
@property (nonatomic , assign) BOOL                 outside;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSArray               * groupLists;
@end
