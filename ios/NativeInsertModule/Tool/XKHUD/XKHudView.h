//
//  XKHudView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/10.
//  Copyright © 2018年 xk. All rights reserved.

#import <UIKit/UIKit.h>
#import "XKProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

static NSTimeInterval toastDefaultTime = 1.5; // toast默认显示时间

typedef void(^XKHudCompletion)(void);

@interface XKHudView : NSObject

/**全局设置默认显示时长 deflaut 2s */
+ (void)setDefualtShowTime:(NSTimeInterval)time;


#pragma mark - 文本提示
/**快捷显示在window上*/
+ (XKProgressHUD *)showTipMessage:(NSString *_Nullable)message;
+ (XKProgressHUD *)showTipMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view animated:(BOOL)annimated;
+ (XKProgressHUD *)showTipMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion;

#pragma mark - 转圈加载提示
+ (XKProgressHUD *)showLoadingTo:(UIView *_Nullable)view animated:(BOOL)annimated;
+ (XKProgressHUD *)showLoadingMessage:(NSString* _Nullable)message to:(UIView *_Nullable)view animated:(BOOL)annimated;

#pragma mark - 默认图片提示
/**快捷显示在window上*/
+ (XKProgressHUD *)showSuccessMessage:(NSString *_Nullable)message;
+ (XKProgressHUD *)showSuccessMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view animated:(BOOL)annimated;
+ (XKProgressHUD *)showSuccessMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion;

/**快捷显示在window上*/
+ (XKProgressHUD *)showErrorMessage:(NSString *_Nullable)message;
+ (XKProgressHUD *)showErrorMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view animated:(BOOL)annimated;
+ (XKProgressHUD *)showErrorMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion;

/**快捷显示在window上*/
+ (XKProgressHUD *)showInfoMessage:(NSString *_Nullable)message;
+ (XKProgressHUD *)showInfoMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view animated:(BOOL)annimated;
+ (XKProgressHUD *)showInfoMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion;

/**快捷显示在window上*/
+ (XKProgressHUD *)showWarnMessage:(NSString *_Nullable)message;
+ (XKProgressHUD *)showWarnMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view animated:(BOOL)annimated;
+ (XKProgressHUD *)showWarnMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion;

#pragma mark - 自定义图片显示
/**快捷显示在window上*/
+ (XKProgressHUD *)showCustomIcon:(NSString *)iconName message:(NSString *_Nullable)message;
+ (XKProgressHUD *)showCustomIcon:(NSString *)iconName message:(NSString *_Nullable)message to:(UIView *_Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion;

+ (void)hideHUDForView:(UIView *_Nullable)view animated:(BOOL)annimated;
+ (void)hideHUDForView:(UIView *_Nullable)view;
/**会遍历所有的view清除hud （效率低 不推荐使用,除非不知道hud到底在哪个view上）*/
+ (void)hideAllHud;

@end

NS_ASSUME_NONNULL_END
