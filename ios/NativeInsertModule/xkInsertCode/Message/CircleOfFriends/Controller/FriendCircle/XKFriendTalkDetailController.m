/*******************************************************************************
 # File        : XKFriendTalkDetailControllerViewController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/18
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendTalkDetailController.h"

#import "XKFriendCircleDetailViewModel.h"
#import <IQKeyboardManager.h>

@interface XKFriendTalkDetailController () {
  UIImageView *_backImgView;
  UIImageView *_headerImg;
  UILabel *_nameLabel;
  UILabel *_shuoshuoLabel;
  BOOL _statusLight;
}
/**tableView*/
@property(nonatomic, strong) UITableView *tableView;
/**viewModel*/
@property(nonatomic, strong) XKFriendCircleDetailViewModel *viewModel;
/**<##>*/
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;
@end

@implementation XKFriendTalkDetailController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
  [super viewDidLoad];
  // 初始化默认数据
  [self createDefaultData];
  // 初始化界面
  [self createUI];
  //
  [self requestDataNeedTip:YES];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
  [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  //     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
  
}

- (void)willPopToPreviousController {
  if (self.viewModel.infoChange) {
    XKFriendTalkModel *model = self.viewModel.dataArray.firstObject;
    model.did = self.did;
    if (model) {
      EXECUTE_BLOCK(self.talkDetailChange,model);
    }
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
  self.viewModel.did = self.did;
}

#pragma mark - 初始化界面
- (void)createUI {
  self.view.backgroundColor = [UIColor whiteColor];
  self.view.clipsToBounds = YES;
  self.navigationView.hidden = NO;
  [self hideNavigationSeperateLine];
  [self setNavTitle:@"详情" WithColor:[UIColor whiteColor]];
  [self createTableView];
  
  XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
  config.verticalOffset = -100;
  config.viewAllowTap = NO;
  config.spaceHeight = 10;
  _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
}

- (void)createTableView {
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  [self.containView addSubview:_tableView];
  //处理留白
  _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.left.right.equalTo(self.containView);
    make.bottom.equalTo(self.containView.mas_bottom).offset(-50 - kBottomSafeHeight);
  }];
  _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
  _tableView.delegate = self.viewModel;
  _tableView.dataSource = self.viewModel;
  _tableView.backgroundColor = HEX_RGB(0xEEEEEE);
  _tableView.estimatedRowHeight = 100;
  _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  
  [self.viewModel registerCellForTableView:self.tableView];
  [self.viewModel configVCToolBar:self];
  __weak typeof(self) weakSelf = self;
  [self.viewModel setRefreshTableView:^{
    [weakSelf.tableView reloadData];
  }];
}

#pragma mark - 请求
- (void)requestDataNeedTip:(BOOL)needTip {
  if (needTip) {
    [XKHudView showLoadingTo:self.containView animated:YES];
  }
  __weak typeof(self) weakSelf = self;
  [self.viewModel requestCompleteBlock:^(id error, id data) {
    [XKHudView hideHUDForView:self.containView];
    if (error) {
      if (self.viewModel.dataArray.count == 0) {
        self.emptyView.config.allowScroll = NO;
        self.emptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
        [self.emptyView showWithImgName:kNetErrorPlaceImgName title:error des:@"点击屏幕重试" tapClick:^{
          [weakSelf requestDataNeedTip:YES];
        }];
      } else {
        [XKHudView showErrorMessage:error to:self.tableView animated:YES];
      }
    } else {
      [self.emptyView hide];
      [self.tableView reloadData];
    }
  }];
}

#pragma mark --------------------------- setter&getter -------------------------
- (XKFriendCircleDetailViewModel *)viewModel {
  if (!_viewModel) {
    __weak typeof(self) weakSelf = self;
    _viewModel = [[XKFriendCircleDetailViewModel alloc] init];
    [_viewModel setDeleteClick:^{
      EXECUTE_BLOCK(weakSelf.deleteClick,weakSelf.viewModel.dataArray.firstObject);
      [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
  }
  return _viewModel;
}

@end
