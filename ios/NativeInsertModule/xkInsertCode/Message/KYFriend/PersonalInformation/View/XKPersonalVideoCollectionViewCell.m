//
//  XKPersonalVideoCollectionViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPersonalVideoCollectionViewCell.h"
@interface XKPersonalVideoCollectionViewCell()

/**❤️*/
@property(nonatomic, strong) UIImageView *heartImageView;
/**点赞数*/
@property(nonatomic, strong) UILabel *heartCountLabel;
/**图片*/
@property(nonatomic, strong) UIImageView *imageView;
@end

@implementation XKPersonalVideoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)setModel:(XKVideoDisplayVideoListItemModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.video.first_cover] placeholderImage:[UIImage imageNamed:@""]];
    self.heartCountLabel.text = [NSString stringWithFormat:@"%ld",model.video.praise_num];
}
- (void)creatUI {
    self.imageView = [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    self.heartImageView = [[UIImageView alloc]init];
    self.heartImageView.image = [UIImage imageNamed:@"ic_btn_msg_circle_noLike"];
    self.heartImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.heartImageView];
    [self.heartImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    self.heartCountLabel = [[UILabel alloc]init];
    self.heartCountLabel.text = @"45.9W";
    self.heartCountLabel.textColor = [UIColor whiteColor];
    self.heartCountLabel.font = XKFont(XK_PingFangSC_Regular, 10);
    [self.contentView addSubview:self.heartCountLabel];
    [self.heartCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heartImageView.mas_right).offset(10);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.heartImageView.mas_top);
        make.bottom.equalTo(self.heartImageView.mas_bottom);
    }];
}




@end
