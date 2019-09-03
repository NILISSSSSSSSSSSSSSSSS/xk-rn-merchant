/*******************************************************************************
 # File        : XKFriendsCircleListController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/8/24
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendsCircleListController.h"
#import "XKFriendsCircleListViewModel.h"
#import <IQKeyboardManager.h>
#import "XKFriendCircleNewTipView.h"
#import "XKFriendTalkMsgRecordController.h"

@interface XKFriendsCircleListController () {
    UIImageView *_backImgView;
    UIImageView *_headerImg;
    UILabel *_nameLabel;
    UILabel *_shuoshuoLabel;
    BOOL _statusLight;
    BOOL _hasRequest;
}

/**tableView*/
@property(nonatomic, strong) UITableView *tableView;
/**viewModel*/
@property(nonatomic, strong) XKFriendsCircleListViewModel *viewModel;
/**<##>*/
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;
@end

@implementation XKFriendsCircleListController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    //
    
    [self handleRed];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRed) name:XKRedPointForFriendCircleNoti object:nil];
}

#pragma mark - 初始化界面
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.clipsToBounds = YES;
    
    self.navigationView.hidden = !self.showNaviBar;
    if (self.showNaviBar) {
        [self setNavTitle:@"可友圈" WithColor:[UIColor whiteColor]];
    }
    
    [self createTableView];
    XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
    config.verticalOffset = -80;
    config.viewAllowTap = NO;
    config.spaceHeight = 10;
    _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.clipsToBounds = NO;
    [self.view addSubview:_tableView];
    [self.view bringSubviewToFront:self.navigationView];
    

    //处理留白
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (self.showNaviBar) {
            make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
        } else {
            make.top.mas_equalTo(self.view.mas_top);
        }
        make.bottom.equalTo(self.view);
    }];
    
    _tableView.delegate = self.viewModel;
    _tableView.dataSource = self.viewModel;
    _tableView.backgroundColor = HEX_RGB(0xEEEEEE);
    _tableView.estimatedRowHeight = 100;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableView.showsVerticalScrollIndicator = NO;
    
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestDataRefresh:YES NeedTip:NO];
    }];
    MJRefreshBackNormalFooter *mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestDataRefresh:NO NeedTip:NO];
    }];
    _tableView.mj_footer.hidden = YES;
    _tableView.mj_footer = mj_footer;
    [mj_footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
    [self.viewModel registerCellForTableView:self.tableView];
    [self.viewModel configVCToolBar:self];

    [self.viewModel setRefreshTableView:^{
        [weakSelf.tableView reloadData];
    }];
}
     
- (void)handleRed {
    __weak typeof(self) weakSelf = self;
    XKRedPointForFriendCircle *cicleItem = [XKRedPointManager getMsgTabBarRedPointItem].friendCicleItem;
    if (cicleItem.unReadTipStatus) { // 提醒
        XKFriendCircleNewTipView *tipView = [[XKFriendCircleNewTipView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
        [tipView updateUI:cicleItem.unReadTip];
        [tipView setClick:^{
            [weakSelf jumpMsgRecord];
        }];
        _tableView.tableHeaderView = tipView;
    } else {
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0.01)];
    }
}

- (void)jumpMsgRecord {
    XKFriendTalkMsgRecordController *vc = [XKFriendTalkMsgRecordController new];
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

- (void)refreshList {
    [self requestDataRefresh:YES NeedTip:NO];
}

- (void)requestFirst {
    if (_hasRequest== NO) { // 需要请求
        [self requestDataRefresh:YES NeedTip:YES];
        _hasRequest = YES;
    }
}

- (void)requestDataRefresh:(BOOL)refresh NeedTip:(BOOL)needTip {
    if (needTip) {
        [XKHudView showLoadingTo:self.tableView animated:YES];
    }
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestRefresh:refresh complete:^(id error, id data) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [self resetMJHeaderFooter:self.viewModel.refreshStatus tableView:self.tableView dataArray:self.viewModel.dataArray];
        [self.tableView reloadData];
        if (error) {
            if (self.viewModel.dataArray.count == 0) {
                self.emptyView.config.allowScroll = NO;
                self.emptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
                [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                    [weakSelf requestDataRefresh:YES NeedTip:YES];
                }];
            } else {
                [XKHudView showErrorMessage:error to:self.tableView animated:YES];
            }
        } else {
            if (refresh) {
                EXECUTE_BLOCK(self.requestFirstPageSuccess);
                [[XKRedPointManager getMsgTabBarRedPointItem].friendCicleItem resetItemRedPointStatus];
                // 清空红点操作
                [[XKRedPointManager getMsgTabBarRedPointItem].friendCicleItem cleanNewsTalkStatus];
            }
            self.emptyView.config.allowScroll = YES;
            if (self.viewModel.dataArray.count == 0) {
                self.emptyView.config.viewAllowTap = NO;
                [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"还没有任何动态哦" tapClick:nil];
            } else {
                [self.emptyView hide];
            }
        }
    }];
}

#pragma mark --------------------------- setter&getter -------------------------
- (XKFriendsCircleListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XKFriendsCircleListViewModel alloc] init];
    }
    return _viewModel;
}

@end
