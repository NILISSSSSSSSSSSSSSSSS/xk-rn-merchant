//
//  XKMallMainFooterView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallMainFooterView.h"
@interface XKMallMainFooterView ()

@property (nonatomic, strong) UIButton  *moreBtn;

@end

@implementation XKMallMainFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
        self.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return self;
}

- (void)addUI {
    [self addSubview:self.moreBtn];
}

- (void)moreBtnClick:(UIButton *)sender {
    if (self.moreBlock) {
        self.moreBlock(sender);
    }
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 35)];
        _moreBtn.titleLabel.font = XKRegularFont(14);
        [_moreBtn setImage:[UIImage imageNamed:@"xk_btn_mall_more"] forState:0];
        [_moreBtn setTitle:@"查看更多" forState:0];
        [_moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_moreBtn.imageView.size.width, 0, _moreBtn.imageView.size.width + 10)];
        [_moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _moreBtn.titleLabel.bounds.size.width, 0, -_moreBtn.titleLabel.bounds.size.width)];
        [_moreBtn setTitleColor:UIColorFromRGB(0x777777) forState:0];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}
@end
