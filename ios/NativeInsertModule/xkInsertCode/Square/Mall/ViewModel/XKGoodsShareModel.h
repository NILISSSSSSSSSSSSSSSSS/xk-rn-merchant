//
//  XKGoodsShareModel.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKGoodsShareValuesItem :NSObject
@property (nonatomic , copy) NSString              * displayName;
@property (nonatomic , copy) NSString              * value;

@end


@interface XKGoodsShareAttrListItem :NSObject
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , strong) NSArray <XKGoodsShareValuesItem *>              * values;

@end


@interface XKGoodsShareGoodsAttrs :NSObject
@property (nonatomic , strong) NSArray <XKGoodsShareAttrListItem *>              * attrList;
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , assign) NSInteger              updatedAt;

@end


@interface XKGoodsShareCategories :NSObject
@property (nonatomic , assign) NSInteger              cc_thr;
@property (nonatomic , assign) NSInteger              cc_sec;
@property (nonatomic , assign) NSInteger              cc_fri;

@end


@interface XKGoodsShareDefaultSku :NSObject
@property (nonatomic , assign) NSInteger              b2bPrice;
@property (nonatomic , assign) NSInteger              b2cPrice;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , assign) NSInteger              isDefault;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) CGFloat              price;
@property (nonatomic , assign) NSInteger              skuId;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , assign) NSInteger              stock;
@property (nonatomic , assign) NSInteger              updatedAt;
@property (nonatomic , assign) NSInteger              weight;

@end


@interface XKGoodsShareBase :NSObject
@property (nonatomic , assign) NSInteger              brandCode;
@property (nonatomic , copy) NSString              * brandName;
@property (nonatomic , copy) NSString              * carriage;
@property (nonatomic , strong) XKGoodsShareCategories              * categories;
@property (nonatomic , assign) NSInteger              costPrice;
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , strong) XKGoodsShareDefaultSku              * defaultSku;
@property (nonatomic , copy) NSString              * detail;
@property (nonatomic , copy) NSString              * goodsStatus;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , assign) NSInteger              isFreeShipping;
@property (nonatomic , assign) NSInteger              isRecommend;
@property (nonatomic , assign) NSInteger              isSingleSpec;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              oldPrice;
@property (nonatomic , assign) NSInteger              popularity;
@property (nonatomic , assign) NSInteger              reduceStock;
@property (nonatomic , assign) NSInteger              saleQ;
@property (nonatomic , strong) NSArray <NSString *>              * showPicUrl;
@property (nonatomic , copy) NSString              * showVideoUrl;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , assign) NSInteger              updatedAt;

@end


@interface XKGoodsShareParam :NSObject
@property (nonatomic , strong) XKGoodsShareGoodsAttrs              * goodsAttrs;
@property (nonatomic , strong) XKGoodsShareBase              * base;
@property (nonatomic , assign) NSInteger              quantity;


@end


@interface XKGoodsShareModel :NSObject
@property (nonatomic , copy) NSString              * shareUrl;
@property (nonatomic , strong) XKGoodsShareParam              * param;

@end

NS_ASSUME_NONNULL_END
