//
//  NSObject+XKDataBaseTool.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
//适用于模型
@interface NSObject (XKDataBaseTool)

/**
 把自己保存起来  类名即表名
 */
- (void)toCache;

/**
 读取本类名的表里保存的key值

 @param key 查询的Key值
 @return 查询到的数据
 */
+ (id)fromCache:(NSString *)key;


/**
 按数量查询

 @params count 查询数量，如果小于等于0，则查询所有数据
 @params newest 排序，如果为YES表示查询最新的数据，否则查询最老的数据
 @return 查到的内容
 */
+ (NSDictionary<NSNumber *, id> *)fetchCache:(int)count newest:(BOOL)newest;


/**
 删除数据
 @param key key名
 */
+ (void)removeCache:(NSString *)key;


/**
 按id删除

 @param identity id
 */
+ (void)removeCacheById:(NSNumber *)identity;


/**
 清除数据
 */
+ (void)clearCache;


@end
