//
//  XKMessageShoppingMallTableViewCell.h
//  XKSquare
//
//  Created by Lin Li on 2018/11/19.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKSysDetailMessageModel.h"
typedef void (^tapBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface XKMessageShoppingMallTableViewCell : UITableViewCell
@property(nonatomic, strong) XKSysDetailMessageModelDataItem *model;
/**标题点击block*/
@property(nonatomic, copy) tapBlock titleLabelTapBlock;

/**物品点击block*/
@property(nonatomic, copy) tapBlock goodsTapBlock;
@end

NS_ASSUME_NONNULL_END
