//
//  XKCityListTableViewCell.h
//  XKSquare
//
//  Created by Lin Li on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
//选择定位城市、历史访问城市和热门城市的通知（用来修改“当前：”后面的城市名称）
extern NSString * const XKCityTableViewCellDidChangeCityNotification;
extern NSString * const XKCityTableViewLoctionCellDidChangeCityNotification;

@interface XKCityListTableViewCell : UITableViewCell

@property (nonatomic, copy) NSArray *cityNameArray;
//是否显示定位图标
@property (nonatomic,assign) BOOL isShowLocation;

/**
 是否是全城按钮
 */
@property (nonatomic,assign) BOOL isAllCityButton;

/**当前选中城市的名字*/
@property(nonatomic, strong) NSString *currentCityName;
@end
