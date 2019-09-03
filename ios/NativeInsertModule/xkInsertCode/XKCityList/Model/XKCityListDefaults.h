//
//  XKCityListDefaults.h
//  XKSquare
//
//  Created by Lin Li on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XKCityListUserDefault               [NSUserDefaults standardUserDefaults]
static NSString *const XKCityListCityNumber          = @"cityNumber";
static NSString *const XKCityListCurrentCity         = @"currentCity";
static NSString *const XKCityListLocationCity        = @"locationCity";
static NSString *const XKCityListPrivateCityNumber   = @"privateCityNumber";
static NSString *const XKCityListParentCity          = @"parentCity";

//数据库中接口的版本号
static NSString *const XKProvinceCacheListVersion           = @"provinceCacheList";
static NSString *const XKCityCacheListVersion               = @"cityCacheList";
static NSString *const XKDistrictCacheListVersion           = @"districtCacheList";

@interface XKCityListDefaults : NSObject
/**
 存储城市code
 */
+ (void)saveCityNumber:(id)cityNumber;

/**
 存储当前城市名字
 */
+ (void)saveCurrentCity:(id)currentCity;

/**
 存储当前定位城市
 */
+ (void)saveLocationCity:(id)locationCity;

/**
 存储私有城市code
 */
+ (void)savePrivateCityNumber:(id)cityNumber;

/**
 当前的二级城市名字
 */
+ (void)saveParentCity:(id)parentCity;

//存储数据库中接口的版本号
+ (void)saveProvinceCacheListVersion:(id)provinceCacheListVersion;
+ (void)saveCityCacheListVersion:(id)cityCacheListVersion;
+ (void)saveDistrictCacheListVersion:(id)districtCacheListVersion;

+ (id)getCityNumber;

+ (id)getCurrentCity;

+ (id)getLocationCity;

+ (id)getPrivateCityNumber;

+ (id)getParentCity;

//获取数据库中接口的版本号
+ (id)getProvinceCacheListVersion;

+ (id)getCityCacheListVersion;

+ (id)getDistrictCacheListVersion;
@end
