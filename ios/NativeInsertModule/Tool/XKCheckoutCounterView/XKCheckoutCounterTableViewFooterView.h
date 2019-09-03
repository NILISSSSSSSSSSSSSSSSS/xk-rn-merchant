//
//  XKCheckoutCounterTableViewFooterView.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKCheckoutCounterTableViewFooterView : UIView

@property (nonatomic, copy) void (^payBtnBlock)(void);

@end

NS_ASSUME_NONNULL_END
