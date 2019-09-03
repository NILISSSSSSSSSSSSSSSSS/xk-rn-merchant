//
//  XKWelfareActivityRulesViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/8.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfareActivityRulesViewController.h"

@interface XKWelfareActivityRulesViewController ()

@end

@implementation XKWelfareActivityRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didPopToPreviousController {
    [self removeAllScriptMessageHandler];
}

#pragma mark - privite method

- (void)creatWkWebViewWithMethodNameArray:(NSArray *)methodNameArray requestUrlString:(NSString *)urlStr {
    [super creatWkWebViewWithMethodNameArray:methodNameArray requestUrlString:urlStr];
    self.navStyle = BaseNavWhiteStyle;
    [self setNavTitle:@"活动规则" WithColor:[UIColor blackColor]];
    [self.view bringSubviewToFront:self.navigationView];
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(NavigationAndStatue_Height, 0.0, 0.0, 0.0));
    }];
}

@end
