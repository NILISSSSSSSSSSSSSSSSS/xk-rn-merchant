//
//  XKCityHeaderView.h
//  XKSquare
//
//  Created by Lin Li on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKCityListModel.h"
@protocol XKCityHeaderViewDelegate <NSObject>

- (void)cityNameWithSelected:(BOOL)selected;
- (void)searchButtonSelected;
- (void)backButtonSelected;

@end

@interface XKCityHeaderView : UIView
@property (nonatomic, copy) NSString   *cityName;
@property (nonatomic, copy) NSString *buttonTitle;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, weak) id<XKCityHeaderViewDelegate> delegate;
@property (nonatomic, strong) DataItem *model;
@end
