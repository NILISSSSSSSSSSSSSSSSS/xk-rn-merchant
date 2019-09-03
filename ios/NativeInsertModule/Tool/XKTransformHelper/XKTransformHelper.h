//
//  XKTransformHelper.h
//  XKSquare
//
//  Created by Apple on 2018/7/31.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKTransformHelper : NSObject

/**
 *  data转string
 *
 *  @param data 传入的参数
 *
 *  @return 返回的值
 */
+ (NSString*)stringByData:(NSData *)data;

/**
 *  字典转string
 *
 *  @param jsonDict 传入的参数
 *
 *  @return 返回的值
 */

+ (NSString*)stringByJsonDict:(NSDictionary *)jsonDict;

/**
 *  string转字典
 *
 *  @param jsonString 传入的参数
 *
 *  @return 返回的值
 */

+ (NSDictionary *)dictByJsonString:(NSString *)jsonString;

/**
 *  data转字典
 *
 *  @param data 传入的参数
 *
 *  @return 返回的值
 */

+ (NSDictionary *)dictByJsonData:(NSData *)data;

/**
 *  字符串解密base64
 *
 *  @param base64Str 传入的参数
 *
 *  @return 返回的值
 */

+ (NSString *)stringFromBase64String:(NSString *)base64Str;

/**
 *  字符串加密base64
 *
 *  @param string 传入的参数
 *
 *  @return 返回的值
 */

+ (NSString *)base64StringFromText:(NSString *)string;

/**
 *  base64字符串解码data
 *
 *  @param string 传入的参数
 *
 *  @return 返回的值
 */

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;


/**
 jsonString转字典

 @param jsonStr 字符串
 @return 字典
 */
+ (NSArray *)jsonStringToArr:(NSString *)jsonStr;
@end
