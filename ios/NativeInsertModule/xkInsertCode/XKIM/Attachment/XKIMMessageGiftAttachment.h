//
//  XKIMMessageGiftAttachment.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageGiftAttachment : XKIMMessageBaseAttachment

// 礼物ID
@property (nonatomic, copy) NSString *giftId;
// 礼物名称
@property (nonatomic, copy) NSString *giftName;
// 礼物图片
@property (nonatomic, copy) NSString *giftIconUrl;
// 礼物数量
@property (nonatomic, assign) NSInteger giftNumber;

@end

NS_ASSUME_NONNULL_END
