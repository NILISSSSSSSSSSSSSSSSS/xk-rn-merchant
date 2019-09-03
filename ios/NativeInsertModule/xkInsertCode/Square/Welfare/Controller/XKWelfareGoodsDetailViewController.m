//
//  XKWelfareGoodsDetailViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareGoodsDetailViewController.h"
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
#import "XKWelfareBuyCarViewController.h"
#import "XKWelfareShareModel.h"
#import "XKGoodsAllCommentController.h"
#import "XKDeviceDataLibrery.h"
#import "XKWelfareBuyCarViewModel.h"
#import "XKWelfareSureOrderViewController.h"
#import "XKWelfarePastAwardRecordsViewController.h"

@interface XKWelfareGoodsDetailViewController ()
@property (nonatomic, strong)XKCustomNavBar *navBar;
@property (nonatomic, strong)XKWelfareOrderDetailBottomView *bottomView;
@property (nonatomic, strong)XKCommonSheetView *sheetView;
@property (nonatomic, strong)XKMallGoodsDetailBottomView *infoView;
@property (nonatomic, strong)XKWelfareGoodsDetailShareView *shareView;
@property (nonatomic, strong)XKCommonSheetView *shareSheetView;
@property (nonatomic, strong)XKMallGoodsDetailViewModel  *viewModel;
@property (nonatomic, strong) XKWelfareShareModel  *shareModel;
@end

@implementation XKWelfareGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didPopToPreviousController {
    [self removeAllScriptMessageHandler];
}

- (void)handleData {
    [super handleData];
    
}

- (void)setGoodsId:(NSString *)goodsId {
    _goodsId = goodsId;
    WelfareDataItem *item = [WelfareDataItem new];
    item.ID = goodsId;
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
    
    NSString *infoStr = [parameterDic yy_modelToJSONString];
    NSString *codeStr = [infoStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];; //编码
    NSString *path = [NSString stringWithFormat:@"web/#/welfFareGoodsDetails?id=%@&client=xk&info=%@",goodsId,codeStr];
    NSString *server = [BaseWebUrl stringByAppendingString:path];
    [self creatWkWebViewWithMethodNameArray:@[@"jsOpenAppShoppingCart", @"jsOpenAppCustomerService", @"jsOpenAppImageBrowser", @"jsOpenAppComments",@"pushSharePath", @"jsOpenIndianaShopOrder"] requestUrlString:server];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    [_navBar customNaviBarWithTitle:@"" andRightButtonImageTitle:@"xk_icon_welfaregoods_detail_more"];
    [_navBar.backButton setImage:[UIImage imageNamed:@"xk_icon_welfaregoods_detail_back"] forState:0];
    _navBar.backgroundColor = [UIColor clearColor];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    _navBar.rightButtonBlock = ^(UIButton *sender){
        [ws topRightBtnClick:sender];
    };
    [self.view addSubview:_navBar];
    //   [self.view addSubview:self.bottomView];
    [self.view bringSubviewToFront:_navBar];
    [self.view bringSubviewToFront:self.bottomView];
    
    [self.sheetView addSubview:self.infoView];
    self.sheetView.contentView = self.infoView;
    [self.shareSheetView addSubview:self.shareView];
}

- (void)creatWkWebViewWithMethodNameArray:(NSArray *)methodNameArray requestUrlString:(NSString *)urlStr {
    [super creatWkWebViewWithMethodNameArray:methodNameArray requestUrlString:urlStr];
    [self.view bringSubviewToFront:self.navBar];
}

//打开购物车
- (void)jsOpenAppShoppingCart {
    NSLog(@"%s",__func__);
    XKWelfareBuyCarViewController *buyCar = [XKWelfareBuyCarViewController new];
    [self.navigationController pushViewController:buyCar animated:YES];
}
//打开客服
- (void)jsOpenAppCustomerService {
    NSLog(@"%s",__func__);
    [XKCustomeSerMessageManager createXKCustomerSerChat];
}
//打开图片浏览
- (void)jsOpenAppImageBrowser {
    [XKGlobleCommonTool showBigImgWithImgsArr:@[] viewController:self];
    NSLog(@"%s",__func__);
}
//打开全部评价（全部晒单
- (void)jsOpenAppComments {
    XKGoodsAllCommentController *comment = [XKGoodsAllCommentController new];
    comment.type = XKAllCommentTypeForWelfare;
    comment.goodsId = self.goodsId;
    [self.navigationController pushViewController:comment animated:YES];
}
//分享
- (void)pushSharePath:(NSString *)sharePath {
    NSLog(@"%@",sharePath);
    _shareModel = [XKWelfareShareModel yy_modelWithJSON:sharePath];
    _navBar.rightButton.userInteractionEnabled = YES;
}
//购买
- (void)jsOpenIndianaShopOrder:(NSString *)shopOrder {
    NSLog(@"%@",shopOrder);
    XKWelfareShareParam *model = [XKWelfareShareParam yy_modelWithJSON:shopOrder];
    NSMutableArray *goodsArr = [NSMutableArray array];
    XKWelfareBuyCarItem *item = [XKWelfareBuyCarItem new];
    item.goodsId = model.sequence.goods.ID;
    item.drawType = model.sequence.lotteryWay.jDrawType;
    item.name = model.sequence.goods.name;
    item.url = model.sequence.goods.mainPic;
    item.quantity = model.quantity;
    item.drawTime = model.sequence.expectLotteryDate;
    item.participateStake = model.sequence.currentCustomerNum;
    item.maxStake = model.sequence.lotteryWay.eachSequenceNumber;
    item.sequenceId = model.sequence.ID;
    item.price = model.sequence.lotteryWay.eachNotePrice;
    [goodsArr addObject:item];
    
    
    XKWelfareSureOrderViewController *sureVC = [XKWelfareSureOrderViewController new];
    sureVC.goodsArr = goodsArr;
    sureVC.totalPrice = item.quantity * model.sequence.lotteryWay.eachNotePrice;
    [self.navigationController pushViewController:sureVC animated:YES];



}


#pragma mark 网络请求
- (void)requestSKUinfo {
    NSDictionary *dic = @{
                          @"goodsId":_goodsId
                          };
    [XKMallGoodsDetailViewModel requestGoodsSKUinfoWithParmDic:dic success:^(XKMallGoodsDetailViewModel *model) {
        self.viewModel = model;
        [self.infoView updateDataWithModel:self.viewModel];
    } failed:^(NSString *failedReason) {
        [XKHudView showErrorMessage:failedReason];
    }];
    
}

//收藏
- (void)collectionGoods:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [XKMallGoodsDetailViewModel requestCollectionGoodsWithParmDic:nil success:^(id data) {
        [XKHudView hideHUDForView:self.view];
        sender.selected = YES;
        sender.userInteractionEnabled = YES;
    } failed:^(NSString *failedReason) {
        [XKHudView showErrorMessage:failedReason];
        sender.selected = YES;
        sender.userInteractionEnabled = YES;
    }];
}
//取消收藏
- (void)cancelCollectionGoods:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [XKMallGoodsDetailViewModel requestCancelCollectionGoodsWithParmDic:nil success:^(id data) {
        [XKHudView hideHUDForView:self.view];
        sender.selected = NO;
        sender.userInteractionEnabled = YES;
    } failed:^(NSString *failedReason) {
        [XKHudView showErrorMessage:failedReason];
        sender.selected = NO;
        sender.userInteractionEnabled = YES;
    }];
}

- (void)topRightBtnClick:(UIButton *)sender
{
    XKWeakSelf(ws);
    XKMenuView *moreMenuVuew = [XKMenuView menuWithTitles:@[@"分享      ", @"意见反馈", @"往期中奖"] images:@[[UIImage imageNamed:@"xk_btn_welfare_share"], [UIImage imageNamed:@"xk_btn_welfare_opinion"], [UIImage imageNamed:@"xk_btn_welfare_award"]] width:100 relyonView:sender clickBlock:^(NSInteger index, NSString *text) {
        if(index == 0) {
            ws.shareView.welfareShareModel = ws.shareModel;
            [ws.shareSheetView show];
        } else if (index == 1) {
            XKWelfareOpinionViewController *opinion = [XKWelfareOpinionViewController new];
            opinion.goodsId = ws.goodsId;
            opinion.goodsName =  ws.shareModel.param.sequence.goods.name;
            [ws.navigationController pushViewController:opinion animated:YES];
        } else if (index == 2) {
            XKWelfarePastAwardRecordsViewController *vc = [[XKWelfarePastAwardRecordsViewController alloc] init];
            vc.goodsId = ws.goodsId;
            [ws.navigationController pushViewController:vc animated:YES];
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
            if(sender.isSelected) {
                [ws cancelCollectionGoods:sender];
            } else {
                [ws collectionGoods:sender];
            }
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

- (XKMallGoodsDetailBottomView *)infoView {
    if(!_infoView) {
        _infoView = [[XKMallGoodsDetailBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 450 + kBottomSafeHeight)];
    }
    return _infoView;
}

- (XKWelfareGoodsDetailShareView *)shareView {
    if(!_shareView) {
        XKWeakSelf(ws);
        _shareView = [[XKWelfareGoodsDetailShareView alloc] initWithFrame:CGRectMake(25 * SCREEN_WIDTH / 375 ,75 * SCREEN_WIDTH / 375  + kIphoneXNavi(0), SCREEN_WIDTH - 50 * SCREEN_WIDTH / 375,500 * SCREEN_WIDTH / 375 )];
        _shareView.closeBlock = ^{
            [ws.shareSheetView dismiss];
        };
    }
    return _shareView;
}

- (XKCommonSheetView *)shareSheetView {
    if(!_shareSheetView) {
        _shareSheetView = [[XKCommonSheetView alloc] init];
        _shareSheetView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _shareSheetView;
}
@end
