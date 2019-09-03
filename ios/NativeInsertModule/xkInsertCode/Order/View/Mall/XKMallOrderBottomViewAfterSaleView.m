//
//  XKMallOrderBottomViewAfterSaleView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderBottomViewAfterSaleView.h"
@interface XKMallOrderBottomViewAfterSaleView ()
/**全选/反选*/
@property (nonatomic, strong)UIButton *choseBtn;
/**合并付款*/
@property (nonatomic, strong)UIButton *sureBtn;
@end

@implementation XKMallOrderBottomViewAfterSaleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}

- (void)addCustomSubviews {
    
    [self addSubview:self.sureBtn];
    [self addSubview:self.choseBtn];
}

- (void)addUIConstraint {
    
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(80);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.mas_top).offset(15);
        make.width.mas_equalTo(70);
    }];
}

- (void)sureBtnClick:(UIButton *)sender {
    if(self.sureBtnBlock) {
        self.sureBtnBlock(sender);
    }
}

- (void)choseBtnClick:(UIButton *)sender {
    if(self.choseBlock) {
        self.choseBlock(sender);
    }
}

- (void)choseAll:(BOOL)all {
    self.choseBtn.selected = all;
}

- (UIButton *)choseBtn {
    if(!_choseBtn) {
        _choseBtn = [[UIButton alloc] init];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
        _choseBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 23, 0, 15);
        _choseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [_choseBtn setTitle:@"全选" forState:0];
        [_choseBtn setTitle:@"全选" forState:UIControlStateSelected];
        _choseBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
        [_choseBtn addTarget:self action:@selector(choseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_choseBtn setTitleColor:UIColorFromRGB(0x777777) forState:0];
        [_choseBtn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateSelected];
    }
    return _choseBtn;
}

- (UIButton *)sureBtn {
    if(!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确认退货" forState:0];
        _sureBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_sureBtn setTitleColor:UIColorFromRGB(0xee6161) forState:0];
        [_sureBtn setBackgroundColor:[UIColor whiteColor]];
        _sureBtn.layer.borderWidth = 1.f;
        _sureBtn.layer.borderColor = UIColorFromRGB(0xee6161).CGColor;
        _sureBtn.layer.cornerRadius = 10.f;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end
