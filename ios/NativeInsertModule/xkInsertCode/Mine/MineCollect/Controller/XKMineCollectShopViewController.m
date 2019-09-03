///*******************************************************************************
// # File        : XKMineCollectShopViewController.m
// # Project     : XKSquare
// # Author      : Lin Li
// # Created     : 2018/9/7
// # Corporation : 水木科技
// # Description :
// <#Description Logs#>
// -------------------------------------------------------------------------------
// # Date        : <#Change Date#>
// # Author      : <#Change Author#>
// # Notes       :
// <#Change Logs#>
// ******************************************************************************/
//
//#import "XKMineCollectShopViewController.h"
//#import "UIView+XKCornerRadius.h"
//#import "XKMineCollectShopTableViewCell.h"
//#import "XKWelfareOrderDetailBottomView.h"
//#import "XKDropDownList.h"
//#import "XKDropDownButton.h"
//#import "XKCollectViewModel.h"
//#import "XKCollectShopModel.h"
//#import "XKMineCollectBottomView.h"
//#import "XKCollectShopModel.h"
//#import "XKShopShareView.h"
//#import "XKStoreRecommendViewController.h"
//
//@interface XKMineCollectShopViewController ()<UITableViewDelegate,UITableViewDataSource,XKCustomShareViewDelegate>{
//    BOOL _neverRequest;
//}
//@property (nonatomic, strong) UITableView    *tableView;
//@property (nonatomic, strong) XKWelfareOrderDetailBottomView *bottomView;
//@property (nonatomic, strong) NSArray        *headerButtonTitleArray;
//@property (nonatomic, strong) XKDropDownList *dropList;
///**请求数据的viewModel*/
//@property (nonatomic, strong) XKCollectViewModel *viewModel;
//@property (nonatomic, strong) XKEmptyPlaceView *emptyView;
///**list名字*/
//@property (nonatomic, copy) NSString *listTitle;
//
//@property (nonatomic, strong)XKCollectShopModelDataItem    *model;
//
///**是否显示占位视图*/
//@property(nonatomic, assign) BOOL showEmptyView;
//
//@end
//
//@implementation XKMineCollectShopViewController
//#pragma mark – Life Cycle
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self initViews];
//    // 初始化默认数据
//    _neverRequest = YES;
//    self.listTitle = @"全部分类";
//    [self initData];
//    [self hideNavigation];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark – Private Methods
//- (void)initViews {
//    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.bottomView];
//    __weak typeof(self) weakSelf = self;
//    if (self.controllerType == XKMeassageCollectControllerType) {
//    }else {
//    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.showEmptyView = NO;
//        if ([weakSelf.listTitle isEqualToString:@"全部分类"]) {
//            [weakSelf requestRefresh:YES needTip:YES typeCode:@""];
//        }else {
//            [weakSelf requestRefresh:YES needTip:YES typeCode:weakSelf.listTitle];
//        }
//    }];
//    
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        weakSelf.showEmptyView = NO;
//        if ([weakSelf.listTitle isEqualToString:@"全部分类"]) {
//            [weakSelf requestRefresh:YES needTip:YES typeCode:@""];
//        }else {
//            [weakSelf requestRefresh:YES needTip:YES typeCode:weakSelf.listTitle];
//        }
//    }];
//    self.tableView.mj_footer = footer;
//    [footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
//    self.tableView.mj_footer.hidden = YES;
//    }
//    // 空视图
//    XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
//    config.verticalOffset = -150;
//    config.viewAllowTap = NO;
//    config.backgroundColor = self.tableView.backgroundColor;
//    config.btnFont = XKRegularFont(14);
//    config.btnColor = XKMainTypeColor;
//    config.descriptionColor = HEX_RGB(0x777777);
//    config.descriptionFont = XKRegularFont(15);
//    config.spaceHeight = 5;
//    _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
//}
//
//- (void)initData {
//    self.isEdit = NO;
//    self.headerButtonTitleArray = @[@"女装",@"男装",@"鞋包"];
//}
//#pragma mark - Events
//
//- (void)updateEditLayout {
//    self.isEdit = 1;
//    [self.dropList removeFromSuperview];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.tableView.height -= 50 + kBottomSafeHeight;
//        self.bottomView.y -= 50 + kBottomSafeHeight;
//    }];
//    [self.tableView reloadData];
//}
//
//
//- (void)restoreLayout {
//    self.isEdit = 0;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.tableView.height += 50 + kBottomSafeHeight;
//        self.bottomView.y += 50 + kBottomSafeHeight;
//    }];
//    [self.tableView reloadData];
//}
//
//
//- (void)requestFirst {
//    if (_neverRequest) {
//        // 请求
//        self.showEmptyView = YES;
//        [self requestRefresh:YES needTip:YES typeCode:@""];
//        if (self.controllerType == XKBrowseControllerType) {
//            
//        }else{
//        [self.viewModel shopRequestClassifyComplete:^(NSString *error, NSArray *array) {
//            self.headerButtonTitleArray = array;
//            [self.dropList reloadData];
//        }];
//        }
//    }
//    _neverRequest = NO;
//}
//
//- (BOOL)checkIsEdit {
//    return self.isEdit;
//}
//
//- (void)dealSelected {
//    XKMineCollectBottomView *btmView = (XKMineCollectBottomView *)_bottomView;
//    [btmView setAllSelected:[self isAllSelected]];
//    [self.tableView reloadData];
//}
//
//- (BOOL)isAllSelected {
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"isSelected = NO"];
//    return [self.viewModel.dataArray filteredArrayUsingPredicate:pred].count == 0;
//}
//
//
//#pragma mark - Custom
//- (void)headerAction:(XKDropDownButton *)sender {
//    XKDropDownList *dropList = [[XKDropDownList alloc]initWithFrame:CGRectMake(10,50 * ScreenScale, 100, SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - 50) dataArray:self.headerButtonTitleArray onTheView:self.tableView];
//    [self.view addSubview:dropList];
//    self.dropList = dropList;
//    XKWeakSelf(ws);
//    sender.backgroundColor = RGBA(237,237,237,1);
//    dropList.selectBlock = ^(NSInteger row, NSString *title){
//        NSLog(@"%@",title);
//        ws.listTitle = title;
//        self.showEmptyView = NO;
//        [ws requestRefresh:YES needTip:NO typeCode:title];
//        [ws.tableView reloadData];
//    };
//    dropList.taptBlock = ^{
//        sender.backgroundColor = [UIColor whiteColor];
//    };
//}
//#pragma mark – Getters and Setters
//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10,10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - kIphoneXNavi(64) - 40  - 10 - kBottomSafeHeight) style:UITableViewStyleGrouped];
//        _tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_tableView registerClass:[XKMineCollectShopTableViewCell class] forCellReuseIdentifier:@"cell"];
//        if (@available(iOS 11.0, *)) {
//            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//        }
//    }
//    return _tableView;
//}
//- (XKWelfareOrderDetailBottomView *)bottomView {
//    if(!_bottomView) {
//        _bottomView = [XKWelfareOrderDetailBottomView WelfareOrderDetailBottomViewWithType:MineCollectBottomView];
//        _bottomView.frame = CGRectMake(0,SCREEN_HEIGHT - kIphoneXNavi(64) - 40, SCREEN_WIDTH, 50 + kBottomSafeHeight);
//        XKWeakSelf(ws);
//        _bottomView.choseBlock = ^(UIButton *sender) {
//            for (XKCollectShopModelDataItem *model in ws.viewModel.dataArray) {
//                model.isSelected = sender.isSelected;
//                [ws.tableView reloadData];
//            }
//        };
//        _bottomView.deleteBlock = ^(UIButton *sender) {
//            NSMutableArray *deleteArray = [NSMutableArray array];
//            for (XKCollectShopModelDataItem *model in ws.viewModel.dataArray) {
//                if (model.isSelected == YES) {
//                    [deleteArray addObject:model.ID];
//                }
//            }
//            if (deleteArray.count > 0) {
//                XKCommonAlertView *alertView = [[XKCommonAlertView alloc] initWithTitle:@"温馨提示" message:@"确定删除选中项吗？" leftButton:@"否" rightButton:@"是" leftBlock:nil rightBlock:^{
//                    [ws deleteCollect];
//                } textAlignment:NSTextAlignmentCenter];
//                [alertView show];
//            }else {
//                [XKAlertView showCommonAlertViewWithTitle:@"请先选择需要删除的选项"];
//            }
//            
//        };
//        _bottomView.shareBlock = ^(UIButton *sender) {
//            
//        };
//    }
//    return _bottomView;
//}
//
//- (XKCollectViewModel *)viewModel {
//    if (!_viewModel) {
//        if (self.controllerType == XKBrowseControllerType){
//            _viewModel = [[XKCollectViewModel alloc]initWithViewModelType:XKCollectShopViewModelType XKControllerType:XKBrowseControllerType];
//        }else{
//             _viewModel = [[XKCollectViewModel alloc]initWithViewModelType:XKCollectShopViewModelType XKControllerType:XKCollectControllerCollectType];
//        }
//    }
//    return _viewModel;
//}
//#pragma mark - UITableViewDataSource
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    XKMineCollectShopTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.xk_radius = 5;
//    cell.xk_openClip = YES;
//    XKWeakSelf(ws);
//    if(self.isEdit == 0) {
//        [cell restoreLayout];
//    } else {
//        [cell updateLayout];
//    }
//    if (self.controllerType == XKBrowseControllerType){
//        cell.shareButton.hidden = YES;
//        if (indexPath.row == self.viewModel.dataArray.count - 1){
//            cell.xk_clipType = XKCornerClipTypeBottomBoth;
//        }else if(indexPath.row == 0){
//            cell.xk_clipType = XKCornerClipTypeTopBoth;
//        }else{
//            cell.xk_clipType = XKCornerClipTypeNone;
//        }
//    }else{
//        cell.shareButton.hidden = NO;
//        if (indexPath.row == self.viewModel.dataArray.count - 1){
//            cell.xk_clipType = XKCornerClipTypeBottomBoth;
//        }else {
//            cell.xk_clipType = XKCornerClipTypeNone;
//        }
//    }
//    cell.tableView = tableView;
//    cell.indexPath = indexPath;
//    cell.deleteBlock = ^{
//        if (self.controllerType == XKMeassageCollectControllerType) {
//            
//        }else {
//            [ws oneDeleteCollect:indexPath];
//        }
//    };
//    
//    cell.scrollBlock = ^{
//        [[tableView visibleCells] enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (cell!=obj)[obj prepareForReuse];
//        }];
//    };
//    
//    cell.selectBlock = ^(UITableView *table, NSIndexPath *indexPath){
//        if (self.controllerType == XKMeassageCollectControllerType) {
//            
//        }else {
//            XKStoreRecommendViewController *vc = [XKStoreRecommendViewController new];
//            XKCollectShopModelDataItem *model = ws.viewModel.dataArray[indexPath.row];
//            vc.shopId = model.target.targetId;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//       
//    };
//    [cell prepareForReuse];
//    cell.controllerType = self.controllerType;
//    cell.model = self.viewModel.dataArray[indexPath.row];
//    cell.index = indexPath;
//    cell.block = ^(NSIndexPath *index, UIButton *sender) {
//        [ws dealSelected];
//    };
//    cell.sendChoseblock = ^(XKCollectShopModelDataItem *model) {
//        if (model.isSendSelected) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:XKCollectionSendAddCount object:nil userInfo:@{@"model":model}];
//        }else {
//            [[NSNotificationCenter defaultCenter]postNotificationName:XKCollectionSendreduceCount object:nil userInfo:@{@"model":model}];
//        }
//        [ws.tableView reloadData];
//    };
//    
//    cell.shareBlock = ^(XKCollectShopModelDataItem *model) {
//        XKShopShareView *view = [[XKShopShareView alloc]init];
//        view.model = model;
//        ws.model = model;
//        view.frame = CGRectMake(0, 0, 300 * ScreenScale, 280 * ScreenScale);
//        XKCustomShareView *shareView = [[XKCustomShareView alloc] init];
//        shareView.autoThirdShare = YES;
//        shareView.customView = view;
//        shareView.shareItems = [@[XKShareItemTypeCircleOfFriends,
//                                  XKShareItemTypeWechatFriends,
//                                  XKShareItemTypeQQ,
//                                  XKShareItemTypeSinaWeibo,
//                                  XKShareItemTypeMyFriends,
//                                  XKShareItemTypeCopyLink
//                                  ] mutableCopy];
//        shareView.delegate = self;
//        shareView.layoutType = XKCustomShareViewLayoutTypeCenter;
//        XKShareDataModel *shareData = [[XKShareDataModel alloc] init];
//        shareData.title = ws.model.target.name;
//        shareData.content = ws.model.target.name;
//        shareData.url = @"www.baidu.com";
//        shareData.img = self.model.target.showPics;
//        shareView.shareData = shareData;
//        [shareView showInView:[UIApplication sharedApplication].keyWindow.window];
//    };
//    return cell;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (([self.viewModel dataArray].count == 0 || [self.viewModel.dataArray isEqual:nil]) && self.showEmptyView) {
//        return 0;
//    }else{
//        return 1;
//    }
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.viewModel.dataArray.count;
//}
//
//#pragma mark - UITableViewDelegate
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 50)];
//    XKDropDownButton * button = [[XKDropDownButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
//    button.title = self.listTitle;
//    button.imageName = @"xk_icon_search_down";
//    if (self.isEdit) {button.enabled = NO;}else{button.enabled = YES;}
//    [button addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
//    headerView.backgroundColor = [UIColor whiteColor];
//    headerView.xk_radius = 8;
//    headerView.xk_openClip = YES;
//    headerView.xk_clipType = XKCornerClipTypeTopBoth;
//    [headerView addSubview:button];
//    return headerView;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return [[UIView alloc]init];
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return 115 * ScreenScale;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        if (self.controllerType == XKBrowseControllerType) {
//            return 0.00000001f;
//        }else{
//            return 50 * ScreenScale;
//        }
//    }else {
//        return 0.00000001f;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//        return 0.00000001f;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//}
//#pragma mark ----------------------------- 网络请求 ------------------------------
//- (void)requestRefresh:(BOOL)refresh needTip:(BOOL)needTip typeCode:(NSString *)typeCode  {
//    if (needTip) {
//        [XKHudView showLoadingTo:self.tableView animated:YES];
//    }
//    __weak typeof(self) weakSelf = self;
//    [self.viewModel requestIsRefresh:refresh typeCode:typeCode complete:^(NSString *error, NSArray *array) {
//        [XKHudView hideHUDForView:self.tableView animated:YES];
//        [self resetMJHeaderFooter:self.viewModel.refreshStatus tableView:self.tableView dataArray:self.viewModel.dataArray];
//        [self.tableView reloadData];
//        if (self.showEmptyView) {
//          if (error) {
//            if (self.viewModel.dataArray.count == 0) {
//                self.emptyView.config.viewAllowTap = YES;
//                [self.emptyView showWithImgName:@"xk_ic_mine_receipt_no" title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
//                    [weakSelf requestRefresh:YES needTip:YES typeCode:@""];
//                }];
//            }
//        } else {
//            if (self.viewModel.dataArray.count == 0) {
//                self.emptyView.config.viewAllowTap = NO;
//                [self.emptyView showWithImgName:@"xk_ic_mine_receipt_no" title:nil des:@"还没有收藏过哦" btnText:@"去收藏一波吧！！！" btnImg:nil tapClick:^{
//                    
//                }];
//            } else {
//                [self.emptyView hide];
//            }
//        }
//    }
//    }];
//}
//
//- (void)deleteCollect {
//    XKWeakSelf(ws);
//    NSString *url;
//    if (self.controllerType == XKCollectControllerCollectType) {
//        url = @"user/ua/xkFavoriteDelete/1.0";
//    }else {
//        url = @"user/ua/xkHistoryDelete/1.0";
//    }
//    NSMutableArray *deleteArray = [NSMutableArray array];
//    for (XKCollectShopModelDataItem *model in self.viewModel.dataArray) {
//        if (model.isSelected == YES) {
//            [deleteArray addObject:model.ID];
//        }
//    }
//    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20.0 parameters:@{@"ids":[deleteArray copy]} success:^(id responseObject) {
//        NSArray *array = [self.viewModel.dataArray copy];
//        for (XKCollectShopModelDataItem *model in array) {
//            if (model.isSelected == YES) {
//                [ws.viewModel.dataArray removeObject:model];
//            }
//        }
//        [ws.tableView reloadData];
//        [XKHudView showSuccessMessage:@"删除成功"];
//    } failure:^(XKHttpErrror *error) {
//        [XKHudView showErrorMessage:@"删除失败，请重试"];
//    }];
//}
//
//- (void)oneDeleteCollect:(NSIndexPath *)indexPath {
//    XKWeakSelf(ws);
//    NSString *url;
//    if (self.controllerType == XKCollectControllerCollectType) {
//        url = @"user/ua/xkFavoriteDelete/1.0";
//    }else {
//        url = @"user/ua/xkHistoryDelete/1.0";
//    }
//    XKCollectShopModelDataItem *model = self.viewModel.dataArray[indexPath.row];
//    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20.0 parameters:@{@"ids":@[model.ID]} success:^(id responseObject) {
//        [self.viewModel.dataArray removeObjectAtIndex:indexPath.row];
//        [ws.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [ws.tableView reloadData];
//        [XKHudView showSuccessMessage:@"删除成功"];
//    } failure:^(XKHttpErrror *error) {
//        [XKHudView showErrorMessage:@"删除失败，请重试"];
//    }];
//
//}
//
//#pragma mark XKCustomShareViewDelegate
//
///**
// XKShareItemTypeCircleOfFriends, // 朋友圈
// XKShareItemTypeWechatFriends,   // 微信好友
// XKShareItemTypeQQ,              // QQ
// XKShareItemTypeSinaWeibo,       // 微博
// XKShareItemTypeMyFriends,       // 我的朋友
// XKShareItemTypeCopyLink,        // 复制链接
// XKShareItemTypeSaveToLocal,     // 保存至本地
// */
//
//- (void)customShareView:(XKCustomShareView *) customShareView didClickedShareItem:(NSString *) shareItem {
//    if ([shareItem isEqualToString:XKShareItemTypeMyFriends]) {
//    }
//    else if ([shareItem isEqualToString:XKShareItemTypeCopyLink]) {
//    }
//}
//
//@end
//
