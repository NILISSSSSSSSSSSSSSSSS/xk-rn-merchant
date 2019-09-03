//
//  XKBuySuccessView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKBuySuccessView.h"
@interface XKBuySuccessView ()

@property (nonatomic, strong) UIImageView  *topImgView;
@property (nonatomic, strong) UIView  *lineView;
@property (nonatomic, strong) UIView  *bottomView;
@property (nonatomic, strong) UIView  *left;
@property (nonatomic, strong) UIButton  *orderBtn;
@property (nonatomic, strong) UIButton  *keepBtn;
@property (nonatomic, strong) UIButton  *groundBtn;

@end

@implementation XKBuySuccessView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor  = [UIColor whiteColor];
        [self addCustomSubviews];
    }
    return self;
}



- (void)addCustomSubviews {
    _topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 220 * ScreenScale)];
    _topImgView.image = [UIImage imageNamed:@"xk_btn_welfare_pay_result"];
    _topImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_topImgView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topImgView.frame ) + 1, SCREEN_WIDTH - 20, 1)];
    _lineView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    [self addSubview:_lineView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lineView.frame ) + 1,SCREEN_WIDTH - 20, 42 * ScreenScale)];
    _bottomView.backgroundColor = [UIColor clearColor];
     [self addSubview:_bottomView];
    
    CGFloat padd =  (SCREEN_WIDTH - 20 - 70 * 3) / 6;
    _orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(padd, 0, 70, 22 * ScreenScale)];
    [_orderBtn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
    _orderBtn.layer.cornerRadius = 12.f;
    _orderBtn.layer.borderWidth = 1.f;
    _orderBtn.layer.borderColor = XKMainTypeColor.CGColor;
    _orderBtn.layer.masksToBounds = YES;
    [_orderBtn setTitle:@"查看订单" forState:0];
    [_orderBtn setTitleColor:XKMainTypeColor forState:0];
    _orderBtn.titleLabel.font = XKRegularFont(12);
    
    _keepBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_orderBtn.frame) + 2 * padd, 0, 70, 22 * ScreenScale)];
    [_keepBtn addTarget:self action:@selector(keepClick:) forControlEvents:UIControlEventTouchUpInside];
    _keepBtn.layer.cornerRadius = 12.f;
    _keepBtn.layer.borderWidth = 1.f;
    _keepBtn.layer.borderColor = XKMainTypeColor.CGColor;
    _keepBtn.layer.masksToBounds = YES;
    [_keepBtn setTitle:@"继续兑奖" forState:0];
    [_keepBtn setTitleColor:XKMainTypeColor forState:0];
    _keepBtn.titleLabel.font = XKRegularFont(12);
    
    _groundBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_keepBtn.frame)  + 2 * padd, 0, 70, 22 * ScreenScale)];
    [_groundBtn addTarget:self action:@selector(groundClick:) forControlEvents:UIControlEventTouchUpInside];
    _groundBtn.layer.cornerRadius = 12.f;
    _groundBtn.layer.borderWidth = 1.f;
    _groundBtn.layer.borderColor = XKMainTypeColor.CGColor;
    _groundBtn.layer.masksToBounds = YES;
    [_groundBtn setTitle:@"返回广场" forState:0];
    [_groundBtn setTitleColor:XKMainTypeColor forState:0];
    _groundBtn.titleLabel.font = XKRegularFont(12);
    
    [_bottomView addSubview:_orderBtn];
    [_bottomView addSubview:_keepBtn];
    [_bottomView addSubview:_groundBtn];
    
    _orderBtn.centerY =  21 * ScreenScale;
    _keepBtn.centerY =  21 * ScreenScale;
    _groundBtn.centerY =  21 * ScreenScale;
    
 
}

- (void)orderClick:(UIButton *)sender {
    if (self.orderBlock) {
        self.orderBlock(sender);
    }
}

- (void)keepClick:(UIButton *)sender {
    if (self.keepBlock) {
        self.keepBlock(sender);
    }
}

- (void)groundClick:(UIButton *)sender {
    if (self.gorundBlock) {
        self.gorundBlock(sender);
    }
}
@end
