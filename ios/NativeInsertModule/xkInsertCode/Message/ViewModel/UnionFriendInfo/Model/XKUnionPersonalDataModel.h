//
//  XKUnionPersonalDataModel.h
//  XKSquare
//
//  Created by Lin Li on 2019/5/6.
//  Copyright © 2019 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKUnionPersonalDataModel : NSObject
@property (nonatomic, copy) NSString               *nickname;
@property (nonatomic, copy) NSString               *avatar;
@property (nonatomic, copy) NSString               *sex;
@property (nonatomic, copy) NSString               *birthday;
@property (nonatomic, copy) NSString               *signature;
@property (nonatomic, copy) NSString               *age;
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
/**<##>*/
@property(nonatomic, assign) BOOL showInfomation;
- (NSString *)birthdayDes;

- (NSString *)sexDes;
@end

NS_ASSUME_NONNULL_END
