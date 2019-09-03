//
//  UIWindow+touch.m
//  XKSquare
//
//  Created by Jamesholy on 2018/11/28.
//  Copyright © 2018 xk. All rights reserved.
//

#import "UIWindow+touch.h"
#import <objc/runtime.h>
#import "XKGlobalNotificationView.h"

@implementation UIWindow (touch)

+ (void)load {
    Method m1 = class_getInstanceMethod([self class], @selector(sendEvent:));
    Method m2 = class_getInstanceMethod([self class], @selector(xk_sendEvent:));
    method_exchangeImplementations(m1, m2);
}

- (void)xk_sendEvent:(UIEvent *)event {
    [self xk_sendEvent:event];
    [self dealTouch:event];
}

- (void)dealTouch:(UIEvent *)event {
    if ([event.allTouches.allObjects.firstObject locationInView:self].y >= kStatusBarHeight + 60.0) {
        // 在点击屏幕非全局通知的地址，发送通知以响应
        [[NSNotificationCenter defaultCenter] postNotificationName:XKScreenTouchesNotificationName object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:XKScreenAllTouchesNotificationName object:nil];
}

@end
