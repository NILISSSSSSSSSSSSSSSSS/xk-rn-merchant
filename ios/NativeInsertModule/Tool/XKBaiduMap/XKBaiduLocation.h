//
//  XKBaiduLocation.h
//  MasonryTest
//
//  Created by hupan on 2018/8/16.
//  Copyright © 2018年 Tears. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMKLocationKit/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>

@protocol XKBaiduLocationDelegate <NSObject>


@optional
/**
 定位失败
 
 @param error error
 */

- (void)failToLocateUserWithError:(NSError *)error;


/**
 获取用户当前位置经纬度

 @param laititude laititude description
 @param longtitude longtitude description
 */
- (void)userLocationLaititude:(double)laititude longtitude:(double)longtitude;


/**
 获取用户所在地地名

 @param country 国家
 @param state 省会
 @param city 城市
 @param subLocality 区域
 @param name 地名
 */
- (void)userLocationCountry:(NSString *)country state:(NSString *)state city:(NSString *)city subLocality:(NSString *)subLocality name:(NSString *)name;


/**
 获取用户附近地址列表

 @param poiInfoList poiInfoList
 */
- (void)userNearbySearchAddressList:(NSArray<BMKPoiInfo *> *)poiInfoList;

@end

@interface XKBaiduLocation : NSObject

@property (nonatomic, weak  ) id<XKBaiduLocationDelegate> delegate;


+ (instancetype)shareManager;


/**
 判断定位权限

 @return 判断定位权限
 */
- (BOOL)locationAuthorized;

/**
 获取用户的经纬度

 @return 用户的经纬度
 */
- (CLLocationCoordinate2D)getUserLocationLaititudeAndLongtitude;


/**
 设置用户的经纬度
 
 */
- (void)setUserLocationLaititude:(double)lat longtitude:(CGFloat)lng;


/**
 获取用户所在地的国家

 @return 获取用户所在地的国家
 */
- (NSString *)getUserLocationCountry;

/**
 获取用户所在地的省会
 
 @return 获取用户所在地的省会
 */
- (NSString *)getUserLocationState;


/**
 获取用户所在地的城市
 
 @return 获取用户所在地的城市
 */
- (NSString *)getUserLocationCity;


/**
 获取用户所在城市的区
 
 @return 获取用户所在城市的区
 */
- (NSString *)getUserLocationSubLocality;

/**
 获取用户所在城市的具体位置
 
 @return 获取用户所在城市的具体位置
 */
- (NSString *)getUserLocationName;


/**
 开始单次定位
 */
- (void)startBaiduSingleLocationService;


/**
 获取附近建筑
 */
- (void)getNearbySearch;



/**
 获取某个经纬度距离当前位置的距离

 @param latitude 目标维度
 @param longitude 目标精度
 @return 距离 以米为单位
 */
- (CGFloat)getDistanceFromCurrentLocationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

@end
