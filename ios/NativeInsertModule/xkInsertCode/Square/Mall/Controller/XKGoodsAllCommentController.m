/*******************************************************************************
 # File        : XKGoodsAllCommentController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/18
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGoodsAllCommentController.h"
#import "XKGoodsAllCommentViewModel.h"
#import "XKGoodsCommentCell.h"
#import "XKTagsDisplayView.h"

@interface XKGoodsAllCommentController ()
/***/
@property(nonatomic, strong) UITableView *tableView;
/**<##>*/
@property(nonatomic, strong) XKGoodsAllCommentViewModel *viewModel;
/**<##>*/
@property(nonatomic, strong) XKTagsDisplayView *tagsView;
/**<##>*/
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;
@end

@implementation XKGoodsAllCommentController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    [self requestCommentLabels];
    [self requestRefresh:YES tag:nil needTip:YES];
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
    __weak typeof(self) weakSelf = self;
    _viewModel = [XKGoodsAllCommentViewModel new];
    _viewModel.goodsId = self.goodsId;
    _viewModel.type = self.type;
    [_viewModel setReloadData:^{
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - 初始化界面
- (void)createUI {
   
    self.navigationView.hidden = NO;
    [self setNavTitle:@"全部评价" WithColor:[UIColor whiteColor]];
    if (self.type == XKAllCommentTypeForWelfare) {
        [self setNavTitle:@"大奖晒单" WithColor:[UIColor whiteColor]];
    }
    [self createTableView];
}

- (void)createTableView {
    __weak typeof(self) weakSelf = self;
    self.view.backgroundColor = HEX_RGB(0xF6F6F6);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self.viewModel;
    self.tableView.dataSource = self.viewModel;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.estimatedRowHeight = 150;
    [self.containView addSubview:self.tableView];
    
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestRefresh:YES tag:weakSelf.viewModel.tag needTip:NO];
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestRefresh:NO tag:weakSelf.viewModel.tag needTip:NO];
        
    }];
    self.tableView.mj_footer = footer;
    [footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer.hidden = YES;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containView);
    }];
    [self.viewModel registerCellForTableView:self.tableView];
    XMEmptyViewConfig *config = [XMEmptyViewConfig new];
    config.verticalOffset = -30;
    _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];

    // 标签
    _tagsView = [[XKTagsDisplayView alloc] init];
    _tagsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.01);
    self.tableView.tableHeaderView = _tagsView;
    [_tagsView setHeightChange:^(CGFloat height, XKTagsDisplayView *tagsView) {
        [weakSelf.tableView reloadData];
    }];
    [_tagsView setItemChange:^(NSInteger index, NSString *text, XKTagsDisplayView *tagsView) {
        XKCommentLabelModel *label = weakSelf.viewModel.labelDataArray[index];
        // 标签切换
        if ([weakSelf.viewModel.tag isEqualToString:label.code]) {
            return ;
        }
        // 标签切换 先清空数据
        [weakSelf.viewModel.dataArray removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf requestRefresh:YES tag:label.code needTip:NO];
    }];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark ----------------------------- 网络请求 ------------------------------

// 请求评论标签
- (void)requestCommentLabels {
    [self.viewModel requestCommentLabelComplete:^(NSString *error, id data) {
        if (error || self.viewModel.labelDataArray.count == 0) {
            return;
        }
        NSMutableArray *arr = @[].mutableCopy;
        for (XKCommentLabelModel *label in self.viewModel.labelDataArray) {
            [arr addObject:[NSString stringWithFormat:@"%@%@",label.displayName,label.count.length != 0 ? [NSString stringWithFormat:@"(%@)",label.count]:@""]];
        }
        [self.tagsView setArr:arr];
        [self.tagsView setDefualtIndex:0];
    }];
}

- (void)requestRefresh:(BOOL)refresh tag:(NSString *)tag needTip:(BOOL)needTip {
    if (needTip) {
        [XKHudView showLoadingTo:self.tableView animated:YES];
    }
    [_emptyView hide];
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestIsRefresh:refresh tag:tag complete:^(NSString *error, NSArray *array) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [self resetMJHeaderFooter:self.viewModel.refreshStatus tableView:self.tableView dataArray:self.viewModel.dataArray];
        [self.tableView reloadData];
        if (error) {
            if (self.viewModel.dataArray.count == 0) {
                self.emptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
                [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                    [weakSelf requestRefresh:YES tag:tag needTip:YES];
                }];
            } else {
                [XKHudView showErrorMessage:error to:self.tableView animated:YES];
            }
        } else {
            if (self.viewModel.dataArray.count == 0) {
                self.emptyView.config.viewAllowTap = NO;
                [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无评论" tapClick:nil];
            } else {
                [self.emptyView hide];
            }
        }
    }];
}
#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
