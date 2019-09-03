//
//  XKTradingAreaOrderDetailViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderDetailViewController.h"
#import "XKTradingAreaOrderDetailBaseAdapter.h"
#import "XKTradingAreaOrderDetailOnlineAdapter.h"
#import "XKTradingAreaOrderDetailOfflineAdapter.h"
#import "XKTradingAreaOrderDetailServiceAdapter.h"

#import "XKStoreEditMenuViewController.h"
#import "XKBDMapViewController.h"
#import "XKTradingAreaOrderRefundViewController.h"
#import "XKOrderEvaluationController.h"
#import "XKTradingAreaOrderRefundListViewController.h"
#import "XKTradingAreaAddGoodsListViewController.h"
#import "XKTradingAreaOrderPayViewController.h"
#import "XKSquareTradingAreaTool.h"
#import "XKTradingAreaOrderDetaiModel.h"


@interface XKTradingAreaOrderDetailViewController ()<XKTradingAreaOrderDetailAdapterDelegate>

@property (nonatomic, strong) UIButton   *shareBtn;

@property (nonatomic, strong) UIView     *bottomView;
@property (nonatomic, strong) UIView     *bottomTotalPriceView;
@property (nonatomic, strong) UILabel    *bottomTotalPriceLabel;
@property (nonatomic, strong) UIView     *bottomTotalLineView;
@property (nonatomic, strong) UIButton   *bottomCancelBtn;
@property (nonatomic, strong) UIButton   *bottomPayBtn;
@property (nonatomic, strong) UIButton   *bottomCallBtn;

@property (nonatomic, strong) UITableView                           *tableView;
@property (nonatomic, strong) XKTradingAreaOrderDetailBaseAdapter   *adapter;
@property (nonatomic, strong) XKTradingAreaOrderDetaiModel          *model;



@end

@implementation XKTradingAreaOrderDetailViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self configNavigationBar];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestOrderDetail];
}

- (void)backBtnClick {
    //先返回店铺 如果没有返回上一级界面
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"XKStoreRecommendViewController")]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [super backBtnClick];
}

#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"订单详情" WithColor:[UIColor whiteColor]];
    [self setNaviCustomView:self.shareBtn withframe:CGRectMake(SCREEN_WIDTH - 80, 0, 75, 40)];
    
}

- (void)configViews {
    if (iPhoneX) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = XKSeparatorLineColor;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kBottomSafeHeight, SCREEN_WIDTH, kBottomSafeHeight)];
        view.backgroundColor = [UIColor whiteColor];
        [view addSubview:line];
        [self.view addSubview:view];
    }
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomCallBtn];
    [self.bottomView addSubview:self.bottomCancelBtn];
    [self.bottomView addSubview:self.bottomPayBtn];
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    //服务+加购
    BOOL afterSale = NO;
    if ([self.model.status isEqualToString:@"del"] && self.model.isAgree == 0) {
        afterSale = YES;
    }
    if ([self.model.sceneStatus isEqualToString:@"SERVICE_AND_LOCALE_BUY"] && !afterSale) {
        [self.view addSubview:self.bottomTotalPriceView];
        [self.bottomTotalPriceView addSubview:self.bottomTotalPriceLabel];
        [self.bottomTotalPriceView addSubview:self.bottomTotalLineView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.bottomTotalPriceView.mas_top);
        }];
        [self.bottomTotalPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@44);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        [self.bottomTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomTotalPriceView).offset(20);
            make.top.bottom.right.equalTo(self.bottomTotalPriceView);
        }];
        [self.bottomTotalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.left.bottom.right.equalTo(self.bottomTotalPriceView);
        }];
    } else {
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        
    }
    
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kBottomSafeHeight);
        make.height.equalTo(@50);
    }];
    [self.bottomCallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(15);
        make.top.bottom.equalTo(self.bottomView);
        make.right.equalTo(self.bottomCancelBtn.mas_left);
    }];
    [self.bottomCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomPayBtn.mas_left);
        make.top.bottom.equalTo(self.bottomView);
        make.width.equalTo(@105);
    }];
    [self.bottomPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView);
        make.width.equalTo(@105);
        make.top.bottom.equalTo(self.bottomView);
    }];
    
    XKWeakSelf(weakSelf);
    MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestOrderDetail];
    }];
    self.tableView.mj_header = narmalHeader;

}

- (void)setViewValues {
    
    //外卖
    if (self.adapter.orderType == OrderDetailType_online) {
        
        if (self.adapter.orderStatus == OrderStatus_pick) {
            self.bottomCancelBtn.hidden = YES;
            self.bottomPayBtn.hidden = NO;
            self.bottomPayBtn.backgroundColor = HEX_RGB(0xEE6161);
            [self.bottomPayBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        } else if (self.adapter.orderStatus == OrderStatus_pay) {
            
            self.bottomCancelBtn.hidden = NO;
            self.bottomCancelBtn.backgroundColor = HEX_RGB(0xEE6161);
            [self.bottomCancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            
            self.bottomPayBtn.hidden = NO;
            self.bottomPayBtn.backgroundColor = XKMainTypeColor;
            [self.bottomPayBtn setTitle:@"去支付" forState:UIControlStateNormal];
            
        } else if (self.adapter.orderStatus == OrderStatus_prepare) {
            
            self.bottomCancelBtn.hidden = YES;
            self.bottomPayBtn.hidden = NO;
            self.bottomPayBtn.backgroundColor = HEX_RGB(0xEE6161);
            [self.bottomPayBtn setTitle:@"退款" forState:UIControlStateNormal];
        } else if (self.adapter.orderStatus == OrderStatus_useing) {
            
            self.bottomCancelBtn.hidden = NO;
            self.bottomCancelBtn.backgroundColor = XKMainTypeColor;
            [self.bottomCancelBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            
            self.bottomPayBtn.hidden = NO;
            self.bottomPayBtn.backgroundColor = HEX_RGB(0xEE6161);
            [self.bottomPayBtn setTitle:@"退款" forState:UIControlStateNormal];
            
        } else if (self.adapter.orderStatus == OrderStatus_afterSale) {
            
            self.bottomCancelBtn.hidden = YES;
            self.bottomPayBtn.hidden = YES;

        } else if (self.adapter.orderStatus == OrderStatus_evaluate) {
            
            self.bottomCancelBtn.hidden = YES;
            self.bottomPayBtn.hidden = NO;
            self.bottomPayBtn.backgroundColor = XKMainTypeColor;
            [self.bottomPayBtn setTitle:@"去评价" forState:UIControlStateNormal];
        } else {
            
            self.bottomCancelBtn.hidden = YES;
            self.bottomPayBtn.hidden = NO;
            self.bottomPayBtn.backgroundColor = XKMainTypeColor;
            [self.bottomPayBtn setTitle:@"再次购买" forState:UIControlStateNormal];
        }
    } else {
        [self.bottomTotalPriceLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"总金额：￥");
            confer.text([NSString stringWithFormat:@"%.2f", self.adapter.goodsPrice + self.adapter.addGoodsPrice]).font(XKMediumFont(24)).textColor(HEX_RGB(0xee6161));
        }];
        
        if (self.adapter.orderStatus == OrderStatus_pick ||
            self.adapter.orderStatus == OrderStatus_use ||
            self.adapter.orderStatus == OrderStatus_prepare ||
            self.adapter.orderStatus == OrderStatus_useing ||
            self.adapter.orderStatus == OrderStatus_evaluate) {
            
            self.bottomCancelBtn.hidden = YES;
            self.bottomPayBtn.hidden = NO;
            if (self.adapter.orderStatus == OrderStatus_pick ||
                self.adapter.orderStatus == OrderStatus_use ||
                self.adapter.orderStatus == OrderStatus_prepare) {
                
                self.bottomPayBtn.backgroundColor = HEX_RGB(0xEE6161);
                [self.bottomPayBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                
            } else {
                self.bottomPayBtn.backgroundColor = XKMainTypeColor;
                
                if (self.adapter.orderStatus == OrderStatus_useing){
                    //商家已确认用户发起结算
                    if ([self.model.orderStatus isEqualToString:@"STAY_CLEARING"]) {
                        [self.bottomPayBtn setTitle:@"去支付" forState:UIControlStateNormal];
                    } else {
                        [self.bottomPayBtn setTitle:@"我要付款" forState:UIControlStateNormal];
                    }
                } else if (self.adapter.orderStatus == OrderStatus_evaluate) {
                    [self.bottomPayBtn setTitle:@"去评价" forState:UIControlStateNormal];
                }
            }
        } else if (self.adapter.orderStatus == OrderStatus_pay) {
            
            self.bottomCancelBtn.hidden = NO;
            self.bottomCancelBtn.backgroundColor = HEX_RGB(0xEE6161);
            [self.bottomCancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            
            self.bottomPayBtn.hidden = NO;
            self.bottomPayBtn.backgroundColor = XKMainTypeColor;
            [self.bottomPayBtn setTitle:@"去支付" forState:UIControlStateNormal];
            
        } else if (self.adapter.orderStatus == OrderStatus_finsh ||
                   self.adapter.orderStatus == OrderStatus_close ||
                   self.adapter.orderStatus == OrderStatus_afterSale) {
            self.bottomCancelBtn.hidden = YES;
            self.bottomPayBtn.hidden = YES;
        }
    }
    
    
    if (self.adapter.orderType == OrderDetailType_online) {
        self.shareBtn.hidden = YES;
    } else {
        
        if (self.adapter.orderStatus == OrderStatus_use ||
            self.adapter.orderStatus == OrderStatus_useing) {
            
            self.shareBtn.hidden = NO;
        } else {
            self.shareBtn.hidden = YES;
        }
    }
}

#pragma mark - requset
- (void)requestOrderDetail {
    [XKHudView showLoadingTo:self.view animated:YES];
    [XKSquareTradingAreaTool tradingAreaOrderDetail:@{@"orderId":self.orderId ? self.orderId : @""}
                                      isRefundOrder:self.isAfterSaleOrder
                                            success:^(XKTradingAreaOrderDetaiModel *model) {
                                                [XKHudView hideHUDForView:self.view];
                                                self.model = model;
                                                //初始化界面
                                                [self configViews];
                                                //赋值模型
                                                self.adapter.orderModel = model;
                                                //判断订单状态
                                                [self setViewValues];
                                                
                                            } faile:^(XKHttpErrror *error) {
                                                [self.tableView.mj_header endRefreshing];
                                                [XKHudView hideHUDForView:self.view];
                                            }];
}

#pragma mark - Events

- (void )shareButtonClicked {
    
     NSMutableArray *shareItems = [NSMutableArray arrayWithArray:@[XKShareItemTypeCircleOfFriends,
                                                                   XKShareItemTypeWechatFriends,
                                                                   XKShareItemTypeQQ,
                                                                   XKShareItemTypeSinaWeibo]];
     XKCustomShareView *moreView = [[XKCustomShareView alloc] init];
     moreView.autoThirdShare = YES;
     //    moreView.delegate = self;
     moreView.layoutType = XKCustomShareViewLayoutTypeBottom;
     moreView.shareItems = shareItems;
     XKShareDataModel *shareData = [[XKShareDataModel alloc] init];
     shareData.title = self.model.shopName ? self.model.shopName : @"";
     shareData.content = @"订单分享";
     shareData.url = [NSString stringWithFormat:@"%@share/#/orderDetail?orderId=%@", BaseWebUrl, self.model.orderId];
     shareData.img = nil;
     moreView.shareData = shareData;
     [moreView showInView:self.view];
}


- (void)cancelOrderBtnClicked:(UIButton *)sender {
    [self senderClicked:sender];
}

- (void)buyButtonClicked:(UIButton *)sender {
    [self senderClicked:sender];
}
- (void)senderClicked:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"取消订单"] || [sender.titleLabel.text isEqualToString:@"退款"]) {
        XKTradingAreaOrderRefundViewController *vc = [[XKTradingAreaOrderRefundViewController alloc] init];
        vc.type = OrderRefundType_cancelOrder;
        vc.orderId = self.adapter.orderModel.orderId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([sender.titleLabel.text isEqualToString:@"去支付"]) {
        XKTradingAreaOrderPayViewController *vc = [[XKTradingAreaOrderPayViewController alloc] init];
        vc.itemsArr = self.adapter.orderModel.items;
        if (self.adapter.orderType == OrderDetailType_hotel || self.adapter.orderType == OrderDetailType_service) {
            
            vc.appointRange = self.adapter.orderModel.appointRange;
            vc.type = PayViewType_service;
            //纯服务
            if ([self.adapter.orderModel.sceneStatus isEqualToString:@"SERVICE_OR_STAY"]) {
                vc.isMainOrder = YES;
            } else {
                //服务+加购
                //进行中的支付 是主单支付   其他时候不是主单支付
                if (self.adapter.orderStatus == OrderStatus_useing) {
                    vc.isMainOrder = YES;
                }
            }
        } else if (self.adapter.orderType == OrderDetailType_offline) {
            vc.type = PayViewType_offline;
            
        } else if (self.adapter.orderType == OrderDetailType_online) {
            if (self.adapter.takeoutWay == 0) {
                vc.type = PayViewType_takeoutSend;
            } else {
                vc.type = PayViewType_takeoutSelfTake;
            }
        }
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([sender.titleLabel.text isEqualToString:@"去评价"]) {
        
        XKOrderEvaluationController *vc = [[XKOrderEvaluationController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([sender.titleLabel.text isEqualToString:@"我要付款"] || [sender.titleLabel.text isEqualToString:@"确认收货"]) {//有加购或者是现场购物的
        [XKHudView showLoadingTo:self.view animated:YES];
        NSString *orderId = self.adapter.orderModel.orderId;
        [XKSquareTradingAreaTool tradingAreaTellMerchantOrderWillPay:@{@"orderId":orderId ? orderId : @""} success:^(XKTradingAreaCreatOderModel *model) {
            [XKHudView hideHUDForView:self.view];
            if ([sender.titleLabel.text isEqualToString:@"我要付款"]) {
                [XKAlertView showCommonAlertViewWithTitle:@"提示商家成功，待商家确认后方可支付"];
            } else {
                [self requestOrderDetail];
            }
        } faile:^(XKHttpErrror *error) {
            [XKHudView hideHUDForView:self.view];
        }];
    } else if ([sender.titleLabel.text isEqualToString:@"再次购买"]) {
        
        
    }
}

- (void)callButtonClicked:(UIButton *)sender {
    [self phoneButtonSelected:nil phoneArray:self.adapter.orderModel.contactPhones];
}

- (void)refreshTradingAreaOrder {
    [self requestOrderDetail];
}

#pragma mark - customDelegate

- (void)refreshTradingAreaOrderDetail {
    [self requestOrderDetail];
}

- (void)gotoPayAddGoodsItem:(NSArray<OrderItems *> *)arr {
    if (arr.count == 0) {
        return;
    }
    XKTradingAreaAddGoodsListViewController *vc = [[XKTradingAreaAddGoodsListViewController alloc] init];
    vc.listType = GoodsListType_payAddGoods;
    vc.goodsArr = arr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refundSeviceOrHotelItem:(NSArray<OrderItems *> *)arr {
    XKTradingAreaOrderRefundListViewController *vc = [[XKTradingAreaOrderRefundListViewController alloc] init];
    vc.arr = arr;
    vc.shopName = self.adapter.orderModel.shopName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deletePurchaseOrder {
    [self requestOrderDetail];
}

- (void)cancelPurchaseOrderWithPurchaseItems:(NSArray<PurchasesItem *> *)arr {
    
    XKTradingAreaOrderRefundViewController *vc = [[XKTradingAreaOrderRefundViewController alloc] init];
    vc.type = OrderRefundType_cancelPurchase;
    vc.purchasesItemArr = arr;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)refundPurchaseOrderWithPurchaseItems:(NSArray<PurchasesItem *> *)arr {
    
    XKTradingAreaOrderRefundViewController *vc = [[XKTradingAreaOrderRefundViewController alloc] init];
    vc.type = OrderRefundType_refundPurchase;
    vc.purchasesItemArr = arr;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)addGoodsWithShopId:(NSString *)shopId orderId:(NSString *)orderId itemId:(NSString *)itemId {
    
    XKStoreEditMenuViewController *vc = [[XKStoreEditMenuViewController alloc] init];
    vc.isAdd = YES;
    vc.orderId = orderId;
    vc.itemId = itemId;
    vc.shopId = shopId;
    //加购的东西 全是现场消费类型的商品
    vc.severCode = kOfflineCode;
    vc.type = Type_offline;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addressButtonSelected:(NSString *)addressName lat:(double)lat lng:(double)lng {
    
    XKBDMapViewController *vc = [[XKBDMapViewController alloc] init];
    vc.destinationName = addressName;
    vc.destinationLatitude = lat;
    vc.destinationLongitude = lng;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)phoneButtonSelected:(UIButton *)sender phoneArray:(NSArray *)phoneArr {
    
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

- (void)shareStoreButtonSelected {
    
    
}

#pragma mark - costomBlock


#pragma mark - lazy load

- (XKTradingAreaOrderDetailBaseAdapter *)adapter {
    if (!_adapter) {
        NSString *type = self.model.sceneStatus;
        if ([type isEqualToString:@"SERVICE_OR_STAY"] || [type isEqualToString:@"SERVICE_AND_LOCALE_BUY"]) {
            _adapter = [[XKTradingAreaOrderDetailServiceAdapter alloc] init];
        } else if ([type isEqualToString:@"TAKE_OUT"]) {
            _adapter = [[XKTradingAreaOrderDetailOnlineAdapter alloc] init];
        } else if ([type isEqualToString:@"LOCALE_BUY"]) {
            _adapter = [[XKTradingAreaOrderDetailOfflineAdapter alloc] init];
        }
        _adapter.delegate = self;
    }
    return _adapter;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        self.adapter.tableView = _tableView;
    }
    return _tableView;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc] init];
        _shareBtn.hidden = YES;
        [_shareBtn addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_shareBtn setTitle:@"分享订单" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [_shareBtn setImage:[UIImage imageNamed:@"xk_btn_TradingArea_share_white"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIView *)bottomTotalPriceView {
    if (!_bottomTotalPriceView) {
        _bottomTotalPriceView = [[UIView alloc] init];
        _bottomTotalPriceView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomTotalPriceView;
}

- (UILabel *)bottomTotalPriceLabel {
    if (!_bottomTotalPriceLabel) {
        _bottomTotalPriceLabel = [[UILabel alloc] init];
        _bottomTotalPriceLabel.backgroundColor = [UIColor whiteColor];
        _bottomTotalPriceLabel.font = XKRegularFont(14);
        _bottomTotalPriceLabel.textColor = HEX_RGB(0x222222);
    }
    return _bottomTotalPriceLabel;
}

- (UIView *)bottomTotalLineView {
    if (!_bottomTotalLineView) {
        _bottomTotalLineView = [[UIView alloc] init];
        _bottomTotalLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _bottomTotalLineView;
}



- (UIButton *)bottomPayBtn {
    if (!_bottomPayBtn) {
        _bottomPayBtn = [[UIButton alloc] init];
        _bottomPayBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_bottomPayBtn addTarget:self action:@selector(buyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _bottomPayBtn;
}

- (UIButton *)bottomCancelBtn {
    if (!_bottomCancelBtn) {
        _bottomCancelBtn = [[UIButton alloc] init];
        _bottomCancelBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_bottomCancelBtn addTarget:self action:@selector(cancelOrderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomCancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _bottomCancelBtn;
}

- (UIButton *)bottomCallBtn {
    if (!_bottomCallBtn) {
        _bottomCallBtn = [[UIButton alloc] init];
        _bottomCallBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _bottomCallBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_bottomCallBtn setTitle:@" 联系商家" forState:UIControlStateNormal];
        [_bottomCallBtn setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
        [_bottomCallBtn setImage:IMG_NAME(@"xk_icon_Store_ phone_normal") forState:UIControlStateNormal];
        [_bottomCallBtn addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomCallBtn;
}


@end
