/*******************************************************************************
 # File        : XKReceiptManageListController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/7
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKReceiptManageListController.h"
#import "XKPersonalDataTableViewCell.h"
#import "UIView+XKCornerRadius.h"
#import "XKEmptyPlaceView.h"
#import "XKReceiptInfoController.h"
#import "XKReceiptListViewModel.h"
#import <MJRefresh.h>

@interface XKReceiptManageListController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
/**<##>*/
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;
/**viewModel*/
@property(nonatomic, strong) XKReceiptListViewModel *viewModel;
@end

@implementation XKReceiptManageListController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    // 请求
    [self requestRefresh:YES needTip:YES];
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
}

#pragma mark - 初始化界面
- (void)createUI {
    self.navigationView.hidden = NO;
    [self setNavTitle:@"发票信息管理" WithColor:[UIColor whiteColor]];
    if (self.title.length != 0) {
        [self setNavTitle:self.title WithColor:[UIColor whiteColor]];
    }
    UIButton *newBtn = [[UIButton alloc] init];
    [newBtn setTitle:@"新建" forState:UIControlStateNormal];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newBtn.titleLabel.font = XKRegularFont(17);
    [newBtn setFrame:CGRectMake(0, 0, XKViewSize(35), XKViewSize(25))];
    [newBtn addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:newBtn withframe:newBtn.bounds];
    
    [self.view addSubview:self.tableView];
    self.tableView.tag = kNeedFixHudOffestViewTag;
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestRefresh:YES needTip:NO];
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestRefresh:NO needTip:NO];
    }];
    self.tableView.mj_footer = footer;
    [footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer.hidden = YES;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);

    }];
    
    // 空视图
    XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
    
    config.viewAllowTap = NO;
    config.backgroundColor = self.tableView.backgroundColor;
    config.btnFont = XKRegularFont(14);
    config.btnColor = XKMainTypeColor;
    config.descriptionColor = HEX_RGB(0x777777);
    config.descriptionFont = XKRegularFont(15);
    config.spaceHeight = 3;
    config.spaceImgBtmHeight = 25;
    _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

- (void)create {
    __weak typeof(self) weakSelf = self;
    XKReceiptInfoController *vc = [XKReceiptInfoController new];
    vc.infoChange = ^{
        [weakSelf requestRefresh:YES needTip:NO];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----------------------------- 网络请求 ------------------------------
- (void)requestRefresh:(BOOL)refresh needTip:(BOOL)needTip {
    if (needTip) {
        [XKHudView showLoadingTo:self.tableView animated:YES];
    }
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestIsRefresh:refresh complete:^(NSString *error, NSArray *array) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [self resetMJHeaderFooter:self.viewModel.refreshStatus tableView:self.tableView dataArray:self.viewModel.dataArray];
        [self.tableView reloadData];
        if (error) {
            if (self.viewModel.dataArray.count == 0) {
                self.emptyView.config.viewAllowTap = YES;
                [self.emptyView showWithImgName:@"xk_ic_mine_receipt_no" title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                    [weakSelf requestRefresh:YES needTip:YES];
                }];
            }
        } else {
            if (self.viewModel.dataArray.count == 0) {
                self.emptyView.config.viewAllowTap = NO;
                [self.emptyView showWithImgName:@"xk_ic_mine_receipt_no" title:nil des:@"\n您还没有发票信息哦！" btnText:@"去新建发票信息" btnImg:nil tapClick:^{
                    [weakSelf create];
                }];
            } else {
                [self.emptyView hide];
            }
        }
    }];
}


#pragma mark ----------------------------- 代理方法 ------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKPersonalDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.xk_openClip = YES;
    cell.xk_radius = 10;
    if (indexPath.row == 0) {
        cell.xk_clipType = XKCornerClipTypeTopBoth;
    } else if (indexPath.row == self.viewModel.dataArray.count - 1) {
        cell.smallLabel.text = nil;
        cell.xk_clipType = XKCornerClipTypeBottomBoth;
    } else {
        cell.xk_clipType = XKCornerClipTypeNone;
    }
    XKReceiptInfoModel *receipt = self.viewModel.dataArray[indexPath.row];
    cell.titleLabel.text = receipt.head;
    cell.rightTitlelabel.text = receipt.isPersonal ? @"个人" : @"企业";
    cell.smallLabel.text = receipt.isDefault ? @"[默认]":@"";
    if (self.useType == XKReceiptManageListUseTypeSelect) {
        cell.nextImageView.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XKReceiptInfoModel *model = self.viewModel.dataArray[indexPath.row];
    if (self.useType == XKReceiptManageListUseTypeSelect) {
        EXECUTE_BLOCK(self.chooseBlock,@[model]);
        return;
    }
    __weak typeof(self) weakSelf = self;
    XKReceiptInfoController *vc = [XKReceiptInfoController new];
    vc.infoChange = ^{
        [weakSelf requestRefresh:YES needTip:NO];
    };
    vc.receiptId = model.receiptId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark --------------------------- setter&getter -------------------------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[XKPersonalDataTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (XKReceiptListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XKReceiptListViewModel alloc] init];
    }
    return _viewModel;
}

@end
