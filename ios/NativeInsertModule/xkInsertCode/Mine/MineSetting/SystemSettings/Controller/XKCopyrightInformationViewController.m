/*******************************************************************************
 # File        : XKCopyrightInformationViewController.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/7
 # Corporation : 水木科技
 # Description :
 
 -------------------------------------------------------------------------------
 # Date        : 2018/9/7
 # Author      : Lin Li
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCopyrightInformationViewController.h"
#import "UIView+XKCornerRadius.h"
#import <WebKit/WebKit.h>
@interface XKCopyrightInformationViewController ()

@end

@implementation XKCopyrightInformationViewController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"版权信息" WithColor:[UIColor whiteColor]];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.xk_openClip = YES;
    contentView.xk_radius = 5;
    contentView.xk_clipType = XKCornerClipTypeAllCorners;
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NavigationAndStatue_Height + 10));
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.bottom.equalTo(@(-20));
    }];
    WKWebView *webView = [[WKWebView alloc]init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [webView loadRequest:request];
    [contentView addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
    
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
