//
//  XKCityCollectionViewCell.h
//  XKSquare
//
//  Created by Lin Li on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKCityListModel.h"
@interface XKCityCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong)XKCityListModel *model;
@property (nonatomic, strong) UILabel *label;
@end
