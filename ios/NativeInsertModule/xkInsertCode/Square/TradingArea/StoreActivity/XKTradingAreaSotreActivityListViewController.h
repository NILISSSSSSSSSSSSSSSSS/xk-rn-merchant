//
//  XKTradingAreaSotreActivityListViewController.h
//  XKSquare
//
//  Created by hupan on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    ActivityListType_reward,//抽奖
    ActivityListType_coupon,//优惠券
    ActivityListType_card,//会员卡
} ActivityListType;

@interface XKTradingAreaSotreActivityListViewController : BaseViewController

@property (nonatomic, assign) ActivityListType activityListType;
@property (nonatomic, copy  ) NSString          *shopId;

@end
