//
//  XKWelfareListViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
#import "XKWelfareCategoryModel.h"
typedef NS_ENUM(NSInteger, XKWelfareListLayout) {
    XKWelfareListLayoutSingle    = 0,        // 列表
    XKWelfareListLayoutDouble    = 1,        // 宫格
};

@interface XKWelfareListViewController : BaseViewController
@property (nonatomic, assign) XKWelfareListLayout layoutType;
@property (nonatomic, strong) XKWelfareCategoryModel *model;
@property (nonatomic, assign) NSInteger  type;
- (void)updateLayout;
- (void)refreshData;
@end
