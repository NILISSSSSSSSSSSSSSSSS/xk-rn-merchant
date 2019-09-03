//
//  XKRedPointManager.h
//  XKSquare
//
//  Created by Jamesholy on 2018/11/26.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKRedPointProtocol.h"

NS_ASSUME_NONNULL_BEGIN


/*
 这个是统一管理tabbar红点的类。
 */


@interface XKRedPointManager : NSObject

+ (instancetype)shareManager;
/**增加针对每个tabbar的管理器*/
+ (void)addRedPointTabbarItem:(id<XKRedPointTabBarItemProtocol>)tabarItem forKey:(NSString *)key;
/**取得对应tabbarItme的管理器*/
+ (id<XKRedPointTabBarItemProtocol>)getRedPointTabBarItemForKey:(NSString *)key;
/**调用计算后刷新所有tabbar上的状态*/
+ (void)refreshAllTabbarRedPoint;
/**清空所有红点*/
+ (void)cleanAllRedPoint;

@end

NS_ASSUME_NONNULL_END
