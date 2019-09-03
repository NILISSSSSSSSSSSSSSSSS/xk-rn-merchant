//
//  XKSqureConsultLsitCell.h
//  XKSquare
//
//  Created by hupan on 2018/10/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConsultItemModel;

@interface XKSqureConsultLsitCell : UITableViewCell

@property (nonatomic, strong) UIView  *backView;

- (void)setValueWithModel:(ConsultItemModel *)model;

@end
