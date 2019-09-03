//
//  XKLatestSecretViewController.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/24.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_OPTIONS(NSUInteger, XKLatestSecretVCType) {
    XKLatestSecretVCTypeLatestSecret = 1 << 0,      // 最新揭秘
    XKLatestSecretVCTypeShopGrandPrize = 1 << 1,    // 店铺大奖
};

NS_ASSUME_NONNULL_BEGIN

@interface XKLatestSecretViewController : BaseViewController

@property (nonatomic, assign) XKLatestSecretVCType vcType;

@end

NS_ASSUME_NONNULL_END
