//
//  XKIMMessageShareWelfareAttachment.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageShareWelfareAttachment : XKIMMessageBaseAttachment

// 福利Id 也就是福利的主键Id
@property (nonatomic, copy) NSString *welfareId;
// 商品Id
@property (nonatomic, copy) NSString *goodsId;
// 期Id
@property (nonatomic, copy) NSString *sequenceId;
// 订单Id
@property (nonatomic, copy) NSString *orderId;
// 福利封面
@property (nonatomic, copy) NSString *welfareIconUrl;
// 福利名称
@property (nonatomic, copy) NSString *welfareName;
// 福利描述
@property (nonatomic, copy) NSString *welfareDescription;
// 价格(分)
@property (nonatomic, assign) CGFloat welfarePrice;
// 来源
@property (nonatomic, copy) NSString *messageSourceName;
// 是否开奖
@property (nonatomic, assign) BOOL lotteryIsOpened;
// 消息发送者是否中奖
@property (nonatomic, assign) BOOL messageSenderIsWinner;

@end

NS_ASSUME_NONNULL_END
