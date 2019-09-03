//
//  XKWelfareBuyCarBottomView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailBuyCarBottomView.h"

@interface XKWelfareOrderDetailBuyCarBottomView ()
/**全选/反选*/
@property (nonatomic, strong)UIButton *choseBtn;
/**移入收藏夹*/
@property (nonatomic, strong)UIButton *collectionBtn;
/**删除*/
@property (nonatomic, strong)UIButton *deleteBtn;
/*结算*/
@property (nonatomic, strong)UIButton *finishBtn;
/**合计*/
@property (nonatomic, strong)UILabel *countLabel;
@end

@implementation XKWelfareOrderDetailBuyCarBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {

        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {

     [self addSubview:self.finishBtn];
     [self addSubview:self.choseBtn];
     [self addSubview:self.collectionBtn];
     [self addSubview:self.deleteBtn];
     [self addSubview:self.countLabel];
}

- (void)addUIConstraint {

    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.mas_bottom).offset(-kBottomSafeHeight);
        make.width.mas_equalTo(105);
    }];
    
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-kBottomSafeHeight);
        make.width.mas_equalTo(80);
    }];

    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.finishBtn);
        make.right.equalTo(self.finishBtn.mas_left).offset(-20);
    }];

    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.mas_bottom).offset(-kBottomSafeHeight);
        make.width.mas_equalTo(105);
    }];

    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteBtn.mas_left);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.mas_bottom).offset(-kBottomSafeHeight);
        make.width.mas_equalTo(105);
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

- (UIButton *)finishBtn {
    if(!_finishBtn) {
        _finishBtn = [[UIButton alloc] init];
        [_finishBtn setTitle:@"结算" forState:0];
        _finishBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_finishBtn setBackgroundColor:XKMainTypeColor];
        [_finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (UILabel *)countLabel {
    if(!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _countLabel;
}

- (UIButton *)deleteBtn {
    if(!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除" forState:0];
        _deleteBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_deleteBtn setTitleColor:UIColorFromRGB(0xffffff) forState:0];
        [_deleteBtn setBackgroundColor:UIColorFromRGB(0xee6161)];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIButton *)collectionBtn {
    if(!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionBtn setTitle:@"移入收藏" forState:0];
        _collectionBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_collectionBtn setTitleColor:UIColorFromRGB(0xffffff) forState:0];
        [_collectionBtn setBackgroundColor:XKMainTypeColor];
        [_collectionBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionBtn;
}

- (void)finishBtnClick:(UIButton *)sender {
    if(self.finishBlock) {
        self.finishBlock(sender);
    }
}

- (void)deleteBtnClick:(UIButton *)sender {
    if(self.deleteBlock) {
        self.deleteBlock(sender);
    }
}

- (void)collectBtnClick:(UIButton *)sender {
    if(self.collectBlock) {
        self.collectBlock(sender);
    }
}

- (void)choseBtnClick:(UIButton *)sender {
    if(self.choseBlock) {
        self.choseBlock(sender);
    }
}

- (void)allChose:(BOOL)all {
    self.choseBtn.selected = all;
}

- (void)setType:(NSInteger)type {
    if(type == 0) {
        self.collectionBtn.alpha = 0.f;
        self.deleteBtn.alpha = 0.f;

        self.countLabel.alpha = 1.f;
        self.finishBtn.alpha = 1.f;
    } else {
        self.collectionBtn.alpha = 1.f;
        self.deleteBtn.alpha = 1.f;

        self.countLabel.alpha = 0.f;
        self.finishBtn.alpha = 0.f;
    }
}
@end
