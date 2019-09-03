//
//  XKTradingAreaOrderSeviceRefundCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderItems;

typedef void(^LookDetailBlock)(void);

@interface XKTradingAreaOrderSeviceRefundCell : UITableViewCell

@property (nonatomic, copy  ) LookDetailBlock  lookDetailBlock;

- (void)setValueWithModel:(OrderItems *)model shopName:(NSString *)shopName;

@end
