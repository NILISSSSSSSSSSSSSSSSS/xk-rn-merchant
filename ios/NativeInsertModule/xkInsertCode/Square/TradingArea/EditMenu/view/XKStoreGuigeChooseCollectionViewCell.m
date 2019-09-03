//
//  XKStoreGuigeChooseCollectionViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreGuigeChooseCollectionViewCell.h"


@interface XKStoreGuigeChooseCollectionViewCell ()

@property (nonatomic, strong) UILabel  *decLabel;

@end


@implementation XKStoreGuigeChooseCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        [self layoutViews];
    }
    
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.decLabel];

}


- (void)layoutViews {

    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(0);
        make.height.equalTo(@26);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView);
    }];
    
}


#pragma mark - Setters



- (UILabel *)decLabel {
    if (!_decLabel) {
        _decLabel = [[UILabel alloc] init];
        _decLabel.textAlignment = NSTextAlignmentCenter;
//        _decLabel.text = @"1000g";
        _decLabel.textColor = HEX_RGB(0x999999);
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _decLabel.layer.masksToBounds = YES;
        _decLabel.layer.cornerRadius = 13;
        _decLabel.layer.borderWidth = 1;
        _decLabel.layer.borderColor = HEX_RGB(0x999999).CGColor;
    }
    
    return _decLabel;
}

- (void)setTitleName:(NSString *)name {
    self.decLabel.text = name;

}


- (void)itemSeleced:(BOOL)selected {
    if (selected) {
        self.decLabel.textColor = XKMainTypeColor;
        self.decLabel.layer.borderColor = XKMainTypeColor.CGColor;
    } else {
        self.decLabel.textColor = HEX_RGB(0x999999);
        self.decLabel.layer.borderColor = HEX_RGB(0x999999).CGColor;
    }
}

@end
