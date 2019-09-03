//
//  XKKeyChainManager.h
//  XKSquare
//
//  Created by Lin Li on 2018/9/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKKeyChainManager : NSObject
/*!
 保存数据
 
 @data  要存储的数据
 @identifier 存储数据的标示
 */
+ (BOOL)keyChainSaveData:(id)data withIdentifier:(NSString*)identifier ;

/*!
 读取数据
 
 @identifier 存储数据的标示
 */
+ (id)keyChainReadData:(NSString*)identifier ;


/*!
 更新数据
 
 @data  要更新的数据
 @identifier 数据存储时的标示
 */
+ (BOOL)keyChainUpdata:(id)data withIdentifier:(NSString*)identifier ;

/*!
 删除数据
 
 @identifier 数据存储时的标示
 */
+ (void)keyChainDelete:(NSString*)identifier ;
@end
