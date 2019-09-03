//
//  XKMallOrderDetailWaitPayBottomView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderDetailWaitPayBottomView.h"

@interface XKMallOrderDetailWaitPayBottomView ()
@property (nonatomic, strong)UIButton *payBtn;
@property (nonatomic, strong)UILabel *totalLabel;
@end

@implementation XKMallOrderDetailWaitPayBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.payBtn];
    [self addSubview:self.totalLabel];
}

- (void)addUIConstraint {
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.payBtn.mas_left).offset(-40);
        make.centerY.equalTo(self.payBtn);
    }];
}

- (void)payBtnClick:(UIButton *)sender {
    if(self.payBlock) {
        self.payBlock(sender);
    }
}

- (void)updatePrice:(long )price {
    self.totalLabel.text = [NSString stringWithFormat:@"合计: ¥%.2ld",price];
}

- (UIButton *)payBtn {
    if(!_payBtn) {
        _payBtn = [UIButton new];
        [_payBtn setTitle:@"去付款" forState:0];
        _payBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_payBtn setTitleColor:UIColorFromRGB(0xee6161) forState:0];
        _payBtn.layer.borderWidth = 1.f;
        _payBtn.layer.cornerRadius = 10;
        _payBtn.layer.borderColor = UIColorFromRGB(0xee6161).CGColor;
        _payBtn.layer.masksToBounds = YES;
        [_payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}

- (UILabel *)totalLabel {
    if(!_totalLabel) {
        _totalLabel = [UILabel new];
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.text = @"合计：¥8800.00";
        _totalLabel.textColor = UIColorFromRGB(0x222222);
        _totalLabel.font = XKRegularFont(14);
    }
    return _totalLabel;
}
@end
