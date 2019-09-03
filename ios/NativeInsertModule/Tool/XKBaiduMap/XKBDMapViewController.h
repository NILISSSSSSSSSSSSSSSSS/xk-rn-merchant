//
//  XKBDMapViewController.h
//  XKBDMap
//
//  Created by hupan on 2018/7/26.
//  Copyright © 2018年 Tears. All rights reserved.
//

#import "BaseViewController.h"

@interface XKBDMapViewController : BaseViewController

//当前经纬度
@property (nonatomic, assign) CGFloat  myLatitude;
@property (nonatomic, assign) CGFloat  myLongitude;

//目的地及其经纬度
@property (nonatomic, copy  ) NSString *destinationName;
@property (nonatomic, assign) CGFloat  destinationLatitude;
@property (nonatomic, assign) CGFloat  destinationLongitude;


//附近商店信息
@property (nonatomic, copy  ) NSArray  *locationMerchantArray;


@end
