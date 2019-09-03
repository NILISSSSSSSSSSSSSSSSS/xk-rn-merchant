//
//  XKMineMainViewStoreTableHeaderView.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineMainViewStoreTableHeaderView.h"

@implementation XKMineMainViewStoreTableHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    self.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
    [self initializeStoreHeaderView];
    
    return self;
}

/** 初始化福利商城区头 */
- (void)initializeStoreHeaderView {
    
    UIView *storeContainerView = [UIView new];
    storeContainerView.backgroundColor = [UIColor whiteColor];
    storeContainerView.xk_openClip = YES;
    storeContainerView.xk_radius = 8;
    storeContainerView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
    [self addSubview:storeContainerView];
    [storeContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom);
    }];
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"福利商城";
    titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
    [storeContainerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(storeContainerView.mas_top).offset(13);
        make.left.equalTo(storeContainerView.mas_left).offset(12);
    }];
    UIImageView *nextImageView = [UIImageView new];
    nextImageView.image = [UIImage imageNamed:@"xk_btn_order_grayArrow"];
    [storeContainerView addSubview:nextImageView];
    [nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(storeContainerView.mas_right).offset(-15);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.height.width.equalTo(@(12));
    }];
    UIButton *winningRecordsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [winningRecordsButton setTitle:@"获奖记录" forState:UIControlStateNormal];
    [winningRecordsButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    winningRecordsButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
    [winningRecordsButton addTarget:self action:@selector(clickWinningRecordsButton:) forControlEvents:UIControlEventTouchUpInside];
    [storeContainerView addSubview:winningRecordsButton];
    [winningRecordsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nextImageView.mas_left).offset(-5);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = XKSeparatorLineColor;
    [storeContainerView addSubview:separatorView];
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(storeContainerView.mas_bottom);
        make.left.equalTo(storeContainerView.mas_left);
        make.right.equalTo(storeContainerView.mas_right);
        make.height.equalTo(@(1));
    }];
}

- (void)clickWinningRecordsButton:(UIButton *)sender {
    [self.delegate storeTableHeaderView:self clickWinningRecordsButton:sender];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
