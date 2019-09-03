//
//  XKMallTypeCollectionReusableView.m
//  XKSquare
//
//  Created by hupan on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallTypeCollectionReusableView.h"

@interface XKMallTypeCollectionReusableView ()

@property (nonatomic, strong) UILabel *nameLabel;


@end

@implementation XKMallTypeCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        [self addSubviews];
        [self layoutAllSubviews];

    }
    return self;
}


- (void)addSubviews {
    [self addSubview:self.nameLabel];
}

- (void)layoutAllSubviews {
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.lessThanOrEqualTo(self).offset(-5);
        make.centerY.equalTo(self);
    }];
    
}

- (void)setTitleWithTitleStr:(NSString *)titleStr titleColor:(UIColor *)color font:(UIFont *)font {
    self.nameLabel.text = titleStr;
    if (color) {
        self.nameLabel.textColor = color;
    }
    if (font) {
        self.nameLabel.font = font;
    }
}
#pragma mark - getter && stter

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEX_RGB(0x777777);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
    }
    return _nameLabel;
}

- (void)titleTextAlignmentBotton {
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.lessThanOrEqualTo(self).offset(-5);
        make.bottom.equalTo(self);
    }];
}

- (void)titleTextAlignmentLeft:(CGFloat)leftMargin {
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(leftMargin);
    }];
}

@end
