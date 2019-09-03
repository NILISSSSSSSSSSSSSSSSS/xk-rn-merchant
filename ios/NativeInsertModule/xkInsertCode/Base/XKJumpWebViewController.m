//
//  XKJumpWebViewController.m
//  XKSquare
//
//  Created by hupan on 2018/10/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKJumpWebViewController.h"

@interface XKJumpWebViewController ()

@end

@implementation XKJumpWebViewController


#pragma mark - Life Cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    [self creatWkWebViewWithMethodNameArray:nil requestUrlString:nil];
    [self configViews];
    if (self.url) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
    if (self.html) {
        [self.webView loadHTMLString:self.html baseURL:nil];
    }
}

- (void)didPopToPreviousController {
    [self removeAllScriptMessageHandler];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Metheods


- (void)configNavigationBar {
    if (self.title) {
        [self setNavTitle:self.title WithColor:[UIColor whiteColor]];
    } else {
        [self setNavTitle:@"详情" WithColor:[UIColor whiteColor]];
    }
}

- (void)configViews {
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height + 10, 10, 10, 10));
    }];
}

#pragma mark - Events

#pragma mark - Custom Delegates

#pragma mark - Getters and Setters

@end
