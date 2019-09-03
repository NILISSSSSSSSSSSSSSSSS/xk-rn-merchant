//
//  XKVideoMoreCustomView.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoMoreCustomView.h"

#import "XKVideoDisplayModel.h"

@interface XKVideoMoreCustomView ()

@property (nonatomic, strong) UIImageView *coverImgView;

@property (nonatomic, strong) UIImageView *authorImgView;

@property (nonatomic, strong) UILabel *authorLab;

@property (nonatomic, strong) UIImageView *likeImgView;

@property (nonatomic, strong) UILabel *likeNumLab;

@property (nonatomic, strong) UILabel *titleLab;


@property (nonatomic, strong) XKVideoDisplayVideoListItemModel *video;

@end

@implementation XKVideoMoreCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)initializeViews {
    [self addSubview:self.coverImgView];
    [self addSubview:self.authorImgView];
    [self addSubview:self.authorLab];
    [self addSubview:self.likeImgView];
    [self addSubview:self.likeNumLab];
    [self addSubview:self.titleLab];
}

- (void)updateViews {
    
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.width.mas_equalTo(187.0);
        make.height.mas_equalTo(264.0);
    }];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.coverImgView).offset(15.0);
        make.bottom.mas_equalTo(self.coverImgView).offset(-10.0);
        make.trailing.mas_equalTo(self.coverImgView).offset(-15.0);
        make.height.mas_equalTo(14.0);
    }];

    [self.likeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLab);
        make.bottom.mas_equalTo(self.titleLab.mas_top).offset(-3.0);
        make.width.height.mas_equalTo(12.0);
    }];

    [self.likeNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.likeImgView);
        make.left.mas_equalTo(self.likeImgView.mas_right).offset(2.0);
        make.trailing.mas_equalTo(self.coverImgView).offset(-15.0);
    }];

    [self.authorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLab);
        make.bottom.mas_equalTo(self.likeImgView.mas_top).offset(-6.0);
        make.width.height.mas_equalTo(30.0);
    }];

    [self.authorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.authorImgView);
        make.left.mas_equalTo(self.authorImgView.mas_right).offset(7.0);
        make.trailing.mas_equalTo(self.coverImgView).offset(-15.0);
    }];
}

#pragma makr- public method

- (void)configViewWithVideoModel:(XKVideoDisplayVideoListItemModel *) video {
    _video = video;
    if (_video.video.zdy_cover && _video.video.zdy_cover.length) {
        [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:_video.video.zdy_cover] placeholderImage:kDefaultPlaceHolderRectImg];
    } else if (_video.video.first_cover && _video.video.first_cover.length) {
        [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:_video.video.first_cover] placeholderImage:kDefaultPlaceHolderRectImg];
    } else {
        self.coverImgView.image = kDefaultPlaceHolderRectImg;
    }
    if (_video.user.user_img && _video.user.user_img.length) {
        [self.authorImgView sd_setImageWithURL:[NSURL URLWithString:_video.user.user_img] placeholderImage:kDefaultHeadImg];
    } else {
        self.authorImgView.image = kDefaultHeadImg;
    }
    self.authorLab.text = _video.user.user_name;
    self.likeNumLab.text = [NSString stringWithFormat:@"%tu", _video.video.praise_num];
    self.titleLab.text = _video.video.describe;
}

#pragma mark - getter setter

- (UIImageView *)coverImgView {
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImgView.xk_radius = 4.0;
        _coverImgView.xk_clipType = XKCornerClipTypeAllCorners;
        _coverImgView.xk_openClip = YES;
    }
    return _coverImgView;
}

- (UIImageView *)authorImgView {
    if (!_authorImgView) {
        _authorImgView = [[UIImageView alloc] init];
        _authorImgView.xk_radius = 15.0;
        _authorImgView.xk_clipType = XKCornerClipTypeAllCorners;
        _authorImgView.xk_openClip = YES;
    }
    return _authorImgView;
}

- (UILabel *)authorLab {
    if (!_authorLab) {
        _authorLab = [[UILabel alloc] init];
        _authorLab.font = XKMediumFont(11.0);
        _authorLab.textColor = HEX_RGB(0xffffff);
    }
    return _authorLab;
}

- (UIImageView *)likeImgView {
    if (!_likeImgView) {
        _likeImgView = [[UIImageView alloc] init];
        _likeImgView.image = IMG_NAME(@"xk_ic_video_more_like");
    }
    return _likeImgView;
}

- (UILabel *)likeNumLab {
    if (!_likeNumLab) {
        _likeNumLab = [[UILabel alloc] init];
        _likeNumLab.font = XKRegularFont(9.0);
        _likeNumLab.textColor = HEX_RGB(0xffffff);
    }
    return _likeNumLab;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = XKMediumFont(10.0);
        _titleLab.textColor = HEX_RGB(0xffffff);
    }
    return _titleLab;
}

@end
