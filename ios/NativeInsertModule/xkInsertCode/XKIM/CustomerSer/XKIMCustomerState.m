//
//  XKIMCustomerState.m
//  XKSquare
//
//  Created by william on 2018/12/17.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMCustomerState.h"

@implementation XKIMCustomerState
+ (XKIMCustomerState *)sharedManager{
    
    static XKIMCustomerState *_sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}
@end
