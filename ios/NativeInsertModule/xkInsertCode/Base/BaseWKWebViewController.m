//
//  BaseWKWebViewController.m
//  XKSquare
//
//  Created by hupan on 2018/8/21.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseWKWebViewController.h"
#import "XKDeviceDataLibrery.h"
@interface BaseWKWebViewController ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIButton       *reloadBtn;
@property (nonatomic, strong) NSArray        *methodNameArray;
@property (nonatomic, copy  ) NSString       *urlString;

@end


@implementation BaseWKWebViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
}

- (void)dealloc {
    [_webView stopLoading];
    [_webView setNavigationDelegate:nil];
    [_webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cleanCacheAndCookie];
}

#pragma mark - Private Metheods


- (void)creatWkWebViewWithMethodNameArray:(NSArray *)methodNameArray requestUrlString:(NSString *)urlStr {
    self.methodNameArray = methodNameArray;
    self.urlString = urlStr;
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    if (methodNameArray.count) {
        for (NSString *methodName in methodNameArray) {
            [userContentController addScriptMessageHandler:self name:methodName];
        }
    }

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;

    if (!_webView) {
        //mark  frame在X上需要增加34
        _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
        _webView.UIDelegate = self; //设置WKUIDelegate代理
        _webView.navigationDelegate = self;
        for (UIScrollView * view in _webView.subviews) {
            if (@available(iOS 11.0, *)) {
                view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
             
            }
        }
        //kvo 添加进度监控
        [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    }
    [XKHudView showLoadingTo:_webView animated:YES];

    
    if (![self.urlString hasPrefix:@"http"]) {//容错处理
        self.urlString = [NSString stringWithFormat:@"http://%@",self.urlString];
    }

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self.view addSubview:_webView];
    /*[self.view addSubview:self.progressView];*/
}

//KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == _webView) {

        [self.progressView setAlpha:1.0f];
        BOOL animated = _webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:_webView.estimatedProgress animated:animated];

        // Once complete, fade out UIProgressView
        if(_webView.estimatedProgress >= 1.0f) {
            if (!self.jsHiddenHUDView) {
                [XKHudView hideHUDForView:_webView];
            }
            /*
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
//                [self.progressView setProgress:0.0f animated:NO];
                
            }];*/
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)jsHiddenXKHUDView {
    [XKHudView hideHUDForView:_webView];
}


- (void)cleanCacheAndCookie {
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
//    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
//    [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
//                     completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
//
//                         for (WKWebsiteDataRecord *record  in records) {
//                             [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
//                                                                       forDataRecords:@[record]
//                                                                    completionHandler:^ {
//                                                                        NSLog(@"Cookies for %@ deleted successfully",record.displayName);
//                                                                    }];
//                         }
//                     }];
    
    // All kinds of data
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    // Date from
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    //// Execute
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        // Done
        NSLog(@"Cookies deleted successfully");
    }];
    
    
    
    
}

- (void)removeAllScriptMessageHandler {
    for (NSString *methodName in self.methodNameArray) {
        [_webView.configuration.userContentController removeScriptMessageHandlerForName:methodName];
    }
}

- (void)reloadWebView {
    self.reloadBtn.hidden = YES;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (void)backBtnClick {
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - WKScriptMessageHandler JS调用OC

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"方法名:%@", message.name);
    NSLog(@"参数:%@", message.body);
    // 方法名
    SEL selector = NSSelectorFromString(message.name);
    NSString *selectorName = [NSString stringWithFormat:@"%@:",message.name];
    SEL parmSelector = NSSelectorFromString(selectorName);
    // 调用方法
    if ([self respondsToSelector:selector]) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector];
    #pragma clang diagnostic pop
    } else if ([self respondsToSelector:parmSelector]) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
         [self performSelector:parmSelector withObject:message.body];
        #pragma clang diagnostic pop
    } else {
        NSLog(@"未实行方法：%@", message.name);
    }
}

#pragma mark - OC调用JS

- (void)ocCallJSWithMethodName:(NSString *)methodName parameters:(id)parameters completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler {
    
    // oc调用js代码
    NSString *jsMethod;
    if (parameters) {
        jsMethod = [NSString stringWithFormat:@"%@('%@')", methodName, parameters];
    } else {
        jsMethod = methodName;
    }
    [_webView evaluateJavaScript:jsMethod completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        completionHandler(data,error);
    }];
    
}



#pragma mark WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    _webView.hidden = NO;
    self.reloadBtn.hidden = YES;
//    //看是否加载空网页
//    if ([webView.URL.scheme isEqual:@"about"]) {
//        webView.hidden = YES;
//    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //执行JS方法获取导航栏标题
//    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
//        self.navigationItem.title = title;
//    }];
}

// 返回内容是否允许加载
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}

//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    webView.hidden = YES;
    self.reloadBtn.hidden = NO;
}



#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - lazyLoad

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, NavigationAndStatue_Height, SCREEN_WIDTH, 2);
        // 设置进度条的色彩
        [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]];
        _progressView.progressTintColor = [UIColor blackColor];
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (UIButton *)reloadBtn{
    if (!_reloadBtn) {
        _reloadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _reloadBtn.frame = CGRectMake(0, 0, 200, 140);
        _reloadBtn.center = self.view.center;
        [_reloadBtn setBackgroundImage:[UIImage imageNamed:@"loadingError"] forState:UIControlStateNormal];
        [_reloadBtn setTitle:@"网络异常，点击重新加载" forState:UIControlStateNormal];
        [_reloadBtn addTarget:self action:@selector(reloadWebView) forControlEvents:UIControlEventTouchUpInside];
        [_reloadBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _reloadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_reloadBtn setTitleEdgeInsets:UIEdgeInsetsMake(200, -50, 0, -50)];
        _reloadBtn.titleLabel.numberOfLines = 0;
        _reloadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGRect rect = _reloadBtn.frame;
        rect.origin.y -= 100;
        _reloadBtn.frame = rect;
        _reloadBtn.hidden = YES;
        [self.view addSubview:_reloadBtn];
    }
    return _reloadBtn;
}


@end
