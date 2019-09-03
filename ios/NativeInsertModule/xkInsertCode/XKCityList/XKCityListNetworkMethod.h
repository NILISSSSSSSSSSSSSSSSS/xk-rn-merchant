//
//  XKCityListNetworkMethod.h
//  XKSquare
//
//  Created by Lin Li on 2018/8/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKCityListNetworkMethod : NSObject

/**
 查询所有城市和区/县列表

 @param parameters 请求参数
 limit:每页条数,
 page:第几页
 @param block 返回数据
 */
+ (void)getCityAndDistrictListParameters:(NSDictionary *)parameters Block:(void(^)(id responseObject,BOOL isSuccess))block;

/**
 查询区/县列表

 @param parameters 请求参数
 cityCode:城市代码,
 limit:每页条数,
 page:第几页
 @param block 返回数据
 */
+ (void)getDistrictListParameters:(NSDictionary *)parameters Block:(void(^)(id responseObject, BOOL isSuccess))block;

/**
 查询热门列表
 
 @param parameters 请求参数
 cityCode:城市代码,
 limit:每页条数,
 page:第几页
 @param block 返回数据
 */
+ (void)getHotListParameters:(NSDictionary *)parameters Block:(void(^)(id responseObject, BOOL isSuccess))block;
/**
 查询所有的城市【前端缓存】
 
 @param parameters 请求参数
 cityVersion:版本号，初始化传空,
 @param block 返回数据
 */
+ (void)getCityCacheListParameters:(NSDictionary *)parameters Block:(void(^)(id responseObject, BOOL isSuccess))block;

/**
 查询所有的省份【前端缓存】
 
 @param parameters 请求参数
 cityVersion:版本号，初始化传空,
 @param block 返回数据
 */
+ (void)getProvinceCacheListParameters:(NSDictionary *)parameters Block:(void(^)(id responseObject, BOOL isSuccess))block;


/**
 查询所有的区/县【前端缓存】
 
 @param parameters 请求参数
 cityVersion:版本号，初始化传空,
 @param block 返回数据
 */
+ (void)getDistrictCacheListParameters:(NSDictionary *)parameters Block:(void(^)(id responseObject, BOOL isSuccess))block;
@end
