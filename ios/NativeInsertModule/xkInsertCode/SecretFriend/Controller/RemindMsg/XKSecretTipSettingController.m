/*******************************************************************************
 # File        : XKSecretTipSettingController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/12
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSecretTipSettingController.h"
#import "XKSecretTipCell.h"
#import "XKContactListController.h"
#import "XKSecretTipEditController.h"
#import "XKSecretMappingFriend.h"
#import "XKContactCacheManager.h"
#import "XKSecretTipMsgManager.h"

@interface XKSecretTipSettingController () <UITableViewDelegate,UITableViewDataSource>
/***/
@property(nonatomic, strong) UITableView *tableView;
/**<##>*/
@property(nonatomic, strong) XKSecretMappingFriend *mappingFriend;
@property(nonatomic, strong) XKContactModel *detailUserInfo;

@end

@implementation XKSecretTipSettingController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    [self requestNeedTip:YES];
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

- (void)willPopToPreviousController {
    [[XKSecretTipMsgManager shareManager] updateSecretTipSetting];
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
    self.navStyle = BaseNavWhiteStyle;
    [self setNavTitle:@"提醒设置" WithColor:[UIColor whiteColor]];
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setTitle:@"更换" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = XKRegularFont(17);
    [rightBtn addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setFrame:CGRectMake(0, 0, XKViewSize(35), XKViewSize(25))];
    [self setRightView:rightBtn withframe:rightBtn.bounds];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = HEX_RGB(0xEEEEEE);
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.containView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    // 注册cell
    [self.tableView registerClass:[XKSecretTipCell class] forCellReuseIdentifier:@"cell"];

}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)change {
    XKContactListController *vc = [XKContactListController new];
    vc.infoText = @"可友通讯录";
    vc.title = @"选择投射对象";
    vc.navStyle = BaseNavWhiteStyle;
    __weak typeof(self) weakSelf = self;
    vc.useType = XKContactUseTypeSingleSelect;
    vc.rightButtonText = @"完成";
    [vc setSureClickBlock:^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
        XKContactModel *user = contacts.firstObject;
        if (user == nil) {
            return;
        }
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"secretId"] = weakSelf.secretId;
        params[@"mappingFriendsId"] = user.userId;
        [XKHudView showLoadingTo:listVC.containView animated:YES];
        [HTTPClient getEncryptRequestWithURLString:@"im/ua/mappingFriendsUpdate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            [XKHudView hideHUDForView:listVC.containView animated:YES];
            [weakSelf requestNeedTip:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                           ^{
                               [listVC.navigationController popViewControllerAnimated:YES];
                           });

        } failure:^(XKHttpErrror *error) {
            [XKHudView hideHUDForView:listVC.containView animated:YES];
            [XKHudView showErrorMessage:error.message to:listVC.containView animated:YES];
        }];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark ----------------------------- 网络请求 ------------------------------
- (void)requestNeedTip:(BOOL)needTip {
    if (needTip) {
        [XKHudView showLoadingTo:self.containView animated:YES];
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"secretId"] = self.secretId;
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/mappingFriendsFind/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        XKSecretMappingFriend *model = [XKSecretMappingFriend yy_modelWithJSON:responseObject];
        [XKHudView hideHUDForView:self.containView animated:YES];
        [self dealData:model];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
    }];
}

- (void)dealData:(XKSecretMappingFriend *)friend {
    self.mappingFriend = nil;
    self.detailUserInfo = nil;
    if (friend.mappingFriends) {
        XKContactModel *user = [XKContactCacheManager queryContactWithUserId:friend.mappingFriends];
        if ([user isFriends]) {
            self.mappingFriend = friend;
            self.detailUserInfo = user;
        }
    }
    [self.tableView reloadData];
}

#pragma mark ----------------------------- 代理方法 ------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mappingFriend ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKSecretTipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.xk_openClip = YES;
    cell.xk_radius = 8;
    cell.xk_clipType = XKCornerClipTypeAllCorners;
    cell.infoView.titleLabel.text = self.detailUserInfo.displayName;
    if (self.mappingFriend.normalMsg.length != 0) {
        cell.infoView.desLabel.text = self.mappingFriend.normalMsg;
        cell.infoView.desLabel.textColor = HEX_RGB(0x777777);
    } else {
        cell.infoView.desLabel.text = @"请设置您的提醒消息";
        cell.infoView.desLabel.textColor = XKMainTypeColor;
    }
    [cell.infoView.imageView sd_setImageWithURL:kURL(self.detailUserInfo.avatar) placeholderImage:kDefaultHeadImg];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XKSecretTipEditController *edit = [XKSecretTipEditController new];
    edit.secretId = self.secretId;
    __weak typeof(self) weakSelf = self;
    [edit setChangeBlock:^{
        [weakSelf requestNeedTip:YES];
    }];
    [self.navigationController pushViewController:edit animated:YES];
}

#pragma mark --------------------------- setter&getter -------------------------


@end
