//
//  XKMallListViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
#import "XKMallCategoryListModel.h"
#import "XKMallListViewModel.h"
typedef NS_ENUM(NSInteger, XKMallListLayout) {
    XKMallListLayoutSingle    = 0,        // 列表
    XKMallListLayoutDouble    = 1,        // 宫格
};

typedef NS_ENUM(NSInteger, XKMllFilterType) {
    XKMllFilterTypePopularity = 0,
    XKMllFilterTypeSaleQ,
    XKMllFilterTypePrice,
};

@interface XKMallListViewController : BaseViewController

@property (nonatomic, assign)XKMallListLayout layoutType;
@property (nonatomic, strong)XKMallCategoryListModel *model;
@property (nonatomic, strong)XKMallListViewModel *viewModel;
- (void)updateLayout;
- (void)refreshDataWithCode:(NSInteger)code;

- (void)filterRefreshWithType:(XKMllFilterType )filterType sort:(NSInteger )sort;
@end
