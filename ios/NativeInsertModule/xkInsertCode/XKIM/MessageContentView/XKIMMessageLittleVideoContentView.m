//
//  XKIMMessageLittleVideoContentView.m
//  XKSquare
//
//  Created by william on 2018/11/8.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageLittleVideoContentView.h"
#import "XKIMMessageLittleVideoAttachment.h"
#import "XKVideoDisplayMediator.h"
#import "XKSecretMessageFireOtherModel.h"
#import "XKSecretFrientManager.h"
NSString *const NIMMessagelittleVideo = @"NIMMessagelittleVideo";

@interface XKIMMessageLittleVideoContentView()

@end

@implementation XKIMMessageLittleVideoContentView

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        self.bubbleImageView.hidden = YES;
        self.backgroundColor = UIColorFromRGB(0xedf4ff);
        [self addSubview:self.mainShowImageView];
        [self addSubview:self.playIconImageView];
        [self addSubview:self.bottomWhiteView];
        [self.bottomWhiteView addSubview:self.nickNameLabel];
        [self.bottomWhiteView addSubview:self.avatarImageView];
    }
    return self;
}

#pragma mark – Private Methods
- (void)refresh:(NIMMessageModel *)data
{
    [super refresh:data];
    NIMCustomObject *object = data.message.messageObject;
    XKIMMessageLittleVideoAttachment *attachment = object.attachment;
    [_mainShowImageView sd_setImageWithURL:[NSURL URLWithString:attachment.videoIconUrl] placeholderImage:nil];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:attachment.videoAuthorAvatarUrl] placeholderImage:nil];
    _nickNameLabel.text = attachment.videoAuthorName;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_mainShowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10 * ScreenScale);
        make.top.mas_equalTo(self.mas_top).offset(10 * ScreenScale);
        make.bottom.mas_equalTo(self.mas_bottom).offset(- 45 * ScreenScale);
        make.right.mas_equalTo(self.mas_right).offset(- 10 * ScreenScale);
    }];
    
    [_playIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mainShowImageView.mas_centerX);
        make.centerY.mas_equalTo(self.mainShowImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30 * ScreenScale, 30 * ScreenScale));
    }];

    [_bottomWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.mainShowImageView);
        make.top.mas_equalTo(self.mainShowImageView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10* ScreenScale);
    }];

    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomWhiteView.mas_left).offset(4 * ScreenScale);
        make.top.mas_equalTo(self.bottomWhiteView.mas_top).offset(4 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(25 * ScreenScale, 25 * ScreenScale));
    }];

    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(self.bottomWhiteView);
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(4 * ScreenScale);
        make.right.mas_equalTo(self.bottomWhiteView.mas_right).offset(-4 * ScreenScale);
    }];
    
    [self handleFireView];
}

-(void)onTouchUpInside:(id)sender{
//    NIMCustomObject *object = self.model.message.messageObject;
//    XKIMMessageLittleVideoAttachment *attachment = object.attachment;
//    [XKVideoDisplayMediator displaySelectedVideoIdWithViewController:[self getCurrentUIVC] videoId:attachment.videoId];
}

#pragma mark -- getter and setter

-(UIImageView *)mainShowImageView{
    if (!_mainShowImageView) {
        _mainShowImageView = [[UIImageView alloc]init];
    }
    return _mainShowImageView;
}

-(UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLabel;
}

-(UIImageView *)playIconImageView{
    if (!_playIconImageView) {
        _playIconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_btn_IM_Message_videoPlay"]];
    }
    return _playIconImageView;
}

-(UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.xk_openClip = YES;
        _avatarImageView.xk_radius = 12.5 * ScreenScale;
        _avatarImageView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _avatarImageView;
}

-(UIView *)bottomWhiteView{
    if (!_bottomWhiteView) {
        _bottomWhiteView = [[UIView alloc]init];
        _bottomWhiteView.backgroundColor = [UIColor whiteColor];
        _bottomWhiteView.xk_openClip = YES;
        _bottomWhiteView.xk_radius = 8;
        _bottomWhiteView.xk_clipType = XKCornerClipTypeBottomBoth;
    }
    return _bottomWhiteView;
}

@end
