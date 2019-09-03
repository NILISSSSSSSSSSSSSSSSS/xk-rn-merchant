//
//  XKMineCouponPackageTerminalCouponTableViewHeader.m
//  XKSquare
//
//  Created by RyanYuan on 2018/12/4.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMineCouponPackageTerminalCouponTableViewHeader.h"
#import "XKMineCouponPackageCouponModel.h"

@interface XKMineCouponPackageTerminalCouponTableViewHeader ()

@property (nonatomic, strong) UILabel *shopNameLabel;

@end

@implementation XKMineCouponPackageTerminalCouponTableViewHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    [self initializeHeaderView];
    
    return self;
}

- (void)initializeHeaderView {
    
    self.shopNameLabel = [UILabel new];
    self.shopNameLabel.textColor = [UIColor darkGrayColor];
    self.shopNameLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:15.0];
    [self.contentView addSubview:self.shopNameLabel];
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(10);
    }];
}

- (void)configHeaderViewWithModel:(XKMineCouponPackageCouponModelDataItem *)model {
    
    if (model.shopName && model.shopName.length != 0) {
        self.shopNameLabel.text = model.shopName;
    }
}

@end
