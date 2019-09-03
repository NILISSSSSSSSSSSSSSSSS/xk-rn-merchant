//
//  XKMallOrderDetailWaitEvaluateBottomView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderDetailWaitEvaluateBottomView.h"
@interface XKMallOrderDetailWaitEvaluateBottomView ()
@property (nonatomic, strong)UIButton *evaluateBtn;
@property (nonatomic, strong)UIButton *moreBtn;
@end

@implementation XKMallOrderDetailWaitEvaluateBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.evaluateBtn];
    [self addSubview:self.moreBtn];
}

- (void)addUIConstraint {
    [self.evaluateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.evaluateBtn.mas_left).offset(-20);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(70 * ScreenScale);
    }];
}

- (void)evaluateBtnClick:(UIButton *)sender {
    if(self.evaluateBlock) {
        self.evaluateBlock(sender);
    }
}

- (void)moreBtnClick:(UIButton *)sender {
    if(self.moreBtnBlock) {
        self.moreBtnBlock(sender);
    }
}

- (UIButton *)evaluateBtn {
    if(!_evaluateBtn) {
        _evaluateBtn = [UIButton new];
        [_evaluateBtn setTitle:@"去评价" forState:0];
        _evaluateBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_evaluateBtn setTitleColor:UIColorFromRGB(0xee6161) forState:0];
        _evaluateBtn.layer.borderWidth = 1.f;
        _evaluateBtn.layer.cornerRadius = 10;
        _evaluateBtn.layer.borderColor = UIColorFromRGB(0xee6161).CGColor;
        _evaluateBtn.layer.masksToBounds = YES;
        [_evaluateBtn addTarget:self action:@selector(evaluateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evaluateBtn;
}

- (UIButton *)moreBtn {
    if(!_moreBtn) {
        _moreBtn = [UIButton new];
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_moreBtn setTitle:@"更多" forState:0];
        _moreBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:12];
        [_moreBtn setTitleColor:UIColorFromRGB(0x999999) forState:0];
        [_moreBtn setBackgroundColor:[UIColor clearColor]];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

@end
