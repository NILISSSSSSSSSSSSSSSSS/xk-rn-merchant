//
//  XKCommonWebViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKCommonWebViewController.h"

@interface XKCommonWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation XKCommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    [self.containView addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    if (self.urlStr) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
        [XKHudView showLoadingTo:self.containView animated:YES];
    }
    if (self.htmlStr) {
        [self.webView loadHTMLString:self.htmlStr baseURL:nil];
        [XKHudView showLoadingTo:self.containView animated:YES];
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@", request.URL.absoluteString);
    [self setNavTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"] WithColor:HEX_RGB(0xFFFFFF)];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [XKHudView hideHUDForView:self.containView];
}

@end
