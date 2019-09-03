//
//  XKCacheTool.h
//  XKSquare
//
//  Created by hupan on 2018/9/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKCacheTool : NSObject

/**
 计算缓存数据大小

 @return 数据大小 xxM
 */
+ (NSString *)getFolderCacheSize;


/**
 删除缓存
*/
+ (void)removeAllCachesComplete:(void(^)(void))complete;

@end
