//
//  NSString+XKSensitive.m
//  XKSquare
//
//  Created by Jamesholy on 2019/4/1.
//  Copyright © 2019 xk. All rights reserved.
//

#import "NSString+XKSensitive.h"
#import "XKSensitiveFilterHelper.h"

@implementation NSString (XKSensitive)

- (instancetype)sensitiveFilter {
    return [[XKSensitiveFilterHelper shared] filter:self];
}

- (instancetype)sensitiveFilterForVideo {
    return [[XKSensitiveFilterHelper shared] filterForVideo:self];
}

- (instancetype)sensitiveFilterForBcircle {
    return [[XKSensitiveFilterHelper shared] filterForBcircle:self];
}

@end
