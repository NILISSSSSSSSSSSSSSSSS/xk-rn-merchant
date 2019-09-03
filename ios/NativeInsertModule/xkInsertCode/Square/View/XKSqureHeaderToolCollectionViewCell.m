//
//  XKSqureHeaderToolCollectionViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/8/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureHeaderToolCollectionViewCell.h"


@interface XKSqureHeaderToolCollectionViewCell ()


@end


@implementation XKSqureHeaderToolCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        [self layoutViews];
    }
    
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
}


- (void)layoutViews {
    
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10*ScreenScale);
        make.centerX.equalTo(self.contentView);
        make.height.width.equalTo(@(40*ScreenScale));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(5*ScreenScale);
        make.centerX.equalTo(self.contentView);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}


#pragma mark - Setters

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
    }
    
    return _nameLabel;
}


- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.cornerRadius = 20*ScreenScale;
        _imgView.layer.masksToBounds = YES;
//        _imgView.backgroundColor = [UIColor greenColor];
    }
    return _imgView;
}



- (void)setTitle:(NSString *)title iconName:(NSString *)iconName {
    self.nameLabel.text = title;
    self.imgView.image = [UIImage imageNamed:iconName];
    
}

- (void)setTitle:(NSString *)title iconUrl:(NSString *)url {
    self.nameLabel.text = title;
    [self.imgView sd_setImageWithURL:kURL(url) placeholderImage:kDefaultPlaceHolderImg];
}


@end
