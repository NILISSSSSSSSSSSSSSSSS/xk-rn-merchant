//
//  XKStoreRecommendViewController.m
//  XKSquare
//
//  Created by hupan on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreRecommendViewController.h"
#import "XKStoreReserveChooseSpecificationView.h"
#import "XKCommonSheetView.h"
#import "BaseViewFactory.h"
#import "XKBaiduLocation.h"
#import "XKBDMapViewController.h"
#import "XKTradingAreaShopCarManager.h"
#import "XKStoreRecommendBaseAdapter.h"
#import "XKTradingAreaCommonAdapter.h"

#import "XKAutoScrollImageItem.h"
#import "XKSquareTradingAreaTool.h"
#import "XKStoreEstimateDetailListViewController.h"
#import "XKTradingAreaOrderReserveViewController.h"
#import "XKStoreEditMenuViewController.h"
#import "XKTradingAreaGoodsDetailViewController.h"
#import "XKTradingAreaSotreActivityMainViewController.h"
#import "XKTradingAreaGoodsInfoModel.h"

@interface XKStoreRecommendViewController ()<XKStoreRecommendBaseAdapterDelegate,XKBaiduLocationDelegate>

@property (nonatomic, strong) UITableView                  *tableView;
@property (nonatomic, strong) XKTradingAreaCommonAdapter   *adapter;

@property (nonatomic, strong) UIButton                     *collectBtn;


@property (nonatomic, strong) XKStoreReserveChooseSpecificationView *guigeChooseView;
@property (nonatomic, strong) XKCommonSheetView                     *chooseGuigeSheetView;


@end

@implementation XKStoreRecommendViewController {
    double   _laititude;
    double   _longtitude;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    
    [self configNavigationBar];
    
    _laititude = [[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].latitude;
    _longtitude = [[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].longitude;
    if (!_laititude && !_longtitude) {
        [self configBaiduMapLocation];
    }
    [self configTableView];
    [self requestAllData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc {
    NSLog(@"%@_dealloc", [self class]);
    [[XKTradingAreaShopCarManager shareManager] clearnShopCarAllDataWithShopId:self.shopId];
}

#pragma mark - Private Metheods

- (void)configBaiduMapLocation {
    [XKBaiduLocation shareManager].delegate = self;
    [[XKBaiduLocation shareManager] startBaiduSingleLocationService];
}

- (void)configNavigationBar {
    
    [self setNavTitle:@"商家详情" WithColor:[UIColor whiteColor]];
    [self setNaviCustomView:self.collectBtn withframe:CGRectMake(SCREEN_WIDTH - 85, 0, 40, 40)];
    
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareBtn addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:[UIImage imageNamed:@"xk_btn_TradingArea_share_white"] forState:UIControlStateNormal];
    [self setNaviCustomView:shareBtn withframe:CGRectMake(SCREEN_WIDTH - 45, 0, 40, 40)];
}

- (void)configTableView {
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height, 0, 0, 0));
    }];
}


#pragma mark - request

- (void)requestAllData {
    
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [self.adapter requsetTradingAreaShopFavoriteStatus:^(NSInteger code) {
        if (code == 1) {
            self.collectBtn.selected = YES;
        } else {
            self.collectBtn.selected = NO;
        }
    }];
    [self.adapter requestTradingAreaShopInfo];
    
    [self.adapter requestTradingAreaShopCommentLabels];

    [self.adapter requestTeadingAreaShopCommentGrade];
    
    [self.adapter requsetTradingAreaShopCommentList];
    
    dispatch_group_notify(self.adapter.group, dispatch_get_global_queue(0,0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [XKHudView hideHUDForView:self.tableView];
            [self.tableView stopRefreshing];
            [self.tableView reloadData];
        });
    });
}


#pragma mark - Events

- (void)collectButtonClicked:(UIButton *)sender {
    
    if (sender.selected == YES) {//取消
        [self.adapter tradingAreaCancelShopFavorite:^(NSInteger code) {
            self.collectBtn.selected = NO;
        }];
    } else {//收藏
        [self.adapter tradingAreaShopFavorite:^(NSInteger code) {
            self.collectBtn.selected = YES;
        }];
    }
}

- (void)shareButtonClicked:(UIButton *)sender {
    [self.adapter shareButtonClicked];
}


#pragma mark - Custom Blocks

/*********服务预定相关***********/
- (void)guigeChooseViewCloseButtonClicekd {
    [self.chooseGuigeSheetView dismiss];
}

- (void)guigeChooseViewNextButtonCliceked:(GoodsSkuVOListItem *)skuItem time:(NSString *)time viewType:(SpecificationViewType)viewType {
    //生成订单
    [self.chooseGuigeSheetView dismiss];
    //走这个地方 一定是服务类型订单
    XKTradingAreaOrderReserveViewController *VC = [[XKTradingAreaOrderReserveViewController alloc] init];
    VC.skuItem = skuItem;
    //VC.goodsDec = self.

    if (viewType == viewType_service) {
        VC.reserveVCType = OrderReserveVC_service;
        VC.reserveTime = time;
    } else if (viewType == viewType_hetol) {
        VC.reserveVCType = OrderReserveVC_hotel;
    }

    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - Custom Delegates

//百度定位
- (void)userLocationLaititude:(double)laititude longtitude:(double)longtitude {
    _laititude = laititude;
    _longtitude = longtitude;
    self.adapter.lat = _laititude;
    self.adapter.lng = _longtitude;
    
    //    [[XKBaiduLocation shareManager] getNearbySearch];
}



- (void)adapterTableView:(UITableView *)tableView didSelectRowAtIndex:(NSInteger)index info:(NSDictionary *)info {

    if (index == CommonType_activity) {//店铺活动
        XKTradingAreaSotreActivityMainViewController *vc = [[XKTradingAreaSotreActivityMainViewController alloc] init];
        vc.shopId = self.shopId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (index == CommonType_booking) {//服务
        
        XKTradingAreaGoodsDetailViewController *vc = [[XKTradingAreaGoodsDetailViewController alloc] init];
        vc.goodsId = info[@"goodsId"];
        vc.shopId = self.shopId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (index == CommonType_hotel) {//酒店
        
        XKTradingAreaGoodsDetailViewController *vc = [[XKTradingAreaGoodsDetailViewController alloc] init];
        vc.goodsId = info[@"goodsId"];
        vc.shopId = self.shopId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (index == CommonType_storeInStore) {//店中店
        
        XKStoreRecommendViewController *vc = [[XKStoreRecommendViewController alloc] init];
        vc.shopId = self.shopId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        //其他不处理
    }
}


- (void)adapterAutoScrollView:(XKAutoScrollView *)autoScrollView didSelectItem:(XKAutoScrollImageItem *)item index:(NSInteger)index {
    
    [XKGlobleCommonTool showBigImgWithImgsArr:@[item.image] viewController:self];
}

- (void)addressButtonSelected:(NSString *)addressName lat:(double)lat lng:(double)lng {
    
    XKBDMapViewController *vc = [[XKBDMapViewController alloc] init];
    vc.myLatitude = _laititude;
    vc.myLongitude = _longtitude;
    vc.destinationName = addressName;
    vc.destinationLatitude = lat;
    vc.destinationLongitude = lng;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)adapterFooterMoreViewClicked:(NSInteger)moreViewTag shopId:(NSString *)shopId severCode:(NSString *)severCode shopName:(NSString *)shopName {
    
    XKStoreEditMenuViewController *vc = [[XKStoreEditMenuViewController alloc] init];
    vc.shopId = shopId;
    vc.shopName = shopName;
    vc.severCode = severCode;
    if ([severCode isEqualToString:kSeverCode]) {
        vc.type = Type_sever;
    } else if ([severCode isEqualToString:kHotelCode]) {
        vc.type = Type_hotel;
    } else if ([severCode isEqualToString:kOfflineCode]) {
       vc.type = Type_offline;
    } else if ([severCode isEqualToString:kOnlineCode]) {
        vc.type = Type_takeOut;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)reservationButtonSelected:(UIButton *)reservationBtn phoneArray:(NSArray *)phoneArr cellType:(IntroductionCellType)cellType {
    

    NSString *message = nil;
    if (phoneArr.count == 0) {
        message = @"暂无可拨打电话";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    for (NSString *phone in phoneArr) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:phone style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSInteger index = [alertController.actions indexOfObject:action];
            NSString *phoneStr = [NSString stringWithFormat:@"tel:%@", phoneArr[index]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr] options:@{} completionHandler:nil];
        }];
        [alertController addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)adapterLookStore:(NSString *)shopId {
    
    XKStoreRecommendViewController *vc = [[XKStoreRecommendViewController alloc] init];
    vc.shopId = shopId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)adapterLookMoreEstimate:(NSInteger)type {
    
    XKStoreEstimateDetailListViewController *vc = [[XKStoreEstimateDetailListViewController alloc] init];
    vc.type = EstimateDetailListType_shop;
    vc.shopId = self.shopId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)adapterEstimateCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imgArr:(NSArray *)imgArr {
    [XKGlobleCommonTool showBigImgWithImgsArr:imgArr viewController:self];

}


- (void)adapterStoreIntroductionImgCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imgArr:(NSArray *)imgArr {
    [XKGlobleCommonTool showBigImgWithImgsArr:imgArr viewController:self];
}


- (void)buyButtonSelected:(NSString *)goodsId goodsDetail:(XKTradingAreaGoodsInfoModel *)goodsDetail type:(NSInteger)type {
    if (type == CommonType_offLine) {
        //这里不会走
    } else if (type == CommonType_takeout) {
        //这里不会走
    } else if (type == CommonType_booking) {
        [self.guigeChooseView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 255 + kBottomSafeHeight + (goodsDetail.goodsSkuAttrsVO.attrList.count * 60))];
        [self.guigeChooseView setValueWithModel:goodsDetail viewType:viewType_service];
        [self.chooseGuigeSheetView show];
        
    } else if (type == CommonType_hotel) {
        [self.guigeChooseView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196 + kBottomSafeHeight + (goodsDetail.goodsSkuAttrsVO.attrList.count * 60))];
        [self.guigeChooseView setValueWithModel:goodsDetail viewType:viewType_hetol];
        [self.chooseGuigeSheetView show];
    }
}

//现场选购 外卖 item
- (void)goodsItemSelected:(NSString *)goodsId index:(NSInteger)index {
    
    XKTradingAreaGoodsDetailViewController *vc = [[XKTradingAreaGoodsDetailViewController alloc] init];
    vc.goodsId = goodsId;
    vc.shopId = self.shopId;
    [self.navigationController pushViewController:vc animated:YES];

}



#pragma mark - Lazy load

- (XKTradingAreaCommonAdapter *)adapter {
    if (!_adapter) {
        _adapter =  [[XKTradingAreaCommonAdapter alloc] init];
        _adapter.shopId = self.shopId;
        _adapter.delegate = self;
        _adapter.lat = [[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].latitude;;
        _adapter.lng = [[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].longitude;;
    }
    return _adapter;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        self.adapter.tableView = _tableView;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [[UIButton alloc] init];
        [_collectBtn addTarget:self action:@selector(collectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_collectBtn setImage:[UIImage imageNamed:@"xk_btn_TradingArea_collect_white"] forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@"xk_btn_TradingArea_collect_red"] forState:UIControlStateSelected];
    }
    return _collectBtn;
}


- (XKStoreReserveChooseSpecificationView *)guigeChooseView {
    if (!_guigeChooseView) {
        _guigeChooseView = [[XKStoreReserveChooseSpecificationView alloc] init];
        XKWeakSelf(weakSelf);
        _guigeChooseView.closeBlock = ^{
            [weakSelf guigeChooseViewCloseButtonClicekd];
        };
        _guigeChooseView.nextBlock = ^(GoodsSkuVOListItem *skuItem, NSString *time, SpecificationViewType viewType) {
            [weakSelf guigeChooseViewNextButtonCliceked:skuItem time:time viewType:viewType];
        };
    }
    return _guigeChooseView;
}

- (XKCommonSheetView *)chooseGuigeSheetView {
    
    if (!_chooseGuigeSheetView) {
        _chooseGuigeSheetView = [[XKCommonSheetView alloc] init];
//        _chooseGuigeSheetView.addBottomSafeHeight = YES;
        _chooseGuigeSheetView.contentView = self.guigeChooseView;
        [_chooseGuigeSheetView addSubview:self.guigeChooseView];
    }
    return _chooseGuigeSheetView;
}



@end
