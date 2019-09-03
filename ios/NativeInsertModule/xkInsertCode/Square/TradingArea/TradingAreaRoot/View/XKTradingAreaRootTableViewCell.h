//
//  XKTradingAreaRootTableViewCell.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKTradingShopListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKTradingAreaRootTableViewCell : UITableViewCell
/**contentView*/
@property(nonatomic, strong) UIView *myContentView;
@property(nonatomic, strong) XKTradingShopListDataItem *model;

@end

NS_ASSUME_NONNULL_END
