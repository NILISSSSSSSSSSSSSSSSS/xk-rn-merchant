//
//  XKPercentDrivenInteractiveTransition.h
//  XKSquare
//
//  Created by RyanYuan on 2018/11/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureConifg)(void);

/** 手势的方向 */
typedef NS_ENUM(NSUInteger, XKPercentDrivenInteractiveTransitionGestureDirection) {
    XKPercentDrivenInteractiveTransitionGestureDirectionLeft = 0,
    XKPercentDrivenInteractiveTransitionGestureDirectionRight,
    XKPercentDrivenInteractiveTransitionGestureDirectionUp,
    XKPercentDrivenInteractiveTransitionGestureDirectionDown
};

/** 手势控制哪种转场 */
typedef NS_ENUM(NSUInteger, XKPercentDrivenInteractiveTransitionType) {
    XKPercentDrivenInteractiveTransitionTypePresent = 0,
    XKPercentDrivenInteractiveTransitionTypeDismiss,
    XKPercentDrivenInteractiveTransitionTypePush,
    XKPercentDrivenInteractiveTransitionTypePop,
};

@interface XKPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interation; /** 记录是否开始手势，判断pop操作是手势触发还是返回键触发 */
@property (nonatomic, copy) GestureConifg presentConifg; /** 促发手势present的时候的config，config中初始化并present需要弹出的控制器 */
@property (nonatomic, copy) GestureConifg pushConifg; /** 促发手势push的时候的config，config中初始化并push需要弹出的控制器 */

/** 初始化方法 */
+ (instancetype)interactiveTransitionWithTransitionType:(XKPercentDrivenInteractiveTransitionType)type GestureDirection:(XKPercentDrivenInteractiveTransitionGestureDirection)direction;
- (instancetype)initWithTransitionType:(XKPercentDrivenInteractiveTransitionType)type GestureDirection:(XKPercentDrivenInteractiveTransitionGestureDirection)direction;

/** 给传入的控制器添加手势 */
- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end
