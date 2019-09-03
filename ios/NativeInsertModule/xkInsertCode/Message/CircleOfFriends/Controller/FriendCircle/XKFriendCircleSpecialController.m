/*******************************************************************************
 # File        : XKFriendCircleSpecialController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/19
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendCircleSpecialController.h"
#import "XKFriendCirclePublishController.h"
#import "XKFriendCircleSpecialViewModel.h"
#import <IQKeyboardManager.h>

@interface XKFriendCircleSpecialController () {
  UIImageView *_backImgView;
  UIImageView *_headerImg;
  UILabel *_nameLabel;
  UILabel *_shuoshuoLabel;
  BOOL _statusLight;
  
}
/**tableView*/
@property(nonatomic, strong) UITableView *tableView;
/**viewModel*/
@property(nonatomic, strong) XKFriendCircleSpecialViewModel *viewModel;
/**<##>*/
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;
/**<##>*/
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation XKFriendCircleSpecialController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
  [super viewDidLoad];
  //    self.isInsertVC = YES;
  // 初始化默认数据
  [self createDefaultData];
  // 初始化界面
  [self createUI];
  //
  [self requestDataRefresh:YES NeedTip:YES];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [IQKeyboardManager sharedManager].enable = NO;
  //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  //     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
  
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}

- (void)dealloc {
  NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
  self.viewModel.isInsertPersonalVC = self.isInsertPersonalVC;
  self.viewModel.userId = self.userId;
  if ([self.userId isEqualToString:[XKUserInfo getCurrentUserId]]) {
    [self addPublishBtn];
  }
}

- (void)addPublishBtn {
  UIButton *publishBtn = [[UIButton alloc] init];
  [publishBtn setImage:[UIImage imageNamed:@"相机icon"] forState:UIControlStateNormal];
  [publishBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
  [publishBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
  [self setRightView:publishBtn withframe:CGRectMake(0, 0, 30, 30)];
}

- (void)publish {
  __weak typeof(self) weakSelf = self;
  XKFriendCirclePublishController *vc = [XKFriendCirclePublishController new];
  [vc setPublishSuccess:^{
    [weakSelf requestDataRefresh:YES NeedTip:NO];
  }];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 初始化界面
- (void)createUI {
  self.view.backgroundColor = HEX_RGB(0xEEEEEE);
  self.view.clipsToBounds = YES;
  self.navigationView.hidden = NO;
  [self hideNavigationSeperateLine];
  [self setBackButton:[UIImage imageNamed:@"xk_navigationBar_global_back"] andName:nil];
  [self setNavTitle:@"可友圈" WithColor:[UIColor whiteColor]];
  self.navigationView.backgroundColor = RGBA(0, 0, 0, 0);
  [self createTableView];
  [self createHeaderView];
  XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
  config.verticalOffset = -100;
  config.viewAllowTap = NO;
  config.spaceHeight = 10;
  _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
  
  [self addActivityIndicator];
}

- (void)addActivityIndicator {
  self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
  [self.view addSubview:self.activityIndicator];
  //设置小菊花的frame
  self.activityIndicator.frame= CGRectMake(0, 0, 45, 45);
  self.activityIndicator.y = self.navigationView.bottom;
  self.activityIndicator.centerX = self.navigationView.width / 2;
  //设置小菊花颜色
  //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
  self.activityIndicator.hidesWhenStopped = YES;
}

- (void)createTableView {
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  _tableView.clipsToBounds = NO;
  [self.view addSubview:_tableView];
  [self.view bringSubviewToFront:self.navigationView];
  //处理留白
  _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view);
    make.top.mas_equalTo(self.navigationView.bottom);
    make.bottom.equalTo(self.view);
  }];
  _tableView.delegate = self.viewModel;
  _tableView.dataSource = self.viewModel;
  _tableView.backgroundColor = HEX_RGB(0xEEEEEE);
  _tableView.estimatedRowHeight = 100;
  _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  //    _tableView.showsVerticalScrollIndicator = NO;
  __weak typeof(self) weakSelf = self;
  
  MJRefreshBackNormalFooter *mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    if (weakSelf.activityIndicator.isAnimating) {
      [weakSelf.tableView.mj_footer endRefreshing];
      return ;
    }
    [weakSelf requestDataRefresh:NO NeedTip:NO];
  }];
  _tableView.mj_footer = mj_footer;
  _tableView.mj_footer.hidden = YES;
  [mj_footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
  [self.viewModel registerCellForTableView:self.tableView];
  
  [self.viewModel setScrollViewScroll:^(UIScrollView *scrollView) {
    [weakSelf scrollViewDidiScroll:scrollView];
  }];
  [self.viewModel configVCToolBar:self];
  
  [self.viewModel setRefreshTableView:^{
    [weakSelf.tableView reloadData];
  }];
}

CGFloat backImagYOffset = 0;
CGFloat headerViewheight = 200;
- (void)createHeaderView {
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
  headerView.backgroundColor = HEX_RGB(0xEEEEEE);
  [headerView bk_whenTapped:^{
    [KEY_WINDOW endEditing:YES];
  }];
  headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerViewheight);
  _backImgView = [[UIImageView alloc] init];
  _backImgView.contentMode = UIViewContentModeScaleAspectFill;
  _backImgView.clipsToBounds = YES;
  _backImgView.backgroundColor = HEX_RGB(0xF1F1F1);
  backImagYOffset = self.navigationView.height;
  _backImgView.frame = CGRectMake(0, -backImagYOffset, SCREEN_WIDTH, backImagYOffset + headerView.height);
  _backImgView.userInteractionEnabled = YES;
  [_backImgView bk_whenTapped:^{
    [KEY_WINDOW endEditing:YES];
  }];
  
  [headerView addSubview:_backImgView];
  WEAK_TYPES(_backImgView)
  UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
  UIVisualEffectView *guassView = [[UIVisualEffectView alloc] initWithEffect:blur];
  guassView.alpha = 0.98f;
  [headerView addSubview:guassView];
  [guassView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(weak_backImgView);
  }];
  
  UIView *shadowView = [[UIView alloc]init];
  shadowView.backgroundColor = HEX_RGBA(0x000000, 0.4);
  [headerView addSubview:shadowView];
  [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(weak_backImgView);
  }];
  
  
  UIImageView * headerImg = [[UIImageView alloc] init];
  _headerImg = headerImg;
  _headerImg.clipsToBounds = YES;
  _headerImg.layer.cornerRadius = 6;
  _headerImg.contentMode = UIViewContentModeScaleAspectFill;
  [headerView addSubview:_headerImg];
  [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(headerView.mas_bottom).offset(-12);
    make.size.mas_equalTo(CGSizeMake(66, 66));
    make.right.equalTo(headerView.mas_right).offset(-20);
  }];
  
  
  _headerImg.userInteractionEnabled = YES;
  [_headerImg bk_whenTapped:^{
    [KEY_WINDOW endEditing:YES];
  }];
  _nameLabel = [[UILabel alloc] init];
  _nameLabel.textColor = [UIColor whiteColor];
  _nameLabel.font = XKMediumFont(17);
  
  [headerView addSubview:_nameLabel];
  [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(headerImg.mas_top).offset(5);
    make.right.equalTo(headerImg.mas_left).offset(-10);
  }];
  
  _shuoshuoLabel = [[UILabel alloc] init];
  _shuoshuoLabel.textColor = [UIColor whiteColor];
  _shuoshuoLabel.font = XKRegularFont(12);
  _shuoshuoLabel.textAlignment = NSTextAlignmentRight;
  _shuoshuoLabel.numberOfLines = 2;
  [headerView addSubview:_shuoshuoLabel];
  [_shuoshuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(headerImg.mas_bottom).offset(-2);
    make.right.equalTo(headerImg.mas_left).offset(-10);
    make.left.equalTo(headerView.mas_left).offset(30);
  }];
  self.tableView.tableHeaderView = headerView;
  
  self.tableView.tableHeaderView.hidden = YES;
}

#pragma mark - 刷新
- (void)startRefresh {
  if (self.activityIndicator.isAnimating == YES) {
    return;
  }
  [self requestDataRefresh:YES NeedTip:NO];
  [self.activityIndicator startAnimating];
}

#pragma mark - 网络请求
- (void)requestDataRefresh:(BOOL)refresh NeedTip:(BOOL)needTip {
  if (needTip) {
    [XKHudView showLoadingTo:self.tableView animated:YES];
  }
  __weak typeof(self) weakSelf = self;
  [self.viewModel requestRefresh:refresh complete:^(id error, id data) {
    [XKHudView hideHUDForView:self.tableView animated:YES];
    [self.activityIndicator stopAnimating];
    [self resetMJHeaderFooter:self.viewModel.refreshStatus tableView:self.tableView dataArray:self.viewModel.dataArray];
    [self.tableView reloadData];
    if (error) {
      if (self.viewModel.dataArray.count == 0) {
        self.emptyView.config.allowScroll = NO;
        self.tableView.tableHeaderView.hidden = YES;
        self.navigationView.backgroundColor = XKMainTypeColor;
        self.emptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
        [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
          [weakSelf requestDataRefresh:YES NeedTip:YES];
        }];
      } else {
        [XKHudView showErrorMessage:error to:self.tableView animated:YES];
      }
    } else {
      if (refresh) {
        [self updataHeaderView];
      }
      if (self.isInsertPersonalVC) {
        self.emptyView.config.allowScroll = YES;
        if (self.viewModel.dataArray.count == 0) {
          self.emptyView.config.viewAllowTap = NO;
          [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"还没有任何动态哦" tapClick:nil];
        } else {
          [self.emptyView hide];
        }
      } else {
        [self.emptyView hide];
        self.tableView.tableHeaderView.hidden = NO;
        [self scrollViewDidiScroll:self.tableView];
      }
      
    }
  }];
}

- (void)updataHeaderView {
  if (!self.isInsertPersonalVC) {
    if (_nameLabel.text.length == 0) {
      [_backImgView sd_setImageWithURL:kURL(self.viewModel.userInfo.avatar) placeholderImage:nil];
      [_headerImg sd_setImageWithURL:kURL(self.viewModel.userInfo.avatar) placeholderImage:kDefaultHeadImg];
      [_nameLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        if ([self.viewModel.userInfo.sex isEqualToString:XKSexMale]) {
          confer.appendImage(IMG_NAME(@"xk_img_personDetailInfo_male")).bounds(CGRectMake(0, -2, 17, 17));
        } else if ([self.viewModel.userInfo.sex isEqualToString:XKSexFemale]) {
          confer.appendImage(IMG_NAME(@"xk_img_personDetailInfo_female")).bounds(CGRectMake(0, -2, 17, 17));
        } else {
          // 未知
        }
        confer.text(@" ");
        confer.text(self.viewModel.userInfo.nickname);
      }];
      _shuoshuoLabel.text = self.viewModel.userInfo.signature;
      
      
    }
  }
}

#pragma mark ----------------------------- 其他方法 ------------------------------
- (void)scrollViewDidiScroll:(UIScrollView *)scrollView {
  if (scrollView.mj_offsetY > 0) {
    _backImgView.y = -backImagYOffset;
    _backImgView.height = backImagYOffset + headerViewheight;
  } else {
    _backImgView.y = -backImagYOffset + scrollView.mj_offsetY;
    _backImgView.height = backImagYOffset + headerViewheight - scrollView.mj_offsetY;
  }
  CGFloat offsetY = scrollView.contentOffset.y;
  if (offsetY > 0) {
    CGFloat alpha = MIN(1, (offsetY)/NavigationAndStatue_Height);
    self.navigationView.backgroundColor = HEX_RGBA(0x4A90FA, alpha);
  } else {
    self.navigationView.backgroundColor = HEX_RGBA(0x4A90FA, 0);
  }
  if (offsetY > NavigationAndStatue_Height) { // 变白
    if (!_statusLight) { // 不是白的才变白
      _statusLight = YES;
      //            [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
    }
  } else { // 变黑
    if (_statusLight) { // 是白的才变黑
      _statusLight = NO;
      //            [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;
    }
  }
}

#pragma mark --------------------------- setter&getter -------------------------
- (XKFriendCircleSpecialViewModel *)viewModel {
  if (!_viewModel) {
    __weak typeof(self) weakSelf = self;
    _viewModel = [[XKFriendCircleSpecialViewModel alloc] init];
    [_viewModel setNeedRequestRefresh:^{ // 触发刷新回调
      [weakSelf startRefresh];
    }];
  }
  return _viewModel;
}

@end

