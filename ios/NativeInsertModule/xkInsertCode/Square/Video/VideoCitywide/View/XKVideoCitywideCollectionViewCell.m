//
//  XKVideoCitywideCollectionViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoCitywideCollectionViewCell.h"

#import "XKVideoDisplayModel.h"

@interface XKVideoCitywideCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeCountLabel;

@end

@implementation XKVideoCitywideCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 图片主视图
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.xk_openClip = YES;
        imageView.xk_radius = 5;
        imageView.xk_clipType = XKCornerClipTypeAllCorners;
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kVideoCitywideCollectionViewCellAppendHeight);
            make.right.equalTo(self.contentView.mas_right);
            
        }];
        self.imageView = imageView;
        
        // 头像
        UIImageView *headImageView = [UIImageView new];
        headImageView.image = [UIImage imageNamed:@"xk_ic_defult_head"];
        headImageView.layer.borderWidth = 2;
        headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        headImageView.layer.cornerRadius = 15;
        headImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:headImageView];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(-8);
            make.left.equalTo(imageView.mas_left).offset(6);
            make.width.height.equalTo(@(30));
        }];
        self.headImageView = headImageView;
        
        // 名称
        UILabel *nameLabel = [UILabel new];
        nameLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headImageView.mas_bottom);
            make.left.equalTo(headImageView.mas_right).offset(4);
            make.right.equalTo(self.contentView.mas_right);
        }];
        self.nameLabel = nameLabel;
        
        // 描述
        UILabel *describeLabel = [UILabel new];
        describeLabel.textColor = [UIColor darkGrayColor];
        describeLabel.numberOfLines = 3;
        describeLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:12.0];
        [self.contentView addSubview:describeLabel];
        [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(4);
            make.left.equalTo(headImageView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
        }];
        self.describeLabel = describeLabel;
        
        // 定位
        UIImageView *locationImageView = [UIImageView new];
        locationImageView.image = [UIImage imageNamed:@"xk_btn_welfare_location"];
        [self.contentView addSubview:locationImageView];
        [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(describeLabel.mas_bottom).offset(4);
            make.left.equalTo(describeLabel.mas_left);
            make.width.equalTo(@(9));
            make.height.equalTo(@(11));
        }];
        UILabel *locationLabel = [UILabel new];
        locationLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:10.0];
        locationLabel.textColor = [UIColor lightGrayColor];
        locationLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:locationLabel];
        [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(locationImageView.mas_right).offset(5);
            make.centerY.equalTo(locationImageView.mas_centerY);
        }];
        self.locationLabel = locationLabel;
        
        // 喜欢
        UILabel *likeCountLabel = [UILabel new];
        likeCountLabel.textAlignment = NSTextAlignmentRight;
        likeCountLabel.textColor = [UIColor lightGrayColor];
        likeCountLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:10.0];
        [self.contentView addSubview:likeCountLabel];
        [likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            make.centerY.equalTo(locationImageView.mas_centerY);
        }];
        self.likeCountLabel = likeCountLabel;
        UIImageView *likeImageView = [UIImageView new];
        likeImageView.image = [UIImage imageNamed:@"xk_btn_home_star_normal"];
        [self.contentView addSubview:likeImageView];
        [likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(likeCountLabel.mas_left).offset(-5);
            make.centerY.equalTo(likeCountLabel.mas_centerY);
            make.width.offset(11);
            make.height.offset(9);
        }];
        self.likeImageView = likeImageView;
    }
    return self;
}

- (void)configCellWithVideo:(XKVideoDisplayVideoListItemModel *)video {
    
    // 主视图
    if (video.video.first_cover && video.video.first_cover.length) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:video.video.first_cover] placeholderImage:kDefaultPlaceHolderRectImg];
    } else if (video.video.zdy_cover && video.video.zdy_cover.length) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:video.video.zdy_cover] placeholderImage:kDefaultPlaceHolderRectImg];
    } else {
        self.imageView.image = kDefaultPlaceHolderRectImg;
    }
    
    // 用户头像
    if (video.user.user_img && video.user.user_img.length) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:video.user.user_img] placeholderImage:kDefaultHeadImg];
    } else {
        self.headImageView.image = kDefaultHeadImg;
    }
    
    // 用户名
    if (video.user.user_name && video.user.user_name.length) {
        self.nameLabel.text = video.user.user_name;
    } else {
        self.nameLabel.text = @"";
    }
    
    // 视频描述
    if (video.video.describe && video.video.describe.length) {
        self.describeLabel.text = video.video.describe;
    } else {
        self.describeLabel.text = @"";
    }
//    self.describeLabel.text = @"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    
    // 定位
    CGFloat distance = [[XKBaiduLocation shareManager] getDistanceFromCurrentLocationWithLatitude:[video.adds.location.lat doubleValue] longitude:[video.adds.location.lat doubleValue]];
    if (distance < 0.0) {
        self.locationLabel.text = @"未知";
    } else if (distance < 1000.0) {
        self.locationLabel.text = [NSString stringWithFormat:@"%tum", (NSUInteger)distance];
    } else if (distance < 20000.0) {
        CGFloat tempDistance = distance / 1000;
        self.locationLabel.text = [NSString stringWithFormat:@"%tukm", (NSUInteger)tempDistance];
    } else {
        self.locationLabel.text = @">20km";
    }
    
    // 点赞图片
    BOOL isHighlighted = video.video.is_praise;
    if (isHighlighted) {
        self.likeImageView.image = [UIImage imageNamed:@"xk_btn_home_star_heighlight"];
    } else {
        self.likeImageView.image = [UIImage imageNamed:@"xk_btn_home_star_normal"];
    }
    
    // 点赞数
    if (video.video.praise_num >= 0) {
        self.likeCountLabel.text = [NSString stringWithFormat:@"%ld", video.video.praise_num];
    } else {
        self.likeCountLabel.text = @"";
    }
}

- (UIImageView *)getCellMainImageView {
    return self.imageView;
}

@end
