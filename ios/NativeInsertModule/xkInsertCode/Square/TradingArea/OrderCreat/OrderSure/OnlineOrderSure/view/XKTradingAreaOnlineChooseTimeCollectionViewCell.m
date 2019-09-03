//
//  XKTradingAreaOnlineChooseTimeCollectionViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOnlineChooseTimeCollectionViewCell.h"


@interface XKTradingAreaOnlineChooseTimeCollectionViewCell ()

@property (nonatomic, strong) UILabel  *decLabel;

@end


@implementation XKTradingAreaOnlineChooseTimeCollectionViewCell


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
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _decLabel.layer.masksToBounds = YES;
        _decLabel.layer.cornerRadius = 3;
        _decLabel.textColor = HEX_RGB(0x999999);
        _decLabel.backgroundColor = HEX_RGB(0xF6F6F6);
        _decLabel.layer.borderColor = HEX_RGB(0xE5E5E5).CGColor;
        _decLabel.layer.borderWidth = 1;


    }
    
    return _decLabel;
}

- (void)setTitleName:(NSString *)name {
    self.decLabel.text = name;

}


- (void)itemSeleced:(BOOL)selected {
    if (selected) {
        self.decLabel.backgroundColor = XKMainTypeColor;
        self.decLabel.textColor = [UIColor whiteColor];
        self.decLabel.layer.borderColor = XKMainTypeColor.CGColor;
        self.decLabel.layer.borderWidth = 1;
    } else {

        self.decLabel.textColor = HEX_RGB(0x999999);
        self.decLabel.backgroundColor = HEX_RGB(0xF6F6F6);
        self.decLabel.layer.borderColor = HEX_RGB(0xE5E5E5).CGColor;
        self.decLabel.layer.borderWidth = 1;
    }
}

@end
