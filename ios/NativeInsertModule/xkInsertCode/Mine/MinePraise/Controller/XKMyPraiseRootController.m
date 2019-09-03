/*******************************************************************************
 # File        : XKMyPraiseRootController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/14
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKMyPraiseRootController.h"
#import "XKMyPraiseFriendCircleController.h"
#import "XKMyPraiseVideoController.h"
#import "XKScrollPageMenuView.h"

@interface XKMyPraiseRootController ()
/*menu 视图*/
@property (nonatomic, strong) XKScrollPageMenuView *pageMenu;
/**vc array*/
@property(nonatomic, copy) NSArray *vcsArray;

@end

@implementation XKMyPraiseRootController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
}


- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
    [self setNavTitle:@"我的获赞" WithColor:[UIColor whiteColor]];
    [self hideNavigationSeperateLine];
    [self.containView addSubview:self.pageMenu];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------
#pragma mark 懒加载
- (XKScrollPageMenuView *)pageMenu {
    if(!_pageMenu) {
        __weak typeof(self) weakSelf = self;
        _pageMenu = [[XKScrollPageMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationAndStatue_Height)];;
        _pageMenu.selectedBlock = ^(NSInteger index) {
            XKBaseListController *vc = weakSelf.vcsArray[index];
            if ([vc respondsToSelector:@selector(requestFirst)]) {
                [vc requestFirst];
            }
        };
        XKMyPraiseVideoController *videoVc = [NSClassFromString(@"XKMyPraiseVideoController") new];
        XKMyPraiseFriendCircleController *circleVC= [NSClassFromString(@"XKMyPraiseFriendCircleController") new];
        
        [self addChildViewController:videoVc];
        [self addChildViewController:circleVC];
        _pageMenu.titles = @[@"小视频", @"可友圈"];
        _pageMenu.sliderSize = CGSizeMake(42, 6);
        _pageMenu.selectedPageIndex = 0;
        _pageMenu.titleColor = HEX_RGBA(0xffffff, 0.5);
        _pageMenu.titleSelectedColor = [UIColor whiteColor];
        _pageMenu.titleFont = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:14];
        _pageMenu.titleSelectedFont = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:14];
        _pageMenu.sliderColor = [UIColor whiteColor];
        _pageMenu.numberOfTitles = 2;
        _pageMenu.titleBarHeight = 40;
        
        _pageMenu.childViews = @[videoVc, circleVC];
        self.vcsArray = _pageMenu.childViews;
        [videoVc requestFirst];
    }
    return _pageMenu;
}


@end
