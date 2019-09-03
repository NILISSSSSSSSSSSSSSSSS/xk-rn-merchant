//
//  XKSearchCityListViewController.h
//  XKSquare
//
//  Created by Lin Li on 2018/8/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^searcheSelectedBlock)(NSString *cityName, double laititude, double longtitude, NSString *cityCode,NSString *level,NSString *parentCode);

@interface XKSearchCityListViewController : BaseViewController
/**选择回调*/
@property(nonatomic, copy) searcheSelectedBlock block;
@end
