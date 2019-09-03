//
//  XKCustomerSerSecondaryListViewController.m
//  XKSquare
//
//  Created by william on 2018/10/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCustomerSerSecondaryListViewController.h"
#import "XKCustomeSerListViewController.h"
@interface XKCustomerSerSecondaryListViewController ()

@end

@implementation XKCustomerSerSecondaryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
}

-(void)configView{
    [self setNavTitle:@"客服消息" WithColor:[UIColor whiteColor]];
    [self setBackButton:nil andName:nil];
    
    XKCustomeSerListViewController *vc = [[XKCustomeSerListViewController alloc]init];
    vc.view.frame = CGRectMake(0, NavigationAndStatue_Height, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationAndStatue_Height);
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
