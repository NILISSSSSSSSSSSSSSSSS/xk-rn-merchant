//
//  XKGamesShareView.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/23.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGamesShareView.h"
#import "XKCommonStarView.h"

@interface XKGamesShareView()
@property (nonatomic, strong)UILabel     *sentimentLabel;
@property (nonatomic, strong)UIView      *segmentationView;
@property (nonatomic, strong)UILabel     *gameSizeLabel;
@property (nonatomic, strong)XKCommonStarView      *starView;
@property (nonatomic, strong)UILabel     *contentLabel;

@end
@implementation XKGamesShareView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

- (void)setModel:(XKCollectGamesModelDataItem *)model {
    _model = model;
    NSString *dataString = [NSString stringWithFormat:@"xkgc://commodity_detail?commodity_id=%@&user_id=%@",model.target.targetId,[XKUserInfo getCurrentUserId]] ;
    [self.iconImgView createShareQRImageWithQRString:dataString correctionLevel:@"L"];
    self.nameLabel.text = model.target.name;
    _starView.scorePercent = model.target.popularity / 5.0;
    self.nameLabel.text = model.target.name;
    _gameSizeLabel.text = [NSString stringWithFormat:@"游戏大小:%ld",model.target.size];
    _contentLabel.text = model.target.describe;
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.target.showPics]];
}

- (void)creatUI {
    [super creatUI];
    [self.bottomView addSubview:self.sentimentLabel];
    [self.bottomView addSubview:self.gameSizeLabel];
    [self.bottomView addSubview:self.segmentationView];
    [self.bottomView addSubview:self.starView];
    [self.bottomView addSubview:self.contentLabel];
    
    [self.sentimentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20 * ScreenScale);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5 * ScreenScale);
        make.width.mas_equalTo(55 * ScreenScale);
        make.height.mas_equalTo(10 * ScreenScale);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sentimentLabel.mas_right).offset(5 * ScreenScale);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5 * ScreenScale);
        make.width.mas_equalTo(80 * ScreenScale);
        make.height.mas_equalTo(10 * ScreenScale);
    }];
    
    [self.segmentationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.starView);
        make.left.equalTo(self.starView.mas_right);
        make.width.equalTo(@1);
        make.height.mas_equalTo(20 * ScreenScale);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20 * ScreenScale);
        make.top.equalTo(self.starView.mas_bottom).offset(10 * ScreenScale);
        make.right.equalTo(self.iconImgView.mas_left).offset(-15 * ScreenScale);
    }];
    
    [self.gameSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentationView.mas_right).offset(5 * ScreenScale);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5 * ScreenScale);
        make.right.equalTo(self.iconImgView.mas_left).offset(-15 * ScreenScale);
        make.height.mas_equalTo(15 * ScreenScale);
    }];
    
}

- (UILabel *)sentimentLabel {
    if(!_sentimentLabel) {
        _sentimentLabel = [[UILabel alloc] init];
        [_sentimentLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _sentimentLabel.textColor = UIColorFromRGB(0x555555);
        _sentimentLabel.text = @"人气指数:";
    }
    return _sentimentLabel;
}

- (UILabel *)contentLabel {
    if(!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _contentLabel.textColor = UIColorFromRGB(0x555555);
        _contentLabel.numberOfLines = 2;
        _contentLabel.text = @"成为厨神！研发国际美食！把你的侧方装饰的美轮美奂！一起来做饭吧！";
    }
    return _contentLabel;
}

- (UILabel *)gameSizeLabel {
    if(!_gameSizeLabel) {
        _gameSizeLabel = [[UILabel alloc] init];
        [_gameSizeLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _gameSizeLabel.textColor = UIColorFromRGB(0x555555);
        NSString *status = @"200MB";
        NSString *statusStr = [NSString stringWithFormat:@"游戏大小：%@",status];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:statusStr];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0xee6161)
                           range:NSMakeRange(5, statusStr.length - 5)];
        _gameSizeLabel.attributedText = attrString;
    }
    return _gameSizeLabel;
}

- (UIView *)segmentationView {
    if(!_segmentationView) {
        _segmentationView = [[UIView alloc] init];
        _segmentationView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _segmentationView;
}


- (XKCommonStarView *)starView {
    if (!_starView) {
        _starView = [[XKCommonStarView alloc]initWithFrame:CGRectMake(0, 0, 80 * ScreenScale, 10 * ScreenScale) numberOfStars:5];
        _starView.userInteractionEnabled = NO;
        _starView.scorePercent = 4 / 5.0;
    }
    return _starView;
}
@end
