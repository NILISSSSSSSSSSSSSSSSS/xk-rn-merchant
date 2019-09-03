//
//  XKOfficialGroupChatDisableSendMsgTableViewCell.m
//  xkMerchant
//
//  Created by RyanYuan on 2018/12/25.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKOfficialGroupChatDisableSendMsgTableViewCell.h"

@interface XKOfficialGroupChatDisableSendMsgTableViewCell ()

@property (nonatomic, strong) NSMutableDictionary *timeDict;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *customTimeLabel;
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation XKOfficialGroupChatDisableSendMsgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    // 点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelectButton:)];
    [self.contentView addGestureRecognizer:tap];
    
    // 选择按钮
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(clickSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.contentView.mas_left).offset(10 * ScreenScale);
      make.centerY.equalTo(self.contentView.mas_centerY);
      make.width.height.equalTo(@20);
    }];
    self.selectButton = selectButton;
    
    // 时间标签
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.font = XKFont(XK_PingFangSC_Regular, 14);
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(selectButton.mas_right).offset(10);
      make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    self.titleLabel = titleLabel;
    
    // 自定义时间标签
    UILabel *customTimeLabel = [UILabel new];
    customTimeLabel.textColor = [UIColor lightGrayColor];
    customTimeLabel.font = XKFont(XK_PingFangSC_Regular, 14);
    [self.contentView addSubview:customTimeLabel];
    [customTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.contentView.mas_right).offset(-10);
      make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    self.customTimeLabel = customTimeLabel;
    
    // 分割线
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = XKSeparatorLineColor;
    [self.contentView addSubview:separatorView];
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(self.contentView.mas_bottom);
      make.left.equalTo(self.contentView.mas_left);
      make.right.equalTo(self.contentView.mas_right);
      make.height.mas_equalTo(1);
    }];
    self.separatorView = separatorView;
  }
  return self;
}

- (void)configTableViewCellWithDictionary:(NSMutableDictionary *)dict {
  
  self.timeDict = dict;
  
  NSString *title = dict[@"title"];
  if (title && title.length > 0) {
    self.titleLabel.text = dict[@"title"];
  }
  
  NSString *isSelected = dict[@"isSelected"];
  if (isSelected && isSelected.length > 0) {
    self.selectButton.selected = isSelected.boolValue;
  }
}

- (void)configTableViewCellWithCustomTimeString:(NSString *)customTimeString {
  
  if (customTimeString && customTimeString.length > 0) {
    self.customTimeLabel.text = customTimeString;
  }
}

- (void)clickSelectButton:(UIControl *)sender {
  
//  NSString *isSelected = self.timeDict[@"isSelected"];
//  NSInteger isSelectedInteger = isSelected.intValue;
//  isSelectedInteger = 1 - isSelectedInteger;
//  self.timeDict[@"isSelected"] = [NSString stringWithFormat:@"%@", @(isSelectedInteger)];
  
  self.timeDict[@"isSelected"] = @"1";
  
  if ([self.delegate respondsToSelector:@selector(tableViewCell:selectedTime:)]) {
    [self.delegate tableViewCell:self selectedTime:self.timeDict];
  }
}

- (void)showCellSeparator {
  self.separatorView.hidden = NO;
}

- (void)hiddenCellSeparator {
  self.separatorView.hidden = YES;
}

- (void)showCustomTimeLabel {
  self.customTimeLabel.hidden = NO;
}

- (void)hiddenCustomTimeLabel {
  self.customTimeLabel.hidden = YES;
}

@end

