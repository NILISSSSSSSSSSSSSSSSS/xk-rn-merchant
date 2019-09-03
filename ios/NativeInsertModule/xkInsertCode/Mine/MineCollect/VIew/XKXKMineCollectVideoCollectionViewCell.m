/*******************************************************************************
 # File        : XKXKMineCollectVideoCollectionViewCell.m
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

#import "XKXKMineCollectVideoCollectionViewCell.h"
#import "UIView+XKCornerRadius.h"
@interface XKXKMineCollectVideoCollectionViewCell ()
@property (nonatomic, strong)UIImageView *contentImageView;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UIImageView *loveIconImgView;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *contentLabel;
@property (nonatomic, strong)UILabel     *loveCountLabel;
@property (nonatomic, assign)BOOL        isEdit;
@property (nonatomic, strong)UIButton    *sendChoseBtn;

@end

@implementation XKXKMineCollectVideoCollectionViewCell

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
    self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.contentView addSubview:self.contentImageView];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.loveIconImgView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.loveCountLabel];
    [self.contentView addSubview:self.shareButton];
    [self.contentView addSubview:self.sendChoseBtn];

}

- (void)setModel:(XKVideoDisplayVideoListItemModel *)model {
    _model = model;
    [_contentImageView sd_setImageWithURL:[NSURL URLWithString:model.video.first_cover]];
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.user.user_img]];
    _nameLabel.text = model.user.user_name;
    _contentLabel.text = model.video.describe;
    _loveCountLabel.text = [NSString stringWithFormat:@"%ld",(long)model.video.praise_num];
    _shareButton.selected = _model.isSelected;
    _sendChoseBtn.selected = _model.isSendSelected;
    if (self.controllerType == XKMeassageCollectControllerType) {
        _sendChoseBtn.hidden = NO;
        _shareButton.hidden = YES;
    }else {
        _sendChoseBtn.hidden = YES;
        _shareButton.hidden = NO;
    }
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

- (void)sendChoseAction:(UIButton *)sender {
    self.model.isSendSelected = !self.model.isSendSelected;
    if (self.sendChoseblock) {
        self.sendChoseblock(self.model);
    }
}

- (void)addUIConstraint {
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.contentView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(@(-10));
        make.height.mas_equalTo(30);
    }];
    [self.loveIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.bottom.equalTo(self.contentLabel.mas_top).offset(-4);
        make.height.width.mas_equalTo(20);
    }];
    [self.loveCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.loveIconImgView.mas_right).offset(3);
        make.centerY.equalTo(self.loveIconImgView);
        make.height.mas_equalTo(15);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.equalTo(self.loveCountLabel.mas_top).offset(-6);
        make.height.width.mas_equalTo(30);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.iconImgView.mas_right).offset(7);
        make.centerY.equalTo(self.iconImgView);
        make.height.mas_equalTo(20);
    }];

    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.equalTo(@(-10));
        make.width.height.equalTo(@(16));
    }];
    
    [self.sendChoseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.equalTo(@(-10));
        make.width.height.equalTo(@(16));
    }];
}
- (void)updateLayout {
    self.isEdit = YES;
    [self.shareButton setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
    [self.shareButton setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
    _shareButton.backgroundColor = [UIColor clearColor];
}

- (void)restoreLayout {
    self.isEdit = NO;
    [self.shareButton setImage:[UIImage imageNamed:@"xk_btn_home_share"] forState:0];
    [self.shareButton setImage:[UIImage imageNamed:@"xk_btn_home_share"] forState:UIControlStateSelected];
    _shareButton.backgroundColor = [UIColor grayColor];

}

- (UIImageView *)contentImageView {
    if(!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.layer.masksToBounds = YES;
    }
    return _contentImageView;
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImgView.layer.borderWidth = 0.5;
        _iconImgView.xk_clipType = XKCornerClipTypeAllCorners;
        _iconImgView.xk_openClip = YES;
        _iconImgView.xk_radius = 10;
    }
    return _iconImgView;
}

- (UIImageView *)loveIconImgView {
    if(!_loveIconImgView) {
        _loveIconImgView = [[UIImageView alloc] init];
        _loveIconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _loveIconImgView.image = [UIImage imageNamed:@"xk_btn_home_star"];
    }
    return _loveIconImgView;
}
- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:11]];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = @"林夕，风拂面";
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if(!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.numberOfLines = 2;
        _contentLabel.text = @"今天天气很好，晒一晒！今天天气很好，晒一晒！今天天气很好，晒一晒！";
    }
    return _contentLabel;
}

- (UILabel *)loveCountLabel {
    if(!_loveCountLabel) {
        _loveCountLabel = [[UILabel alloc] init];
        [_loveCountLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:9]];
        _loveCountLabel.textColor = [UIColor whiteColor];
        NSString *count = @"12999";
        _loveCountLabel.text = count;
    }
    return _loveCountLabel;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc]init];
        [_shareButton setImage:[UIImage imageNamed:@"xk_btn_collection-zf"] forState:UIControlStateNormal];
        _shareButton.layer.masksToBounds = YES;
        _shareButton.layer.cornerRadius = 8;
        [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
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
@end
