//
//  XKCustomerSerHistoryConsultationFooterView.m
//  xkMerchant
//
//  Created by xudehuai on 2019/2/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "XKCustomerSerHistoryConsultationFooterView.h"

@interface XKCustomerSerHistoryConsultationFooterView ()

@end

@implementation XKCustomerSerHistoryConsultationFooterView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.timeView = [[UIView alloc] init];
    self.timeView.backgroundColor = HEX_RGB(0xFFFFFF);
    [self addSubview:self.timeView];
    self.timeView.xk_radius = 8.0;
    self.timeView.xk_clipType = XKCornerClipTypeAllCorners;
    self.timeView.xk_openClip = YES;
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.text = @"结束时间";
    self.timeLab.font = XKRegularFont(10.0);
    self.timeLab.textColor = HEX_RGB(0x777777);
    [self.timeView addSubview:self.timeLab];
    
    self.finishLab = [[UILabel alloc] init];
    self.finishLab.text = @"对话已结束!";
    self.finishLab.font = XKRegularFont(12.0);
    self.finishLab.textColor = HEX_RGB(0x777777);
    [self addSubview:self.finishLab];
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(15.0);
      make.centerX.mas_equalTo(self);
      make.height.mas_equalTo(20.0);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
    }];
    
    [self.finishLab mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self.timeView.mas_bottom).offset(10.0);
      make.centerX.mas_equalTo(self);
    }];
    
  }
  return self;
}

@end
