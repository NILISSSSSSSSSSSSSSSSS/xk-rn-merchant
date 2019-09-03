//
//  XKIMSDKChatToolCollectionViewCell.m
//  xkMerchant
//
//  Created by xudehuai on 2019/3/1.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "XKIMSDKChatToolCollectionViewCell.h"

@interface XKIMSDKChatToolCollectionViewCell ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation XKIMSDKChatToolCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self initializeViews];
    [self updateViews];
  }
  return self;
}

- (void)initializeViews {
  self.containerView = [[UIView alloc] init];
  [self.contentView addSubview:self.containerView];
  
  self.imgView = [[UIImageView alloc] init];
  [self.containerView addSubview:self.imgView];
  
  self.titleLab = [[UILabel alloc] init];
  self.titleLab.textAlignment = NSTextAlignmentCenter;
  [self.containerView addSubview:self.titleLab];
}

- (void)updateViews {
  [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.mas_equalTo(self.contentView);
  }];
  
  [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.leading.trailing.mas_equalTo(self.containerView);
    make.width.height.mas_equalTo(60.0);
  }];
  
  [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.imgView.mas_bottom).offset(5.0);
    make.leading.trailing.mas_equalTo(self.containerView);
    make.bottom.mas_equalTo(self.containerView);
  }];
}

- (void)configCellWithImg:(NSString *)img
                    title:(NSString *)title
                    space:(CGFloat)space
                     font:(UIFont *)font
               titleColor:(UIColor *)titleColor {
  self.imgView.image = [UIImage imageNamed:img];
  self.titleLab.text = title;
  [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.imgView.mas_bottom).offset(space);
  }];
  self.titleLab.font = font;
  self.titleLab.textColor = titleColor;
}

@end
