//
//  XKLotteryTicketChooseNumberCollectionViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/3.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKLotteryTicketChooseNumberCollectionViewCell : UICollectionViewCell

- (void)configCellWithNumber:(NSUInteger)number;

- (void)setCellSelected:(BOOL)selected tintColor:(UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
