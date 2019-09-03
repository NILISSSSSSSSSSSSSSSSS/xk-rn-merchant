//
//  XKWelfareOrderWinCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
#import "XKWelfareOrderListViewModel.h"
#import "XKMallBuyCarViewModel.h"
@interface XKWelfareOrderWinCell : XKBaseTableViewCell
- (void)bindData:(WelfareOrderDataItem *)item;
- (void)bindItem:(XKMallBuyCarItem *)item;
@end
