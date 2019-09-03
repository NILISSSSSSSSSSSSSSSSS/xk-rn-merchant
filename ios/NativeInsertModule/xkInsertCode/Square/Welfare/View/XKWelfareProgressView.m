//
//  XKWelfareProgressView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareProgressView.h"
@interface XKWelfareProgressView ()
@property (nonatomic, strong)UIView *bgView;
@end

@implementation XKWelfareProgressView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        self.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.17;//阴影透明度，默认0
        self.layer.shadowRadius = 8;
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.bgView addSubview:self.progressLabel];
    [self addSubview:self.bgView];
}

- (void)addUIConstraint {
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(5);
        make.right.equalTo(self.bgView.mas_right).offset(-5);
        make.top.bottom.equalTo(self.bgView);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}


- (UILabel *)progressLabel {
    if(!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textColor = UIColorFromRGB(0x222222);
        _progressLabel.font =  [UIFont fontWithName:XK_PingFangSC_Regular size:12];
    }
    return _progressLabel;
}

- (UIView *)bgView {
    if(!_bgView) {
        _bgView  = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 4.f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
@end
