//
//  XKStoreTakeoutCollectionCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreTakeoutCollectionCell.h"
#import "XKTradingAreaShopInfoModel.h"

@interface XKStoreTakeoutCollectionCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *nameLabel;


@end


@implementation XKStoreTakeoutCollectionCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        [self layoutViews];
    }
    
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.imgView];
}


- (void)layoutViews {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.height.equalTo(self.imgView.mas_width);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(5);
        make.left.equalTo(self.imgView.mas_left);
        make.right.equalTo(self.contentView);
    }];

}


#pragma mark - Setters

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
//        [_imgView sd_setImageWithURL:[NSURL URLWithString:@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"]];
    }
    return _imgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.text = @"鲜牛肉";
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
    }
    
    return _nameLabel;
}


- (void)setValueWithModel:(ATShopGoodsItem *)model {
    
    [self.imgView sd_setImageWithURL:kURL(model.mainPic) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];
    self.nameLabel.text = model.goodsName;
}


@end
