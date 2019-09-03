//
//  BaseTabBarConfig.h
//  eptcoininfo
//
//  Created by 胡廉伟 on 2018/3/7.
//  Copyright © 2018年 Eptonic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYLTabBarController.h"

@interface BaseTabBarConfig : NSObject
@property (nonatomic, readonly, strong) CYLTabBarController *tabBarController;
@property (nonatomic, copy) NSString *context;

@end
