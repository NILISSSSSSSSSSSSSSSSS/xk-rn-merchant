//
//  XKGoodsHistoryReusableView.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKGoodsHistoryReusableView.h"
@interface XKGoodsHistoryReusableView()
@property(nonatomic, strong) UIButton *autotrophyButton;
@property(nonatomic, strong) UIButton *businessButton;


@end
@implementation XKGoodsHistoryReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *autotrophyButton = [self creatButtonWithTitle:@"自营商品" Sel:@selector(autotrophyButtonClick:)];
        [autotrophyButton setTitleColor:HEX_RGB(0x4A90FA) forState:UIControlStateNormal];
        autotrophyButton.layer.borderColor = HEX_RGB(0x4A90FA).CGColor;
        UIButton *businessButton = [self creatButtonWithTitle:@"商圈商品" Sel:@selector(businessButtonClick:)];
        [businessButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        businessButton.layer.borderColor = HEX_RGB(0x999999).CGColor;
        [self addSubview:autotrophyButton];
        [self addSubview:businessButton];
        [autotrophyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(22);
            make.width.mas_equalTo(70);
        }];
        
        [businessButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(autotrophyButton.mas_right).offset(20);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(22);
            make.width.mas_equalTo(70);
        }];
        self.autotrophyButton = autotrophyButton;
        self.businessButton = businessButton;
    }
    return self;
}

- (UIButton *)creatButtonWithTitle:(NSString *)title Sel:(SEL)sel  {
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = 0.5 ;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius  = 12;
    button.titleLabel.font = XKFont(XK_PingFangSC_Regular, 12);
    return button;
}

- (void)autotrophyButtonClick:(UIButton *)sender {
    
    sender.layer.borderColor = HEX_RGB(0x4A90FA).CGColor;
    [sender setTitleColor:HEX_RGB(0x4A90FA) forState:UIControlStateNormal];
    [self.businessButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
    self.businessButton.layer.borderColor = HEX_RGB(0x999999).CGColor;
    EXECUTE_BLOCK(self.autotrophyButtonBlock,sender);
    
}

- (void)businessButtonClick:(UIButton *)sender {
    sender.layer.borderColor = HEX_RGB(0x4A90FA).CGColor;
    [sender setTitleColor:HEX_RGB(0x4A90FA) forState:UIControlStateNormal];
    self.autotrophyButton.layer.borderColor = HEX_RGB(0x999999).CGColor;
    [self.autotrophyButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
    EXECUTE_BLOCK(self.businessButtonBlock,sender);
}

@end
