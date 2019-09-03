//
//  XKCustomServiceGoodsCell.m
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/19.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKCustomServiceGoodsCell.h"
@interface XKCustomServiceGoodsCell ()
@property (nonatomic, strong)UIButton    *shareButton;
@property (nonatomic, strong)UIButton    *choseBtn;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *monthCountLabel;
@property (nonatomic, strong)UILabel     *piceLabel;
@property (nonatomic, strong)UIView      *segmengView;
@property (nonatomic, strong)UIButton    *detailBtn;
@end
@implementation XKCustomServiceGoodsCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self createUI];
    [self addUIConstraint];
  }
  return self;
}
- (void)createUI {
  
  [self addCustomSubviews];
}
- (void)addCustomSubviews {
  [self.contentView addSubview:self.bgContainView];
  [self.bgContainView addSubview:self.choseBtn];
  [self.bgContainView addSubview:self.iconImgView];
  [self.bgContainView addSubview:self.nameLabel];
  [self.bgContainView addSubview:self.monthCountLabel];
  [self.bgContainView addSubview:self.piceLabel];
  [self.bgContainView addSubview:self.segmengView];
  [self.bgContainView addSubview:self.shareButton];
  [self.bgContainView addSubview:self.detailBtn];
  
  [_iconImgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:kDefaultPlaceHolderImg];
  _nameLabel.text = @"名字";
  _monthCountLabel.text = @"规格";
  _piceLabel.text = @"价格";
}

/*
- (void)setModel:(XKCollectGoodsDataItem *)model {
  _model = model;
  [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.target.showPics] placeholderImage:kDefaultPlaceHolderImg];
  _nameLabel.text = model.target.name;
  NSString *mouthVolumeStr = @"";
  if (model.target.mouthVolume > 10000) {
    mouthVolumeStr = [NSString stringWithFormat:@"月销量：%ldw",model.target.mouthVolume/10000];
  }else{
    mouthVolumeStr = [NSString stringWithFormat:@"月销量：%ld",model.target.mouthVolume];
  }
  _monthCountLabel.text = mouthVolumeStr;
  NSString *status = [NSString stringWithFormat:@"￥%ld",model.target.price/100];
  NSString *statusStr = [NSString stringWithFormat:@"价格：%@",status];
  NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:statusStr];
  [attrString addAttribute:NSForegroundColorAttributeName
                     value:UIColorFromRGB(0xee6161)
                     range:NSMakeRange(4, statusStr.length - 4)];
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
}
 */
- (void)addUIConstraint {
  [self.bgContainView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView.mas_left).offset(0);
    make.right.equalTo(self.contentView.mas_right).offset(0);
    make.top.bottom.equalTo(self.contentView);
  }];
  
  [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.bottom.equalTo(self.bgContainView);
    make.width.mas_equalTo(40 * ScreenScale);
  }];
  
  [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.choseBtn.mas_right);
    make.size.mas_equalTo(CGSizeMake(68 * ScreenScale, 68 * ScreenScale));
    make.centerY.equalTo(self.bgContainView);
  }];
  
  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.iconImgView.mas_right).offset(15 * ScreenScale);
    make.top.equalTo(self.iconImgView.mas_top);
    make.right.equalTo(self.bgContainView.mas_right).offset(-15 * ScreenScale);
  }];
  
  [self.monthCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.iconImgView.mas_right).offset(15 * ScreenScale);
    make.top.equalTo(self.nameLabel.mas_bottom).offset(10 * ScreenScale);
    make.right.equalTo(self.nameLabel);
  }];
  
  [self.piceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.iconImgView.mas_right).offset(15 * ScreenScale);
    make.top.equalTo(self.monthCountLabel.mas_bottom).offset(3);
    make.right.equalTo(self.nameLabel);
  }];
  
  [self.segmengView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.left.right.equalTo(self.bgContainView);
    make.height.mas_equalTo(1);
  }];
  [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.piceLabel);
    make.right.equalTo(@(-20 * ScreenScale));
    make.width.height.equalTo(@(20 * ScreenScale));
  }];
  
  [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.mas_equalTo(self.iconImgView.mas_bottom);
    make.right.equalTo(@(-20 * ScreenScale));
    make.size.mas_equalTo(CGSizeMake(75, 24));
  }];
}
- (void)updateLayout {
  self.choseBtn.hidden = NO;
  [self.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.bgContainView.mas_left).offset(40 * ScreenScale);
  }];
}

- (void)restoreLayout {
  self.choseBtn.hidden = YES;
  [self.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.bgContainView.mas_left).offset(15 * ScreenScale);
  }];
}

- (void)choseAction:(UIButton *)sender {
//  self.model.isSelected = !self.model.isSelected;
//  if (self.block) {
//    self.block();
//  }
}

- (void)sendChoseAction:(UIButton *)sender {
//  self.model.isSendSelected = !self.model.isSendSelected;
//  if (self.sendChoseblock) {
//    self.sendChoseblock(self.model);
//  }
}

- (void)detailBtnClick:(UIButton *)sender {
  
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

- (UIImageView *)iconImgView {
  if(!_iconImgView) {
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImgView.layer.borderWidth = 1.f;
    _iconImgView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    _iconImgView.layer.cornerRadius = 5.f;
    
  }
  return _iconImgView;
}

- (UILabel *)nameLabel {
  if(!_nameLabel) {
    _nameLabel = [[UILabel alloc] init];
    [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
    _nameLabel.textColor = UIColorFromRGB(0x222222);
    _nameLabel.numberOfLines = 2;
    _nameLabel.text = @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
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
    NSString *status = @"￥284";
    NSString *statusStr = [NSString stringWithFormat:@"价格：%@",status];
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

- (UIButton *)detailBtn {
  if (!_detailBtn) {
    _detailBtn = [[UIButton alloc]init];
    [_detailBtn setTitle:@"查看详情" forState:0];
    [_detailBtn setTitleColor:XKMainTypeColor forState:0];
    _detailBtn.titleLabel.font = XKRegularFont(13);
    _detailBtn.layer.borderWidth = 1.f;
    _detailBtn.layer.masksToBounds = YES;
    _detailBtn.layer.borderColor = XKMainTypeColor.CGColor;
    _detailBtn.layer.cornerRadius = 12;
    [_detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _detailBtn;
}
@end
