//
//  XKMineRootPersonInfoHeaderFirstView.m
//  XKSquare
//
//  Created by william on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineRootPersonInfoHeaderFirstView.h"
#import "NSObject+XKGlobeMethod.h"
#import "XKMineSettingRootViewController.h"

@interface XKMineRootPersonInfoHeaderFirstView()

@property(nonatomic,strong) UIImageView *backgroundImageView;   //背景图片
@property(nonatomic,strong) UIView      *shadowView;            //蒙层
@property(nonatomic,strong) UIImageView *userHeaderImageView;
@property(nonatomic,strong) UIButton    *settingButton;
@property(nonatomic,strong) UILabel     *nickNameLabel;
@property(nonatomic,strong) UILabel     *signLabel;
@property(nonatomic,strong) UILabel     *fansNameLabel;
@property(nonatomic,strong) UILabel     *fansCountLabel;
@property(nonatomic,strong) UILabel     *getPraiseNameLabel;
@property(nonatomic,strong) UILabel     *getPraiseCountLabel;
@property(nonatomic,strong) UILabel     *commentNameLabel;
@property(nonatomic,strong) UILabel     *commentCountLabel;

@end
@implementation XKMineRootPersonInfoHeaderFirstView

#pragma mark – Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        self.backgroundColor = HEX_RGB(0xEEEEEE);
        [self initViews];
        [self layoutViews];
        [self test];
        
    }
    return self;
}


#pragma mark - Events
-(void)settingButtonClicked:(UIButton *)sender{
    
    XKMineSettingRootViewController *vc = [[XKMineSettingRootViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark – Private Methods
-(void)initViews{
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.shadowView];
    [self addSubview:self.userHeaderImageView];
    [self addSubview:self.settingButton];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.signLabel];
    [self addSubview:self.fansNameLabel];
    [self addSubview:self.fansCountLabel];
    [self addSubview:self.getPraiseNameLabel];
    [self addSubview:self.getPraiseCountLabel];
    [self addSubview:self.commentNameLabel];
    [self addSubview:self.commentCountLabel];
}

-(void)layoutViews{
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.and.top.mas_equalTo(self);
    }];
    
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.and.top.mas_equalTo(self);
    }];
    
    [_userHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(25 * ScreenScale);
        make.top.mas_equalTo(self.mas_top).offset((33 + (iPhoneX?10:0)) * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(46 * ScreenScale, 46 * ScreenScale));
    }];
    
    [_settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_userHeaderImageView.mas_top);
        make.right.mas_equalTo(self.mas_right).offset(-23 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(23 * ScreenScale, 23 * ScreenScale));
    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_userHeaderImageView.mas_right).offset(5 * ScreenScale);
        make.top.mas_equalTo(self->_userHeaderImageView.mas_top);
        make.bottom.mas_equalTo(self->_userHeaderImageView.mas_centerY);
        make.right.mas_equalTo(self->_settingButton.mas_left).offset(-10 * ScreenScale);
    }];
    
    [_signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self->_nickNameLabel);
        make.top.mas_equalTo(self->_nickNameLabel.mas_bottom);
        make.bottom.mas_equalTo(self->_userHeaderImageView.mas_bottom);
    }];
    
    [_fansNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(45 * ScreenScale);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-24 * ScreenScale);
        make.height.mas_equalTo(20);
    }];

    [_fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self->_fansNameLabel.mas_centerX);
        make.bottom.mas_equalTo(self->_fansNameLabel.mas_top);
        make.height.mas_equalTo(20);
    }];
    
    [_getPraiseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self->_fansNameLabel.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
    [_getPraiseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self->_getPraiseNameLabel.mas_centerX);
        make.bottom.mas_equalTo(self->_getPraiseNameLabel.mas_top);
        make.height.mas_equalTo(20);
    }];
    
    [_commentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-45 * ScreenScale);
        make.centerY.mas_equalTo(self->_getPraiseNameLabel.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
    [_commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self->_commentNameLabel.mas_centerX);
        make.bottom.mas_equalTo(self->_commentNameLabel.mas_top);
        make.height.mas_equalTo(20);
    }];
}

-(void)test{
    [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534254111904&di=1e487e3d79ef4a654278b05f5280d38c&imgtype=0&src=http%3A%2F%2Fwww.qqzhi.com%2Fuploadpic%2F2015-01-11%2F050001550.jpg"] placeholderImage:kDefaultPlaceHolderImg];
    [_userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534254111904&di=1e487e3d79ef4a654278b05f5280d38c&imgtype=0&src=http%3A%2F%2Fwww.qqzhi.com%2Fuploadpic%2F2015-01-11%2F050001550.jpg"] placeholderImage:kDefaultPlaceHolderImg];
    _nickNameLabel.text = @"天府新区吴彦祖";
    _signLabel.text = @"通过天府新区人民认证的帅哥";
    _fansCountLabel.text = @"186";
    _getPraiseCountLabel.text = @"7889";
    _commentCountLabel.text = @"128";
}
#pragma mark – Getters and Setters
-(UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]init];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.layer.masksToBounds = YES;
        _backgroundImageView.layer.contentsRect=CGRectMake(0,0,1,0.5);
    }
    return _backgroundImageView;
}

-(UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]init];
        _shadowView.backgroundColor = HEX_RGBA(0x4A90FA, 0.8);
    }
    return _shadowView;
}

-(UIImageView *)userHeaderImageView{
    if (!_userHeaderImageView) {
        _userHeaderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 46 * ScreenScale, 46 * ScreenScale)];
        [_userHeaderImageView cutCornerWithRadius:5 color:[UIColor whiteColor] lineWidth:0];
        _userHeaderImageView.layer.masksToBounds = YES;

    }
    return _userHeaderImageView;
}

-(UIButton *)settingButton{
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setBackgroundImage:[UIImage imageNamed:@"xk_btn_Mine_setting"] forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(settingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

-(UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:18] textColor:UIColorFromRGB(0xffffff) backgroundColor:[UIColor clearColor]];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLabel;
}

-(UILabel *)signLabel{
    if (!_signLabel) {
        _signLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10] textColor:UIColorFromRGB(0xf2f2f2) backgroundColor:[UIColor clearColor]];
        _signLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _signLabel;
}

-(UILabel *)fansNameLabel{
    if (!_fansNameLabel) {
        _fansNameLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"我的粉丝" font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14] textColor:UIColorFromRGB(0xffffff) backgroundColor:[UIColor clearColor]];
        _fansNameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _fansNameLabel;
}

-(UILabel *)fansCountLabel{
    if (!_fansCountLabel) {
        _fansCountLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] textColor:UIColorFromRGB(0xffffff) backgroundColor:[UIColor clearColor]];
        _fansCountLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _fansCountLabel;
}

-(UILabel *)getPraiseNameLabel{
    if (!_getPraiseNameLabel) {
        _getPraiseNameLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"获赞" font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14] textColor:UIColorFromRGB(0xffffff) backgroundColor:[UIColor clearColor]];
        _getPraiseNameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _getPraiseNameLabel;
}

-(UILabel *)getPraiseCountLabel{
    if (!_getPraiseCountLabel) {
        _getPraiseCountLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] textColor:UIColorFromRGB(0xffffff) backgroundColor:[UIColor clearColor]];
        _getPraiseCountLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _getPraiseCountLabel;
}

-(UILabel *)commentNameLabel{
    if (!_commentNameLabel) {
        _commentNameLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"点评" font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14] textColor:UIColorFromRGB(0xffffff) backgroundColor:[UIColor clearColor]];
        _commentNameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _commentNameLabel;
}

-(UILabel *)commentCountLabel{
    if (!_commentCountLabel) {
        _commentCountLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] textColor:UIColorFromRGB(0xffffff) backgroundColor:[UIColor clearColor]];
        _commentCountLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _commentCountLabel;
}

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - Custom Delegates



@end
