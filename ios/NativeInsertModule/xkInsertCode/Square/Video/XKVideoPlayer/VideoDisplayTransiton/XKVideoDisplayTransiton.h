//
//  XKVideoDisplayTransiton.h
//  XKSquare
//
//  Created by RyanYuan on 2018/11/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  动画过渡代理管理的是push还是pop
 */
typedef NS_ENUM(NSUInteger, XKVideoDisplayTransitonType) {
    XKVideoDisplayTransitonTypePush = 0,
    XKVideoDisplayTransitonTypePop
};

@interface XKVideoDisplayTransiton : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) XKVideoDisplayTransitonType type;

@end
