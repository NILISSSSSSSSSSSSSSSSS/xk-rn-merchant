//
//  XKWelfareBuyCarViewModel.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareBuyCarViewModel.h"
#import "XKWelfareBuyCarViewModel.h"
#import "XKWelfareCarGoodsInfo.h"
@implementation XKWelfareDrawDetail

@end

@implementation XKWelfareGoods

@end

@implementation XKWelfareBuyCarItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id",
             };
}
@end
@implementation XKWelfareBuyCarViewModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [XKWelfareBuyCarItem class]
             };
}

+ (void)requestWelfareBuyCarListWithParam:(NSDictionary *)dic success:(void(^)(XKWelfareBuyCarViewModel *model))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient getEncryptRequestWithURLString:GetWelfareBuyCarListUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success([XKWelfareBuyCarViewModel yy_modelWithJSON:responseObject]);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

#pragma mark - 批量删除
+ (void)deleteWelfareBuyCarListWithDeleteArr:(NSArray *)arr success:(void(^)(NSArray *modelArr))success failed:(void(^)(NSString *failedReason))failed {
    NSMutableArray *idsArr = [NSMutableArray array];
    for(XKWelfareBuyCarItem *model in arr) {
        [idsArr addObject:model.ID];
    };
    NSDictionary *dic = @{
                          @"ids":idsArr
                          };
    [HTTPClient postEncryptRequestWithURLString:GetWelfareBuyCarDeleteUrl timeoutInterval:20 parameters:dic success:^(id responseObject) {
        // 成功了就本地移移除数据 请求会导致本地数据被覆盖
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        failed(error.message);
    }];
}
//收藏
+ (void)collectWelfareBuyCarListWithDeleteArr:(NSArray *)arr success:(void(^)(NSArray *modelArr))success failed:(void(^)(NSString *failedReason))failed {
    NSMutableArray *idsArr = [NSMutableArray array];
    for(XKWelfareBuyCarItem *model in arr) {
        [idsArr addObject:model.goodsId];
    };
    NSDictionary *dic = @{
                          @"ids":idsArr
                          };
    [HTTPClient postEncryptRequestWithURLString:GetWelfareBuyCarCollectionUrl timeoutInterval:20 parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        failed(error.message);
    }];
}

+ (void)changeWelfareBuyCarListNumberWithAllArr:(NSArray *)arr success:(void(^)(NSArray *modelArr))success failed:(void(^)(NSString *failedReason))failed {
    NSMutableArray *idsArr = [NSMutableArray array];
    for(XKWelfareBuyCarItem *model in arr) {
        NSDictionary *dic = @{
                              @"quantity" : @(model.quantity),
                              @"id"  : model.ID
                              };
        [idsArr addObject:dic];
    };
    NSDictionary *dic = @{
                          @"cart":idsArr
                          };
    [HTTPClient postEncryptRequestWithURLString:GetWelfareBuyCarChangeNumbernUrl timeoutInterval:20 parameters:dic success:^(id responseObject) {
        
            //success(responseObject);
    } failure:^(XKHttpErrror *error) {
      //  failed(error.message);
    }];
}

- (void)deleteGoods:(NSArray <XKWelfareCarGoodsInfo*>*)goodsInfos complete:(void(^)(NSString *error,id data))complete {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    NSMutableArray *goodsArr = @[].mutableCopy;
    for (XKWelfareCarGoodsInfo *goods in goodsInfos) {
        [goodsArr addObject:goods.goodsId];
    }
    params[@"goodsIds"] = goodsArr.copy;
    [HTTPClient postEncryptRequestWithURLString:@"goods/ua/jfmallCartQList/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        // 成功了就本地移移除数据 请求会导致本地数据被覆盖
        [self.dataArr removeObjectsInArray:goodsInfos];
        EXECUTE_BLOCK(complete,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}

#pragma mark - 加入收藏夹
- (void)addGoodsToFavorites:(NSArray <XKWelfareCarGoodsInfo*>*)goodsInfos complete:(void(^)(NSString *error,id data))complete {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    NSMutableArray *goodsArr = @[].mutableCopy;
    for (XKWelfareCarGoodsInfo *goods in goodsInfos) {
        [goodsArr addObject:goods.goodsId];
    }
    params[@"goodsIds"] = goodsArr.copy;
    [HTTPClient postEncryptRequestWithURLString:@"goods/ua/jfmallCartMoveToFavorites/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        EXECUTE_BLOCK(complete,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}

+ (void)orderWelfareGiveOrderParmDic:(NSDictionary *)dic success:(void(^)(id respson))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient postEncryptRequestWithURLString:@"trade/ua/jmallOrderCreate/1.0" timeoutInterval:20 parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
         [XKHudView hideAllHud];
        failed(error.message);
    }];
}

+ (void)orderWelfarePayParmDic:(NSDictionary *)dic success:(void(^)(id respson))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient postEncryptRequestWithURLString:@"trade/ua/jOrderPayment/1.0" timeoutInterval:20 parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

#pragma mark - 同步商品数量
- (void)updateGoodsQuantity:(NSArray <XKWelfareCarGoodsInfo*>*)goodsInfos complete:(void(^)(NSString *error,id data))complete {
   
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    NSMutableArray *goodsArr = @[].mutableCopy;
    for (XKWelfareCarGoodsInfo *goods in self.dataArr) { // 全部同步
   // for (XKWelfareCarGoodsInfo *goods in self.goodsInfos) { //只同步传入的修改项
        NSMutableDictionary *goodsInfoDic = @{}.mutableCopy;
        goodsInfoDic[@"quantity"] = @(goods.quantity);
        goodsInfoDic[@"id"] = goods.goodsId;
        [goodsArr addObject:goodsInfoDic];
    }
    params[@"cart"] = goodsArr;
    [HTTPClient postEncryptRequestWithURLString:@"goods/ua/jfmallCartUpdateQuantity/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        EXECUTE_BLOCK(complete,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}


- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
