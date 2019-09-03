//
//  XKTradingAreaShopCarManager.m
//  XKSquare
//
//  Created by hupan on 2018/11/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaShopCarManager.h"
#import "XKTradingAreaGoodsInfoModel.h"

@interface XKTradingAreaShopCarManager ()


@property (nonatomic, strong) NSMutableDictionary *goodsMudic;
//二维数组
@property (nonatomic, strong) NSMutableArray      *goodsListMuarr;

@end


static XKTradingAreaShopCarManager *_shareManager;

@implementation XKTradingAreaShopCarManager

+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareManager) {
            _shareManager = [[XKTradingAreaShopCarManager alloc] init];
            _shareManager.goodsMudic = [NSMutableDictionary dictionary];
            _shareManager.goodsListMuarr = [NSMutableArray array];
        }
    });
    return _shareManager;
}


- (NSArray<NSArray<GoodsSkuVOListItem *> *> *)getShopCarGoodsListWithShopId:(NSString *)shopId industryType:(XKIndustryType)type {
    
    NSString *key = [self getCustomKeyWithShopId:shopId industryType:type];
    return [self.goodsMudic objectForKey:key];
}

- (void)addToShopCarWithGoodsModel:(GoodsSkuVOListItem *)model shopId:(NSString *)shopId industryType:(XKIndustryType)type {
    
    NSString *key = [self getCustomKeyWithShopId:shopId industryType:type];

    NSMutableArray *muArr = [self.goodsMudic objectForKey:key];
    
    NSMutableArray *newMuArr = [NSMutableArray array];
    [newMuArr addObjectsFromArray:muArr];
    
    BOOL findGoods = NO;
    for (NSMutableArray *subMuarr in muArr) {
        NSMutableArray *newSubMuarr = [NSMutableArray array];
        [newSubMuarr addObjectsFromArray:subMuarr];
        
        for (GoodsSkuVOListItem *goodsSkuVOModel in subMuarr) {
            //相同商品
            if ([goodsSkuVOModel.goodsId isEqualToString:model.goodsId]) {
                findGoods = YES;
                //相同规格
                if ([goodsSkuVOModel.skuCode isEqualToString:model.skuCode]) {
                    [newSubMuarr addObject:model];
                    [newMuArr replaceObjectAtIndex:[muArr indexOfObject:subMuarr] withObject:newSubMuarr];
                } else {//不同规格
                    [newMuArr addObject:[NSArray arrayWithObject:model]];
                }
                break;
            }
        }
        if (findGoods) {
            break;
        }
    }
    if (!findGoods) {
        //不同商品
        [newMuArr addObject:[NSArray arrayWithObject:model]];
    }
    [self.goodsMudic setObject:newMuArr forKey:key];
}



- (void)deleteGoodsWithGoodsModel:(GoodsSkuVOListItem *)model shopId:(NSString *)shopId industryType:(XKIndustryType)type {
    
    NSString *key = [self getCustomKeyWithShopId:shopId industryType:type];

    NSMutableArray *muArr = [self.goodsMudic objectForKey:key];
    
    NSMutableArray *newMuArr = [NSMutableArray array];
    [newMuArr addObjectsFromArray:muArr];
    
    BOOL findGoods = NO;
    for (NSMutableArray *subMuarr in muArr) {
        NSMutableArray *newSubMuarr = [NSMutableArray array];
        [newSubMuarr addObjectsFromArray:subMuarr];
        
        for (GoodsSkuVOListItem *goodsSkuVOModel in subMuarr) {
            //相同商品 相同规格（备注：在这里是相同商品的话一定是相同规格）
            if ([goodsSkuVOModel.goodsId isEqualToString:model.goodsId] && [goodsSkuVOModel.skuCode isEqualToString:model.skuCode]) {
                findGoods = YES;
                [newSubMuarr removeObjectAtIndex:[subMuarr indexOfObject:goodsSkuVOModel]];
                [newMuArr replaceObjectAtIndex:[muArr indexOfObject:subMuarr] withObject:newSubMuarr];
                break;
            }
        }
        //如果为空就删除
        if (newSubMuarr.count == 0) {
            [newMuArr removeObjectAtIndex:[muArr indexOfObject:subMuarr]];
        }
        
        if (findGoods) {
            break;
        }
    }
    [self.goodsMudic setObject:newMuArr forKey:key];
}


- (void)clearnShopCarAllDataWithShopId:(NSString *)shopId {
    if (!shopId) {
        [XKAlertView showCommonAlertViewWithTitle:@"清理购物车数据时，店铺id不能为空"];
        return;
    }
    
    NSString *key1 = [NSString stringWithFormat:@"%@+%lu", shopId, (unsigned long)XKIndustryType_offline];
    NSString *key2 = [NSString stringWithFormat:@"%@+%lu", shopId, (unsigned long)XKIndustryType_online];
    
    [self.goodsMudic removeObjectForKey:key1];
    [self.goodsMudic removeObjectForKey:key2];
}


- (void)clearnShopCarWithShopId:(NSString *)shopId industryType:(XKIndustryType)type {

    NSString *key = [self getCustomKeyWithShopId:shopId industryType:type];
    [self.goodsMudic removeObjectForKey:key];
}



- (NSString *)getCustomKeyWithShopId:(NSString *)shopId industryType:(XKIndustryType)type {
    
    if (!shopId || !type) {
        [XKAlertView showCommonAlertViewWithTitle:@"获取购物车数据时，店铺id或者模块类型不能为空"];
        return @"";
    }
    NSString *key = [NSString stringWithFormat:@"%@+%lu", shopId, (unsigned long)type];
    return key;
}



@end
