//
//  XKWelfareMainSingleCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareMainSingleCell.h"
#import "XKWelfareProgressView.h"
#import "XKTimeSeparateHelper.h"
@interface XKWelfareMainSingleCell ()
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UILabel *standardLabel;
@property (nonatomic, strong)UILabel *progressTipLabel;
@property (nonatomic, strong)UIProgressView *openProgress;

@property (nonatomic, strong)XKWelfareProgressView *progressNumberView;
@end

@implementation XKWelfareMainSingleCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addCustomSuviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)bindData:(WelfareDataItem *)item {
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.mainUrl] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = item.goodsName;
    NSString *point = @(item.perPrice).stringValue;
    NSString *nameStr = [NSString stringWithFormat:@"积分：%@",point];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:nameStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(3, nameStr.length - 3)];
    _priceLabel.attributedText = attrString;
    self.standardLabel.text = [NSString stringWithFormat:@"规格：%@",item.showAttr];

    //item.participateStake
    CGFloat progress = @(item.joinCount).floatValue/item.maxStake;
    self.openProgress.progress = progress;
    NSString *progressText = [NSString stringWithFormat:@"%.0f%%",progress * 100];
    self.progressNumberView.progressLabel.text = progressText;
    CGFloat textW = [progressText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH,MAXFRAG) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XKRegularFont(12)} context:nil].size.width;
    CGFloat offset = progress == 1.f ? (textW + 10 ) : 0;
    [self.progressNumberView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressTipLabel);
        make.height.mas_equalTo(16);
        make.left.equalTo(self.openProgress.mas_left).offset(self.openProgress.width * self.openProgress.progress - offset);
    }];
    
}

- (void)addCustomSuviews {
    
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.standardLabel];
    [self.contentView addSubview:self.progressTipLabel];
    [self.contentView addSubview:self.openProgress];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.progressNumberView];
}

- (void)addUIConstraint {
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(10);
        make.top.equalTo(self.iconImgView);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.progressTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
    [self.openProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressTipLabel);
        make.left.equalTo(self.progressTipLabel.mas_right);
        make.right.equalTo(self.nameLabel.mas_right);
        make.height.mas_equalTo(4);
    }];
    
    
    [self.progressNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.openProgress);
        make.height.mas_equalTo(16);
        make.left.equalTo(self.openProgress.mas_left).offset(self.openProgress.width * self.openProgress.progress);
    }];
    
    [self.standardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.progressTipLabel.mas_top);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.standardLabel.mas_top);
    }];
    
    [self layoutIfNeeded];
    [self.progressNumberView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressTipLabel);
        make.height.mas_equalTo(16);
        make.left.equalTo(self.openProgress.mas_left).offset(self.openProgress.width * self.openProgress.progress - 10);
    }];
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.image = kDefaultPlaceHolderImg;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 2;
        _nameLabel.text = @"柏品 泰尼亚羊毛桑蚕丝混纺面料西装 男士商务西服套装 纯色套西";
    }
    return _nameLabel;
}

- (UILabel *)standardLabel {
    if(!_standardLabel) {
        _standardLabel = [[UILabel alloc] init];
        [_standardLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _standardLabel.textColor = UIColorFromRGB(0x777777);
        _standardLabel.text = @"规格： 46（170/88A）藏青色";
    }
    return _standardLabel;
}

- (UILabel *)progressTipLabel {
    if(!_progressTipLabel) {
        _progressTipLabel = [[UILabel alloc] init];
        [_progressTipLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _progressTipLabel.textColor = UIColorFromRGB(0x777777);
        _progressTipLabel.text = @"进度：";
    }
    return _progressTipLabel;
}

- (UIProgressView *)openProgress {
    if(!_openProgress) {
        _openProgress = [[UIProgressView alloc] init];
        _openProgress.progressTintColor = XKMainTypeColor;
        _openProgress.trackTintColor = UIColorFromRGB(0xe5e5e5);
        _openProgress.layer.cornerRadius = 2.f;
        _openProgress.layer.masksToBounds = YES;
    }
    return _openProgress;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        [_priceLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _priceLabel.textColor = UIColorFromRGB(0x777777);
        _priceLabel.text  = @"消费券: 1079";
    }
    return _priceLabel;
}

- (XKWelfareProgressView *)progressNumberView {
    if(!_progressNumberView) {
        _progressNumberView = [[XKWelfareProgressView alloc] init];
    }
    return _progressNumberView;
}
@end
