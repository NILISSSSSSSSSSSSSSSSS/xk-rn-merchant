//
//  XKHudView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/10.
//  Copyright © 2018年 xk. All rights reserved.

#import "XKHudView.h"


@implementation XKHudView

#pragma mark - 创建MB

/**
 内部使用的方法   创建MB
 
 @param message  文案
 @param view 传入的视图 为nil 默认在window上
 @return MB
 */
+ (XKProgressHUD*)createMBProgressHUDviewWithMessage:(NSString*)message view:(UIView *)view completion:(XKHudCompletion _Nullable)completion {
    if (view == nil) {
        view = (UIView*)[UIApplication sharedApplication].delegate.window;
    }
    XKProgressHUD *hud = [XKProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:15];
    [self fixHudOffest:hud  view:view];
    hud.minSize = CGSizeMake(100, 100);
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    hud.completionBlock = completion;
    return hud;
}

#pragma mark - 修复偏移量下方的问题
+ (void)fixHudOffest:(XKProgressHUD *)hude view:(UIView *)view {
    if (view.tag == kNeedFixHudOffestViewTag) {
        if (view.y <= NavigationAndStatue_Height) {
            hude.yOffset = - NavigationAndStatue_Height / 2;
        }
    } else {
        if ([view isKindOfClass:[UITableView class]]) {
            CGFloat space = SCREEN_HEIGHT - NavigationAndStatue_Height - view.height;
            if (space < 20 && space >= 0) { // tableView在导航栏下
                hude.yOffset = - (NavigationAndStatue_Height + space)/ 2;
            }
        }
    }
}

+ (void)setDefualtShowTime:(NSTimeInterval)time {
    toastDefaultTime = time;
}

#pragma mark-------------------- show Tip----------------------------

+ (XKProgressHUD *)showTipMessage:(NSString *)message {
    return [self commomShowTipMessage:message view:nil time:toastDefaultTime animated:YES completion:nil];
}

+ (XKProgressHUD *)showTipMessage:(NSString *)message to:(UIView *)view animated:(BOOL)annimated {
    return [self commomShowTipMessage:message view:view time:toastDefaultTime animated:annimated completion:nil];
}

+ (XKProgressHUD *)showTipMessage:(NSString *)message to:(UIView *)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion {
    return [self commomShowTipMessage:message view:nil time:time animated:annimated completion:completion];
}

+ (XKProgressHUD *)commomShowTipMessage:(NSString *)message view:(UIView *)view time:(NSTimeInterval)aTime animated:(BOOL)annimated  completion:(XKHudCompletion _Nullable)completion {
    XKProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message view:view completion:completion];
    hud.minSize = CGSizeZero;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message?message:@"     ";
    [hud hide:annimated afterDelay:aTime];
    return hud;
}

#pragma mark-------------------- show Activity----------------------------

+ (XKProgressHUD *)showLoadingMessage:(NSString *)message to:(UIView *)view animated:(BOOL)annimated {
    return [self commonShowActivityMessage:message view:view time:0 animated:annimated];
}

+ (XKProgressHUD *)showLoadingTo:(UIView *)view animated:(BOOL)annimated {
    return [self commonShowActivityMessage:@"加载中" view:view time:0 animated:annimated];
}

+ (XKProgressHUD *)commonShowActivityMessage:(NSString*)message view:(UIView *)view time:(NSTimeInterval)aTime animated:(BOOL)annimated {
    XKProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message view:view completion:nil];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = message?message:@"加载中";
    if (aTime>0) {
        [hud hide:YES afterDelay:aTime];
    }
    return hud;
}


#pragma mark-------------------- show Image----------------------------
// Success
+ (XKProgressHUD *)showSuccessMessage:(NSString *)message {
    return [self showSuccessMessage:message to:nil animated:YES];
}

+ (XKProgressHUD *)showSuccessMessage:(NSString *)message to:(UIView *)view animated:(BOOL)annimated {
    return [self showSuccessMessage:message to:view time:toastDefaultTime animated:annimated completion:nil];
}

+ (XKProgressHUD *)showSuccessMessage:(NSString *)message to:(UIView *)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion {
    NSString *name =@"XKHudResources.bundle/MBProgressHUD/MBHUD_Success";
    return [self commonShowCustomIcon:name message:message view:view time:toastDefaultTime animated:annimated completion:completion];
}

// Error
+ (XKProgressHUD *)showErrorMessage:(NSString *)message {
    return [self showErrorMessage:message to:nil animated:YES];
}

+ (XKProgressHUD *)showErrorMessage:(NSString *)message to:(UIView *)view animated:(BOOL)annimated {
    return [self showErrorMessage:message to:view time:toastDefaultTime animated:annimated completion:nil];
}

+ (XKProgressHUD *)showErrorMessage:(NSString *)message to:(UIView * _Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion {
    NSString *name =@"XKHudResources.bundle/MBProgressHUD/MBHUD_Warn";
    return [self commonShowCustomIcon:name message:message view:view time:time animated:annimated completion:completion];
}

// Info
+ (XKProgressHUD *)showInfoMessage:(NSString *)message {
    return [self showInfoMessage:message to:nil animated:YES];
}

+ (XKProgressHUD *)showInfoMessage:(NSString *)message to:(UIView *)view animated:(BOOL)annimated {
    return [self showInfoMessage:message to:view time:toastDefaultTime animated:annimated completion:nil];
}

+ (XKProgressHUD *)showInfoMessage:(NSString *)message to:(UIView *)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion{
    NSString *name =@"XKHudResources.bundle/MBProgressHUD/MBHUD_Info";
    return [self commonShowCustomIcon:name message:message view:view time:time animated:annimated completion:completion];
}

// warning
+ (XKProgressHUD *)showWarnMessage:(NSString *)message {
    return [self showWarnMessage:message to:nil animated:YES];
}

+ (XKProgressHUD *)showWarnMessage:(NSString *)message to:(UIView *)view animated:(BOOL)annimated {
    return [self showWarnMessage:message to:view time:toastDefaultTime animated:annimated completion:nil];
}

+ (XKProgressHUD *)showWarnMessage:(NSString *)message to:(UIView * _Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion {
    NSString *name =@"XKHudResources.bundle/MBProgressHUD/MBHUD_Warn";
    return [self commonShowCustomIcon:name message:message view:view time:time animated:annimated completion:completion];
}

// custom
+ (XKProgressHUD *)showCustomIcon:(NSString *)iconName message:(NSString *)message {
    return [self showCustomIcon:iconName message:message to:nil time:toastDefaultTime animated:YES completion:nil];
}

+ (XKProgressHUD *)showCustomIcon:(NSString *)iconName message:(NSString *)message to:(UIView *)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion {
    return [self commonShowCustomIcon:iconName message:message view:view time:time animated:annimated completion:completion];
}

+ (XKProgressHUD *)commonShowCustomIcon:(NSString *)iconName message:(NSString *)message view:(UIView *)view time:(NSTimeInterval)aTime animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion {
    XKProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message view:view completion:completion];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = message?message:@"    ";
    [hud hide:YES afterDelay:aTime];
    return hud;
}


+ (void)hideHUDForView:(UIView *)view animated:(BOOL)annimated {
    if (view == nil) {
        UIView  *winView =(UIView*)[UIApplication sharedApplication].delegate.window;
        [XKProgressHUD hideAllHUDsForView:winView animated:annimated];
        return;
    }
    [XKProgressHUD hideAllHUDsForView:view animated:annimated];
}

+ (void)hideHUDForView:(UIView *)view {
    [self hideHUDForView:view animated:YES];
}

#pragma mark - 清除所有的hud
+ (void)hideAllHud {
    [self hideHUDForView:nil]; // 清除window上的
    UIViewController *currentVC = [XKHudView getCurrentUIVC];
    [self recursionHideAllHudForView:currentVC.view]; // 清除当前控制器view上的hud 包括子上面的视图的所有
    // 存在控制器有子视图控制器的情况
    NSArray *childVCs = currentVC.childViewControllers;
    for (UIViewController *childVC in childVCs) {
        [self recursionHideAllHudForView:childVC.view];
    }
}

#pragma mark - 递归搞事情
+ (void)recursionHideAllHudForView:(UIView *)view {
    NSArray *views = view.subviews;
    for (UIView *view in views) {
        if ([view isKindOfClass:[XKProgressHUD class]]) {
            XKProgressHUD *hud = (XKProgressHUD *)view;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:NO];
        } else {
            [self recursionHideAllHudForView:view];
        }
    }
}

/**常规写法*/
+ (UIViewController *)getCurrentUIVC {
    return [NSObject getCurrentUIVC];
}



@end
