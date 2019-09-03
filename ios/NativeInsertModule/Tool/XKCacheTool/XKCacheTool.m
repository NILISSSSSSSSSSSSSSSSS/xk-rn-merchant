//
//  XKCacheTool.m
//  XKSquare
//
//  Created by hupan on 2018/9/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCacheTool.h"
#import <SDWebImage/SDImageCache.h>
#import <WebKit/WebKit.h>
@implementation XKCacheTool


#pragma mark - 计算缓存数据大小

+ (NSString *)getFolderCacheSize {
    
    CGFloat cacheSize = 0.0;
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",files.count);
    
    for (NSString *path in files) {
        
        NSString *filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
        //累加
        cacheSize += [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    
    if (cacheSize == 0) {
        return @"0 KB";
        
    } else if (cacheSize > 0 && cacheSize < 1024) {
        return [NSString stringWithFormat:@"%d B",(int)cacheSize];
        
    } else if (cacheSize < 1024 * 1024) {
        return [NSString stringWithFormat:@"%.2f KB",cacheSize / 1024.0];
        
    } else if (cacheSize < 1024 * 1024 * 1024) {
        return [NSString stringWithFormat:@"%.2f MB",cacheSize / (1024.0 * 1024.0)];
        
    } else {
        return [NSString stringWithFormat:@"%.2f G",cacheSize / (1024.0 * 1024.0 * 1024.0)];
    }
    
    return nil;
}


#pragma mark - 删除缓存
+ (void)removeAllCachesComplete:(void(^)(void))complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [self removeSdImgCache];
        [self removeSandBoxCache];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeWebCache];
            EXECUTE_BLOCK(complete);
        });
    });
}

+ (void)removeSandBoxCache {
    //获取路径
    NSString*cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //返回路径中的文件数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    for (NSString *p in files) {
        
        NSError *error;
        NSString *path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@", p]];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            BOOL isRemove = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            if (isRemove) {
                NSLog(@"清除成功");
            } else {
                NSLog(@"清除失败");
            }
        }
    }
}

// 清除SD图片
+ (void)removeSdImgCache {
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}

// 清除web缓存
+ (void)removeWebCache {
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}



@end
