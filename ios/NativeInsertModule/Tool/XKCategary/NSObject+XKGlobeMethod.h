//
//  NSObject+XKGlobeMethod.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XKGlobeMethod)

/**
 获取随机数

 @param num 随机数的位数
 @return 返回随机数
 */
- (NSString *)getRandomStringWithNum:(NSInteger)num;


/**
 判断E-mail

 @param email E-mail
 @return 是否是E-mail
 */
- (BOOL)checkEmail:(NSString *)email;

/**
 判断mobile
 
 @param mobile mobile
 @return 是否是mobile
 */
- (BOOL)checkMobile:(NSString *)mobile;
/**
 判断车牌号
 
 @param carNo 车牌号
 @return 是否是车牌号
 */
- (BOOL)checkCarNo:(NSString *)carNo;


/**
 判断纯数字
 
 @param text 文本
 @return 是否是数字
 */
- (BOOL)checkNumberOnly:(NSString *)text;

/**
 密码输入规则

 @param string 密码
 @return 是否符合需求
 */
- (BOOL)checkNewPassword:(NSString*)string;

- (BOOL)checkPassword:(NSString *)passWord;

- (BOOL)checkName:(NSString *)name;

+ (void)swizzleMethod:(Class)class orgSel:(SEL)originalSelector swizzSel:(SEL)swizzledSelector;
@end
