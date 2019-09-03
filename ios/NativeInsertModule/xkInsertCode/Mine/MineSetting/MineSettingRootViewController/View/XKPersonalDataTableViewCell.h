//
//  XKPersonalDataTableViewCell.h
//  XKSquare
//
//  Created by Lin Li on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XKCornerRadius.h"

@interface XKPersonalDataTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *smallLabel;
@property (nonatomic, strong)UILabel *rightTitlelabel;
@property (nonatomic, strong)UIImageView *nextImageView;
@property (nonatomic, strong)UIView      *myContentView;


@end
