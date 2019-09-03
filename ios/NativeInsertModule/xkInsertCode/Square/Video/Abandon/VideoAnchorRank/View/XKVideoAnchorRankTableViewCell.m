//
//  XKVideoAnchorRankTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoAnchorRankTableViewCell.h"

@interface XKVideoAnchorRankTableViewCell()

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *medalImageView;

@end

@implementation XKVideoAnchorRankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.contentView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self initializeViews];
    return self;
}

- (void)initializeViews {
    
    // 主视图
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    self.mainView = mainView;

    // 奖牌视图
    UIImageView *medalImageView = [UIImageView new];
    medalImageView.xk_openClip = YES;
    medalImageView.xk_radius = 12;
    medalImageView.xk_clipType = XKCornerClipTypeAllCorners;
    [mainView addSubview:medalImageView];
    [medalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView.mas_left).offset(13);
        make.centerY.equalTo(mainView.mas_centerY);
        make.width.height.equalTo(@(24));
    }];
    self.medalImageView = medalImageView;
    
    // 头像
    UIImageView *headImageView = [UIImageView new];
    headImageView.xk_openClip = YES;
    headImageView.xk_radius = 17;
    headImageView.xk_clipType = XKCornerClipTypeAllCorners;
    [mainView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(medalImageView.mas_right).offset(7);
        make.centerY.equalTo(mainView.mas_centerY);
        make.width.height.equalTo(@(34));
    }];
    
    // 主播名字
    UILabel *nameLabel = [UILabel new];
    nameLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:14.0];
    [mainView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_top);
        make.left.equalTo(headImageView.mas_right).offset(4);
    }];
    
    // 得到钻石
    UILabel *diamondDescribeLabel = [UILabel new];
    diamondDescribeLabel.text = @"总得到：";
    diamondDescribeLabel.textColor = [UIColor lightGrayColor];
    diamondDescribeLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:11.0];
    [mainView addSubview:diamondDescribeLabel];
    [diamondDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(3);
        make.left.equalTo(nameLabel.mas_left);
    }];
    UILabel *diamondLabel = [UILabel new];
    diamondLabel.textColor = RGB(242, 160, 161);
    diamondLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:11.0];
    [mainView addSubview:diamondLabel];
    [diamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(diamondDescribeLabel.mas_top);
        make.left.equalTo(diamondDescribeLabel.mas_right);
    }];
    
    // 关注按钮
    UIButton *attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionButton.layer.borderWidth = 1;
    attentionButton.layer.borderColor = XKMainTypeColor.CGColor;
    attentionButton.layer.cornerRadius = 10;
    attentionButton.layer.masksToBounds = YES;
    [attentionButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    [attentionButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
    attentionButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:12.0];
    [mainView addSubview:attentionButton];
    [attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(mainView.mas_right).offset(-15);
        make.centerY.equalTo(mainView.mas_centerY);
        make.width.equalTo(@(60));
        make.height.equalTo(@(20));
    }];
}

- (void)showTopCornerRadius {
    
    self.mainView.xk_openClip = YES;
    self.mainView.xk_radius = 8;
    self.mainView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
}

- (void)showBottomCornerRadius {
    
    self.mainView.xk_openClip = YES;
    self.mainView.xk_radius = 8;
    self.mainView.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
    
}

- (void)hiddenCornerRadius {
    
    self.mainView.xk_openClip = NO;
}

- (void)showSecondMedalImageView {
    self.medalImageView.image = [UIImage imageNamed:@"xk_ic_video_second"];
}

- (void)showThirdMedalImageView {
    self.medalImageView.image = [UIImage imageNamed:@"xk_ic_video_third"];
}

- (void)hiddenMedalImageView {
    self.medalImageView.image = [UIImage imageNamed:@""];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
