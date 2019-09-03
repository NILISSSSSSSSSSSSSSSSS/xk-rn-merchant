/*******************************************************************************
 # File        : XKVisibleAuthorityController.m
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

#import "XKVisibleAuthorityController.h"
#import "XKVisiblelAuthorityViewModel.h"

@interface XKVisibleAuthorityController ()
/**<##>*/
@property(nonatomic, strong) UITableView *tableView;
/**<##>*/
@property(nonatomic, strong) XKVisiblelAuthorityViewModel *viewModel;
@end

@implementation XKVisibleAuthorityController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    if (![self.result containNetData]) { // 没有分组数据 代表之前结果数据缺失  需要重新请求
        [self requestNeedTip:YES];
    }
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    __weak typeof(self) weakSelf = self;
    _viewModel = [XKVisiblelAuthorityViewModel new];
    [_viewModel setInitData:self.result];
    [_viewModel setReloadData:^{
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - 初始化界面
- (void)createUI {
    [self setNavTitle:@"谁可以看" WithColor:[UIColor whiteColor]];
    UIButton *newBtn = [[UIButton alloc] init];
    [newBtn setTitle:@"完成" forState:UIControlStateNormal];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newBtn.titleLabel.font = XKRegularFont(17);
    [newBtn sizeToFit];
    [newBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:newBtn withframe:newBtn.bounds];
    
    self.containView.backgroundColor = HEX_RGB(0xEEEEEE);
    self.tableView = [[UITableView alloc] initWithFrame:self.containView.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self.viewModel;
    self.tableView.dataSource = self.viewModel;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.estimatedRowHeight = 60;
    [self.containView addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
    // 注册cell
    [self.viewModel registerCellForTableView:self.tableView];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)doneClick {
  XKVisiblelAuthorityResult *result = [[XKVisiblelAuthorityResult alloc] init];
  result.dataArray = self.viewModel.dataArray;
  if ([[result getDynamicAuthType] isEqualToString:DynamicAuthSee] || [[result  getDynamicAuthType] isEqualToString:DynamicAuthUnSee] ) {
    if ([result getDynamicUserIds].count == 0) {
      [XKHudView showTipMessage:@"请至少选择一个联系人"];
      return;
    }
  }
  EXECUTE_BLOCK(self.resultBlock,result);
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----------------------------- 网络请求 ------------------------------
- (void)requestNeedTip:(BOOL)needTip {
    if (needTip) {
        [XKHudView showLoadingTo:self.containView animated:YES];
    }
    [self.viewModel requestGroupsComplete:^(NSString *err, id data) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        if (err) {
            [XKHudView showErrorMessage:err to:self.containView animated:YES];
        } else {
            [self.tableView reloadData];
        }
    }];
}

#pragma mark --------------------------- setter&getter -------------------------


@end
