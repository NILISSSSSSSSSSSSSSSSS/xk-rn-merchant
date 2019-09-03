//
//  XKMessageShoppingMallViewModel.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/19.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMessageShoppingMallViewModel.h"
#import "XKMessageShoppingMallTableViewCell.h"
#import "XKMallGoodsDetailViewController.h"
#import "XKMallOrderDetailWaitAcceptViewController.h"
static NSString * const cellID  = @"cell";

@interface XKMessageShoppingMallViewModel()

@end

@implementation XKMessageShoppingMallViewModel

- (void)registerCellForTableView:(UITableView *)tableView {
    [tableView registerClass:[XKMessageShoppingMallTableViewCell class] forCellReuseIdentifier:cellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKMessageShoppingMallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    XKSysDetailMessageModelDataItem *model = self.dataArray[indexPath.row];
    XKWeakSelf(ws);
    cell.titleLabelTapBlock = ^{
        if (ws.type == XKShoppingSysMessageControllerType) {
            [ws jumpToShoppingOrderVc:model];
        }else if (ws.type == XKMallSysMessageControllerType){
            [ws jumpToMallOrderVc:model];
        }
    };
    
    cell.goodsTapBlock = ^{
        if (ws.type == XKShoppingSysMessageControllerType) {
            [ws jumpToShoppingGoodsVc:model.extras.goodsId];
        }else if (ws.type == XKMallSysMessageControllerType){
            [ws jumpToMallGoodsVc:model.extras.goodsId];
        }
    };
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 159;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKSysDetailMessageModelDataItem *model = self.dataArray[indexPath.row];
    if (self.type == XKShoppingSysMessageControllerType) {
        [self jumpToShoppingOrderVc:model];
    }
    else if (self.type == XKMallSysMessageControllerType){
        [self jumpToMallOrderVc:model];
    }
    if (self.selectBlock) {
        self.selectBlock(indexPath);
    }
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    return @[deleteAction];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

#pragma mark 自营商城
//跳转到自营商城商品
- (void)jumpToShoppingGoodsVc:(NSString *)goodsId {
    XKWeakSelf(ws);
    XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
    detail.goodsId = goodsId;
    [[ws getCurrentUIVC].navigationController pushViewController:detail animated:YES];
}

//跳转到自营商城订单
- (void)jumpToShoppingOrderVc:(XKSysDetailMessageModelDataItem *)model {
    XKWeakSelf(ws);
    
    //购买订单推送
    if (model.extras.orderStatus) {
    //待支付
    if ([model.extras.orderStatus isEqualToString:mallMessageOderPrePayStatus]) {
        
    }
    //待配送
    else if ([model.extras.orderStatus isEqualToString:mallMessageOderPreShipStatus]){
        
    }
    //待收货1
    else if ([model.extras.orderStatus isEqualToString:mallMessageOderPreReceviceStatus]){
        XKMallOrderDetailWaitAcceptViewController *vc = [XKMallOrderDetailWaitAcceptViewController new];
        vc.orderId = model.extras.orderId;
        [[ws getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
    //待评价
    else if ([model.extras.orderStatus isEqualToString:mallMessageOderPreEvaluateStatus]){
        
    }
    //已完成
    else if ([model.extras.orderStatus isEqualToString:mallMessageOderCompletelyStatus]){
        
    }
        
  }
 
    //退货推送
    if (model.extras.refundStatus) {
        //未退款
        if ([model.extras.refundStatus isEqualToString:mallMessageRefundOderStatusNONE]) {
            
        }
        //已申请1
        else if ([model.extras.refundStatus isEqualToString:mallMessageRefundOderStatusAPPLY]){
            
        }
        //未通过1
        else if ([model.extras.refundStatus isEqualToString:mallMessageRefundOderStatusREFUSED]){
          
        }
        //待用户发货
        else if ([model.extras.refundStatus isEqualToString:mallMessageRefundOderStatusPREUSERSHIP]){
            
        }
        //待平台收货1
        else if ([model.extras.refundStatus isEqualToString:mallMessageRefundOderStatusPREPLATRECEIVE]){
            
        }
        //待平台退货
        else if ([model.extras.refundStatus isEqualToString:mallMessageRefundOderStatusPREREFUND]){
            
        }
        //退款中1
        else if ([model.extras.refundStatus isEqualToString:mallMessageRefundOderStatusREFUNDING]){
            
        }
        //退款完成
        else if ([model.extras.refundStatus isEqualToString:mallMessageRefundOderStatusCOMPLETE]){
            
        }
    }

}

#pragma mark 福利商城

//跳转到福利商城商品
- (void)jumpToMallGoodsVc:(NSString *)goodsId {
    XKWeakSelf(ws);
    XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
    detail.goodsId = goodsId;
    [[ws getCurrentUIVC].navigationController pushViewController:detail animated:YES];
}


//跳转到自营商城订单
- (void)jumpToMallOrderVc:(XKSysDetailMessageModelDataItem *)model {
    XKWeakSelf(ws);
    //待支付
    if ([model.extras.orderStatus isEqualToString:mallMessageOderPrePayStatus]) {
        
    }
    //待配送
    else if ([model.extras.orderStatus isEqualToString:mallMessageOderPreShipStatus]){
        
    }
    //待收货
    else if ([model.extras.orderStatus isEqualToString:mallMessageOderPreReceviceStatus]){
       
    }
    //待评价
    else if ([model.extras.orderStatus isEqualToString:mallMessageOderPreEvaluateStatus]){
        
    }
    //已完成
    else if ([model.extras.orderStatus isEqualToString:mallMessageOderCompletelyStatus]){
        
    }
}
@end
