//
//  XKVideoShareView.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/23.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKVideoShareView.h"
@interface XKVideoShareView ()
@property (nonatomic, strong)UIImageView *contentImageView;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UIImageView *loveIconImgView;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *contentLabel;
@property (nonatomic, strong)UILabel     *loveCountLabel;
@property (nonatomic, strong)UIView      *contentView;

@end
@implementation XKVideoShareView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}
- (void)setModel:(XKVideoDisplayVideoListItemModel *)model {
    _model = model;
    [_contentImageView sd_setImageWithURL:[NSURL URLWithString:model.video.first_cover]];
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.user.user_img]];
    _nameLabel.text = model.user.user_name;
    _contentLabel.text = model.video.describe;
    _loveCountLabel.text = [NSString stringWithFormat:@"%ld",(long)model.video.praise_num];
    
}
- (void)creatUI {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.contentImageView];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.loveIconImgView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.loveCountLabel];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.bottom.mas_equalTo(10);
        make.left.mas_equalTo(67);
        make.right.mas_equalTo(-67);
    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.contentView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(@(-10));
        make.height.mas_equalTo(30);
    }];
    [self.loveIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.bottom.equalTo(self.contentLabel.mas_top).offset(-4);
        make.height.width.mas_equalTo(20);
    }];
    [self.loveCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.loveIconImgView.mas_right).offset(3);
        make.centerY.equalTo(self.loveIconImgView);
        make.height.mas_equalTo(15);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.equalTo(self.loveCountLabel.mas_top).offset(-6);
        make.height.width.mas_equalTo(30);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.iconImgView.mas_right).offset(7);
        make.centerY.equalTo(self.iconImgView);
        make.height.mas_equalTo(20);
    }];

}
- (UIView *)contentView {
    if (!_contentView ) {
        _contentView = [[UIView alloc]init];
    }
    return _contentView;
}

- (UIImageView *)contentImageView {
    if(!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.layer.masksToBounds = YES;
    }
    return _contentImageView;
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImgView.layer.borderWidth = 0.5;
        _iconImgView.xk_clipType = XKCornerClipTypeAllCorners;
        _iconImgView.xk_openClip = YES;
        _iconImgView.xk_radius = 10;
    }
    return _iconImgView;
}

- (UIImageView *)loveIconImgView {
    if(!_loveIconImgView) {
        _loveIconImgView = [[UIImageView alloc] init];
        _loveIconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _loveIconImgView.image = [UIImage imageNamed:@"xk_btn_home_star"];
    }
    return _loveIconImgView;
}
- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:11]];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = @"林夕，风拂面";
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if(!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.numberOfLines = 2;
        _contentLabel.text = @"今天天气很好，晒一晒！今天天气很好，晒一晒！今天天气很好，晒一晒！";
    }
    return _contentLabel;
}

- (UILabel *)loveCountLabel {
    if(!_loveCountLabel) {
        _loveCountLabel = [[UILabel alloc] init];
        [_loveCountLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:9]];
        _loveCountLabel.textColor = [UIColor whiteColor];
        NSString *count = @"12999";
        _loveCountLabel.text = count;
    }
    return _loveCountLabel;
}

@end
