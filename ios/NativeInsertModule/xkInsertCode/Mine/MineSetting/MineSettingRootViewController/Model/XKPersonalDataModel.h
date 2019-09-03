/*******************************************************************************
 # File        : XKPersonalDataModel.h
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/19
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

@interface XKPersonalDataModel : NSObject

@property (nonatomic, copy) NSString               *nickname;
@property (nonatomic, copy) NSString               *avatar;
@property (nonatomic, copy) NSString               *sex;
@property (nonatomic, copy) NSString               *birthday;
@property (nonatomic, copy) NSString               *signature;
@property (nonatomic, copy) NSString               *phone;
@property (nonatomic , copy) NSString              *channel;
@property (nonatomic , assign) NSInteger            createdAt;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * nicknamePy;
@property (nonatomic , copy) NSString              * platform;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString             * uid;
@property (nonatomic , assign) NSInteger              updatedAt;
@property (nonatomic , copy) NSString               *referralCode;
@property (nonatomic , copy) NSString                *address;
- (NSString *)birthdayDes;

- (NSString *)sexDes;

@end
