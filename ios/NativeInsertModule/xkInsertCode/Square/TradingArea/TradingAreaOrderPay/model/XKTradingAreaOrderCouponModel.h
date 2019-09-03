//
//  XKTradingAreaOrderCouponModel.h
//  XKSquare
//
//  Created by hupan on 2018/11/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKTradingAreaOrderCouponModel : NSObject

@property (nonatomic , copy) NSString              * cardId;
@property (nonatomic , copy) NSString              * cardMessage;
@property (nonatomic , copy) NSString              * cardName;
@property (nonatomic , copy) NSString              * cardType;
@property (nonatomic , copy) NSString              * condition;
@property (nonatomic , copy) NSString              * couponType;
@property (nonatomic , assign) NSInteger            ID;
@property (nonatomic , copy) NSString              * invalidTime;
@property (nonatomic , copy) NSString              * validTime;
@property (nonatomic , copy) NSString              * price;
@property (nonatomic , assign) NSInteger           state;

@end
