/*******************************************************************************
 # File        : XKSecretFriendSettingController.m
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

#import "XKSecretFriendSettingController.h"
#import "XKSecretFriendSettingViewModel.h"
#import "XKSecretFrientManager.h"
@interface XKSecretFriendSettingController () {
    UIButton *_deleteBtn1;
    UIButton *_deleteBtn2;
}
@property(nonatomic, strong) XKSecretFriendSettingViewModel *viewModel;
/**<##>*/
@property(nonatomic, strong) UITableView *tableView;
/**<##>*/
@property(nonatomic, assign) BOOL infoChangeStatus;
@end

@implementation XKSecretFriendSettingController

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

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}


- (void)willPopToPreviousController {
    if (self.infoChangeStatus) {
        EXECUTE_BLOCK(self.changeInfo,self);
        [[NSNotificationCenter defaultCenter] postNotificationName:XKSecretFriendListInfoChangeNoti object:nil];
    }
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    __weak typeof(self) weakSelf = self;
    _viewModel = [[XKSecretFriendSettingViewModel alloc] init];
    _viewModel.secretId = self.secretId;
    _viewModel.userId = self.userId;
    [_viewModel setRefreshTableView:^{
        [weakSelf.tableView reloadData];
        weakSelf.infoChangeStatus = YES;
    }];
    [_viewModel setRefreshData:^{
        [weakSelf requestDetialNeedTip:NO];
    }];
    _viewModel.userId = self.userId;
}

#pragma mark - 初始化界面
- (void)createUI {
    self.navStyle = BaseNavWhiteStyle;
    [self setNavTitle:@"资料设置" WithColor:[UIColor whiteColor]];
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
    _deleteBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn1.backgroundColor = HEX_RGB(0xEE6161);
    [_deleteBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _deleteBtn1.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:17];
    _deleteBtn1.layer.cornerRadius = 8;
    _deleteBtn1.layer.masksToBounds = YES;
    _deleteBtn1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    [_deleteBtn1 setTitle:@"删除密友" forState:UIControlStateNormal];
    [_deleteBtn1 addTarget:self action:@selector(click_deleteBtn1) forControlEvents:UIControlEventTouchUpInside];
    
    _deleteBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn2.backgroundColor = HEX_RGB(0xEE6161);
    [_deleteBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _deleteBtn2.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:17];
    _deleteBtn2.layer.cornerRadius = 8;
    _deleteBtn2.layer.masksToBounds = YES;
    _deleteBtn2.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    [_deleteBtn2 setTitle:@"删除密友并删除可友" forState:UIControlStateNormal];
    [_deleteBtn2 addTarget:self action:@selector(click_deleteBtn2) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    [footerView addSubview:_deleteBtn1];
    [_deleteBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(footerView);
        make.height.equalTo(@45);
    }];
    [footerView addSubview:_deleteBtn2];
    [_deleteBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(footerView);
        make.height.equalTo(@45);
    }];
    _deleteBtn2.hidden = YES;
    self.tableView.tableFooterView = footerView;
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
        } else {
            [self updateFooterBtn];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - 更新删除按钮
- (void)updateFooterBtn {
    _deleteBtn2.hidden = NO;
    if ([self isFriend]) { // 是可友
        [_deleteBtn2 setTitle:@"删除密友并删除可友" forState:UIControlStateNormal];
    } else {
        [_deleteBtn2 setTitle:@"删除密友转为可友" forState:UIControlStateNormal];
    }
}

- (BOOL)isFriend {
    return self.viewModel.detailInfo.friendRelation != XKRelationNoting;
}

#pragma mark - 删除密友
- (void)click_deleteBtn1 {
    [XKAlertView showCommonAlertViewWithTitle:@"提示" message:[self isFriend] ? @"确认要删除密友吗？删除密友将同时删除与该密友的聊天记录。以后收发消息将转到可友中。":@"确认要删除密友吗？删除密友将同时删除与该密友的聊天记录。" leftText:@"删除" rightText:@"取消" leftBlock:^{
        [XKHudView showLoadingTo:self.containView animated:YES];
        [XKFriendshipManager requestDeleteSecretFriend:self.userId complete:^(NSString *error, id data) {
            if (error) {
                [XKHudView showErrorMessage:error to:self.containView animated:YES];
            } else {
                [XKSecretFrientManager deleteAllSecretChatHistoryInSession:[NIMSession session:self.userId type:NIMSessionTypeP2P] complete:^(BOOL success) {
                    
                }];
                EXECUTE_BLOCK(self.deleteBlock,self);
            }
        }];
    } rightBlock:^{
        //
    } textAlignment:NSTextAlignmentCenter];
}

#pragma mark - 删除密友 删除可友
- (void)click_deleteBtn2 {
    if (self.viewModel.detailInfo.friendRelation != XKRelationNoting) { // 是可友
        [XKAlertView showCommonAlertViewWithTitle:@"提示" message:@"确认要同时删除密友和可友吗？删除密友和可友将同时删除与该密友和可友的聊天记录。" leftText:@"删除" rightText:@"取消" leftBlock:^{
            [XKHudView showLoadingTo:self.containView animated:YES];
            [XKFriendshipManager requestDeleteSecretFriendBothDeleteFriend:self.userId complete:^(NSString *error, id data) {
                if (error) {
                    [XKHudView showErrorMessage:error to:self.containView animated:YES];
                } else {
                    [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:[NIMSession session:self.userId type:NIMSessionTypeP2P] option:nil];
                    EXECUTE_BLOCK(self.deleteBlock,self);
                }
            }];
        } rightBlock:^{
            //
        } textAlignment:NSTextAlignmentCenter];
    } else {
        [XKAlertView showCommonAlertViewWithTitle:@"提示" message:@"确认要删除密友并转为可友吗？删除密友将同时删除与该密友的聊天记录。以后收发消息将转到可友中。" leftText:@"删除" rightText:@"取消" leftBlock:^{
            [XKHudView showLoadingTo:self.containView animated:YES];
            [XKFriendshipManager requestDeleteSecretFriendBothReturnFriend:self.userId complete:^(NSString *error, id data) {
                if (error) {
                    [XKHudView showErrorMessage:error to:self.containView animated:YES];
                } else {
                    [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:[NIMSession session:self.userId type:NIMSessionTypeP2P] option:nil];
                    EXECUTE_BLOCK(self.deleteBlock,self);
                }
            }];
        } rightBlock:^{
            //
        } textAlignment:NSTextAlignmentCenter];
    }
}


@end
