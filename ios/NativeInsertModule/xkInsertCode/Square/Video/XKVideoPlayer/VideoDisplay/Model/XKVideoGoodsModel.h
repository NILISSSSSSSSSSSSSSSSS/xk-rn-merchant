//
//  XKVideoGoodsModel.h
//  XKSquare
//
//  Created by RyanYuan on 2018/10/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKVideoGoodsModel :NSObject

@property (nonatomic , copy) NSString *ID;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *pic;
@property (nonatomic , copy) NSString *xkModule;
@property (nonatomic , copy) NSString *goodsSkuName;
@property (nonatomic , copy) NSString *goodsSkuCode;
@property (nonatomic , assign) NSInteger num;
@property (nonatomic , assign) NSInteger isDown;

@property (nonatomic , assign) NSInteger price;

@property (nonatomic ,copy) NSString *lng;
@property (nonatomic ,copy) NSString *lat;
@property (nonatomic ,assign) CGFloat level;
@property (nonatomic ,assign) NSInteger monthVolume;

@end

