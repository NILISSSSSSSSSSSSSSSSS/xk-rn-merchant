//
//  XKSecretDataSingleton.m
//  XKSquare
//
//  Created by william on 2018/11/13.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKSecretDataSingleton.h"

@implementation XKSecretDataSingleton
+ (XKSecretDataSingleton *)sharedManager{
    
    static XKSecretDataSingleton *_sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}
@end
