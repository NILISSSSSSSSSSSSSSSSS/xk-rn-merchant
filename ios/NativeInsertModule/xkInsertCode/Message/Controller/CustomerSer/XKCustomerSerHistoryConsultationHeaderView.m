//
//  XKCustomerSerHistoryConsultationHeaderView.m
//  xkMerchant
//
//  Created by xudehuai on 2019/2/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "XKCustomerSerHistoryConsultationHeaderView.h"

@interface XKCustomerSerHistoryConsultationHeaderView ()

@end

@implementation XKCustomerSerHistoryConsultationHeaderView

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
    self.timeLab.text = @"开始时间";
    self.timeLab.font = XKRegularFont(10.0);
    self.timeLab.textColor = HEX_RGB(0x777777);
    [self.timeView addSubview:self.timeLab];
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.mas_equalTo(self);
      make.height.mas_equalTo(20.0);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
    }];
  }
  return self;
}

@end
