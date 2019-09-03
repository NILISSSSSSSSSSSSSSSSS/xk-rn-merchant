//
//  M80AttributedLabelURL+XKM80AttributedLabelURL.m
//  XKSquare
//
//  Created by xudehuai on 2019/7/8.
//  Copyright © 2019 xk. All rights reserved.
//

#import "M80AttributedLabelURL+XKM80AttributedLabelURL.h"

static NSString *M80URLExpression = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";

static NSString *M80URLExpressionKey = @"M80URLExpressionKey";

@implementation M80AttributedLabelURL (XKM80AttributedLabelURL)

+ (NSRegularExpression *)urlExpression
{
    NSMutableDictionary *dict = [[NSThread currentThread] threadDictionary];
    NSRegularExpression *exp = dict[M80URLExpressionKey];
    if (exp == nil)
    {
        exp = [NSRegularExpression regularExpressionWithPattern:M80URLExpression
                                                        options:NSRegularExpressionCaseInsensitive
                                                          error:nil];
        dict[M80URLExpressionKey] = exp;
    }
    return exp;
}

@end
