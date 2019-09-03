//
//  XKCoordinateTransformation.h
//  Mom
//
//  Created by hupan on 2018/7/26.
//  Copyright © 2018年 Tears. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface XKCoordinateTransformation : NSObject

//判断是否已经超出中国范围
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;

//转GCJ-02
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

// 百度地图(BD09)经纬度转换为高德地图(GCJ02 火星坐标)经纬度
+ (CLLocationCoordinate2D)transfromFromBD09ToGCJ02WithBD09Latitide:(double)latitude BD09Longitude:(double)longitude;

// 高德地图(GCJ02 火星坐标)经纬度转换为百度地图(BD09)经纬度
+ (CLLocationCoordinate2D)transfromFromGCJ02ToBD09WithGCJ02Latitide:(double)latitude GCJ02Longitude:(double)longitude;

@end
