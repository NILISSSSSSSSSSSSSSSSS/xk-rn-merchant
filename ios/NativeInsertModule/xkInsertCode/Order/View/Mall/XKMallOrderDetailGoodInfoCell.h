//
//  XKMallOrderDetailGoodInfoCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMallOrderDetailViewModel.h"
#import "XKMallBuyCarViewModel.h"
@interface XKMallOrderDetailGoodInfoCell : UITableViewCell
- (void)handleWaitPayOrderDetailModel:(XKMallOrderDetailGoodsItem *)model;

- (void)bindItem:(XKMallBuyCarItem *)item;
@end
