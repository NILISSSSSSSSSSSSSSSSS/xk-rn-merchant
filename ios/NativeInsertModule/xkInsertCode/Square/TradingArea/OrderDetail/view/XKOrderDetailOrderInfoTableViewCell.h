//
//  XKOrderDetailOrderInfoTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    OrderInfoCellType_orderInfo,
    OrderInfoCellType_goodsInfo,
} OrderInfoCellType;

@interface XKOrderDetailOrderInfoTableViewCell : UITableViewCell

@property (nonatomic, assign) OrderInfoCellType cellType;

- (void)setValueWithDic:(NSDictionary *)dic;

@end
