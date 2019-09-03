//
//  XKWelfareOrderFinishBottomView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailFinishBottomView.h"

@interface XKWelfareOrderDetailFinishBottomView ()
/**全选/反选*/
@property (nonatomic, strong)UIButton *choseBtn;
/**删除*/
@property (nonatomic, strong)UIButton *deleteBtn;

@end

@implementation XKWelfareOrderDetailFinishBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}

- (void)addCustomSubviews {

    [self addSubview:self.choseBtn];
    [self addSubview:self.deleteBtn];
}

- (void)addUIConstraint {
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(80);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight + 10));
        make.width.mas_equalTo(80);
    }];
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

- (UIButton *)deleteBtn {
    if(!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除" forState:0];
        _deleteBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_deleteBtn setTitleColor:UIColorFromRGB(0xffffff) forState:0];
        [_deleteBtn setBackgroundColor:UIColorFromRGB(0xee6161)];
        _deleteBtn.layer.cornerRadius = 3.f;
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.layer.masksToBounds = YES;
    }
    return _deleteBtn;
}

- (void)deleteBtnClick:(UIButton *)sender {
    if(self.deleteBlock) {
        self.deleteBlock(sender);
    }
}

- (void)choseBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(self.choseBlock) {
        self.choseBlock(sender);
    }
}

@end
