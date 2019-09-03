/*******************************************************************************
 # File        : XKBaseListController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/26
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKBaseListController.h"
#import "UIView+XKCornerRadius.h"
#import "XKEmptyPlaceView.h"
#import "ProjectEnum.h"
@interface XKBaseListController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableDictionary *_estimatedRowHeightCache;
    BOOL _neverRequest;
}

@property(nonatomic, strong) NSMutableArray *dataArray;
/**tableView*/
@property(nonatomic, strong) UITableView *tableView;
/**无数据框*/
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;
/**请求页数*/
@property(nonatomic, assign) NSInteger page;
/**请求条数*/
@property(nonatomic, assign) NSInteger limit;
@end


@implementation XKBaseListController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    _estimatedRowHeightCache = [NSMutableDictionary dictionary];
    // 初始化界面
    [self createSuperUI];
    // 初始化默认数据
    [self createSuperDefaultData];
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createSuperDefaultData {
    _page = 1;
    _limit = 20;
    _neverRequest = YES;
}

#pragma mark - 初始化界面
- (void)createSuperUI {
    self.view.backgroundColor = HEX_RGB(0xEEEEEE);
    [self createTableView];
}

- (void)createTableView {
    self.tableView = [self makeTableView];
    [self configMoreForTableView:self.tableView];
    self.emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
}

- (UITableView *)makeTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tag = kNeedFixHudOffestViewTag;
    tableView.estimatedRowHeight = 300;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        if ([self needNav]) {
            self.navigationView.hidden = NO;
            make.top.equalTo(self.navigationView.mas_bottom);
        } else {
            self.navigationView.hidden = YES;
            make.top.equalTo(self.view.mas_top);
        }
    }];
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf baseRequestRefresh:YES needTip:NO];
    }];
    tableView.mj_header = narmalHeader;
    
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf baseRequestRefresh:NO needTip:NO];
    }];
    foot.hidden = YES;
    [foot setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
    tableView.mj_footer = foot;
    return tableView;
}

#pragma mark - -------公用方法-------------

- (void)requestFirst {
    if (_neverRequest) { // 需要请求
        [self baseRequestRefresh:YES needTip:YES];
        _neverRequest = NO;
    }
}

- (void)refreshDataNeedTip:(BOOL)needTip {
    [self baseRequestRefresh:YES needTip:needTip];
}

- (void)baseRequestRefresh:(BOOL)isRefresh needTip:(BOOL)needTip {

    if (needTip) {
        [XKHudView showLoadingTo:self.tableView animated:YES];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (isRefresh) {
        [params setObject:@(1) forKey:@"page"];
    } else {
        [params setObject:@(self.page + 1) forKey:@"page"];
    }
    [params setObject:@(_limit) forKey:@"limit"];
    __weak typeof(self) weakSelf = self;
    [self requestIsRefresh:isRefresh params:params complete:^(NSString *error, NSArray *array) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        RefreshDataStatus refreshStatus;
        if (error) {
            refreshStatus = Refresh_NoNet;
            if (self.dataArray.count == 0) {
                [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"温馨提示" des:@"网络错误 点击重试" tapClick:^{
                    [weakSelf baseRequestRefresh:YES needTip:YES];
                }];
            }
        } else {
            if (isRefresh) {
                self.page = 1;
            } else {
                self.page += 1;
            }
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            if (array.count < self.limit) {
                refreshStatus = Refresh_NoDataOrHasNoMoreData;
            } else {
                refreshStatus = Refresh_HasDataAndHasMoreData;
            }
            [self.dataArray addObjectsFromArray:array];
            if (self.dataArray.count == 0) {
                [self.emptyView showWithImgName:kEmptyPlaceImgName title:@"" des:@"暂无数据" tapClick:^{
                    //
                }];
            } else {
                [self.emptyView hide];
            }
        }
        [self resetMJHeaderFooter:refreshStatus tableView:self.tableView dataArray:self.dataArray];
        [self.tableView reloadData];
    }];
}

#pragma mark - ----------_cell 点击事件-----------


#pragma mark - tableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self returnCellForIndexPath:indexPath tableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self dataArray].count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dealCellClick:indexPath];
}

#pragma mark - 解决动态cell高度 reloadData刷新抖动的问题
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
   _estimatedRowHeightCache[indexPath] = @(cell.frame.size.height);
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return [_estimatedRowHeightCache[indexPath] floatValue] + 1;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - ==========================子类重写======================================
#pragma mark - 子类重写 实现数据请求
- (void)requestIsRefresh:(BOOL)isRefresh params:(NSMutableDictionary *)params complete:(void(^)(NSString *error,NSArray *array))complete {
    @throw [NSException exceptionWithName:NSStringFromClass([self class]) reason:@"requestIsRefresh方法子类请重写" userInfo:nil];
}
#pragma mark - 子类重写 实现返回cell
- (UITableViewCell *)returnCellForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    @throw [NSException exceptionWithName:NSStringFromClass([self class]) reason:@"dealCellForIndexPath方法子类请重写" userInfo:nil];
}

#pragma mark - 子类实现 处理cell 的点击事件
- (void)dealCellClick:(NSIndexPath *)indexPath {
  
}

#pragma mark - 子类实现 处理注册cell
- (void)configMoreForTableView:(UITableView *)tableView {
    
}

#pragma mark - 子类重写 是否显示导航栏
- (BOOL)needNav {
    return YES;
}

@end

