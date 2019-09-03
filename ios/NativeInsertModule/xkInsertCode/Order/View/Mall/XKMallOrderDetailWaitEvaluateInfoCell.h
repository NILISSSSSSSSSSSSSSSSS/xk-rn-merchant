//
//  XKMallOrderDetailWaitEvaluateInfoCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMallOrderDetailViewModel.h"
@interface XKMallOrderDetailWaitEvaluateInfoCell : UITableViewCell
@property (nonatomic, copy)void(^downLoadBlock)(UIButton *sender);
//type 0 订单编号  1 支付方式  2物流公司 3收货时间
- (void)handleWaitPayOrderDetailModel:(XKMallOrderDetailViewModel *)model withType:(NSInteger)type;
@end
