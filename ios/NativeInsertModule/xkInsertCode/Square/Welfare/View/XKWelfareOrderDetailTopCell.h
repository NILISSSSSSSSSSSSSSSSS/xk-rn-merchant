//
//  XKWelfareOrderDetailTopCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMallOrderDetailViewModel.h"
#import "XKMallOrderViewModel.h"
#import "XKWelfareOrderListViewModel.h"
#import "XKWelfareOrderDetailViewModel.h"
typedef NS_ENUM(NSInteger, WelfareOrderType) {
    WelfareOrderTypePre_send = 0,//待发货
    WelfareOrderTypePre_recevice,//待收货
    WelfareOrderTypeReceviced,//已收货
    WelfareOrderTypeNotShare//未分享
};
@interface XKWelfareOrderDetailTopCell : UITableViewCell

/**
 商城订单详情信息

 @param orderType 订单类型
 @param model 数据模型
 */
- (void)handleOrderDetailWithType:(MallOrderType)orderType dataModel:(XKMallOrderDetailViewModel *)model;

/**
 福利订单详情信息
 
 @param orderType 订单类型
 @param model 数据模型
 */
- (void)handleWelfareOrderDetailWithType:(WelfareOrderType)orderType dataModel:(XKWelfareOrderDetailViewModel *)model;
@end
