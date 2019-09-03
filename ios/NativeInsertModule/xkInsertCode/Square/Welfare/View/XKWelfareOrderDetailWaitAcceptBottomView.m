//
//  XKWelfareOrderDetailWaitAcceptBottomView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailWaitAcceptBottomView.h"

@interface XKWelfareOrderDetailWaitAcceptBottomView ()
@property (nonatomic, strong)UIButton *chatBtn;
@property (nonatomic, strong)UIButton *sureBtn;
@property (nonatomic, strong)UIButton *moreBtn;
@end

@implementation XKWelfareOrderDetailWaitAcceptBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
    
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.chatBtn];
    [self addSubview:self.sureBtn];
    [self addSubview:self.moreBtn];
}

- (void)addUIConstraint {
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(105 * ScreenScale);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chatBtn.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(105 * ScreenScale);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sureBtn.mas_left).offset(0);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(40 * ScreenScale);
    }];
}

- (void)chatBtnClick:(UIButton *)sender {
    if(self.chatBtnBlock) {
        self.chatBtnBlock(sender);
    }
}

- (void)sureBtnClick:(UIButton *)sender {
    if(self.sureBtnBlock) {
        self.sureBtnBlock(sender);
    }
}

- (void)moreBtnClick:(UIButton *)sender {
    if(self.moreBtnBlock) {
        self.moreBtnBlock(sender);
    }
}

- (UIButton *)chatBtn {
    if(!_chatBtn) {
        _chatBtn = [UIButton new];
        [_chatBtn setTitle:@"联系客服" forState:0];
        [_chatBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chat"] forState:0];
        _chatBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_chatBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_chatBtn setBackgroundColor:UIColorFromRGB(0xee6161)];
         _chatBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_chatBtn addTarget:self action:@selector(chatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatBtn;
}

- (UIButton *)sureBtn {
    if(!_sureBtn) {
        _sureBtn = [UIButton new];
        [_sureBtn setTitle:@"确认收货" forState:0];
        [_sureBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_accept"] forState:0];
        _sureBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_sureBtn setBackgroundColor:XKMainTypeColor];
        _sureBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)moreBtn {
    if(!_moreBtn) {
        _moreBtn = [UIButton new];
        [_moreBtn setTitle:@"更多" forState:0];
        _moreBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:12];
        [_moreBtn setTitleColor:UIColorFromRGB(0x999999) forState:0];
        [_moreBtn setBackgroundColor:[UIColor clearColor]];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}
@end
