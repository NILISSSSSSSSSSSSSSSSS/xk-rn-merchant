//
//  XKBaiduLocation.m
//  MasonryTest
//
//  Created by hupan on 2018/8/16.
//  Copyright © 2018年 Tears. All rights reserved.
//

#import "XKBaiduLocation.h"
#import "CYLTabBarController.h"
#import "XKLaunchAdvertisementViewController.h"
#import "BaiduMapAPI_Utils/BMKUtilsComponent.h"

@interface XKBaiduLocation ()<BMKGeoCodeSearchDelegate, BMKLocationManagerDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) BMKLocationManager  *locationManager;
@property (nonatomic, strong) BMKGeoCodeSearch    *searcher;

@property (nonatomic, assign) double              laititude;
@property (nonatomic, assign) double              longtitude;
@property (nonatomic, copy  ) NSString            *country;     //国家
@property (nonatomic, copy  ) NSString            *state;       //省会
@property (nonatomic, copy  ) NSString            *city;        //城市
@property (nonatomic, copy  ) NSString            *subLocality; //区
@property (nonatomic, copy  ) NSString            *name;        //名字


@end

static XKBaiduLocation *_shareManager;

@implementation XKBaiduLocation

+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareManager) {
            _shareManager = [[XKBaiduLocation alloc] init];
            _shareManager.laititude = 0.0;
            _shareManager.longtitude = 0.0;
        }
    });
    return _shareManager;
}



- (CLLocationCoordinate2D)getUserLocationLaititudeAndLongtitude {
    return CLLocationCoordinate2DMake(self.laititude, self.longtitude);
}

- (void)setUserLocationLaititude:(double)lat longtitude:(CGFloat)lng {
    self.laititude = lat;
    self.longtitude = lng;
}


- (NSString *)getUserLocationCountry {
    return self.country;
}

- (NSString *)getUserLocationState {
    return self.state;
}

- (NSString *)getUserLocationCity {
    return self.city;
}

- (NSString *)getUserLocationSubLocality {
    return self.subLocality;
}

- (NSString *)getUserLocationName {
    return self.name;
}

- (BOOL)locationAuthorized {
    
    BOOL isAuthorized = NO;
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        isAuthorized = NO;
        if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[CYLTabBarController class]]) {
            CYLTabBarController *vc = (CYLTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            if (![vc.presentedViewController isKindOfClass:[XKLaunchAdvertisementViewController class]]) {
                [self showLocationAuthorizedMessage];
            }
        } else {
            [self showLocationAuthorizedMessage];
        }
    } else { //开启的
        isAuthorized = YES;
    }
    return isAuthorized;
}


- (void)showLocationAuthorizedMessage {
    
    [XKAlertView showCommonAlertViewWithTitle:@"定位服务未开启\n请在系统设置中开启定位服务" leftText:@"暂不" rightText:@"去设置" leftBlock:^{
        
    } rightBlock:^{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }];
}


- (void)startBaiduSingleLocationService {
    
    if ([self locationAuthorized]) {
        XKWeakSelf(weakSelf);
        [self.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
            
            if (error) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(failToLocateUserWithError:)]) {
                    [weakSelf.delegate failToLocateUserWithError:error];
                }
            } else {
                weakSelf.laititude = location.location.coordinate.latitude;
                weakSelf.longtitude = location.location.coordinate.longitude;
                
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userLocationLaititude:longtitude:)]) {
                    [weakSelf.delegate userLocationLaititude:weakSelf.laititude longtitude:weakSelf.longtitude];
                }
                
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userLocationCountry:state:city:subLocality:name:)]) {
                    [weakSelf getAddressByLatitude:weakSelf.laititude longitude:weakSelf.longtitude];
                }
            }
        }];
    }
}


- (void)getNearbySearch {
    
    //发起检索
    BMKReverseGeoCodeSearchOption *option = [[BMKReverseGeoCodeSearchOption alloc] init];
    option.location = CLLocationCoordinate2DMake(self.laititude, self.longtitude);
    BOOL flag = [self.searcher reverseGeoCode:option];
    if(flag) {
        NSLog(@"逆geo检索发送成功");
    } else {
        NSLog(@"逆geo检索发送失败");
    }
}

- (CGFloat)getDistanceFromCurrentLocationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude {
    if (self.laititude == 0.0 && self.longtitude == 0.0) {
        return -1.0;
    }
    BMKMapPoint fromPoint = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(self.laititude, self.longtitude));
    BMKMapPoint toPoint = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(latitude, longitude));
    return BMKMetersBetweenMapPoints(fromPoint, toPoint);
}

#pragma mark - PoiSearchDeleage

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPOISearchResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(userNearbySearchAddressList:)]) {
            [self.delegate userNearbySearchAddressList:poiResult.poiInfoList];
        }
    } else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}


#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {

    if (error == BMK_OPEN_NO_ERROR) {
        for (BMKPoiInfo *info in result.poiList) {
            NSLog(@"%@-%@", info.name, info.address);
        }
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - BMKLocationManagerDelegate

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(failToLocateUserWithError:)]) {
        [self.delegate failToLocateUserWithError:error];
    }
}


#pragma mark -根据坐标取得地名-
- (void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    
    //反地理编码
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks firstObject];
        NSDictionary *addressDic = placemark.addressDictionary;
        /*
         City = "成都市";
         Country = "中国";
         CountryCode = CN;
         FormattedAddressLines =     (
         "中国四川省成都市武侯区"
         );
         Name = "桂溪街道";
         State = "四川省";
         SubLocality = "武侯区";
         */
        
        NSString *country = [addressDic objectForKey:@"Country"];
        NSString *state = [addressDic objectForKey:@"State"];
        NSString *city = [addressDic objectForKey:@"City"];
        NSString *subLocality = [addressDic objectForKey:@"SubLocality"];
        NSString *name = [addressDic objectForKey:@"Name"];
        
        if (!city) {
            city = @"成都市";
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(userLocationCountry:state:city:subLocality:name:)]) {
            [self.delegate userLocationCountry:country state:state city:city subLocality:subLocality name:name];
        }
    }];
}

#pragma mark - Lazy load


- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        //初始化实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _locationManager.delegate = self;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        //_locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 10;
    }
    return _locationManager;
}


- (BMKGeoCodeSearch *)searcher {
    if (!_searcher) {
        _searcher = [[BMKGeoCodeSearch alloc] init];
        _searcher.delegate = self;
    }
    return _searcher;
}


- (void)dealloc {
    _searcher.delegate = nil;
    _locationManager.delegate = nil;
}


@end
