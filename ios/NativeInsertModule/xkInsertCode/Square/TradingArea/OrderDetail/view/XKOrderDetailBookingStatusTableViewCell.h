//
//  XKOrderDetailBookingStatusTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XKTradingAreaOrderDetaiModel;

typedef void(^RefreshOrderDetailBlock)(void);

@interface XKOrderDetailBookingStatusTableViewCell : UITableViewCell

@property (nonatomic, copy  ) RefreshOrderDetailBlock  refreshOrderDetailBlock;

- (void)setValueWithModel:(XKTradingAreaOrderDetaiModel *)model orderType:(NSInteger)orderType orderStatus:(NSInteger)status;

@end
