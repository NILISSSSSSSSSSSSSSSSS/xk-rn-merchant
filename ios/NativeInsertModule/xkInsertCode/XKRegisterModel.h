/*******************************************************************************
 # File        : XKRegisterModel.h
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/17
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



@interface UserImAccount :NSObject
@property (nonatomic , copy) NSString              * accid;
@property (nonatomic , copy) NSString              * token;

@end


@interface XKRegisterModel : NSObject
@property (nonatomic , strong) UserImAccount       * userImAccount;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * token;
@property (nonatomic , copy) NSString              * securityCode;
@property (nonatomic , copy) NSString              * address;
@property (nonatomic , copy) NSString              * age;
@property (nonatomic , copy) NSString              * birthday;
@property (nonatomic , copy) NSString              * constellation;
@property (nonatomic , copy) NSString              * qrCode;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * signature;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * realPhone;
@property (nonatomic , strong) NSArray             <NSDictionary *> *merchant;
@property (nonatomic , assign) BOOL               isAdmin; // 是否是联盟商


@end

