//
//  XKWelfareSureOrderBottomView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailSureOrderBottomView.h"
@interface XKWelfareOrderDetailSureOrderBottomView ()
/**支付*/
@property (nonatomic, strong)UIButton *payBtn;
/*合计*/
@property (nonatomic, strong)UILabel *totalLabel;

@end

@implementation XKWelfareOrderDetailSureOrderBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {

    [self addSubview:self.payBtn];
    [self addSubview:self.totalLabel];
}

- (void)addUIConstraint {
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.mas_bottom).offset(-kBottomSafeHeight);
        make.width.mas_equalTo(105);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.payBtn.mas_left).offset(-20);
        make.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
    }];
}

- (UIButton *)payBtn {
    if(!_payBtn) {
        _payBtn = [[UIButton alloc] init];
        [_payBtn setTitle:@"支付" forState:0];
        _payBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:16];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_payBtn setBackgroundColor:UIColorFromRGB(0xee6161)];
        [_payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}

- (UILabel *)totalLabel {
    if(!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:15];
        NSString *point = @"1067";
        NSString *nameStr = [NSString stringWithFormat:@"合计积分：%@",point];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:nameStr];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0xee6161)
                           range:NSMakeRange(5, nameStr.length - 5)];
        _totalLabel.attributedText = attrString;
    }
    return _totalLabel;
}

- (void)payBtnClick:(UIButton *)sender {
    if(self.payBlock) {
        self.payBlock(sender);
    }
}
@end
