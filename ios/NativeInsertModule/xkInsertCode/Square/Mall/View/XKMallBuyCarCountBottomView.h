//
//  XKMallBuyCarCountBottomView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/25.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKMallBuyCarCountBottomView : UIView
@property (nonatomic, strong) void (^payBlock)(UIButton *sender);
@property (nonatomic, assign) CGFloat  totalPrice;
@end

NS_ASSUME_NONNULL_END
