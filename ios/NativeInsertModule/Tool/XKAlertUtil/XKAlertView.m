//
//  XKUploadManager.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/9.
//  Copyright © 2018年 xk. All rights reserved.

#import "XKAlertView.h"
#import <NSString+Utils.h>

@implementation XKAlertView

#pragma mark - 不需要交互
+ (XKCommonAlertView *)showCommonAlertViewWithTitle:(NSString *)title {
    XKCommonAlertView *alert = [[XKCommonAlertView alloc] initWithTitle:nil message:title leftButton:nil rightButton:@"确定" leftBlock:nil rightBlock:nil textAlignment:NSTextAlignmentCenter];
    [alert show];
    return alert;
}

+ (XKCommonAlertView *)showCommonAlertViewWithTitle:(NSString *)title message:(NSString *)messge {
    XKCommonAlertView *alert = [[XKCommonAlertView alloc] initWithTitle:title message:messge leftButton:nil rightButton:@"确定" leftBlock:nil rightBlock:nil textAlignment:NSTextAlignmentCenter];
    [alert show];
    return alert;
}

+ (XKCommonAlertView *)showCommonAlertViewWithTitle:(NSString *)title block:(void(^)(void))block {
    XKCommonAlertView *alert = [[XKCommonAlertView alloc] initWithTitle:nil message:title leftButton:nil rightButton:@"确定" leftBlock:nil rightBlock:block textAlignment:NSTextAlignmentCenter];
    [alert show];
    return alert;
}

#pragma mark - 左边按钮默认取消 左边无事件处理
+ (XKCommonAlertView *)showCommonAlertViewWithTitle:(NSString *)title rightText:(NSString *)rightText rightBlock:(void(^)(void))rightBlock {
    return [self showCommonAlertViewWithTitle:title leftText:@"" rightText:rightText leftBlock:nil rightBlock:rightBlock];
}

+ (XKCommonAlertView *)showCommonAlertViewWithTitle:(NSString *)title leftText:(NSString *)leftText rightText:(NSString *)rightText leftBlock:(void(^)(void))leftBlock rightBlock:(void(^)(void))rightBlock {
    XKCommonAlertView *alert = [[XKCommonAlertView alloc] initWithTitle:nil message:title leftButton:[leftText isExist] ? leftText : @"取消" rightButton:rightText leftBlock:leftBlock rightBlock:rightBlock textAlignment:NSTextAlignmentCenter];
    [alert show];
    return alert;
}

+ (XKCommonAlertView *)showAlertViewWithCloseBtnWithTitle:(nullable NSString *)title message:(nullable NSString *)messge leftText:(nullable NSString *)leftText rightText:(nullable NSString *)rightText textColor:(UIColor *)color leftBlock:(nullable void(^)(void))leftBlock rightBlock:(nullable void(^)(void))rightBlock textAlignment:(NSTextAlignment)textAlignment {
    XKCommonAlertView *alert = [[XKCommonAlertView alloc] initWithTitle:title message:messge leftButton:[leftText isExist] ? leftText : @"取消" rightButton:rightText leftBlock:leftBlock rightBlock:rightBlock textAlignment:NSTextAlignmentCenter];
    [alert setCloseButtonHidden:NO];
    [alert setRightButtonColor:color];
    [alert setLeftButtonColor:color];
    [alert show];
    return alert;
}

+ (XKCommonAlertView *)showCommonAlertViewWithTitle:(NSString *)title message:(NSString *)messge leftText:(nullable NSString *)leftText rightText:(NSString *)rightText leftBlock:(nullable void(^)(void))leftBlock rightBlock:(nullable void(^)(void))rightBlock textAlignment:(NSTextAlignment)textAlignment {
    XKCommonAlertView *alert = [[XKCommonAlertView alloc] initWithTitle:title message:messge leftButton:leftText rightButton:rightText leftBlock:leftBlock rightBlock:rightBlock textAlignment:textAlignment];
    [alert show];
    return alert;
}

@end

