//
//  XKOrderInfoTableViewCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOrderInfoTableViewCell.h"

@interface XKOrderInfoTableViewCell ()

@end

@implementation XKOrderInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.rightTf];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.rightImgView];
}

- (void)addUIConstraint {
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.rightTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel.mas_right).offset(10);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.rightImgView.mas_right).offset(-15);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel.mas_right).offset(10);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.rightImgView.mas_left).offset(-5);
    }];
    self.rightImgView.alpha = 0;
}

- (void)setupWithLeftLabelText:(NSString *)leftText leftLabelFont:(UIFont *)leftFont leftLabelTextColor:(UIColor *)leftColor rightLabelText:(NSString *)rightText rightLabelFont:(UIFont *)rightFont rightLabelTextColor:(UIColor *)rightColor  rightLabelAligment:(NSTextAlignment )alignment rightTextfieldEnable:(BOOL)tfEnable rightTextfieldPlaceHolder:(NSString *)placeHolder rightTextfieldFont:(UIFont *)rightTfFont rightTextfieldTextColor:(UIColor *)rightTfColor rightImgViewEnable:(BOOL)imageEnable rightImgViewImgName:(NSString *)imgName {
    self.leftLabel.text = leftText;
    self.leftLabel.font = leftFont ?: XKRegularFont(12);
    self.leftLabel.textColor = leftColor ?: UIColorFromRGB(0x222222);
    
    self.rightLabel.text = rightText;
    self.rightLabel.font = rightFont ?: XKRegularFont(12);
    self.rightLabel.textColor = rightColor ?: UIColorFromRGB(0x777777);
    self.rightLabel.textAlignment = alignment;
    
    self.rightTf.userInteractionEnabled = tfEnable;
    self.rightTf.enabled = tfEnable;
    self.rightTf.placeholder = placeHolder;
    self.rightTf.font = rightFont ?: XKRegularFont(12);
    self.rightTf.textColor = rightColor ?: UIColorFromRGB(0x777777);
    
    self.rightImgView.alpha = imageEnable == YES ? 1 : 0;
    self.rightImgView.image = [UIImage imageNamed:imgName];
    if(imageEnable) {
        [self.rightImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.rightTf mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.mas_right).offset(10);
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.rightImgView.mas_right).offset(-15);
        }];
        
        if(alignment == NSTextAlignmentRight) {
            [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftLabel.mas_right).offset(10);
                make.top.bottom.equalTo(self.contentView);
                make.right.equalTo(self.rightImgView.mas_left).offset(-5);
            }];
        } else {
            [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.mas_right).offset(10);
            make.top.bottom.equalTo(self.contentView);
            make.right.lessThanOrEqualTo(self.rightImgView.mas_left).offset(-5);
        }];
        }
    } else {
        [self.rightImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        
        [self.rightTf mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.mas_right).offset(10);
            make.top.bottom.equalTo(self.contentView);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-15);
        }];
        
        if(alignment == NSTextAlignmentRight) {
            [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftLabel.mas_right).offset(10);
                make.top.bottom.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-5);
            }];
        } else {
            [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftLabel.mas_right).offset(10);
                make.top.bottom.equalTo(self.contentView);
                make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-5);
            }];
        }
    }
}

- (void)scanfTap {
    if (self.scanfBlock) {
        self.scanfBlock();
    }
}

#pragma mark lazy
- (UILabel *)leftLabel {
    if(!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        [_leftLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _leftLabel.textColor = UIColorFromRGB(0x222222);
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if(!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        [_rightLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _rightLabel.textColor = UIColorFromRGB(0x777777);
    }
    return _rightLabel;
}

- (UITextField *)rightTf {
    if(!_rightTf) {
        _rightTf = [[UITextField alloc] init];
        [_rightTf setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _rightTf.textColor = UIColorFromRGB(0x555555);
    }
    return _rightTf;
}

- (UIImageView *)rightImgView {
    if(!_rightImgView) {
        _rightImgView = [[UIImageView alloc] init];
        _rightImgView.userInteractionEnabled = YES;
        _rightImgView.contentMode = UIViewContentModeCenter;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanfTap)];
        [_rightImgView addGestureRecognizer:tap];
    }
    return _rightImgView;
}

@end
