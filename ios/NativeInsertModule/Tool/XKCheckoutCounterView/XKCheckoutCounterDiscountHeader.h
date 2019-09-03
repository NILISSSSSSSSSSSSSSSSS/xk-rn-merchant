//
//  XKCheckoutCounterDiscountHeader.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/5.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKCheckoutCounterDiscountHeader : UIView

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *ratioLab;

@property (nonatomic, strong) UISwitch *switchControl;

@property (nonatomic, copy) void(^switchBlock)(BOOL isOn);

@end

NS_ASSUME_NONNULL_END
