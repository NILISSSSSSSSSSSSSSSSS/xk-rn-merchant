/*******************************************************************************
 # File        : XKXKMineCollectGoodsDoubleCollectionViewCell.m
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

#import "XKXKMineCollectGoodsDoubleCollectionViewCell.h"
#import "UIView+XKCornerBorder.h"
@interface XKXKMineCollectGoodsDoubleCollectionViewCell ()
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *monthCountLabel;
@property (nonatomic, strong)UILabel     *piceLabel;
@property (nonatomic, strong)UIView      *segmengView;
@property (nonatomic, strong)UIView      *bigContentView;
@property (nonatomic, assign)BOOL        isEdit;
/**右上角标签*/
@property (nonatomic, strong) UIButton    *tagButton;
@end

@implementation XKXKMineCollectGoodsDoubleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.isEdit = NO;
    [self addCustomSubviews];
    [self addUIConstraint];
  }
  return self;
}
- (void)addCustomSubviews {
  self.contentView.xk_openBorder = YES;
  self.contentView.xk_borderType = XKBorderTypeAllCorners;
  self.contentView.xk_borderColor = HEX_RGB(0xF1F1F1);
  self.contentView.xk_borderRadius = 5.0;
  self.contentView.xk_borderWidth = 1.0;
  [self.contentView addSubview:self.iconImgView];
  [self.contentView addSubview:self.nameLabel];
  [self.contentView addSubview:self.monthCountLabel];
  [self.contentView addSubview:self.piceLabel];
  [self.contentView addSubview:self.shareButton];
  [self.contentView addSubview:self.segmengView];
  [self.contentView addSubview:self.tagButton];
  
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
      confer.paragraphStyle.lineSpacing(5);
      confer.text(@"惊喜价:");
      confer.text(status).textColor(HEX_RGB(0xee6161));
    }];
    
  }else{
    attrString = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
      confer.paragraphStyle.lineSpacing(5);
      confer.text(@"原价:");
      confer.text([NSString stringWithFormat:@"￥%.2f",model.target.price.floatValue / 100.f]).strikeThrough(RZLineStyleSignl).strikeThroughColor(HEX_RGB(0x999999)).textColor(HEX_RGB(0x999999));
      confer.text(@"\n");
      confer.text(@"惊喜价:");
      confer.text(status).textColor(HEX_RGB(0xee6161));
    }];
  }
  
  _piceLabel.attributedText = attrString;
  _shareButton.selected = _model.isSelected;
  if (model.target.isLoseEfficacy) {
    _tagButton.hidden = NO;
  }else{
    _tagButton.hidden = YES;
  }
}

- (void)addUIConstraint {
  [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.equalTo(self.contentView);
    make.height.mas_equalTo(150 * ScreenScale);
  }];
  
  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.contentView).offset(-10);
    make.left.equalTo(self.contentView).offset(10);
    make.top.equalTo(self.iconImgView.mas_bottom);
    make.height.mas_equalTo(32 * ScreenScale);
  }];
  
  [self.monthCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.contentView).offset(-10 * ScreenScale);
    make.left.equalTo(self.contentView).offset(10 * ScreenScale);
    make.top.equalTo(self.nameLabel.mas_bottom).offset(10 * ScreenScale);
    make.height.mas_equalTo(17 * ScreenScale);
  }];
  
  [self.piceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.contentView).offset(-10 * ScreenScale);
    make.left.equalTo(self.contentView).offset(10 * ScreenScale);
    make.top.equalTo(self.monthCountLabel.mas_bottom).offset(2 * ScreenScale);
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
  
  [self.tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.right.equalTo(self.contentView);
    make.height.mas_equalTo(24);
    make.width.mas_equalTo(47);
  }];
}

- (void)updateLayout {
  self.isEdit = YES;
  [self.shareButton setImage:[UIImage imageNamed:@"xk_btn_collection_unSelect"] forState:0];
  [self.shareButton setImage:[UIImage imageNamed:@"xk_btn_collection_select"] forState:UIControlStateSelected];
}

- (void)restoreLayout {
  self.isEdit = NO;
  [self.shareButton setImage:[UIImage imageNamed:@"xk_btn_collection_zhuangfa"] forState:0];
  [self.shareButton setImage:[UIImage imageNamed:@"xk_btn_collection_zhuangfa"] forState:UIControlStateSelected];
  
}
- (UIImageView *)iconImgView {
  if(!_iconImgView) {
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImgView.clipsToBounds = YES;
    _iconImgView.layer.borderColor = HEX_RGB(0xF1F1F1).CGColor;
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
  }
  return _monthCountLabel;
}

- (UILabel *)piceLabel {
  if(!_piceLabel) {
    _piceLabel = [[UILabel alloc] init];
    [_piceLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
    _piceLabel.textColor = UIColorFromRGB(0x555555);
    _piceLabel.numberOfLines = 0;
  }
  return _piceLabel;
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

- (UIView *)bigContentView {
  if(!_bigContentView) {
    _bigContentView = [[UIView alloc] init];
    _bigContentView.backgroundColor = UIColorFromRGB(0xf1f1f1);
  }
  return _bigContentView;
}
-(UIButton *)tagButton {
  if (!_tagButton) {
    _tagButton = [[UIButton alloc] init];
    [_tagButton setImage:[UIImage imageNamed:@"xk_btn_collection_shixiao"] forState:0];
  }
  return _tagButton;
}
@end
