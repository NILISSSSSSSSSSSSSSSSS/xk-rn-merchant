/*******************************************************************************
 # File        : XKRealNameResultController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/6
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKRealNameResultController.h"
#import "XKEmptyPlaceView.h"
#import "UIImage+Edit.h"
#import "XKRealNameAuthController.h"
@interface XKRealNameResultController ()
/**<##>*/
@property(nonatomic, strong) XKEmptyPlaceView *resultView;
@end

@implementation XKRealNameResultController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    //
    [UIViewController cleanFromCurrentStackTargetVCClass:[XKRealNameAuthController class]];
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
    self.navigationView.hidden = NO;
    [self setNavTitle:@"实名认证" WithColor:[UIColor whiteColor]];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
    
    config.btnColor = [UIColor whiteColor];
    config.btnFont = XKRegularFont(17);
    config.descriptionColor = HEX_RGB(0x777777);
    config.descriptionFont = XKRegularFont(14);
    config.btnMargin = 10;
    config.btnBackImg = HEX_RGB(0x4A90FA);
    config.spaceHeight = 10;
    _resultView = [XKEmptyPlaceView configScrollView:scrollView config:config];
}

- (void)viewDidLayoutSubviews {
    [_resultView showWithImgName:@"xk_ic_main_authResult" title:@"" des:@"\n您已成功提交，请耐心等待工作人员审核\n" btnText:@"返回" btnImg:nil tapClick:^{
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"XKMineSettingRootViewController")]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
