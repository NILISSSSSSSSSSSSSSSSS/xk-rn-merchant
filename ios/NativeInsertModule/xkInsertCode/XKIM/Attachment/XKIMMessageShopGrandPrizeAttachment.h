//
//  XKIMMessageShopGrandPrizeAttachment.h
//  XKSquare
//
//  Created by xudehuai on 2019/5/20.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageShopGrandPrizeAttachment : XKIMMessageBaseAttachment
// 期ID
@property (nonatomic, copy) NSString *periodId;
// 订单ID
@property (nonatomic, copy) NSString *orderId;
// 大奖图片URL
@property (nonatomic, copy) NSString *lotteryImgUrl;
// 大奖标题
@property (nonatomic, copy) NSString *lotteryTitle;
// 大奖奖品名称
@property (nonatomic, copy) NSString *lotteryPrizeName;
// 大奖奖品规格
@property (nonatomic, copy) NSString *lotteryPrizeSpecification;
// 是否开奖
@property (nonatomic, assign) BOOL lotteryIsOpened;
// 消息发送者是否中奖
@property (nonatomic, assign) BOOL messageSenderIsWinner;

@end

NS_ASSUME_NONNULL_END
