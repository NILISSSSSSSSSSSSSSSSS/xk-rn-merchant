//
//  XKCityNormalTableViewCell.h
//  XKSquare
//
//  Created by Lin Li on 2018/8/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKCityListModel.h"
@interface XKCityNormalTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel   *cityTextLabel;
@property (nonatomic, strong) XKCityListModel   *model;

@end
