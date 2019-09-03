/*******************************************************************************
 # File        : XKMineCollectWelfareDoubleCollectionViewCell.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/10
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKMineCollectWelfareDoubleCollectionViewCell.h"

#import "XKWelfareProgressView.h"
@interface XKMineCollectWelfareDoubleCollectionViewCell ()
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *monthCountLabel;
@property (nonatomic, strong)UILabel     *piceLabel;
@property (nonatomic, strong)UIView      *segmengView;
@property (nonatomic, strong)UILabel *progressLabel;
@property (nonatomic, strong)XKWelfareProgressView *progressTipView;
@property (nonatomic, strong)UIProgressView *progressView;
@property (nonatomic, assign)BOOL        isEdit;

@end

@implementation XKMineCollectWelfareDoubleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}
- (void)addCustomSubviews {
    self.contentView.layer.borderWidth = 0.3;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.monthCountLabel];
    [self.contentView addSubview:self.piceLabel];
    [self.contentView addSubview:self.segmengView];
    [self.contentView addSubview:self.shareButton];
    [self.contentView addSubview:self.progressLabel];
    [self.contentView addSubview:self.progressView];
    [self.contentView addSubview:self.progressTipView];
    
}
- (void)shareAction:(UIButton *)sender {
    if (self.isEdit) {
        NSLog(@"编辑中");
        self.model.isSelected = !self.model.isSelected;
        if (self.block) {
            self.block();
        }
    }else{
        NSLog(@"分享");
        if (self.shareBlock) {
            self.shareBlock(self.model);
        }
    }
}

- (void)setModel:(XKCollectWelfareDataItem *)model {
    _model = model;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.target.showPics] placeholderImage:kDefaultPlaceHolderImg];
    _nameLabel.text = model.target.goodsName;
    NSString *status = @(model.target.perPrice / 100).stringValue;
    NSString *statusStr = [NSString stringWithFormat:@"代金券：%@",status];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:statusStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(4, statusStr.length - 4)];
    _piceLabel.attributedText = attrString;
    _monthCountLabel.text = [NSString stringWithFormat:@"产品规格：%@",model.target.showAttr];
    _progressView.progress = 0.8;
    if (self.isEdit) {
        _shareButton.selected = _model.isSelected;
    }
}
- (void)addUIConstraint {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(150 * ScreenScale);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10 * ScreenScale);
        make.left.equalTo(self.contentView).offset(10 * ScreenScale);
        make.top.equalTo(self.iconImgView.mas_bottom);
        make.height.mas_equalTo(40 * ScreenScale);
    }];
    
    [self.monthCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10 * ScreenScale);
        make.left.equalTo(self.contentView).offset(10 * ScreenScale);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10 * ScreenScale);
        make.height.mas_equalTo(20 * ScreenScale);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10 * ScreenScale);
        make.top.equalTo(self.monthCountLabel.mas_bottom).offset(5 * ScreenScale);
        make.width.mas_equalTo(80 * ScreenScale);
        make.height.mas_equalTo(20 * ScreenScale);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressLabel.mas_right);
        make.centerY.equalTo(self.progressLabel);
        make.height.mas_equalTo(4 * ScreenScale);
        make.right.equalTo(self.contentView.mas_right).offset(-15 * ScreenScale);
    }];
    
    [self.progressTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.height.mas_equalTo(16 * ScreenScale);
        make.left.equalTo(self.progressView.mas_right).multipliedBy(self.progressView.progress);
    }];
    
    [self.piceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10 * ScreenScale);
        make.left.equalTo(self.contentView).offset(10 * ScreenScale);
        make.top.equalTo(self.progressLabel.mas_bottom).offset(10 * ScreenScale);
        make.height.mas_equalTo(20 * ScreenScale);
    }];
    
    
    [self.segmengView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.iconImgView.mas_bottom);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * ScreenScale);
        make.right.equalTo(@(-10 * ScreenScale));
        make.width.height.equalTo(@(20 * ScreenScale));
    }];
}
- (void)updateLayout {
    self.isEdit = YES;
    [self.shareButton setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
    [self.shareButton setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];

}

- (void)restoreLayout {
    self.isEdit = NO;
    [self.shareButton setImage:[UIImage imageNamed:@"xk_btn_home_share"] forState:0];
    [self.shareButton setImage:[UIImage imageNamed:@"xk_btn_home_share"] forState:UIControlStateSelected];

}
- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgView.clipsToBounds = YES;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 2;
        _nameLabel.text = @"9.9折全场包邮/9.9折全场包邮/9.9折全场包邮";
    }
    return _nameLabel;
}

- (UILabel *)monthCountLabel {
    if(!_monthCountLabel) {
        _monthCountLabel = [[UILabel alloc] init];
        [_monthCountLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _monthCountLabel.textColor = UIColorFromRGB(0x555555);
        _monthCountLabel.text = @"产品规格:500ml+120ml";
    }
    return _monthCountLabel;
}

- (UILabel *)piceLabel {
    if(!_piceLabel) {
        _piceLabel = [[UILabel alloc] init];
        [_piceLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _piceLabel.textColor = UIColorFromRGB(0x555555);
        NSString *status = @"20000";
        NSString *statusStr = [NSString stringWithFormat:@"代金券：%@",status];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:statusStr];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0xee6161)
                           range:NSMakeRange(5, statusStr.length - 5)];
        _piceLabel.attributedText = attrString;
    }
    return _piceLabel;
}

- (UIView *)segmengView {
    if(!_segmengView) {
        _segmengView = [[UIView alloc] init];
        _segmengView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _segmengView;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc]init];
        [_shareButton setImage:[UIImage imageNamed:@"xk_btn_home_share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (UILabel *)progressLabel {
    if(!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textColor = UIColorFromRGB(0x777777);
        _progressLabel.font =  [UIFont fontWithName:XK_PingFangSC_Regular size:14];
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
