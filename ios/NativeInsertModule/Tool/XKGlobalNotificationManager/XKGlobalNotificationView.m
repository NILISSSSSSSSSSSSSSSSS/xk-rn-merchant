//
//  XKGlobalNotificationView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/28.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGlobalNotificationView.h"

@interface XKGlobalNotificationView()

@property (nonatomic, assign) CGFloat maxY;

@property (nonatomic, assign) BOOL touching;

@end

@implementation XKGlobalNotificationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStatePossible) {
        NSLog(@"UIGestureRecognizerStatePossible");
    } else if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        self.touching = YES;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.touching = YES;
        // 获取偏移量
        // 返回的是相对于最原始的手指的偏移量
        CGPoint panPoint = [sender translationInView:self];
        if (CGAffineTransformTranslate(self.transform, 0.0, panPoint.y).ty > self.maxY) {
            return;
        } else {
            self.transform = CGAffineTransformTranslate(self.transform, 0.0, panPoint.y);
        }
        // 复位,表示相对上一次
        [sender setTranslation:CGPointZero inView:self];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        self.touching = NO;
        if (CGRectGetMinY(self.frame) > 0.0) {
            [UIView animateWithDuration:0.33 animations:^{
                self.transform = CGAffineTransformTranslate(self.transform, 0.0, self.maxY - CGRectGetMaxY(self.frame));
            } completion:^(BOOL finished) {
                if (finished) {
                    // 5.0秒后自动移除
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (!self.touching) {
                            [self dismissWithAnimation:YES];
                        }
                    });
                }
            }];;
        } else {
            [self dismissWithAnimation:YES];
        }
    } else if (sender.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"UIGestureRecognizerStateCancelled");
        self.touching = NO;
        [self show];
    } else if (sender.state == UIGestureRecognizerStateFailed) {
        self.touching = NO;
        NSLog(@"UIGestureRecognizerStateFailed");
    } else if (sender.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"UIGestureRecognizerStateRecognized");
    }
}

- (void)initializeViews {
    
}

- (void)updateViews {
    
}

- (void)show {
    [self layoutIfNeeded];
    self.maxY = kStatusBarHeight + CGRectGetHeight(self.frame);
    self.frame = CGRectMake(0.0, -CGRectGetHeight(self.frame), SCREEN_WIDTH, CGRectGetHeight(self.frame));
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.33 animations:^{
        self.transform = CGAffineTransformTranslate(self.transform, 0.0, self.maxY - CGRectGetMaxY(self.frame));
    } completion:^(BOOL finished) {
        if (finished) {
            UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
            [self addGestureRecognizer:panGestureRecognizer];
            // 移除多余的视图
            for (UIView *temp in [UIApplication sharedApplication].keyWindow.subviews) {
                if ([temp isKindOfClass:[XKGlobalNotificationView class]] && temp != self) {
                    XKGlobalNotificationView *tempGlobalNotificationView = (XKGlobalNotificationView *)temp;
                    [tempGlobalNotificationView dismiss];
                }
            }
            // 5.0秒后自动移除
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!self.touching) {
                    [self dismissWithAnimation:YES];
                }
            });
        }
    }];
}

- (void)dismiss {
    self.hidden = YES;
    [self removeFromSuperview];
}

- (void)dismissWithAnimation:(BOOL)animationFlag {
    if (animationFlag) {
        [UIView animateWithDuration:0.33 animations:^{
            self.transform = CGAffineTransformTranslate(self.transform, 0.0, -CGRectGetMaxY(self.frame));
        } completion:^(BOOL finished) {
            if (finished) {
                [self dismiss];
            }
        }];
    } else {
        [self dismiss];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

@end
