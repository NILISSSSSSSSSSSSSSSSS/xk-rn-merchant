//
//  XKSqureSearchViewController.h
//  XKSquare
//
//  Created by hupan on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, SearchEntryType) {
    SearchEntryType_Home,//首页
    SearchEntryType_Welfare,//福利
    SearchEntryType_Mall,//自营
    SearchEntryType_Area,//商圈
};

@interface XKSqureSearchViewController : BaseViewController

@property (nonatomic, copy  ) NSString         *searchText;
@property (nonatomic, assign) SearchEntryType  searchType;

@end
