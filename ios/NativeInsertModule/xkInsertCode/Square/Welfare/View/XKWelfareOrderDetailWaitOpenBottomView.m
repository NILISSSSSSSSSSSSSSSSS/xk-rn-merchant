//
//  XKWelfareOrderDetailWaitOpenBottomView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailWaitOpenBottomView.h"

@interface XKWelfareOrderDetailWaitOpenBottomView ()
@property (nonatomic, strong)UIButton *chatBtn;

@end

@implementation XKWelfareOrderDetailWaitOpenBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.chatBtn];
}

- (void)addUIConstraint {
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(105);
    }];
}

- (void)chatBtnClick:(UIButton *)sender {
    if(self.chatBtnBlock) {
        self.chatBtnBlock(sender);
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
        [_chatBtn addTarget:self action:@selector(chatBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _chatBtn;
}
@end
