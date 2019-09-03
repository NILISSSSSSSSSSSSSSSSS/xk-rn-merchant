//
//  XKGlobalNotificationManager.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/28.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGlobalNotificationManager.h"
#import "XKLittleVideoRedEnvelopeNotificationModel.h"
#import "XKGlobalLittleVideoRedEnvelopeNotificationView.h"
#import "XKLittleVideoGiftNotificationModel.h"
#import "XKGlobalLittleVideoGiftNotificationView.h"

static XKGlobalNotificationManager *manager;

@interface XKGlobalNotificationManager ()

@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation XKGlobalNotificationManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XKGlobalNotificationManager alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:manager selector:@selector(screenTouchesAction:) name:XKScreenTouchesNotificationName object:nil];
    });
    return manager;
}

- (void)screenTouchesAction:(NSNotification *)sender {
    if (self.isAnimating) {
        return;
    } else {
        self.isAnimating = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isAnimating = NO;
        });
        for (UIView *temp in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([temp isKindOfClass:[XKGlobalNotificationView class]]) {
                XKGlobalNotificationView *tempGlobalNotificationView = (XKGlobalNotificationView *)temp;
                [tempGlobalNotificationView dismissWithAnimation:YES];
            }
        }
    }
}

- (void)addLittleVideoRedEnvelopeNotificationView:(nullable XKLittleVideoRedEnvelopeNotificationModel *)littleVideoRedEnvelope checkBlock:(nullable void(^)(void)) checkBlock {
    XKGlobalLittleVideoRedEnvelopeNotificationView *view = [[XKGlobalLittleVideoRedEnvelopeNotificationView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 60.0)];
    [view configViewWithLittleVideoRedEnvelope:littleVideoRedEnvelope];
    view.checkBtnBlock = ^{
        [self screenTouchesAction:nil];
        if (checkBlock) {
            checkBlock();
        }
    };
    [view show];
}

- (void)addLittleVideoGiftNotificationView:(nullable XKLittleVideoGiftNotificationModel *)littleVideoGift checkBlock:(void (^)(void))checkBlock {
    XKGlobalLittleVideoGiftNotificationView *view = [[XKGlobalLittleVideoGiftNotificationView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 60.0)];
    [view configViewWithLittleVideoGift:littleVideoGift];
    view.checkBtnBlock = ^{
        [self screenTouchesAction:nil];
        if (checkBlock) {
            checkBlock();
        }
    };
    [view show];
}

@end
