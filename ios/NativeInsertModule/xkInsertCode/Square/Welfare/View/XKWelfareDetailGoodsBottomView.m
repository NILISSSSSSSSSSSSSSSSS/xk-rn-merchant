//
//  XKWelfareDetailGoodsBottomView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareDetailGoodsBottomView.h"
@interface XKWelfareDetailGoodsBottomView ()
/**兑奖*/
@property (nonatomic, strong)UIButton *redeemBtn;
/*加入购物车*/
@property (nonatomic, strong)UIButton *joinBuyCarBtn;
/*购物车*/
@property (nonatomic, strong)UIButton *buyCarBtn;
/*收藏*/
@property (nonatomic, strong)UIButton *collectBtn;
/*聊天*/
@property (nonatomic, strong)UIButton *chatBtn;
@end

@implementation XKWelfareDetailGoodsBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
   
    [self addSubview:self.redeemBtn];
    [self addSubview:self.joinBuyCarBtn];
    [self addSubview:self.buyCarBtn];
    [self addSubview:self.collectBtn];
    [self addSubview:self.chatBtn];
}

- (void)sureBuyTitle:(NSString *)title {
    [self.redeemBtn setTitle:title forState:0];
}

- (void)addUIConstraint {
    CGFloat btnW = (SCREEN_WIDTH - ScreenScale * 105 * 2) / 3;
    
    [self.redeemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(ScreenScale * 105);
    }];
    
    [self.joinBuyCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.redeemBtn.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(ScreenScale * 105);
    }];
    
    [self.buyCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.joinBuyCarBtn.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(btnW);
    }];
    
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.buyCarBtn.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(btnW);
    }];
    
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.collectBtn.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(btnW);
    }];
}

- (UIButton *)redeemBtn {
    if(!_redeemBtn) {
        _redeemBtn = [[UIButton alloc] init];
        [_redeemBtn setTitle:@"立即兑奖" forState:0];
        _redeemBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_redeemBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_redeemBtn setBackgroundColor:UIColorFromRGB(0xee6161)];
        [_redeemBtn addTarget:self action:@selector(redeemBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _redeemBtn;
}

- (UIButton *)joinBuyCarBtn {
    if(!_joinBuyCarBtn) {
        _joinBuyCarBtn = [[UIButton alloc] init];
        [_joinBuyCarBtn setTitle:@"加入购物车" forState:0];
        _joinBuyCarBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_joinBuyCarBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_joinBuyCarBtn setBackgroundColor:XKMainTypeColor];
        [_joinBuyCarBtn addTarget:self action:@selector(joinBuyCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinBuyCarBtn;
}

- (UIButton *)buyCarBtn {
    if(!_buyCarBtn) {
        _buyCarBtn = [[UIButton alloc] init];
        [_buyCarBtn setImage:[UIImage imageNamed:@"xk_icon_welfaregoods_detail_buyCar"] forState:0];
        [_buyCarBtn setBackgroundColor:[UIColor whiteColor]];
        [_buyCarBtn addTarget:self action:@selector(buyCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyCarBtn;
}

- (UIButton *)collectBtn {
    if(!_collectBtn) {
        _collectBtn = [[UIButton alloc] init];
        [_collectBtn setImage:[UIImage imageNamed:@"xk_icon_welfaregoods_detail_star"] forState:0];
        [_collectBtn setImage:[UIImage imageNamed:@"xk_icon_welfaregoods_detail_unstar"] forState:UIControlStateSelected];
        [_collectBtn setBackgroundColor:[UIColor whiteColor]];
        [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectBtn;
}

- (UIButton *)chatBtn {
    if(!_chatBtn) {
        _chatBtn = [[UIButton alloc] init];
        [_chatBtn setImage:[UIImage imageNamed:@"xk_icon_welfaregoods_detail_chat"] forState:0];
        [_chatBtn setBackgroundColor:[UIColor whiteColor]];
        [_chatBtn addTarget:self action:@selector(chatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatBtn;
}

- (void)collectBtnClick:(UIButton *)sender {
    if(self.collectBlock) {
        self.collectBlock(sender);
    }
}

- (void)chatBtnClick:(UIButton *)sender {
    if(self.chatBtnBlock) {
        self.chatBtnBlock(sender);
    }
}

- (void)buyCarBtnClick:(UIButton *)sender {
    if(self.collectBlock) {
        self.collectBlock(sender);
    }
}

- (void)joinBuyCarBtnClick:(UIButton *)sender {
    if(self.joinBuyCarBlock) {
        self.joinBuyCarBlock(sender);
    }
}

- (void)redeemBtnClick:(UIButton *)sender {
    if(self.redeemBlock) {
        self.redeemBlock(sender);
    }
}
@end
