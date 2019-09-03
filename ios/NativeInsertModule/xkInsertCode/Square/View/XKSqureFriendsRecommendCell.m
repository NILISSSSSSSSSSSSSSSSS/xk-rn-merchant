//
//  XKSqureFriendsRecommendCell.m
//  XKSquare
//
//  Created by hupan on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureFriendsRecommendCell.h"

@interface XKSqureFriendsRecommendCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *decLable;
@property (nonatomic, strong) UIButton    *focusBtn;
@property (nonatomic, strong) UIButton    *addFriendBtn;
@property (nonatomic, strong) UIView      *lineView;


@end

@implementation XKSqureFriendsRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.decLable];
    [self.contentView addSubview:self.focusBtn];
    [self.contentView addSubview:self.addFriendBtn];
    [self.contentView addSubview:self.lineView];

}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@(38*ScreenScale));
        make.bottom.equalTo(self.contentView).offset(-15);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top).offset(-2);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.right.equalTo(self.focusBtn.mas_left).offset(-5);
    }];

    [self.decLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.imgView.mas_bottom).offset(0);
    }];


    [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addFriendBtn.mas_left).offset(-8);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@22);
        make.width.equalTo(@60);

    }];
    
    [self.addFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@22);
        make.width.equalTo(@60);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}



#pragma mark - Events

- (void)focusBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.focusBtn.layer.borderColor = HEX_RGB(0xE5E5E5).CGColor;
    } else {
        self.focusBtn.layer.borderColor = HEX_RGB(0xEE6161).CGColor;
    }
}

- (void)addFriendBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.addFriendBtn.layer.borderWidth = 0;
        self.addFriendBtn.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        self.addFriendBtn.layer.borderWidth = 1;
        self.addFriendBtn.layer.borderColor = XKMainTypeColor.CGColor;
    }
}



#pragma mark - Setter


- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 5;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538047861638&di=868dd2f924e8f80a811ef302ad7722fd&imgtype=0&src=http%3A%2F%2Fpic33.photophoto.cn%2F20141028%2F0038038006886895_b.jpg"]];
    }
    return _imgView;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:16];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"阿文";
    }
    return _nameLabel;
}


- (UILabel *)decLable {
    
    if (!_decLable) {
        _decLable = [[UILabel alloc] init];
        _decLable.textAlignment = NSTextAlignmentLeft;
        _decLable.text = @"人事实在法傲娇foe放弃是打发时间发京东方 阿萨德发的";
        _decLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _decLable.textColor = HEX_RGB(0x777777);
    }
    return _decLable;
}




- (UIButton *)focusBtn {
    if (!_focusBtn) {
        _focusBtn = [[UIButton alloc] init];
        _focusBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_focusBtn setTitle:@"取消关注" forState:UIControlStateSelected];
        [_focusBtn setTitleColor:HEX_RGB(0x777777)  forState:UIControlStateSelected];
        [_focusBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_focusBtn addTarget:self action:@selector(focusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_focusBtn setTitle:@" 关注" forState:UIControlStateNormal];
        [_focusBtn setTitleColor:HEX_RGB(0xEE6161)  forState:UIControlStateNormal];
        [_focusBtn setImage:IMG_NAME(@"xk_btn_IM_fans_addFocus") forState:UIControlStateNormal];
        _focusBtn.layer.borderColor = HEX_RGB(0xEE6161).CGColor;
        _focusBtn.layer.borderWidth = 1;
        _focusBtn.layer.masksToBounds = YES;
        _focusBtn.layer.cornerRadius = 11;
    }
    return _focusBtn;
}

- (UIButton *)addFriendBtn {
    if (!_addFriendBtn) {
        _addFriendBtn = [[UIButton alloc] init];
        _addFriendBtn.layer.masksToBounds = YES;
        _addFriendBtn.layer.cornerRadius = 11;
        _addFriendBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_addFriendBtn setBackgroundColor:XKMainTypeColor];
        [_addFriendBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_addFriendBtn setTitle:@"已是好友" forState:UIControlStateSelected];
        [_addFriendBtn setTitleColor:HEX_RGB(0x777777)  forState:UIControlStateSelected];

        [_addFriendBtn setImage:IMG_NAME(@"xk_btn_bankCardAdd") forState:UIControlStateNormal];
        [_addFriendBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        [_addFriendBtn setTitle:@" 好友" forState:UIControlStateNormal];
        [_addFriendBtn addTarget:self action:@selector(addFriendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addFriendBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}



@end





















