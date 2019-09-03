//
//  XKMyGrandPrizesSubViewController.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/25.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"

@class XKGrandPrizeModel;

typedef NS_OPTIONS(NSUInteger, XKMyGrandPrizeSubVCType) {
    XKMyGrandPrizeSubVCTypeWaitingChooseNums    = 1 << 0, // 待选号
    XKMyGrandPrizeSubVCTypeWaiting              = 1 << 1, // 待开奖
    XKMyGrandPrizeSubVCTypeAlready              = 1 << 2, // 已开奖
};

NS_ASSUME_NONNULL_BEGIN

@interface XKMyGrandPrizesSubViewController : UIViewController

@property (nonatomic, assign) XKMyGrandPrizeSubVCType vcType;


@end

NS_ASSUME_NONNULL_END
