/*******************************************************************************
 # File        : XKSettingUserComplainController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/22
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSettingUserComplainController.h"
#import "XKEmptyPlaceView.h"

@interface XKSettingUserComplainController ()
/**<##>*/
@property(nonatomic, strong) UIScrollView *scrollView;
@end

@implementation XKSettingUserComplainController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self setNavTitle:@"投诉" WithColor:[UIColor whiteColor]];
    _scrollView = [UIScrollView new];
    [self.containView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containView);
    }];

    if (_isSecret) {
        self.navStyle = BaseNavWhiteStyle;
    }
    
    XKEmptyPlaceView *emptyView = [XKEmptyPlaceView configScrollView:_scrollView config:nil];
    emptyView.config.descriptionColor = HEX_RGB(0x999999);
    [emptyView showWithImgName:kEmptyPlaceImgName title:@"" des:@"此功能暂未开启，请在之后版本中再试\n谢谢你的理解" tapClick:nil];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
