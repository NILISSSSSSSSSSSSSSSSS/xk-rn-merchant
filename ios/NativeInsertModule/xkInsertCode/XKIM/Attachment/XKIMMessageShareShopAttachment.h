//
//  XKIMMessageShareShopAttachment.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/9.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageShareShopAttachment : XKIMMessageBaseAttachment

// 店铺ID
@property (nonatomic, copy) NSString *storeId;
// 店铺名城
@property (nonatomic, copy) NSString *storeName;
// 店铺封面
@property (nonatomic, copy) NSString *storeIconUrl;
// 店铺描述
@property (nonatomic, copy) NSString *storeDescription;
// 星级评分
@property (nonatomic, assign) CGFloat storeScore;
// 经度
@property (nonatomic, assign) CGFloat storeLongitude;
// 纬度
@property (nonatomic, assign) CGFloat storeLatitude;
// 交易量
@property (nonatomic, assign) NSUInteger storeSalesVolume;
// 消息来源
@property (nonatomic, copy) NSString *messageSourceName;

@end

NS_ASSUME_NONNULL_END
