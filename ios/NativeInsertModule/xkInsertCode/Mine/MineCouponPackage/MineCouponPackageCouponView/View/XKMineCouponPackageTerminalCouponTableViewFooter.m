//
//  XKMineCouponPackageTerminalCouponTableViewFooter.m
//  XKSquare
//
//  Created by RyanYuan on 2018/12/4.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMineCouponPackageTerminalCouponTableViewFooter.h"
#import "XKMineCouponPackageCouponModel.h"

@interface XKMineCouponPackageTerminalCouponTableViewFooter ()

@property (nonatomic, strong) UIButton *loadMoreButton;
@property (nonatomic, strong) XKMineCouponPackageCouponModelDataItem *shopModel;

@end

@implementation XKMineCouponPackageTerminalCouponTableViewFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    self.contentView.backgroundColor = [UIColor redColor];
    [self initializeFooterView];
    
    return self;
}

- (void)initializeFooterView {
    
    self.loadMoreButton = [UIButton new];
    [self.loadMoreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.loadMoreButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
    [self.loadMoreButton addTarget:self action:@selector(clickLoadMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.loadMoreButton setTitle:@"更多" forState:UIControlStateNormal];
    [self.loadMoreButton setImage:[UIImage imageNamed:@"xk_btn_mall_ticket_down"] forState:UIControlStateNormal];
    [self.loadMoreButton setTitle:@"收起" forState:UIControlStateHighlighted];
    [self.loadMoreButton setImage:[UIImage imageNamed:@"xk_btn_mall_ticket_top"] forState:UIControlStateHighlighted];
    
    // button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
    self.loadMoreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
    // button标题的偏移量，这个偏移量是相对于图片的
    self.loadMoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    [self.contentView addSubview:self.loadMoreButton];
    [self.loadMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-18);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.offset(80);
    }];
    
    
}

- (void)configFooterViewWithModel:(XKMineCouponPackageCouponModelDataItem *)model {
    
    self.shopModel = model;
    if (model.isShowingAll) {
        self.loadMoreButton.highlighted = YES;
    } else {
        self.loadMoreButton.highlighted = NO;
    }
}

- (void)clickLoadMoreButton:(UIButton *)sender {
    
    self.shopModel.isShowingAll = !self.shopModel.isShowingAll;
    [self.delegate tableViewFooter:self updateModel:self.shopModel];
}

@end
