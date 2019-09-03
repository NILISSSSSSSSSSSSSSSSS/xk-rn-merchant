//
//  XKVideoDisplayMediator.m
//  XKSquare
//
//  Created by RyanYuan on 2018/11/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoDisplayMediator.h"
#import "XKVideoDisplayViewController.h"
#import "XKClearVideoDisplayViewController.h"

@interface XKVideoDisplayMediator ()

@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

@end

@implementation XKVideoDisplayMediator

+ (instancetype)shareInstance {
    
    static XKVideoDisplayMediator *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XKVideoDisplayMediator alloc] init];
    });
    return instance;
}

+ (void)displayRecommendVideoListWithViewController:(UIViewController *)viewController {
    
    if (viewController) {
        XKVideoDisplayMediator *videoDisplayMediator = [XKVideoDisplayMediator shareInstance];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:viewController forKey:@"viewController"];
        [videoDisplayMediator performTarget:@"XKVideoDisplayViewController" action:@"displayVideoWithParams" params:params shouldCacheTarget:NO];
    }
}

+ (void)displaySingleVideoWithViewController:(UIViewController *)viewController videoListItemModel:(XKVideoDisplayVideoListItemModel *)model {
    
    if (viewController && model) {
        XKVideoDisplayMediator *videoDisplayMediator = [XKVideoDisplayMediator shareInstance];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:viewController forKey:@"viewController"];
        [params setObject:model forKey:@"model"];
        [videoDisplayMediator performTarget:@"XKVideoDisplayViewController" action:@"displayVideoWithParams" params:params shouldCacheTarget:NO];
    }
}

+ (void)displaySingleVideoWithViewController:(UIViewController *)viewController videoId:(NSString *)videoId {
    
    if (viewController && videoId) {
        XKVideoDisplayMediator *videoDisplayMediator = [XKVideoDisplayMediator shareInstance];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:viewController forKey:@"viewController"];
        [params setObject:videoId forKey:@"videoId"];
        [videoDisplayMediator performTarget:@"XKVideoDisplayViewController" action:@"displayVideoWithParams" params:params shouldCacheTarget:NO];
    }
}

+ (void)displaySingleVideoClearWithViewController:(UIViewController *)viewController urlString:(NSString *)urlString {
    
    if (viewController && urlString) {
        XKVideoDisplayMediator *videoDisplayMediator = [XKVideoDisplayMediator shareInstance];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:viewController forKey:@"viewController"];
        [params setObject:urlString forKey:@"urlString"];
        [videoDisplayMediator performTarget:@"XKClearVideoDisplayViewController" action:@"displayVideoWithParams" params:params shouldCacheTarget:NO];
    }
}

+ (void)displayLocalSingleVideoClearWithViewController:(UIViewController *)viewController localFilePath:(NSString *)localFilePath {
    
    if (viewController && localFilePath) {
        XKVideoDisplayMediator *videoDisplayMediator = [XKVideoDisplayMediator shareInstance];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:viewController forKey:@"viewController"];
        [params setObject:localFilePath forKey:@"localFilePath"];
        [videoDisplayMediator performTarget:@"XKClearVideoDisplayViewController" action:@"displayVideoWithParams" params:params shouldCacheTarget:NO];
    }
}

+ (void)displaySingleVideoWithViewController:(UIViewController *)viewController videoListItemModel:(XKVideoDisplayVideoListItemModel *)model fromView:(UIView *)view {
    
    if (viewController && model && view) {
        XKVideoDisplayMediator *videoDisplayMediator = [XKVideoDisplayMediator shareInstance];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:viewController forKey:@"viewController"];
        [params setObject:model forKey:@"model"];
        [params setObject:view forKey:@"view"];
        [videoDisplayMediator performTarget:@"XKVideoDisplayViewController" action:@"displayVideoWithParams" params:params shouldCacheTarget:NO];
    }
}

+ (void)displaySingleVideoWithViewController:(UIViewController *)viewController videoId:(NSString *)videoId fromView:(UIView *)view {
    
    if (viewController && videoId && view) {
        XKVideoDisplayMediator *videoDisplayMediator = [XKVideoDisplayMediator shareInstance];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:viewController forKey:@"viewController"];
        [params setObject:videoId forKey:@"videoId"];
        [params setObject:view forKey:@"view"];
        [videoDisplayMediator performTarget:@"XKVideoDisplayViewController" action:@"displayVideoWithParams" params:params shouldCacheTarget:NO];
    }
}

+ (void)displaySingleVideoClearWithViewController:(UIViewController *)viewController urlString:(NSString *)urlString fromView:(UIView *)view {
    
    if (viewController && urlString && view) {
        XKVideoDisplayMediator *videoDisplayMediator = [XKVideoDisplayMediator shareInstance];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:viewController forKey:@"viewController"];
        [params setObject:urlString forKey:@"urlString"];
        [params setObject:view forKey:@"view"];
        [videoDisplayMediator performTarget:@"XKClearVideoDisplayViewController" action:@"displayVideoWithParams" params:params shouldCacheTarget:NO];
    }
}

+ (void)displayLocalSingleVideoClearWithViewController:(UIViewController *)viewController localFilePath:(NSString *)localFilePath fromView:(UIView *)view {
    
    if (viewController && localFilePath && view) {
        XKVideoDisplayMediator *videoDisplayMediator = [XKVideoDisplayMediator shareInstance];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:viewController forKey:@"viewController"];
        [params setObject:localFilePath forKey:@"localFilePath"];
        [params setObject:view forKey:@"view"];
        [videoDisplayMediator performTarget:@"XKClearVideoDisplayViewController" action:@"displayVideoWithParams" params:params shouldCacheTarget:NO];
    }
}

#pragma mark - private methods

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget {
    
    NSString *targetClassString = [NSString stringWithFormat:@"%@", targetName];
    NSString *actionString = [NSString stringWithFormat:@"Action_%@:", actionName];
    Class targetClass;
    
    NSObject *target = self.cachedTarget[targetClassString];
    if (target == nil) {
        targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc] init];
    }
    
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
        [self NoTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
        return nil;
    }
    
    if (shouldCacheTarget) {
        self.cachedTarget[targetClassString] = target;
    }
    
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:params];
    }
    
    return nil;
}

- (void)NoTargetActionResponseWithTargetString:(NSString *)targetString selectorString:(NSString *)selectorString originParams:(NSDictionary *)originParams {
    
    SEL action = NSSelectorFromString(@"Action_response:");
    NSObject *target = [[NSClassFromString(@"Target_NoTargetAction") alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"originParams"] = originParams;
    params[@"targetString"] = targetString;
    params[@"selectorString"] = selectorString;
    
    [self safePerformAction:action target:target params:params];
}

- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params {
    
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

- (NSMutableDictionary *)cachedTarget {
    
    if (_cachedTarget == nil) {
        _cachedTarget = [[NSMutableDictionary alloc] init];
    }
    return _cachedTarget;
}

@end
