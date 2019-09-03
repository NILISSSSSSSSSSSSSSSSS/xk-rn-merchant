//
//  XKReceiveCardModel.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKReceiveCardModel : NSObject

@property (nonatomic, copy) NSString *cardType;

@property (nonatomic, copy) NSString *discount;

@property (nonatomic, assign) NSInteger invalidTime;

@property (nonatomic, copy) NSString *memberId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy) NSString *shopName;

@property (nonatomic, copy) NSString *shopPic;

@property (nonatomic, assign) NSInteger totalNum;

@property (nonatomic, assign) NSInteger validTime;

// 是否是晓可卡
@property (nonatomic, assign) BOOL isXKCard;
// 是否已领取
@property (nonatomic, assign) BOOL isReceived;
// 是否已购买
@property (nonatomic, assign) BOOL isBought;

@end

NS_ASSUME_NONNULL_END
