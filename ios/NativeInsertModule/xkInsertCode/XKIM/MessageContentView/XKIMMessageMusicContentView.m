//
//  XKIMMessageMusicContentView.m
//  XKSquare
//
//  Created by xudehuai on 2019/2/21.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKIMMessageMusicContentView.h"
#import "XKIMMessageMusicAttachment.h"
#import "XKSecretMessageFireOtherModel.h"
#import "XKSecretFrientManager.h"
#import "XKJumpWebViewController.h"

@interface XKIMMessageMusicContentView ()

@property (nonatomic, strong) UILabel *sourceLab;

@property (nonatomic, strong) UIView *midLineView;

@property (nonatomic, strong) NIMMessageModel *data;

@end

@implementation XKIMMessageMusicContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.bubbleImageView.hidden = YES;
        [self addSubview:self.musicImgView];
        [self addSubview:self.musicLab];
        [self addSubview:self.userLab];
        [self addSubview:self.sourceLab];
        [self addSubview:self.midLineView];
    }
    return self;
}

- (void)refresh:(NIMMessageModel*)data{
    //务必调用super方法
    [super refresh:data];
    self.data = data;
    NIMCustomObject *object = data.message.messageObject;
    XKIMMessageMusicAttachment *attachment = object.attachment;
    
    if (attachment.voiceIcon && attachment.voiceIcon.length) {
        [self.musicImgView sd_setImageWithURL:[NSURL URLWithString:attachment.voiceIcon] placeholderImage:kDefaultPlaceHolderImg];
    } else {
        self.musicImgView.image = kDefaultPlaceHolderImg;
    }
    self.musicLab.text = attachment.voiceTitle;
    self.userLab.text = [NSString stringWithFormat:@"来自%@的分享", attachment.sendNickName];
    self.sourceLab.text = @"晓可小视频";
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self cutCornerWithRadius:8 color:UIColorFromRGB(0xffffff) lineWidth:0];
    
    [self.musicImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10 * ScreenScale);
        make.left.mas_equalTo(self.mas_left).offset(10 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(60 * ScreenScale, 60 * ScreenScale));
    }];
    
    [self.musicLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.musicImgView.mas_right).offset(7 * ScreenScale);
        make.right.mas_equalTo(self.mas_right).offset(-10 * ScreenScale);
        make.bottom.mas_equalTo(self.musicImgView.mas_centerY).offset(-3 *ScreenScale);
        make.height.mas_equalTo(18 * ScreenScale);
    }];
    
    [self.userLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.musicImgView.mas_right).offset(7 * ScreenScale);
        make.right.mas_equalTo(self.mas_right).offset(-10 * ScreenScale);
        make.top.mas_equalTo(self.musicImgView.mas_centerY).offset(3 * ScreenScale);
        make.height.mas_equalTo(15 * ScreenScale);
    }];
    
    [self.sourceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left).offset(10 * ScreenScale);
        make.height.mas_equalTo(20 * ScreenScale);
    }];
    
    [_midLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.sourceLab.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    [self handleFireView];
}

-(void)onTouchUpInside:(id)sender{
    NIMCustomObject *object = self.data.message.messageObject;
    XKIMMessageMusicAttachment *attachment = object.attachment;
    XKJumpWebViewController *vc = [[XKJumpWebViewController alloc] init];
    vc.url = attachment.voiceUrl;
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark -- getter and setter

-(UIImageView *)musicImgView{
    if (!_musicImgView) {
        _musicImgView = [[UIImageView alloc]init];
        _musicImgView.xk_openClip = YES;
        _musicImgView.xk_radius = 8;
        _musicImgView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _musicImgView;
}

-(UILabel *)musicLab{
    if (!_musicLab) {
        _musicLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(14) textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
    }
    return _musicLab;
}

-(UILabel *)userLab{
    if (!_userLab) {
        _userLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
    }
    return _userLab;
}

-(UILabel *)sourceLab{
    if (!_sourceLab) {
        _sourceLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"个人主页" font:XKRegularFont(10) textColor:UIColorFromRGB(0x999999) backgroundColor:[UIColor whiteColor]];
        _sourceLab.adjustsFontSizeToFitWidth = YES;
    }
    return _sourceLab;
}

-(UIView *)midLineView{
    if (!_midLineView) {
        _midLineView = [[UIView alloc]init];
        _midLineView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _midLineView;
}

@end
