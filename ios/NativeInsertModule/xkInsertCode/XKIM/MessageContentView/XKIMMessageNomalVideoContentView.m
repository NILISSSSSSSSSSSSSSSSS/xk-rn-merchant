//
//  XKIMMessageNomalVideoContentView.m
//  XKSquare
//
//  Created by william on 2018/10/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMMessageNomalVideoContentView.h"
#import "XKIMMessageNomalVideoAttachment.h"
#import "XKVideoDisplayMediator.h"
#import "XKSecretMessageFireOtherModel.h"
#import "XKSecretFrientManager.h"
NSString *const NIMMessageNommalVideo = @"NIMMessageNommalVideo";
@interface XKIMMessageNomalVideoContentView()

@end

@implementation XKIMMessageNomalVideoContentView

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        self.bubbleImageView.hidden = YES;
        self.backgroundColor = UIColorFromRGB(0xedf4ff);
        [self addSubview:self.mainShowImageView];
        [self addSubview:self.durLabel];
        [self addSubview:self.playIconImageView];
    }
    return self;
}


#pragma mark – Private Methods
- (void)refresh:(NIMMessageModel *)data
{
    [super refresh:data];
    NIMCustomObject *object = data.message.messageObject;
    XKIMMessageNomalVideoAttachment *attachment = object.attachment;
    [_mainShowImageView sd_setImageWithURL:[NSURL URLWithString:attachment.videoIcon] placeholderImage:nil];
    NSInteger minute = attachment.videoTime / 1000 / 60;
    NSInteger second = attachment.videoTime / 1000 % 60;
    self.durLabel.text = [NSString stringWithFormat:@"%tu:%02tu",minute,second];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_mainShowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10 * ScreenScale);
        make.top.mas_equalTo(self.mas_top).offset(10 * ScreenScale);
        make.bottom.mas_equalTo(self.mas_bottom).offset(- 10 * ScreenScale);
        make.right.mas_equalTo(self.mas_right).offset(- 10 * ScreenScale);
    }];
    
    [_playIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30 * ScreenScale, 30 * ScreenScale));
    }];
    
    [_durLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self->_mainShowImageView.mas_right).offset(-5);
        make.bottom.mas_equalTo(self->_mainShowImageView.mas_bottom).offset(-5);
        make.height.mas_equalTo(15* ScreenScale);
    }];
    
    [self handleFireView];
}

-(void)onTouchUpInside:(id)sender{
    NIMCustomObject *object = self.model.message.messageObject;
    XKIMMessageNomalVideoAttachment *attachment = object.attachment;
    [XKVideoDisplayMediator displaySingleVideoClearWithViewController:[self getCurrentUIVC] urlString:attachment.videoUrl];
}

#pragma mark -- getter and setter

-(UIImageView *)mainShowImageView{
    if (!_mainShowImageView) {
        _mainShowImageView = [[UIImageView alloc]init];
        _mainShowImageView.contentMode = UIViewContentModeScaleAspectFit;
        _mainShowImageView.backgroundColor = HEX_RGB(0x000000);
    }
    return _mainShowImageView;
}

-(UILabel *)durLabel{
    if (!_durLabel) {
        _durLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0xffffff) backgroundColor:[UIColor clearColor]];
        _durLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _durLabel;
}

-(UIImageView *)playIconImageView{
    if (!_playIconImageView) {
        _playIconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_btn_IM_Message_videoPlay"]];
    }
    return _playIconImageView;
}

@end
