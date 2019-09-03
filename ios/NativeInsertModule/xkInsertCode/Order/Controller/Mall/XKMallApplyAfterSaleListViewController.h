//
//  XKMallApplyAfterSaleListViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
#import "XKMallOrderApplyRefundViewController.h"
#import "XKMallOrderViewModel.h"
typedef NS_ENUM(NSInteger, XKApplyEnterType) {
    XKApplyEnterTypeList = 0,
    XKApplyEnterTypeDetail
};
@interface XKMallApplyAfterSaleListViewController : BaseViewController
@property (nonatomic, assign) OrderStatus  status;
@property (nonatomic, copy) NSString  *orderId;
@property (nonatomic, strong) NSArray  *goodsArr;
@property (nonatomic, assign) XKApplyEnterType  applyType;
@end
