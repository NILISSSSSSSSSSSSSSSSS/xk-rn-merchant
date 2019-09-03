//
//  XKWelfareShareView.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKCollectWelfareShareView.h"
#import "XKWelfareProgressView.h"
@interface XKCollectWelfareShareView ()

@property (nonatomic, strong)UILabel     *monthCountLabel;
@property (nonatomic, strong)UILabel     *piceLabel;
@property (nonatomic, strong)UIView      *segmengView;
@property (nonatomic, strong)UILabel     *progressLabel;
@property (nonatomic, strong)XKWelfareProgressView *progressTipView;
@property (nonatomic, strong)UIProgressView *progressView;

@end

@implementation XKCollectWelfareShareView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [super creatUI];
    
//    [self.bottomView addSubview:self.progressLabel];
    [self.bottomView addSubview:self.monthCountLabel];
    [self.bottomView addSubview:self.piceLabel];
//    [self.bottomView addSubview:self.progressView];
//    [self.bottomView addSubview:self.progressTipView];
    
//    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bottomView).offset(20);
//        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
//        make.width.mas_equalTo(80);
//        make.height.mas_equalTo(12);
//    }];
//
//    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.progressLabel.mas_right);
//        make.centerY.equalTo(self.progressLabel);
//        make.height.mas_equalTo(4);
//        make.right.equalTo(self.iconImgView.mas_left).offset(-10);
//    }];
//
//    [self.progressTipView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.progressLabel);
//        make.height.mas_equalTo(16);
//        make.left.equalTo(self.progressView.mas_right).multipliedBy(self.progressView.progress);
//    }];
    
    [self.monthCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.right.equalTo(self.iconImgView.mas_left).offset(-10);
        make.height.mas_equalTo(15);
    }];
    
    [self.piceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(20);
        make.top.equalTo(self.monthCountLabel.mas_bottom).offset(10);
        make.right.equalTo(self.iconImgView.mas_left).offset(-10);
        make.height.mas_equalTo(15);
    }];
    
}
- (void)setModel:(XKCollectWelfareDataItem *)model {
    _model = model;
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.target.showPics] placeholderImage:kDefaultPlaceHolderImg];
    NSString *dataString = [NSString stringWithFormat:@"xkgc://commodity_detail?commodity_id=%@&user_id=%@&periods_id=%@",model.target.targetId,[XKUserInfo getCurrentUserId],model.target.targetId] ;
    [self.iconImgView createShareQRImageWithQRString:dataString correctionLevel:@"L"];
    self.nameLabel.text = model.target.name;
    NSString *status = @(model.target.perPrice / 100).stringValue;
    NSString *statusStr = [NSString stringWithFormat:@"代金券：%@",status];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:statusStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(4, statusStr.length - 4)];
    _piceLabel.attributedText = attrString;
    _monthCountLabel.text = [NSString stringWithFormat:@"产品规格：%@",model.target.showAttr];
    _progressView.progress = 0.8;
}

- (UILabel *)monthCountLabel {
    if(!_monthCountLabel) {
        _monthCountLabel = [[UILabel alloc] init];
        [_monthCountLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _monthCountLabel.textColor = UIColorFromRGB(0x777777);
        _monthCountLabel.text = @"产品规格:  500ml+120ml";
    }
    return _monthCountLabel;
}

- (UILabel *)piceLabel {
    if(!_piceLabel) {
        _piceLabel = [[UILabel alloc] init];
        [_piceLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _piceLabel.textColor = UIColorFromRGB(0x777777);
        NSString *status = @"20000";
        NSString *statusStr = [NSString stringWithFormat:@"代金券：%@",status];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:statusStr];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0xee6161)
                           range:NSMakeRange(4, statusStr.length - 4)];
        _piceLabel.attributedText = attrString;
    }
    return _piceLabel;
}

- (UILabel *)progressLabel {
    if(!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textColor = UIColorFromRGB(0x777777);
        _progressLabel.font =  [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _progressLabel.text = @"开奖进度：";
    }
    return _progressLabel;
}

- (UIProgressView *)progressView {
    if(!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.tintColor = UIColorFromRGB(0xDFE2E6);
        _progressView.progressTintColor = XKMainTypeColor;
        _progressView.layer.cornerRadius = 2.f;
        _progressView.layer.masksToBounds = YES;
        _progressView.progress = 0.8;
    }
    return _progressView;
}


- (XKWelfareProgressView *)progressTipView {
    if(!_progressTipView) {
        _progressTipView = [[XKWelfareProgressView alloc] init];
        
    }
    return _progressTipView;
}
@end
