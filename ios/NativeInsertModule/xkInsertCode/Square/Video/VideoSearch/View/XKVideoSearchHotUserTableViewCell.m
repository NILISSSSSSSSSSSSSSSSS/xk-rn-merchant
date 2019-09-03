//
//  XKVideoSearchHotUserTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKVideoSearchHotUserTableViewCell.h"

#import "XKVideoSearchUserModel.h"

@interface XKVideoSearchHotUserTableViewCell()

@property (nonatomic, strong) UIImageView *avatarImgView;

@property (nonatomic, strong) UILabel *usernameLab;

@property (nonatomic, strong) UIButton *focusBtn;

@property (nonatomic, strong) UILabel *downLine;

@end

@implementation XKVideoSearchHotUserTableViewCell

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
    [self.containerView addSubview:self.focusBtn];
    [self.containerView addSubview:self.downLine];
}

- (void)updateViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
    }];
    
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14.0);
        make.centerY.mas_equalTo(self.containerView);
        make.width.height.mas_equalTo(46.0);
    }];
    
    [self.usernameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImgView.mas_right).offset(15.0);
        make.centerY.mas_equalTo(self.containerView);
        make.right.mas_equalTo(self.focusBtn.mas_left).offset(-10.0);
    }];
    
    [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-15.0);
        make.centerY.mas_equalTo(self.containerView);
        make.height.mas_equalTo(22.0);
        make.width.mas_equalTo(60.0);
    }];
    
    [self.downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.containerView);
        make.height.mas_equalTo(1.0);
    }];
}

#pragma mark - privite method

- (void)focusBtnAction {
    if (self.focusBtnBlock) {
        self.focusBtnBlock(self.user);
    }
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
        _avatarImgView.xk_radius = 23.0;
        _avatarImgView.xk_clipType = XKCornerClipTypeAllCorners;
        _avatarImgView.xk_openClip = YES;
    }
    return _avatarImgView;
}

- (UILabel *)usernameLab {
    if (!_usernameLab) {
        _usernameLab = [BaseViewFactory labelWithFram:CGRectZero text:@"昵称" font:XKRegularFont(14.0) textColor:HEX_RGB(0x222222) backgroundColor:[UIColor whiteColor]];
    }
    return _usernameLab;
}

- (UIButton *)focusBtn {
    if (!_focusBtn) {
        _focusBtn = [BaseViewFactory buttonWithFrame:CGRectZero font:XKRegularFont(12.0) title:@"" titleColor:XKMainTypeColor backColor:[UIColor whiteColor]];
        _focusBtn.layer.cornerRadius = 11.0;
        _focusBtn.layer.masksToBounds = YES;
        _focusBtn.layer.borderWidth = 1.0;
        [_focusBtn addTarget:self action:@selector(focusBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _focusBtn;
}

- (UILabel *)downLine {
    if (!_downLine) {
        _downLine = [[UILabel alloc] init];
        _downLine.backgroundColor = HEX_RGB(0xf1f1f1);
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
//    未关注该用户
    if (_user.followRelation == 0) {
        [self.focusBtn setTitle:@" 关注 " forState:UIControlStateNormal];
        [self.focusBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        [self.focusBtn setImage:IMG_NAME(@"xk_ic_video_addFoucs") forState:UIControlStateNormal];
        self.focusBtn.layer.borderColor = XKMainTypeColor.CGColor;
    } else {
        [self.focusBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.focusBtn setTitleColor:HEX_RGB(0x9d9d9d) forState:UIControlStateNormal];
        [self.focusBtn setImage:IMG_NAME(@"xk_ic_video_cancelFoucs") forState:UIControlStateNormal];
        self.focusBtn.layer.borderColor = HEX_RGB(0xe9e9e9).CGColor;
    }
}

@end
