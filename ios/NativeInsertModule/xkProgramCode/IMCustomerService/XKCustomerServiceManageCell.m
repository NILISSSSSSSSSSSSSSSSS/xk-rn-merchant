//
//  XKCustomerServiceManageCell.m
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/19.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKCustomerServiceManageCell.h"

@interface XKCustomerServiceManageCell ()
@property (nonatomic, strong)UIButton    *choseBtn;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel     *nameLabel;

@end
@implementation XKCustomerServiceManageCell

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

  
  [_iconImgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:kDefaultPlaceHolderImg];
  _nameLabel.text = @"名字";

}

- (void)addUIConstraint {
  [self.bgContainView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView.mas_left).offset(10);
    make.right.equalTo(self.contentView.mas_right).offset(-10);
    make.top.bottom.equalTo(self.contentView);
  }];
  
  [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.bottom.equalTo(self.bgContainView);
    make.width.mas_equalTo(40 * ScreenScale);
  }];
  
  [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.choseBtn.mas_right);
    make.size.mas_equalTo(CGSizeMake(44 * ScreenScale, 44 * ScreenScale));
    make.centerY.equalTo(self.bgContainView);
  }];
  
  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.iconImgView.mas_right).offset(15 * ScreenScale);
    make.centerY.equalTo(self.bgContainView);
    make.right.lessThanOrEqualTo(self.bgContainView.mas_right).offset(-15 * ScreenScale);
  }];
  
}

- (void)managerModel:(BOOL)isManage {
  if (isManage) {
    [self.choseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.top.bottom.equalTo(self.bgContainView);
      make.width.mas_equalTo(0 * ScreenScale);
    }];
  }
}

- (void)choseAction:(UIButton *)sender {
  //  self.model.isSelected = !self.model.isSelected;
  //  if (self.block) {
  //    self.block();
  //  }
}

- (void)setUser:(XKContactModel *)user {
  _user = user;
  [self.iconImgView sd_setImageWithURL:kURL(user.avatar) placeholderImage:kDefaultHeadImg];
  self.nameLabel.text = user.nickname;
  self.choseBtn.selected = user.selected;
}

#pragma mark 懒加载
- (UIButton *)choseBtn {
  if(!_choseBtn) {
    _choseBtn = [[UIButton alloc] init];
    _choseBtn.userInteractionEnabled = NO;
    [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
    [_choseBtn addTarget:self action:@selector(choseAction:) forControlEvents:UIControlEventTouchUpInside];
    [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
  }
  return _choseBtn;
}

- (UIImageView *)iconImgView {
  if(!_iconImgView) {
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImgView.clipsToBounds = YES;
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



@end
