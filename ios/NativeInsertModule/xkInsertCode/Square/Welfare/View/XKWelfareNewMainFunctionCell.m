//
//  XKWelfareNewMainFunctionCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareNewMainFunctionCell.h"
@interface XKWelfareNewMainFunctionCell ()
@property (nonatomic, strong) UIImageView  *topLeftImgView;
@property (nonatomic, strong) UIImageView  *topRightImgView;
@property (nonatomic, strong) UILabel      *topLabel;
@property (nonatomic, strong) UIView       *leftView;
@property (nonatomic, strong) UIImageView  *leftImgView;
@property (nonatomic, strong) UILabel      *leftTitleLabel;
@property (nonatomic, strong) UIView       *midView;
@property (nonatomic, strong) UIImageView  *midImgView;
@property (nonatomic, strong) UILabel      *midTitleLabel;
@property (nonatomic, strong) UIView       *rightView;
@property (nonatomic, strong) UIImageView  *rightImgView;
@property (nonatomic, strong) UILabel      *rightTitleLabel;

@end

@implementation XKWelfareNewMainFunctionCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xFBEEDE);
    }
    return self;
}

- (void)addCustomSuviews {
    
    [self.contentView addSubview:self.topLeftImgView];
    [self.contentView addSubview:self.topRightImgView];
    [self.contentView addSubview:self.topLabel];
    [self.contentView addSubview:self.leftView];
    [self.leftView addSubview:self.leftImgView];
  //  [self.leftView addSubview:self.leftTitleLabel];
    [self.contentView addSubview:self.midView];
//    [self.midView addSubview:self.midTitleLabel];
    [self.midView addSubview:self.midImgView];
    [self.contentView addSubview:self.rightView];
    [self.rightView addSubview:self.rightImgView];
 //   [self.rightView addSubview:self.rightTitleLabel];
    
    [self.leftView bk_whenTapped:^{
        if (self.leftViewBlock) {
            self.leftViewBlock();
        }
    }];
    [self.midView bk_whenTapped:^{
        if (self.midViewBlock) {
            self.midViewBlock();
        }
    }];
    [self.rightView bk_whenTapped:^{
        if (self.rightViewBlock) {
            self.rightViewBlock();
        }
    }];
}

- (void)addUIConstraint {
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(10 * ScreenScale);
    }];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15 * ScreenScale);
        make.top.equalTo(self.contentView.mas_top).offset(47 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(110 * ScreenScale, 110 * ScreenScale));
    }];
    
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.leftView);
    //    make.height.mas_equalTo((SCREEN_WIDTH - 20) / 3 * 0.8);
    }];
    
//    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.leftView);
//        make.top.equalTo(self.leftImgView.mas_bottom);
//    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(- 15 * ScreenScale);
        make.top.equalTo(self.contentView.mas_top).offset(47 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(110 * ScreenScale, 110 * ScreenScale));
    }];
    
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.rightView);
   //     make.height.mas_equalTo((SCREEN_WIDTH - 20) / 3 * 0.8);
    }];
    
//    [self.rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.rightView);
//        make.top.equalTo(self.rightImgView.mas_bottom);
//    }];
    
    [self.midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_right).offset(10 * ScreenScale);
        make.top.equalTo(self.contentView.mas_top).offset(47 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(110 * ScreenScale, 110 * ScreenScale));
    }];
    
    [self.midImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.midView);
   //     make.height.mas_equalTo((SCREEN_WIDTH - 20) / 3 * 0.8);
    }];
    
//    [self.midTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.midView);
//        make.top.equalTo(self.midImgView.mas_bottom);
//    }];
    
    [self.topLeftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topLabel);
        make.right.equalTo(self.topLabel.mas_left).offset(-15);
        make.size.mas_equalTo(CGSizeMake(54 * ScreenScale, 5 * ScreenScale));
    }];
    
    [self.topRightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topLabel);
        make.left.equalTo(self.topLabel.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(54 * ScreenScale, 5 * ScreenScale));
    }];
}

- (UIImageView *)topLeftImgView {
    if (!_topLeftImgView) {
        _topLeftImgView = [UIImageView new];
        _topLeftImgView.contentMode = UIViewContentModeScaleAspectFit;
        _topLeftImgView.image = [UIImage imageNamed:@"xk_btn_welfare_left-side"];
    }
    return _topLeftImgView;
}

- (UIImageView *)topRightImgView {
    if (!_topRightImgView) {
        _topRightImgView = [UIImageView new];
        _topRightImgView.contentMode = UIViewContentModeScaleAspectFit;
        _topRightImgView.image = [UIImage imageNamed:@"xk_btn_welfare_right-side"];
    }
    return _topRightImgView;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [UILabel new];
        _topLabel.font = XKMediumFont(17);
        _topLabel.textColor = UIColorFromRGB(0x222222);
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.text = @"下单抽大奖赢好礼";
    }
    return _topLabel;
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [UIView new];
        _leftView.backgroundColor = [UIColor clearColor];
        _leftView.layer.cornerRadius = 4.f;
        _leftView.layer.masksToBounds = YES;
    }
    return _leftView;
}

- (UIImageView *)leftImgView {
    if (!_leftImgView) {
        _leftImgView = [UIImageView new];
        _leftImgView.contentMode = UIViewContentModeScaleAspectFit;
        _leftImgView.image = [UIImage imageNamed:@"xk_btn_welfare_最近开奖"];
    }
    return _leftImgView;
}

- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [UILabel new];
        _leftTitleLabel.font = XKMediumFont(14);
        _leftTitleLabel.textColor = UIColorFromRGB(0x222222);
        _leftTitleLabel.textAlignment = NSTextAlignmentCenter;
        _leftTitleLabel.text = @"最近开奖";
    }
    return _leftTitleLabel;
}

- (UIView *)midView {
    if (!_midView) {
        _midView = [UIView new];
        _midView.backgroundColor = [UIColor clearColor];
        _midView.layer.cornerRadius = 4.f;
        _midView.layer.masksToBounds = YES;
    }
    return _midView;
}

- (UIImageView *)midImgView {
    if (!_midImgView) {
        _midImgView = [UIImageView new];
        _midImgView.contentMode = UIViewContentModeScaleAspectFit;
        _midImgView.image = [UIImage imageNamed:@"xk_btn_welfare_晒单"];
    }
    return _midImgView;
}

- (UILabel *)midTitleLabel {
    if (!_midTitleLabel) {
        _midTitleLabel = [UILabel new];
        _midTitleLabel.font = XKMediumFont(14);
        _midTitleLabel.textColor = UIColorFromRGB(0x222222);
        _midTitleLabel.textAlignment = NSTextAlignmentCenter;
        _midTitleLabel.text = @"晒单";
    }
    return _midTitleLabel;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [UIView new];
        _rightView.backgroundColor = [UIColor clearColor];
        _rightView.layer.cornerRadius = 4.f;
        _rightView.layer.masksToBounds = YES;
    }
    return _rightView;
}

- (UIImageView *)rightImgView {
    if (!_rightImgView) {
        _rightImgView = [UIImageView new];
        _rightImgView.contentMode = UIViewContentModeScaleAspectFit;
        _rightImgView.image = [UIImage imageNamed:@"xk_btn_welfare_抽奖规则"];
    }
    return _rightImgView;
}

- (UILabel *)rightTitleLabel {
    if (!_rightTitleLabel) {
        _rightTitleLabel = [UILabel new];
        _rightTitleLabel.font = XKMediumFont(14);
        _rightTitleLabel.textColor = UIColorFromRGB(0x222222);
        _rightTitleLabel.textAlignment = NSTextAlignmentCenter;
        _rightTitleLabel.text = @"抽奖规则";
    }
    return _rightTitleLabel;
}
@end
