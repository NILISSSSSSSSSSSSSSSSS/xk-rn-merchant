//
//  XKCityListDefaults.m
//  XKSquare
//
//  Created by Lin Li on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCityListDefaults.h"

@implementation XKCityListDefaults
+ (void)saveValue:(id)value forKey:(NSString *)key {
    [XKCityListUserDefault setObject:value forKey:key];
    [XKCityListUserDefault synchronize];
}

+ (void)saveCityNumber:(id)cityNumber {
    [self saveValue:cityNumber forKey:XKCityListCityNumber];
}

+ (void)saveCurrentCity:(id)currentCity {
    [self saveValue:currentCity forKey:XKCityListCurrentCity];
}

+ (void)saveLocationCity:(id)locationCity {
    [self saveValue:locationCity forKey:XKCityListLocationCity];
}

+ (void)savePrivateCityNumber:(id)privateCityNumber {
    [self saveValue:privateCityNumber forKey:XKCityListPrivateCityNumber];
}

+(void)saveParentCity:(id)parentCity {
    [self saveValue:parentCity forKey:XKCityListParentCity];
}

+ (void)saveProvinceCacheListVersion:(id)provinceCacheListVersion {
    [self saveValue:provinceCacheListVersion forKey:XKProvinceCacheListVersion];

}

+ (void)saveCityCacheListVersion:(id)cityCacheListVersion {
    [self saveValue:cityCacheListVersion forKey:XKCityCacheListVersion];

}

+ (void)saveDistrictCacheListVersion:(id)districtCacheListVersion {
    [self saveValue:districtCacheListVersion forKey:XKDistrictCacheListVersion];
}

+ (id)getCityNumber {
    return [XKCityListUserDefault objectForKey:XKCityListCityNumber];
}

+ (id)getCurrentCity {
    return [XKCityListUserDefault objectForKey:XKCityListCurrentCity];
}

+ (id)getLocationCity {
    return [XKCityListUserDefault objectForKey:XKCityListLocationCity];
}

+ (id)getPrivateCityNumber {
    return [XKCityListUserDefault objectForKey:XKCityListPrivateCityNumber];
}

+(id)getParentCity {
    return [XKCityListUserDefault objectForKey:XKCityListParentCity];
}

+(id)getProvinceCacheListVersion {
    return [XKCityListUserDefault objectForKey:XKProvinceCacheListVersion];

}

+ (id)getCityCacheListVersion {
    return [XKCityListUserDefault objectForKey:XKCityCacheListVersion];

}

+ (id)getDistrictCacheListVersion {
    return [XKCityListUserDefault objectForKey:XKDistrictCacheListVersion];

}
@end
