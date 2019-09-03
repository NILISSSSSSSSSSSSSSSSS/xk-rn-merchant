//
//  XKConsumeCouponCellModel.h
//  XKSquare
//
//  Created by william on 2018/9/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseModel.h"

@interface XKConsumeCouponCellModel : BaseModel

@property (nonatomic, assign) long  dateTime;           //请求数据时间

@property (nonatomic, assign) NSInteger   Amount;       //商品数量

@property (nonatomic, copy) NSString    *goods;         //商品名字

@property (nonatomic, copy) NSString    *category;      //消费券类型

@property (nonatomic, copy) NSString    *consumerCoupontype;   //收入支出类型 【pay】支出 【income】收入

@property (nonatomic, assign) long      total;         //总条数

@property (nonatomic, assign) long      count;          //消费券数量

@end
