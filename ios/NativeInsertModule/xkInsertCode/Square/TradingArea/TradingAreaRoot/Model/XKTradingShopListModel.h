//
//  XKTradingShopListModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/27.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKTradingShopListIndustryItem :NSObject
@property (nonatomic , copy) NSString              * levelOneCode;
@property (nonatomic , copy) NSString              * levelTwoCode;

@end


@interface XKTradingShopListLocation :NSObject
@property (nonatomic , assign) CGFloat              lat;
@property (nonatomic , assign) NSInteger              lng;

@end


@interface XKTradingShopListDataItem :NSObject
@property (nonatomic , assign) NSInteger              avgConsumption;
@property (nonatomic , copy) NSString              * cover;
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , copy) NSString              * des;
@property (nonatomic , copy) NSString              * shopId;
@property (nonatomic , strong) NSArray <XKTradingShopListIndustryItem *>              * industry;
@property (nonatomic , assign) NSInteger              isRecommend;
@property (nonatomic , assign) NSInteger              level;
@property (nonatomic , strong) XKTradingShopListLocation              * location;
@property (nonatomic , assign) NSInteger              monthPopularity;
@property (nonatomic , assign) NSInteger              monthVolume;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , assign) NSInteger              updatedAt;
@property (nonatomic , assign) NSInteger              distance;

@end


@interface XKTradingShopListModel :NSObject
@property (nonatomic , strong) NSArray <XKTradingShopListDataItem *>              * data;
@property (nonatomic , assign) BOOL              empty;
@property (nonatomic , assign) NSInteger              total;

@end
NS_ASSUME_NONNULL_END
