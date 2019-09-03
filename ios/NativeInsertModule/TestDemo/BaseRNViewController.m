/*******************************************************************************
 # File        : BaseRNViewController.m
 # Project     : NativeInsertDemo
 # Author      : Jamesholy
 # Created     : 2018/12/8
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "BaseRNViewController.h"
#import "XKConsoleBoard.h"

@interface BaseRNViewController ()

@end

@implementation BaseRNViewController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
  #if DEBUG
//    [self.view becomeFirstResponder];
  #endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
  if ([_rnId isEqualToString:@"rnId"]) {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RNMessageRootViewShow" object:nil];
  }
  
}

//
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event {
//#if DEBUG
//  if (UIEventSubtypeMotionShake ==motion) {
//    [[XKConsoleBoard borad] show];
//  }
//#endif
//}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
    
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------

-(UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

@end
