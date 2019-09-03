//
//  XKMallOrderListWaitPayBottomView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderListWaitPayBottomView.h"
@interface XKMallOrderListWaitPayBottomView ()
/**全选/反选*/
@property (nonatomic, strong)UIButton *choseBtn;
/**合并付款*/
@property (nonatomic, strong)UIButton *totalBtn;
@end

@implementation XKMallOrderListWaitPayBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}

- (void)addCustomSubviews {
    
    [self addSubview:self.totalBtn];
    [self addSubview:self.choseBtn];

}

- (void)addUIConstraint {
    
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(80);
    }];
    
    [self.totalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.mas_top).offset(15);
        make.width.mas_equalTo(70);
    }];
}

- (void)totalBtnClick:(UIButton *)sender {
    if(self.totalBtnBlock) {
        self.totalBtnBlock(sender);
    }
}

- (void)choseBtnClick:(UIButton *)sender {
    if(self.choseBlock) {
        self.choseBtn.selected = !self.choseBtn.selected;
        self.choseBlock(sender);
    }
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

- (UIButton *)totalBtn {
    if(!_totalBtn) {
        _totalBtn = [[UIButton alloc] init];
        [_totalBtn setTitle:@"合并付款" forState:0];
        _totalBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_totalBtn setTitleColor:UIColorFromRGB(0xee6161) forState:0];
        [_totalBtn setBackgroundColor:[UIColor whiteColor]];
        _totalBtn.layer.borderWidth = 1.f;
        _totalBtn.layer.borderColor = UIColorFromRGB(0xee6161).CGColor;
        _totalBtn.layer.cornerRadius = 10.f;
        _totalBtn.layer.masksToBounds = YES;
        [_totalBtn addTarget:self action:@selector(totalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _totalBtn;
}

@end
