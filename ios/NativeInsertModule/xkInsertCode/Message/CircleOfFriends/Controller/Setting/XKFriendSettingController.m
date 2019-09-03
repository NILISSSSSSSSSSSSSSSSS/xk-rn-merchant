/*******************************************************************************
 # File        : XKContactBaseViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/10
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendSettingController.h"
#import "XKFriendSettingViewModel.h"

@interface XKFriendSettingController ()
@property(nonatomic, strong) XKFriendSettingViewModel *viewModel;
/**<##>*/
@property(nonatomic, strong) UITableView *tableView;

/**<##>*/
@property(nonatomic, assign) BOOL infoChangeStatus;
@end

@implementation XKFriendSettingController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    //
    [self requestDetialNeedTip:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:XKFriendListInfoChangeNoti object:nil];
    EXECUTE_BLOCK(self.changeInfo,self);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    __weak typeof(self) weakSelf = self;
    _viewModel = [[XKFriendSettingViewModel alloc] init];
    _viewModel.isOfficalTeam = self.isOfficalTeam;
    _viewModel.userId = self.userId;
    _viewModel.teamId = self.teamId;
    [_viewModel setRefreshTableView:^{
        [weakSelf.tableView reloadData];
        weakSelf.infoChangeStatus = YES;
    }];
    [_viewModel setRefreshData:^{
        [weakSelf requestDetialNeedTip:NO];
    }];
}

#pragma mark - 初始化界面
- (void)createUI {
    [self setNavTitle:@"可友设置" WithColor:[UIColor whiteColor]];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = HEX_RGB(0xEEEEEE);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self.viewModel;
    self.tableView.dataSource = self.viewModel;
    [self.containView addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containView).insets(UIEdgeInsetsMake(0, 10, 10, 10));
    }];
    [_viewModel registerCellForTableView:self.tableView];
    
    // 创建按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.backgroundColor = HEX_RGB(0xEE6161);
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:17];
    deleteBtn.layer.cornerRadius = 8;
    deleteBtn.layer.masksToBounds = YES;
    deleteBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    [deleteBtn setTitle:@"删除可友" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(clickdeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = deleteBtn;
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)requestDetialNeedTip:(BOOL)needTip {
    if (needTip) {
        [XKHudView showLoadingTo:self.containView animated:YES];
    }
    [self.viewModel requestDetailComplete:^(NSString *error, id data) {
        [XKHudView hideHUDForView:self.containView];
        if (error) {
            [XKHudView showErrorMessage:error to:self.containView animated:YES];
        }
        [self.tableView reloadData];
    }];
}

- (void)clickdeleteBtn {
    [XKAlertView showCommonAlertViewWithTitle:@"提示" message:@"确认删除可友？" leftText:@"删除" rightText:@"取消" leftBlock:^{
        [XKHudView showLoadingTo:self.containView animated:YES];
        [XKFriendshipManager requestDeleteFriend:self.userId complete:^(NSString *error, id data) {
            [XKHudView hideHUDForView:self.containView animated:YES];
            if (error) {
                [XKHudView showErrorMessage:error to:self.containView animated:YES];
            } else {
                EXECUTE_BLOCK(self.deleteBlock,self);
            }
        }];
    } rightBlock:^{
        //
    } textAlignment:NSTextAlignmentCenter];
}

@end
