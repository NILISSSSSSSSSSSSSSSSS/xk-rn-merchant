/*******************************************************************************
 # File        : XKMineCollectShopTableViewCell.m
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

#import "XKMineCollectShopTableViewCell.h"
#import "XKCommonStarView.h"
#import "XKBottomAlertSheetView.h"
#import <MapKit/MapKit.h>
#import "XKBaiduLocation.h"
#define MAX_OFFSET_X 250
#define MIN_OFFSET_X 60
#define DELETE_BUTTON_WIDTH 80
#define CELL_BUTTON_HEIGHT self.scrollContent.bounds.size.height
@interface XKMineCollectShopTableViewCell ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIButton    *choseBtn;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *smallNameLabel;
@property (nonatomic, strong)UILabel     *monthCountLabel;
@property (nonatomic, strong)UILabel     *distanceLabel;
@property (nonatomic, strong)UIView      *segmengView;
@property (nonatomic, strong)UIView      *segmentationView2;
@property (nonatomic, strong)UIView      *segmentationView;
@property (nonatomic, strong)XKCommonStarView      *starView;
@property (nonatomic, strong)UILabel     *countLabel;
@property (nonatomic, strong)UILabel     *countLabel2;
@property (nonatomic, strong)XKBottomAlertSheetView     *sheetView;
@property (nonatomic, strong)UIButton    *sendChoseBtn;

@end

@implementation XKMineCollectShopTableViewCell

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
    [self.myContentView addSubview:self.monthCountLabel];
    [self.myContentView addSubview:self.distanceLabel];
    [self.myContentView addSubview:self.shareButton];
    [self.myContentView addSubview:self.sendChoseBtn];
    [self.myContentView addSubview:self.segmengView];
    [self.myContentView addSubview:self.segmentationView];
    [self.myContentView addSubview:self.starView];
    [self.myContentView addSubview:self.countLabel];
    [self.myContentView addSubview:self.countLabel2];
    [self.myContentView addSubview:self.segmentationView2];
    [self.myContentView addSubview:self.smallNameLabel];
    self.choseBtn.hidden = YES;
}
- (void)setModel:(XKCollectShopModelDataItem *)model {
    _model = model;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.target.showPics] placeholderImage:kDefaultPlaceHolderImg];
    _nameLabel.text = model.target.name;
    NSString *mouthVolumeStr = @"";
    if (model.target.mouthCount > 10000) {
        mouthVolumeStr = [NSString stringWithFormat:@"月销量：%ldw",model.target.mouthCount/10000];
    }else{
        mouthVolumeStr = [NSString stringWithFormat:@"月销量：%ld",(long)model.target.mouthCount];
    }
    _monthCountLabel.text = mouthVolumeStr;
    _smallNameLabel.text = @"";
    _starView.scorePercent = model.target.starLevel / 5;
    _countLabel2.text = [NSString stringWithFormat:@"人均￥%ld起",(long)model.target.avgConsumption];
    _countLabel.text = [NSString stringWithFormat:@"%ld分",(long)model.target.starLevel];
    CLLocationCoordinate2D cl2d = [[XKBaiduLocation shareManager]getUserLocationLaititudeAndLongtitude];
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:cl2d.latitude longitude:cl2d.longitude];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:model.target.lat.doubleValue longitude:model.target.lng.doubleValue];
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    NSString *distanceStr = @"";
    if (distance >1000.00) {
        distanceStr = [NSString stringWithFormat:@"距离：%0.1fkm",distance/1000];
    }else {
        distanceStr = [NSString stringWithFormat:@"距离：%0.1fm",distance];
    }
    _distanceLabel.text = distanceStr;
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

    [self.smallNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15 * ScreenScale);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5 * ScreenScale);
        make.right.equalTo(self.myContentView.mas_right).offset(-15 * ScreenScale);
        make.height.mas_equalTo(17 * ScreenScale);
    }];

    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15 * ScreenScale);
        make.top.equalTo(self.smallNameLabel.mas_bottom).offset(5 * ScreenScale);
        make.width.mas_equalTo(80 * ScreenScale);
        make.height.mas_equalTo(10 * ScreenScale);
    }];

    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starView.mas_right).offset(15 * ScreenScale);
        make.centerY.equalTo(self.starView);
        make.width.mas_equalTo(20 * ScreenScale);
        make.height.mas_equalTo(15 * ScreenScale);
    }];

    [self.segmentationView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.starView);
        make.left.equalTo(self.countLabel.mas_right).offset(5 * ScreenScale);
        make.width.equalTo(@1);
        make.height.mas_equalTo(20 * ScreenScale);
    }];


    [self.countLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentationView2.mas_right).offset(5 * ScreenScale);
        make.centerY.equalTo(self.starView);
        make.right.equalTo(self.myContentView).offset(-5 * ScreenScale);
        make.height.mas_equalTo(15 * ScreenScale);
    }];


    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15 * ScreenScale);
        make.top.equalTo(self.starView.mas_bottom).offset(10 * ScreenScale);
        make.width.mas_equalTo(100 * ScreenScale);
    }];

    [self.segmentationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.distanceLabel);
        make.left.equalTo(self.distanceLabel.mas_right).offset(10 * ScreenScale);
        make.width.equalTo(@1);
        make.height.mas_equalTo(20 * ScreenScale);
    }];

    [self.monthCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentationView.mas_right).offset(10 * ScreenScale);
        make.centerY.equalTo(self.distanceLabel);
        make.height.mas_equalTo(30 * ScreenScale);
        make.right.equalTo(@(-10 * ScreenScale));
    }];

    [self.segmengView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.myContentView);
        make.height.mas_equalTo(1);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.distanceLabel).offset(10 * ScreenScale);
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
        self.block(self.index, sender);
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
        _nameLabel.text = @"1+家便利店（晓可广场店）";
    }
    return _nameLabel;
}

- (UILabel *)smallNameLabel {
    if(!_smallNameLabel) {
        _smallNameLabel = [[UILabel alloc] init];
        [_smallNameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _smallNameLabel.textColor = UIColorFromRGB(0x555555);
        _smallNameLabel.text = @"鸡排";
    }
    return _smallNameLabel;
}
- (UILabel *)monthCountLabel {
    if(!_monthCountLabel) {
        _monthCountLabel = [[UILabel alloc] init];
        [_monthCountLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _monthCountLabel.textColor = UIColorFromRGB(0x555555);
        _monthCountLabel.text = @"成交量:12.5w单";
    }
    return _monthCountLabel;
}

- (UILabel *)countLabel {
    if(!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        [_countLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _countLabel.textColor = UIColorFromRGB(0x555555);
        _countLabel.text = @"4分";
    }
    return _countLabel;
}

- (UILabel *)countLabel2 {
    if(!_countLabel2) {
        _countLabel2 = [[UILabel alloc] init];
        [_countLabel2 setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _countLabel2.textColor = UIColorFromRGB(0x555555);
        _countLabel2.text = @"人均：￥269起";
    }
    return _countLabel2;
}
- (UILabel *)distanceLabel {
    if(!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        [_distanceLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _distanceLabel.textColor = UIColorFromRGB(0x555555);
        NSString *status = @"190m";
        NSString *statusStr = [NSString stringWithFormat:@"距离：%@",status];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:statusStr];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0xee6161)
                           range:NSMakeRange(5, statusStr.length - 5)];
        _distanceLabel.attributedText = attrString;
    }
    return _distanceLabel;
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

- (UIView *)segmentationView2 {
    if(!_segmentationView2) {
        _segmentationView2 = [[UIView alloc] init];
        _segmentationView2.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _segmentationView2;
}


- (XKCommonStarView *)starView {
    if (!_starView) {
        _starView = [[XKCommonStarView alloc] initWithFrame:CGRectMake(0, 0, 80 * ScreenScale, 10 * ScreenScale) numberOfStars:5];
        _starView.userInteractionEnabled = NO;
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
