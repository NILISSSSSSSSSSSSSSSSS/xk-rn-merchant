//
//  XKMineSettingRootHeaderView.m
//  XKSquare
//
//  Created by william on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineSettingRootHeaderView.h"
#import "NSObject+XKGlobeMethod.h"
#import "XKHotspotButton.h"

@interface XKMineSettingRootHeaderView()

@property (nonatomic,strong)XKHotspotButton    *backButton;
@property (nonatomic,strong)UIImageView *userHeaderImageView;
@property (nonatomic,strong)UILabel     *nickNameLabel;
@property (nonatomic,strong)UILabel     *phoneNumeLabel;
@property (nonatomic,strong)UILabel     *idLabel;
@property (nonatomic,strong)XKHotspotButton    *editPersonInfoButton;
@property (nonatomic,strong)UIView      *bottomCellView;

@end

@implementation XKMineSettingRootHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        self.backgroundColor = HEX_RGB(0xEEEEEE);
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark – Private Methods
-(void)initViews{
    [self addSubview:self.backImageView];
    [self addSubview:self.shadowView];
    [self addSubview:self.backButton];
    [self addSubview:self.userHeaderImageView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.idLabel];
    [self addSubview:self.phoneNumeLabel];
    [self addSubview:self.editPersonInfoButton];
    [self addSubview:self.bottomCellView];
}

-(void)layoutViews{
    
    [_bottomCellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10 * ScreenScale);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, 50 * ScreenScale));
    }];
    
//    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_equalTo(self);
//        make.height.mas_equalTo(185 * ScreenScale);
//        make.bottom.equalTo(self.bottomCellView.mas_top).offset(25 * ScreenScale);
//    }];
    
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.and.top.mas_equalTo(self->_backImageView);
    }];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset((34 + (iPhoneX?10:0)) * ScreenScale);
        make.left.mas_equalTo(self.mas_left).offset(25 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(20*ScreenScale, 20*ScreenScale));
    }];
    
    [_userHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_backButton.mas_bottom).offset(11 * ScreenScale);
        make.left.mas_equalTo(self->_backButton.mas_left);
        make.size.mas_equalTo(CGSizeMake(50 * ScreenScale, 50 * ScreenScale));
    }];
    
    [_editPersonInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->_userHeaderImageView.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-26 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(10 * ScreenScale, 20 * ScreenScale));
    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_userHeaderImageView.mas_top);
        make.bottom.mas_equalTo(self->_userHeaderImageView.mas_centerY);
        make.left.mas_equalTo(self->_userHeaderImageView.mas_right).offset(5.4 * ScreenScale);
        make.right.mas_equalTo(self->_editPersonInfoButton.mas_left).offset(-10 * ScreenScale);
    }];
    
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_nickNameLabel.mas_bottom);
        make.left.and.right.mas_equalTo(self->_nickNameLabel);
        make.height.mas_equalTo(20 * ScreenScale);
    }];
    
    [_phoneNumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_idLabel.mas_bottom);
        make.left.and.right.mas_equalTo(self->_nickNameLabel);
        make.bottom.mas_equalTo(self->_userHeaderImageView.mas_bottom).offset(10);
    }];
}

- (void)setEditPersonheaderBlock:(headerBlock)block {
    self.headerBlock = block;
}
- (void)setbottomCellViewBlock:(headerBlock)block {
    self.bottomCellViewBlock = block;
}

- (void)loadUI {
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[XKUserInfo getCurrentUserAvatar]] placeholderImage:kDefaultHeadImg];
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[XKUserInfo getCurrentUserAvatar]] placeholderImage:kDefaultHeadImg];
    [self.nickNameLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text([XKUserInfo getCurrentUserName]).font(XKRegularFont(18));
    }];
    self.idLabel.text = [NSString stringWithFormat:@"ID:%@",[XKUserInfo currentUser].uid];
    self.phoneNumeLabel.text = [NSString stringWithFormat:@"%@",[XKUserInfo currentUser].signature ?:@"本宝宝暂时还没有有趣的签名"];
}

- (void)tap:(UIGestureRecognizer *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [XKUserInfo currentUser].userId;
    [XKHudView showTipMessage:@"复制成功"];
}

#pragma mark – Getters and Setters
-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.layer.masksToBounds = YES;
        _backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 185 * ScreenScale);
        _backImageView.layer.contentsRect=CGRectMake(0,0,1,0.5);
    }
    return _backImageView;
}

-(UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]init];
        _shadowView.backgroundColor = HEX_RGBA(0x4A90FA, 0.8);
    }
    return _shadowView;
}

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [XKHotspotButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"   " forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"xk_btn_Mine_setting_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(UIButton *)editPersonInfoButton{
    if (!_editPersonInfoButton) {
        _editPersonInfoButton  = [XKHotspotButton buttonWithType:UIButtonTypeCustom];
        [_editPersonInfoButton setBackgroundImage:[UIImage imageNamed:@"xk_btn_Mine_Setting_nextWhite"] forState:UIControlStateNormal];
        [_editPersonInfoButton addTarget:self action:@selector(editPersonInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editPersonInfoButton;
}

-(UIImageView *)userHeaderImageView{
    if (!_userHeaderImageView) {
        _userHeaderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50 * ScreenScale, 50 * ScreenScale)];
        [_userHeaderImageView cutCornerWithRadius:5 color:[UIColor whiteColor] lineWidth:0];
        _userHeaderImageView.layer.masksToBounds = YES;
        _userHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userHeaderImageView;
}

-(UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:18] textColor:UIColorFromRGB(0xffffff) backgroundColor:[UIColor clearColor]];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLabel;
}

-(UILabel *)phoneNumeLabel{
    if (!_phoneNumeLabel) {
        _phoneNumeLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10] textColor:UIColorFromRGB(0xf2f2f2) backgroundColor:[UIColor clearColor]];
        _phoneNumeLabel.numberOfLines = 2;
        _phoneNumeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _phoneNumeLabel;
}

-(UILabel *)idLabel{
    if (!_idLabel) {
        _idLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10] textColor:UIColorFromRGB(0xf2f2f2) backgroundColor:[UIColor clearColor]];
        _idLabel.numberOfLines = 2;
        _idLabel.textAlignment = NSTextAlignmentLeft;
        _idLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tap.numberOfTapsRequired = 3;
        [_idLabel addGestureRecognizer:tap];
    }
    return _idLabel;
}

-(UIView *)bottomCellView{
    if (!_bottomCellView) {
        _bottomCellView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50 * ScreenScale)];
        _bottomCellView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomCellViewTap)];
        [_bottomCellView addGestureRecognizer:tap];
        [_bottomCellView cutCornerWithRadius:8 color:[UIColor whiteColor] lineWidth:0];
        
    }
    return _bottomCellView;
}

-(void)setCellName:(NSString *)cellName{
    _cellName = cellName;
    UILabel *label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:_cellName font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
    label.adjustsFontSizeToFitWidth = YES;
    [_bottomCellView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(self->_bottomCellView);
        make.left.mas_equalTo(self->_bottomCellView.mas_left).offset(14 * ScreenScale);;
    }];
    
    UIImageView *nextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_btn_personal_nextBlack"]];
    [_bottomCellView addSubview:nextImage];
    [nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->_bottomCellView.mas_centerY);
        make.right.mas_equalTo(self->_bottomCellView.mas_right).offset(-16 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(8.8 * ScreenScale, 10 * ScreenScale));
    }];
}

#pragma mark - Events
- (void)bottomCellViewTap {
    if (self.bottomCellViewBlock) {
        self.bottomCellViewBlock();
    }
}
-(void)backButtonClicked:(UIButton *)sender{
    [[self getCurrentUIVC].navigationController popViewControllerAnimated:YES];
}

- (void)editPersonInfoAction:(UIButton *)sender {
    if (self.headerBlock) {
        self.headerBlock();
    }
}
#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - Custom Delegates



@end
