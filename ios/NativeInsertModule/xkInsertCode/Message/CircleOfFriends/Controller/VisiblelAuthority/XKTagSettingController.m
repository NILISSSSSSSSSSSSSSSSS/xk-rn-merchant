/*******************************************************************************
 # File        : XKTagSettingController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/16
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKTagSettingController.h"
#import "XKTagSettingViewModel.h"
#import "XKContactListController.h"
@interface XKTagSettingController () {
}
/**<##>*/
@property(nonatomic, strong) UITextField *nameTextField;
/**<##>*/
@property(nonatomic, strong) UILabel *numLabel;
/**<##>*/
@property(nonatomic, strong) XKTagSettingViewModel *viewModel;
/**数据是否改变*/
@property(nonatomic, assign)  BOOL change;
@end

@implementation XKTagSettingController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
  [super viewDidLoad];
  // 初始化默认数据
  [self createDefaultData];
  // 初始化界面
  [self createUI];
  
  [self requestNeedTip:YES];
}

- (void)dealloc {
  NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
  __weak typeof(self) weakSelf = self;
  _viewModel = [XKTagSettingViewModel new];
  _viewModel.tagId = self.tagId;
  [_viewModel setRemove:^(NSIndexPath *indexPath) {
    [weakSelf remove:indexPath];
  }];
}

#pragma mark - 初始化界面
- (void)createUI {
  [self setNavTitle:@"设置标签" WithColor:[UIColor whiteColor]];
  [self createTableView];
  UIButton *newBtn = [[UIButton alloc] init];
  [newBtn setTitle:@"完成" forState:UIControlStateNormal];
  [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  newBtn.titleLabel.font = XKRegularFont(17);
  [newBtn setFrame:CGRectMake(0, 0, XKViewSize(35), 25)];
  [newBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
  [self setRightView:newBtn withframe:newBtn.bounds];
  self.tableView.delegate = self.viewModel;
  self.tableView.dataSource = self.viewModel;
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.containView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
  }];
  [self createHeaderView];
}

#pragma mark ----------------------------- 其他方法 ------------------------------
- (void)createHeaderView {
  UIView *headerView = [[UIView alloc] init];
  headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 20, 10 + 50 + 100 + 10);
  [self createNameViewToView:headerView];
  [self createAddViewToView:headerView];
  self.tableView.tableHeaderView = headerView;
}

- (UIView *)createNameViewToView:(UIView *)headerView {
  UIView *nameView = [UIView new];
  nameView.backgroundColor = [UIColor whiteColor];
  nameView.layer.cornerRadius = 6;
  nameView.layer.masksToBounds = YES;
  [headerView addSubview:nameView];
  
  [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(headerView.mas_top).offset(10);
    make.left.right.equalTo(headerView);
    make.height.equalTo(@50);
  }];
  
  UILabel *label = [[UILabel alloc] init];
  label.text = @"标签名称";
  label.textColor = HEX_RGB(51);
  label.font = XKRegularFont(14);
  [nameView addSubview:label];
  [label mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(nameView);
    make.left.equalTo(nameView.mas_left).offset(18);
    make.width.mas_equalTo(XKViewSize(62));
  }];
  
  self.nameTextField = [[UITextField alloc] init];
  self.nameTextField.placeholder = @"例如家人、朋友";
  self.nameTextField.font = XKRegularFont(15);
  self.nameTextField.returnKeyType = UIReturnKeyDone;
  [self.nameTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
  [nameView addSubview:self.nameTextField];
  [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(label.mas_right).offset(20);
    make.top.bottom.equalTo(nameView);
    make.right.equalTo(nameView.mas_right).offset(-10);
  }];
  return nameView;
}


- (void)textChange:(UITextField *)textField {
  _change = YES;
  NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
  if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 有高亮选择的字 则不搜索
    if (position) {
      return;
    }
  }
  if (textField.text.length > 20) {
    textField.text = [textField.text substringToIndex:20];
  }
  self.viewModel.model.groupName = textField.text;
}

- (UIView *)createAddViewToView:(UIView *)view {
  // create header
  UIView *btmView = [[UIView alloc] init];
  btmView.backgroundColor = [UIColor whiteColor];
  btmView.layer.cornerRadius = 6;
  btmView.layer.masksToBounds = YES;
  [view addSubview:btmView];
  
  [btmView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(view.mas_top).offset(70);
    make.left.right.equalTo(view);
    make.height.equalTo(@100);
  }];
  
  _numLabel = [[UILabel alloc] init];
  _numLabel.text = @"标签名称";
  _numLabel.textColor = HEX_RGB(51);
  _numLabel.font = XKRegularFont(14);
  [btmView addSubview:_numLabel];
  [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(btmView.mas_top).offset(25);
    make.left.equalTo(btmView.mas_left).offset(18);
    make.width.equalTo(@200);
  }];
  
  UIView *line = [[UIView alloc] init];
  line.backgroundColor = HEX_RGB(0xF1F1F1);
  [btmView addSubview:line];
  [line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(btmView);
    make.top.equalTo(btmView.mas_top).offset(50);
    make.height.equalTo(@1);
  }];
  
  __weak typeof(self) weakSelf = self;
  UIButton *addBtn  = [UIButton new];
  [addBtn setImage:IMG_NAME(@"xk_btn_TradingArea_add") forState:UIControlStateNormal];
  addBtn.userInteractionEnabled = NO;
  [btmView addSubview:addBtn];
  [addBtn addTarget:self action:@selector(addMember) forControlEvents:UIControlEventTouchUpInside];
  UILabel *textLabel = [UILabel new];
  textLabel.text = @"添加成员";
  textLabel.textColor = XKMainTypeColor;
  textLabel.font = XKRegularFont(15);
  [btmView addSubview:textLabel];
  textLabel.userInteractionEnabled = YES;
  [textLabel bk_whenTapped:^{
    [weakSelf addMember];
  }];
  
  [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(btmView.mas_left).offset(15);
    make.centerY.equalTo(btmView.mas_top).offset(75);
    make.size.mas_equalTo(CGSizeMake(20, 30));
  }];
  [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(addBtn);
    make.left.equalTo(addBtn.mas_right).offset(10);
  }];
  return btmView;
}

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark - 添加成员
- (void)addMember {
  __weak typeof(self) weakSelf = self;
  XKContactListController *list = [[XKContactListController alloc] init];
  list.rightButtonText = @"完成";
  list.showSelectedNum = YES;
  list.useType = XKContactUseTypeManySelect;
  list.title = @"选择联系人";
  list.defaultSelected = self.viewModel.dataArray;
  list.defaultIsGray = YES;
  
  UIViewController * currentVC = self.getCurrentUIVC;
  [list setSureClickBlock:^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
    if (contacts.count != 0) {
      weakSelf.change = YES;
    }
    [weakSelf.viewModel.dataArray addObjectsFromArray:contacts];
    weakSelf.viewModel.model.list = weakSelf.viewModel.dataArray;
    [weakSelf.viewModel buildData];
    [weakSelf.tableView reloadData];
    [listVC.navigationController popViewControllerAnimated:YES];
  }];
  [currentVC.navigationController pushViewController:list animated:YES];
}

#pragma mark - 点击完成
- (void)doneClick {
  if (self.change == NO) {
    [self.navigationController popViewControllerAnimated:YES];
    return;
  }
  if (![self.nameTextField.text isExist]) {
    [XKHudView showTipMessage:@"请输入标签名"];
    return;
  }
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"groupType"] = @"label";
  params[@"groupId"] = self.tagId;
  params[@"labelName"] = self.nameTextField.text;
  NSMutableArray *ids = @[].mutableCopy;
  for (XKContactModel *model in self.viewModel.dataArray) {
    [ids addObject:model.userId];
  }
  params[@"userIds"] = ids;
  [XKHudView showLoadingTo:self.containView animated:YES];
  [HTTPClient postEncryptRequestWithURLString:@"im/ua/xkGroupUsersUpdate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
    [XKHudView hideHUDForView:self.containView animated:YES];
    EXECUTE_BLOCK(self.changeBlock,self.viewModel.model);
    [self.navigationController popViewControllerAnimated:YES];
  } failure:^(XKHttpErrror *error) {
    [XKHudView hideHUDForView:self.containView animated:YES];
    [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
  }];
  //
}

#pragma mark - 移除
- (void)remove:(NSIndexPath *)indexPath {
  XKContactModel *user = self.viewModel.sectionDataArray[indexPath.section][indexPath.row];
  [self.viewModel.dataArray removeObject:user];
  [self.viewModel buildData];
  [self.tableView reloadData];
}

#pragma mark - 更新头界面
- (void)updateHeadView {
  _numLabel.text = [NSString stringWithFormat:@"标签成员(%ld)",self.viewModel.dataArray.count];
  _nameTextField.text = self.viewModel.model.groupName;
}

#pragma mark ----------------------------- 网络请求 ------------------------------
- (void)requestNeedTip:(BOOL)needTip {
  if (needTip) {
    [XKHudView showLoadingTo:self.containView animated:YES];
  }
  [self.viewModel requestComplete:^(NSString *err, NSArray *arr) {
    [XKHudView hideHUDForView:self.containView animated:YES];
    if (err) {
      [XKHudView showErrorMessage:err to:self.containView animated:YES];
    } else {
      [self updateHeadView];
      [self.tableView reloadData];
    }
  }];
}

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
