//
//  XKIMMessageShareGoodsAttachment.h
//  XKSquare
//
//  Created by william on 2018/11/8.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

@interface XKIMMessageShareGoodsAttachment : XKIMMessageBaseAttachment
/**
 商品类型
 1 自营商品
 2 商圈商品
 */
@property (nonatomic, assign) NSUInteger commodityType;
// 商圈商品需要
@property (nonatomic, copy) NSString *shopId;
// 商品id
@property (nonatomic, copy) NSString *commodityId;
// 商品类型Id（商圈用）
@property (nonatomic, copy) NSString *goodsTypeId;
// 商品图片
@property (nonatomic, copy) NSString *commodityIconUrl;
// 商品标题
@property (nonatomic, copy) NSString *commodityName;
// 商品规格
@property (nonatomic, copy) NSString *commoditySpecification;
// 商品销量
@property (nonatomic, assign) NSUInteger commoditySalesVolume;
// 价格（分）
@property (nonatomic, assign) NSUInteger commodityPrice;
// 消息来源类型名称
@property (nonatomic, copy) NSString *messageSourceName;

@end
