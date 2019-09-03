//
//  XKStoreEstimateDetailListViewController.h
//  XKSquare
//
//  Created by hupan on 2018/9/21.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    EstimateDetailListType_goods,
    EstimateDetailListType_shop,
} EstimateDetailListType;

@interface XKStoreEstimateDetailListViewController : BaseViewController

@property (nonatomic, assign) EstimateDetailListType type;
@property (nonatomic, copy  ) NSString               *goodsId;
@property (nonatomic, copy  ) NSString               *shopId;

@end
