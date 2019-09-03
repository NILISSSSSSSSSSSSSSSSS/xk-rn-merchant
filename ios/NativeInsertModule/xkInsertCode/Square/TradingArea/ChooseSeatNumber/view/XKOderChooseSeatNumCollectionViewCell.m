//
//  XKOderChooseSeatNumCollectionViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOderChooseSeatNumCollectionViewCell.h"
#import "XKHotspotButton.h"
#import "XKTradingAreaSeatListModel.h"


@interface XKOderChooseSeatNumCollectionViewCell ()

@property (nonatomic, strong) UIView             *backView;
@property (nonatomic, strong) UILabel            *nameLabel;
@property (nonatomic, strong) UIImageView        *imgView;
@property (nonatomic, strong) UILabel            *tipLabel;


@end


@implementation XKOderChooseSeatNumCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initViews];
        [self layoutViews];
    }
    
    return self;
}

- (void)initViews {
    
    [self.contentView addSubview:self.backView];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.tipLabel];
}


- (void)layoutViews {
    
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(5);
        make.bottom.right.equalTo(self.contentView).offset(-5);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(2);
        make.right.equalTo(self.contentView).offset(-2);
        make.height.width.equalTo(@12);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView).offset(10);
        make.center.equalTo(self.contentView);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.width.equalTo(@30);
        make.height.equalTo(@14);
        make.centerX.equalTo(self.contentView);
    }];
    
}


- (void)setValueWithModel:(XKTradingAreaSeatListModel *)model {
    
    if (model.images.count) {
        self.tipLabel.hidden = NO;
    } else {
        self.tipLabel.hidden = YES;
    }
    self.nameLabel.text = model.name;
    
    if (model.isSelected) {
        self.imgView.hidden = NO;
        [self.backView drawShadowPathWithShadowColor:XKMainTypeColor shadowOpacity:0.2 shadowRadius:5.0 shadowPathWidth:2.0 shadowOffset:CGSizeMake(0,1)];
    } else {
        self.imgView.hidden = YES;
        [self.backView drawShadowPathWithShadowColor:HEX_RGB(0x000000) shadowOpacity:0.2 shadowRadius:5.0 shadowPathWidth:2.0 shadowOffset:CGSizeMake(0,1)];
    }
}

#pragma mark - Setters


- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"xk_ic_contact_chose"];
        
    }
    return _imgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 2;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
//        _nameLabel.text = @"A1";
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _nameLabel;
}


- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.layer.masksToBounds = YES;
        _tipLabel.layer.cornerRadius = 7;
        _tipLabel.text = @"有图";
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.backgroundColor = XKMainTypeColor;
        _tipLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
    }
    return _tipLabel;
}

@end
