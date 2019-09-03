//
//  XKStoreInfoCollectionCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreInfoCollectionCell.h"


@interface XKStoreInfoCollectionCell ()

@property (nonatomic, strong) UIImageView *imgView;

@end


@implementation XKStoreInfoCollectionCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        [self layoutViews];
    }
    
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.imgView];
}


- (void)layoutViews {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.height.equalTo(self.imgView.mas_width);
    }];

}

- (void)updataViewsWithNOMargin {
    [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 5, 0));
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

- (void)setImgViewWithImgUrl:(NSString *)imgUrl {
    
    [self.imgView sd_setImageWithURL:kURL(imgUrl) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];

}


@end
