//
//  XKMallMainHeaderView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallMainHeaderView.h"
@interface XKMallMainHeaderView ()
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIButton  *layoutBtn;

@end

@implementation XKMallMainHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
        self.backgroundColor = [UIColor whiteColor];
        self.xk_openClip = YES;
        self.xk_radius = 8.f;
        self.xk_clipType = XKCornerClipTypeTopBoth;
    }
    return self;
}

- (void)addUI {
    [self addSubview:self.layoutBtn];
    [self addSubview:self.titleLabel];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.layoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)layoutBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
         [_layoutBtn setImage:[UIImage imageNamed:@"xk_btn_mall_layoutTwo"] forState:0];
    } else {
         [_layoutBtn setImage:[UIImage imageNamed:@"xk_btn_mall_layoutOne"] forState:0];
    }
    
    if (self.layoutBlock) {
        self.layoutBlock(sender);
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
        _titleLabel.font  = XKRegularFont(17);
        _titleLabel.textColor  = UIColorFromRGB(0x222222);
        _titleLabel.text = @"商品推荐";
    }
    return _titleLabel;
}

- (UIButton *)layoutBtn {
    if (!_layoutBtn) {
        _layoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45 - 20, 0, 30, 30)];
        [_layoutBtn setImage:[UIImage imageNamed:@"xk_btn_mall_layoutOne"] forState:0];
        [_layoutBtn setTitleColor:UIColorFromRGB(0x777777) forState:0];
        [_layoutBtn addTarget:self action:@selector(layoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _layoutBtn;
}

@end
