/*******************************************************************************
 # File        : XKMineFocusListController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/29
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKMineFocusListController.h"
#import "XKMineFansCell.h"
#import "XKMineFocusViewModel.h"
#import "XKApplyFriendController.h"

@interface XKMineFocusListController () <UITableViewDelegate, UITableViewDataSource>
/**tableView*/
@property(nonatomic, strong) UITableView *tableView;
/**<##>*/
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;
/**viewModel*/
@property(nonatomic, strong) XKMineFocusViewModel *viewModel;
@end

@implementation XKMineFocusListController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    
    [self requestRefresh:YES needTip:YES];
}


- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

- (void)createDefaultData {
}


- (void)createUI {
    self.navigationView.hidden = NO;
    if (self.rid) {
        if ([self.rid isEqualToString:[XKUserInfo getCurrentUserId]]) {
            [self setNavTitle:@"我的关注" WithColor:[UIColor whiteColor]];
        } else {
            [self setNavTitle:@"Ta的关注" WithColor:[UIColor whiteColor]];
        }
    } else {
        [self setNavTitle:@"我的关注" WithColor:[UIColor whiteColor]];
    }
    [self createTableView];
}

- (void)createTableView {
    self.view.backgroundColor = HEX_RGB(0xF6F6F6);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.tag = kNeedFixHudOffestViewTag;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.estimatedRowHeight = 60;
    [self.containView addSubview:self.tableView];
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
        make.edges.equalTo(self.containView);
    }];
    
    XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
    
    config.viewAllowTap = NO;
    config.spaceHeight = 10;
    _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
    
    [self.tableView registerClass:[XKMineFansCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark - 关注点击
- (void)foucusClick:(NSIndexPath *)indexPath {
    [XKHudView showLoadingTo:self.containView animated:YES];
    [self.viewModel requestFocus:indexPath complete:^(NSString *error, id data) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        if (error) {
            [XKHudView showWarnMessage:error];
            return ;
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - 添加好友
- (void)applayFriend:(NSIndexPath *)indexPath {
    XKContactModel *model = self.viewModel.dataArray[indexPath.row];
    if (model.isFriends) {
        //return;
    }
    XKApplyFriendController *vc = [[XKApplyFriendController alloc] init];
    vc.applyId = model.userId;
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
                self.emptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
                [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                    [weakSelf requestRefresh:YES needTip:YES];
                }];
            } else {
                [XKHudView showErrorMessage:error to:self.tableView animated:YES];
            }
        } else {
            if (self.viewModel.dataArray.count == 0) {
                self.emptyView.config.viewAllowTap = YES;
                [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:[self isMine] ? @"您还没有关注任何人哦": @"Ta还没有关注任何人哦" tapClick:nil];
            } else {
                [self.emptyView hide];
            }
        }
    }];
}

- (BOOL)isMine {
    if (self.rid && ![self.rid isEqualToString:[XKUserInfo getCurrentUserId]]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark - tableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    XKMineFansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.clipType = XKCornerClipTypeTopBoth;
        if (self.viewModel.dataArray.count == 1) {
            cell.clipType = XKCornerClipTypeAllCorners;
        }
    } else if (indexPath.row != self.viewModel.dataArray.count - 1) { // 不是最后一个
        cell.clipType = XKCornerClipTypeNone;
    } else { // 最后一个
        cell.clipType = XKCornerClipTypeBottomBoth;
    }
    cell.indexPath = indexPath;
    [cell setAddClick:^(NSIndexPath *indexPath) {
        [weakSelf applayFriend:indexPath];
    }];
    [cell setFocusClick:^(NSIndexPath *indexPath) {
        [weakSelf foucusClick:indexPath];
    }];
    [cell setFocusModel:self.viewModel.dataArray[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [UIView new];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return CGFLOAT_MIN;
}

#pragma mark - cell 点击事件 处理选择状态
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark --------------------------- setter&getter -------------------------

- (XKMineFocusViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XKMineFocusViewModel alloc] init];
        _viewModel.rid = self.rid;
    }
    return _viewModel;
}

@end


