///*******************************************************************************
// # File        : XKMineCollectRootViewController.m
// # Project     : XKSquare
// # Author      : Lin Li
// # Created     : 2018/9/7
// # Corporation : 水木科技
// # Description :
// <#Description Logs#>
// -------------------------------------------------------------------------------
// # Date        : <#Change Date#>
// # Author      : <#Change Author#>
// # Notes       :
// <#Change Logs#>
// ******************************************************************************/
//
#import "XKMineCollectRootViewController.h"
//#import "XKScrollPageMenuView.h"
//#import "XKMineCollectShopViewController.h"
//#import "XKMineCollectGoogsViewController.h"
//#import "XKMineCollectGamesViewController.h"
//#import "XKMineCollectVideoViewController.h"
//#import "XKMineCollectWelfareViewController.h"
//#import "XKMineCollectSearchViewController.h"
@interface XKMineCollectRootViewController (){
}
///*menu 视图*/
//@property (nonatomic, strong)XKScrollPageMenuView *pageMenu;
//@property (nonatomic, strong)XKMineCollectGoogsViewController *goodsVC;
//@property (nonatomic, strong)XKMineCollectShopViewController  *shopVC;
//@property (nonatomic, strong)XKMineCollectGamesViewController *gamesVC;
//@property (nonatomic, strong)XKMineCollectVideoViewController *videoVC;
//@property (nonatomic, strong)XKMineCollectWelfareViewController *welfareVC;
///**当前控制器*/
//@property(nonatomic, strong) UIViewController *currentVC;
//@property (nonatomic, assign)NSInteger index;
//@property (nonatomic, strong)UIButton *currentButton;
//@property (nonatomic, assign)BOOL isManagerStatus;
//@property (nonatomic, strong)UIButton *sendButton;
///**发送的数量*/
//@property(nonatomic, assign) NSInteger sendCount;
///**发送收藏的数组*/
//@property(nonatomic, strong) NSMutableArray *sendCountArray;
@end
//
@implementation XKMineCollectRootViewController
//
//#pragma mark ----------------------------- 生命周期 ------------------------------
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    _isManagerStatus = NO;
//    // 初始化默认数据
//    [self createDefaultData];
//    // 初始化界面
//    [self createUI];
//    if (self.controllerType == XKCollectControllerCollectType) {
//        [self setNavTitle:@"我的收藏" WithColor:[UIColor whiteColor]];
//        [self setNavRightButton];
//    }else if (self.controllerType == XKBrowseControllerType){
//        [self setNavTitle:@"我的浏览" WithColor:[UIColor whiteColor]];
//        [self setNavRightButton];
//    }else if (self.controllerType == XKMeassageCollectControllerType){
//        [self setNavTitle:@"我的收藏" WithColor:[UIColor whiteColor]];
//        [self setMessageCollectNavRightButton];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changerCount:) name:XKCollectionSendAddCount object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reduceCount:) name:XKCollectionSendreduceCount object:nil];
//    }
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    
//}
//
//- (void)dealloc {
//    NSLog(@"=====%@被销毁了=====", [self class]);
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:XKCollectionSendAddCount object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:XKCollectionSendreduceCount object:nil];
//}
//
//#pragma mark - 初始化默认数据
//- (void)createDefaultData {
//    self.index = 0;
//    self.sendCount = 0;
//}
//
//#pragma mark - 初始化界面
//- (void)createUI {
//    [self.view addSubview:self.pageMenu];
//    
//}
//
//#pragma mark ----------------------------- 其他方法 ------------------------------
//- (void)setMessageCollectNavRightButton {
//    UIView *rightView = [[UIView alloc]init];
//    UIButton *button = [[UIButton alloc]init];
//    [button setTitle:@"发送" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
//    [button addTarget:self action:@selector(messageSendAction:) forControlEvents:UIControlEventTouchUpInside];
//    [rightView addSubview:button];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.top.bottom.equalTo(@0);
//        make.width.equalTo(@90);
//    }];
//    self.sendButton = button;
//    [self setRightView:rightView withframe:CGRectMake(0, 0, 90, 24)];
//}
//
//
//- (void)setNavRightButton {
//    UIView *rightView = [[UIView alloc]init];
//    UIButton *button = [[UIButton alloc]init];
//    [button setTitle:@"管理" forState:UIControlStateNormal];
//    [button setTitle:@"完成" forState:UIControlStateSelected];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
//    [button addTarget:self action:@selector(managerAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.currentButton = button;
//    UIButton *searchButton = [[UIButton alloc]init];
//    [searchButton setImage:[UIImage imageNamed:@"xk_iocn_searchBar"] forState:0];
//    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    searchButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
//    [searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
//    searchButton.hidden = YES;
//    [rightView addSubview:searchButton];
//    [rightView addSubview:button];
// 
//    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.bottom.equalTo(@0);
//        make.width.equalTo(@45);
//    }];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.top.bottom.equalTo(@0);
//        make.width.equalTo(@45);
//    }];
//    
//    [self setRightView:rightView withframe:CGRectMake(0, 0, 90, 24)];
//}
//
//- (void)managerAction:(UIButton *)sender {
//    _isManagerStatus = YES;
//    sender.selected = !sender.selected;
//    self.currentVC = self.pageMenu.childViews[self.index];
//    if(sender.selected) {
//        if ([self.currentVC respondsToSelector:@selector(updateEditLayout)]) {
//            [self.currentVC performSelector:@selector(updateEditLayout)];
//        }else{
//             @throw [NSException exceptionWithName:NSStringFromClass([self.currentVC class]) reason:@"updateEditLayout必须实现" userInfo:nil];
//        }
//    } else {
//        if ([self.currentVC respondsToSelector:@selector(restoreLayout)]) {
//            [self.currentVC performSelector:@selector(restoreLayout)];
//        }else{
//             @throw [NSException exceptionWithName:NSStringFromClass([self.currentVC class]) reason:@"restoreLayout必须实现" userInfo:nil];
//        }
//    }
//}
//
//- (void)searchAction:(UIButton *)sender {
//    XKMineCollectSearchViewController * vc = [[XKMineCollectSearchViewController alloc]init];
//    [self presentViewController:vc animated:YES completion:nil];
//    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
//}
//
//- (void)messageSendAction:(UIButton *)sender {
//    if (self.sendColloctionItemBolck) {
//        self.sendColloctionItemBolck(self.sendCountArray);
//    }
//    NSLog(@"%@",self.sendCountArray);
//}
//
//- (void)changerCount:(NSNotification *)notifition {
//    self.sendCount += 1;
//    [self.sendCountArray addObject:notifition.userInfo[@"model"]];
//    [self.sendButton setTitle:[NSString stringWithFormat:@"发送(%ld)",(long)self.sendCount] forState:UIControlStateNormal];
//
//}
//
//- (void)reduceCount:(NSNotification *)notifition {
//    self.sendCount -= 1;
//    [self.sendCountArray removeObject:notifition.userInfo[@"model"]];
//    if (self.sendCount == 0) {
//        [self.sendButton setTitle:[NSString stringWithFormat:@"发送"] forState:UIControlStateNormal];
//    }else {
//        [self.sendButton setTitle:[NSString stringWithFormat:@"发送(%ld)",(long)self.sendCount] forState:UIControlStateNormal];
//
//    }
//    
//}
//#pragma mark ----------------------------- 公用方法 ------------------------------
//
//#pragma mark ----------------------------- 网络请求 ------------------------------
//
//#pragma mark ----------------------------- 代理方法 ------------------------------
//
//#pragma mark --------------------------- setter&getter -------------------------
//#pragma mark 懒加载
//- (XKScrollPageMenuView *)pageMenu {
//    if(!_pageMenu) {
//        _pageMenu = [[XKScrollPageMenuView alloc] initWithFrame:CGRectMake(0, NavigationAndStatue_Height - 1, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationAndStatue_Height)];
//        XKWeakSelf(ws);
//
//        self.shopVC = [XKMineCollectShopViewController new];
//        self.goodsVC = [XKMineCollectGoogsViewController new];
//        self.gamesVC = [XKMineCollectGamesViewController new];
//        self.videoVC = [XKMineCollectVideoViewController new];
//        self.welfareVC = [XKMineCollectWelfareViewController new];
//        if (self.controllerType == XKCollectControllerCollectType) {
//            self.shopVC.controllerType = XKCollectControllerCollectType;
//            self.goodsVC.controllerType = XKCollectControllerCollectType;
//            self.gamesVC.controllerType = XKCollectControllerCollectType;
//            self.videoVC.controllerType = XKCollectControllerCollectType;
//            self.welfareVC.controllerType = XKCollectControllerCollectType;
//
//        }else if (self.controllerType == XKBrowseControllerType){
//            self.shopVC.controllerType = XKBrowseControllerType;
//            self.gamesVC.controllerType = XKBrowseControllerType;
//            self.goodsVC.controllerType = XKBrowseControllerType;
//            self.videoVC.controllerType = XKBrowseControllerType;
//            self.welfareVC.controllerType = XKBrowseControllerType;
//        }
//        else if (self.controllerType == XKMeassageCollectControllerType){
//            self.shopVC.controllerType = XKMeassageCollectControllerType;
//            self.gamesVC.controllerType = XKMeassageCollectControllerType;
//            self.goodsVC.controllerType = XKMeassageCollectControllerType;
//            self.videoVC.controllerType = XKMeassageCollectControllerType;
//            self.welfareVC.controllerType = XKMeassageCollectControllerType;
//        }
//        _pageMenu.selectedBlock = ^(NSInteger index) {
//            if (ws.isManagerStatus) {
//                if ([ws.currentVC performSelector:@selector(checkIsEdit)]) {
//                    [ws.currentVC performSelector:@selector(restoreLayout)];
//                }
//                ws.isManagerStatus = NO;
//                ws.currentButton.selected = NO;
//            }
//            ws.index = index;
//            if (index == 0) {
//            }else {
//                [ws.pageMenu.childViews[index] performSelector:@selector(requestFirst)];
//            }
//        };
//        _pageMenu.titles = @[@"商品", @"店铺", @"游戏",@"小视频",@"福利"];
//        _pageMenu.childViews = @[self.goodsVC, self.shopVC, self.gamesVC, self.videoVC, self.welfareVC];
//        _pageMenu.sliderSize = CGSizeMake(42, 6);
//        [self addChildViewController:self.goodsVC];
//        [self addChildViewController:self.shopVC];
//        [self addChildViewController:self.gamesVC];
//        [self addChildViewController:self.videoVC];
//        [self addChildViewController:self.welfareVC];
//        _pageMenu.selectedPageIndex = 0;
//        _pageMenu.titleColor = HEX_RGBA(0xffffff, 0.5);
//        _pageMenu.titleSelectedColor = [UIColor whiteColor];
//        _pageMenu.titleFont = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:14];
//        _pageMenu.titleSelectedFont = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:14];
//        _pageMenu.sliderColor = [UIColor whiteColor];
//        [_pageMenu.scrollView setScrollEnabled:NO];
//        _pageMenu.numberOfTitles = 5;
//        _pageMenu.titleBarHeight = 40;
//        [self.goodsVC requestFirst];
//    }
//    return _pageMenu;
//}
//
//- (NSMutableArray *)sendCountArray {
//    if (!_sendCountArray) {
//        _sendCountArray = [NSMutableArray array];
//    }
//    return _sendCountArray;
//}
@end
