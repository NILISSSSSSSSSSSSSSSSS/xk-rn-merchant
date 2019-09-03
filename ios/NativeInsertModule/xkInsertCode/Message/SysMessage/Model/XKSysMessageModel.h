//
//  XKSysMessageModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/11/23.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKSysMessageModel : NSObject
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * accid;
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * token;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              *createdAt;
@property (nonatomic , copy) NSString              *updatedAt;
@end

NS_ASSUME_NONNULL_END
