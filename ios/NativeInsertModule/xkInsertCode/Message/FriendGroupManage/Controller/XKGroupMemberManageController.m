/*******************************************************************************
 # File        : XKGroupMemberManagController.m
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

#import "XKGroupMemberManageController.h"
#import "UIView+XKCornerRadius.h"
#import "XKGroupMemberManageViewModel.h"
#import "XKContactListController.h"
#import "XKSecretContactListController.h"

#define kViewMargin 10

@interface XKGroupMemberManageController ()
/***/
@property(nonatomic, strong) UIView *headerView;
/**viewModel*/
@property(nonatomic, strong) XKGroupMemberManageViewModel *viewModel;
/**无数据框*/
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;
/**<##>*/
@property(nonatomic, assign) BOOL  change;
@end

@implementation XKGroupMemberManageController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    // 请求
    [self requestDataNeedTip:YES];
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    __weak typeof(self) weakSelf = self;
    _viewModel = [[XKGroupMemberManageViewModel alloc] init];
    _viewModel.groupId = self.groupId;
    _viewModel.isSecret = self.isSecret;
    _viewModel.secretId = self.secretId;
    _viewModel.isTag = self.mode;
    [_viewModel setRefreshBlock:^{
        [weakSelf.tableView reloadData];
    }];
    [_viewModel setRemove:^(NSIndexPath *indexPath) {
        [weakSelf remove:indexPath];
    }];
}

#pragma mark - 初始化界面
- (void)createUI {
    self.navStyle = self.isSecret ? BaseNavWhiteStyle : BaseNavBlueStyle;
    [self setNavTitle:self.mode == 0 ? @"分组管理" : @"标签管理" WithColor:[UIColor whiteColor]];
    self.containView.backgroundColor = HEX_RGB(0xEEEEEE);
    
    UIButton *newBtn = [[UIButton alloc] init];
    [newBtn setTitle:@"完成" forState:UIControlStateNormal];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newBtn.titleLabel.font = XKRegularFont(17);
    [newBtn setFrame:CGRectMake(0, 0, XKViewSize(35), 25)];
    [newBtn addTarget:self action:@selector(newClick) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:newBtn withframe:newBtn.bounds];
    
    [self createTopView];
    [self createTableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(kViewMargin);
        make.right.equalTo(self.containView.mas_right).offset(-kViewMargin);
        make.bottom.equalTo(self.containView.mas_bottom);
        make.top.equalTo(self.headerView.mas_bottom).offset(kViewMargin);
    }];
    self.tableView.delegate = self.viewModel;
    self.tableView.dataSource = self.viewModel;
    
    XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
    
    config.viewAllowTap = NO;
    _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
}

- (void)createTopView {
    // create header
    __weak typeof(self) weakSelf = self;
    self.headerView = [[UIView alloc] init];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.headerView.layer.cornerRadius = 8;
    self.headerView.layer.masksToBounds = YES;
    [self.headerView bk_whenTapped:^{
        [weakSelf addMember];
    }];
    [self.containView addSubview:self.headerView];
    UIButton *addBtn  = [UIButton new];
    [addBtn setImage:IMG_NAME(@"xk_btn_TradingArea_add") forState:UIControlStateNormal];
    addBtn.userInteractionEnabled = NO;
    [self.headerView addSubview:addBtn];
    UILabel *textLabel = [UILabel new];
    textLabel.text = @"添加成员";
    textLabel.textColor = XKMainTypeColor;
    textLabel.font = XKRegularFont(15);
    [self.headerView addSubview:textLabel];
    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left).offset(15);
        make.centerY.equalTo(self.headerView);
        make.size.mas_equalTo(CGSizeMake(20, 30));
    }];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView);
        make.left.equalTo(addBtn.mas_right).offset(10);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(10);
        make.left.equalTo(self.containView.mas_left).offset(10);
        make.right.equalTo(self.containView.mas_right).offset(-10);
        make.height.equalTo(@50);
    }];
}

- (void)backBtnClick {
    if (self.change) {
        [XKAlertView showCommonAlertViewWithTitle:@"温馨提示" message:@"有暂未保存的修改，是否退出？" leftText:@"确定" rightText:@"取消" leftBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        } rightBlock:^{
            //
        } textAlignment:NSTextAlignmentCenter];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 添加成员
- (void)addMember {
    NSArray *existFriends = self.viewModel.dataArray;
    __weak typeof(self) weakSelf = self;
    if (!self.isSecret) { // 可友分组添加成员
        XKContactListController *vc = [[XKContactListController alloc] init];
        vc.useType = XKContactUseTypeManySelect;
        [vc setRightButtonText:@"完成"];
        vc.showSelectedNum = YES;
        vc.title = @"选择联系人";
        vc.defaultSelected = existFriends;
        vc.defaultIsGray = YES;
        [vc setSureClickBlock:^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
            if (contacts.count == 0) {
               [listVC.navigationController popViewControllerAnimated:YES];
                return ;
            }
            [weakSelf requestAddMember:contacts complete:^(NSString *error, id data) {
                if (error) {
                } else {
                    [listVC.navigationController popViewControllerAnimated:YES];
                }
            }];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    } else { // 密友分组添加成员
        XKSecretContactListController *vc = [[XKSecretContactListController alloc] init];
        vc.useType = XKContactUseTypeManySelect;
        [vc setRightButtonText:@"完成"];
        vc.secretId = self.secretId;
        vc.title = @"选择联系人";
        vc.defaultSelected = existFriends;
        vc.defaultIsGray = YES;
        [vc setSureClickBlock:^(NSArray<XKContactModel *> *contacts, XKSecretContactListController *listVC) {
            if (contacts.count == 0) {
                [listVC.navigationController popViewControllerAnimated:YES];
                return ;
            }
            [weakSelf requestAddMember:contacts complete:^(NSString *error, id data) {
                if (error) {
                } else {
                    [listVC.navigationController popViewControllerAnimated:YES];
                }
            }];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 请求
- (void)requestDataNeedTip:(BOOL)tip {
    [XKHudView showLoadingTo:self.containView animated:YES];
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestComplete:^(NSString *error, NSArray *array) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [self.tableView reloadData];
        if (error) {
            if (self.viewModel.dataArray.count == 0) {
                self.emptyView.config.viewAllowTap = YES;
                [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                    [weakSelf requestDataNeedTip:YES];
                }];
            }
        } else {
            if (self.viewModel.dataArray.count == 0) {
                self.emptyView.config.viewAllowTap = NO;
                [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无成员哦" tapClick:nil];
            } else {
                [self.emptyView hide];
            }
        }
    }];
}

- (void)newClick {

    [XKHudView showLoadingTo:self.containView animated:YES];
    NSString *url = self.isSecret ? @"im/ua/secretGroupUsersUpdate/1.0" : @"im/ua/xkGroupUsersUpdate/1.0";
    NSMutableDictionary *params = @{}.mutableCopy;
    if (self.isSecret) {
        params[@"secretId"] = self.secretId;
        params[@"groupId"] = self.groupId;
        params[@"userId"] = [XKUserInfo getCurrentUserId];
    } else {
        if (self.mode) {
            params[@"groupType"] = @"friend";
        } else {
            params[@"groupType"] = @"label";
        }
        params[@"groupId"] = self.groupId;
        params[@"userId"] = [XKUserInfo getCurrentUserId];
    }

    NSMutableArray *ids = @[].mutableCopy;
    for (XKContactModel *usr in self.viewModel.dataArray) {
        [ids addObject:usr.userId];
    }
    params[@"userIds"] = ids;
    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        EXECUTE_BLOCK(self.memberChange);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
    }];
}

#pragma mark - 添加成员
- (void)requestAddMember:(NSArray *)members complete:(void(^)(NSString *error, id data))complete {
    self.change = YES;
    __weak typeof(self) weakSelf = self;
    // 其实木有做请求
    [self.viewModel addMembers:members complete:^(NSString *error, id data) {
        if (!error) {
            [weakSelf.tableView reloadData];
        }
        if (weakSelf.viewModel.dataArray.count == 0) {
            weakSelf.emptyView.config.viewAllowTap = NO;
            [weakSelf.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无成员哦" tapClick:nil];
        } else {
            [weakSelf.emptyView hide];
        }
        complete(error,data);
    }];
}

#pragma mark - 移除
- (void)remove:(NSIndexPath *)indexPath {
    self.change = YES;
    __weak typeof(self) weakSelf = self;
    // 其实木有做请求
    [self.viewModel removeList:indexPath complete:^(NSString *error, id data) {
        if (error) {
            [XKHudView showWarnMessage:error to:weakSelf.containView animated:YES];
        } else {
            [weakSelf.tableView reloadData];
            if (weakSelf.viewModel.dataArray.count == 0) {
                weakSelf.emptyView.config.viewAllowTap = NO;
                [weakSelf.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无成员哦" tapClick:nil];
            } else {
                [weakSelf.emptyView hide];
            }
        }
    }];
}

@end
