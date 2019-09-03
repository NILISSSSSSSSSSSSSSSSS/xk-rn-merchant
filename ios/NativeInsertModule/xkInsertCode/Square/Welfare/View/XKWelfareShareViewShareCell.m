//
//  XKWelfareShareViewShareCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareShareViewShareCell.h"
@interface XKWelfareShareViewShareCell ()
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@end
@implementation XKWelfareShareViewShareCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLabel];
}

- (void)addUIConstraint {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(10 * SCREEN_WIDTH / 375);
        make.size.mas_equalTo(CGSizeMake(40 * SCREEN_WIDTH / 375, 40 * SCREEN_WIDTH / 375));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.iconImgView.mas_bottom).offset(5 * SCREEN_WIDTH / 375);
    }];
}

- (void)updateItemName:(NSString *)name AndIconName:(NSString *)iconName {
    _iconImgView.image = [UIImage imageNamed:iconName];
    _nameLabel.text = name;
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorFromRGB(0x777777);
        _nameLabel.font =  [UIFont fontWithName:XK_PingFangSC_Regular size:10];
        _nameLabel.text = @"我的朋友";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
@end
