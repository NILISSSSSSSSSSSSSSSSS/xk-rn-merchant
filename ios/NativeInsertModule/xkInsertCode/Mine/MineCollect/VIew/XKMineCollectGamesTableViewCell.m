/*******************************************************************************
 # File        : XKMineCollectGamesTableViewCell.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/10
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKMineCollectGamesTableViewCell.h"
#import "XKCommonStarView.h"
#import "XKBottomAlertSheetView.h"
@interface XKMineCollectGamesTableViewCell ()
@property (nonatomic, strong)UIButton    *choseBtn;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *sentimentLabel;
@property (nonatomic, strong)UIView      *segmentationView;
@property (nonatomic, strong)UILabel     *gameSizeLabel;
@property (nonatomic, strong)UIView      *segmengView;
@property (nonatomic, strong)XKCommonStarView      *starView;
@property (nonatomic, strong)UILabel     *contentLabel;
@property (nonatomic, strong)XKBottomAlertSheetView     *sheetView;

@property (nonatomic, strong)UIButton    *sendChoseBtn;


@end

@implementation XKMineCollectGamesTableViewCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 初始化默认数据
        [self createDefaultData];
        // 初始化界面
        [self createUI];
        // 布局界面
        [self createConstraints];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
    [super createUI];
    [self.myContentView addSubview:self.choseBtn];
    [self.myContentView addSubview:self.iconImgView];
    [self.myContentView addSubview:self.nameLabel];
    [self.myContentView addSubview:self.sentimentLabel];
    [self.myContentView addSubview:self.gameSizeLabel];
    [self.myContentView addSubview:self.shareButton];
    [self.myContentView addSubview:self.sendChoseBtn];
    [self.myContentView addSubview:self.segmengView];
    [self.myContentView addSubview:self.segmentationView];
    [self.myContentView addSubview:self.starView];
    [self.myContentView addSubview:self.contentLabel];
    self.choseBtn.hidden = YES;
}

- (void)setModel:(XKCollectGamesModelDataItem *)model {
    _model = model;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.target.showPics]];
    _starView.scorePercent = model.target.popularity / 5.0;
    _nameLabel.text = model.target.name;
    _gameSizeLabel.text = [NSString stringWithFormat:@"游戏大小:%ld",(long)model.target.size];
    _contentLabel.text = model.target.describe;
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
#pragma mark - 布局界面
- (void)createConstraints {
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.myContentView);
        make.width.mas_equalTo(40 * ScreenScale);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myContentView.mas_left).offset(15 * ScreenScale);
        make.top.equalTo(self.myContentView.mas_top).offset(15 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(80 * ScreenScale, 80 * ScreenScale));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15 * ScreenScale);
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.equalTo(self.myContentView.mas_right).offset(-15 * ScreenScale);
    }];
    
    [self.sentimentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15 * ScreenScale);
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
        make.left.equalTo(self.iconImgView.mas_right).offset(15 * ScreenScale);
        make.top.equalTo(self.starView.mas_bottom).offset(10 * ScreenScale);
        make.right.equalTo(self.myContentView.mas_right).offset(-15 * ScreenScale);
    }];
    
    [self.gameSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentationView.mas_right).offset(5 * ScreenScale);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5 * ScreenScale);
        make.right.mas_equalTo(-15 * ScreenScale);
        make.height.mas_equalTo(15 * ScreenScale);
    }];
    
    
    [self.segmengView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.myContentView);
        make.height.mas_equalTo(1);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * ScreenScale);
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
        _iconImgView.layer.borderWidth = 1.f;
        _iconImgView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        _iconImgView.xk_clipType = XKCornerClipTypeAllCorners;
        _iconImgView.xk_openClip = YES;
        _iconImgView.xk_radius = 10;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 1;
        _nameLabel.text = @"疯狂的老鸟";
    }
    return _nameLabel;
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

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc]init];
        [_shareButton setImage:[UIImage imageNamed:@"xk_btn_home_share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (UIView *)segmengView {
    if(!_segmengView) {
        _segmengView = [[UIView alloc] init];
        _segmengView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _segmengView;
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
- (void)shareAction:(UIButton *)sender {
    if (self.shareBlock) {
        self.shareBlock(self.model);
    }
}


- (XKBottomAlertSheetView *)sheetView {
    if (!_sheetView) {
        _sheetView = [[XKBottomAlertSheetView alloc]init];
    }
    return _sheetView;
}
@end
