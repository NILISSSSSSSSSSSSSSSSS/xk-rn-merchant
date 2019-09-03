///*******************************************************************************
// # File        : XKMineCollectVideoViewController.m
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
//#import "XKMineCollectVideoViewController.h"
//#import "XKXKMineCollectVideoCollectionViewCell.h"
//#import "XKWelfareOrderDetailBottomView.h"
//#import "XKMineCollectBottomView.h"
//#import "XKVideoShareView.h"
//#import "XKVideoDisplayModel.h"
//#import "XKVideoDisplayMediator.h"
//
//@interface XKMineCollectVideoViewController ()
//<UICollectionViewDelegate,
//UICollectionViewDataSource,
//UICollectionViewDelegateFlowLayout,
//XKCustomShareViewDelegate>
//
//{
//    BOOL _neverRequest;
//}
//@property (nonatomic, strong) UICollectionView               *collectionView;
//
//@property (nonatomic, strong) XKWelfareOrderDetailBottomView *bottomView;
//
//@property (nonatomic, strong) XKEmptyPlaceView               *emptyView;
//
//@property (nonatomic, strong) XKVideoDisplayVideoListItemModel     *model;
//
//@property (nonatomic, strong) NSMutableArray                 *dataArray;
//
//@end
//
//@implementation XKMineCollectVideoViewController
//
//#pragma mark ----------------------------- 生命周期 ------------------------------
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self hideNavigation];
//    // 初始化默认数据
//    _neverRequest = YES;
//    if (self.controllerType == XKCollectControllerCollectType) {
//        [self createDefaultData];
//    }else if (self.controllerType == XKBrowseControllerType){
//        [self createBrowseDefaultData];
//    }
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
//    
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    
//}
//
//- (void)dealloc {
//    NSLog(@"=====%@被销毁了=====", [self class]);
//}
//#pragma mark - 初始化默认数据
//- (void)createBrowseDefaultData {
//    self.isEdit = NO;
//    
//}
//- (void)createDefaultData {
//    self.isEdit = NO;
//
//}
//
//#pragma mark - 初始化界面
//- (void)createUI {
//    [self.view addSubview:self.collectionView];
//    [self.view addSubview:self.bottomView];
//    __weak typeof(self) weakSelf = self;
//    if (self.controllerType == XKMeassageCollectControllerType) {
//        
//    }else {
//    self.collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf requestRefresh:YES needTip:NO];
//    }];
//    
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf requestRefresh:NO needTip:NO];
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
//- (void)updateEditLayout {
//    self.isEdit = 1;
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        self.collectionView.height -= 50 + kBottomSafeHeight;
//        self.bottomView.y -= 50 + kBottomSafeHeight;
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
//    }];
//    [self.collectionView reloadData];
//}
//
//- (void)requestFirst {
//    if (_neverRequest) {
//        // 请求
//        [self requestRefresh:YES needTip:YES];
//    }
//    _neverRequest = NO;
//}
//- (BOOL)checkIsEdit {
//    return self.isEdit;
//}
//
//
//- (void)dealSelected {
//    XKMineCollectBottomView *btmView = (XKMineCollectBottomView *)_bottomView;
//    [btmView setAllSelected:[self isAllSelected]];
//    [self.collectionView reloadData];
//}
//
//- (BOOL)isAllSelected {
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"isSelected = NO"];
//    return [self.dataArray filteredArrayUsingPredicate:pred].count == 0;
//}
//#pragma mark collectionview代理 数据源
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.dataArray.count;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
//referenceSizeForHeaderInSection:(NSInteger)section {
//    
//    return CGSizeZero;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return CGSizeZero;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    XKWeakSelf(ws);
//        XKXKMineCollectVideoCollectionViewCell *doubleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListDoubleCell" forIndexPath:indexPath];
//        doubleCell.backgroundColor = [UIColor whiteColor];
//    if (self.controllerType == XKBrowseControllerType){
//        if(self.isEdit == 0) {
//            [doubleCell restoreLayout];
//            doubleCell.shareButton.hidden = YES;
//            
//        } else {
//            [doubleCell updateLayout];
//            doubleCell.shareButton.hidden = NO;
//        }
//    }else{
//        doubleCell.shareButton.hidden = NO;
//        if(self.isEdit == 0) {
//            [doubleCell restoreLayout];
//        } else {
//            [doubleCell updateLayout];
//        }
//    }
//    doubleCell.controllerType = self.controllerType;
//    doubleCell.model = self.dataArray[indexPath.item];
//    doubleCell.block = ^{
//        [ws dealSelected];
//    };
//    doubleCell.sendChoseblock = ^(XKVideoDisplayVideoListItemModel *model) {
//        if (model.isSendSelected) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:XKCollectionSendAddCount object:nil userInfo:@{@"model":model}];
//        }else {
//            [[NSNotificationCenter defaultCenter]postNotificationName:XKCollectionSendreduceCount object:nil userInfo:@{@"model":model}];
//        }
//        [ws.collectionView reloadData];
//    };
//    doubleCell.shareBlock = ^(XKVideoDisplayVideoListItemModel *model) {
//        XKVideoShareView *view = [[XKVideoShareView alloc]init];
//        view.model = model;
//        ws.model = model;
//        view.frame = CGRectMake(0, 0, 320, 280);
//        
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
//        shareData.title = self.model.video.describe;
//        shareData.content = self.model.user.user_name;
//        shareData.url = self.model.video.wmImg_video;
//        shareData.img = self.model.video.first_cover;
//        shareView.shareData = shareData;
//        [shareView showInView:[UIApplication sharedApplication].keyWindow.window];
//    
//    };
//        return doubleCell;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//        return  CGSizeMake(SCREEN_WIDTH/2, 288 * ScreenScale);
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
//    if (self.controllerType == XKMeassageCollectControllerType) {
//        
//    }else {
//        XKXKMineCollectVideoCollectionViewCell *cell = (XKXKMineCollectVideoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        [XKVideoDisplayMediator displaySingleVideoWithViewController:self videoListItemModel:cell.model];
//    }
//}
//
//#pragma mark 懒加载
//- (NSMutableArray *)dataArray {
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray array];
//    }
//    return _dataArray;
//}
//- (UICollectionView *)collectionView {
//    if(!_collectionView) {
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight) collectionViewLayout:layout];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.backgroundColor = [UIColor whiteColor];
//        [_collectionView registerClass:[XKXKMineCollectVideoCollectionViewCell class] forCellWithReuseIdentifier:@"XKWelfareListDoubleCell"];
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
//            for (XKVideoDisplayVideoListItemModel *model in ws.dataArray) {
//                model.isSelected = sender.isSelected;
//                [ws.collectionView reloadData];
//            }
//        };
//        _bottomView.deleteBlock = ^(UIButton *sender) {
//            NSMutableArray *deleteArray = [NSMutableArray array];
//            for (XKVideoDisplayVideoListItemModel *model in ws.dataArray) {
//                if (model.isSelected == YES) {
//                    [deleteArray addObject:[NSString stringWithFormat:@"%ld",(long)model.video.video_id]];
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
//#pragma mark ----------------------------- 网络请求 ------------------------------
//- (void)requestIsRefresh:(BOOL)isRefresh complete:(void(^)(NSArray *array))complete {
//    __weak typeof(self) weakSelf = self;
//    [XKZBHTTPClient postRequestWithURLString:@"index/Square/a001/videoColle/1.0" timeoutInterval:20.0 parameters:@{@"page":@0,@"limit":@400,@"searchWord":@""} success:^(id  _Nonnull responseObject) {
//        if (responseObject) {
//            XKVideoDisplayModel * model = [XKVideoDisplayModel yy_modelWithJSON:responseObject];
//            for (XKVideoDisplayVideoListItemModel *vmodel in model.body.video_list) {
//                NSLog(@"%@",vmodel.user.user_name);
//                NSLog(@"%@",vmodel.user.user_img);
//                NSLog(@"%ld",(long)vmodel.video.praise_num);
//                NSLog(@"%@",vmodel.video.describe);
//            }
//            self.dataArray = model.body.video_list.mutableCopy;
//            [self.collectionView reloadData];
//            [self.collectionView.mj_header endRefreshing];
//            complete(model.body.video_list);
//        }
//    } failure:^(XKHttpErrror * _Nonnull error) {
//        if (self.dataArray.count == 0) {
//            self.emptyView.config.viewAllowTap = YES;
//            [self.emptyView showWithImgName:@"xk_ic_mine_receipt_no" title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
//                [weakSelf requestRefresh:YES needTip:YES];
//            }];
//        }
//        [XKHudView hideHUDForView:self.collectionView animated:YES];
//    }];
//}
//
//- (void)requestRefresh:(BOOL)refresh needTip:(BOOL)needTip {
//    if (needTip) {
//        [XKHudView showLoadingTo:self.collectionView animated:YES];
//    }
//    [self requestIsRefresh:refresh complete:^(NSArray *array) {
//        [XKHudView hideHUDForView:self.collectionView animated:YES];
//        [self.collectionView reloadData];
//        if (self.dataArray.count == 0) {
//            self.emptyView.config.viewAllowTap = NO;
//            [self.emptyView showWithImgName:@"xk_ic_mine_receipt_no" title:nil des:@"还没有收藏过哦" btnText:@"去收藏一波吧！！！" btnImg:nil tapClick:^{
//            }];
//        } else {
//            [XKHudView hideHUDForView:self.collectionView animated:YES];
//            [self.emptyView hide];
//        }
//    }];
//}
//
//
//- (void)deleteCollect {
//    XKWeakSelf(ws);
//    NSString *url;
//    if (self.controllerType == XKCollectControllerCollectType) {
//        url = @"user/ua/xkFavoriteVideoDelete/1.0";
//    }else {
//        url = @"user/ua/xkHistoryDelete/1.0";
//    }
//    NSMutableArray *deleteArray = [NSMutableArray array];
//    for (XKVideoDisplayVideoListItemModel *model in self.dataArray) {
//        if (model.isSelected == YES) {
//            [deleteArray addObject:[NSString stringWithFormat:@"%ld",(long)model.video.video_id]];
//        }
//    }
//    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20.0 parameters:@{@"targetIds":[deleteArray copy]} success:^(id responseObject) {
//        NSArray *array = [self.dataArray copy];
//        for (XKVideoDisplayVideoListItemModel *model in array) {
//            if (model.isSelected == YES) {
//                [ws.dataArray removeObject:model];
//            }
//        }
//        [ws.collectionView reloadData];
//        [XKHudView showSuccessMessage:@"删除成功"];
//    } failure:^(XKHttpErrror *error) {
//        [XKHudView showErrorMessage:@"删除失败，请重试"];
//    }];
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
