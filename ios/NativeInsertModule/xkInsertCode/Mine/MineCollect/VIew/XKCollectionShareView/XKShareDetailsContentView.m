//
//  XKShareDetailsContentView.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/23.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKShareDetailsContentView.h"
@interface XKShareDetailsContentView()

@end
@implementation XKShareDetailsContentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI {
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    self.topContentView = [[UIView alloc]init];
    self.topContentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.topContentView];
    
    self.topImageView = [[UIImageView alloc]init];
    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.topContentView addSubview:self.topImageView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = XKSeparatorLineColor;
    [self.contentView addSubview:lineView];
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bottomView];
    
    [self.bottomView addSubview:self.iconImgView];
    [self.bottomView addSubview:self.nameLabel];

   
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(173 * ScreenScale);
    }];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20 * ScreenScale);
        make.left.mas_equalTo(84 * ScreenScale);
        make.right.mas_equalTo(-84 * ScreenScale);
        make.bottom.mas_equalTo(-20 * ScreenScale);
    }];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.topContentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(lineView.mas_bottom);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).offset(-20 * ScreenScale);
        make.top.equalTo(self.bottomView).offset(15 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(70 * ScreenScale, 70 * ScreenScale));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20 * ScreenScale);
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.equalTo(self.iconImgView.mas_left).offset(-15 * ScreenScale);
    }];
}

- (XKQRCodeView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[XKQRCodeView alloc] initWithFrame:CGRectMake(0, 0, 66,66)];
//        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
//        _iconImgView.layer.borderWidth = 1.f;
//        _iconImgView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
//        _iconImgView.xk_clipType = XKCornerClipTypeAllCorners;
//        _iconImgView.xk_openClip = YES;
//        _iconImgView.xk_radius = 10;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 1;
        _nameLabel.text = @"疯狂的老鸟";
    }
    return _nameLabel;
}

@end
