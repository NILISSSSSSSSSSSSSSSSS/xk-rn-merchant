//
//  XKIMMessageCustomerSerOrderAttachment.h
//  XKSquare
//
//  Created by william on 2018/9/6.
//  Copyright © 2018年 xk. All rights reserved.
//
//  客服聊天页面发送订单Attachment
//
//
#import "XKIMMessageBaseAttachment.h"

@interface XKIMMessageCustomerSerOrderAttachment : XKIMMessageBaseAttachment

// 订单类型 1福利订单 2自营订单
@property (nonatomic, assign) NSUInteger orderType;
// 订单Id
@property (nonatomic, copy) NSString *orderId;
// 图片URL
@property (nonatomic, copy) NSString *orderIconUrl;
// 标题
@property (nonatomic, copy) NSString *commodityName;
// 描述（规格）
@property (nonatomic, copy) NSString *commoditySpecification;
// 订单内有多少商品
@property (nonatomic, assign) NSUInteger orderCommodityCount;
// 价格
@property (nonatomic, assign) CGFloat orderTotalAmount;
// h5链接
@property (nonatomic, copy) NSString *url;
//
@property (nonatomic, copy) NSString *ret;
//
@property (nonatomic, copy) NSString *ticket;

@end

