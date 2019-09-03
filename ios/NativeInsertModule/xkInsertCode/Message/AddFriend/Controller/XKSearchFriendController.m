/*******************************************************************************
 # File        : XKSearchFriendController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/15
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/


#import "XKSearchFriendController.h"
#import "XKContactListCell.h"
#import "XKPersonDetailInfoViewController.h"

#define kViewMargin 15

@interface XKSearchFriendController () <UITableViewDelegate, UITableViewDataSource> {
  UILabel *_searchLabel;
}
/**搜索view*/
@property(nonatomic, strong) UIView *searchView;
/**搜索框*/
@property(nonatomic, strong) UITextField *searchField;
@property(nonatomic, strong) UIButton *searchBtn;
/**tableView*/
@property(nonatomic, strong) UITableView *tableView;

/**<##>*/
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation XKSearchFriendController

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
  _dataArray = [NSMutableArray array];
  //    [_dataArray addObject:@""];
  //    [_dataArray addObject:@""];
  //    [_dataArray addObject:@""];
}

#pragma mark - 初始化界面
- (void)createUI {
  [self setNavTitle:@"搜索" WithColor:[UIColor whiteColor]];
  if (self.isSecret) {
    self.navStyle = BaseNavWhiteStyle;
  }
  self.containView.backgroundColor = HEX_RGB(0xEEEEEE);
  [self createSearchView];
  [self createTableView];
}

#pragma mark ----------------------------- 其他方法 ------------------------------
- (void)createSearchView {
  _searchView = [UIView new];
  _searchView.backgroundColor = [UIColor whiteColor];
  _searchView.xk_openClip = YES;
  _searchView.xk_radius = 8;
  _searchView.xk_clipType = XKCornerClipTypeAllCorners;
  self.searchView.frame = CGRectMake(kViewMargin, kViewMargin, SCREEN_WIDTH - 2 *kViewMargin, 45);
  [self.containView addSubview:self.searchView];
  
  //    UIImageView *imageView = [[UIImageView alloc] init];
  //    imageView.image = self.navStyle == BaseNavWhiteStyle ? IMG_NAME(@"xk_ic_login_search") : IMG_NAME(@"xk_ic_contact_search");
  //    imageView.contentMode = UIViewContentModeScaleAspectFit;
  //    [_searchView addSubview:imageView];
  //    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
  //        make.left.equalTo(self.searchView.mas_left).offset(5);
  //        make.height.equalTo(@18);
  //        make.centerY.equalTo(self.searchView);
  //        make.width.equalTo(@26);
  //    }];
  
  self.searchField = [[UITextField alloc] init];
  NSAttributedString *placeHolderAttText = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
    confer.appendImage([UIImage imageNamed:@"xk_ic_login_search"]).bounds(CGRectMake(0, -2, 15, 15));
    confer.text(@" ");
    confer.text(self.isSecret ? @"请输入密友姓名" : @"搜索可友昵称或安全码").font(self.searchField.font).textColor(HEX_RGB(0x999999));
  }];
  self.searchField.attributedPlaceholder = placeHolderAttText;
  self.searchField.font = XKNormalFont(15);
  [self.searchField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
  [_searchView addSubview:self.searchField];
  [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.searchView.mas_left).offset(10);
    make.top.bottom.equalTo(self.searchView);
    make.right.equalTo(self.searchView.mas_right).offset(-50);
  }];
  
  self.searchBtn = [[UIButton alloc] init];
  [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
  self.searchBtn.titleLabel.font = XKRegularFont(15);
  [self.searchBtn setBackgroundColor:HEX_RGB(0xCCCCCC)];
  [self.searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
  [self.searchView addSubview:self.searchBtn];
  [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.right.bottom.equalTo(self.searchView);
    make.width.equalTo(@50);
  }];
  
  //    __weak typeof(self) weakSelf = self;
  
}

- (void)createTableView {
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.layer.cornerRadius = 6;
  self.tableView.layer.masksToBounds = YES;
  self.tableView.backgroundColor = [UIColor whiteColor];
  
  self.tableView.showsVerticalScrollIndicator = NO;
  self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kViewMargin, 0);
  [self.containView addSubview:self.tableView];
  self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.searchView.mas_bottom).offset(15);
    make.left.equalTo(self.containView).offset(15);
    make.right.equalTo(self.containView).offset(-15);
    make.bottom.equalTo(self.containView.mas_bottom).offset(iPhoneX? -30 : -15);
  }];
  
  _searchLabel = [[UILabel alloc] init];
  _searchLabel.font = XKRegularFont(15);
  _searchLabel.numberOfLines = 2;
  _searchLabel.backgroundColor = [UIColor whiteColor];
  _searchLabel.textColor = HEX_RGB(0x555555);
  _searchLabel.frame = CGRectMake(0, 0, 40, 60);
  
  self.tableView.tableHeaderView = _searchLabel;
  [self textChange:nil];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)textChange:(UITextField *)textField {
  [self.dataArray removeAllObjects];
  [self.tableView reloadData];
  if (textField.text.length == 0) {
    _searchLabel.frame = CGRectMake(0, 0, 40, 60);
    self.searchBtn.backgroundColor = HEX_RGB(0xCCCCCC);
    self.searchBtn.userInteractionEnabled = NO;
    [_searchLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
      confer.paragraphStyle.headIndent(10).firstLineHeadIndent(10).tailIndent(SCREEN_WIDTH - 30 - 5);
      confer.text(@"因用户体系不通，晓可联盟APP无法添加晓可广场或晓可小视频的可友。").textColor(HEX_RGB(0x999999));
    }];
    
  } else {
    _searchLabel.frame = CGRectMake(0, 0, 20, 50);
    _searchLabel.text = [NSString stringWithFormat:@"   搜索：%@",self.searchField.text];
    self.searchBtn.userInteractionEnabled = YES;
    self.searchBtn.backgroundColor = XKMainTypeColor;
  }
  [self.tableView reloadData];
}

#pragma mark - 搜索点击
- (void)searchClick {
  [self.view endEditing:YES];
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
      [self.dataArray removeAllObjects];
      [self.dataArray addObjectsFromArray:users];
      
      [self.tableView reloadData];
    }];
  } failure:^(XKHttpErrror *error) {
    [XKHudView hideHUDForView:self.containView];
    [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
  }];
}

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *rid = @"cell";
  XKContactListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
  if(cell == nil){
    cell = [[XKContactListCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:rid];
  }
  cell.showChooseBtn = NO;
  XKContactModel *model = self.dataArray[indexPath.row];
  // 处理文字颜色
  NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:model.nickname];
  NSRange range = [model.nickname rangeOfString:self.searchField.text];
  if(range.location != NSNotFound){
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:XKMainTypeColor
                       range:range];
    
  }
  cell.nameLabel.attributedText = attrString;
  [cell.headerImgView sd_setImageWithURL:kURL(model.avatar) placeholderImage:kDefaultHeadImg];
  cell.xk_radius = 6;
  cell.xk_openClip = YES;
  if (indexPath.row == 0) {
    cell.xk_clipType = XKCornerClipTypeTopBoth;
    cell.hideSeperate = NO;
    if (self.dataArray.count == 1) {
      cell.xk_clipType = XKCornerClipTypeAllCorners;
      cell.hideSeperate = YES;
    }
  } else if (indexPath.row != self.dataArray.count - 1) { // 不是最后一个
    cell.xk_clipType = XKCornerClipTypeNone;
    cell.hideSeperate = NO;
  } else { // 最后一个
    cell.xk_clipType = XKCornerClipTypeBottomBoth;
    cell.hideSeperate = YES;
  }
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  XKContactModel *model = self.dataArray[indexPath.row];
  XKPersonDetailInfoViewController *infoVC = [XKPersonDetailInfoViewController new];
  infoVC.isSecret = self.isSecret;
  infoVC.secretId = self.secretId;
  infoVC.userId = model.userId;
  [self.navigationController pushViewController:infoVC animated:YES];
}

#pragma mark --------------------------- setter&getter -------------------------


@end
