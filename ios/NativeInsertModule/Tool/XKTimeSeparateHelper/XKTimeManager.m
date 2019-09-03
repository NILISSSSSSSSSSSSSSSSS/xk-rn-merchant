//
//  XKTimeManager.m
//  TimeSeparate
//
//  Created by hupan on 2018/8/2.
//  Copyright © 2018年 Tears. All rights reserved.
//

#import "XKTimeManager.h"

static XKTimeManager *_shareManager;

@implementation XKTimeManager

+ (instancetype)timeShareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareManager) {
            _shareManager = [[XKTimeManager alloc] init];
            _shareManager.dateFormatter = [[NSDateFormatter alloc] init];
            [_shareManager.dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        }
    });
    return _shareManager;
}

@end
