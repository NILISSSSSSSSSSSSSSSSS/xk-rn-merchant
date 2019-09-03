//
//  XKMallGoodsDetailViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallGoodsDetailViewController.h"
#import "XKWelfareOrderDetailBottomView.h"
#import "XKWelfareGoodsDetailBannerCell.h"
#import "XKWelfareGoodsDetailInfoCell.h"
#import "XKWelfareGoodsDetailContentCell.h"
#import "XKWelfareGoodsDetailCommentCell.h"
#import "XKCommonSheetView.h"
#import "XKMallGoodsDetailBottomView.h"
#import "XKWelfareGoodsDetailShareView.h"
#import "XKMenuView.h"
#import "XKMallGoodsDetailViewModel.h"
#import "XKWelfareOpinionViewController.h"
#import "XKCustomeSerMessageManager.h"
#import "XKMallBuyCarViewController.h"
#import "XKGoodsAllCommentController.h"
#import "XKGoodsShareModel.h"
#import "XKDeviceDataLibrery.h"
#import "XKMallBuyCarCountViewController.h"
#import "XKMallBuyCarViewModel.h"
#import "XKGoodsDetailPicModel.h"
#import "XKMallMerchantViewController.h"
@interface XKMallGoodsDetailViewController ()
@property (nonatomic, strong) XKCustomNavBar *navBar;
@property (nonatomic, strong) XKWelfareOrderDetailBottomView *bottomView;
@property (nonatomic, strong) XKCommonSheetView *sheetView;

@property (nonatomic, strong) XKWelfareGoodsDetailShareView *shareView;
@property (nonatomic, strong) XKCommonSheetView *shareSheetView;
@property (nonatomic, strong) XKMallGoodsDetailViewModel  *viewModel;
@property (nonatomic, strong) MallGoodsListItem  *item;
@property (nonatomic, strong) XKGoodsShareModel  *shareModel;

@end

@implementation XKMallGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didPopToPreviousController {
    [self removeAllScriptMessageHandler];
}

- (void)setGoodsId:(NSString *)goodsId {
    _goodsId = goodsId;
    MallGoodsListItem *item = [MallGoodsListItem new];
    item.ID = goodsId;
    [self config:item];
}


- (void)config:(MallGoodsListItem *)goodsItem {
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    NSString *userToken = [XKUserInfo getCurrentUserToken];
    NSString *userId = [XKUserInfo getCurrentUserId];
    if (userToken) {
        [parameterDic setValue:userToken forKey:@"token"];
        [parameterDic setValue:userId forKey:@"userId"];
    }
    [parameterDic setValue:@"ios" forKey:@"os"];
    [parameterDic setValue:XKAppVersion forKey:@"clientVersion"];
    [parameterDic setValue:[[XKDeviceDataLibrery sharedLibrery] getDiviceName] forKey:@"mobileType"];
    [parameterDic setValue:[XKGlobleCommonTool getCurrentUserDeviceToken] forKey:@"guid"];
    [parameterDic setValue:@"appStore" forKey:@"channel"];
    [parameterDic setValue:@(self.entryType)  forKey:@"entryType"];
    NSString *from;
    switch (self.type) {
        case XKMallGoodsDetailViewControllerTypeSoldByXiaoke: {
            from = @"soldByXiaoke";
            break;
        }
        case XKMallGoodsDetailViewControllerTypeSoldByVideoAdvertisement: {
            from = @"soldByVideoAdvertisement";
            break;
        }
        default:
            break;
    }
    [parameterDic setValue:from forKey:@"from"];
    NSString *infoStr = [parameterDic yy_modelToJSONString];
    NSString *codeStr = [infoStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];; //编码
    NSString *path = [NSString stringWithFormat:@"web/#/goodsdetail?id=%@&client=xk&info=%@",goodsItem.ID,codeStr];
    NSString *server = [BaseWebUrl stringByAppendingString:path];
    [self creatWkWebViewWithMethodNameArray:@[@"jsHiddenXKHUDView", @"jsOpenAppShoppingCart", @"jsOpenAppCustomerService", @"jsOpenAppImageBrowser", @"jsOpenAppComments",@"pushSharePath", @"jsOpenIndianaShopOrder", @"jsOpenZyMallStore"] requestUrlString:server];
    self.jsHiddenHUDView = YES;
//    [self updateDataWithItem:goodsItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.navBar];

}

- (void)handleData {
    [super handleData];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    switch (self.type) {
        case XKMallGoodsDetailViewControllerTypeSoldByXiaoke: {
            [_navBar customNaviBarWithTitle:@"" andRightButtonImageTitle:@"xk_icon_welfaregoods_detail_more"];
            _navBar.rightButtonBlock = ^(UIButton *sender){
                [ws topRightBtnClick:sender];
            };
            break;
        }
        case XKMallGoodsDetailViewControllerTypeSoldByVideoAdvertisement: {
            [_navBar customNaviBarWithTitle:@"" andRightButtonImageTitle:@""];
            break;
        }
        default:
            break;
    }
    [_navBar.backButton setImage:[UIImage imageNamed:@"xk_icon_welfaregoods_detail_back"] forState:0];
    _navBar.backgroundColor = [UIColor clearColor];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    _navBar.rightButton.userInteractionEnabled = NO;
    [self.view addSubview:_navBar];
 //   [self.view addSubview:self.bottomView];
    [self.view bringSubviewToFront:_navBar];
    [self.view bringSubviewToFront:self.bottomView];
    
    self.shareSheetView.contentView = self.shareView;
    [self.shareSheetView addSubview:self.shareView];
}
/*
- (void)updateDataWithItem:(MallGoodsListItem *)item {
    _item = item;
    [self.view bringSubviewToFront:self.bottomView];
    [self.view bringSubviewToFront:self.navBar];
    [self requestSKUinfo];
}*/

//打开购物车
- (void)jsOpenAppShoppingCart {
    NSLog(@"%s",__func__);
    XKMallBuyCarViewController *buyCarVC = [XKMallBuyCarViewController new];
    [self.navigationController pushViewController:buyCarVC animated:YES];
}
//打开客服
- (void)jsOpenAppCustomerService {
    NSLog(@"%s",__func__);
   [XKCustomeSerMessageManager createXKCustomerSerChat];
}
//打开图片浏览
- (void)jsOpenAppImageBrowser:(NSString *)urlStr {
    NSLog(@"%s",__func__);
    XKGoodsDetailPicModel *model = [XKGoodsDetailPicModel yy_modelWithJSON:urlStr];
    [XKGlobleCommonTool showBigImgWithImgsArr:model.list defualtIndex:model.index viewController:self];
    
}
//打开全部评价（全部晒单
- (void)jsOpenAppComments {
    XKGoodsAllCommentController *comment = [XKGoodsAllCommentController new];
    comment.goodsId = self.goodsId;
    [self.navigationController pushViewController:comment animated:YES];
}

//分享
- (void)pushSharePath:(NSString *)sharePath {
    NSLog(@"%@",sharePath);
    _shareModel = [XKGoodsShareModel yy_modelWithJSON:sharePath];
    _navBar.rightButton.userInteractionEnabled = YES;
}

//购买
- (void)jsOpenIndianaShopOrder:(NSString *)shopOrder {
    NSLog(@"%@",shopOrder);
    XKMallBuyCarCountViewController *sureVC = [XKMallBuyCarCountViewController new];
    XKGoodsShareParam *item = [XKGoodsShareParam yy_modelWithJSON:shopOrder];
    XKMallBuyCarItem *obj = [XKMallBuyCarItem new];
    if (item.base.showPicUrl.count > 0) {
        obj.url = item.base.showPicUrl.firstObject;
    }
    obj.goodsName = item.base.name;
    obj.goodsAttr = item.base.defaultSku.name;
    obj.quantity = item.quantity;
    obj.price = item.base.defaultSku.price;
    obj.goodsId = item.base.ID;
    obj.goodsSkuCode = item.base.defaultSku.code;
    
    sureVC.goodsArr = @[obj];
    sureVC.totalPrice = item.base.defaultSku.price * item.quantity;
    [self.navigationController pushViewController:sureVC animated:YES];
}

//打开商家详情
- (void)jsOpenZyMallStore:(NSString *)merchantStr {
    XKMallMerchantViewController *merchant = [XKMallMerchantViewController new];
    [self.navigationController pushViewController:merchant animated:YES];
}

#pragma mark 网络请求
- (void)requestSKUinfo {
//    NSDictionary *dic = @{
//                          @"goodsId" : _item.ID
//                          };
//    [XKMallGoodsDetailViewModel requestGoodsSKUinfoWithParmDic:dic success:^(XKMallGoodsDetailViewModel *model) {
//        self.viewModel = model;
//        [self.infoView updateDataWithModel:self.viewModel];
//    } failed:^(NSString *failedReason) {
//        [XKHudView showErrorMessage:failedReason];
//    }];
    
}

- (void)topRightBtnClick:(UIButton *)sender
{
    XKWeakSelf(ws);
    XKMenuView *moreMenuVuew = [XKMenuView menuWithTitles:@[@"分享      ",@"意见反馈"] images:@[[UIImage imageNamed:@"xk_btn_welfare_share"],[UIImage imageNamed:@"xk_btn_welfare_opinion"]] width:100 relyonView:sender clickBlock:^(NSInteger index, NSString *text) {
        if(index == 0) {
            ws.shareView.shareModel = ws.shareModel;
            [ws.shareSheetView showForShare];
        } else {
            XKWelfareOpinionViewController *opinion = [XKWelfareOpinionViewController new];
            opinion.goodsId = ws.goodsId;
            opinion.goodsName =  ws.shareModel.param.base.defaultSku.name;
            opinion.reportType = XKReportTypeOpinion;
            [ws.navigationController pushViewController:opinion animated:YES];
        }
    }];
    moreMenuVuew.menuColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    moreMenuVuew.textFont = XKRegularFont(12);
    moreMenuVuew.textColor = [UIColor whiteColor];
    [moreMenuVuew show];
}

- (XKWelfareOrderDetailBottomView *)bottomView {
    if(!_bottomView) {
        XKWeakSelf(ws);
        _bottomView = [XKWelfareOrderDetailBottomView WelfareOrderDetailBottomViewWithType:WelfareDetailBottomViewGoods];
        _bottomView.frame = CGRectMake(0,SCREEN_HEIGHT - kBottomSafeHeight - 50, SCREEN_WIDTH, 50 + kBottomSafeHeight);
        _bottomView.type = 0;
        [_bottomView sureBuyTitle:@"立即购买"];
        // 兑奖回调
        _bottomView.redeemBlock = ^(UIButton *sender) {
            
        };
        // 收藏回调
        _bottomView.collectBlock = ^(UIButton *sender) {

        };
        // 加入购物车回调
        _bottomView.joinBuyCarBlock = ^(UIButton *sender) {
            [ws.sheetView show];
        };
        // 联系客服回调
        _bottomView.chatBtnBlock = ^(UIButton *sender) {
            [XKCustomeSerMessageManager createXKCustomerSerChat];
        };
    }
    return _bottomView;
}

- (XKCommonSheetView *)sheetView {
    if(!_sheetView) {
        _sheetView = [[XKCommonSheetView alloc] init];
    }
    return _sheetView;
}



- (XKWelfareGoodsDetailShareView *)shareView {
    if(!_shareView) {
        XKWeakSelf(ws);
        _shareView = [[XKWelfareGoodsDetailShareView alloc] initWithFrame:CGRectMake(25 * SCREEN_WIDTH / 375 ,75 * SCREEN_WIDTH / 375  + kIphoneXNavi(0), SCREEN_WIDTH - 50 * SCREEN_WIDTH / 375,500 * SCREEN_WIDTH / 375)];
        _shareView.closeBlock = ^{
            [ws.shareSheetView dismissShare];
        };
    }
    return _shareView;
}

- (XKCommonSheetView *)shareSheetView {
    if(!_shareSheetView) {
        _shareSheetView = [[XKCommonSheetView alloc] init];
        _shareSheetView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _shareSheetView.animationWay = AnimationWay_centerShow;
    }
    return _shareSheetView;
}

@end
