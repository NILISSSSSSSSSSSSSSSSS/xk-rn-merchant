//
//  XKTradingAreaMainListViewController.h
//  XKSquare
//
//  Created by hupan on 2018/9/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
@class XKTradingAreaPullDownMenu;

typedef enum : NSUInteger {
    
    TradingAreaMainListVC_nomal,
    TradingAreaMainListVC_topHeight84,
    
} TradingAreaMainListVC;

@interface XKTradingAreaMainListViewController : BaseViewController

@property (nonatomic, assign) TradingAreaMainListVC        listVCType;
@property (nonatomic, strong) XKTradingAreaPullDownMenu    *filterView;

@property (nonatomic, copy  ) NSArray    *sortArr;
@property (nonatomic, copy  ) NSString   *oneLeverCode;
@property (nonatomic, copy  ) NSArray    *twoLeverArr;

- (void)selectedTitleAtIndex:(NSInteger)index itemIndex:(NSInteger)itemIndex;

@end
