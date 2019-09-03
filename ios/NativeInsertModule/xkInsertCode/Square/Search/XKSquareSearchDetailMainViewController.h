//
//  XKSquareSearchDetailMainViewController.h
//  XKSquare
//
//  Created by hupan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, SearchMainEntryType) {
    SearchMainEntryType_Home,//首页
    SearchMainEntryType_Welfare,//福利
    SearchMainEntryType_Mall,//自营
    SearchMainEntryType_Area,//商圈
};

@interface XKSquareSearchDetailMainViewController : BaseViewController

@property (nonatomic, copy  ) NSString             *searchText;
@property (nonatomic, assign) SearchMainEntryType  searchType;

@end
