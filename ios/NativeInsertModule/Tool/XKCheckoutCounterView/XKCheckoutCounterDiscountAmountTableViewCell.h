//
//  XKCheckoutCounterDiscountAmountTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKCheckoutCounterDiscountAmountTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *useLab;

@property (nonatomic, strong) UITextField *discountAmountTF;

- (void)setCellEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
