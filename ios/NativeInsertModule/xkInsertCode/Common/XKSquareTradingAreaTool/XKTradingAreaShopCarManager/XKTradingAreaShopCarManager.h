//
//  XKTradingAreaShopCarManager.h
//  XKSquare
//
//  Created by hupan on 2018/11/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GoodsSkuVOListItem;

//目前只有这两种需要购物车
typedef enum : NSUInteger {
    XKIndustryType_offline = 1000,//现场购买
    XKIndustryType_online,//在线购买（外卖）
} XKIndustryType;

@interface XKTradingAreaShopCarManager : NSObject

+ (instancetype)shareManager;

- (NSArray<NSArray<GoodsSkuVOListItem *> *> *)getShopCarGoodsListWithShopId:(NSString *)shopId industryType:(XKIndustryType)type;
- (void)addToShopCarWithGoodsModel:(GoodsSkuVOListItem *)model shopId:(NSString *)shopId industryType:(XKIndustryType)type;
- (void)deleteGoodsWithGoodsModel:(GoodsSkuVOListItem *)model shopId:(NSString *)shopId industryType:(XKIndustryType)type;
- (void)clearnShopCarWithShopId:(NSString *)shopId industryType:(XKIndustryType)type;
- (void)clearnShopCarAllDataWithShopId:(NSString *)shopId;

@end
