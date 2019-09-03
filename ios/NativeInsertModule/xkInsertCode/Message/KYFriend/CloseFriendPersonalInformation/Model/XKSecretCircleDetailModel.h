//
//  XKSecretCircleDetailModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKSecretCircleDetailModel : NSObject
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * birthday;
@property (nonatomic , copy) NSString              * cityCode;
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , copy) NSString              * districtCode;
@property (nonatomic , copy) NSString              *erCode;
@property (nonatomic , copy) NSString              * secretId;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * nicknamePy;
@property (nonatomic , assign) NSInteger              outside;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * provinceCode;
@property (nonatomic , copy) NSString              * secretName;
@property (nonatomic , copy) NSString              * secretPwd;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * signature;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , assign) NSInteger              updatedAt;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * address;

- (NSString *)birthdayDes;

- (NSString *)sexDes;
@end

NS_ASSUME_NONNULL_END
