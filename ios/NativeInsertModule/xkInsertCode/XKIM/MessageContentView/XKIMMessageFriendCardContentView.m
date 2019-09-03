//
//  XKIMMessageFriendCardContentView.m
//  XKSquare
//
//  Created by william on 2018/10/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMMessageFriendCardContentView.h"
#import "XKIMMessageFirendCardAttachment.h"
#import "XKPersonDetailInfoViewController.h"
#import "XKSecretMessageFireOtherModel.h"
#import "XKSecretFrientManager.h"
NSString *const NIMMessageFriendCard = @"NIMMessageFriendCard";

@interface XKIMMessageFriendCardContentView()

@property (nonatomic, strong) UILabel   *cardNameLabel;

@property (nonatomic, strong) UIView    *midLineView;

@property (nonatomic, strong) NIMMessageModel *data;

@end

@implementation XKIMMessageFriendCardContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.bubbleImageView.hidden = YES;
        [self addSubview:self.avatarImageView];
        [self addSubview:self.nickNameLabel];
        [self addSubview:self.userIDLabel];
        [self addSubview:self.cardNameLabel];
        [self addSubview:self.midLineView];
    }
    return self;
}

- (void)refresh:(NIMMessageModel*)data{
    //务必调用super方法
    [super refresh:data];
    self.data = data;
    NIMCustomObject *object = data.message.messageObject;
    XKIMMessageFirendCardAttachment *attachment = object.attachment;

    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:attachment.businessUserAvatarUrl]];
    self.nickNameLabel.text = attachment.businessUserNickname;
//    self.userIDLabel.text = attachment.businessUserUid;
    if (data.message.isOutgoingMsg) {
        self.cardNameLabel.text = @"个人主页";
    } else {
        self.cardNameLabel.text = @"可友名片";
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self cutCornerWithRadius:8 color:UIColorFromRGB(0xffffff) lineWidth:0];
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10 * ScreenScale);
        make.left.mas_equalTo(self.mas_left).offset(10 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(60 * ScreenScale, 60 * ScreenScale));
    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_avatarImageView.mas_right).offset(7 * ScreenScale);
        make.right.mas_equalTo(self.mas_right).offset(-10 * ScreenScale);
        make.bottom.mas_equalTo(self->_avatarImageView.mas_centerY).offset(-3 *ScreenScale);
        make.height.mas_equalTo(18 * ScreenScale);
    }];
    
    [_userIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_avatarImageView.mas_right).offset(7 * ScreenScale);
        make.right.mas_equalTo(self.mas_right).offset(-10 * ScreenScale);
        make.top.mas_equalTo(self->_avatarImageView.mas_centerY).offset(3 * ScreenScale);
        make.height.mas_equalTo(15 * ScreenScale);
    }];

    [_cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left).offset(10 * ScreenScale);
        make.height.mas_equalTo(20 * ScreenScale);
    }];
    
    [_midLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self->_cardNameLabel.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    [self handleFireView];
}

-(void)onTouchUpInside:(id)sender{
    NIMCustomObject *object = self.data.message.messageObject;
    XKIMMessageFirendCardAttachment *attachment = object.attachment;
    XKPersonDetailInfoViewController *vc = [[XKPersonDetailInfoViewController alloc]init];
    vc.userId = attachment.businessUserId;
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark -- getter and setter

-(UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.xk_openClip = YES;
        _avatarImageView.xk_radius = 8;
        _avatarImageView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _avatarImageView;
}

-(UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(14) textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
    }
    return _nickNameLabel;
}

-(UILabel *)userIDLabel{
    if (!_userIDLabel) {
        _userIDLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
    }
    return _userIDLabel;
}

-(UILabel *)cardNameLabel{
    if (!_cardNameLabel) {
        _cardNameLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"个人主页" font:XKRegularFont(10) textColor:UIColorFromRGB(0x999999) backgroundColor:[UIColor whiteColor]];
        _cardNameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _cardNameLabel;
}

-(UIView *)midLineView{
    if (!_midLineView) {
        _midLineView = [[UIView alloc]init];
        _midLineView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _midLineView;
}

@end
