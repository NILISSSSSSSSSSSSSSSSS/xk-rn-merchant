//
//  XKDataBase.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface XKDataBase : NSObject

/**
 数据保存的单例

 @return 单例
 */
+ (instancetype)instance;


/**
 查询表格是否存在

 @param table 表名
 @return 是否存在
 */
- (BOOL)existsTable:(NSString *)table;

/**
 建表

 @param name 表名
 @return 建表是否成功
 */
- (BOOL)createTable:(NSString *)name;


/**
 查询该表是否存在该key值

 @param table 表名
 @param key key名
 @return 是否存在
 */
- (BOOL)exists:(NSString *)table key:(NSString *)key;


/**
 查询保存的数值

 @param table 表名
 @param key key名
 @return 返回该数值
 */
- (NSString *)select:(NSString *)table key:(NSString *)key;

/**
 @params count 查询数量，如果小于等于0，则查询所有数据
 @params newest 排序，如果为YES表示查询最新的数据，否则查询最老的数据
 */
- (NSDictionary<NSNumber *, NSString *> *)select:(NSString *)table count:(int)count newest:(BOOL)newest;

//新增数据
- (BOOL)insert:(NSString *)table key:(NSString *)key value:(NSString *)val;

//更新数据
- (BOOL)update:(NSString *)table key:(NSString *)key value:(NSString *)val;

//更新数据
- (BOOL)replace:(NSString *)table key:(NSString *)key value:(NSString *)val;

//删除数据 按key
- (BOOL)deleteValueForTable:(NSString *)table key:(NSString *)key;

//删除数据 按id
- (BOOL)deleteValueForTable:(NSString *)table identity:(NSNumber *)identity;

//删表
- (BOOL)clear:(NSString *)table;
@end
