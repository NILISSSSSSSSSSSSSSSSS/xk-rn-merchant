//
//  XKPrivacyContactBlacklistViewController.m
//  XKSquare
//
//  Created by william on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPrivacyContactBlacklistViewController.h"

@interface XKPrivacyContactBlacklistViewController ()

@end

@implementation XKPrivacyContactBlacklistViewController


#pragma mark – Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Events

#pragma mark – Private Methods
-(void)initViews{
    [self setNavTitle:@"通讯录黑名单" WithColor:[UIColor whiteColor]];
}
#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - Custom Delegates

#pragma mark – Getters and Setters

@end
