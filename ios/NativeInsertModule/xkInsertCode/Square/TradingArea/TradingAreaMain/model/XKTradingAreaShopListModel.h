//
//  XKTradingAreaShopListModel.h
//  XKSquare
//
//  Created by hupan on 2018/10/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShopListItem;
@class ShopListLocation;
@class ShopListIndustryItem;

@interface XKTradingAreaShopListModel : NSObject

@property (nonatomic , strong) NSArray <ShopListItem *>  * data;
@property (nonatomic , assign) BOOL                   empty;
@property (nonatomic , assign) NSInteger              total;

@end


@interface ShopListItem :NSObject

@property (nonatomic , assign) NSInteger              avgConsumption;//人均消费
@property (nonatomic , assign) NSInteger              level;//评分
@property (nonatomic , assign) NSInteger              monthPopularity;//人气
@property (nonatomic , assign) NSInteger              monthVolume;//月销量
@property (nonatomic , copy  ) NSString              * distance;
@property (nonatomic , copy  ) NSString              * cover;
@property (nonatomic , copy  ) NSString              * createdAt;
@property (nonatomic , copy  ) NSString              * descriptionStr;
@property (nonatomic , copy  ) NSString              * itemId;
@property (nonatomic , assign) NSInteger              isRecommend;
@property (nonatomic , strong) ShopListLocation      * location;
@property (nonatomic , copy  ) NSString              * name;
@property (nonatomic , copy  ) NSString              * status;
@property (nonatomic , copy  ) NSString              * updatedAt;
@property (nonatomic , strong) NSArray <ShopListIndustryItem *>  * industry;


@end



@interface ShopListIndustryItem :NSObject

@property (nonatomic , copy) NSString              * levelOneCode;
@property (nonatomic , copy) NSString              * levelTwoCode;

@end


@interface ShopListLocation :NSObject

@property (nonatomic , assign) CGFloat              lat;
@property (nonatomic , assign) NSInteger            lng;

@end



