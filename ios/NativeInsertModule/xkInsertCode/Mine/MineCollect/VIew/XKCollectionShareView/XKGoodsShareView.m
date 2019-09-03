//
//  XKGoodsShareView.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/23.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGoodsShareView.h"
@interface XKGoodsShareView ()
@property (nonatomic, strong)UILabel     *monthCountLabel;
@property (nonatomic, strong)UILabel     *piceLabel;
@end
@implementation XKGoodsShareView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self creatUI];
  }
  return self;
}
- (void)setModel:(XKCollectGoodsDataItem *)model {
  _model = model;
  [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.target.showPics] placeholderImage:kDefaultPlaceHolderImg];
  self.nameLabel.text = model.target.name;
  NSString *mouthVolumeStr = @"";
  if (model.target.mouthVolume > 10000) {
    mouthVolumeStr = [NSString stringWithFormat:@"销售量：%ldw",model.target.mouthVolume/10000];
  }else{
    mouthVolumeStr = [NSString stringWithFormat:@"销售量：%ld",model.target.mouthVolume];
  }
  _monthCountLabel.text = mouthVolumeStr;
  NSString *status = [NSString stringWithFormat:@"￥%.2f",model.target.buyPrice.floatValue / 100.0];
  NSString *statusStr = [NSString stringWithFormat:@"价格：%@",status];
  NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:statusStr];
  [attrString addAttribute:NSForegroundColorAttributeName
                     value:UIColorFromRGB(0xee6161)
                     range:NSMakeRange(4, statusStr.length - 4)];
  NSString *dataString = [NSString stringWithFormat:@"xkgc://commodity_detail?commodity_id=%@&userId=%@",model.target.targetId,[XKUserInfo getCurrentUserId]];
  [self.iconImgView createShareQRImageWithQRString:dataString correctionLevel:@"L"];
  _piceLabel.attributedText = attrString;
}
- (void)creatUI {
  [super creatUI];
  [self.bottomView addSubview:self.monthCountLabel];
  [self.bottomView addSubview:self.piceLabel];
  [self.monthCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.bottomView).offset(20);
    make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    make.right.equalTo(self.iconImgView.mas_left).offset(-10);
  }];
  
  [self.piceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.bottomView).offset(20);
    make.top.equalTo(self.monthCountLabel.mas_bottom).offset(2);
    make.right.equalTo(self.iconImgView.mas_left).offset(-10);
  }];
  
}

- (UILabel *)monthCountLabel {
  if(!_monthCountLabel) {
    _monthCountLabel = [[UILabel alloc] init];
    [_monthCountLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
    _monthCountLabel.textColor = UIColorFromRGB(0x555555);
    _monthCountLabel.text = @"销售量:12.5w";
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
@end
