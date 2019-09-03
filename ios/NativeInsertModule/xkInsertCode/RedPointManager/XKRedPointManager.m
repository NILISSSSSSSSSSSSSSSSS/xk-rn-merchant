//
//  XKRedPointManager.m
//  XKSquare
//
//  Created by Jamesholy on 2018/11/26.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKRedPointManager.h"

@interface XKRedPointManager ()

@property(nonatomic, strong) NSMutableDictionary *tabBarItemDic;

@end

@implementation XKRedPointManager

+ (instancetype)shareManager {
    static XKRedPointManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XKRedPointManager alloc] init];
    });
    return instance;
}

+ (void)addRedPointTabbarItem:(id<XKRedPointTabBarItemProtocol>)tabarItem forKey:(NSString *)key {
    [XKRedPointManager shareManager].tabBarItemDic[key] = tabarItem;
}

+ (id<XKRedPointTabBarItemProtocol>)getRedPointTabBarItemForKey:(NSString *)key {
    return [XKRedPointManager shareManager].tabBarItemDic[key];
}

+ (void)refreshAllTabbarRedPoint {
    [[XKRedPointManager shareManager].tabBarItemDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  <XKRedPointTabBarItemProtocol>_Nonnull obj, BOOL * _Nonnull stop) {
        [obj resetTabBarRedPointStatusWithCalculate];
    }];
}

+ (void)cleanAllRedPoint {
    [[XKRedPointManager shareManager].tabBarItemDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  <XKRedPointTabBarItemProtocol>_Nonnull obj, BOOL * _Nonnull stop) {
        [obj cleanRedPoint];
    }];
}

- (NSMutableDictionary *)tabBarItemDic {
    if (!_tabBarItemDic) {
        _tabBarItemDic = [NSMutableDictionary dictionary];
    }
    return _tabBarItemDic;
}


@end
