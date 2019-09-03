/*******************************************************************************
 # File        : XKContactBlackListController.m
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

#import "XKContactBlackListController.h"
#import "UIView+XKCornerRadius.h"
#import "XKContactBlackListViewModel.h"

#define kViewMargin 10

@interface XKContactBlackListController ()
/**viewModel*/
@property(nonatomic, strong) XKContactBlackListViewModel *viewModel;
/**无数据框*/
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;
@end

@implementation XKContactBlackListController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    // 请求
    [self requestDataNeedTip:YES];
}


- (void)update {
    [self requestDataNeedTip:NO];
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    __weak typeof(self) weakSelf = self;
    _viewModel = [[XKContactBlackListViewModel alloc] init];
    [_viewModel setRefreshBlock:^{
        [weakSelf.tableView reloadData];
    }];
    [_viewModel setRemove:^(NSIndexPath *indexPath) {
        [weakSelf remove:indexPath];
    }];
}

#pragma mark - 初始化界面
- (void)createUI {
    [self setNavTitle:@"通讯录黑名单" WithColor:[UIColor whiteColor]];
    self.containView.backgroundColor = HEX_RGB(0xEEEEEE);
    
    [self createSearchView];
    [self createTableView];
    
    self.searchField.delegate = self.viewModel;
    [self.searchField addTarget:self.viewModel action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(kViewMargin);
        make.right.equalTo(self.containView.mas_right).offset(-kViewMargin);
        make.bottom.equalTo(self.containView.mas_bottom);
        make.top.equalTo(self.searchView.mas_bottom).offset(kViewMargin);
    }];
    self.tableView.delegate = self.viewModel;
    self.tableView.dataSource = self.viewModel;
    
    XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
    
    config.viewAllowTap = NO;
    _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
}

#pragma mark - 请求
- (void)requestDataNeedTip:(BOOL)tip {
    __weak typeof(self) weakSelf = self;
    [XKHudView showLoadingTo:self.containView animated:YES];
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
                [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"无拉黑好友哦" tapClick:nil];
            } else {
                [self.emptyView hide];
            }
        }
    }];
}

#pragma mark - 移除
- (void)remove:(NSIndexPath *)indexPath {
    [XKHudView showLoadingTo:self.containView animated:YES];
    [self.viewModel removeBlackList:indexPath complete:^(NSString *error, id data) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        if (error) {
            [XKHudView showWarnMessage:error to:self.containView animated:YES];
        } else {
            [self.tableView reloadData];
        }
    }];
}


@end
