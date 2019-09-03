//
//  XKCommonSheetView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCommonSheetView.h"

#define bgViewTag  123

@interface XKCommonSheetView ()

@end

@implementation XKCommonSheetView
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化默认数据
        [self createDefaultData];
        // 初始化UI
        [self createUI];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:XKToolsBottomSheetViewDismissNotification object:nil];
}

#pragma mark - 初始化UI
- (void)createUI {
    self.frame = [UIScreen mainScreen].bounds;
    UIView *tempView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:tempView];
    [tempView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
}

#pragma mark - 显示
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    UIView *view = [self viewWithTag:bgViewTag];
    if (!view) {
        CGRect rect;
        if (self.animationWay == AnimationWay_centerShow) {
            rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } else {
            CGFloat height = SCREEN_HEIGHT - (SCREEN_HEIGHT - self.contentView.y) - (self.addBottomSafeHeight ? kBottomSafeHeight : 0);
            if (self.shieldBottomHeight) {
                height = height - self.shieldBottomHeight;
            }
            rect = CGRectMake(0, 0, SCREEN_WIDTH, height);
        }
        view = [[UIView alloc] initWithFrame:rect];
        view.tag = bgViewTag;
        view.alpha = 0.8f;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
        [self addSubview:view];
        [self bringSubviewToFront:self.contentView];
    }
    
    XKWeakSelf(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        if (weakSelf.animationWay == AnimationWay_centerShow) {
            weakSelf.contentView.transform = CGAffineTransformIdentity;
        } else {
            weakSelf.contentView.transform = CGAffineTransformMakeTranslation(0, -weakSelf.contentView.height -(self.addBottomSafeHeight ? kBottomSafeHeight : 0));
        }
        view.backgroundColor = RGBA(0, 0, 0, 0.5);

    } completion:^(BOOL finished) {
        weakSelf.showing = YES;
        view.backgroundColor = RGBA(0, 0, 0, 0.5);
    }];
}

- (void)showForShare {
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    UIVisualEffectView *view = [self viewWithTag:bgViewTag];

    if (!view) {
        CGRect rect;
        if (self.animationWay == AnimationWay_centerShow) {
            rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } else {
            CGFloat height = SCREEN_HEIGHT - (SCREEN_HEIGHT - self.contentView.y) - (self.addBottomSafeHeight ? kBottomSafeHeight : 0);
            if (self.shieldBottomHeight) {
                height = height - self.shieldBottomHeight;
            }
            rect = CGRectMake(0, 0, SCREEN_WIDTH, height);
        }
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:blur];
        view.frame = rect;
        view.tag = bgViewTag;
        view.alpha = 0.9;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShare)]];
        [self addSubview:view];
        [self bringSubviewToFront:self.contentView];
    }
    
    XKWeakSelf(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        if (weakSelf.animationWay == AnimationWay_centerShow) {
            weakSelf.contentView.transform = CGAffineTransformIdentity;
            
        } else {
            weakSelf.contentView.transform = CGAffineTransformMakeTranslation(0, -weakSelf.contentView.height -(self.addBottomSafeHeight ? kBottomSafeHeight : 0));
        }
       //  view.backgroundColor = RGBA(0, 0, 0, 0.5);
    } completion:^(BOOL finished) {
        weakSelf.showing = YES;
      //  view.backgroundColor = RGBA(0, 0, 0, 0.5);
    }];
}


- (void)showWithNoShield {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self bringSubviewToFront:self.contentView];
    
    
    XKWeakSelf(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        if (weakSelf.animationWay == AnimationWay_centerShow) {
            weakSelf.contentView.transform = CGAffineTransformIdentity;
        } else {
            weakSelf.contentView.transform = CGAffineTransformMakeTranslation(0, -weakSelf.contentView.height -(self.addBottomSafeHeight ? kBottomSafeHeight : 0));
        }
    } completion:^(BOOL finished) {
        weakSelf.showing = YES;
    }];
}

#pragma mark - 消失
- (void)dismiss {
    
    UIView *view = [self viewWithTag:bgViewTag];
    XKWeakSelf(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        if (weakSelf.animationWay == AnimationWay_centerShow) {
            weakSelf.contentView.transform = CGAffineTransformMakeScale(0, 0);
        } else {
            weakSelf.contentView.transform = CGAffineTransformIdentity;
        }
        view.backgroundColor = RGBA(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        weakSelf.showing = NO;
        if(weakSelf.dismissBlock) {
            weakSelf.dismissBlock();
        }
        [weakSelf removeFromSuperview];
    }];
}

- (void)dismissShare {
    
    self.showing = NO;
    if(self.dismissBlock) {
        self.dismissBlock();
    }
    [self removeFromSuperview];
}
@end
