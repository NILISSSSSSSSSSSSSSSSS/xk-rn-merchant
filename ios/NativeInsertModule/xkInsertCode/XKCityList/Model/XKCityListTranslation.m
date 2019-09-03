//
//  XKCityListTranslation.m
//  XKSquare
//
//  Created by Lin Li on 2018/8/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCityListTranslation.h"
#import "XKCityListViewController.h"
#import "XKSearchCityListViewController.h"

@implementation XKCityListTranslation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //城市列表vc跳转到搜索页面
    if (self.isSearchVC) {
        //transitionContext:转场上下文
        //转场过程中显示的view，所有动画控件都应该加在这上面
        __block UIView* containerView = [transitionContext containerView];
        XKSearchCityListViewController *toVC = (XKSearchCityListViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        XKCityListViewController *fromVC =(XKCityListViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        //做一个淡入淡出的效果
        toVC.view.alpha = 0;
        [containerView addSubview:toVC.view];
        [UIView animateWithDuration:0.6 animations:^{
            fromVC.view.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
        [UIView animateWithDuration:0.6 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            toVC.view.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        
    }else{
        //transitionContext:转场上下文
        //转场过程中显示的view，所有动画控件都应该加在这上面
        __block UIView* containerView = [transitionContext containerView];
        XKCityListViewController *toVC =(XKCityListViewController *)[transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
        XKSearchCityListViewController *fromVC = (XKSearchCityListViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        //做一个淡入淡出的效果
        toVC.view.alpha = 0;
        [containerView addSubview:toVC.view];
        [UIView animateWithDuration:0.6 animations:^{
            fromVC.view.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
        [UIView animateWithDuration:0.6 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            toVC.view.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
