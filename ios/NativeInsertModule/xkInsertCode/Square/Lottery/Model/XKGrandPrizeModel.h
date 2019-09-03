//
//  XKGrandPrizeModel.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/25.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, XKGrandPrizeModelStatus) {
    XKGrandPrizeModelStatusNotWon = 1 << 0, // 未中奖
    XKGrandPrizeModelStatusWonButNotShare = 1 << 1, // 中奖但未分享
    XKGrandPrizeModelStatusWonButNotConfirmOrder = 1 << 2, // 中奖但未确认订单
    XKGrandPrizeModelStatusWonButNotShowOrder = 1 << 3, // 中奖但未晒单
    XKGrandPrizeModelStatusWonButAndShownOrder = 1 << 4, // 中奖已晒单
};

NS_ASSUME_NONNULL_BEGIN

@interface XKGrandPrizeModel : NSObject

@end

NS_ASSUME_NONNULL_END
