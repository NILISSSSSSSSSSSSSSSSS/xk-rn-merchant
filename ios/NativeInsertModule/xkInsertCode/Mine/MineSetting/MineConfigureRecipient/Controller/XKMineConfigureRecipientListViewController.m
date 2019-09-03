//
//  XKMineConfigureRecipientListViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/8/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineConfigureRecipientListViewController.h"
#import "XKMineConfigureRecipientListTableViewCell.h"
#import "XKMineConfigureRecipientEditViewController.h"
#import "XKMineConfigureRecipientListModel.h"
#import "XKEmptyPlaceView.h"
#import "UIImage+Edit.h"

static const CGFloat kConfigureRecipientListTableViewEdge = 10.0;
static const CGFloat kConfigureRecipientListTableViewCellHight = 78.0;
static const CGFloat kConfigureRecipientListTableViewHeaderHight = 5.0;
static const CGFloat kConfigureRecipientListTableViewFooterHight = 20.0;
NSString *const kConfigureRecipientListTableViewCellIdentifier = @"XKMineConfigureRecipientListTableViewCell";

@interface XKMineConfigureRecipientListViewController () <UITableViewDataSource, UITableViewDelegate, XKMineConfigureRecipientListTableViewCellDelegate, XKMineConfigureRecipientEditViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) XKEmptyPlaceView *emptyView;
@property (nonatomic, assign) BOOL hasLoadData;

@end

@implementation XKMineConfigureRecipientListViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeViews];
    self.currentPage = 1;
    self.hasLoadData = NO;
    [self getRecipientList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.dataArr && self.dataArr.count != 0) {
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 5)];
        tableHeaderView.backgroundColor = [UIColor whiteColor];
        [tableHeaderView cutCornerWithRoundedRect:tableHeaderView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        return tableHeaderView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.dataArr && self.dataArr.count != 0) {
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 5)];
        tableFooterView.backgroundColor = [UIColor whiteColor];
        [tableFooterView cutCornerWithRoundedRect:tableFooterView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        return tableFooterView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKMineConfigureRecipientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kConfigureRecipientListTableViewCellIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    XKMineConfigureRecipientItem *recipientItem = self.dataArr[indexPath.row];
    [cell configTableViewCell:recipientItem];
    if (indexPath.row == self.dataArr.count - 1) {
        [cell hiddenCellSeparator];
    } else {
        [cell showCellSeparator];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kConfigureRecipientListTableViewHeaderHight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kConfigureRecipientListTableViewFooterHight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kConfigureRecipientListTableViewCellHight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:item:)]) {
        XKMineConfigureRecipientItem *recipientItem = self.dataArr[indexPath.row];
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath item:recipientItem];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定删除该地址吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            XKMineConfigureRecipientItem *recipientItem = self.dataArr[indexPath.row];
            [self deleteRecipient:recipientItem];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    UITableViewRowAction *setDefaultAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"设为默认" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        XKMineConfigureRecipientItem *recipientItem = self.dataArr[indexPath.row];
        [self setDefaultRecipient:recipientItem];
    }];
    setDefaultAction.backgroundColor = [UIColor lightGrayColor];
    
    // 默认地址隐藏【设为默认】按钮
    XKMineConfigureRecipientItem *recipientItem = self.dataArr[indexPath.row];
    NSString *isDefault = recipientItem.isDefault;
    if ([isDefault isEqualToString:@"1"]) {
        return @[deleteAction];
    } else {
        return @[deleteAction, setDefaultAction];
    }
}

#pragma mark - XKMineConfigureRecipientListTableViewCellDelegate

- (void)configureRecipientList:(XKMineConfigureRecipientListTableViewCell *)cell clickEditingButton:(UIButton *)sender {
    
    XKMineConfigureRecipientEditViewController *configureRecipientEditViewController = [XKMineConfigureRecipientEditViewController new];
    configureRecipientEditViewController.state = XKMineConfigureRecipientEditViewControllerStateEdit;
    configureRecipientEditViewController.delegate = self;
    configureRecipientEditViewController.hidesBottomBarWhenPushed = YES;
    XKMineConfigureRecipientItem *recipientItem = self.dataArr[cell.indexPath.row];
    configureRecipientEditViewController.recipientItem = recipientItem;
    if (self.dataArr.count == 1) {
        configureRecipientEditViewController.isForceDefault = YES;
    } else {
        configureRecipientEditViewController.isForceDefault = NO;
    }
    [self.navigationController pushViewController:configureRecipientEditViewController animated:YES];
}

#pragma mark - XKMineConfigureRecipientEditViewControllerDelegate

- (void)viewController:(XKMineConfigureRecipientEditViewController *)viewController didDeletedRecipientItem:(XKMineConfigureRecipientItem *)recipientItem {
    
    [self.dataArr removeObject:recipientItem];
    [self.tableView reloadData];
    
    // 删除了默认地址，重新设置
    if ([recipientItem.isDefault isEqualToString:@"1"]) {
        if (self.dataArr != 0) {
            XKMineConfigureRecipientItem *newDefaultRecipientItem = self.dataArr[0];
            [self setDefaultRecipient:newDefaultRecipientItem];
        }
    }
}

- (void)viewController:(XKMineConfigureRecipientEditViewController *)viewController creatNewRecipientItem:(XKMineConfigureRecipientItem *)recipientItem {
    
    self.currentPage = 1;
    self.hasLoadData = NO;
    [self getRecipientList];
}

#pragma mark - events

- (void)createAdress:(UIButton *)sender {
    
    XKMineConfigureRecipientEditViewController *configureRecipientEditViewController = [XKMineConfigureRecipientEditViewController new];
    configureRecipientEditViewController.state = XKMineConfigureRecipientEditViewControllerStateCreat;
    configureRecipientEditViewController.delegate = self;
    if (self.hasLoadData && self.dataArr.count == 0) {
        configureRecipientEditViewController.isForceDefault = YES;
    } else {
        configureRecipientEditViewController.isForceDefault = NO;
    }
    configureRecipientEditViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:configureRecipientEditViewController animated:YES];
}

#pragma mark - private methods

/*
 * 初始化视图
 */
- (void)initializeViews {
    
    [self setNavTitle:@"我的收货地址" WithColor:[UIColor whiteColor]];
    UIButton *newAdressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newAdressButton setTitle:@"新增地址" forState:UIControlStateNormal];
    newAdressButton.titleLabel.tintColor = [UIColor whiteColor];
    [newAdressButton addTarget:self action:@selector(createAdress:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:newAdressButton withframe:CGRectMake(0, 20, 100, 24)];
    
    // 下拉刷新 & 上拉加载
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.dataArr removeAllObjects];
        weakSelf.currentPage = 1;
        [weakSelf getRecipientList];
    }];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf getRecipientList];
    }];
    [footer setTitle:@"上拉加载更多数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height + kConfigureRecipientListTableViewEdge, kConfigureRecipientListTableViewEdge, 0, kConfigureRecipientListTableViewEdge));
    }];
    
    XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
    config.viewAllowTap = NO;
    
    config.backgroundColor = self.tableView.backgroundColor;
    config.btnColor = [UIColor whiteColor];
    config.btnBackImg = XKMainTypeColor;
    config.spaceHeight = 40;
    self.emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
}

/*
 * 获取收货地址列表
 */
- (void)getRecipientList {
    
    NSString *currentPageString = [NSString stringWithFormat:@"%@", @(self.currentPage)];
    NSDictionary *parameters = @{@"page"    : currentPageString,
                                 @"limit"   : @"20"};
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:GetRecipientListUrl timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        self.hasLoadData = YES;
        
        XKMineConfigureRecipientListModel *model = [XKMineConfigureRecipientListModel yy_modelWithJSON:responseObject];
        if (self.currentPage == 1) {
            self.dataArr = model.data.mutableCopy;
        } else if (self.currentPage > 1) {
            [self.dataArr addObjectsFromArray:model.data];
        }
        
        // 无数据
        if (self.dataArr == nil || self.dataArr.count == 0) {
            __weak typeof(self) weakSelf = self;
            [self.emptyView showWithImgName:@"xk_ic_recipient_empty" title:@"" des:@"您还没有添加收货地址" btnText:@"添加新地址" btnImg:nil tapClick:^{
                [weakSelf createAdress:nil];
            }];
            self.tableView.mj_footer.hidden = YES;
            
        // 存在数据
        } else {
            if (model.data.count < 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer resetNoMoreData];
            }
            [self.emptyView hide];
        }
        
        // 刷新tableView
        [self.tableView reloadData];
        
    } failure:^(XKHttpErrror *error) {
        
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showErrorMessage:error.message to:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = YES;
    }];
}

/*
 * 设置默认收货地址
 */
- (void)setDefaultRecipient:(XKMineConfigureRecipientItem *)recipientItem {
    
    NSString *ID = recipientItem.ID;
    NSString *isDefault = @"1";
    NSDictionary *parameters = @{@"id": ID,
                                 @"isDefault": isDefault};
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:GetSetDefaultRecipientUrl timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        
        [XKHudView hideHUDForView:self.tableView];
        [self getRecipientList];
        
    } failure:^(XKHttpErrror *error) {
        
        [XKHudView hideHUDForView:self.tableView];
    }];
}

/*
 * 删除收货地址
 */
- (void)deleteRecipient:(XKMineConfigureRecipientItem *)recipientItem {
    
    NSString *ID = recipientItem.ID;
    NSDictionary *parameters = @{@"id": ID};
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:GetDeleteRecipientUrl timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView];
        
        [self.dataArr removeObject:recipientItem];
        [self.tableView reloadData];
        
        // 删除了默认地址，重新设置
        if ([recipientItem.isDefault isEqualToString:@"1"]) {
            if (self.dataArr != 0) {
                XKMineConfigureRecipientItem *newDefaultRecipientItem = self.dataArr[0];
                [self setDefaultRecipient:newDefaultRecipientItem];
            }
        }
//        [self getRecipientList];
        
    } failure:^(XKHttpErrror *error) {
        
        [XKHudView hideHUDForView:self.tableView];
        
    }];
}

#pragma mark - setter and getter

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[XKMineConfigureRecipientListTableViewCell class] forCellReuseIdentifier:kConfigureRecipientListTableViewCellIdentifier];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

@end
