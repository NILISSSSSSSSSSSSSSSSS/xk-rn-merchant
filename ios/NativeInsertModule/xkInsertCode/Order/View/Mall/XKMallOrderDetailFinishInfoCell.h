//
//  XKMallOrderDetailFinishInfoCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMallOrderDetailViewModel.h"
@interface XKMallOrderDetailFinishInfoCell : UITableViewCell
- (void)handleWaitPayOrderDetailModel:(XKMallOrderDetailViewModel *)model;
@property (nonatomic, copy)void(^downLoadBlock)(UIButton *sender);

@end
