//
//  XKParmItemCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKParmItemCell.h"
@interface  XKParmItemCell ()
@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation XKParmItemCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
        self.layer.cornerRadius = 13.f;
        self.layer.borderWidth = 1;
        self.layer.borderColor = XKMainTypeColor.CGColor;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.titleLabel];
    
}

- (void)setUpDataWithItem:(XKMallGoodsDetailAttrValuesItem *)item {
    self.titleLabel.text = item.name;
    [self isChosed:item.selected];
}

- (void)addUIConstraint {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

- (void)setUpWithTtitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)isChosed:(BOOL)selected {
    if(selected) {
        self.layer.cornerRadius = 13.f;
        self.layer.borderWidth = 1;
        self.layer.borderColor = XKMainTypeColor.CGColor;
        self.layer.masksToBounds = YES;
        self.backgroundColor = XKMainTypeColor;
        self.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.layer.cornerRadius = 13.f;
        self.layer.borderWidth = 1;
        self.layer.borderColor = XKMainTypeColor.CGColor;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = XKMainTypeColor;
    }
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _titleLabel.textColor = XKMainTypeColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end
