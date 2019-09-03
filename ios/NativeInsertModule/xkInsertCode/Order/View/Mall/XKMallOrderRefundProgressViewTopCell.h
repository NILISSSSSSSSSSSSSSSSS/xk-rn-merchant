//
//  XKMallOrderRefundProgressViewTopCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMallOrderDetailViewModel.h"
@interface XKMallOrderRefundProgressViewTopCell : UITableViewCell
- (void)updateInfoWithModel:(XKMallOrderDetailViewModel *)model;
@end
