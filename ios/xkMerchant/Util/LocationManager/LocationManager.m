/*******************************************************************************
 # File        : LocationManager.m
 # Project     : xkMerchant
 # Author      : Jamesholy
 # Created     : 2018/9/4
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager()<CLLocationManagerDelegate>
/**<##>*/
@property(nonatomic, strong) CLLocationManager *locationManager;
/***/
@property(nonatomic, copy) void(^complete)(NSString *err,NSDictionary *info);
@end

@implementation LocationManager

+ (instancetype)shareInstance {
  static LocationManager *_instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [[LocationManager alloc] init];
  });
  return _instance;
}

- (instancetype)init {
  if (self = [super init]) {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    [self.locationManager requestWhenInUseAuthorization];
  }
  return self;
}

//开始定位
- (void)startLocation{

  [self.locationManager requestLocation];
}

//获得的定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
  
  CLLocation *newLocation = locations[0];
  if (!self.complete) {
    return ;
  }
  
  CLGeocoder *geocoder = [[CLGeocoder alloc]init];
  
  [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
    
    if (error) {
      if (self.complete) {
        self.complete(error.localizedDescription, nil);
      }
    } else {
      CLPlacemark *place = placemarks.firstObject;
      if (place == nil) {
        if (self.complete) {
          self.complete(nil, @{@"lat":@(newLocation.coordinate.latitude).stringValue,@"lon":@(newLocation.coordinate.longitude).stringValue});
        }
        
      } else {
        //        NSLog(@"name,%@",place.name);                      // 位置名
        //        NSLog(@"thoroughfare,%@",place.thoroughfare);      // 街道
        //        NSLog(@"subThoroughfare,%@",place.subThoroughfare);// 子街道
        //        NSLog(@"city,%@",place.locality);              // 市
        //        NSLog(@"regin,%@",place.subLocality);        // 区
        //        NSLog(@"country,%@",place.country);                // 国家
        //获取城市
        
        NSString *city = place.locality;
        if (!city) {
          //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
          city = place.administrativeArea;
        }
        if (self.complete) {
          NSDictionary *info = @{@"lat":@(newLocation.coordinate.latitude).stringValue,@"lon":@(newLocation.coordinate.longitude).stringValue,@"province":place.administrativeArea?:@"", @"city":city?:@"",@"region":place.subLocality?:@"",@"address":place.thoroughfare?:@""};
          self.complete(nil, info);
        }
      }
    }
    self.complete = nil;
  }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
  if (self.complete) {
      self.complete(error.localizedDescription, nil);
  }
}

- (void)updateLoactionComplete:(void(^)(NSString *err,NSDictionary *loactionInfo))complete {
//  dispatch_async(dispatch_get_main_queue(), ^{
    [self startLocation];
    self.complete = complete;
//  });
}

@end
