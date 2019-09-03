//
//  XKTradingAreaPrizeHeaderView.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/6.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKTradingAreaPrizeHeaderView.h"
@interface XKTradingAreaPrizeHeaderView ()
/**
 与我的距离
 */
@property (nonatomic, strong)UIButton *distanceBtn;
/**
 人均消费
 */
@property (nonatomic, strong)UIButton *priceBtn;

@property (nonatomic, strong)UIView *line;

@end

@implementation XKTradingAreaPrizeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.distanceBtn];
    [self addSubview:self.priceBtn];
    [self addSubview:self.line];

}

- (void)addUIConstraint {
    CGFloat btnW = SCREEN_WIDTH / 2;
    [self.distanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(btnW, 44));
    }];
    
    [self.priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(btnW, 44));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(1);
    }];
    
    [self layoutIfNeeded];
    [_distanceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_distanceBtn.imageView.size.width, 0, _distanceBtn.imageView.size.width + 10)];
    [_distanceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _distanceBtn.titleLabel.bounds.size.width + 10, 0, -_distanceBtn.titleLabel.bounds.size.width)];
    
    [_priceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_priceBtn.imageView.size.width, 0, _priceBtn.imageView.size.width + 10)];
    [_priceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _priceBtn.titleLabel.bounds.size.width + 10, 0, -_priceBtn.titleLabel.bounds.size.width)];
}


- (UIButton *)distanceBtn {
    if(!_distanceBtn) {
        _distanceBtn = [[UIButton alloc] init];
        _distanceBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_distanceBtn setBackgroundColor:[UIColor whiteColor]];
        [_distanceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_unselected"] forState:0];
        [_distanceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_default"] forState:UIControlStateSelected];
        [_distanceBtn setTitle:@"与我的距离" forState:0];
        [_distanceBtn setTitle:@"与我的距离" forState:UIControlStateSelected];
        [_distanceBtn setTitleColor:UIColorFromRGB(0x222222) forState:0];
        [_distanceBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateSelected];
        _distanceBtn.titleLabel.font = XKRegularFont(14);
        [_distanceBtn addTarget:self action:@selector(distanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _distanceBtn.selected = YES;
    }
    return _distanceBtn;
}

- (UIButton *)priceBtn {
    if(!_priceBtn) {
        _priceBtn = [[UIButton alloc] init];
        [_priceBtn setBackgroundColor:[UIColor whiteColor]];
        [_priceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_unselected"] forState:0];
        [_priceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_selected"] forState:UIControlStateSelected];
        [_priceBtn setTitle:@"人均消费" forState:0];
        [_priceBtn setTitle:@"人均消费" forState:UIControlStateSelected];
        [_priceBtn setTitleColor:UIColorFromRGB(0x222222) forState:0];
        [_priceBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateSelected];
        _priceBtn.titleLabel.font = XKRegularFont(14);
        [_priceBtn addTarget:self action:@selector(priceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceBtn;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor blueColor];
    }
    return _line;
}
- (void)distanceBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.priceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_unselected"] forState:0];
    self.priceBtn.selected  = NO;
    [self.distanceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_selected"] forState:0];
    [self.distanceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_default"] forState:UIControlStateSelected];
    if (self.distanceBClickBlock) {
        self.distanceBClickBlock(sender);
    }
}


- (void)priceBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.distanceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_unselected"] forState:0];
    self.distanceBtn.selected  = NO;
    [self.priceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_selected"] forState:0];
    [self.priceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_default"] forState:UIControlStateSelected];
    if (self.priceBClickBlock) {
        self.priceBClickBlock(sender);
    }
}

@end
