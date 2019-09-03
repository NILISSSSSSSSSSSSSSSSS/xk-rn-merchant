///*******************************************************************************
// # File        : XKMineCollectGoogsViewController.m
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
//#import "XKMineCollectGoogsViewController.h"
//#import "UIView+XKCornerRadius.h"
//#import "XKMineCollectGoodsSingularTableViewCell.h"
//#import "XKXKMineCollectGoodsDoubleCollectionViewCell.h"
//#import "XKWelfareOrderDetailBottomView.h"
//#import "XKDropDownList.h"
//#import "XKDropDownButton.h"
//#import "XKCollectViewModel.h"
//#import "XKGoodsCollectionReusableView.h"
//#import "XKCollectGoodsModel.h"
//#import "XKMineCollectBottomView.h"
//#import "XKGoodsHistoryReusableView.h"
//#import "XKGoodsShareView.h"
//#import "XKDeviceDataLibrery.h"
//#import "XKMallGoodsDetailViewController.h"
//
//static NSString * const headerID = @"headerID";
//static NSString * const historyHeaderID = @"historyHeaderID";
//static NSString * const singleCellID = @"singleCellID";
//static NSString * const doubleCellID = @"doubleCellID";
//static NSString * const footerID = @"footerID";
//
//@interface XKMineCollectGoogsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XKCustomShareViewDelegate>{
//    BOOL _neverRequest;
//}
//@property (nonatomic, strong)UICollectionView *collectionView;
//@property (nonatomic, strong)XKWelfareOrderDetailBottomView *bottomView;
//@property (nonatomic, strong)NSArray        *headerButtonTitleArray;
//@property (nonatomic, strong)XKDropDownList *dropList;
///**UICollectionViewFlowLayout*/
//@property(nonatomic, strong) UICollectionViewFlowLayout *layout;
///*headerView*/
//@property(nonatomic, strong) XKGoodsCollectionReusableView *headerView;
///**viewModel*/
//@property(nonatomic, strong) XKCollectViewModel *viewModel;
//@property(nonatomic, strong) XKEmptyPlaceView *emptyView;
//@property(nonatomic, strong) XKCollectGoodsDataItem *model;
///**是否显示占位视图*/
//@property(nonatomic, assign) BOOL showEmptyView;
///**list名字*/
//@property(nonatomic, copy) NSString *listTitle;
//@end
//
//@implementation XKMineCollectGoogsViewController
//
//#pragma mark ----------------------------- 生命周期 ------------------------------
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self hideNavigation];
//    // 初始化默认数据
//    _neverRequest = YES;
//    [self createDefaultData];
//    // 初始化界面
//    [self createUI];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//}
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    
//}
//
//- (void)dealloc {
//    NSLog(@"=====%@被销毁了=====", [self class]);
//}
//
//#pragma mark - 初始化默认数据
//- (void)createDefaultData {
//    self.isEdit = NO;
//    self.listTitle = @"";
//    self.headerButtonTitleArray = @[@"女装",@"男装",@"鞋包",@"美妆"];
//}
//
//- (void)requestFirst {
//    if (_neverRequest) {
//        // 请求
//        [self requestRefresh:YES needTip:YES typeCode:@""];
//        self.showEmptyView = YES;
//        if (self.controllerType == XKBrowseControllerType) {
//            
//        }else{
//        [self.viewModel goodsRequestClassifyComplete:^(NSString *error, NSArray *array) {
//            self.headerButtonTitleArray = array;
//            [self.dropList reloadData];
//        }];
//        }
//    }
//    _neverRequest = NO;
//}
//
//- (void)headerRightButtonAction:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    self.layoutType =  (self.layoutType == XKCollectGoodsListLayoutSingle) ? XKCollectGoodsListLayoutDouble : XKCollectGoodsListLayoutSingle;
//    [self updateLayout];
//}
//#pragma mark - 初始化界面
//- (void)createUI {
//    [self.view addSubview:self.collectionView];
//    [self.view addSubview:self.bottomView];
//    __weak typeof(self) weakSelf = self;
//    if (self.controllerType == XKMeassageCollectControllerType) {
//        
//    }else{
//    self.collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.showEmptyView = NO;
//        [weakSelf requestRefresh:YES needTip:NO typeCode:weakSelf.listTitle];
//    }];
//    
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        weakSelf.showEmptyView = NO;
//        [weakSelf requestRefresh:NO needTip:NO typeCode:weakSelf.listTitle];
//    }];
//    self.collectionView.mj_footer = footer;
//    [footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
//    self.collectionView.mj_footer.hidden = YES;
//    }
//    // 空视图
//    XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
//    config.verticalOffset = -150;
//    config.viewAllowTap = NO;
//    config.backgroundColor = self.collectionView.backgroundColor;
//    config.btnFont = XKRegularFont(14);
//    config.btnColor = XKMainTypeColor;
//    config.descriptionColor = HEX_RGB(0x777777);
//    config.descriptionFont = XKRegularFont(15);
//    config.spaceHeight = 5;
//    _emptyView = [XKEmptyPlaceView configScrollView:self.collectionView config:config];
//}
//- (void)updateLayout {
//    [self.collectionView reloadData];
//}
//
//- (UIButton *)setSectionHeaderRightButton {
//    UIButton *button = [[UIButton alloc]init];
//    button.backgroundColor = XKMainTypeColor;
//    [button setImage:[UIImage imageNamed:@"xk_btn_secretFriend_groupManage"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"xk_btn_subscription_move"] forState:UIControlStateSelected];
//    [button addTarget:self action:@selector(headerRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}
//
//#pragma mark - CollectMethodProtocol方法
//
//- (void)updateEditLayout {
//    self.isEdit = 1;
//    [self.dropList removeFromSuperview];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.collectionView.height -= 50 + kBottomSafeHeight;
//        self.bottomView.y -= 50 + kBottomSafeHeight;
//        NSLog(@"%f", self.bottomView.y);
//    }];
//    [self.collectionView reloadData];
//}
//
//
//- (void)restoreLayout {
//    self.isEdit = 0;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.collectionView.height += 50 + kBottomSafeHeight;
//        self.bottomView.y += 50 + kBottomSafeHeight;
//        NSLog(@"%f", self.bottomView.y);
//    }];
//    [self.collectionView reloadData];
//}
//
//- (BOOL)checkIsEdit {
//    return self.isEdit;
//}
//- (void)dealSelected {
//    XKMineCollectBottomView *btmView = (XKMineCollectBottomView *)_bottomView;
//    [btmView setAllSelected:[self isAllSelected]];
//    [self.collectionView reloadData];
//}
//
//- (BOOL)isAllSelected {
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"isSelected = NO"];
//    return [self.viewModel.dataArray filteredArrayUsingPredicate:pred].count == 0;
//}
//
//- (void)shareWithModel:(XKCollectGoodsDataItem *)model {
//    XKWeakSelf(ws);
//    XKGoodsShareView *view = [[XKGoodsShareView alloc]init];
//    view.model = model;
//    self.model = model;
//    view.frame = CGRectMake(0, 0, 300 * ScreenScale, 280 * ScreenScale);
//    XKCustomShareView *shareView = [[XKCustomShareView alloc] init];
//    shareView.autoThirdShare = YES;
//    shareView.customView = view;
//    shareView.shareItems = [@[XKShareItemTypeCircleOfFriends,
//                              XKShareItemTypeWechatFriends,
//                              XKShareItemTypeQQ,
//                              XKShareItemTypeSinaWeibo,
//                              XKShareItemTypeMyFriends,
//                              XKShareItemTypeCopyLink
//                              ] mutableCopy];
//    shareView.delegate = self;
//    shareView.layoutType = XKCustomShareViewLayoutTypeCenter;
//    XKShareDataModel *shareData = [[XKShareDataModel alloc] init];
//    shareData.title = ws.model.target.name;
//    shareData.content = ws.model.target.name;
//    NSString *path = [NSString stringWithFormat:@"share/#/goodsdetail?id=%@&client=xk&securityCode=undefined",ws.model.target.targetId];
//    NSString *server = [BaseWebUrl stringByAppendingString:path];
//    shareData.url = server;
//    shareData.img = self.model.target.showPics;
//    shareView.shareData = shareData;
//    [shareView showInView:[UIApplication sharedApplication].keyWindow.window];
//}
//#pragma mark - Custom
//- (void)headerAction:(XKDropDownButton *)sender {
//    XKDropDownList *dropList = [[XKDropDownList alloc]initWithFrame:CGRectMake(10,50, 100, SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - 50) dataArray:self.headerButtonTitleArray onTheView:self.collectionView];
//    [self.view addSubview:dropList];
//    self.dropList = dropList;
//    XKWeakSelf(ws);
//    sender.backgroundColor = RGBA(237,237,237,1);
//    dropList.selectBlock = ^(NSInteger row, NSString *title){
//        NSLog(@"%@",title);
//        self.listTitle = title;
//        ws.headerView.dropDownButton.title = title;
//        [ws requestRefresh:YES needTip:NO typeCode:title];
//        self.showEmptyView = NO;
//        [ws.collectionView reloadData];
//    };
//    dropList.taptBlock = ^{
//        sender.backgroundColor = [UIColor whiteColor];
//    };
//}
//#pragma mark collectionview代理 数据源
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    if (([self.viewModel dataArray].count == 0 || [self.viewModel.dataArray isEqual:nil]) && self.showEmptyView) {
//        return 0;
//    }else{
//        return 1;
//    }
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.viewModel.dataArray.count;
//}
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//        UIView *contentView;
//        NSString *identifier;
//        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//            if (self.controllerType == XKBrowseControllerType) {
//                identifier = historyHeaderID;
//                XKGoodsHistoryReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
//                view.autotrophyButtonBlock = ^(UIButton *button) {
//                    [self requestRefresh:YES needTip:NO typeCode:@"goods"];
//                };
//                view.businessButtonBlock = ^(UIButton *button) {
//                    [self requestRefresh:YES needTip:NO typeCode:@"shop"];
//                };
//                view.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, 50);
//                view.backgroundColor = [UIColor whiteColor];
//                view.xk_radius = 8;
//                view.xk_openClip = YES;
//                view.xk_clipType = XKCornerClipTypeTopBoth;
//                return view;
//            }else {
//                identifier = headerID;
//                XKGoodsCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
//                self.headerView = view;
//                XKWeakSelf(ws);
//                if (self.controllerType == XKMeassageCollectControllerType) {
//                    view.layoutButton.hidden = YES;
//                }
//                if (self.isEdit) {view.dropDownButton.enabled = NO;}else{view.dropDownButton.enabled = YES;}
//                view.dropDownButtonBlock = ^(XKDropDownButton *dropDownButton){
//                    [ws headerAction:dropDownButton];
//                };
//                view.layoutChangeBlock= ^(UIButton *button) {
//                    [ws headerRightButtonAction:button];
//                };
//                view.autotrophyButtonBlock = ^(UIButton *button) {
//                    [self requestRefresh:YES needTip:NO typeCode:@"goods"];
//                };
//                view.businessButtonBlock = ^(UIButton *button) {
//                    [self requestRefresh:YES needTip:NO typeCode:@"shop"];
//                };
//                [view setGoodsButtonHidden:YES];
//                view.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, 50);
//                view.backgroundColor = [UIColor whiteColor];
//                view.xk_radius = 8;
//                view.xk_openClip = YES;
//                view.xk_clipType = XKCornerClipTypeTopBoth;
//                return view;
//            }
//        } else {
//            identifier = footerID;
//            contentView = self.tableFooterView;
//            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
//            [view addSubview:contentView];
//            return view;
//        }
//}
//
//// 设置section头视图的参考大小，与tableheaderview类似
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
//referenceSizeForHeaderInSection:(NSInteger)section {
//    if (self.controllerType == XKBrowseControllerType) {
//        return CGSizeZero;
//    }else{
//        return CGSizeMake(SCREEN_WIDTH - 20 , 50);
//    }
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    if(self.layoutType == XKCollectGoodsListLayoutSingle) {
//        return CGSizeMake(SCREEN_WIDTH - 20 , 0);
//    } else {
//        return CGSizeZero;
//    }
//    
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    XKWeakSelf(ws);
//    if(self.layoutType == XKCollectGoodsListLayoutSingle) {
//        XKMineCollectGoodsSingularTableViewCell *singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:singleCellID forIndexPath:indexPath];
//        singleCell.backgroundColor = [UIColor whiteColor];
//        singleCell.xk_openClip = YES;
//        singleCell.xk_radius = 5;
//        if(self.isEdit == 0) {
//            [singleCell restoreLayout];
//        } else {
//            [singleCell updateLayout];
//        }
//        if (self.controllerType == XKBrowseControllerType){
//            singleCell.shareButton.hidden = YES;
//            if (indexPath.item == self.viewModel.dataArray.count - 1){
//                singleCell.xk_clipType = XKCornerClipTypeBottomBoth;
//            }else if(indexPath.item == 0){
//                singleCell.xk_clipType = XKCornerClipTypeTopBoth;
//            }else{
//                singleCell.xk_clipType = XKCornerClipTypeNone;
//            }
//        }else{
//            singleCell.shareButton.hidden = NO;
//            if (indexPath.item == self.viewModel.dataArray.count - 1) {
//                singleCell.xk_clipType = XKCornerClipTypeBottomBoth;
//            }else{
//                singleCell.xk_clipType = XKCornerClipTypeNone;
//            }
//        }
//        //滑动手势
//        singleCell.collectionView = collectionView;
//        singleCell.indexPath = indexPath;
//        singleCell.deleteBlock = ^{
//            if (self.controllerType == XKMeassageCollectControllerType) {
//                
//            }else {
//                [ws oneDeleteCollect:indexPath];
//            }
//        };
//        
//        singleCell.scrollBlock = ^{
//            [[collectionView visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (singleCell != obj)[obj prepareForReuse];
//            }];
//        };
//        
//        singleCell.selectBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath){
//            if (self.controllerType == XKMeassageCollectControllerType) {
//                
//            }else {
//                [ws gotoDeatilWithItem:ws.viewModel.dataArray[indexPath.item]];
//            }
//        };
//        [singleCell prepareForReuse];
//        singleCell.controllerType = self.controllerType;
//        singleCell.model = self.viewModel.dataArray[indexPath.row];
//        singleCell.block = ^{
//            [ws dealSelected];
//        };
//        singleCell.shareBlock = ^(XKCollectGoodsDataItem *model) {
//            [ws shareWithModel:model];
//        };
//        singleCell.sendChoseblock = ^(XKCollectGoodsDataItem *model) {
//            if (model.isSendSelected) {
//                [[NSNotificationCenter defaultCenter]postNotificationName:XKCollectionSendAddCount object:nil userInfo:@{@"model":model}];
//            }else {
//                [[NSNotificationCenter defaultCenter]postNotificationName:XKCollectionSendreduceCount object:nil userInfo:@{@"model":model}];
//            }
//            [ws.collectionView reloadData];
//        };
//        return singleCell;
//    } else {
//        XKXKMineCollectGoodsDoubleCollectionViewCell *doubleCell = [collectionView dequeueReusableCellWithReuseIdentifier:doubleCellID forIndexPath:indexPath];
//        doubleCell.xk_openClip = YES;
//        doubleCell.xk_radius = 5;
//        doubleCell.xk_clipType = XKCornerClipTypeAllCorners;
//        doubleCell.backgroundColor = [UIColor whiteColor];
//        if(self.isEdit == 0) {
//            [doubleCell restoreLayout];
//        } else {
//            [doubleCell updateLayout];
//        }
//        if (self.controllerType == XKCollectControllerCollectType) {
//            doubleCell.shareButton.hidden = NO;
//        }else if (self.controllerType == XKBrowseControllerType){
//            doubleCell.shareButton.hidden = YES;
//        }
//        doubleCell.model = self.viewModel.dataArray[indexPath.row];
//        doubleCell.block = ^{
//            [ws dealSelected];
//        };
//        
//        doubleCell.shareBlock = ^(XKCollectGoodsDataItem *model) {
//            [ws shareWithModel:model];
//        };
//        return doubleCell;
//    }
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if(self.layoutType == XKCollectGoodsListLayoutSingle) {
//        return CGSizeMake(SCREEN_WIDTH - 20, 129 * ScreenScale);
//    } else {
//        return  CGSizeMake((SCREEN_WIDTH - 30)/2, 288 * ScreenScale);
//    }
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    if(self.layoutType == XKCollectGoodsListLayoutSingle) {
//        return 0;
//    } else {
//        return  10;
//    }
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    if(self.layoutType == XKCollectGoodsListLayoutSingle) {
//        return 0;
//    } else {
//        return  10;
//    }
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
//    [self gotoDeatilWithItem:self.viewModel.dataArray[indexPath.item]];
//}
//- (void)gotoDeatilWithItem:(XKCollectGoodsDataItem *)item {
//    
//    XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
//    detail.goodsId = item.target.targetId;
//    [self.navigationController pushViewController:detail animated:YES];
//}
//#pragma mark 懒加载
//- (UICollectionView *)collectionView {
//    if(!_collectionView) {
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        self.layout = layout;
//        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,10, SCREEN_WIDTH , SCREEN_HEIGHT - kIphoneXNavi(64) - 50 - kBottomSafeHeight) collectionViewLayout:layout];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.backgroundColor = [UIColor clearColor];
//        [_collectionView registerClass:[XKGoodsCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
//        [_collectionView registerClass:[XKGoodsHistoryReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:historyHeaderID];
//
//        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerID];
//        [_collectionView registerClass:[XKMineCollectGoodsSingularTableViewCell class] forCellWithReuseIdentifier:singleCellID];
//        [_collectionView registerClass:[XKXKMineCollectGoodsDoubleCollectionViewCell class] forCellWithReuseIdentifier:doubleCellID];
//    }
//    return _collectionView;
//}
//
//- (XKWelfareOrderDetailBottomView *)bottomView {
//    if(!_bottomView) {
//        _bottomView = [XKWelfareOrderDetailBottomView WelfareOrderDetailBottomViewWithType:MineCollectBottomView];
//        _bottomView.frame = CGRectMake(0,SCREEN_HEIGHT - kIphoneXNavi(64) - 40, SCREEN_WIDTH, 50 + kBottomSafeHeight);
//        XKWeakSelf(ws)
//        _bottomView.choseBlock = ^(UIButton *sender) {
//            for (XKCollectGoodsDataItem *model in ws.viewModel.dataArray) {
//                model.isSelected = sender.isSelected;
//                [ws.collectionView reloadData];
//            }
//        };
//        
//        _bottomView.deleteBlock = ^(UIButton *sender) {
//            NSMutableArray *deleteArray = [NSMutableArray array];
//            for (XKCollectGoodsDataItem *model in ws.viewModel.dataArray) {
//                if (model.isSelected == YES) {
//                    [deleteArray addObject:model.ID];
//                }
//            }
//            if (deleteArray.count > 0) {
//            XKCommonAlertView *alertView = [[XKCommonAlertView alloc] initWithTitle:@"温馨提示" message:@"确定删除选中项吗？" leftButton:@"否" rightButton:@"是" leftBlock:nil rightBlock:^{
//                [ws deleteCollect];
//            } textAlignment:NSTextAlignmentCenter];
//            [alertView show];
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
//       if (self.controllerType == XKBrowseControllerType){
//            _viewModel = [[XKCollectViewModel alloc]initWithViewModelType:XKCollectGoodsViewModelType XKControllerType:XKBrowseControllerType];
//        }else {
//            _viewModel = [[XKCollectViewModel alloc]initWithViewModelType:XKCollectGoodsViewModelType XKControllerType:XKCollectControllerCollectType];
//        }
//    }
//    return _viewModel;
//}
//
//#pragma mark ----------------------------- 网络请求 ------------------------------
//- (void)requestRefresh:(BOOL)refresh needTip:(BOOL)needTip typeCode:(NSString *)typeCode {
//    if (needTip) {
//        [XKHudView showLoadingTo:self.collectionView animated:YES];
//    }
//    __weak typeof(self) weakSelf = self;
//    [self.viewModel requestIsRefresh:refresh typeCode:typeCode complete:^(NSString *error, NSArray *array) {
//        [XKHudView hideHUDForView:self.collectionView animated:YES];
//        [self resetMJHeaderFooter:self.viewModel.refreshStatus tableView:self.collectionView dataArray:self.viewModel.dataArray];
//        [self.collectionView reloadData];
//        if (self.showEmptyView) {
//         if (error) {
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
//    for (XKCollectGoodsDataItem *model in self.viewModel.dataArray) {
//        if (model.isSelected == YES) {
//            [deleteArray addObject:model.ID];
//        }
//    }
//    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20.0 parameters:@{@"ids":[deleteArray copy]} success:^(id responseObject) {
//        NSArray *array = [self.viewModel.dataArray copy];
//        for (XKCollectGoodsDataItem *model in array) {
//            if (model.isSelected == YES) {
//                [ws.viewModel.dataArray removeObject:model];
//            }
//        }
//        [ws.collectionView reloadData];
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
//    XKCollectGoodsDataItem *model = self.viewModel.dataArray[indexPath.row];
//    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20.0 parameters:@{@"ids":@[model.ID]} success:^(id responseObject) {
//        [self.viewModel.dataArray removeObjectAtIndex:indexPath.row];
//        [ws.collectionView deselectItemAtIndexPath:indexPath animated:UITableViewRowAnimationFade];
//        [ws.collectionView reloadData];
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
//        NSString *path = [NSString stringWithFormat:@"share/#/goodsdetail?id=%@&client=xk&securityCode=undefined",self.model.target.targetId];
//        NSString *server = [BaseWebUrl stringByAppendingString:path];
//        [UIPasteboard generalPasteboard].string = server;
//    }
//}
//
//@end
