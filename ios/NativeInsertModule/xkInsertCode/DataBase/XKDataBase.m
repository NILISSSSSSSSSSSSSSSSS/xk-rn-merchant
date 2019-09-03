//
//  XKDataBase.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKDataBase.h"
#import <FMDB.h>
#import <YYModel.h>
@interface XKDataBase ()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation XKDataBase

+ (instancetype)instance {
  static dispatch_once_t token;
  static XKDataBase *instance = nil;
  dispatch_once(&token, ^{
    instance = [[XKDataBase alloc] initWithName:@"xk_data"];
  });
  return instance;
}

- (instancetype)initWithName:(NSString *)dbname {
  self = [super init];
  if (self) {
    // 获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"xkcache_%@.sqlite", dbname]];
    // 创建数据库
    _db = [FMDatabase databaseWithPath:file];
    // 打开数据库
    [_db open];
  }
  return self;
}

- (void)dealloc {
  if (_db) {
    [_db close];
    _db = nil;
  }
}

- (BOOL)existsTable:(NSString *)table {
  return  [_db tableExists:[NSString stringWithFormat:@"T_%@",table]];
}

- (BOOL)createTable:(NSString *)name {
  NSString *sql = [NSString stringWithFormat:@"create table if not exists T_%@(id integer primary key autoincrement, key text, val text);", name];
  BOOL result = [_db executeUpdate:sql];
  return result;
}

- (BOOL)exists:(NSString *)table key:(NSString *)key {
  if (![self existsTable:table]) {
    return NO;
  }
  NSString *sql = [NSString stringWithFormat:@"select 1 from T_%@ where key = ?;", table];
  FMResultSet *resultSet = [_db executeQuery:sql, key];
  BOOL next = [resultSet next];
  [resultSet close];
  return next;
}

- (NSString *)select:(NSString *)table key:(NSString *)key {
  NSString *val = nil;
  NSString *sql = [NSString stringWithFormat:@"select val from T_%@ where key = ?;", table];
  FMResultSet *resultSet = [_db executeQuery:sql, key];
  if ([resultSet next]) {
    val = [resultSet objectForColumn:@"val"];
  }
  [resultSet close];
  return val;
}

- (NSDictionary<NSNumber *, NSString *> *)select:(NSString *)table count:(int)count newest:(BOOL)newest {
  if (table.length == 0) {
    return nil;
  }
  NSNumber *iden;
  NSString *val = nil;
  NSString *sql = [NSString stringWithFormat:@"select id, val from T_%@ order by id %@ %@;", table, newest?@"desc":@"asc", count>0?[NSString stringWithFormat:@"limit %d", count]:@""];
  FMResultSet *resultSet = [_db executeQuery:sql];
  NSMutableDictionary<NSNumber *, NSString *> *results = @{}.mutableCopy;
  while ([resultSet next]) {
    iden = [resultSet objectForColumn:@"id"];
    val = [resultSet objectForColumn:@"val"];
    [results setObject:val?val:@"" forKey:iden];
  }
  [resultSet close];
  return results.copy;
}

- (BOOL)insert:(NSString *)table key:(NSString *)key value:(NSString *)val {
  if (table.length == 0 || val.length == 0 || ![self createTable:table]) {
    return NO;
  }
  if (key == nil) {
    key = @"";
  }
  NSString *sql = [NSString stringWithFormat:@"insert into T_%@(key, val) values(?,?);", table];
  BOOL result = [_db executeUpdate:sql, key, val];
  return result;
}

- (BOOL)update:(NSString *)table key:(NSString *)key value:(NSString *)val {
  if (![self createTable:table]) {
    return NO;
  }
  NSString *sql = [NSString stringWithFormat:@"update T_%@ set val = ? where key = ?;", table];
  BOOL result = [_db executeUpdate:sql, val, key];
  return result;
}

- (BOOL)replace:(NSString *)table key:(NSString *)key value:(NSString *)val {
  if ([self exists:table key:key]) {
    return [self update:table key:key value:val];
  } else {
    return [self insert:table key:key value:val];
  }
}

- (BOOL)deleteValueForTable:(NSString *)table key:(NSString *)key {
  NSString *sql = [NSString stringWithFormat:@"delete from T_%@ where key = ?;", table];
  BOOL result = [_db executeUpdate:sql, key];
  return result;
}

- (BOOL)deleteValueForTable:(NSString *)table identity:(NSNumber *)identity {
  NSString *sql = [NSString stringWithFormat:@"delete from T_%@ where id = ?;", table];
  BOOL result = [_db executeUpdate:sql, identity];
  return result;
}

- (BOOL)clear:(NSString *)table {
  NSString *sql = [NSString stringWithFormat:@"drop table if exists T_%@;", table];
  BOOL result = [_db executeUpdate:sql];
  return result;
}
@end
