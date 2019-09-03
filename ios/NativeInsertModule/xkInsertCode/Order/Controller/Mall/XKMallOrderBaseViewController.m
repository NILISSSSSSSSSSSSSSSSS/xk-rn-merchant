//
//  XKMallOrderBaseViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/6.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMallOrderBaseViewController.h"
#import "XKCustomeSerMessageManager.h"
#import "XKMenuView.h"
#import "XKPayAlertSheetView.h"
#import "XKMallOrderTraceViewController.h"
#import "XKMallBuyCarViewModel.h"
#import "XKPayForMallViewController.h"
#import "XKPayCenter.h"
@interface XKMallOrderBaseViewController ()

@end

@implementation XKMallOrderBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)showPayWithItem:(MallOrderListDataItem *)item successBlock:(void(^)(id data))success failedBlock:(void(^)(NSString *reason))failed {
   // [XKPayAlertSheetView show];
    XKWeakSelf(ws);
    CGFloat totalPrice = 0.f;
    for (MallOrderListObj *obj in item.goods) {
        totalPrice += obj.price;
    };
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:@{ @"totalAmount" : @"1",
                                                                                   @"orderId" : item.orderId,
                                                                                   @"describe" : @"test"
                                                                                   
                                                                                   }];
    [XKPayAlertSheetView showWithResultBlock:^(NSInteger index) {
       
        switch (index) {
            case 0: {
                tmpDic[@"payChannel"] = @"ALI_PAY";
                [HTTPClient postRequestWithURLString:@"http://192.168.2.57:8089/api/external/ali/appPay" timeoutInterval:20.f parameters:tmpDic success:^(id responseObject) {
                    [XKHudView hideAllHud];
                    [[XKPayCenter sharedPayCenter] AliPayWithOrderString:responseObject[@"data"] succeedBlock:^{
                        [XKHudView showSuccessMessage:@"支付成功"];
                    } failedBlock:^(NSString *reason) {
                        [XKHudView showErrorMessage:reason];
                    }];
                } failure:^(XKHttpErrror *error) {
                    [XKHudView hideAllHud];
                 
                }];
            }
                
                break;
            case 1: {
                tmpDic[@"payChannel"] = @"WX";
                tmpDic[@"tradeType"] = @"APP";
                [HTTPClient postRequestWithURLString:@"http://192.168.2.57:8089/api/external/wx/appPay" timeoutInterval:20.f parameters:tmpDic success:^(id responseObject) {
                    [XKHudView hideAllHud];
                    NSDictionary *dic = responseObject[@"data"];
                    [[XKPayCenter sharedPayCenter] WeChatPayWithPayPara:dic succeedBlock:^{
                        [XKHudView showSuccessMessage:@"支付成功"];
                    } failedBlock:^(NSString *reason) {
                        [XKHudView showErrorMessage:reason];
                    }];
                } failure:^(XKHttpErrror *error) {
                    [XKHudView hideAllHud];
                    
                }];
            }
                
                break;
            case 2:
                tmpDic[@"payChannel"] = @"ALI_PAY";
                break;
                
            default:
                break;
        }
        return ;
        XKPayForMallViewController *pay = [XKPayForMallViewController new];
        pay.payResult = ^(BOOL successful) {
            if (successful) {
                [XKMallOrderViewModel payForMallOrderWithParmDic:tmpDic Success:^(id data) {
                    success(data);
                } failed:^(NSString *failedReason, NSInteger code) {
                    failed(failedReason);
                }];
            } else {
                [XKHudView showErrorMessage:@"支付失败"];
            }
        };
        [[ws getCurrentUIVC].navigationController pushViewController:pay animated:YES];
    }];
}

- (void)requestPayWithGoodsArr:(NSArray *)goodsArr andOrderId:(NSString *)orderId payChannel:(NSString *)payChannel successBlock:(void(^)(id data))success failedBlock:(void(^)(NSString *reason))failed {
    // [XKPayAlertSheetView show];
    CGFloat totalPrice = 0.f;
    for (XKMallBuyCarItem *item in goodsArr) {
        totalPrice += item.price;
    };
    NSDictionary *dic = @{
                          @"payAmount" : @(totalPrice),
                          @"orderId" : orderId,
                          @"payChannel" : payChannel// @"ALI_PAY"
                          };
    [XKMallOrderViewModel payForMallOrderWithParmDic:dic Success:^(id data) {
        success(data);
    } failed:^(NSString *failedReason, NSInteger code) {
        failed(failedReason);
    }];
}

- (void)setOrderId:(NSString *)orderId {
    _orderId = orderId;
}

- (void)showPayWithItems:(NSArray *)itemArr {
    
}

- (void)chatWithCustomerServiceWithGoodsItem {
    [XKCustomeSerMessageManager createXKCustomerSerChat];
}

- (void)goodsReturnWithListOrderWithGoodsItem:(MallOrderListDataItem *)item withStatus:(OrderStatus)status {
    XKMallApplyAfterSaleListViewController *apply = [XKMallApplyAfterSaleListViewController new];
    apply.status = status;
    apply.orderId = item.orderId;
    apply.goodsArr = [item.goods copy];
    apply.applyType = XKApplyEnterTypeList;
    [self.navigationController pushViewController:apply animated:YES];
}

- (void)goodsReturnWithDetailOrderWithGoodsItem:(XKMallOrderDetailViewModel *)item withStatus:(OrderStatus)status {
    XKMallApplyAfterSaleListViewController *apply = [XKMallApplyAfterSaleListViewController new];
    apply.status = status;
    apply.orderId = item.orderId;
    apply.goodsArr = [item.goodsInfo copy];
    apply.applyType = XKApplyEnterTypeDetail;
    [self.navigationController pushViewController:apply animated:YES];
}

- (void)cancelOrderWithGoodsItem:(MallOrderListDataItem *)item suucessBlock:(void(^)(id data))success failedBlock:(void(^)(NSString *reason))failed {
  
    [XKMallOrderViewModel cancelMallOrderWithOrderId:item.orderId Success:^(id data) {
        success(data);
    } failed:^(NSString *failedReason, NSInteger code) {
        failed(failedReason);
    }];
}

- (void)sureAcceptGoodsWithOrderId:(NSString *)orderId {
    XKWeakSelf(ws);
    
    [XKMallOrderViewModel sureAcceptMallOrderWithOrderId:orderId Success:^(id data) {
        if (ws.sureOrderBlock) {
            ws.sureOrderBlock(nil);
        }
    } failed:^(NSString *failedReason, NSInteger code) {
        [XKHudView showErrorMessage:failedReason];
    }];
}

- (void)cancelGoodsReturnWithRefundId:(MallOrderListDataItem *)item suucessBlock:(void(^)(id data))success failedBlock:(void(^)(NSString *reason))failed {
    [XKHudView showLoadingTo:self.view animated:YES];
    [XKMallOrderViewModel cancelGoodsReturnWithRefundId:item.refundId Success:^(id data) {
        if (self.cancelRefundBlock) {
            self.cancelRefundBlock();
        }
    } failed:^(NSString *failedReason, NSInteger code) {
         [XKHudView showErrorMessage:failedReason];
    }];
}

- (void)moreBtnClickForList:(UIButton *)sender withGoodsItem:(MallOrderListDataItem *)item functionName:(NSArray *)functionName {
    XKWeakSelf(ws);//
    XKMenuView *moreMenuVuew = [XKMenuView menuWithTitles:functionName images:nil width:80 relyonView:sender clickBlock:^(NSInteger index, NSString *text) {
        if ([text isEqualToString:@"退货"]) {
            [ws goodsReturnWithListOrderWithGoodsItem:item withStatus:OrderStatusWaitAccept];
        } else if ([text isEqualToString:@"联系客服"]) {
            [ws chatWithCustomerServiceWithGoodsItem];
        } else if ([text isEqualToString:@"取消订单"]) {
            [ws presentViewController:ws.cancelAlert animated:YES completion:nil];
        } else if ([text isEqualToString:@"查看物流"]) {
            XKMallOrderTraceViewController *trace = [XKMallOrderTraceViewController new];
            trace.orderId = item.orderId;
            [ws.navigationController pushViewController:trace animated:YES];
        }
    }];
    moreMenuVuew.textFont = XKRegularFont(12);
    moreMenuVuew.textColor = UIColorFromRGB(0x222222);
    [moreMenuVuew show];
}

- (void)moreBtnClickForDetail:(UIButton *)sender withGoodsItem:(XKMallOrderDetailViewModel *)item functionName:(NSArray *)functionName {
    XKWeakSelf(ws);//
    XKMenuView *moreMenuVuew = [XKMenuView menuWithTitles:functionName images:nil width:80 relyonView:sender clickBlock:^(NSInteger index, NSString *text) {
        if ([text isEqualToString:@"退货"]) {
            [ws goodsReturnWithDetailOrderWithGoodsItem:item withStatus:OrderStatusWaitAccept];
        } else if ([text isEqualToString:@"联系客服"]) {
            [ws chatWithCustomerServiceWithGoodsItem];
        } else if ([text isEqualToString:@"取消订单"]) {
            [ws presentViewController:ws.cancelAlert animated:YES completion:nil];
        } else if ([text isEqualToString:@"查看物流"]) {
            XKMallOrderTraceViewController *trace = [XKMallOrderTraceViewController new];
            trace.orderId = item.orderId;
            [ws.navigationController pushViewController:trace animated:YES];
        }
    }];
    moreMenuVuew.textFont = XKRegularFont(12);
    moreMenuVuew.textColor = UIColorFromRGB(0x222222);
    [moreMenuVuew show];
}

- (UIAlertController *)cancelAlert {
    if(!_cancelAlert) {
        XKWeakSelf(ws);
        _cancelAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要取消订单吗" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [ws.cancelAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (ws.cancelOrderBlock) {
                ws.cancelOrderBlock();
            }
            [ws.cancelAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [_cancelAlert addAction:sure];
        [_cancelAlert addAction:cancel];
    }
    return _cancelAlert;
}
@end
