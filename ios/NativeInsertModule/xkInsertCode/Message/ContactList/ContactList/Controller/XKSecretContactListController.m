/*******************************************************************************
 # File        : XKSecretContactListController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/10
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSecretContactListController.h"

#import "UIView+XKCornerRadius.h"
#import "XKSecreContactListViewModel.h"
#import "XKAddFriendController.h"


@interface XKSecretContactListController () {
  UIButton *_sureBtn;
}

/**viewModel*/
@property(nonatomic, strong) XKSecreContactListViewModel *viewModel;
/***/
@property(nonatomic, copy) XKEmptyPlaceView *emptyView;

@end

@implementation XKSecretContactListController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
  [super viewDidLoad];
  // 初始化默认数据
  [self createDefaultData];
  // 初始化界面
  [self createUI];
  [self requestDataNeedTip:YES];
}

- (void)dealloc {
  NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
  __weak typeof(self) weakSelf = self;
  _viewModel = [[XKSecreContactListViewModel alloc] init];
  _viewModel.useType = self.useType;
  _viewModel.secretId = self.secretId;
  _viewModel.defaultSelected = self.defaultSelected;
  _viewModel.defaultIsGray = self.defaultIsGray;
  [_viewModel setSureClick:^{
    EXECUTE_BLOCK(weakSelf.sureClickBlock,[weakSelf getSelectedArray],weakSelf);
  }];
  [_viewModel setRefreshBlock:^{
    [weakSelf dealBtnShow];
    [weakSelf.tableView reloadData];
  }];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:XKSecretFriendListInfoChangeNoti object:nil];
}

- (void)refreshList {
  [self requestDataNeedTip:NO];
}

#pragma mark - 初始化界面
- (void)createUI {
  self.navStyle = BaseNavWhiteStyle;
  [self setNavTitle:@"密友通讯录" WithColor:[UIColor whiteColor]];
  if (self.title.length != 0) {
    [self setNavTitle:self.title WithColor:[UIColor whiteColor]];
  }
  self.containView.backgroundColor = HEX_RGB(0xEEEEEE);
  [self createSearchView];
  self.searchField.delegate = self.viewModel;
  NSAttributedString *place = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
    confer.text(@"请输入昵称或者备注").font(XKRegularFont(14)).textColor(RGBGRAY(200));
  }];
  self.searchField.attributedPlaceholder = place;
  [self.searchField addTarget:self.viewModel action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
  
  [self createBottomView];
  
  [self createTableView];
  self.tableView.delegate = self.viewModel;
  self.tableView.dataSource = self.viewModel;
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.containView.mas_left).offset(kViewMargin);
    make.right.equalTo(self.containView.mas_right).offset(-kViewMargin);
    make.bottom.equalTo(self.bottomView.mas_top);
    make.top.equalTo(self.searchView.mas_bottom).offset(kViewMargin);
  }];
  
  // 空视图
  XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
  
  config.viewAllowTap = NO;
  _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
  
  [self createRightButton];
  
}

#pragma mark ----------------------------- 公用方法 ------------------------------
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
        [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"您还未添加密友哦" tapClick:nil];
      } else {
        [self.emptyView hide];
      }
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
    [_sureBtn setTitle:self.rightButtonText forState:UIControlStateNormal];
  } else {
    [_sureBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",self.rightButtonText,count] forState:UIControlStateNormal];
  }
}

#pragma mark - 添加密友
- (void)addSecretFriend {
  XKAddFriendController *vc = [XKAddFriendController new];
  vc.isSecret = YES;
  vc.secretId = self.secretId;
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


- (void)createRightButton {
  if (self.useType == XKContactUseTypeNormal) {
    _sureBtn = [[UIButton alloc] init];
    [_sureBtn setTitle:@"添加密友" forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:15];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(addSecretFriend) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self setRightView:_sureBtn withframe:CGRectMake(0, 0, XKViewSize(80), 26)];
  } else {
    if (self.rightButtonText){
      _sureBtn = [[UIButton alloc] init];
      [_sureBtn setTitle:self.rightButtonText forState:UIControlStateNormal];
      _sureBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
      [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
      _sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
      [self setRightView:_sureBtn withframe:CGRectMake(0, 0, XKViewSize(70), 26)];
    }
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
