//
//  XKMallTopFilterView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallTopFilterView.h"
@interface XKMallTopFilterView ()
/**
 人气
 */
@property (nonatomic, strong)UIButton *hotBtn;
/**
 销量
 */
@property (nonatomic, strong)UIButton *sellBtn;
/**
 价格
 */
@property (nonatomic, strong)UIButton *priceBtn;
@end

@implementation XKMallTopFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.hotBtn];
    [self addSubview:self.sellBtn];
    [self addSubview:self.priceBtn];
}

- (void)addUIConstraint {
    CGFloat btnW = SCREEN_WIDTH / 3;
    [self.hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(btnW, 44));
    }];
    
    [self.priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(btnW, 44));
    }];
    
    [self.sellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotBtn.mas_right);
        make.top.equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(btnW, 44));
    }];
    
    [self layoutIfNeeded];
    [_hotBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_hotBtn.imageView.size.width, 0, _hotBtn.imageView.size.width + 10)];
    [_hotBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _hotBtn.titleLabel.bounds.size.width + 10, 0, -_hotBtn.titleLabel.bounds.size.width)];
    
    [_sellBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_sellBtn.imageView.size.width, 0, _sellBtn.imageView.size.width + 10)];
    [_sellBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _sellBtn.titleLabel.bounds.size.width + 10, 0, -_sellBtn.titleLabel.bounds.size.width)];
    
    [_priceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_priceBtn.imageView.size.width, 0, _priceBtn.imageView.size.width + 10)];
    [_priceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _priceBtn.titleLabel.bounds.size.width + 10, 0, -_priceBtn.titleLabel.bounds.size.width)];
}

#pragma mark event
- (void)hotBtnClick:(UIButton *)sender {
    [self.sellBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_unselected"] forState:0];
    [self.priceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_unselected"] forState:0];
    self.sellBtn.selected  = NO;
    self.priceBtn.selected  = NO;
    
    [self.hotBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_selected"] forState:0];
    [self.hotBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_default"] forState:UIControlStateSelected];
    if(self.hotBClickBlock) {
        self.hotBClickBlock(sender);
    }
}

- (void)sellBtnClick:(UIButton *)sender {
    [self.hotBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_unselected"] forState:0];
    [self.priceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_unselected"] forState:0];
    self.hotBtn.selected  = NO;
    self.priceBtn.selected  = NO;
    
    [self.sellBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_selected"] forState:0];
    [self.sellBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_default"] forState:UIControlStateSelected];
    if(self.sellBClickBlock) {
        self.sellBClickBlock(sender);
    }
}

- (void)priceBtnClick:(UIButton *)sender {
    [self.hotBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_unselected"] forState:0];
    [self.sellBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_unselected"] forState:0];
    self.hotBtn.selected  = NO;
    self.sellBtn.selected  = NO;
    
    [self.priceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_selected"] forState:0];
    [self.priceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_default"] forState:UIControlStateSelected];
    if(self.priceBClickBlock) {
        self.priceBClickBlock(sender);
    }
}
#pragma mark lazy
- (UIButton *)hotBtn {
    if(!_hotBtn) {
        _hotBtn = [[UIButton alloc] init];
        _hotBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_hotBtn setBackgroundColor:[UIColor whiteColor]];
        [_hotBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_unselected"] forState:0];
        [_hotBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_default"] forState:UIControlStateSelected];
        [_hotBtn setTitle:@"人气" forState:0];
        [_hotBtn setTitle:@"人气" forState:UIControlStateSelected];
        [_hotBtn setTitleColor:UIColorFromRGB(0x222222) forState:0];
        [_hotBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateSelected];
        _hotBtn.titleLabel.font = XKRegularFont(14);
        [_hotBtn addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _hotBtn.selected = YES;
    }
    return _hotBtn;
}

- (UIButton *)priceBtn {
    if(!_priceBtn) {
        _priceBtn = [[UIButton alloc] init];
        [_priceBtn setBackgroundColor:[UIColor whiteColor]];
        [_priceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_unselected"] forState:0];
        [_priceBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_selected"] forState:UIControlStateSelected];
        [_priceBtn setTitle:@"价格" forState:0];
        [_priceBtn setTitle:@"价格" forState:UIControlStateSelected];
        [_priceBtn setTitleColor:UIColorFromRGB(0x222222) forState:0];
        [_priceBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateSelected];
        _priceBtn.titleLabel.font = XKRegularFont(14);
        [_priceBtn addTarget:self action:@selector(priceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceBtn;
}

- (UIButton *)sellBtn {
    if(!_sellBtn) {
        _sellBtn = [[UIButton alloc] init];
        [_sellBtn setBackgroundColor:[UIColor whiteColor]];
        [_sellBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_unselected"] forState:0];
        [_sellBtn setImage:[UIImage imageNamed:@"xk_mall_btn_sort_selected"] forState:UIControlStateSelected];
        [_sellBtn setTitle:@"销量" forState:0];
        [_sellBtn setTitle:@"销量" forState:UIControlStateSelected];
        [_sellBtn setTitleColor:UIColorFromRGB(0x222222) forState:0];
        [_sellBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateSelected];
        _sellBtn.titleLabel.font = XKRegularFont(14);
        [_sellBtn addTarget:self action:@selector(sellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sellBtn;
}

@end
