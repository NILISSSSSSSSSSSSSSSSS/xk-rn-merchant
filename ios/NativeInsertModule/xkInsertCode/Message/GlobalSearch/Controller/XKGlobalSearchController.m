/*******************************************************************************
 # File        : XKGlobalSearchController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/6
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGlobalSearchController.h"
#import "XKContactListCell.h"
#import "XKPersonDetailInfoViewController.h"
#import "XKSegment.h"
#import "XKGlobalSearchViewModel.h"
#import "XKP2PChatViewController.h"
#import "XKSecretChatViewController.h"
#define kViewMargin 10

@interface XKGlobalSearchController () <UITableViewDelegate, UITableViewDataSource> {
  UILabel *_searchLabel;
  UIView *_tipView;
}
/**搜索view*/
@property(nonatomic, strong) UIView *searchView;
/**搜索框*/
@property(nonatomic, strong) UITextField *searchField;
@property(nonatomic, strong) UIButton *searchBtn;
/**tableView*/
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) XKSegment *segment;
/**陌生用户搜索*/
@property(nonatomic, strong) NSMutableArray *netSearchDataArray;
/**本地信息搜索*/
@property(nonatomic, strong) NSMutableArray<XKGlobalSearchLocalInfo *> *localSearchDataArray;

/**<##>*/
@property(nonatomic, strong) XKGlobalSearchViewModel *viewModel;
@end

@implementation XKGlobalSearchController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
  [super viewDidLoad];
  // 初始化默认数据
  [self createDefaultData];
  // 初始化界面
  [self createUI];
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
  _viewModel = [[XKGlobalSearchViewModel alloc] init];
  _viewModel.secretId = self.secretId;
  _viewModel.isSecret = self.isSecret;
  _netSearchDataArray = [NSMutableArray array];
  _localSearchDataArray = [NSMutableArray array];
}

#pragma mark - 初始化界面
- (void)createUI {
  [self setNavTitle:@"搜索" WithColor:[UIColor whiteColor]];
  if (self.isSecret) {
    self.navStyle = BaseNavWhiteStyle;
  }
  self.containView.backgroundColor = HEX_RGB(0xEEEEEE);
  [self createSearchView];
  if (self.justSearchFriend == NO) {
    [self createSegment];
  }
  [self createTableView];
}

#pragma mark ----------------------------- 其他方法 ------------------------------


- (void)createSearchView {
  _searchView = [UIView new];
  _searchView.backgroundColor = [UIColor whiteColor];
  _searchView.xk_openClip = YES;
  _searchView.xk_radius = 8;
  _searchView.xk_clipType = XKCornerClipTypeAllCorners;
  self.searchView.frame = CGRectMake(kViewMargin, kViewMargin, SCREEN_WIDTH - 2 *kViewMargin, 42);
  [self.containView addSubview:self.searchView];
  
  self.searchField = [[UITextField alloc] init];
  self.searchField.font = XKNormalFont(15);
  if (!self.isSecret) {
      [self.searchField enableSecretJump:YES];
  }
  [self.searchField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
  [_searchView addSubview:self.searchField];
  [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.searchView.mas_left).offset(10);
    make.top.bottom.equalTo(self.searchView);
    make.right.equalTo(self.searchView.mas_right).offset(-50);
  }];
  //
  
  self.searchBtn = [[UIButton alloc] init];
  [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
  self.searchBtn.titleLabel.font = XKRegularFont(15);
  [self.searchBtn setBackgroundColor:HEX_RGB(0xCCCCCC)];
  self.searchBtn.userInteractionEnabled = NO;
  [self.searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
  [self.searchView addSubview:self.searchBtn];
  [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.right.bottom.equalTo(self.searchView);
    make.width.equalTo(@50);
  }];
  
  //    __weak typeof(self) weakSelf = self;
}

- (void)createSegment {
  __weak typeof(self) weakSelf = self;
  if (self.isSecret) {
    _segment = [[XKSegment alloc] initWithTitleArray:@[@"密友信息",@"陌生用户"] selectColor:HEX_RGB(0x222222) normalColor:HEX_RGB(0x999999)];
  } else {
    _segment = [[XKSegment alloc] initWithTitleArray:@[@"可友信息",@"陌生用户"]];
  }
  
  [self.containView addSubview:_segment];
  
  [_segment mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.searchView.mas_bottom).offset(10);
    make.left.right.equalTo(self.searchView);
    make.height.equalTo(@44);
  }];
  [_segment showBorderSite:rzBorderSitePlaceBottom];
  _segment.bottomBorder.borderLine.backgroundColor = HEX_RGB(0xF0F0F0);
  _segment.xk_openClip = YES;
  _segment.xk_radius = 8;
  _segment.xk_clipType = XKCornerClipTypeTopBoth;
  
  [_segment setSegmentChange:^(NSInteger index) {
    [weakSelf segmentChange];
  }];
}

- (void)createTableView {
  
  UIView *cardView = [[UIView alloc] init];
  cardView.backgroundColor = [UIColor whiteColor];
  if (self.justSearchFriend) {
    cardView.xk_clipType = XKCornerClipTypeAllCorners;
  } else {
    cardView.xk_clipType = XKCornerClipTypeBottomBoth;
  }
  cardView.xk_radius = 8;
  cardView.xk_openClip = YES;
  [self.containView addSubview:cardView];
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.showsVerticalScrollIndicator = NO;
  self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;

  [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
    if (self.justSearchFriend) {
      make.top.equalTo(self.searchView.mas_bottom).offset(10);
    } else {
      make.top.equalTo(self.segment.mas_bottom);
    }
    make.left.equalTo(self.containView).offset(10);
    make.right.equalTo(self.containView).offset(-10);
    make.bottom.equalTo(self.containView.mas_bottom).offset(iPhoneX_Serious ? -30 : - 15);
  }];
  
  [cardView addSubview:self.tableView];
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(cardView);
  }];
  
  _searchLabel = [[UILabel alloc] init];
  _searchLabel.font = XKRegularFont(15);
  _searchLabel.backgroundColor = [UIColor whiteColor];
  _searchLabel.textColor = HEX_RGB(0x555555);
  _searchLabel.frame = CGRectMake(0, 0, 20, 50);
  
  [self dealTableHeaderShow];
}

#pragma mark ----------------------------- 公用方法 ------------------------------

- (void)segmentChange {
  [self cleanSearchResult];
  [self.tableView reloadData];
  [self dealTableHeaderShow];
}

- (void)textChange:(UITextField *)textField {
  _viewModel.currentSearchKey = textField.text;
  [self cleanSearchResult];
  [self.tableView reloadData];
  if (textField.text.length == 0) {
    self.searchBtn.backgroundColor = HEX_RGB(0xCCCCCC);
    self.searchBtn.userInteractionEnabled = NO;
    [self dealTableHeaderShow];
  } else {
    self.searchBtn.userInteractionEnabled = YES;
    self.searchBtn.backgroundColor = self.isSecret ? HEX_RGB(0x222222) : XKMainTypeColor;
    [self dealTableHeaderShow];
  }
}

- (void)cleanSearchResult {
  [self.netSearchDataArray removeAllObjects];
  self.localSearchDataArray = nil;
  [self.viewModel cleanLocalResult];
}

- (void)dealTableHeaderShow {
  BOOL hasData = NO;
  NSString *placeText;
  if (self.segment.selectIndex == 0) { // 本地搜索
    if (self.isSecret) {
      placeText = @"搜索联系人、聊天记录";
    } else {
      placeText= @"搜索联系人、群聊、聊天记录";
    }
    
    hasData = [self.viewModel hasSearchResult];
  } else {
    placeText = @"搜索可友昵称或安全码";
    hasData = self.netSearchDataArray.count != 0;
  }
  
  NSAttributedString *placeHolderAttText = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
    confer.appendImage([UIImage imageNamed:@"xk_ic_search_xi"]).bounds(CGRectMake(0, -2.5, 16, 16));
    confer.text(@" ");
    confer.text(placeText).font(self.searchField.font).textColor(HEX_RGB(0x999999));
  }];
  //
  self.searchField.attributedPlaceholder = placeHolderAttText;
  if (hasData) {
    self.tableView.tableHeaderView = nil;
    self.tableView.superview.backgroundColor = [UIColor clearColor];
    [self.tableView reloadData];
  } else {
    self.tableView.tableHeaderView = _searchLabel;
    self.tableView.superview.backgroundColor = [UIColor whiteColor];
    if (self.searchField.text.length == 0) {
      NSString *seg0Text;
      if (self.isSecret) {
        seg0Text = @"   搜索联系人、聊天记录";
      } else {
        seg0Text = @"   搜索联系人、群聊、聊天记录";
      }
      _searchLabel.text = self.segment.selectIndex == 0 ? seg0Text: @"   搜索陌生用户";
      _searchLabel.textColor = HEX_RGB(0x999999);
      // 捉急产品不用脑子想需求
      if (self.segment.selectIndex == 1) {
        self.tableView.tableHeaderView = [self tipView];
      }
    } else {
      _searchLabel.text = [NSString stringWithFormat:@"   搜索：%@",self.searchField.text];
      _searchLabel.textColor = HEX_RGB(0x555555);
    }
    [self.tableView reloadData];
  }
  
}

- (UIView *)tipView {
  if (!_tipView) {
    UIView *tipView = [UIView new];
    _tipView = tipView;
    UILabel *titleLabel = [UILabel new];
    [_tipView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(tipView);
      make.top.equalTo(tipView).offset(5);
    }];
    titleLabel.text = @"温馨提示";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = XKRegularFont(12);
    titleLabel.textColor = HEX_RGB(0x555555);
    UILabel *desLabel = [UILabel new];
    [_tipView addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(tipView);
      make.top.equalTo(titleLabel.mas_bottom).offset(2);
      make.left.equalTo(tipView.mas_left).offset(10);
      make.right.equalTo(tipView.mas_right).offset(-10);
    }];
    desLabel.textColor = HEX_RGB(0x999999);
    desLabel.numberOfLines = 2;
    desLabel.text = @"因用户体系不通，晓可联盟APP无法添加晓可广场或晓可小视频的可友。";
    desLabel.font = XKRegularFont(12);
    tipView.frame = CGRectMake(0, 0, 50, 50);
  }
  return _tipView;
}

#pragma mark - 搜索点击
- (void)searchClick {
  [self.view endEditing:YES];
  __weak typeof(self) weakSelf = self;
  if (self.segment.selectIndex == 1) {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"searchKey"] = self.searchField.text;
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    [XKHudView showLoadingTo:self.containView animated:YES];
    [HTTPClient getEncryptRequestWithURLString:@"user/ua/xkUserSearch/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
      [XKHudView hideHUDForView:self.containView];
      NSArray *arr = [NSArray yy_modelArrayWithClass:[XKContactModel class] json:responseObject];
      [XKFriendshipManager filterStrangerUserWithUsers:arr userKey:params[@"searchKey"] result:^(NSArray *users, BOOL singleIsMyFriend) {
        if (singleIsMyFriend) {
          [XKAlertView showCommonAlertViewWithTitle:@"该用户已在您的好友列表中"];
        } else {
          if (users.count == 0) {
            [XKAlertView showCommonAlertViewWithTitle:@"该用户不存在！" message:@"请检查您填写的账号是否正确"];
          }
        }
        [self.netSearchDataArray removeAllObjects];
        [self.netSearchDataArray addObjectsFromArray:users];
        [self.tableView reloadData];
        [self dealTableHeaderShow];
      }];
    } failure:^(XKHttpErrror *error) {
      [XKHudView hideHUDForView:self.containView];
      [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
    }];
  } else {
    [XKHudView showLoadingTo:self.containView animated:YES];
    [_viewModel queryloacalDataWithKeyWord];
    [_viewModel setSearchResult:^{
      [XKHudView hideHUDForView:weakSelf.containView];
      if ([weakSelf.viewModel hasSearchResult]) {
        weakSelf.localSearchDataArray = weakSelf.viewModel.localSearchDataArray;
        [weakSelf dealTableHeaderShow];
        [weakSelf.tableView reloadData];
      } else {
        [XKAlertView showCommonAlertViewWithTitle:@"未搜索到结果"];
      }
    }];
    
  }
}

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *rid = @"cell";
  if (self.segment.selectIndex == 0) {
    XKGlobalSearchLocalInfo *info = self.localSearchDataArray[indexPath.section];
    XKContactListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    cell.headerImgView.userInteractionEnabled = NO;
    if(cell == nil){
      cell = [[XKContactListCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:rid];
    }
    cell.showChooseBtn = NO;
    cell.nameLabel.numberOfLines = 1;
    if ([info.type isEqualToString:@"联系人"]) {
      XKContactModel *user = info.dataArray[indexPath.row];
      // 处理文字颜色
      NSString *showText;
      if (self.isSecret) {
        showText = [NSString stringWithFormat:@"%@%@",user.nickname,user.secretRemark?[NSString stringWithFormat:@"(%@)",user.secretRemark] : @""];
      } else {
        showText = [NSString stringWithFormat:@"%@%@",user.nickname,user.friendRemark?[NSString stringWithFormat:@"(%@)",user.friendRemark] : @""];
      }
      cell.nameLabel.attributedText = [self returnColorStrWithOriginText:showText colorText:self.searchField.text originColor:nil];
      [cell.headerImgView sd_setImageWithURL:kURL(user.avatar) placeholderImage:kDefaultHeadImg];
    } else if ([info.type isEqualToString:@"聊天记录"]) {
      XKGlobalSearchResult *result = info.dataArray[indexPath.row];
      [cell.headerImgView sd_setImageWithURL:kURL(result.user.avatar) placeholderImage:kDefaultHeadImg];
      NSMutableAttributedString *mutAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",result.user.displayName]];
      mutAtt.yy_lineSpacing = 4;
      NSMutableAttributedString *appendStr = [self returnColorStrWithOriginText:result.text colorText:self.searchField.text originColor:HEX_RGB(0x777777)];
      appendStr.yy_font = XKRegularFont(12);
      [mutAtt appendAttributedString:appendStr];
      cell.nameLabel.attributedText = mutAtt;
      cell.nameLabel.numberOfLines = 2;
    } else if ([info.type isEqualToString:@"群聊"]) {
      XKGlobalSearchResult *result = info.dataArray[indexPath.row];
      [cell.headerImgView sd_setImageWithURL:kURL(result.team.avatarUrl) placeholderImage:kDefaultPlaceHolderImg];
      cell.nameLabel.attributedText = [self returnColorStrWithOriginText:result.text colorText:self.searchField.text originColor:nil];
    }
    [self setRadiu:cell dataArray:info.dataArray indexPath:indexPath];
    return cell;
  } else {
    XKContactListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
      cell = [[XKContactListCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:rid];
    }
    cell.showChooseBtn = NO;
    XKContactModel *model = self.netSearchDataArray[indexPath.row];
    
    cell.nameLabel.attributedText = [self returnColorStrWithOriginText:model.nickname colorText:self.searchField.text originColor:cell.nameLabel.textColor];
    [cell.headerImgView sd_setImageWithURL:kURL(model.avatar) placeholderImage:kDefaultHeadImg];
    [self setRadiu:cell dataArray:self.netSearchDataArray indexPath:indexPath];
    
    return cell;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.segment.selectIndex == 0) {
    return self.localSearchDataArray.count;
  } else {
    return 1;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.segment.selectIndex == 0) {
    return self.localSearchDataArray[section].dataArray.count;
  } else {
    return self.netSearchDataArray.count;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.segment.selectIndex == 0) {
    XKGlobalSearchLocalInfo *info = self.localSearchDataArray[indexPath.section];
    if ([info.type isEqualToString:@"联系人"]) {
      XKContactModel *user = info.dataArray[indexPath.row];
      XKPersonDetailInfoViewController *infoVC = [XKPersonDetailInfoViewController new];
      infoVC.isSecret = self.isSecret;
      infoVC.secretId = self.secretId;
      infoVC.userId = user.userId;
      [self.navigationController pushViewController:infoVC animated:YES];
    } else if  ([info.type isEqualToString:@"群聊"]) {
      if (self.isSecret) {
        //
      } else {
        XKGlobalSearchResult *result = info.dataArray[indexPath.row];
        NIMTeam *team = result.team;
        NIMSession *session = [NIMSession session:team.teamId type:NIMSessionTypeTeam];
        XKP2PChatViewController *vc = [[XKP2PChatViewController alloc] initWithSession:session];
        [self.navigationController pushViewController:vc animated:YES];
      }
    } else if  ([info.type isEqualToString:@"聊天记录"]) {
      if (self.isSecret) {
        XKGlobalSearchResult *result = info.dataArray[indexPath.row];
        NIMMessage *message = result.message;
        XKSecretChatViewController *vc = [[XKSecretChatViewController alloc] initWithSession:message.session];
        vc.searchMessage = message;
        [self.navigationController pushViewController:vc animated:YES];
      } else {
        XKGlobalSearchResult *result = info.dataArray[indexPath.row];
        NIMMessage *message = result.message;
        XKP2PChatViewController *vc = [[XKP2PChatViewController alloc] initWithSession:message.session];
        vc.searchMessage = message;
        [self.navigationController pushViewController:vc animated:YES];
      }
    } else {
      
    }
  } else {
    XKContactModel *model = self.netSearchDataArray[indexPath.row];
    XKPersonDetailInfoViewController *infoVC = [XKPersonDetailInfoViewController new];
    infoVC.isSecret = self.isSecret;
    infoVC.secretId = self.secretId;
    infoVC.userId = model.userId;
    [self.navigationController pushViewController:infoVC animated:YES];
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (self.segment.selectIndex == 0) {
    XKGlobalSearchLocalInfo *info = self.localSearchDataArray[section];
    if (info.dataArray.count == 0) {
      return nil;
    }
    
    UILabel *label = [UILabel new];
    label.text = [NSString stringWithFormat:@"   %@",info.type];
    label.font = XKRegularFont(14);
    label.textColor = HEX_RGB(0x555555);
    label.backgroundColor = HEX_RGB(0xF6F6F6);
    if (self.justSearchFriend) {
      label.xk_radius = 8;
      label.xk_openClip = YES;
      if (section == 0) {
        label.xk_clipType = XKCornerClipTypeTopBoth;
      } else  { // 不是最后一个
        label.xk_clipType = XKCornerClipTypeNone;
      }
    }
    
    return label;
  } else {
    return [UIView new];
  }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (self.segment.selectIndex == 0) {
    XKGlobalSearchLocalInfo *info = self.localSearchDataArray[section];
    if (info.dataArray.count == 0) {
      return CGFLOAT_MIN;
    } else {
      return 35;
    }
  } else {
    return 0.1;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  return [UIView new];;
}
#pragma mark - 辅助
- (NSMutableAttributedString *)returnColorStrWithOriginText:(NSString *)orangeText colorText:(NSString *)colorText originColor:(UIColor *)originColor {
  // 处理文字颜色
  NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:orangeText];
  if (originColor) {
    attrString.yy_color = originColor;
  }
  NSRange range = [orangeText.lowercaseString rangeOfString:colorText.lowercaseString];
  if(range.location != NSNotFound){
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:XKMainTypeColor
                       range:range];
  }
  return attrString;
}

- (void)setRadiu:(XKContactListCell *)cell dataArray:(NSArray *)dataArray indexPath:(NSIndexPath *)indexPath {
  cell.xk_radius = 8;
  cell.xk_openClip = YES;
  if (indexPath.row == 0) {
    cell.xk_clipType = XKCornerClipTypeNone;
    cell.hideSeperate = NO;
    if (self.netSearchDataArray.count == 1) {
      cell.xk_clipType = XKCornerClipTypeBottomBoth;
      cell.hideSeperate = YES;
    }
  } else if (indexPath.row != dataArray.count - 1) { // 不是最后一个
    cell.xk_clipType = XKCornerClipTypeNone;
    cell.hideSeperate = NO;
  } else { // 最后一个
    cell.xk_clipType = XKCornerClipTypeBottomBoth;
    cell.hideSeperate = YES;
  }
}

#pragma mark --------------------------- setter&getter -------------------------


@end
