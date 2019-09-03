//
//  XKOfficialGroupChatListViewTableViewCell.m
//  xkMerchant
//
//  Created by RyanYuan on 2019/1/25.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "XKOfficialGroupChatListViewTableViewCell.h"
#import "XKOfficialGroupChatListModel.h"

@interface XKOfficialGroupChatListViewTableViewCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation XKOfficialGroupChatListViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.backgroundColor = [UIColor clearColor];
  [self initializeSubviews];
  return self;
}

- (void)configOfficialGroupChatListCellWithModel:(XKOfficialGroupChatListModel *)model {
  
}

- (void)showCellSeparator {
  self.separatorView.hidden = NO;
}

- (void)clipTopCornerRadius {
  
  self.containerView.xk_openClip = YES;
  self.containerView.xk_radius = 6;
  self.containerView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
}

- (void)clipBottomCornerRadius {
  
  self.containerView.xk_openClip = YES;
  self.containerView.xk_radius = 6;
  self.containerView.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
}

- (void)initializeSubviews {
  
  [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.contentView);
  }];
  
  [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.contentView.mas_bottom);
    make.left.equalTo(self.contentView.mas_left);
    make.right.equalTo(self.contentView.mas_right);
    make.height.mas_equalTo(1);
  }];
}

- (UIView *)containerView {
  
  if (!_containerView) {
    _containerView = [UIView new];
    _containerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_containerView];
  }
  return _containerView;
}

- (UIView *)separatorView {
  
  if (!_separatorView) {
    _separatorView = [UIView new];
    _separatorView.backgroundColor = XKSeparatorLineColor;
    [self.containerView addSubview:_separatorView];
  }
  return _separatorView;
}

@end
