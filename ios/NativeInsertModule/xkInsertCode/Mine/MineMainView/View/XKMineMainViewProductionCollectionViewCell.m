//
//  XKMineMainViewProductionCollectionViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineMainViewProductionCollectionViewCell.h"
#import "XKVideoDisplayModel.h"

@interface XKMineMainViewProductionCollectionViewCell ()

@property (nonatomic, strong) XKVideoDisplayVideoListItemModel *videoListItem;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *shareCountLabel;
@property (nonatomic, strong) UILabel *commentCountLabel;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) NSMutableArray<UIView *> *countViewArr;

@end

@implementation XKMineMainViewProductionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    
    UIControl *control = [UIControl new];
    [control addTarget:self action:@selector(clickCollectionViewCell:) forControlEvents:UIControlEventTouchUpInside];
    control.backgroundColor = [UIColor whiteColor];
    control.frame = self.contentView.frame;
    [self.contentView addSubview:control];
    
    // 图片
    UIImageView *imageView = [UIImageView new];
    imageView.xk_openClip = YES;
    imageView.xk_radius = 5;
    imageView.xk_clipType = XKCornerClipTypeAllCorners;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.backgroundColor = HEX_RGB(0xF6F6F6);
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@(110 * ScreenScale));
    }];
    self.imageView = imageView;
    
    // 描述
    UILabel *describeLabel = [UILabel new];
    describeLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:11.0];
    describeLabel.textAlignment = NSTextAlignmentLeft;
    describeLabel.numberOfLines = 2;
    [self.contentView addSubview:describeLabel];
    [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(3);
        make.left.equalTo(imageView.mas_left);
        make.right.equalTo(imageView.mas_right);
    }];
    self.describeLabel = describeLabel;
    
    // 分享、留言、喜欢
    for (NSInteger index = 0; index < 3; index++) {
        UIView *countView = [UIView new];
        [self.contentView addSubview:countView];
        UIImageView *imageView = [UIImageView new];
        [countView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(countView.mas_left);
            make.centerY.equalTo(countView.mas_centerY);
            make.width.height.equalTo(@10);
        }];
        UILabel *countLabel = [UILabel new];
        countLabel.textAlignment = NSTextAlignmentLeft;
        countLabel.textColor = [UIColor lightGrayColor];
        countLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:11.0];
        switch (index) {
            case 0:
                imageView.image = [UIImage imageNamed:@"xk_btn_home_share"];
                self.shareCountLabel = countLabel;
                break;
            case 1:
                imageView.image = [UIImage imageNamed:@"xk_btn_home_comment"];
                self.commentCountLabel = countLabel;
                break;
            case 2:
                imageView.image = [UIImage imageNamed:@"xk_btn_home_star_normal"];
                self.likeCountLabel = countLabel;
                break;
            default:
                break;
        }
        [countView addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(2);
            make.centerY.equalTo(countView.mas_centerY);
        }];

        [self.countViewArr addObject:countView];
    }
    
    // 水平排列
    [self.countViewArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:0 tailSpacing:0];
    [self.countViewArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(describeLabel.mas_bottom).offset(8);
    }];
}
 
- (void)configCellWithVideoListItem:(XKVideoDisplayVideoListItemModel *)videoListItem {
    
    self.videoListItem = videoListItem;
    
    // 图片视图
    if (videoListItem.video.first_cover && videoListItem.video.first_cover.length) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:videoListItem.video.first_cover] placeholderImage:kDefaultPlaceHolderRectImg];
    } else if (videoListItem.video.zdy_cover && videoListItem.video.zdy_cover.length) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:videoListItem.video.zdy_cover] placeholderImage:kDefaultPlaceHolderRectImg];
    } else {
        self.imageView.image = kDefaultPlaceHolderRectImg;
    }
    
    // 视频描述
    if (videoListItem.video.describe && videoListItem.video.describe.length) {
        self.describeLabel.text = videoListItem.video.describe;
    } else {
        self.describeLabel.text = @"";
    }

    // 分享数
    self.shareCountLabel.text = [NSString stringWithFormat:@"%ld", videoListItem.video.share_num];
    
    // 留言数
    self.commentCountLabel.text = [NSString stringWithFormat:@"%ld", videoListItem.video.com_num];
    
    // 点赞数
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld", videoListItem.video.praise_num];
}

- (void)clickCollectionViewCell:(UIControl *)sender {
    [self.delegate productionCollectionViewCell:self clickProductionWithModel:self.videoListItem];
}

- (NSMutableArray *)countViewArr {
    
    if (!_countViewArr) {
        _countViewArr = @[].mutableCopy;
    }
    return _countViewArr;
}

@end
