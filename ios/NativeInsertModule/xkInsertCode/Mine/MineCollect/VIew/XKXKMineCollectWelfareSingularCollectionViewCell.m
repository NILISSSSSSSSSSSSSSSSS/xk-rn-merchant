/*******************************************************************************
 # File        : XKXKMineCollectWelfareSingularCollectionViewCell.m
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

#import "XKXKMineCollectWelfareSingularCollectionViewCell.h"
#import "XKWelfareProgressView.h"
@interface XKXKMineCollectWelfareSingularCollectionViewCell ()
@property (nonatomic, strong)UIButton    *choseBtn;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *monthCountLabel;
@property (nonatomic, strong)UILabel     *piceLabel;
@property (nonatomic, strong)UIView      *segmengView;
@property (nonatomic, strong)UILabel *progressLabel;
@property (nonatomic, strong)XKWelfareProgressView *progressTipView;
@property (nonatomic, strong)UIProgressView *progressView;
@property (nonatomic, strong)UIButton    *sendChoseBtn;

@end

@implementation XKXKMineCollectWelfareSingularCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self addUIConstraint];
    }
    return self;
}
- (void)createUI {
    [super createUI];
    [self addCustomSubviews];
}
- (void)addCustomSubviews {
    [self.myContentView addSubview:self.choseBtn];
    [self.myContentView addSubview:self.iconImgView];
    [self.myContentView addSubview:self.nameLabel];
    [self.myContentView addSubview:self.monthCountLabel];
    [self.myContentView addSubview:self.piceLabel];
    [self.myContentView addSubview:self.segmengView];
    [self.myContentView addSubview:self.shareButton];
    [self.myContentView addSubview:self.progressLabel];
    [self.myContentView addSubview:self.progressView];
    [self.myContentView addSubview:self.progressTipView];
    [self.myContentView addSubview:self.sendChoseBtn];
    self.choseBtn.hidden = YES;
}
- (void)shareAction:(UIButton *)sender {
    NSLog(@"111111");
    if (self.shareBlock) {
        self.shareBlock(self.model);
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
    _choseBtn.selected = _model.isSelected;
    _sendChoseBtn.selected = _model.isSendSelected;
    if (self.controllerType == XKMeassageCollectControllerType) {
        _sendChoseBtn.hidden = NO;
        _shareButton.hidden = YES;
    }else {
        _sendChoseBtn.hidden = YES;
        _shareButton.hidden = NO;
    }
    
}
- (void)addUIConstraint {
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.myContentView);
        make.width.mas_equalTo(40 * ScreenScale);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myContentView.mas_left).offset(15 * ScreenScale);
        make.top.equalTo(self.myContentView.mas_top).offset(15 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(100 * ScreenScale, 100 * ScreenScale));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(12 * ScreenScale);
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.equalTo(self.myContentView.mas_right).offset(-15 * ScreenScale);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(12 * ScreenScale);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5 * ScreenScale);
        make.width.mas_equalTo(80 * ScreenScale);
        make.height.mas_equalTo(12 * ScreenScale);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressLabel.mas_right);
        make.centerY.equalTo(self.progressLabel);
        make.height.mas_equalTo(4 * ScreenScale);
        make.right.equalTo(self.myContentView.mas_right).offset(-15 * ScreenScale);
    }];
    
    [self.progressTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.height.mas_equalTo(16 * ScreenScale);
        make.left.equalTo(self.progressView.mas_right).multipliedBy(self.progressView.progress);
    }];
    
    [self.monthCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(12 * ScreenScale);
        make.top.equalTo(self.progressTipView.mas_bottom).offset(5 * ScreenScale);
        make.right.mas_equalTo(-15 * ScreenScale);
        make.height.mas_equalTo(15 * ScreenScale);
    }];
    
    [self.piceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(12 * ScreenScale);
        make.top.equalTo(self.monthCountLabel.mas_bottom).offset(2 * ScreenScale);
        make.right.mas_equalTo(-15 * ScreenScale);
        make.height.mas_equalTo(15 * ScreenScale);
    }];
    
    [self.segmengView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.myContentView);
        make.height.mas_equalTo(1);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.piceLabel).offset(10 * ScreenScale);
        make.right.equalTo(@(-20 * ScreenScale));
        make.width.height.equalTo(@(20 * ScreenScale));
    }];
    
    [self.sendChoseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.iconImgView.mas_bottom);
        make.right.equalTo(@(-20 * ScreenScale));
        make.width.height.equalTo(@(20 * ScreenScale));
    }];
}
- (void)updateLayout {
    self.choseBtn.hidden = NO;
    [self.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myContentView.mas_left).offset(40 * ScreenScale);
    }];
}

- (void)restoreLayout {
    self.choseBtn.hidden = YES;
    [self.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myContentView.mas_left).offset(15 * ScreenScale);
    }];
}
- (void)choseAction:(UIButton *)sender {
    self.model.isSelected = !self.model.isSelected;
    if (self.block) {
        self.block();
    }
}
- (void)sendChoseAction:(UIButton *)sender {
    self.model.isSendSelected = !self.model.isSendSelected;
    if (self.sendChoseblock) {
        self.sendChoseblock(self.model);
    }
}
#pragma mark 懒加载
- (UIButton *)choseBtn {
    if(!_choseBtn) {
        _choseBtn = [[UIButton alloc] init];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
        [_choseBtn addTarget:self action:@selector(choseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
    }
    return _choseBtn;
}

- (UIButton *)sendChoseBtn {
    if(!_sendChoseBtn) {
        _sendChoseBtn = [[UIButton alloc] init];
        [_sendChoseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
        [_sendChoseBtn addTarget:self action:@selector(sendChoseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sendChoseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
    }
    return _sendChoseBtn;
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        _iconImgView.xk_clipType = XKCornerClipTypeAllCorners;
        _iconImgView.xk_openClip = YES;
        _iconImgView.xk_radius = 5;
        
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

- (void)setFrame:(CGRect)frame {
    frame.size.width -= 20;
    frame.origin.x += 10;
    [super setFrame:frame];
}
@end
