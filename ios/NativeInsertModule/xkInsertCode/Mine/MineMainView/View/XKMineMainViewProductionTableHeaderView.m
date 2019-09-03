//
//  XKMineMainViewProductionTableHeaderView.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineMainViewProductionTableHeaderView.h"

@implementation XKMineMainViewProductionTableHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    self.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
    [self initializeProductionHeaderView];
    
    return self;
}

/** 初始化我的作品区头 */
- (void)initializeProductionHeaderView {
    
    UIView *productionContainerView = [UIView new];
    productionContainerView.backgroundColor = [UIColor whiteColor];
    productionContainerView.xk_openClip = YES;
    productionContainerView.xk_radius = 8;
    productionContainerView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
    [self addSubview:productionContainerView];
    [productionContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"我的作品";
    titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
    [productionContainerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productionContainerView.mas_top).offset(13);
        make.left.equalTo(productionContainerView.mas_left).offset(12);
    }];
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = XKSeparatorLineColor;
    [productionContainerView addSubview:separatorView];
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(productionContainerView.mas_bottom);
        make.left.equalTo(productionContainerView.mas_left);
        make.right.equalTo(productionContainerView.mas_right);
        make.height.equalTo(@(1));
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
