//
//  XKTimeManager.h
//  TimeSeparate
//
//  Created by hupan on 2018/8/2.
//  Copyright © 2018年 Tears. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKTimeManager : NSObject

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

+ (instancetype)timeShareManager;

@end
