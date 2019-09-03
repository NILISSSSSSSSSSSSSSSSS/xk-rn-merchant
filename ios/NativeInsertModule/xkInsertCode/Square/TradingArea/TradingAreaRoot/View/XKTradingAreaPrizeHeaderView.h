//
//  XKTradingAreaPrizeHeaderView.h
//  XKSquare
//
//  Created by Lin Li on 2018/11/6.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKTradingAreaPrizeHeaderView : UIView
@property (nonatomic, copy)void(^distanceBClickBlock)(UIButton *sender);
@property (nonatomic, copy)void(^priceBClickBlock)(UIButton *sender);
@end

NS_ASSUME_NONNULL_END
