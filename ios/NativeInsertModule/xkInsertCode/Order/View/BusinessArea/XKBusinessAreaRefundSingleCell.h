//
//  XKBusinessAreaRefundSingleCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
@class AreaOrderListModel;

@interface XKBusinessAreaRefundSingleCell : XKBaseTableViewCell

- (void)bindData:(AreaOrderListModel *)item;

@end
