//
//  XKQRCodeResultManager.h
//  XKSquare
//
//  Created by Lin Li on 2018/11/14.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKQRCodeResultManager : NSObject


/**
 注册时扫描二维码返回安全码
 
 @param resultString 扫描回来的数据
 @return 处理过后的字典
 */
+ (NSMutableDictionary *)registerQrResult:(NSString *)resultString;

/**
 根据二维码类型处理跳转
 
 @param resultString 扫描回来的数据
 */
+ (void)dealResult:(NSString *)resultString;
@end

NS_ASSUME_NONNULL_END
