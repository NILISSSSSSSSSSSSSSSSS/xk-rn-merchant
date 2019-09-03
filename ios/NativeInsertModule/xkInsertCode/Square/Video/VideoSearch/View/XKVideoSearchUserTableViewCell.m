//
//  XKVideoSearchUserTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/14.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKVideoSearchUserTableViewCell.h"

#import "XKVideoSearchUserModel.h"

@interface XKVideoSearchUserTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarImgView;

@property (nonatomic, strong) UILabel *usernameLab;

@property (nonatomic, strong) UILabel *userIdLab;



@property (nonatomic, strong) UILabel *moreLab;

@property (nonatomic, strong) UIImageView *arrowImgView;

@property (nonatomic, strong) UILabel *downLine;

@end

@implementation XKVideoSearchUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)initializeViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.avatarImgView];
    [self.containerView addSubview:self.usernameLab];
    [self.containerView addSubview:self.userIdLab];
    [self.containerView addSubview:self.moreView];
    [self.moreView addSubview:self.moreLab];
    [self.moreView addSubview:self.arrowImgView];
    [self.containerView addSubview:self.downLine];
}

- (void)updateViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
    }];

    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15.0);
        make.centerY.mas_equalTo(self.containerView);
        make.width.height.mas_equalTo(46.0);
    }];

    [self.usernameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImgView);
        make.left.mas_equalTo(self.avatarImgView.mas_right).offset(15);
        make.height.mas_equalTo(24.0);
        make.trailing.mas_equalTo(-80.0);
    }];
    
    [self.userIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.usernameLab.mas_bottom).offset(3.0);
        make.leading.trailing.mas_equalTo(self.usernameLab);
        make.height.mas_equalTo(17.0);
    }];
    
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.containerView);
        make.trailing.mas_equalTo(-15.0);
    }];
    
    [self.moreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.moreView);
        make.centerY.mas_equalTo(self.moreView);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.moreLab.mas_right).offset(5.0);
        make.trailing.mas_equalTo(self.moreView);
        make.centerY.mas_equalTo(self.moreView);
    }];
    
    [self.downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.containerView);
        make.height.mas_equalTo(1.0);
    }];
}

#pragma mark - getter setter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc] init];
        _avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImgView.xk_radius = 8.0;
        _avatarImgView.xk_clipType = XKCornerClipTypeAllCorners;
        _avatarImgView.xk_openClip = YES;
    }
    return _avatarImgView;
}

- (UILabel *)usernameLab {
    if (!_usernameLab) {
        _usernameLab = [[UILabel alloc] init];
        _usernameLab.text = @"用户名";
        _usernameLab.font = XKRegularFont(17.0);
        _usernameLab.textColor = HEX_RGB(0x222222);
    }
    return _usernameLab;
}

- (UILabel *)userIdLab {
    if (!_userIdLab) {
        _userIdLab = [[UILabel alloc] init];
        _userIdLab.text = @"用户ID";
        _userIdLab.font = XKRegularFont(12.0);
        _userIdLab.textColor = HEX_RGB(0x777777);
    }
    return _userIdLab;
}

- (UIView *)moreView {
    if (!_moreView) {
        _moreView = [[UIView alloc] init];
    }
    return _moreView;
}

- (UILabel *)moreLab {
    if (!_moreLab) {
        _moreLab = [[UILabel alloc] init];
        _moreLab.text = @"查看更多";
        _moreLab.font = XKRegularFont(12.0);
        _moreLab.textColor = HEX_RGB(0x777777);
    }
    return _moreLab;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = IMG_NAME(@"ic_btn_msg_circle_rightArrow");
    }
    return _arrowImgView;
}

- (UILabel *)downLine {
    if (!_downLine) {
        self.downLine = [[UILabel alloc] init];
        self.downLine.backgroundColor = HEX_RGB(0xf1f1f1);
    }
    return _downLine;
}

- (void)setUser:(XKVideoSearchUserModel *)user {
    _user = user;
    if (_user.avatar && _user.avatar.length) {
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:_user.avatar] placeholderImage:kDefaultHeadImg];
    } else {
        self.avatarImgView.image = kDefaultHeadImg;
    }
    self.usernameLab.text = _user.nickname;
    self.userIdLab.text = [NSString stringWithFormat:@"用户ID：%tu", _user.uid];
}

- (void)setMoreViewHidden:(BOOL)hidden {
    self.moreView.hidden = hidden;
    if (hidden) {
        self.usernameLab.font = XKRegularFont(17.0);
    } else {
        self.usernameLab.font = XKMediumFont(16.0);
    }
}

@end
