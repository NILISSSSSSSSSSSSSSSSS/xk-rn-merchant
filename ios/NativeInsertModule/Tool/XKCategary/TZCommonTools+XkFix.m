//
//  TZCommonTools+XkFix.m
//  XKSquare
//
//  Created by Jamesholy on 2018/12/4.
//  Copyright © 2018 xk. All rights reserved.
//

#import "TZCommonTools+XkFix.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wobjc-protocol-method-implementation"

@implementation TZCommonTools (XkFix)

+ (BOOL)tz_isIPhoneX {
    return iPhoneX_Serious;
}

@end

#pragma clang diagnostic pop
