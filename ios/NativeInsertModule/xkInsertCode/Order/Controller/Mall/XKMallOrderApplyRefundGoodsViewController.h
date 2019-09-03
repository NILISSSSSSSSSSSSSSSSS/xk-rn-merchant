//
//  XKMallOrderApplyRefundGoodsViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/7.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"
#import "XKMallOrderViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XKMallOrderApplyRefundGoodsViewController : BaseViewController
@property (nonatomic, strong) NSArray  *goodsArr;
@property (nonatomic, copy) NSString  *refundType;
@property (nonatomic, copy) NSString  *orderId;

@property (nonatomic, strong) MallOrderListDataItem  *item;
@end

NS_ASSUME_NONNULL_END
