//
//  NSObject+XKDataBaseTool.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "NSObject+XKDataBaseTool.h"
#import <objc/runtime.h>
#import "XKDataBase.h"


@implementation NSObject (XKDataBaseTool)

- (void)toCache {
    NSString *name = NSStringFromClass([self class]);
    NSString *key = nil;
    NSString *val = self.yy_modelToJSONString;
    [[XKDataBase instance] insert:name key:key value:val];
}

+ (id)fromCache:(NSString *)key {
    NSString *name = NSStringFromClass([self class]);
    if (key.length > 0) {
        NSString *str = [[XKDataBase instance] select:name key:key];
        return [[self class] yy_modelWithJSON:str];
    }
    return nil;
}

+ (NSDictionary<NSNumber *, id> *)fetchCache:(int)count newest:(BOOL)newest {
    NSString *name = NSStringFromClass([self class]);
    NSDictionary<NSNumber *, NSString *> *cacheDatas = [[XKDataBase instance] select:name count:count newest:newest];
    NSMutableDictionary<NSNumber *, id> *datas = @{}.mutableCopy;
    [cacheDatas enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [datas setObject:[[self class] yy_modelWithJSON:obj] forKey:key];
    }];
    return datas;
}

+ (void)removeCache:(NSString *)key {
    NSString *name = NSStringFromClass([self class]);
    if (key.length > 0) {
        [[XKDataBase instance] deleteValueForTable:name key:key];
    }
}

+ (void)removeCacheById:(NSNumber *)identity {
    NSString *name = NSStringFromClass([self class]);
    if (identity) {
        [[XKDataBase instance] deleteValueForTable:name identity:identity];
    }
}

+ (void)clearCache {
    NSString *name = NSStringFromClass([self class]);
    [[XKDataBase instance] clear:name];
}
@end
