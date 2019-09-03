//
//  XKTradingAreaOrderDetailBaseAdapter.m
//  XKSquare
//
//  Created by hupan on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderDetailBaseAdapter.h"
#import "XKTradingAreaOrderDetaiModel.h"

@interface XKTradingAreaOrderDetailBaseAdapter ()

@end


@implementation XKTradingAreaOrderDetailBaseAdapter

#pragma mark - UITableViewDelegate & UITableViewDataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
}


#pragma mark - setter

- (NSMutableArray *)purchaseMuarr {
    if (!_purchaseMuarr) {
        _purchaseMuarr = [NSMutableArray array];
    }
    return _purchaseMuarr;
}

- (void)setOrderModel:(XKTradingAreaOrderDetaiModel *)orderModel {
    _orderModel = orderModel;
    /*
     服务类或者住宿类SERVICE_OR_STAY，外卖类TAKE_OUT，现场购物类LOCALE_BUY，服务+现场购物SERVICE_AND_LOCALE_BUY，商家手动下单SHOP_HAND_ORDER
     */
    //判断业务场景
    NSString *type = orderModel.sceneStatus;
    if ([type isEqualToString:@"SERVICE_OR_STAY"]) {
        //酒店和服务唯一区别：酒店是时间段  服务是一个时间
        NSArray *timeArr = [orderModel.appointRange componentsSeparatedByString:@"-"];
        if (timeArr.count == 2) {//酒店列表
            self.orderType = OrderDetailType_hotel;
        } else {
            self.orderType = OrderDetailType_service;
        }
    } else if ([type isEqualToString:@"TAKE_OUT"]) {
        self.orderType = OrderDetailType_online;
        
        if (orderModel.isSelfLifting) {
            self.takeoutWay = 1;
        } else {
            self.takeoutWay = 0;
        }
    } else if ([type isEqualToString:@"SERVICE_AND_LOCALE_BUY"]) {
        self.orderType = OrderDetailType_service;
    } else if ([type isEqualToString:@"LOCALE_BUY"]) {
        self.orderType = OrderDetailType_offline;
    }
    
    /*
     服务类或者住宿类   SERVICE_OR_STAY     STAY_ORDER    待接单
                                         STAY_PAY    已接单=待付款
                                         STAY_CONSUMPTION    待消费 必须是 服务类的商家状态是已接单 作为定金或者没有的时候必须是已支付状态
                                         STAY_EVALUATE    待评价 用户到店消费就直接变成待评价了
                                         COMPLETELY    取消订单=已评价=完成=已关闭
     
     外卖类TAKE_OUT   STAY_ORDER    待接单
                     STAY_PAY    已接单=待付款
                     STOCK_CENTRE    已支付=备货中
                     PROCESS_CENTRE    已发货=进行中
                     SHOP_DELIVERY    商家已送达
                     STAY_EVALUATE    已收货=待评价
                     COMPLETELY    取消订单=已评价=完成=已关闭
     
     现场购物类LOCALE_BUY      STAY_ORDER    待接单
                             CONSUMPTION_CENTRE    已接单=进行中=消费中
                             AGREE_PAY    用户已发起结算动作=代商户发起结算
                             STAY_CLEARING    商户已发起结算=待用户付款
                             STAY_EVALUATE    用户已结算=用户已付款=待评价
                             COMPLETELY    取消订单=已评价=完成
     
     服务+现场购物SERVICE_AND_LOCALE_BUY   STAY_ORDER    待接单
                                         STAY_PAY    已接单=待付款
                                         STAY_CONSUMPTION    待消费 必须是 服务类的商家状态是已接单 作为定金必须是已支付状态
                                         CONSUMPTION_CENTRE    进行中=消费中
                                         AGREE_PAY    用户已发起结算动作=代商户发起结算
                                         STAY_CLEARING    商户已发起结算=待用户付款
                                         STAY_EVALUATE    已结算=待评价
                                         COMPLETELY    取消订单=已评价=完成
     */
    
    //判断订单状态
    
    //先判断是否是售后
    if ([orderModel.status isEqualToString:@"del"] && orderModel.isAgree == 0) {
        self.orderStatus = OrderStatus_afterSale;
    } else if ([orderModel.orderStatus isEqualToString:@"STAY_ORDER"]) {
        self.orderStatus = OrderStatus_pick;
    } else if ([orderModel.orderStatus isEqualToString:@"STAY_PAY"]) {
        self.orderStatus = OrderStatus_pay;
    } else if ([orderModel.orderStatus isEqualToString:@"STAY_CONSUMPTION"]) {
        self.orderStatus = OrderStatus_use;
    } else if ([orderModel.orderStatus isEqualToString:@"STOCK_CENTRE"]) {
        self.orderStatus = OrderStatus_prepare;
    } else if ([orderModel.orderStatus isEqualToString:@"CONSUMPTION_CENTRE"] ||
               [orderModel.orderStatus isEqualToString:@"PROCESS_CENTRE"] ||
               [orderModel.orderStatus isEqualToString:@"SHOP_DELIVERY"] ||
               [orderModel.orderStatus isEqualToString:@"STAY_CLEARING"] ||
               [orderModel.orderStatus isEqualToString:@"AGREE_PAY"]) {
        self.orderStatus = OrderStatus_useing;
    } else if ([orderModel.orderStatus isEqualToString:@"STAY_EVALUATE"]) {
        self.orderStatus = OrderStatus_evaluate;
    } else if ([orderModel.orderStatus isEqualToString:@"COMPLETELY"] && [orderModel.status isEqualToString:@"active"] && orderModel.isAgree == 0) {
        self.orderStatus = OrderStatus_finsh;
    } else if ([orderModel.orderStatus isEqualToString:@"COMPLETELY"] && [orderModel.status isEqualToString:@"del"] && orderModel.isAgree == 1) {
        self.orderStatus = OrderStatus_close;
    }

    /*else if ([orderModel.payStatus isEqualToString:@"APPLY_REFUND"]) {
        self.orderStatus = OrderStatus_refunding;
    } else if (([orderModel.payStatus isEqualToString:@"NOT_PAY"] || [orderModel.payStatus isEqualToString:@"DURING_PAY"] || [orderModel.payStatus isEqualToString:@"FAILED_PAY"]) && [orderModel.status isEqualToString:@"active"] && orderModel.isAgree == 0) {
        self.orderStatus = OrderStatus_canceling;
    }*/

    self.showPurchaseBtn = NO;
    
    if (orderModel.isPurchased) {//可加购
        //现场购物 或者 服务+加购
        if ([orderModel.sceneStatus isEqualToString:@"LOCALE_BUY"]) {
            //现场购物
            if ([orderModel.orderStatus isEqualToString:@"CONSUMPTION_CENTRE"] ||
                [orderModel.orderStatus isEqualToString:@"AGREE_PAY"]) {
                self.showPurchaseBtn = YES;
            }
        } else if ([orderModel.sceneStatus isEqualToString:@"SERVICE_AND_LOCALE_BUY"]) {
            //免费下单或者0元下单 定金类DEPOSIT(1)，免费类FREE(2)，O元服务类ZERO_ORDER(3)，其他OTHER(4)
            if ([orderModel.orderType isEqualToString:@"2"] || [orderModel.orderType isEqualToString:@"3"]) {
                if ([orderModel.orderStatus isEqualToString:@"STAY_PAY"] ||
                    [orderModel.orderStatus isEqualToString:@"STAY_CONSUMPTION"] ||
                    [orderModel.orderStatus isEqualToString:@"CONSUMPTION_CENTRE"] ||
                    [orderModel.orderStatus isEqualToString:@"AGREE_PAY"]) {
                    
                    self.showPurchaseBtn = YES;
                }
            } else {
                if ([orderModel.orderStatus isEqualToString:@"STAY_CONSUMPTION"] ||
                    [orderModel.orderStatus isEqualToString:@"CONSUMPTION_CENTRE"] ||
                    [orderModel.orderStatus isEqualToString:@"AGREE_PAY"]) {
                    
                    self.showPurchaseBtn = YES;
                }
            }
        }
    }

    //商品以及对应的加购
    if (self.purchaseMuarr.count) {
        [self.purchaseMuarr removeAllObjects];
    }
    if (orderModel.isPurchased) {//可加购 空的数组也要加进来
        [self.purchaseMuarr addObjectsFromArray:orderModel.items];
    }
    
    //遍历加购商品总数 以及价格
    self.goodsPrice = 0;
    self.addGoodsNum = 0;
    self.addGoodsPrice = 0;
    
    //外卖类 或者 纯服务
    if ([type isEqualToString:@"SERVICE_OR_STAY"]
        || [type isEqualToString:@"TAKE_OUT"]) {
        for (OrderItems *tiems in orderModel.items) {
            self.goodsPrice += tiems.platformShopPrice.floatValue;
        }
    } else {
        //服务+加购、现场购物（当0元服务+加购处理）
        for (OrderItems *tiems in orderModel.items) {
            self.goodsPrice += tiems.platformShopPrice.floatValue;
            for (PurchasesItem *item in tiems.purchases) {
                self.addGoodsNum += 1;
                self.addGoodsPrice += item.platformShopPrice.floatValue;
            }
        }
    }
    self.goodsPrice = self.goodsPrice / 100.0;
    self.addGoodsPrice = self.addGoodsPrice / 100.0;
    
    [self.tableView reloadData];
}


#pragma mark - getter
- (OrderDetailType)getOrderIndustryType {
    return self.orderType;
}

@end
