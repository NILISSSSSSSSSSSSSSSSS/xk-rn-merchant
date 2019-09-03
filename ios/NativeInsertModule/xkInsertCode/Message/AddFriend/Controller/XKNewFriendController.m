/*******************************************************************************
 # File        : XKNewFriendController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/17
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKNewFriendController.h"
#import "XKNewFriendApplyInfo.h"
#import "XKNewFriendApplyCell.h"
#import "XKPersonDetailInfoViewController.h"
#import "XKAddFriendController.h"
#import "XKSearchFriendController.h"
#import "XKIMGlobalMethod.h"
#import "XKIMMessageNomalTextAttachment.h"
@interface XKNewFriendController () <UITableViewDelegate, UITableViewDataSource>
/**<##>*/
@property(nonatomic, strong) UIView *searchView;
/**<##>*/
@property(nonatomic, strong) UITextField *searchField;
/**<##>*/
@property(nonatomic, strong) UITableView *tableView;
/**<##>*/
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation XKNewFriendController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    //
    [self requestNeedTip:YES];
    
    [[XKRedPointManager getMsgTabBarRedPointItem].newFriendItem cleanItemRedPoint];
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
    _dataArray = @[].mutableCopy;
}

#pragma mark - 初始化界面
- (void)createUI {
    [self createSearchView];
    [self createTableView];
}

- (void)createTableView {
    [self setNavTitle:@"新的好友" WithColor:[UIColor whiteColor]];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = self.containView.backgroundColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.containView addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(5);
        make.left.equalTo(self.containView).offset(15);
        make.right.equalTo(self.containView).offset(-15);
        make.bottom.equalTo(self.containView.mas_bottom);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"新的好友申请";
    label.font = XKRegularFont(14);
    label.textColor = HEX_RGB(0x777777);
    label.frame = CGRectMake(0, 0, 20, 35);
    self.tableView.tableHeaderView = label;
    
    [self.tableView registerClass:[XKNewFriendApplyCell class] forCellReuseIdentifier:@"cell"];
}

- (void)createSearchView {
    __weak typeof(self) weakSelf = self;
    _searchView = [UIView new];
    _searchView.backgroundColor = [UIColor whiteColor];
    _searchView.xk_openClip = YES;
    _searchView.xk_radius = 8;
    _searchView.xk_clipType = XKCornerClipTypeAllCorners;
    self.searchView.frame = CGRectMake(15, 15, SCREEN_WIDTH - 30, 45);
    [self.containView addSubview:self.searchView];
    
    [_searchView bk_whenTapped:^{
        [weakSelf searchFriend];
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = self.navStyle == BaseNavWhiteStyle ? IMG_NAME(@"xk_ic_search_xi") : IMG_NAME(@"xk_ic_contact_search");
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_searchView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchView.mas_left).offset(5);
        make.height.equalTo(@16);
        make.centerY.equalTo(self.searchView);
        make.width.equalTo(@26);
    }];
    
    self.searchField = [[UITextField alloc] init];
    self.searchField.placeholder = @"";
    self.searchField.font = XKRegularFont(15);
    self.searchField.userInteractionEnabled = NO;
    self.searchField.returnKeyType = UIReturnKeyDone;
    self.searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchView addSubview:self.searchField];
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(5);
        make.top.bottom.equalTo(self.searchView);
        make.right.equalTo(self.searchView.mas_right).offset(-10);
    }];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark - 通过
- (void)pass:(NSIndexPath *)indexPath {
    XKNewFriendApplyInfo *model = self.dataArray[indexPath.row];
    [XKHudView showLoadingTo:self.containView animated:YES];
    [XKFriendshipManager requestOperateFriendApply:YES applyId:model.applyId complete:^(NSString *error, id data) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        if (error) {
            [XKHudView showErrorMessage:error to:self.containView animated:YES];
        } else {
            model.isPass = YES;
            [self.tableView reloadData];
            EXECUTE_BLOCK(self.friendStatusChange);
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                         ^{
                           NIMSession *Session = [NIMSession session:model.userId type:NIMSessionTypeP2P];
                           
                           XKIMMessageNomalTextAttachment *attachment = [[XKIMMessageNomalTextAttachment alloc] init];
                           attachment.msgContent = @"我们已经是好友了,现在可以聊天了";
                           NIMCustomObject *object    = [[NIMCustomObject alloc] init];
                           object.attachment = attachment;
                           
                           // 构造出具体消息并注入附件
                           NIMMessage *message = [[NIMMessage alloc] init];
                           message.messageObject = object;
                           message.from = Session.sessionId;
                           [[NIMSDK sharedSDK].conversationManager saveMessage:message forSession:Session completion:^(NSError * _Nullable error) {
                                [XKIMGlobalMethod sendTextMessage:@"我通过了你的好友验证，现在我们可以聊天了。" session:Session];
                           }];
                         });
        }
    }];
    
}

#pragma mark - 点击头像
- (void)clickHead:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    XKNewFriendApplyInfo *model = self.dataArray[indexPath.row];
    XKPersonDetailInfoViewController *vc = [XKPersonDetailInfoViewController new];
    if (!model.isPass) {
        vc.isAcceptApply = YES;
        vc.applyInfo = model.validateMsg;
        vc.userId = model.userId;
        vc.applyId = model.applyId;
        [vc setAddBlackList:^(NSString *userId) { // 被搞进黑名单了
            [weakSelf deleteApply:indexPath needTip:NO];
        }];
        [vc setAddFriend:^(NSString *applyId) {
            model.isPass = YES;
            [weakSelf.tableView reloadData];
        }];
    }
    vc.userId = model.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 删除
- (void)deleteApply:(NSIndexPath *)indexPath needTip:(BOOL)needTip {
    XKNewFriendApplyInfo *model = self.dataArray[indexPath.row];
    if (needTip) {
        [XKHudView showLoadingTo:self.containView animated:YES];
    }
    
    [XKFriendshipManager requestOperateFriendApply:NO applyId:model.applyId complete:^(NSString *error, id data) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        if (error) {
            [XKHudView showErrorMessage:error to:self.containView animated:YES];
        } else {
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
    }];
}

#pragma mark - 查找朋友
- (void)searchFriend {
    XKSearchFriendController *vc = [XKSearchFriendController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----------------------------- 网络请求 ------------------------------
- (void)requestNeedTip:(BOOL)needTip {
    if (needTip) {
        [XKHudView showLoadingTo:self.containView animated:YES];
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/friendsApplyRecord/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKNewFriendApplyInfo class] json:responseObject]];
        [self.tableView reloadData];
        [XKHudView hideHUDForView:self.containView animated:YES];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
    }];
}
#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  __weak typeof(self) weakSelf = self;
  XKNewFriendApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  cell.indexPath = indexPath;
  cell.contentView.xk_openClip = YES;
  cell.contentView.xk_radius = 8;
  
  if (indexPath.row == 0) {
    cell.contentView.xk_clipType = XKCornerClipTypeTopBoth;
    [cell hiddenSeperateLine:NO];
    if (self.dataArray.count == 1) {
      cell.contentView.xk_clipType = XKCornerClipTypeAllCorners;
    }
  } else if (indexPath.row != self.dataArray.count - 1) { // 不是最后一个
    cell.contentView.xk_clipType = XKCornerClipTypeNone;
  } else { // 最后一个
    cell.contentView.xk_clipType = XKCornerClipTypeBottomBoth;
    [cell hiddenSeperateLine:YES];
  }
  [cell setOperationClick:^(NSIndexPath *indexPath) {
    [weakSelf pass:indexPath];
  }];
  [cell setHeadClick:^(NSIndexPath *indexPath) {
    [weakSelf clickHead:indexPath];
  }];
  cell.model = self.dataArray[indexPath.row];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

#pragma mark - 侧滑
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf deleteApply:indexPath needTip:YES];
    }];
    return @[removeAction];
}

@end
