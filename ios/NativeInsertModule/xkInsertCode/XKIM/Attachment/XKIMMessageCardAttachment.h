//
//  XKIMMessageCardAttachment.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/15.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageCardAttachment : XKIMMessageBaseAttachment
// 卡ID
@property (nonatomic, copy) NSString *cardId;
// 卡名称
@property (nonatomic, copy) NSString *cardName;
// 卡类型 1 晓可卡 2 商户卡
@property (nonatomic, assign) NSUInteger cardType;
// 卡自类型 1 会员卡 2 普通卡
@property (nonatomic, assign) NSUInteger cardSubType;;
// 折扣 0-1
@property (nonatomic, assign) double cardDiscount;
// 卡使用范围
@property (nonatomic, copy) NSString *cardScope;
// 卡有效期开始时间
@property (nonatomic, assign) NSUInteger cardStartTime;
// 卡有效期结束时间
@property (nonatomic, assign) NSUInteger cardEndTime;

@end

NS_ASSUME_NONNULL_END
