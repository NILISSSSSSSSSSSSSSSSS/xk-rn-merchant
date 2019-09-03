//
//  XKWelfareOrderDetailWaitSendView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailWaitSendBottomView.h"

@interface XKWelfareOrderDetailWaitSendBottomView ()
@property (nonatomic, strong)UIButton *moreBtn;
@property (nonatomic, strong)UIButton *chatBtn;
@property (nonatomic, strong)UIButton *tipBtn;
@end

@implementation XKWelfareOrderDetailWaitSendBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {

    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.chatBtn];
 //   [self addSubview:self.moreBtn];
    [self addSubview:self.tipBtn];
}

- (void)addUIConstraint {
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(105 * ScreenScale);
    }];
    
    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chatBtn.mas_left);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(105 * ScreenScale);
    }];
//
//    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.tipBtn.mas_left);
//        make.top.equalTo(self.mas_top);
//        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
//        make.width.mas_equalTo(70 * ScreenScale);
//    }];
}

- (void)chatBtnClick:(UIButton *)sender {
    if(self.chatBtnBlock) {
        self.chatBtnBlock(sender);
    }
}

- (void)tipBtnClick:(UIButton *)sender {
    if(self.tipBtnBlock) {
        self.tipBtnBlock(sender);
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

- (UIButton *)moreBtn {
    if(!_moreBtn) {
        _moreBtn = [UIButton new];
        [_moreBtn setTitle:@"更多" forState:0];
        _moreBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_moreBtn setTitleColor:UIColorFromRGB(0x555555) forState:0];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIButton *)tipBtn {
    if(!_tipBtn) {
        _tipBtn = [UIButton new];
        [_tipBtn setTitle:@"提醒发货" forState:0];
        [_tipBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_trans_detail"] forState:0];
        _tipBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_tipBtn setTitleColor:[UIColor whiteColor] forState:0];
        _tipBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_tipBtn setBackgroundColor:XKMainTypeColor];
        [_tipBtn addTarget:self action:@selector(tipBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _tipBtn;
}
@end
