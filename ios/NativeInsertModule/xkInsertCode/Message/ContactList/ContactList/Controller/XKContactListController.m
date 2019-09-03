/*******************************************************************************
 # File        : XKContactListController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/10
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKContactListController.h"
#import "UIView+XKCornerRadius.h"
#import "XKContactListViewModel.h"
#import "XKNewFriendController.h"
#import "XKGroupManageController.h"
#import "XKGlobalSearchController.h"
#import "XKGuidanceManager.h"
#import "XKGuidanceView.h"

@interface XKContactListController () {
  UIButton *_sureBtn;
  UIImageView *_redPoint;
}

/**<##>*/
@property(nonatomic, strong) UIView *headerView;
/**viewModel*/
@property(nonatomic, strong) XKContactListViewModel *viewModel;
/***/
@property(nonatomic, copy) XKEmptyPlaceView *emptyView;

@end

@implementation XKContactListController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
  [super viewDidLoad];
  // 初始化默认数据
  [self createDefaultData];
  // 初始化界面
  [self createUI];
  [self requestDataNeedTip:YES];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:XKFriendListInfoChangeNoti object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRedPoint) name:XKRedPointItemForNewFriendNoti object:nil];
}
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if ([self.title isEqualToString:@"选择投射对象"]) {
    if (self.viewModel.dataArray.count >= 1) {
      //添加引导视图
      XKContactListCell *cell = (XKContactListCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
      [XKGuidanceManager configShowGuidanceViewType:XKGuidanceManagerXKSecretTipSettingController TransparentRectArr:@[[NSValue valueWithCGRect:CGRectMake(_sureBtn.getWindowFrame.origin.x + 20, _sureBtn.getWindowFrame.origin.y, _sureBtn.getWindowFrame.size.width - 10, _sureBtn.getWindowFrame.size.height)],[NSValue valueWithCGRect:cell.chooseBtn.getWindowFrame]]];
    }
  }
}

- (void)dealloc {
  NSLog(@"=====%@被销毁了=====", [self class]);
}

- (void)update {
  [self requestDataNeedTip:NO];
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
  __weak typeof(self) weakSelf = self;
  _viewModel = [[XKContactListViewModel alloc] init];
  _viewModel.useType = self.useType;
  _viewModel.defaultSelected = self.defaultSelected;
  _viewModel.defaultIsGray = self.defaultIsGray;
  _viewModel.outDataArray = self.outDataArray;
  _viewModel.secretId = self.secretId;
  [_viewModel setSureClick:^{
    EXECUTE_BLOCK(weakSelf.sureClickBlock,[weakSelf getSelectedArray],weakSelf);
  }];
  // 加密友
  [_viewModel setOperationBlock:^(NSIndexPath *indexPath, XKContactModel *model) {
    [weakSelf addSecretFriend:model];
  }];
  [_viewModel setRefreshBlock:^{
    [weakSelf dealBtnShow];
    [weakSelf.tableView reloadData];
  }];
  [_viewModel setSearchStatusChangeBlock:^{
    [weakSelf showHeader];
    [weakSelf.tableView reloadData];
  }];
}

#pragma mark - 初始化界面
- (void)createUI {
  [self setNavTitle:@"可友通讯录" WithColor:[UIColor whiteColor]];
  if (self.title.length != 0) {
    [self setNavTitle:self.title WithColor:[UIColor whiteColor]];
  }
  __weak typeof(self) weakSelf = self;
  self.containView.backgroundColor = HEX_RGB(0xEEEEEE);
  [self createSearchView];
  if (self.useType == XKContactUseTypeNormal) {
    self.searchField.placeholder = nil;
    self.searchField.attributedPlaceholder = nil;
    self.searchField.userInteractionEnabled = NO;
    [self.searchView bk_whenTapped:^{
      XKGlobalSearchController *vc = [XKGlobalSearchController new];
      vc.justSearchFriend = YES;
      [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
  } else {
    NSAttributedString *place = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
      confer.text(@"请输入昵称或者备注").font(XKRegularFont(14)).textColor(RGBGRAY(180));
    }];
    self.searchField.attributedPlaceholder = place;
  }
  self.searchField.delegate = self.viewModel;
  [self.searchField addTarget:self.viewModel action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
  
  UILabel *infolabel = [[UILabel alloc] init];
  infolabel.text = self.infoText;
  infolabel.textColor = HEX_RGB(0x7777777);
  infolabel.font = XKRegularFont(13);
  [self.containView addSubview:infolabel];
  [infolabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.searchView);
    make.top.equalTo(self.searchView.mas_bottom).offset(6);
  }];
  infolabel.hidden = self.infoText.length == 0 ? YES : NO;
  
  [self createBottomView];
  [self createTableView];
  self.tableView.delegate = self.viewModel;
  self.tableView.dataSource = self.viewModel;
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.containView.mas_left).offset(kViewMargin);
    make.right.equalTo(self.containView.mas_right).offset(-kViewMargin);
    make.bottom.equalTo(self.bottomView.mas_top);
    if (self.infoText.length == 0) {
      make.top.equalTo(self.searchView.mas_bottom).offset(kViewMargin);
    } else {
      make.top.equalTo(infolabel.mas_bottom).offset(6);
    }
  }];
  // creatHeader
  [self showHeader];
  
  // 空视图
  XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
  
  config.viewAllowTap = NO;
  _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
  
  [self createRightButton];
}

- (void)showHeader {
  if (self.useType == XKContactUseTypeNormal) {
    if (self.viewModel.searchStatus) {
      self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGFLOAT_MIN)];
    } else {
      self.tableView.tableHeaderView = self.headerView;
    }
  } else {
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGFLOAT_MIN)];
  }
}

- (UIView *)headerView {
  if (!_headerView) {
    __weak typeof(self) weakSelf = self;
    CGFloat height = 55;
    NSArray *arr = @[@[@"ic_btn_msg_addNew",@"新的好友"],@[@"ic_btn_msg_groups",@"分组管理"],@[@"ic_btn_msg_tags",@"标签管理"]];
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, arr.count * height + 10);
    UIView *contentView = [[UIView alloc] init];
    [headerView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.left.right.equalTo(headerView);
      make.height.mas_equalTo(arr.count * height);
    }];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 6;
    _headerView = headerView;
    UIView *tmpView;
    for (NSArray *itemsArr in arr) {
      UIView *view = [self createItemsView:IMG_NAME(itemsArr.firstObject) text:itemsArr.lastObject];
      [contentView addSubview:view];
      [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        if (tmpView) {
          make.top.equalTo(tmpView.mas_bottom);
        } else {
          make.top.equalTo(contentView);
        }
        make.height.mas_equalTo(height);
      }];
      [view bk_whenTapped:^{
        [weakSelf dealTitleClick:itemsArr.lastObject];
      }];
      [view showBorderSite:rzBorderSitePlaceTop];
      view.topBorder.borderLine.backgroundColor = HEX_RGB(0xF1F1F1);
      if (!tmpView) {
        view.topBorder.borderLine.hidden = YES;
      }
      tmpView = view;
    }
  }
  return _headerView;
}

- (UIView *)createItemsView:(UIImage *)image text:(NSString *)text {
  UIView *view = [[UIView alloc] init];
  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.image = image;
  UILabel *nameLabel = [UILabel new];
  nameLabel.text = text;
  nameLabel.textColor = HEX_RGB(0x222222);
  nameLabel.font = XKRegularFont(14);
  [view addSubview:imageView];
  [view addSubview:nameLabel];
  [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(view.mas_left).offset(15);
    make.centerY.equalTo(view);
    make.size.mas_equalTo(CGSizeMake(ScreenScale * 35, ScreenScale *35));
  }];
  [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(imageView.mas_right).offset(10 *ScreenScale);
    make.centerY.equalTo(view);
  }];
  if ([text isEqualToString:@"新的好友"]) {
    _redPoint = [[UIImageView alloc] init];
    _redPoint.image = IMG_NAME(@"xk_ic_msg_tipRed");
    [view addSubview:_redPoint];
    [self handleRedPoint];
    [_redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(imageView.mas_right).offset(-1);
      make.centerY.equalTo(imageView.mas_top).offset(1);
      make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
  }
  return view;
}

- (void)handleRedPoint {
  if ([XKRedPointManager getMsgTabBarRedPointItem].newFriendItem.hasRedPoint) {
    _redPoint.hidden = NO;
  } else {
    _redPoint.hidden = YES;
  }
}

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark - 点击选项
- (void)dealTitleClick:(NSString *)text {
  if ([text isEqualToString:@"新的好友"]) {
    [self newFriend];
  } else if ([text isEqualToString:@"分组管理"]) {
    [self groupsManage];
  } else if ([text isEqualToString:@"标签管理"]) {
    [self tagsManage];
  }
}

#pragma mark - 新的好友
- (void)newFriend {
  __weak typeof(self) weakSelf = self;
  XKNewFriendController *vc = [XKNewFriendController new];
  [vc setFriendStatusChange:^{
    [weakSelf requestDataNeedTip:NO];
  }];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 分组管理
- (void)groupsManage {
  XKGroupManageController *vc = [XKGroupManageController new];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 标签管理
- (void)tagsManage {
  XKGroupManageController *vc = [XKGroupManageController new];
  vc.mode = 1;
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 请求
- (void)requestDataNeedTip:(BOOL)tip {
  if (tip) {
    [XKHudView showLoadingTo:self.containView animated:YES];
  }
  
  __weak typeof(self) weakSelf = self;
  [self.viewModel requestComplete:^(NSString *error, NSArray *array) {
    [XKHudView hideHUDForView:self.containView animated:YES];
    [self.tableView reloadData];
    if (error) {
      if (self.viewModel.dataArray.count == 0) {
        if (self.useType != XKContactUseTypeNormal) {
          self.emptyView.config.viewAllowTap = YES;
          [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
            [weakSelf requestDataNeedTip:YES];
          }];
        } else {
          [XKHudView showErrorMessage:@"网络错误" to:self.containView animated:YES];
        }
      }
    } else {
      if (self.viewModel.dataArray.count == 0) {
        if (self.useType != XKContactUseTypeNormal) {
          self.emptyView.config.viewAllowTap = NO;
          [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"您还未添加好友哦" tapClick:nil];
        } else {
          [XKHudView showTipMessage:@"您还未添加好友哦" to:self.containView animated:YES];
        }
      } else {
        [self dealBtnShow];
        [self.emptyView hide];
      }
    }
  }];
}

#pragma mark - 加密友
- (void)addSecretFriend:(XKContactModel *)model {
  [XKAlertView showAlertViewWithCloseBtnWithTitle:@"提示" message:@"是否保留可友？\n(选择\"否\"将删除可友，\n选择\"是\"将保留可友)" leftText:@"否" rightText:@"是" textColor:XKMainTypeColor leftBlock:^{
    [self requestAddFriend:model needDeleteFriend:YES];
  } rightBlock:^{
    [self requestAddFriend:model needDeleteFriend:NO];
  } textAlignment:NSTextAlignmentCenter];
}

- (void)requestAddFriend:(XKContactModel *)model needDeleteFriend:(BOOL)delete {
  [XKHudView showLoadingTo:self.containView animated:YES];
  [XKFriendshipManager addSecretFriendWithoutAgree:model.userId needDeleteFriend:delete   withSecretId:self.secretId complete:^(NSString *error, id data) {
    [XKHudView hideHUDForView:self.containView];
    if (error) {
      [XKHudView showErrorMessage:error to:self.containView animated:YES];
    } else {
      model.secretRelation = XKRelationOneWay;
      [XKHudView showSuccessMessage:@"已添加为密友" to:self.containView animated:YES];
      model.secretId = self.secretId;
      [self.tableView reloadData];
      [self requestDataNeedTip:NO];
      [[NSNotificationCenter defaultCenter] postNotificationName:XKSecretFriendListInfoChangeNoti object:nil];
    }
  }];
}

- (NSArray *)getSelectedArray {
  return [self.viewModel getSelectedArray];
}

- (void)bottomBtnClick:(UIButton *)btn {
  EXECUTE_BLOCK(self.sureClickBlock,[self getSelectedArray],self);
}

- (void)sureBtnClick {
  EXECUTE_BLOCK(self.sureClickBlock,[self getSelectedArray],self);
}

- (void)dealBtnShow {
  NSInteger count = [self getSelectedArray].count;
  if (count == 0) {
    if (self.sureBtnIsGrayWhenNoChoose) {
      _sureBtn.enabled = NO;
    }
    [_sureBtn setTitle:self.rightButtonText forState:UIControlStateNormal];
  } else {
    _sureBtn.enabled = YES;
    [_sureBtn setTitle:[NSString stringWithFormat:@"%@(%ld) ",self.rightButtonText,count] forState:UIControlStateNormal];
  }
}

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


- (void)createRightButton {
  if (self.rightButtonText){
    _sureBtn = [[UIButton alloc] init];
    [_sureBtn setTitle:self.rightButtonText forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:18];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureBtn setTitleColor:RGBGRAY(220) forState:UIControlStateDisabled];
    [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self setRightView:_sureBtn withframe:CGRectMake(0, 0, 70, 26)];
  }
}

- (void)createBottomView {
  self.bottomView = [[UIView alloc] init];
  [self.containView addSubview:self.bottomView];
  if (!self.bottomButtonText) {
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.right.bottom.equalTo(self.containView);
      make.height.equalTo(@0);
    }];
  } else {
    UIButton *btn = [self getBottomBtn];
    [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:self.bottomButtonText forState:UIControlStateNormal];
    [self.bottomView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.left.right.equalTo(self.bottomView);
      make.height.equalTo(@44);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.right.bottom.equalTo(self.containView);
      make.height.mas_equalTo(44 + kBottomSafeHeight);
    }];
  }
}

- (UIButton *)getBottomBtn {
  UIButton *btn = [[UIButton alloc] init];
  btn.backgroundColor = XKMainTypeColor;
  [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  btn.titleLabel.font = XKRegularFont(17);
  return btn;
}

@end
