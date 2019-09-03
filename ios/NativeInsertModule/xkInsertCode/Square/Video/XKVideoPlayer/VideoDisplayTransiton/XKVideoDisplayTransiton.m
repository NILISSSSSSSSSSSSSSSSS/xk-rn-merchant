//
//  XKVideoDisplayTransiton.m
//  XKSquare
//
//  Created by RyanYuan on 2018/11/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoDisplayTransiton.h"
#import "XKVideoDisplayViewController.h"
#import "XKVideoMainViewController.h"

@interface XKVideoDisplayTransiton () 

@property (nonatomic, assign) CGRect afterChangeRect;

@end

@implementation XKVideoDisplayTransiton

#pragma mark - UIViewControllerAnimatedTransitioning

/**
 *  动画时长
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return .2;
}
/**
 *  如何执行过渡动画
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    switch (_type) {
        case XKVideoDisplayTransitonTypePush:
            [self doPushAnimation:transitionContext];
            break;
            
        case XKVideoDisplayTransitonTypePop:
            [self doPopAnimation:transitionContext];
            break;
    }
}

#pragma mark - private methods

/**
 *  执行push过渡动画
 */
- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *firstViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    XKVideoDisplayViewController *secondViewController = (XKVideoDisplayViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *firstView = [secondViewController getTransitonFromView];
    UIView *secondView = [secondViewController getTransitonToView];
    CGRect afterChangeRect = [firstView convertRect:firstView.bounds toView:firstViewController.view];
    self.afterChangeRect = afterChangeRect;
    
    //拿到当前点击的cell的imageView
    UIView *containerView = [transitionContext containerView];
    //snapshotViewAfterScreenUpdates 对cell的imageView截图保存成另一个视图用于过渡，并将视图转换到当前控制器的坐标
    UIView *tempView = [firstView snapshotViewAfterScreenUpdates:NO];
    tempView.frame = [firstView convertRect:firstView.frame toView:containerView];
    //设置动画前的各个控件的状态
//    firstView.hidden = YES;
    secondView.alpha = 0;
    //tempView 添加到containerView中，要保证在最前方，所以后添加
    [containerView addSubview:secondView];
    [containerView addSubview:tempView];
    
    // 放大倍数
    CGFloat withScale = SCREEN_WIDTH / firstView.width;
    CGFloat heightScale = SCREEN_HEIGHT / firstView.height;
    CGFloat Scale = withScale < heightScale ? withScale : heightScale;
    CGRect largeRect = CGRectMake(0, 0, firstView.width * Scale, firstView.height * Scale);
    
    //开始做动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        tempView.frame = largeRect;
        tempView.alpha = 0;
        secondView.alpha = 1;
    } completion:^(BOOL finished) {
        tempView.hidden = YES;
        secondView.hidden = NO;
        
        //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中动画完成的部署，会出现无法交互之类的bug
        [transitionContext completeTransition:YES];
    }];
}
/**
 *  执行pop过渡动画
 */
- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
//    NSLog(@"self:%@", self);
    XKVideoDisplayViewController *secondViewController = (XKVideoDisplayViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIView *firstView = [secondViewController getTransitonFromView];
    UIView *secondView = [secondViewController getTransitonToView];
    UIViewController *firstViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIView *tempView = [secondView snapshotViewAfterScreenUpdates:NO];
    [containerView addSubview:tempView];
    
    //设置初始状态
//    firstView.hidden = YES;
    secondView.hidden = YES;
    tempView.hidden = NO;
    tempView.alpha = 1;
    
    [containerView insertSubview:firstViewController.view atIndex:0];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{

//        NSLog(@"firstView.frame:*******%@*******", NSStringFromCGRect(firstView.frame));
//        NSLog(@"firstView:*******%@*******", firstView);
//        NSLog(@"testRect:*******%@*******", NSStringFromCGRect(self.afterChangeRect));
        
        tempView.frame = self.afterChangeRect;
        
        
        secondView.alpha = 1;
    } completion:^(BOOL finished) {
        // 由于加入了手势必须判断
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            // 手势取消了，原来隐藏的imageView要显示出来
            // 失败了隐藏tempView，显示videoDisplayViewController.toView
            tempView.hidden = YES;
            secondView.hidden = NO;
        } else {
            // 手势成功，cell的imageView也要显示出来
            // 成功了移除tempView，下一次pop的时候又要创建，然后显示cell的imageView
//            firstView.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
}

@end
