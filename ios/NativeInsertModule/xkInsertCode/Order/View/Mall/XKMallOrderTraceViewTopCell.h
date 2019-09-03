//
//  XKMallOrderTraceViewTopCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKOrderTransportInfoModel.h"
@interface XKMallOrderTraceViewTopCell : UITableViewCell
- (void)bindModel:(XKOrderTransportInfoModel *)model withOrderId:(NSString *)orderId;
@end
