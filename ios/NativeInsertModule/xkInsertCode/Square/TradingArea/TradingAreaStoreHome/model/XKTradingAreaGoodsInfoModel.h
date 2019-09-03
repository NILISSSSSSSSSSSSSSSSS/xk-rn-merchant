//
//  XKTradingAreaGoodsInfoModel.h
//  XKSquare
//
//  Created by hupan on 2018/11/2.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GoodsSkuAttrsVO;
@class GoodsSkuVOListItem;
@class GoodsModel;

@interface XKTradingAreaGoodsInfoModel : NSObject

@property (nonatomic , strong) GoodsSkuAttrsVO                  * goodsSkuAttrsVO;//分开的规格
@property (nonatomic , strong) NSArray <GoodsSkuVOListItem *>   * goodsSkuVOList;//组合好的的规格列表
@property (nonatomic , strong) GoodsModel                       * goods;

@end


@interface GoodsAttrValuesItem :NSObject

@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * showPics;


@end


@interface GoodsAttrListItem :NSObject
@property (nonatomic , strong) NSArray <GoodsAttrValuesItem *>   * attrValues;
@property (nonatomic , copy  ) NSString                          * key;
@property (nonatomic , copy  ) NSString                          * name;

@end

//分开的规格
@interface GoodsSkuAttrsVO :NSObject
@property (nonatomic , strong) NSArray <GoodsAttrListItem *>    * attrList;
@property (nonatomic , copy  ) NSString              * createdAt;
@property (nonatomic , copy  ) NSString              * goodsId;
@property (nonatomic , copy  ) NSString              * itemId;
@property (nonatomic , copy  ) NSString              * shopId;
@property (nonatomic , copy  ) NSString              * status;
@property (nonatomic , copy  ) NSString              * updatedAt;

@end

//组合好的规格
@interface GoodsSkuVOListItem :NSObject

@property (nonatomic , copy  ) NSString              * createdAt;
@property (nonatomic , copy  ) NSString              * deposit;//押金
@property (nonatomic , copy  ) NSString              * free;//免费
@property (nonatomic , copy  ) NSString              * zeroOrder;//0元购
@property (nonatomic , assign) BOOL                  isSeatOnline;//选座（后台弃用字段）使用purchased字段
@property (nonatomic , assign) BOOL                  purchased;//加购
@property (nonatomic , copy  ) NSString              * reservation;//预定
@property (nonatomic , copy  ) NSString              * discountPrice;
@property (nonatomic , copy  ) NSString              * goodsId;
@property (nonatomic , copy  ) NSString              * goodsName;
@property (nonatomic , copy  ) NSString              * itemId;
@property (nonatomic , copy  ) NSString              * originalPrice;
@property (nonatomic , copy  ) NSString              * shopId;
@property (nonatomic , copy  ) NSString              * skuCode;
@property (nonatomic , copy  ) NSString              * skuName;
@property (nonatomic , copy  ) NSString              * status;
@property (nonatomic , assign) NSInteger              stock;//库存
@property (nonatomic , copy  ) NSString              * updatedAt;
@property (nonatomic , assign) NSInteger              weight;
@property (nonatomic , copy  ) NSString              * skuUrl;

@end



@interface GoodsCategory :NSObject

@property (nonatomic , copy) NSString              * goodsClassificationId;
@property (nonatomic , copy) NSString              * goodsTypeId;
@property (nonatomic , copy) NSString              * industryId1;
@property (nonatomic , copy) NSString              * industryId2;

@end

@interface GoodsModel :NSObject

@property (nonatomic , copy) NSString              * auditStatus;
@property (nonatomic , strong) GoodsCategory       * category;
@property (nonatomic , copy) NSString              * createdAt;
@property (nonatomic , copy) NSString              * defaultSkuCode;
@property (nonatomic , copy) NSString              * defaultSkuName;
@property (nonatomic , copy) NSString              * deposit;
@property (nonatomic , copy) NSString              * details;
@property (nonatomic , assign) NSInteger              discount;
@property (nonatomic , copy) NSString              * discountPrice;
@property (nonatomic , copy) NSString              * discountType;
@property (nonatomic , copy) NSString              * free;
@property (nonatomic , copy) NSString              * goodsName;
@property (nonatomic , copy) NSString              * goodsStatus;
@property (nonatomic , copy) NSString              * itemId;
@property (nonatomic , assign) NSInteger              isSeatOnline;
@property (nonatomic , copy) NSString              * mainPic;
@property (nonatomic , copy) NSString              * originalPrice;
@property (nonatomic , assign) NSInteger              purchased;
@property (nonatomic , copy) NSString              * refunds;
@property (nonatomic , copy) NSString              * refundsTime;
@property (nonatomic , assign) NSInteger              reservation;
@property (nonatomic , copy) NSString              * saleM;
@property (nonatomic , copy) NSString              * shopId;
@property (nonatomic , copy) NSString              * shopName;
@property (nonatomic , strong) NSArray <NSString *> * showPics;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * updatedAt;

@end



