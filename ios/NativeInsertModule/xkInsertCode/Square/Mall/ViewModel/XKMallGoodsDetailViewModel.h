//
//  XKMallGoodsDetailViewModel.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseModel.h"
@interface XKMallGoodsDetailSkuAttrValuesItem : BaseModel
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * name;
@end

@interface XKMallGoodsDetailAttrValuesItem : BaseModel
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) BOOL                selected;
@end

@interface XKMallGoodsDetailAttrListItem : BaseModel
@property (nonatomic , strong) NSArray <XKMallGoodsDetailAttrValuesItem *>              * attrValues;
@property (nonatomic , copy) NSString              * key;
@property (nonatomic , copy) NSString              * name;
@end

@interface XKMallGoodsDetailSkuAttr : BaseModel
@property (nonatomic , strong) NSArray <XKMallGoodsDetailAttrListItem *>              * attrList;
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , assign) NSInteger              updatedAt;
@end

@interface XKMallGoodsDetailViewModel : BaseModel
@property (nonatomic , strong) NSArray <XKMallGoodsDetailSkuAttrValuesItem *>              * skuAttrValue;
@property (nonatomic , strong) XKMallGoodsDetailSkuAttr              * skuAttr;

/**
 收藏商品

 @param parmDic 需要的参数
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)requestCollectionGoodsWithParmDic:(NSDictionary *)parmDic  success:(void(^)(id data))success failed:(void(^)(NSString *failedReason))failed;

/**
 取消收藏商品
 
 @param parmDic 需要的参数
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)requestCancelCollectionGoodsWithParmDic:(NSDictionary *)parmDic  success:(void(^)(id data))success failed:(void(^)(NSString *failedReason))failed;

/**
 请求SKU明细
 
 @param parmDic 需要的参数
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)requestGoodsSKUinfoWithParmDic:(NSDictionary *)parmDic  success:(void(^)(XKMallGoodsDetailViewModel *model))success failed:(void(^)(NSString *failedReason))failed;
@end
