//
//  XKHUD.m
//  XKSquare
//
//  Created by william on 2018/7/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKHUD.h"
static const NSTimeInterval kDelayTime = 1.5; //消失时间

@implementation XKHUD

+ (void)showLoadingText:(NSString *)aText
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showWithStatus:aText];
}

+ (void)showSuccessWithText:(NSString *)aText{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:aText];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)showErrorWithText:(NSString *)aText{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:aText];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)dismiss{
    [SVProgressHUD dismiss];
}

@end
