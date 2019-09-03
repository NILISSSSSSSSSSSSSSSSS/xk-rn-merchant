//
//  XKIMMessageCustomerSerOrderContentView.h
//  XKSquare
//
//  Created by william on 2018/9/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "NIMSessionMessageContentView.h"

extern NSString *const NIMMessageCustomerSerOrder;


@interface XKIMMessageCustomerSerOrderContentView : NIMSessionMessageContentView

@property (nonatomic,strong) UIImageView  *orderImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *detailLabel;

@property (nonatomic,strong) UILabel *orderIdLabel;

@end
