//
//  XKVideoSearchUserModel.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoSearchUserModel : NSObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *signature;

@property (nonatomic, copy) NSString *fansCount;
// 0我未关注他 1我已关注他 2相互关注
@property (nonatomic, assign) NSUInteger followRelation;

@end

NS_ASSUME_NONNULL_END
