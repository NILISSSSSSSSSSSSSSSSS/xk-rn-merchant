//
//  XKJPushLoginModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKJPushLoginModel : NSObject

/**
 用户名字
 */
@property (nonatomic, copy) NSString *name;

/**
 用户头像
 */
@property (nonatomic, copy) NSString *iconurl;

/**
 用户性别
 */
@property (nonatomic, assign) NSInteger gender;

/**
 openid
 */
@property (nonatomic, copy) NSString *openid;
/**
 unionid
 */
@property (nonatomic, copy) NSString *unionid;
@end
