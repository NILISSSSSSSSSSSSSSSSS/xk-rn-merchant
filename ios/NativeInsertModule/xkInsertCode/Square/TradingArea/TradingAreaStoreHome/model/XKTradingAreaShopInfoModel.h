//
//  XKTradingAreaShopInfoModel.h
//  XKSquare
//
//  Created by hupan on 2018/10/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ATCouponsItem :NSObject
@property (nonatomic , copy) NSString              * couponId;
@property (nonatomic , copy) NSString              * couponName;
@property (nonatomic , copy) NSString              * couponType;
@property (nonatomic , assign) NSInteger              invalidTime;
@property (nonatomic , copy) NSString              * message;
@property (nonatomic , copy) NSString              * price;
@property (nonatomic , copy) NSString              * shopId;
@property (nonatomic , copy) NSString              * shopName;
@property (nonatomic , copy) NSString              * shopPic;
@property (nonatomic , assign) NSInteger              validTime;

@end


@interface ATShopGoodsItem :NSObject
@property (nonatomic , copy) NSString              * discountPrice;
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , copy) NSString              * goodsName;
@property (nonatomic , copy) NSString              * mainPic;
@property (nonatomic , copy) NSString              * originalPrice;
@property (nonatomic , copy) NSString              * saleM;

@end


@interface ATGoodsItem :NSObject
@property (nonatomic , copy) NSString              * goodsTypeId;
@property (nonatomic , copy) NSString              * goodsTypeName;
@property (nonatomic , strong) NSArray <ATShopGoodsItem *>  * shopGoods;

@end



@interface ATMon :NSObject
@property (nonatomic , copy) NSString              * endAt;
@property (nonatomic , copy) NSString              * startAt;

@end

@interface ATTue :NSObject
@property (nonatomic , copy) NSString              * endAt;
@property (nonatomic , copy) NSString              * startAt;

@end


@interface ATWed :NSObject
@property (nonatomic , copy) NSString              * endAt;
@property (nonatomic , copy) NSString              * startAt;

@end

@interface ATThu :NSObject
@property (nonatomic , copy) NSString              * endAt;
@property (nonatomic , copy) NSString              * startAt;

@end

@interface ATFri :NSObject
@property (nonatomic , copy) NSString              * endAt;
@property (nonatomic , copy) NSString              * startAt;

@end

@interface ATSat :NSObject
@property (nonatomic , copy) NSString              * endAt;
@property (nonatomic , copy) NSString              * startAt;

@end


@interface ATSun :NSObject
@property (nonatomic , copy) NSString              * endAt;
@property (nonatomic , copy) NSString              * startAt;

@end


@interface ATBusinessTime :NSObject
@property (nonatomic , strong) ATMon              * mon;
@property (nonatomic , strong) ATTue              * tue;
@property (nonatomic , strong) ATWed              * wed;
@property (nonatomic , strong) ATThu              * thu;
@property (nonatomic , strong) ATFri              * fri;
@property (nonatomic , strong) ATSat              * sat;
@property (nonatomic , strong) ATSun              * sun;


@end


@interface ATIndustryItem :NSObject
@property (nonatomic , copy) NSString              * levelOneCode;
@property (nonatomic , copy) NSString              * levelTwoCode;

@end


@interface ATMShop :NSObject
@property (nonatomic , copy) NSString                * address;
@property (nonatomic , copy) NSString                * adminPhone;
@property (nonatomic , assign) NSInteger             automatic;
@property (nonatomic , assign) CGFloat               avgConsumption;
@property (nonatomic , strong) ATBusinessTime        * businessTime;
@property (nonatomic , copy) NSString                * cityCode;
@property (nonatomic , assign) NSInteger             code;
@property (nonatomic , strong) NSArray <NSString *>  * contactPhones;
@property (nonatomic , copy) NSString                * cover;
@property (nonatomic , copy) NSString                * createdAt;
@property (nonatomic , copy) NSString                * descriptionStr;
@property (nonatomic , assign) CGFloat               discount;
@property (nonatomic , copy) NSString                * districtCode;
@property (nonatomic , copy) NSString                * firstAuthStatus;
@property (nonatomic , copy) NSString                * itemId;
@property (nonatomic , strong) NSArray <ATIndustryItem *> * industry;
@property (nonatomic , assign) NSInteger              isBusiness;
@property (nonatomic , assign) NSInteger              isRecommend;
@property (nonatomic , copy) NSString                 * lat;
@property (nonatomic , assign) NSInteger              level;
@property (nonatomic , copy) NSString                 * lng;
@property (nonatomic , assign) NSInteger              maxMoney;
@property (nonatomic , assign) NSInteger              minMoney;
@property (nonatomic , assign) NSInteger              monthPopularity;
@property (nonatomic , assign) NSInteger              monthVolume;
@property (nonatomic , copy) NSString                 * name;
@property (nonatomic , assign) NSInteger              onLine;
@property (nonatomic , strong) NSArray <NSString *>   * pictures;
@property (nonatomic , copy) NSString                 * provinceCode;
@property (nonatomic , assign) NSInteger              range;
@property (nonatomic , copy) NSString                 * secondAuthStatus;
@property (nonatomic , copy) NSString                 * status;
@property (nonatomic , copy) NSString                 * updatedAt;

@end


@interface ATShopsItem :NSObject
@property (nonatomic , copy) NSString              * shopId;
@property (nonatomic , copy) NSString              * shopName;
@property (nonatomic , copy) NSString              * shopPic;


@end


@interface XKTradingAreaShopInfoModel :NSObject

@property (nonatomic , strong) NSArray <ATCouponsItem *>            * coupons;
@property (nonatomic , copy  ) NSString                             * distance;
@property (nonatomic , strong) NSArray <ATGoodsItem *>              * goods;
@property (nonatomic , strong) ATMShop                              * mShop;
@property (nonatomic , strong) NSArray <ATShopsItem *>              * shops;

@end



