//
//  XKGroupChatManageAddBottomView.m
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/27.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKGroupChatManageAddBottomView.h"
@interface XKGroupChatManageAddBottomView ()
/**全选/反选*/


/**确定*/
@property (nonatomic, strong)UIButton *sureBtn;

@end

@implementation XKGroupChatManageAddBottomView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if(self) {
    self.backgroundColor = [UIColor whiteColor];
    [self addCustomSubviews];
    [self addUIConstraint];
  }
  return self;
}

- (void)addCustomSubviews {

  [self addSubview:self.choseBtn];
  [self addSubview:self.sureBtn];

}

- (void)addUIConstraint {
  
  [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.equalTo(self);
    make.bottom.equalTo(self.mas_bottom);
    make.width.mas_equalTo(80);
  }];
  
  [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self);
    make.height.mas_equalTo(50);
    make.bottom.equalTo(self.mas_bottom);
    make.width.mas_equalTo(105);
  }];

}

- (void)choseBtnClick:(UIButton *)sender {
  sender.selected = !sender.selected;
  if (self.allChoseBlock) {
      self.allChoseBlock(sender);
  }
}

- (void)sureBtnClick:(UIButton *)sender {
  if (self.sureBlock) {
    self.sureBlock(sender);
  }
}

- (UIButton *)choseBtn {
  if(!_choseBtn) {
    _choseBtn = [[UIButton alloc] init];
    [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
    [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
    _choseBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 23, 0, 15);
    _choseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [_choseBtn setTitle:@"全选" forState:0];
    [_choseBtn setTitle:@"全选" forState:UIControlStateSelected];
    _choseBtn.titleLabel.font = XKRegularFont(14);
    [_choseBtn addTarget:self action:@selector(choseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_choseBtn setTitleColor:UIColorFromRGB(0x777777) forState:0];
    [_choseBtn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateSelected];
  }
  return _choseBtn;
}

- (UIButton *)sureBtn {
  if(!_sureBtn) {
    _sureBtn = [[UIButton alloc] init];
    [_sureBtn setTitle:@"确定" forState:0];
    _sureBtn.titleLabel.font = XKRegularFont(17);
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_sureBtn setBackgroundColor:XKMainTypeColor];
    [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _sureBtn;
}

@end
