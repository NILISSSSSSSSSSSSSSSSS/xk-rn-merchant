//
//  XKMallTypeCollectionViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallTypeCollectionViewCell.h"


@interface XKMallTypeCollectionViewCell ()

@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIImageView *imgView;

@end


@implementation XKMallTypeCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
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
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-30);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(10);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}


#pragma mark - Setters

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = HEX_RGB(0x555555);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
    }
    return _nameLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

- (void)setTitle:(NSString *)title iconName:(NSString *)iconName urlStr:(NSString *)urlStr{
    _nameLabel.text = title;
    if(urlStr) {
       [_imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:kDefaultPlaceHolderImg];
    } else if(iconName) {
        _imgView.image = [UIImage imageNamed:iconName];
    }
}

@end
