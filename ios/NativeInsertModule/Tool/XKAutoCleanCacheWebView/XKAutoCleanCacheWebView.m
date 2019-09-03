//
//  XKAutoCleanCacheWebView.m
//  XKSquare
//
//  Created by hupan on 2018/8/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKAutoCleanCacheWebView.h"

@implementation XKAutoCleanCacheWebView

- (void)dealloc {
    [self cleanCacheAndCookie];
}
- (void)cleanCacheAndCookie {
    /**清除缓存和cookie*/
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

@end
