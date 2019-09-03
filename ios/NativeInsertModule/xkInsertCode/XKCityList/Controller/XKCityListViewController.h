//
//  XKCityListViewController.h
//  XKSquare
//
//  Created by Lin Li on 2018/8/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"


typedef void(^CitySelectedBlock)(NSString *cityName, double laititude, double longtitude, NSString *cityCode);

@interface XKCityListViewController : BaseViewController

@property (nonatomic, copy  ) CitySelectedBlock  citySelectedBlock;

@end
