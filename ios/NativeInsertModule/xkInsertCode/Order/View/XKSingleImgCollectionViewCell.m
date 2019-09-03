//
//  XKSingleImgCollectionViewCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSingleImgCollectionViewCell.h"
@interface XKSingleImgCollectionViewCell ()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel  *exitLabel;
@end
@implementation XKSingleImgCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 6.f;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = XKSeparatorLineColor.CGColor;
        self.layer.borderWidth = 1.f;
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.exitLabel];
}

- (void)bindItem:(MallOrderListObj *)obj {
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:obj.goodsPic] placeholderImage:kDefaultPlaceHolderImg];
    if (obj.refundId) {
        _exitLabel.hidden = NO;
    } else {
         _exitLabel.hidden = YES;
    }
}

- (void)setImageWithImgUrl:(NSString *)url {
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kDefaultPlaceHolderImg];
}

- (void)addUIConstraint {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.contentView);
    }];
    
    [self.exitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.iconImgView);
        make.size.mas_equalTo(CGSizeMake(40, 16));
    }];
    _exitLabel.hidden = YES;
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.image = kDefaultPlaceHolderImg;

    }
    return _iconImgView;
}

- (UILabel *)exitLabel {
    if(!_exitLabel) {
        _exitLabel = [[UILabel alloc] init];
        _exitLabel.textColor = [UIColor whiteColor];
        _exitLabel.backgroundColor = XKMainTypeColor;
        _exitLabel.textAlignment = NSTextAlignmentCenter;
        _exitLabel.xk_openClip = YES;
        _exitLabel.xk_radius = 6.f;
        _exitLabel.text = @"退款中";
        _exitLabel.font = [UIFont systemFontOfSize:10];
        _exitLabel.xk_clipType = XKCornerClipTypeTopRight | XKCornerClipTypeBottomLeft;
    }
    return _exitLabel;
}
@end
