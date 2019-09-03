//
//  XKIMMessageCouponAttachment.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/15.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageCouponAttachment : XKIMMessageBaseAttachment
// 券ID
@property (nonatomic, copy) NSString *voucherId;
// 券名称
@property (nonatomic, copy) NSString *voucherName;
// 券类型 1 晓可券 2 商户券
@property (nonatomic, assign) NSUInteger voucherType;
// 券子类型 1 折扣券 2 满减券 3 抵扣券
@property (nonatomic, assign) NSUInteger voucherSubType;
// 券的值, 如果是折扣券,就是折扣比例 遵循后台规则（4折，则传输时使用400）; 如果是满减券,就是减少的金额（分为单位）; 如果是抵扣券,就是抵扣的金额（分为单位）.
@property (nonatomic, assign) double voucherValue;
// 券使用范围
@property (nonatomic, copy) NSString *voucherScope;
// 券有效期开始时间
@property (nonatomic, assign) NSUInteger voucherStartTime;
// 券有效期结束时间
@property (nonatomic, assign) NSUInteger voucherEndTime;

@end

NS_ASSUME_NONNULL_END
