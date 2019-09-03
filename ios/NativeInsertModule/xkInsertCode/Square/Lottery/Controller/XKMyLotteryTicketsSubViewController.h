//
//  XKMyLotteryTicketsSubViewController.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/5.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, XKMyLotteryTicketsVCType) {
    XKMyLotteryTicketsVCTypeActivity = 1 << 0, // 活动
    XKMyLotteryTicketsVCTypePlatform = 1 << 1, // 平台
    XKMyLotteryTicketsVCTypeMerchant = 1 << 2, // 商铺
};

NS_ASSUME_NONNULL_BEGIN

@interface XKMyLotteryTicketsSubViewController : UIViewController

@property (nonatomic, assign) XKMyLotteryTicketsVCType vcType;

@end

NS_ASSUME_NONNULL_END
