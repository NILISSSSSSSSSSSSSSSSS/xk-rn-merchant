/*******************************************************************************
 # File        : XKGroupChatSettingViewController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/29
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGroupChatSettingViewController.h"
#import "XKGroupChatSettingViewModel.h"
#import "XKChooseMediaCell.h"
#import "XKContactListController.h"
#import "XKIMTeamChatManager.h"
#import "XKGroupChatMemberController.h"


@interface XKGroupChatSettingViewController () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic, strong) XKGroupChatSettingViewModel *viewModel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIView *headView;
@property(nonatomic, strong) UILabel *seeMoreLabel;

@property(nonatomic, assign) BOOL infoChangeStatus;

@end

@implementation XKGroupChatSettingViewController

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
    if (self.infoChangeStatus) {
        EXECUTE_BLOCK(self.groupInfoChange,self.viewModel.getSettingModel);
        self.infoChangeStatus = NO;
    }
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

- (XKGroupChatSettingViewModel *)viewModel {
  if (!_viewModel) {
    _viewModel = [[XKGroupChatSettingViewModel alloc] init];
    _viewModel.isOffical = self.isOffical;
    _viewModel.merchantType = self.merchantType;
    _viewModel.session = self.session;
    __weak typeof(self) weakSelf = self;
    [_viewModel setRefreshTableView:^{
      [weakSelf reloadTotalUI];
    }];
  }
  return _viewModel;
}

#pragma mark - 初始化界面
- (void)createUI {
    [self setNavTitle:@"聊天详情" WithColor:[UIColor whiteColor]];
    
    UIButton *deleteBtn = [[UIButton alloc] init];
    [deleteBtn setTitle:@"删除并退出" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = XKRegularFont(17);
    [deleteBtn sizeToFit];
    [deleteBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:deleteBtn withframe:deleteBtn.bounds];
    [self setRightView:deleteBtn withframe:deleteBtn.frame];
    deleteBtn.hidden = YES;
    
    [self createTableView];
    [self createCollectionView];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = HEX_RGB(0xEEEEEE);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self.viewModel;
    self.tableView.dataSource = self.viewModel;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.containView addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containView).insets(UIEdgeInsetsMake(0, 10, 10, 10));
    }];
    [_viewModel registerCellForTableView:self.tableView];
}

- (void)createCollectionView {
    _headView = [UIView new];
    _headView.backgroundColor = [UIColor whiteColor];
    _headView.layer.cornerRadius = 7;
    _headView.layer.masksToBounds = YES;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kItemWidth, kItemHeight);
    layout.minimumLineSpacing = kItemSpace;
    layout.minimumInteritemSpacing = kItemSpace;
    layout.sectionInset = UIEdgeInsetsMake(kItemTopBtm,kItemSpace,kItemSpace, kItemSpace);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_headView addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[XKChooseMediaCell class] forCellWithReuseIdentifier:@"cell"];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headView);
    }];
    _seeMoreLabel = [UILabel new];
    [self.headView addSubview:_seeMoreLabel];
    [_seeMoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headView);
        make.bottom.equalTo(self.headView.mas_bottom).offset(-15);
    }];
    [_seeMoreLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentCenter);
        confer.text(@"查看更多群成员 ").textColor(HEX_RGB(0x999999)).font(XKRegularFont(14));
        confer.appendImage(IMG_NAME(@"ic_btn_msg_circle_rightArrow")).bounds(CGRectMake(0, -2, 10.5, 14));
    }];
    __weak typeof(self) weakSelf = self;
    _seeMoreLabel.userInteractionEnabled = YES;
    [_seeMoreLabel bk_whenTapped:^{
        XKGroupChatMemberController *vc = [XKGroupChatMemberController new];
        vc.viewModel = weakSelf.viewModel;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    self.tableView.tableHeaderView = self.headView;
}

#pragma mark ----------------------------- 公用方法 ------------------------------

- (void)reloadTotalUI {
    [self.viewModel resetDataArray];
    [self updateHeader];
    [self.tableView reloadData];
    self.infoChangeStatus = YES;
}

#pragma mark - 更新头部用户界面显示
- (void)updateHeader {
    [self.viewModel rebuildUserAndAddDeleteArray];
    NSInteger itemsCount = [self.viewModel.userAndAddDeleteArray count];
    NSInteger lineNum = ceil(itemsCount * 1.0 / kItemLineNum);
    self.headView.height = kItemTopBtm * 2 + lineNum * kItemHeight +  (lineNum - 1) *kItemSpace;
    if (self.viewModel.hasMoreUser) {
        self.headView.height += 36;
        self.seeMoreLabel.hidden = NO;
    } else {
        self.seeMoreLabel.hidden = YES;
    }
    [self.collectionView reloadData];
}

#pragma mark - 获取群组设置详细信息
- (void)requestDetialNeedTip:(BOOL)needTip {
    if (needTip) {
        [XKHudView showLoadingTo:self.containView animated:YES];
    }
    [self.viewModel requestSettingInfoComplete:^(NSString *error, id data) {
        [XKHudView hideHUDForView:self.containView];
        if (error) {
            [XKHudView showErrorMessage:error to:self.containView animated:YES];
        } else {
             [self reloadTotalUI];
        }
    }];
}

- (void)clickDeleteBtn {
    XKWeakSelf(weakSelf);
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:_session.sessionId];
    if ([team.owner isEqualToString:[XKUserInfo getCurrentIMUserID]]) {
        NSLog(@"我是群主");
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"群主无法退出群聊" message:@"请先将群主权限移交给其他群成员，再退出群聊" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertCon addAction:knowAction];
        [self presentViewController:alertCon animated:YES completion:nil];
    }
    else{
        NSLog(@"我不是群主");
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"您是否要退出此群聊" message:@"退出后您将不会再接收到此群消息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NIMSDK sharedSDK].teamManager quitTeam:team.teamId completion:^(NSError * _Nullable error) {
                if (!error) {
                    NIMRecentSession *recentSession = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:weakSelf.session];
                    [[self getCurrentUIVC].navigationController popToRootViewControllerAnimated:YES];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [[NIMSDK sharedSDK].conversationManager deleteRecentSession:recentSession];
                        [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:weakSelf.session option:nil];
                    });
                }
            }];
        }];
        [alertCon addAction:cancelAction];
        [alertCon addAction:confirmAction];
        [self presentViewController:alertCon animated:YES completion:nil];
    }
}

#pragma mark - 代理

#pragma mark - collectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.userAndAddDeleteArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKChooseMediaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.withoutDelte = YES;
    cell.showText = YES;
    id model = self.viewModel.userAndAddDeleteArray[indexPath.row];
    if ([model isKindOfClass:[XKContactModel class]]) {
        XKContactModel *user = (XKContactModel *)model;
        [cell.iconImgView sd_setImageWithURL:kURL(user.avatar) placeholderImage:kDefaultHeadImg];
        cell.textLabel.text = user.displayName;
    } else {
        cell.textLabel.text = @"";
        if ([model isEqualToString:@"add"]) {
            cell.iconImgView.image = IMG_NAME(@"xk_btn_friendsCirclePermissions_add");
        } else if ([model isEqualToString:@"delete"]) {
            cell.iconImgView.image = IMG_NAME(@"xk_btn_friendsCirclePermissions_delete");
        }
    }
//    XKWeakSelf(ws);
    cell.indexPath = indexPath;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel dealCollectionViewClick:indexPath dataArray:self.viewModel.userAndAddDeleteArray vc:self];
}

@end
