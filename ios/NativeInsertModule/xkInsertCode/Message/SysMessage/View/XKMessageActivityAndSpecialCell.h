//
//  XKMessageActivityAndSpecialCell.h
//  XKSquare
//
//  Created by Lin Li on 2018/11/20.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKSysDetailMessageModel.h"
typedef void (^delBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface XKMessageActivityAndSpecialCell : UITableViewCell

@property(nonatomic, strong) XKSysDetailMessageModelDataItem *model;
/**删除block*/
@property(nonatomic, copy) delBlock delBlock;

@end

NS_ASSUME_NONNULL_END
