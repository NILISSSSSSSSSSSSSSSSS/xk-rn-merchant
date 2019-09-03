//
//  XKCheckoutCounterPaymentMethodTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKCheckoutCounterPaymentMethodTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *subTitleLab;

@property (nonatomic, strong) UIButton *chooseBtn;

@end

NS_ASSUME_NONNULL_END
