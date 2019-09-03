//
//  XKSqureVideoOfConcernedCollectionCell.m
//  XKSquare
//
//  Created by hupan on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureVideoOfConcernedCollectionCell.h"


@interface XKSqureVideoOfConcernedCollectionCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIButton    *adrButton;


@end


@implementation XKSqureVideoOfConcernedCollectionCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        [self layoutViews];
    }
    
    return self;
}

- (void)initViews {

    [self.contentView addSubview:self.imgView];
    [self.imgView addSubview:self.nameLabel];
    [self.imgView addSubview:self.adrButton];
}


- (void)layoutViews {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 5, 5, 5));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgView).offset(-10);
        make.left.equalTo(self.imgView).offset(5);
        make.right.equalTo(self.adrButton.mas_left).offset(-5);
    }];
    
    [self.adrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}


#pragma mark - Setters


- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 5;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgView;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"oolkg超出南皇";
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:12];
    }
    
    return _nameLabel;
}

- (UIButton *)adrButton {
    
    if (!_adrButton) {
        _adrButton = [[UIButton alloc] init];
        [_adrButton setImage:[UIImage imageNamed:@"xk_iocn_squrea_address_white"] forState:UIControlStateNormal];
        [_adrButton setTitle:@"成都" forState:UIControlStateNormal];
        [_adrButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _adrButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
    }
    return _adrButton;
}


- (void)setValueWithName:(NSString *)name address:(NSString *)address imgUrl:(NSString *)imgUrl {
    self.nameLabel.text = name;
    [self.adrButton setTitle:address forState:UIControlStateNormal];
    [self.imgView sd_setImageWithURL:kURL(imgUrl) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];
}

@end
