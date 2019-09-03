/*******************************************************************************
 # File        : XKSecretGroupMangeController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/9
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGroupManageController.h"
#import "XKSortDeleteCell.h"
#import "XKCheckTableViewCell.h"
#import "UITableView+MoveCell.h"
#import "XKCommonAlertInputView.h"
#import "XKGroupManageViewModel.h"
#import "XKEmptyPlaceView.h"
#import "XKGroupMemberManageController.h"
@interface XKGroupManageController ()<UITableViewDelegate,UITableViewDataSource> {
  UIButton *_doneBtn;
}
/***/
@property(nonatomic, strong) UITableView *tableView;
/**<##>*/

/**<##>*/
@property(nonatomic, strong) XKGroupManageViewModel *viewModel;
/**编辑状态*/
@property(nonatomic, assign) BOOL editingStatus;
/**<##>*/
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;
@end

@implementation XKGroupManageController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
  [super viewDidLoad];
  // 初始化默认数据
  [self createDefaultData];
  // 初始化界面
  [self createUI];
  //
  [self requestListNeedTip:YES];
}

- (void)dealloc {
  NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
  _viewModel = [[XKGroupManageViewModel alloc] init];
  _viewModel.isTag = self.mode;
  _viewModel.isSecret = self.isSecret;
  _viewModel.secretId = self.secretId;
  _viewModel.defaultGroupId = self.defaultGroupId;
}

#pragma mark - 初始化界面
- (void)createUI {
  self.navStyle = self.isSecret ? BaseNavWhiteStyle : BaseNavBlueStyle;
  __weak typeof(self) weakSelf = self;
  if (_mode == 0) {
    [self setNavTitle:self.userType == 0 ? @"分组管理" : @"移动分组" WithColor:[UIColor whiteColor]];
  } else {
    [self setNavTitle:@"标签管理" WithColor:[UIColor whiteColor]];
  }
  _doneBtn = [[UIButton alloc] init];
  [_doneBtn setTitle:self.userType == 0 ? @"编辑" : @"完成" forState:UIControlStateNormal];
  [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  _doneBtn.titleLabel.font = XKMediumFont(17);
  [_doneBtn sizeToFit];
  [_doneBtn setFrame:CGRectMake(0, 0, CGRectGetWidth(_doneBtn.frame), CGRectGetHeight(_doneBtn.frame))];
  [_doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
  [self setRightView:_doneBtn withframe:_doneBtn.bounds];
  
  // create header
  UIView *headerView = [[UIView alloc] init];
  headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
  headerView.backgroundColor = [UIColor whiteColor];
  headerView.layer.cornerRadius = 8;
  headerView.layer.masksToBounds = YES;
  [headerView bk_whenTapped:^{
    [weakSelf addGroup];
  }];
  [self.containView addSubview:headerView];
  UIButton *addBtn  = [UIButton new];
  [addBtn setImage:IMG_NAME(@"xk_btn_TradingArea_add") forState:UIControlStateNormal];
  addBtn.userInteractionEnabled = NO;
  [headerView addSubview:addBtn];
  UILabel *textLabel = [UILabel new];
  textLabel.text = self.userType == 0 ? @"添加分组" : @"添加到新分组";
  if (_mode == 1) {
    textLabel.text = @"添加标签";
  }
  textLabel.textColor = HEX_RGB(0x222222);
  textLabel.font = XKRegularFont(15);
  [headerView addSubview:textLabel];
  
  [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(headerView.mas_left).offset(15);
    make.centerY.equalTo(headerView);
    make.size.mas_equalTo(CGSizeMake(20, 30));
  }];
  [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(headerView);
    make.left.equalTo(addBtn.mas_right).offset(10);
  }];
  
  [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.navigationView.mas_bottom).offset(10);
    make.left.equalTo(self.containView.mas_left).offset(10);
    make.right.equalTo(self.containView.mas_right).offset(-10);
    make.height.equalTo(@50);
  }];
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  self.tableView.backgroundColor = HEX_RGB(0xEEEEEE);
  self.tableView.tableFooterView = [UIView new];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.showsVerticalScrollIndicator = NO;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.containView addSubview:self.tableView];
  
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(headerView.mas_bottom).offset(10);
    make.left.width.equalTo(headerView);
    make.bottom.equalTo(self.containView);
  }];
  
  [self.tableView registerClass:[XKSortDeleteCell class] forCellReuseIdentifier:@"sort"];
  [self.tableView registerClass:[XKCheckTableViewCell class] forCellReuseIdentifier:@"check"];
  
  if (self.userType == 0) {
    [self.tableView configMove];
  }
  _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

- (void)reloadData {
  __weak typeof(self) weakSelf = self;
  [self.tableView setDataWithArray:self.viewModel.dataArray withBlock:^(NSMutableArray *newArray) {
    weakSelf.viewModel.dataArray = newArray;
    [weakSelf requestExchange];
  }];
  [self.tableView reloadData];
}

- (void)doneClick {
  if (self.userType == 0) {
    self.editingStatus = !self.editingStatus;
  } else {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"selected = YES"];
    XKFriendGroupModel *model = [self.viewModel.dataArray filteredArrayUsingPredicate:pre].firstObject;
    EXECUTE_BLOCK(self.chooseBlock,model,self);
  }
}

- (void)addGroup {
  if (self.isSecret == YES && self.viewModel.dataArray.count == 10) {
    [XKHudView showTipMessage:@"最多设置10个分组"];
    return;
  }
  NSString *title = self.mode == 0 ? @"添加分组" : @"添加分组";
  NSString *des = self.mode == 0 ? @"请输入分组名称" : @"请输入标签名称";
  XKCommonAlertInputView *view = [[XKCommonAlertInputView alloc] initWithTitle:title placeHolder:des maxNum:7 message:nil leftButton:@"取消" rightButton:@"确定" leftBlock:^(NSString *text){
  } rightBlock:^(NSString *text) {
    [self requestAddGroup:text];
  } isBeginFirstResponder:YES];
  [view setCloseButtonHidden:YES];
  [view show];
}

- (void)backBtnClick {
  [super backBtnClick];
}
- (void)didPopToPreviousController {
  if (self.viewModel.isSendNotification) {
    if (self.isSecret) {
      [[NSNotificationCenter defaultCenter]postNotificationName:XKSecretFriendGroupChange object:nil];
    } else {
      [[NSNotificationCenter defaultCenter]postNotificationName:XKKYFriendGroupChange object:nil];
    }
    
  }
}
#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark - 请求列表
- (void)requestListNeedTip:(BOOL)needTip {
  if (needTip) {
    [XKHudView showLoadingTo:self.containView animated:YES];
  }
  __weak typeof(self) weakSelf = self;
  [self.viewModel requestListComplete:^(NSString *error, id data) {
    [XKHudView hideHUDForView:self.containView animated:YES];
    [self reloadData];
    if (error) {
      if (self.viewModel.dataArray.count == 0) {
        self.emptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
        [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
          [weakSelf requestListNeedTip:YES];
        }];
      } else {
        [XKHudView showErrorMessage:error to:self.containView animated:YES];
      }
    } else {
      if (self.viewModel.dataArray.count == 0) {
        self.emptyView.config.viewAllowTap = NO;
        [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:self.mode == 0 ?@"您还没有任何分组哦":@"您还没有任何标签哦" tapClick:nil];
      } else {
        [self.emptyView hide];
      }
    }
  }];
}

#pragma mark - 请求添加分组
- (void)requestAddGroup:(NSString *)name {
  [XKHudView showLoadingTo:self.containView animated:YES];
  [self.viewModel requestCreateGroupName:name complete:^(NSString *error, id data) {
    [XKHudView hideHUDForView:self.containView];
    if (error) {
      [XKHudView showErrorMessage:error to:self.containView animated:YES];
    } else {
      //            [XKHudView showSuccessMessage:@"创建分组成功" to:self.containView animated:YES];
      [self requestListNeedTip:NO];
    }
  }];
}

#pragma mark - 修改分组名称
- (void)requestModifyGroupName:(NSString *)name  model:(XKFriendGroupModel *)model {
  [XKHudView showLoadingTo:self.containView animated:YES];
  [self.viewModel requestModifyGroupName:name groupId:model.groupId complete:^(NSString *error, id data) {
    [XKHudView hideHUDForView:self.containView];
    if (error) {
      [XKHudView showErrorMessage:error to:self.containView animated:YES];
    } else {
      model.groupName = name;
      [self reloadData];
    }
  }];
}

#pragma mark - 删除分组
- (void)requestDeleteGroup:(NSIndexPath *)indexPath {
  XKFriendGroupModel *model = self.viewModel.dataArray[indexPath.row];
  [XKHudView showLoadingTo:self.containView animated:YES];
  [self.viewModel requestDeleteGroup:model.groupId complete:^(NSString *error, id data) {
    [XKHudView hideHUDForView:self.containView animated:YES];
    if (error) {
      [XKHudView showWarnMessage:error to:self.containView animated:YES];
    } else {
      [self.viewModel.dataArray removeObjectAtIndex:indexPath.row];
      [self reloadData];
      [self requestListNeedTip:NO];
    }
  }];
}

#pragma mark - 请求交换
- (void)requestExchange {
  [self.viewModel requestExchangeComplete:^(NSString *error, id data) {
    //
  }];
}

#pragma mark ----------------------------- 代理方法 ------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.viewModel.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  __weak typeof(self) weakSelf = self;
  XKBaseTableViewCell *cell;
  XKFriendGroupModel *model = self.viewModel.dataArray[indexPath.row];
  if (self.userType == 0) {
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"sort" forIndexPath:indexPath];
    XKSortDeleteCell *sortCell =  (XKSortDeleteCell *)cell;
    sortCell.canDelete = self.editingStatus;
    sortCell.titleLabel.text = model.groupName;
    sortCell.indexPath = indexPath;
    [sortCell setDeleteClick:^(NSIndexPath *indexPath) {
      [XKAlertView showCommonAlertViewWithTitle:weakSelf.mode == 0 ? @"确认删除分组" : @"确认删除标签" rightText:@"确认" rightBlock:^{
        [weakSelf requestDeleteGroup:indexPath];
      }];
    }];
  } else {
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"check" forIndexPath:indexPath];
    XKCheckTableViewCell *checkCell =  (XKCheckTableViewCell *)cell;
    checkCell.nameLabel.text = model.groupName;
    checkCell.chooseBtn.selected = model.selected;
  }
  cell.contentView.xk_openClip = YES;
  cell.contentView.xk_radius = 8;
  if (indexPath.row == 0) {
    cell.contentView.xk_clipType = XKCornerClipTypeTopBoth;
    if (self.viewModel.dataArray.count == 1) {
      cell.contentView.xk_clipType = XKCornerClipTypeAllCorners;
    }
  } else if (indexPath.row == self.viewModel.dataArray.count - 1) {
    cell.contentView.xk_clipType = XKCornerClipTypeBottomBoth;
  } else {
    cell.contentView.xk_clipType = XKCornerClipTypeNone;
  }
  if (indexPath.row == self.viewModel.dataArray.count - 1) {
    [cell hiddenSeperateLine:YES];
  } else {
    [cell hiddenSeperateLine:NO];
  }
  return cell;
}

#pragma mark - cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.userType == 0) {
    if (self.editingStatus) {
      XKFriendGroupModel *model = self.viewModel.dataArray[indexPath.row];
      XKCommonAlertInputView *view = [[XKCommonAlertInputView alloc] initWithTitle:self.mode == 0 ? @"修改分组名称" : @"修改标签名称"  placeHolder:self.mode == 0 ? @"请输入分组名称" : @"请输入标签名称" maxNum:7 message:model.groupName leftButton:@"取消" rightButton:@"确定" leftBlock:^(NSString *text){
        
      } rightBlock:^(NSString *text) {
        [self requestModifyGroupName:text model:model];
      } isBeginFirstResponder:YES];
      [view setCloseButtonHidden:YES];
      [view show];
    } else {
      __weak typeof(self) weakSelf = self;
      XKFriendGroupModel *model = self.viewModel.dataArray[indexPath.row];
      XKGroupMemberManageController *vc = [XKGroupMemberManageController new];
      vc.isSecret = self.isSecret;
      vc.secretId = self.secretId;
      vc.mode = self.mode;
      vc.groupId = model.groupId;
      [vc setMemberChange:^{
        weakSelf.viewModel.isSendNotification = YES;
      }];
      [self.navigationController pushViewController:vc animated:YES];
    }
  } else {
    [self.viewModel.dataArray enumerateObjectsUsingBlock:^(XKFriendGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      obj.selected = NO;
    }];
    XKFriendGroupModel *model = self.viewModel.dataArray[indexPath.row];
    model.selected = YES;
    self.viewModel.defaultGroupId = model.groupId;
    [self reloadData];
  }
}

#pragma mark - 侧滑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return self.editingStatus;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
  __weak typeof(self) weakSelf = self;
  UITableViewRowAction *removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    [weakSelf requestDeleteGroup:indexPath];
  }];
  return @[removeAction];
}

#pragma mark --------------------------- setter&getter -------------------------
- (void)setEditingStatus:(BOOL)editingStatus {
  _editingStatus = editingStatus;
  [_doneBtn setTitle:editingStatus ? @"完成" : @"编辑" forState:UIControlStateNormal];
  [self reloadData];
}

@end
