//
//  XKIMMessageManager.h
//  XKSquare
//
//  Created by william on 2018/11/28.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XKIMMessageManager : NSObject

+ (instancetype)shareManager;

//配置代理
-(void)configDelegate;

//销毁相关
- (void)dellocManager;

@end

