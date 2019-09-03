/*******************************************************************************
 # File        : XKMineCollectGoodsSingularTableViewCell.m
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
#import "UIView+XKCornerBorder.h"
#import "XKMineCollectGoodsSingularTableViewCell.h"
@interface XKMineCollectGoodsSingularTableViewCell ()
@property (nonatomic, strong)UIButton    *choseBtn;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *monthCountLabel;
@property (nonatomic, strong)UILabel     *piceLabel;
@property (nonatomic, strong)UIView      *segmengView;
@property (nonatomic, strong)UIButton    *sendChoseBtn;
/**右上角标签*/
@property (nonatomic, strong) UIButton    *tagButton;
@end

@implementation XKMineCollectGoodsSingularTableViewCell

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
  [self.myContentView addSubview:self.sendChoseBtn];
  [self.myContentView addSubview:self.tagButton];
  
  self.choseBtn.hidden = YES;
}
- (void)shareAction:(UIButton *)sender {
  if (self.shareBlock) {
    self.shareBlock(self.model);
  }
}

- (void)setModel:(XKCollectGoodsDataItem *)model {
  _model = model;
  [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.target.showPics] placeholderImage:kDefaultPlaceHolderImg];
  _nameLabel.text = model.target.name;
  NSString *mouthVolumeStr = @"";
  if (model.target.mouthVolume > 10000) {
    mouthVolumeStr = [NSString stringWithFormat:@"销售量：%ldw",model.target.mouthVolume/10000];
  }else{
    mouthVolumeStr = [NSString stringWithFormat:@"销售量：%ld",(long)model.target.mouthVolume];
  }
  _monthCountLabel.text = mouthVolumeStr;
  NSAttributedString *attrString;
  NSString *status = [NSString stringWithFormat:@"￥%.2f",model.target.buyPrice.floatValue / 100.f];
  if ([model.target.price isEqualToString: @"0"] || model.target.price == nil) {
    attrString = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
      confer.text(@"惊喜价:");
      confer.text(status).textColor(HEX_RGB(0xee6161));
    }];
  }else{
    attrString = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
      confer.text(@"惊喜价:");
      confer.text(status).textColor(HEX_RGB(0xee6161));
      confer.text(@" ");
      confer.text([NSString stringWithFormat:@"￥%.2f",model.target.price.floatValue/ 100.f]).strikeThrough(RZLineStyleSignl).strikeThroughColor(HEX_RGB(0x999999)).textColor(HEX_RGB(0x999999));
    }];
  }
  _piceLabel.attributedText = attrString;
  _choseBtn.selected = _model.isSelected;
  _sendChoseBtn.selected = _model.isSendSelected;
  if (self.controllerType == XKMeassageCollectControllerType) {
    _sendChoseBtn.hidden = NO;
    _shareButton.hidden = YES;
  }else {
    _sendChoseBtn.hidden = YES;
    _shareButton.hidden = NO;
  }
  if (model.target.isLoseEfficacy) {
    _tagButton.hidden = NO;
  }else{
    _tagButton.hidden = YES;
  }
}
- (void)addUIConstraint {
  [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.bottom.equalTo(self.myContentView);
    make.width.mas_equalTo(40 * ScreenScale);
  }];
  
  [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.myContentView.mas_left).offset(15 * ScreenScale);
    make.size.mas_equalTo(CGSizeMake(80 * ScreenScale, 80 * ScreenScale));
    make.centerY.equalTo(self.myContentView);
  }];
  
  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.iconImgView.mas_right).offset(15 * ScreenScale);
    make.top.equalTo(self.iconImgView.mas_top);
    make.right.equalTo(self.myContentView.mas_right).offset(-15 * ScreenScale);
  }];
  
  [self.monthCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.iconImgView.mas_right).offset(15 * ScreenScale);
    make.top.equalTo(self.nameLabel.mas_bottom).offset(12 * ScreenScale);
    make.right.equalTo(self.nameLabel);
    make.height.mas_equalTo(17);
  }];
  
  [self.piceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.iconImgView.mas_right).offset(15 * ScreenScale);
    make.top.equalTo(self.monthCountLabel.mas_bottom).offset(5 * ScreenScale);
    make.right.equalTo(self.nameLabel);
    make.height.mas_equalTo(17);
  }];
  
  [self.segmengView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.left.right.equalTo(self.myContentView);
    make.height.mas_equalTo(1);
  }];
  [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(@(-15 * ScreenScale));
    make.bottom.mas_equalTo(-20 * ScreenScale);
    make.width.height.equalTo(@(20 * ScreenScale));
  }];
  
  [self.sendChoseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.mas_equalTo(self.iconImgView.mas_bottom);
    make.right.equalTo(@(-20 * ScreenScale));
    make.width.height.equalTo(@(20 * ScreenScale));
  }];
  
  [self.tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.top.equalTo(self.myContentView);
    make.height.mas_equalTo(24);
    make.width.mas_equalTo(47);
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
  if(!_choseBtn)     {
    _choseBtn = [[UIButton alloc] init];
    [_choseBtn setImage:[UIImage imageNamed:@"xk_btn_collection_unSelect"] forState:0];
    [_choseBtn addTarget:self action:@selector(choseAction:) forControlEvents:UIControlEventTouchUpInside];
    [_choseBtn setImage:[UIImage imageNamed:@"xk_btn_collection_select"] forState:UIControlStateSelected];
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
    _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImgView.xk_clipType = XKCornerClipTypeAllCorners;
    _iconImgView.xk_openClip = YES;
    _iconImgView.xk_radius = 5;
    _iconImgView.xk_openBorder = YES;
    _iconImgView.xk_borderType = XKBorderTypeAllCorners;
    _iconImgView.xk_borderColor = HEX_RGB(0xF1F1F1);
    _iconImgView.xk_borderWidth = 1.f;
    _iconImgView.xk_borderRadius = 5;
  }
  return _iconImgView;
}

- (UILabel *)nameLabel {
  if(!_nameLabel) {
    _nameLabel = [[UILabel alloc] init];
    [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
    _nameLabel.textColor = UIColorFromRGB(0x222222);
    _nameLabel.numberOfLines = 2;
  }
  return _nameLabel;
}

- (UILabel *)monthCountLabel {
  if(!_monthCountLabel) {
    _monthCountLabel = [[UILabel alloc] init];
    [_monthCountLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
    _monthCountLabel.textColor = UIColorFromRGB(0x555555);
    _monthCountLabel.text = @"月销量:12.5w";
  }
  return _monthCountLabel;
}

- (UILabel *)piceLabel {
  if(!_piceLabel) {
    _piceLabel = [[UILabel alloc] init];
    [_piceLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
    _piceLabel.textColor = UIColorFromRGB(0x555555);
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

- (void)setFrame:(CGRect)frame {
  frame.size.width -= 20;
  frame.origin.x += 10;
  [super setFrame:frame];
}

-(UIButton *)tagButton {
  if (!_tagButton) {
    _tagButton = [[UIButton alloc] init];
    [_tagButton setImage:[UIImage imageNamed:@"xk_btn_collection_shixiao"] forState:0];
  }
  return _tagButton;
}
@end
