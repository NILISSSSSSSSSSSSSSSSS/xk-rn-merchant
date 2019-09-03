//
//  XKTradingAreaCommonAdapter.h
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKStoreRecommendBaseAdapter.h"

typedef enum : NSUInteger {
    CommonType_introduction,//店铺简介
    CommonType_activity,//店铺活动
    CommonType_booking,//(订座)服务类
    CommonType_hotel,//酒店类
    CommonType_offLine,//现场购买（线下购物）
    CommonType_takeout,//外卖 （在线购物）
    //店中店部分
    CommonType_storeInStore,//店中店
    CommonType_storeInfo,//商户信息
    CommonType_estimate,//评价
    
} CommonType;


@interface XKTradingAreaCommonAdapter : XKStoreRecommendBaseAdapter

@property (nonatomic, copy  ) NSString              *shopId;
@property (nonatomic, strong) dispatch_group_t      group;

@property (nonatomic, assign) double lng;
@property (nonatomic, assign) double lat;



//店铺详情
- (void)requestTradingAreaShopInfo;

//商店是否收藏
- (void)requsetTradingAreaShopFavoriteStatus:(void (^__strong)(NSInteger code))success;

//收藏
- (void)tradingAreaShopFavorite:(void (^__strong)(NSInteger code))success;

//取消收藏
- (void)tradingAreaCancelShopFavorite:(void (^__strong)(NSInteger code))success;

//分享
- (void)shareButtonClicked;

//商店评论标签
- (void)requestTradingAreaShopCommentLabels;

//店铺评分
- (void)requestTeadingAreaShopCommentGrade;

//商店评论列表
- (void)requsetTradingAreaShopCommentList;



@end
