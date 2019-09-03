//
//  XKMineMainViewStoreCollectionViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineMainViewStoreCollectionViewCell.h"
#import "UIView+XKCornerRadius.h"
#import "XKWelfareGoodsListViewModel.h"

@interface XKMineMainViewStoreCollectionViewCell ()

@property (nonatomic, strong) UIImageView *merchPicImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation XKMineMainViewStoreCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    
    UIControl *control = [UIControl new];
    control.backgroundColor = [UIColor whiteColor];
    control.frame = self.contentView.frame;
    [self.contentView addSubview:control];
    
    UIView *imageBackgroundView = [UIView new];
    imageBackgroundView.xk_openClip = YES;
    imageBackgroundView.xk_radius = 5;
    imageBackgroundView.xk_clipType = XKCornerClipTypeAllCorners;
    imageBackgroundView.backgroundColor = HEX_RGB(0xF6F6F6);
    [self.contentView addSubview:imageBackgroundView];
    [imageBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.height.equalTo(@(80));
    }];
    
    UIImageView *merchPicImageView = [UIImageView new];
    merchPicImageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageBackgroundView addSubview:merchPicImageView];
    [merchPicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageBackgroundView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    self.merchPicImageView = merchPicImageView;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageBackgroundView.mas_bottom);
        make.left.equalTo(imageBackgroundView.mas_left);
        make.right.equalTo(imageBackgroundView.mas_right);
    }];
    self.titleLabel = titleLabel;
    
    UILabel *priceLabel = [UILabel new];
    priceLabel.textColor = [UIColor grayColor];
    priceLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:10.0];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.left.equalTo(imageBackgroundView.mas_left);
    }];
    self.priceLabel = priceLabel;
}

- (void)configCellWithWelfareGoodsListViewModel:(WelfareDataItem *)model {
    
    [self.merchPicImageView sd_setImageWithURL:[NSURL URLWithString:model.mainUrl] placeholderImage:kDefaultPlaceHolderImg];
    self.titleLabel.text = model.goodsName;
    NSString *point = @(model.perPrice).stringValue;
    self.priceLabel.text = [NSString stringWithFormat:@"%@积分", point];
}


@end
