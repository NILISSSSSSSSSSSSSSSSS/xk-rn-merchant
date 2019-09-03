//
//  BaseWKWebViewController.h
//  XKSquare
//
//  Created by hupan on 2018/8/21.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface BaseWKWebViewController : BaseViewController

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL      jsHiddenHUDView;
/**
 必须实现方法 webView初始化

 @param methodNameArray js调用oc的方法名数组 可为空
 @param urlStr 请求url 可为空
 */
- (void)creatWkWebViewWithMethodNameArray:(NSArray *)methodNameArray requestUrlString:(NSString *)urlStr;

/**
 oc调用js方法

 @param methodName 方法名
 @param parameters 参数
 @param completionHandler 回调
 */
- (void)ocCallJSWithMethodName:(NSString *)methodName parameters:(id)parameters completionHandler:(void (^ _Nullable)(_Nullable id data, NSError * _Nullable error))completionHandler;



/**
 重新刷新webView
 */
- (void)reloadWebView;


/**
 必须实现方法  移除所有注册方法 避免内存泄漏
 */
- (void)removeAllScriptMessageHandler;


@end


