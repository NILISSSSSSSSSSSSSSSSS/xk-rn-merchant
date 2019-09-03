//
//  XKMallOrderDetailWaitAcceptBottomView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderDetailWaitAcceptBottomView.h"
@interface XKMallOrderDetailWaitAcceptBottomView ()
@property (nonatomic, strong)UIButton *moreBtn;
@property (nonatomic, strong)UIButton *tipBtn;
@end

@implementation XKMallOrderDetailWaitAcceptBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.moreBtn];
    [self addSubview:self.tipBtn];
}

- (void)addUIConstraint {
    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.mas_top).offset(12);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tipBtn.mas_left);
        make.centerY.equalTo(self.tipBtn);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(50);
    }];
    
    
}

- (void)moreBtnClick:(UIButton *)sender {
    if(self.moreBtnBlock) {
        self.moreBtnBlock(sender);
    }
}

- (void)tipBtnClick:(UIButton *)sender {
    if(self.tipBtnBlock) {
        self.tipBtnBlock(sender);
    }
}

- (UIButton *)moreBtn {
    if(!_moreBtn) {
        _moreBtn = [UIButton new];
        [_moreBtn setTitle:@"更多" forState:0];
        _moreBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_moreBtn setTitleColor:UIColorFromRGB(0x222222) forState:0];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _moreBtn;
}

- (UIButton *)tipBtn {
    if(!_tipBtn) {
        _tipBtn = [UIButton new];
        [_tipBtn setTitle:@"确认收货" forState:0];
        _tipBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_tipBtn setTitleColor:UIColorFromRGB(0xee6161) forState:0];
        _tipBtn.layer.cornerRadius = 10.f;
        _tipBtn.layer.masksToBounds = YES;
        _tipBtn.layer.borderWidth = 1.f;
        _tipBtn.layer.borderColor = UIColorFromRGB(0xee6161).CGColor;
        [_tipBtn addTarget:self action:@selector(tipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _tipBtn;
}

@end
