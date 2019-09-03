//
//  XKSqureStoreCollectionViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/8/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureStoreCollectionViewCell.h"


@interface XKSqureStoreCollectionViewCell ()

@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *decLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView      *lineView;


@end


@implementation XKSqureStoreCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        [self layoutViews];
    }
    
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.decLabel];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.lineView];
}


- (void)layoutViews {
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);

    }];
    
    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.decLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-12);

    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(13);
        make.bottom.equalTo(self.contentView).offset(-10);

    }];
}


#pragma mark - Setters

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
//        _nameLabel.text = @"超出南皇";
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    
    return _nameLabel;
}


- (UILabel *)decLabel {
    if (!_decLabel) {
        _decLabel = [[UILabel alloc] init];
        _decLabel.textAlignment = NSTextAlignmentCenter;
//        _decLabel.text = @"测试测试手册测试";
        _decLabel.textColor = HEX_RGB(0x777777);
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
    }
    
    return _decLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
//        _imgView.backgroundColor = [UIColor greenColor];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
//        [_imgView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538047861638&di=868dd2f924e8f80a811ef302ad7722fd&imgtype=0&src=http%3A%2F%2Fpic33.photophoto.cn%2F20141028%2F0038038006886895_b.jpg"]];
    }
    return _imgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}

- (void)setName:(NSString *)name dec:(NSString *)dec imgUrl:(NSString *)ingUrl {
    self.nameLabel.text = name;
    self.decLabel.text = dec;
    [self.imgView sd_setImageWithURL:kURL(ingUrl) placeholderImage:IMG_NAME(kDefaultPlaceHolderRectImgName)];
}

- (void)hiddenLineView:(BOOL)hidden {
    self.lineView.hidden = hidden;
}


@end
