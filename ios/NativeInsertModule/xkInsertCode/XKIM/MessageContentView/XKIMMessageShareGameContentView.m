//
//  XKIMMessageShareGameContentView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/9.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageShareGameContentView.h"
#import "XKCommonStarView.h"
#import "XKIMMessageShareGameAttachment.h"
#import "XKGamesDetailViewController.h"
#import "XKSecretMessageFireOtherModel.h"
#import "XKSecretFrientManager.h"

@interface XKIMMessageShareGameContentView()

@end

@implementation XKIMMessageShareGameContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.bubbleImageView.hidden = YES;
        [self addSubview:self.gameCoverImgView];
        [self addSubview:self.gameNameLab];
        [self addSubview:self.starLab];
        [self addSubview:self.starView];
        [self addSubview:self.starValueLab];
        [self addSubview:self.gameDespLab];
        [self addSubview:self.lineH];
        [self addSubview:self.fromLab];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *object = data.message.messageObject;
    XKIMMessageShareGameAttachment *attachment = object.attachment;
    if (attachment.gameIconUrl && attachment.gameIconUrl.length) {
        [self.gameCoverImgView sd_setImageWithURL:[NSURL URLWithString:attachment.gameIconUrl]];
    } else {
        self.gameCoverImgView.image = kDefaultPlaceHolderRectImg;
    }
    self.gameNameLab.text = attachment.gameName;
    self.starView.scorePercent = attachment.gameScore / 5.0;
    self.starValueLab.text = [NSString stringWithFormat:@"%tu分", (NSUInteger)attachment.gameScore];
    self.gameDespLab.text = attachment.gameDescription;
    if (data.message.isOutgoingMsg) {
        self.fromLab.text = @"我的分享";
    } else {
        self.fromLab.text = @"可友分享";
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self cutCornerWithRadius:8 color:UIColorFromRGB(0xffffff) lineWidth:0];
    
    [self.gameCoverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * ScreenScale);
        make.leading.mas_equalTo(10 * ScreenScale);
        make.width.height.mas_equalTo(60.0 * ScreenScale);
    }];
    
    [self.gameNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gameCoverImgView);
        make.left.mas_equalTo(self.gameCoverImgView.mas_right).offset(7.0 * ScreenScale);
        make.trailing.mas_equalTo(-10.0 * ScreenScale);
    }];
    
    CGSize starLabSize = [self.starLab.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0.0) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.starLab.font} context:nil].size;
    
    [self.starLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gameNameLab.mas_bottom).offset(5.0 * ScreenScale);
        make.leading.mas_equalTo(self.gameNameLab);
        make.width.mas_equalTo(starLabSize.width + 1.0);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.starLab.mas_right);
        make.centerY.mas_equalTo(self.starLab);
        make.width.mas_equalTo(60.0 * ScreenScale);
        make.height.mas_equalTo(10.0 * ScreenScale);
    }];
    
    [self.starValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.starView.mas_right).offset(5.0 * ScreenScale);
        make.centerY.mas_equalTo(self.starView);
        make.trailing.mas_equalTo(-10.0 * ScreenScale);
    }];
    
    [self.gameDespLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.starLab.mas_bottom).offset(5.0 * ScreenScale);
        make.leading.trailing.mas_equalTo(self.gameNameLab);
    }];

    [self.lineH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.mas_equalTo(self);
        make.bottom.mas_equalTo(self.fromLab.mas_top);
        make.height.mas_equalTo(1.0);
    }];
    
    [self.fromLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10.0 * ScreenScale);
        make.trailing.mas_equalTo(-10.0 * ScreenScale);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(20 * ScreenScale);
    }];
    
    [self handleFireView];
}

- (void)onTouchUpInside:(id)sender {
//    NIMCustomObject *obj = self.model.message.messageObject;
//    XKIMMessageShareGameAttachment *game = obj.attachment;
//    XKGamesDetailViewController *vc = [[XKGamesDetailViewController alloc] init];
//    vc.gameId = game.gameId;
//    if (game.gameRecommendCode && game.gameRecommendCode.length) {
//        vc.recommendCode = game.gameRecommendCode;
//    }
//    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter setter

- (UIImageView *)gameCoverImgView {
    if (!_gameCoverImgView) {
        _gameCoverImgView = [[UIImageView alloc] init];
        _gameCoverImgView.contentMode = UIViewContentModeScaleAspectFill;
        _gameCoverImgView.xk_openClip = YES;
        _gameCoverImgView.xk_radius = 8;
        _gameCoverImgView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _gameCoverImgView;
}

- (UILabel *)gameNameLab {
    if (!_gameNameLab) {
        _gameNameLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(12) textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
        _gameNameLab.numberOfLines = 1;
        _gameNameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _gameNameLab;
}

- (UILabel *)starLab {
    if (!_starLab) {
        _starLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"人气指数：" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
    }
    return _starLab;
}

- (XKCommonStarView *)starView {
    if (!_starView) {
        _starView = [[XKCommonStarView alloc] initWithFrame:CGRectMake(0.0, 0.0, 60 * ScreenScale, 10.0 * ScreenScale) numberOfStars:5];
    }
    return _starView;
}

- (UILabel *)starValueLab {
    if (!_starValueLab) {
        _starValueLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
    }
    return _starValueLab;
}

- (UILabel *)gameDespLab {
    if (!_gameDespLab) {
        _gameDespLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
        _gameDespLab.numberOfLines = 2;
    }
    return _gameDespLab;
}

- (UILabel *)lineH {
    if (!_lineH) {
        _lineH = [[UILabel alloc] init];
        _lineH.backgroundColor = XKSeparatorLineColor;
    }
    return _lineH;
}

- (UILabel *)fromLab {
    if (!_fromLab) {
        _fromLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x999999) backgroundColor:[UIColor whiteColor]];
    }
    return _fromLab;
}

@end
