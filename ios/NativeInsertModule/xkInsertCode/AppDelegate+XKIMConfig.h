//
//  AppDelegate+XKIMConfig.h
//  XKSquare
//
//  Created by william on 2018/8/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "AppDelegate.h"
#import <NIMSDK/NIMSDK.h>
#import <NIMKit.h>
@interface AppDelegate (XKIMConfig)
//注册云信IM
-(void)setupNIMSDK;

//释放方法
-(void)deallocIM;
@end
