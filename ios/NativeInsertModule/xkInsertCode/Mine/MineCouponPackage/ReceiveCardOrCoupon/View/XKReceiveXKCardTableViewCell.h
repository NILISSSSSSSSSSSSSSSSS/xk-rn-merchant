//
//  XKReceiveXKCardTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKReceiveCardModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKReceiveXKCardTableViewCell : UITableViewCell

- (void)configCellWithCardModel:(XKReceiveCardModel *) XKCard;

@end

NS_ASSUME_NONNULL_END
