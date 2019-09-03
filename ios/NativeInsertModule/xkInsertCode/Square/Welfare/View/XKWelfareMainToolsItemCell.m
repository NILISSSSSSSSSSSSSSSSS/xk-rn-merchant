//
//  XKWelfareMainToolsItemCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/23.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfareMainToolsItemCell.h"

@interface XKWelfareMainToolsItemCell ()


@end


@implementation XKWelfareMainToolsItemCell


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
        make.top.equalTo(self.contentView).offset((SCREEN_WIDTH - 60 * ScreenScale) / 4 * 15 / 78);
        make.centerX.equalTo(self.contentView);
        make.height.width.equalTo(@((SCREEN_WIDTH - 60 * ScreenScale) / 4 * 40 / 78));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset((SCREEN_WIDTH - 60 * ScreenScale) / 4 * 5 / 78 * ScreenScale);
        make.centerX.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
    }];
}


#pragma mark - Setters

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = XKRegularFont(12);
    }
    
    return _nameLabel;
}


- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.cornerRadius = (SCREEN_WIDTH - 60 * ScreenScale) / 4 * 20 / 78;
        _imgView.layer.masksToBounds = YES;

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
