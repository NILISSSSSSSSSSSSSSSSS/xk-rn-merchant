//
//  XKOrderInputTableViewCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOrderInputTableViewCell.h"

@interface XKOrderInputTableViewCell ()

@end

@implementation XKOrderInputTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
        self.xk_openClip = YES;
        self.xk_radius = 6;
        self.xk_clipType = XKCornerClipTypeNone;
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
        make.right.lessThanOrEqualTo(self.rightImgView.mas_right).offset(-15);
    }];
    
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.rightTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel.mas_right).offset(10);
        make.top.bottom.equalTo(self.contentView);
        make.right.lessThanOrEqualTo(self.rightImgView.mas_right).offset(-15);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel.mas_right).offset(10);
        make.top.bottom.equalTo(self.contentView);
        make.right.lessThanOrEqualTo(self.rightImgView.mas_right).offset(-15);
    }];
    self.rightImgView.alpha = 0;
}

- (void)updateLayout {
    [self.rightTf mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel.mas_right).offset(10);
        make.top.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(50);
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-15);
    }];
}

- (void)updateTextLayout {
    self.leftLabel.numberOfLines = 0;
    [self.leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-15);
    }];
}

- (void)setupWithLeftTitle:(NSString *)leftTtitle rightTitle:(NSString *)rightTtile alignment:(NSTextAlignment)alignment rightTextfieldEnable:(BOOL)tfenable rightTextfieldPlaceHolder:(NSString *)placeHolder rightImgViewEnable:(BOOL)imgenable rightImgViewImgName:(NSString *)imgName {
    self.leftLabel.text = leftTtitle;
    self.rightLabel.textAlignment = alignment;
    self.rightLabel.text = rightTtile;
    self.rightTf.enabled = tfenable;
    self.rightTf.placeholder = placeHolder;
    self.rightImgView.alpha = imgenable == YES ? 1 : 0;
    self.rightImgView.image = [UIImage imageNamed:imgName];
    if(imgenable) {
        [self.rightImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.rightTf mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.mas_right).offset(10);
            make.centerY.equalTo(self.leftLabel);
            make.right.lessThanOrEqualTo(self.rightImgView.mas_right).offset(-15);
        }];
        
        [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.mas_right).offset(10);
            make.top.bottom.equalTo(self.contentView);
            make.right.lessThanOrEqualTo(self.rightImgView.mas_right).offset(-15);
        }];
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
        
        [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.mas_right).offset(10);
            make.top.bottom.equalTo(self.contentView);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-15);
        }];
    }
}



- (UILabel *)leftLabel {
    if(!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        [_leftLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _leftLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if(!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        [_rightLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _rightLabel.textColor = UIColorFromRGB(0x555555);
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
        _rightImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightImgView;
}
@end
